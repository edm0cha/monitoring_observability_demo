export PKG_DIR="python"

rm -rf ${PKG_DIR} && mkdir -p ${PKG_DIR}

docker run --rm -v $(pwd):/foo -w /foo lambci/lambda:build-python3.12 \
    pip install -r requirements-langchain.txt --no-deps -t ${PKG_DIR}