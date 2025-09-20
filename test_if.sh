extern printd(x);
extern printI32(x);
extern putchard(x);

def binary : 1 (x y) y;
def testBegin(i)
    putchard('t') : putchard('e') : putchard('s') : putchard('t') : 
    putchard('0'+i) : putchard(':') : putchard('\n')

def f(x)
    (
    if (x < 10) putchard('-')
    else (if (x < 100) putchard('+') else putchard('*'))
    ) 
    : putchard('\n');

testBegin(1);
f(1);
f(3.14);
f(5);
testBegin(2);
f(10);
f(42);
f(99);
testBegin(3);
f(100);
f(1024);
f(2147483647);