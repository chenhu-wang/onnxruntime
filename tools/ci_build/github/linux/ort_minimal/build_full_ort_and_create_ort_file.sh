#!/bin/bash
set -e -o -x

EXIT_CODE=1

# run a full build of ORT
/opt/python/cp37-cp37m/bin/python3 /onnxruntime_src/tools/ci_build/build.py \
    --build_dir /build --cmake_generator Ninja \
    --config Debug \
    --skip_submodule_sync \
    --parallel \
    --build_wheel \
    --skip_tests \
    --enable_pybind \
    --cmake_extra_defines PYTHON_INCLUDE_DIR=/opt/python/cp37-cp37m/include/python3.7m PYTHON_LIBRARY=/usr/lib64/librt.so

# install the ORT python wheel
/opt/python/cp37-cp37m/bin/python3  -m pip install -U /build/Debug/dist/*

# copy the test data to a separated folder
mkdir -p /home/onnxruntimedev/.test_data
cp -Rf $(Build.SourcesDirectory)/onnxruntime/test/testdata/ort_minimal_e2e_test_data /home/onnxruntimedev/.test_data

# convert the onnx models the $HOME/.test_data to ort model
find /home/onnxruntimedev/.test_data -type f -name "*.onnx"  -exec /opt/python/cp37-cp37m/bin/python3 \
    /onnxruntime_src/tools/python/convert_onnx_model_to_ort.py {} \;

EXIT_CODE=$?

set -e
exit $EXIT_CODE
