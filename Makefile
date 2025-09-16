.PHONY: all run config build build_lib build_main src format clean rebuild reconfig

all: run

run: build_main
	./build/src/kaleidoscope_main

VCPKG_FILE := ${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake  

BUILD_TYPE=Debug
# BUILD_TYPE=RelWithDebInfo
config:
	cmake -B build -S . -DCMAKE_CXX_CLANG_TIDY=clang-tidy -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_TOOLCHAIN_FILE=${VCPKG_FILE}

BUILD_TARGET ?= lib 
build:
	cmake --build build --target kaleidoscope_${BUILD_TARGET}

build_lib:
	cmake --build build --target kaleidoscope_lib

build_main: build_lib
	cmake --build build --target kaleidoscope_main

format:
	cmake --build build --target format

clean:
	rm -rf build

rebuild: clean config build

reconfig: clean config