extern printd(x);
extern putchard(x);
extern printI32(x);

def binary : 1 (x y) y;

def repeat(c n)
    for ( i = 0; i < 10; 1) putchard(c);

def prefix(i)
    repeat('-', 20) : putchard('\n') :
    putchard('t') : putchard('e') : putchard('s') : putchard('t') : 
    putchard('0'+i) : putchard(':') : putchard('\n')

def test1(x)
    printI32(x) : putchard('\n') :
    x = 42 :
    printI32(x) : putchard('\n');

def test2(x y)
    printI32(x) : putchard('\n') :
    printI32(y) : putchard('\n') :
    x = y :
    printI32(x) : putchard('\n') :
    printI32(y) : putchard('\n');

prefix(1) : test1(123);
prefix(2) : test1(2);
prefix(3) : test2(3, 1024);
prefix(4) : (var y = 4) : test2(123, y);
prefix(5) : (var x = 5) : test2(x, 42);
prefix(6) : (var x = 6) : test2(x, 10*x);
prefix(7) : (var x = 7) : (var y = 42) : test2(x, y);