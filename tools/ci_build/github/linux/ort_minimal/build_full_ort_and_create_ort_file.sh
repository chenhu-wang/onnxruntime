#!/bin/bash
set -e -o -x

/opt/python/cp37-cp37m/bin/python3 /onnxruntime_src/tools/ci_build/build.py \
    --build_dir /build --cmake_generator Ninja \
    --config Debug \
    --skip_submodule_sync \
    --parallel \
    --build_wheel \
    --skip_tests \
    --enable_pybind \
    --cmake_extra_defines PYTHON_INCLUDE_DIR=/opt/python/cp37-cp37m/include/python3.7m PYTHON_LIBRARY=/usr/lib64/librt.so

/opt/python/cp37-cp37m/bin/python3  -m pip install -U /build/Debug/dist/*

EXIT_CODE=$?

set -e
exit $EXIT_CODE
