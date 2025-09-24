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
define double @__anon_expr() {
entry:
  %i = alloca double, align 8
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry
  %i1 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i1, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i2 = load double, ptr %i, align 8
  %calltmp = call double @printI32(double %i2)
  %calltmp3 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp, double %calltmp3)
  %i4 = load double, ptr %i, align 8
  %nextvar = fadd double %i4, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 2.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %i = alloca double, align 8
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry
  %i1 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i1, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i2 = load double, ptr %i, align 8
  %calltmp = call double @printI32(double %i2)
  %calltmp3 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp, double %calltmp3)
  %i4 = load double, ptr %i, align 8
  %nextvar = fadd double %i4, 2.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 3.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %i = alloca double, align 8
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry
  %i1 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i1, 0.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i2 = load double, ptr %i, align 8
  %calltmp = call double @printI32(double %i2)
  %calltmp3 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp, double %calltmp3)
  %i4 = load double, ptr %i, align 8
  %nextvar = fadd double %i4, 2.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 4.000000e+00)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %j = alloca double, align 8
  %i = alloca double, align 8
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forcont9, %entry
  %i1 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i1, 1.000000e+01
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i2 = load double, ptr %i, align 8
  store double %i2, ptr %j, align 8
  br label %forentry3

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

forentry3:                                        ; preds = %forbody8, %forbody
  %j4 = load double, ptr %j, align 8
  %lttmp5 = fcmp ult double %j4, 1.000000e+01
  %booltmp6 = uitofp i1 %lttmp5 to double
  %forcond7 = fcmp one double %booltmp6, 0.000000e+00
  br i1 %forcond7, label %forbody8, label %forcont9

forbody8:                                         ; preds = %forentry3
  %calltmp = call double @putchard(double 4.200000e+01)
  %j10 = load double, ptr %j, align 8
  %nextvar = fadd double %j10, 1.000000e+00
  store double %nextvar, ptr %j, align 8
  br label %forentry3

forcont9:                                         ; preds = %forentry3
  %calltmp11 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double 0.000000e+00, double %calltmp11)
  %i12 = load double, ptr %i, align 8
  %nextvar13 = fadd double %i12, 1.000000e+00
  store double %nextvar13, ptr %i, align 8
  br label %forentry
}
define double @__anon_expr() {
entry:
  %calltmp = call double @testBegin(double 5.000000e+00)
  ret double %calltmp
}
define double @circle(double %r) {
entry:
  %j = alloca double, align 8
  %i = alloca double, align 8
  %r1 = alloca double, align 8
  store double %r, ptr %r1, align 8
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forcont12, %entry
  %i2 = load double, ptr %i, align 8
  %r3 = load double, ptr %r1, align 8
  %multmp = fmul double 4.000000e+00, %r3
  %lttmp = fcmp ult double %i2, %multmp
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  store double 0.000000e+00, ptr %j, align 8
  br label %forentry4

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

forentry4:                                        ; preds = %if.cont, %forbody
  %j5 = load double, ptr %j, align 8
  %r6 = load double, ptr %r1, align 8
  %multmp7 = fmul double 4.000000e+00, %r6
  %lttmp8 = fcmp ult double %j5, %multmp7
  %booltmp9 = uitofp i1 %lttmp8 to double
  %forcond10 = fcmp one double %booltmp9, 0.000000e+00
  br i1 %forcond10, label %forbody11, label %forcont12

forbody11:                                        ; preds = %forentry4
  %i13 = load double, ptr %i, align 8
  %r14 = load double, ptr %r1, align 8
  %multmp15 = fmul double 2.000000e+00, %r14
  %subtmp = fsub double %i13, %multmp15
  %i16 = load double, ptr %i, align 8
  %r17 = load double, ptr %r1, align 8
  %multmp18 = fmul double 2.000000e+00, %r17
  %subtmp19 = fsub double %i16, %multmp18
  %multmp20 = fmul double %subtmp, %subtmp19
  %j21 = load double, ptr %j, align 8
  %r22 = load double, ptr %r1, align 8
  %multmp23 = fmul double 2.000000e+00, %r22
  %subtmp24 = fsub double %j21, %multmp23
  %j25 = load double, ptr %j, align 8
  %r26 = load double, ptr %r1, align 8
  %multmp27 = fmul double 2.000000e+00, %r26
  %subtmp28 = fsub double %j25, %multmp27
  %multmp29 = fmul double %subtmp24, %subtmp28
  %addtmp = fadd double %multmp20, %multmp29
  %r30 = load double, ptr %r1, align 8
  %r31 = load double, ptr %r1, align 8
  %multmp32 = fmul double %r30, %r31
  %lttmp33 = fcmp ult double %addtmp, %multmp32
  %booltmp34 = uitofp i1 %lttmp33 to double
  %if.cond = fcmp one double %booltmp34, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

forcont12:                                        ; preds = %forentry4
  %calltmp37 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double 0.000000e+00, double %calltmp37)
  %i38 = load double, ptr %i, align 8
  %nextvar39 = fadd double %i38, 1.000000e+00
  store double %nextvar39, ptr %i, align 8
  br label %forentry

if.then:                                          ; preds = %forbody11
  %calltmp = call double @putchard(double 3.200000e+01)
  br label %if.cont

if.else:                                          ; preds = %forbody11
  %calltmp35 = call double @putchard(double 4.200000e+01)
  br label %if.cont

if.cont:                                          ; preds = %if.else, %if.then
  %iftmp = phi double [ %calltmp, %if.then ], [ %calltmp35, %if.else ]
  %j36 = load double, ptr %j, align 8
  %nextvar = fadd double %j36, 1.000000e+00
  store double %nextvar, ptr %j, align 8
  br label %forentry4
}
define double @__anon_expr() {
entry:
  %calltmp = call double @circle(double 1.000000e+01)
  ret double %calltmp
}
