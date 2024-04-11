export PKG_DIR="requirements"

rm -rf layers/${PKG_DIR} && mkdir -p layers/${PKG_DIR}

docker run --rm -v $(pwd):/foo -w /foo python:3.12 \
    pip install -r requirements.txt -t layers/${PKG_DIR}/python/lib/python3.12/site-packages