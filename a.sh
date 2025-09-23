# 最后用 sort | uniq -c 替代，会输出“次数 字符串”的格式
for str in $(llvm-config --components); do llvm-config --libs "$str"; done | tr ' ' '\n' | sort | uniq -c | wc -l
llvm-config --libs "all" | tr ' ' '\n' | sort | uniq -c | wc -l
llvm-config --libs "core" | tr ' ' '\n' | sort | uniq -c | wc -l