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
