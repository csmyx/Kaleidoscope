declare double @printd(double)
declare double @putchard(double)
declare double @printI32(double)
define double @"binary:"(double %x, double %y) {
entry:
  %y2 = alloca double, align 8
  %x1 = alloca double, align 8
  store double %x, double* %x1, align 8
  store double %y, double* %y2, align 8
  %y3 = load double, double* %y2, align 8
  ret double %y3
}
define double @repeat(double %c, double %n) {
entry:
  %i = alloca double, align 8
  %n2 = alloca double, align 8
  %c1 = alloca double, align 8
  store double %c, double* %c1, align 8
  store double %n, double* %n2, align 8
  store double 0.000000e+00, double* %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry
  %i3 = load double, double* %i, align 8
  %lttmp = fcmp ult double %i3, 1.000000e+01
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %c4 = load double, double* %c1, align 8
  %calltmp = call double @putchard(double %c4)
  %i5 = load double, double* %i, align 8
  %nextvar = fadd double %i5, 1.000000e+00
  store double %nextvar, double* %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}
define double @prefix(double %i) {
entry:
  %i1 = alloca double, align 8
  store double %i, double* %i1, align 8
  %calltmp = call double @repeat(double 4.500000e+01, double 2.000000e+01)
  %calltmp2 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp, double %calltmp2)
  %calltmp3 = call double @putchard(double 1.160000e+02)
  %binop4 = call double @"binary:"(double %binop, double %calltmp3)
  %calltmp5 = call double @putchard(double 1.010000e+02)
  %binop6 = call double @"binary:"(double %binop4, double %calltmp5)
  %calltmp7 = call double @putchard(double 1.150000e+02)
  %binop8 = call double @"binary:"(double %binop6, double %calltmp7)
  %calltmp9 = call double @putchard(double 1.160000e+02)
  %binop10 = call double @"binary:"(double %binop8, double %calltmp9)
  %i11 = load double, double* %i1, align 8
  %addtmp = fadd double 4.800000e+01, %i11
  %calltmp12 = call double @putchard(double %addtmp)
  %binop13 = call double @"binary:"(double %binop10, double %calltmp12)
  %calltmp14 = call double @putchard(double 5.800000e+01)
  %binop15 = call double @"binary:"(double %binop13, double %calltmp14)
  %calltmp16 = call double @putchard(double 1.000000e+01)
  %binop17 = call double @"binary:"(double %binop15, double %calltmp16)
  ret double %binop17
}
define double @test1(double %x) {
entry:
  %x1 = alloca double, align 8
  store double %x, double* %x1, align 8
  %x2 = load double, double* %x1, align 8
  %calltmp = call double @printI32(double %x2)
  %calltmp3 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp, double %calltmp3)
  %x4 = load double, double* %x1, align 8
  store double 4.200000e+01, double* %x1, align 8
  %binop5 = call double @"binary:"(double %binop, double 4.200000e+01)
  %x6 = load double, double* %x1, align 8
  %calltmp7 = call double @printI32(double %x6)
  %binop8 = call double @"binary:"(double %binop5, double %calltmp7)
  %calltmp9 = call double @putchard(double 1.000000e+01)
  %binop10 = call double @"binary:"(double %binop8, double %calltmp9)
  ret double %binop10
}
define double @test2(double %x, double %y) {
entry:
  %y2 = alloca double, align 8
  %x1 = alloca double, align 8
  store double %x, double* %x1, align 8
  store double %y, double* %y2, align 8
  %x3 = load double, double* %x1, align 8
  %calltmp = call double @printI32(double %x3)
  %calltmp4 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp, double %calltmp4)
  %y5 = load double, double* %y2, align 8
  %calltmp6 = call double @printI32(double %y5)
  %binop7 = call double @"binary:"(double %binop, double %calltmp6)
  %calltmp8 = call double @putchard(double 1.000000e+01)
  %binop9 = call double @"binary:"(double %binop7, double %calltmp8)
  %x10 = load double, double* %x1, align 8
  %y11 = load double, double* %y2, align 8
  store double %y11, double* %x1, align 8
  %binop12 = call double @"binary:"(double %binop9, double %y11)
  %x13 = load double, double* %x1, align 8
  %calltmp14 = call double @printI32(double %x13)
  %binop15 = call double @"binary:"(double %binop12, double %calltmp14)
  %calltmp16 = call double @putchard(double 1.000000e+01)
  %binop17 = call double @"binary:"(double %binop15, double %calltmp16)
  %y18 = load double, double* %y2, align 8
  %calltmp19 = call double @printI32(double %y18)
  %binop20 = call double @"binary:"(double %binop17, double %calltmp19)
  %calltmp21 = call double @putchard(double 1.000000e+01)
  %binop22 = call double @"binary:"(double %binop20, double %calltmp21)
  ret double %binop22
}
define double @__anon_expr() {
entry:
  %calltmp = call double @prefix(double 1.000000e+00)
  %calltmp1 = call double @test1(double 1.230000e+02)
  %binop = call double @"binary:"(double %calltmp, double %calltmp1)
  ret double %binop
}
define double @__anon_expr() {
entry:
  %calltmp = call double @prefix(double 2.000000e+00)
  %calltmp1 = call double @test1(double 2.000000e+00)
  %binop = call double @"binary:"(double %calltmp, double %calltmp1)
  ret double %binop
}
define double @__anon_expr() {
entry:
  %calltmp = call double @prefix(double 3.000000e+00)
  %calltmp1 = call double @test2(double 3.000000e+00, double 1.024000e+03)
  %binop = call double @"binary:"(double %calltmp, double %calltmp1)
  ret double %binop
}
define double @__anon_expr() {
entry:
  %y = alloca double, align 8
  %calltmp = call double @prefix(double 4.000000e+00)
  store double 4.000000e+00, double* %y, align 8
  %binop = call double @"binary:"(double %calltmp, double 4.000000e+00)
  %y1 = load double, double* %y, align 8
  %calltmp2 = call double @test2(double 1.230000e+02, double %y1)
  %binop3 = call double @"binary:"(double %binop, double %calltmp2)
  ret double %binop3
}
define double @__anon_expr() {
entry:
  %x = alloca double, align 8
  %calltmp = call double @prefix(double 5.000000e+00)
  store double 5.000000e+00, double* %x, align 8
  %binop = call double @"binary:"(double %calltmp, double 5.000000e+00)
  %x1 = load double, double* %x, align 8
  %calltmp2 = call double @test2(double %x1, double 4.200000e+01)
  %binop3 = call double @"binary:"(double %binop, double %calltmp2)
  ret double %binop3
}
define double @__anon_expr() {
entry:
  %x = alloca double, align 8
  %calltmp = call double @prefix(double 6.000000e+00)
  store double 6.000000e+00, double* %x, align 8
  %binop = call double @"binary:"(double %calltmp, double 6.000000e+00)
  %x1 = load double, double* %x, align 8
  %x2 = load double, double* %x, align 8
  %multmp = fmul double 1.000000e+01, %x2
  %calltmp3 = call double @test2(double %x1, double %multmp)
  %binop4 = call double @"binary:"(double %binop, double %calltmp3)
  ret double %binop4
}
define double @__anon_expr() {
entry:
  %y = alloca double, align 8
  %x = alloca double, align 8
  %calltmp = call double @prefix(double 7.000000e+00)
  store double 7.000000e+00, double* %x, align 8
  %binop = call double @"binary:"(double %calltmp, double 7.000000e+00)
  store double 4.200000e+01, double* %y, align 8
  %binop1 = call double @"binary:"(double %binop, double 4.200000e+01)
  %x2 = load double, double* %x, align 8
  %y3 = load double, double* %y, align 8
  %calltmp4 = call double @test2(double %x2, double %y3)
  %binop5 = call double @"binary:"(double %binop1, double %calltmp4)
  ret double %binop5
}
Total token count: 301
; ModuleID = 'my cool jit'
source_filename = "my cool jit"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
