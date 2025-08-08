.PHONY: build src

all: build run

run:
	./build/src/main

vcpkg_file := ${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake  
config:
	cmake -B build -S . -DCMAKE_CXX_CLANG_TIDY=clang-tidy -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=${vcpkg_file}

build:
	cmake --build build --target main

format:
	cmake --build build --target format

clean:
	rm -rf build

rebuild: clean config build