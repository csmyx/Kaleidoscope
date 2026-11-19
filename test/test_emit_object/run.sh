#!/bin/bash

set -x

cmake --build build --target emit_object

pushd build/test/test_emit_object

echo "pwd: ${PWD}"

./emit_object ../../../test/test_emit_object/test_emit_object.kaleidoscope

clang++ ../../../test/test_emit_object/test_emit_object.cpp output.o -o test_emit_object 

./test_emit_object

popd
