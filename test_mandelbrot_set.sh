extern printd(x);
extern putchard(x);

# Logical unary not.
def unary!(v)
  if (v) 0 else 1;

# Unary negate.
def unary-(v)
  0-v;

# Define > with the same precedence as <.
def binary> 10 (LHS RHS)
  RHS < LHS;

# Binary logical or, which does not short circuit.
def binary| 5 (LHS RHS)
  if (LHS) 1 else if (RHS) 1 else 0;

# Binary logical and, which does not short circuit.
def binary& 6 (LHS RHS)
  if (!LHS) 0 else !!RHS;

# Define = with slightly lower precedence than relationals.
def binary = 9 (LHS RHS)
  !(LHS < RHS | LHS > RHS);

# Define ':' for sequencing: as a low-precedence operator that ignores operands
# and just returns the RHS.
def binary : 1 (x y) y;


 def printdensity(d)
  if (d > 8)
    putchard(32)  # ' '
  else if (d > 4)
    putchard(46)  # '.'
  else if (d > 2)
    putchard(43)  # '+'
  else
    putchard(42); # '*'

printdensity(1): printdensity(2): printdensity(3):
printdensity(4): printdensity(5): printdensity(9):
putchard(10);

# Determine whether the specific location diverges.
# Solve for z = z^2 + c in the complex plane.
def mandelconverger(real imag iters creal cimag)
  if (iters > 255 | (real*real + imag*imag > 4))
    iters
  else
    mandelconverger(real*real - imag*imag + creal,
                    2*real*imag + cimag,
                    iters+1, creal, cimag);

# Return the number of iterations required for the iteration to escape
def mandelconverge(real imag)
  mandelconverger(real, imag, 0, real, imag);

# Compute and plot the mandelbrot set with the specified 2 dimensional range
# info.
def mandelhelp(xmin xmax xstep   ymin ymax ystep)
  for (y = ymin; y < ymax; ystep) (
    (
        for (x = xmin; x < xmax; xstep)
            printdensity(mandelconverge(x,y))
    )
    : putchard(10)
  )

# mandel - This is a convenient helper function for plotting the mandelbrot set
# from the specified position with the specified Magnification.
def mandel(realstart imagstart realmag imagmag)
  mandelhelp(realstart, realstart+realmag*78, realmag,
             imagstart, imagstart+imagmag*40, imagmag);

mandel(-2.3, -1.3, 0.05, 0.07);
mandel(-2, -1, 0.02, 0.04);
mandel(-0.9, -1.4, 0.02, 0.03);