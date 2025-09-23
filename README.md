# Kaleidoscope
A simple compiler

### chapter 4

TODO: 设置安装规则和公共头文件目录
```
# 安装规则
install(TARGETS libC
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
)

# 公共头文件目录（如果有）
target_include_directories(libC PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)
```

使用接口库（推荐）
```
# 在libC中创建接口目标
add_library(libCInterface INTERFACE)
target_link_libraries(libCInterface INTERFACE libC)
target_include_directories(libCInterface INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
)

# 在libB中
target_link_libraries(libB PUBLIC libCInterface)

# 在app中
target_link_libraries(A PRIVATE libB libCInterface)
```

查看动态符号：`readelf --dyn-syms libxxx.so`

Linux里GLOBAL符号外部可见性默认DEFAULT是：外部可见，如果需要隐藏符号，即修改为外部不可见的话，需要显式标记为
`__attribute__((visibility("hidden"))) `。

Windows里GLOBAL符号外部可见性默认是：外部不可见。

### chapter 7
TODO: 
- 异常处理只是打印warning info或者直接exit，待规范异常处理
- unary binary 重载需要添加特殊符号判定，比如 `(`, `)`, `'` 等符号不能被重载
- firendly error msg (print values rather then a singal const string)

- 由于当前函数体支持一条语句, 为了测试var声明语句正确性,只能将其视作返回其初始化值的表达式, 不然无法运行下面的测试实例
`prefix(3) : var y = 4 : test2(123, y);`
待修改为正确实现: 将 var 语句作为顶层的独立语句来解析 即和函数定义的def一样, 它不应该存在返回值,即codegen应该返回nullptr.


- 动态链接问题

mylib 依赖clang标准库libc++.so, 同时依赖libLLVM.so。而libLLVM.so依赖gcc标准库libstdc++.so。
这样在动态链接的时候就会出问题
`ld.lld: error: undefined reference: llvm::orc::ExecutionSession::createBareJITDylib(std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>)`

```
❯ llvm-readelf --dyn-syms ./libLLVM.so | grep createBareJITDylib
 43658: 00000000027e87e0   320 FUNC    GLOBAL DEFAULT    12 _ZN4llvm3orc16ExecutionSession18createBareJITDylibENSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE@@LLVM_14
❯ llvm-readelf --dyn-syms ./libLLVM.so | grep createBareJITDylib | awk '{print $NF}' | c++filt
llvm::orc::ExecutionSession::createBareJITDylib(std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >)@@LLVM_14
```
标准库mangling的规则不一样，比如说std命名空间mangling后clang是`std::__1`，gcc是`std::__cxx11`，所以报错找不到符号。
除了符号名不同，更重要的是内存布局也不一致，即同一个标准库对象比如vector可能其成员布局完全不一样，即使用`llvm-cxxmap`之类工具解决名称修饰问题也会存在UB。参照https://www.cnblogs.com/adinosaur/p/11161081.html
总结：
符号不一致的本质是 C++ 标准库的 ABI 不兼容（名称修饰 + 内存布局差异）。解决方法只有一个：让你的库和 LLVM 动态库使用完全相同的 C++ 标准库（libc++ 或 libstdc++）。