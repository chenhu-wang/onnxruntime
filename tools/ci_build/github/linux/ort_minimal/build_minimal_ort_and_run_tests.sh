#!/bin/bash
set -e -o -x

EXIT_CODE=1

# We need copy the related test files to a separated folder since the --include_ops_by_model will search the testdata folder recursively
# and include many unnecessary ops, minimal build UT currently uses .ort format models converted from the models we copied below,
# which will be used as the input of --include_ops_by_model to have ops to be included for the minimal build UT.
mkdir -p /home/onnxruntimedev/.test_data/model_to_exclude
cp /onnxruntime_src/onnxruntime/test/testdata/ort_github_issue_4031.onnx /home/onnxruntimedev/.models_to_exclude

# build a minimal build with included ops and models
/opt/python/cp37-cp37m/bin/python3 /onnxruntime_src/tools/ci_build/build.py \
    --build_dir /build --cmake_generator Ninja \
    --config Debug \
    --skip_submodule_sync \
    --build_shared_lib \
    --parallel \
    --minimal_build \
    --disable_ml_ops \
    --disable_exceptions \
    --include_ops_by_model /home/onnxruntimedev/.models_to_exclude/ \
    --include_ops_by_config /home/onnxruntimedev/.test_data/exclude_unused_ops_config.txt

# run some test
/build/Debug/onnx_test_runner /home/onnxruntimedev/.test_data

EXIT_CODE=$?

set -e
exit $EXIT_CODE
