.PHONY: all run config build build_lib build_main src format clean rebuild reconfig

all: run

run: build_main
	./build/src/kaleidoscope_main

VCPKG_FILE := ${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake  

BUILD_TYPE=Debug
# BUILD_TYPE=RelWithDebInfo
config:
	cmake -B build -S . \
	-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
	-DCMAKE_TOOLCHAIN_FILE=${VCPKG_FILE}


BUILD_TARGET ?= lib 
build:
	cmake --build build --target kaleidoscope_${BUILD_TARGET}

build_lib:
	cmake --build build --target kaleidoscope_lib


build_main: build_lib
	cmake --build build --target kaleidoscope_main

# build_lib_verbose:
# 	cd build/ && make kaleidoscope_lib VERBOSE=1
# build_main_verbose:  build_lib
# 	cd build/ && make kaleidoscope_main VERBOSE=1

format:
	cmake --build build --target format

clean: clean_tests
	rm -rf build

rebuild: clean config build

reconfig: clean config

TEST_LIST = test_if test_for test_mandelbrot_set test_var_declar_assign
TEST_DIR = test/
# files of test:
# input file -> test_name.sh, 
# ll file -> test_name.ll, 
# output file -> test_name.txt
test_all: build_main
	@for test in $(TEST_LIST); do \
		echo "Running test: $$test"; \
		./build/src/kaleidoscope_main <"$(TEST_DIR)$$test.sh" 1>"$(TEST_DIR)$$test.txt" 2>"$(TEST_DIR)$$test.ll"; \
		if [ $$? -eq 0 ]; then \
			echo "Test $$test succeeded"; \
		else \
			echo "Test $$test failed"; \
			exit 1; \
		fi; \
	done

# 单个测试的目标模板，可单独运行某个测试，如 make test1
$(TEST_LIST): %: build_main
	./build/src/kaleidoscope_main <"$*.sh" 1>"$*.txt" 2>"$*.ll"

# 清理测试生成的文件
clean_tests:
# 	rm -f $(foreach test,$(TEST_LIST),$(TEST_DIR)/$(test).txt $(TEST_DIR)/$(test).ll)