#!/usr/bin/env sh

if [ "$(uname)" = "Darwin" ]; then
    # macOS might not support readlink -f
    HERE="$(cd "$(dirname "$0")" && pwd)"
else
    HERE="$(dirname "$(readlink -f "$0")")"
fi

cd "$HERE" || exit 1

docker build --tag tg/eva:dev -f Containerfile  .

if [ -f "${HERE}/.env" ]; then
    echo "Using .env file"
    . "${HERE}/.env"
fi

docker stop eva >/dev/null 2>&1 || true
docker rm eva >/dev/null 2>&1 || true

mkdir -p "${HERE}/documents" || exit 1
mkdir -p "${HERE}/chroma_db" || exit 1

docker run -d \
    --name eva \
    --restart unless-stopped \
    -p ${PORT:-8000}:8000 \
    -v "${HERE}/documents:/app/documents" \
    -v "${HERE}/chroma_db:/app/chroma_db" \
    -e "OPENAI_API_KEY=${OPENAI_API_KEY:-}" \
    -e "CHAT_API_KEY=${CHAT_API_KEY:-'very-secret'}" \
    -e "LLM_PROVIDER=${LLM_PROVIDER:-openai}" \
    -e "LLM_MAX_TOKENS=${LLM_MAX_TOKENS:-4096}" \
    -e "ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY:-}" \
    -e "MAX_HISTORY_MESSAGES=${MAX_HISTORY_MESSAGES:-50}" \
    -e "SUMMARY_THRESHOLD=${SUMMARY_THRESHOLD:-30}" \
    -e "RAG_DOCS_FOLDER=${RAG_DOCS_FOLDER:-documents}" \
    -e "CHROMA_LOCAL=${CHROMA_LOCAL:-true}" \
    -e "CHROMA_COLLECTION_NAME=${CHROMA_COLLECTION_NAME:-eva_rag}" \
    -e "CHROMA_HOST=${CHROMA_HOST:-localhost}" \
    -e "CHROMA_PORT=${CHROMA_PORT:-8888}" \
    -e "CHROMA_DB_DIR=${CHROMA_DB_DIR:-chroma_db}" \
    -e "HOST=${HOST:-0.0.0.0}" \
    -e "PORT=${PORT:-8000}" \
    -e "TRUSTED_ORIGINS=${TRUSTED_ORIGINS:-}" \
    -e "TRUSTED_ORIGIN_REGEX=${TRUSTED_ORIGIN_REGEX:-}" \
    -e "TRUSTED_HOSTS=${TRUSTED_HOSTS:-}" \
    -e "LOG_LevaL=${LOG_LevaL:-info}" \
    tg/eva:dev
