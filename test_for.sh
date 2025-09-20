extern printd(x);
extern printI32(x);
extern putchard(x);

def binary : 1 (x y) y;

def testBegin(i)
    putchard('t') : putchard('e') : putchard('s') : putchard('t') : 
    putchard('0'+i) : putchard(':') : putchard('\n')

testBegin(1);
for (i = 0; i < 5; ) printI32(i) : putchard('\n');

testBegin(2);
for (i = 0; i < 5; 2) printI32(i) : putchard('\n');

testBegin(3);
for (i = 0; i < 0; 2) printI32(i) : putchard('\n');

testBegin(4);
for (i = 0; i < 10; 1)
    (for (j = i; j < 10; 1) putchard('*')) : putchard('\n');

testBegin(5);
def circle(r)
    for (i = 0; i < 4*r; )
        (for (j = 0; j < 4*r; )
            if ((i-2*r)*(i-2*r)+(j-2*r)*(j-2*r) < r*r) putchard(' ')
            else putchard('*'))
        : putchard('\n') 
    ;
circle(10);

# for (i = 0; i < 1; ) printd(i);

# for ()
# for (i = 0; i < 10; ) 
#     for (j = i; j < )
# printd(i);
