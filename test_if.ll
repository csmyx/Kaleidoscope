declare double @printd(double)
declare double @printI32(double)
declare double @putchard(double)
define double @"binary:"(double %x, double %y) {
entry:
  %y2 = alloca double, align 8
  %x1 = alloca double, align 8
  store double %x, double* %x1, align 8
  store double %y, double* %y2, align 8
  %y3 = load double, double* %y2, align 8
  ret double %y3
}
define double @testBegin(double %i) {
entry:
  %i1 = alloca double, align 8
  store double %i, double* %i1, align 8
  %calltmp = call double @putchard(double 1.160000e+02)
  %calltmp2 = call double @putchard(double 1.010000e+02)
  %binop = call double @"binary:"(double %calltmp, double %calltmp2)
  %calltmp3 = call double @putchard(double 1.150000e+02)
  %binop4 = call double @"binary:"(double %binop, double %calltmp3)
  %calltmp5 = call double @putchard(double 1.160000e+02)
  %binop6 = call double @"binary:"(double %binop4, double %calltmp5)
  %i7 = load double, double* %i1, align 8
  %addtmp = fadd double 4.800000e+01, %i7
  %calltmp8 = call double @putchard(double %addtmp)
  %binop9 = call double @"binary:"(double %binop6, double %calltmp8)
  %calltmp10 = call double @putchard(double 5.800000e+01)
  %binop11 = call double @"binary:"(double %binop9, double %calltmp10)
  %calltmp12 = call double @putchard(double 1.000000e+01)
  %binop13 = call double @"binary:"(double %binop11, double %calltmp12)
  ret double %binop13
}
define double @f(double %x) {
entry:
  %x1 = alloca double, align 8
  store double %x, double* %x1, align 8
  %x2 = load double, double* %x1, align 8
  %lttmp = fcmp ult double %x2, 1.000000e+01
  %booltmp = uitofp i1 %lttmp to double
  %if.cond = fcmp one double %booltmp, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %calltmp = call double @putchard(double 4.500000e+01)
  br label %if.cont11

if.else:                                          ; preds = %entry
  %x3 = load double, double* %x1, align 8
  %lttmp4 = fcmp ult double %x3, 1.000000e+02
  %booltmp5 = uitofp i1 %lttmp4 to double
  %if.cond6 = fcmp one double %booltmp5, 0.000000e+00
  br i1 %if.cond6, label %if.then7, label %if.else9

if.then7:                                         ; preds = %if.else
  %calltmp8 = call double @putchard(double 4.300000e+01)
  br label %if.cont

if.else9:                                         ; preds = %if.else
  %calltmp10 = call double @putchard(double 4.200000e+01)
  br label %if.cont

if.cont:                                          ; preds = %if.else9, %if.then7
  %iftmp = phi double [ %calltmp8, %if.then7 ], [ %calltmp10, %if.else9 ]
  br label %if.cont11

if.cont11:                                        ; preds = %if.cont, %if.then
  %iftmp12 = phi double [ %calltmp, %if.then ], [ %iftmp, %if.cont ]
  %calltmp13 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %iftmp12, double %calltmp13)
  ret double %binop
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 1.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 3.140000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 5.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 2.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 1.000000e+01)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 4.200000e+01)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 9.900000e+01)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 3.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 1.000000e+02)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 1.024000e+03)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %calltmp = call double @f(double 0x41DFFFFFFFC00000)
  ret double %calltmp
}
Total token count: 171
; ModuleID = 'my cool jit'
source_filename = "my cool jit"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
