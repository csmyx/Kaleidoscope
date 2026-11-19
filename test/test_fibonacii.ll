declare double @printd(double)
declare double @printI32(double)
declare double @putchard(double)
define double @"binary:"(double %x, double %y) {
entry:
  %y2 = alloca double, align 8
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  store double %y, ptr %y2, align 8
  %y3 = load double, ptr %y2, align 8
  ret double %y3
}
define double @testBegin(double %i) {
entry:
  %i1 = alloca double, align 8
  store double %i, ptr %i1, align 8
  %calltmp = call double @putchard(double 1.160000e+02)
  %calltmp2 = call double @putchard(double 1.010000e+02)
  %binop = call double @"binary:"(double %calltmp, double %calltmp2)
  %calltmp3 = call double @putchard(double 1.150000e+02)
  %binop4 = call double @"binary:"(double %binop, double %calltmp3)
  %calltmp5 = call double @putchard(double 1.160000e+02)
  %binop6 = call double @"binary:"(double %binop4, double %calltmp5)
  %i7 = load double, ptr %i1, align 8
  %addtmp = fadd double 4.800000e+01, %i7
  %calltmp8 = call double @putchard(double %addtmp)
  %binop9 = call double @"binary:"(double %binop6, double %calltmp8)
  %calltmp10 = call double @putchard(double 5.800000e+01)
  %binop11 = call double @"binary:"(double %binop9, double %calltmp10)
  %calltmp12 = call double @putchard(double 1.000000e+01)
  %binop13 = call double @"binary:"(double %binop11, double %calltmp12)
  ret double %binop13
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp
}
define double @fib(double %x) {
entry:
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  %x2 = load double, ptr %x1, align 8
  %lttmp = fcmp ult double %x2, 3.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %if.cond = fcmp one double %booltmp, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.cont

if.else:                                          ; preds = %entry
  %x3 = load double, ptr %x1, align 8
  %subtmp = fsub double %x3, 1.000000e+00
  %calltmp = call double @fib(double %subtmp)
  %x4 = load double, ptr %x1, align 8
  %subtmp5 = fsub double %x4, 2.000000e+00
  %calltmp6 = call double @fib(double %subtmp5)
  %addtmp = fadd double %calltmp, %calltmp6
  br label %if.cont

if.cont:                                          ; preds = %if.else, %if.then
  %iftmp = phi double [ 1.000000e+00, %if.then ], [ %addtmp, %if.else ]
  ret double %iftmp
}
define double @printFib(double %x) {
entry:
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  %calltmp = call double @putchard(double 7.000000e+01)
  %calltmp2 = call double @putchard(double 1.050000e+02)
  %binop = call double @"binary:"(double %calltmp, double %calltmp2)
  %calltmp3 = call double @putchard(double 9.800000e+01)
  %binop4 = call double @"binary:"(double %binop, double %calltmp3)
  %calltmp5 = call double @putchard(double 9.100000e+01)
  %binop6 = call double @"binary:"(double %binop4, double %calltmp5)
  %x7 = load double, ptr %x1, align 8
  %calltmp8 = call double @printI32(double %x7)
  %binop9 = call double @"binary:"(double %binop6, double %calltmp8)
  %calltmp10 = call double @putchard(double 9.300000e+01)
  %binop11 = call double @"binary:"(double %binop9, double %calltmp10)
  %calltmp12 = call double @putchard(double 5.800000e+01)
  %binop13 = call double @"binary:"(double %binop11, double %calltmp12)
  %calltmp14 = call double @putchard(double 3.200000e+01)
  %binop15 = call double @"binary:"(double %binop13, double %calltmp14)
  %x16 = load double, ptr %x1, align 8
  %calltmp17 = call double @fib(double %x16)
  %calltmp18 = call double @printI32(double %calltmp17)
  %binop19 = call double @"binary:"(double %binop15, double %calltmp18)
  ret double %binop19
}
define double @__anon_expr() {
entry:
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 1.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 1.000000e+01
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printFib(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}
