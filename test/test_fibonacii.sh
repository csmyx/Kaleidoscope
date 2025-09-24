extern printd(x);
extern printI32(x);
extern putchard(x);

def binary : 1 (x y) y;

def testBegin(i)
    putchard('t') : putchard('e') : putchard('s') : putchard('t') : 
    putchard('0'+i) : putchard(':') : putchard('\n')

testBegin(1);

# Recursive fib, we could do this before.
# and just returns the RHS.
def fib(x)
  if (x < 3) 1
  else fib(x-1)+fib(x-2);

def printFib(x)
    putchard('F') : putchard('i') : putchard('b') : putchard('[') : printI32(x) : putchard(']') :
    putchard(':') : putchard(' ') : printI32(fib(x));

for (i = 1; i < 10; )  printFib(i) : putchard('\n');
