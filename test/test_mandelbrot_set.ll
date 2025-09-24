declare double @printd(double)
declare double @putchard(double)
define double @"unary!"(double %v) {
entry:
  %v1 = alloca double, align 8
  store double %v, ptr %v1, align 8
  %v2 = load double, ptr %v1, align 8
  %if.cond = fcmp one double %v2, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.cont

if.else:                                          ; preds = %entry
  br label %if.cont

if.cont:                                          ; preds = %if.else, %if.then
  %iftmp = phi double [ 0.000000e+00, %if.then ], [ 1.000000e+00, %if.else ]
  ret double %iftmp
}
define double @unary-(double %v) {
entry:
  %v1 = alloca double, align 8
  store double %v, ptr %v1, align 8
  %v2 = load double, ptr %v1, align 8
  %subtmp = fsub double 0.000000e+00, %v2
  ret double %subtmp
}
define double @"binary>"(double %LHS, double %RHS) {
entry:
  %RHS2 = alloca double, align 8
  %LHS1 = alloca double, align 8
  store double %LHS, ptr %LHS1, align 8
  store double %RHS, ptr %RHS2, align 8
  %RHS3 = load double, ptr %RHS2, align 8
  %LHS4 = load double, ptr %LHS1, align 8
  %lttmp = fcmp ult double %RHS3, %LHS4
  %booltmp = uitofp i1 %lttmp to double
  ret double %booltmp
}
define double @"binary|"(double %LHS, double %RHS) {
entry:
  %RHS2 = alloca double, align 8
  %LHS1 = alloca double, align 8
  store double %LHS, ptr %LHS1, align 8
  store double %RHS, ptr %RHS2, align 8
  %LHS3 = load double, ptr %LHS1, align 8
  %if.cond = fcmp one double %LHS3, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.cont8

if.else:                                          ; preds = %entry
  %RHS4 = load double, ptr %RHS2, align 8
  %if.cond5 = fcmp one double %RHS4, 0.000000e+00
  br i1 %if.cond5, label %if.then6, label %if.else7

if.then6:                                         ; preds = %if.else
  br label %if.cont

if.else7:                                         ; preds = %if.else
  br label %if.cont

if.cont:                                          ; preds = %if.else7, %if.then6
  %iftmp = phi double [ 1.000000e+00, %if.then6 ], [ 0.000000e+00, %if.else7 ]
  br label %if.cont8

if.cont8:                                         ; preds = %if.cont, %if.then
  %iftmp9 = phi double [ 1.000000e+00, %if.then ], [ %iftmp, %if.cont ]
  ret double %iftmp9
}
define double @"binary&"(double %LHS, double %RHS) {
entry:
  %RHS2 = alloca double, align 8
  %LHS1 = alloca double, align 8
  store double %LHS, ptr %LHS1, align 8
  store double %RHS, ptr %RHS2, align 8
  %LHS3 = load double, ptr %LHS1, align 8
  %unop = call double @"unary!"(double %LHS3)
  %if.cond = fcmp one double %unop, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.cont

if.else:                                          ; preds = %entry
  %RHS4 = load double, ptr %RHS2, align 8
  %unop5 = call double @"unary!"(double %RHS4)
  %unop6 = call double @"unary!"(double %unop5)
  br label %if.cont

if.cont:                                          ; preds = %if.else, %if.then
  %iftmp = phi double [ 0.000000e+00, %if.then ], [ %unop6, %if.else ]
  ret double %iftmp
}
define double @"binary="(double %LHS, double %RHS) {
entry:
  %RHS2 = alloca double, align 8
  %LHS1 = alloca double, align 8
  store double %LHS, ptr %LHS1, align 8
  store double %RHS, ptr %RHS2, align 8
  %LHS3 = load double, ptr %LHS1, align 8
  %RHS4 = load double, ptr %RHS2, align 8
  %lttmp = fcmp ult double %LHS3, %RHS4
  %booltmp = uitofp i1 %lttmp to double
  %LHS5 = load double, ptr %LHS1, align 8
  %RHS6 = load double, ptr %RHS2, align 8
  %gttmp = fcmp ugt double %LHS5, %RHS6
  %booltmp7 = uitofp i1 %gttmp to double
  %binop = call double @"binary|"(double %booltmp, double %booltmp7)
  %unop = call double @"unary!"(double %binop)
  ret double %unop
}
define double @"binary:"(double %x, double %y) {
entry:
  %y2 = alloca double, align 8
  %x1 = alloca double, align 8
  store double %x, ptr %x1, align 8
  store double %y, ptr %y2, align 8
  %y3 = load double, ptr %y2, align 8
  ret double %y3
}
define double @printdensity(double %d) {
entry:
  %d1 = alloca double, align 8
  store double %d, ptr %d1, align 8
  %d2 = load double, ptr %d1, align 8
  %gttmp = fcmp ugt double %d2, 8.000000e+00
  %booltmp = uitofp i1 %gttmp to double
  %if.cond = fcmp one double %booltmp, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %calltmp = call double @putchard(double 3.200000e+01)
  br label %if.cont20

if.else:                                          ; preds = %entry
  %d3 = load double, ptr %d1, align 8
  %gttmp4 = fcmp ugt double %d3, 4.000000e+00
  %booltmp5 = uitofp i1 %gttmp4 to double
  %if.cond6 = fcmp one double %booltmp5, 0.000000e+00
  br i1 %if.cond6, label %if.then7, label %if.else9

if.then7:                                         ; preds = %if.else
  %calltmp8 = call double @putchard(double 4.600000e+01)
  br label %if.cont18

if.else9:                                         ; preds = %if.else
  %d10 = load double, ptr %d1, align 8
  %gttmp11 = fcmp ugt double %d10, 2.000000e+00
  %booltmp12 = uitofp i1 %gttmp11 to double
  %if.cond13 = fcmp one double %booltmp12, 0.000000e+00
  br i1 %if.cond13, label %if.then14, label %if.else16

if.then14:                                        ; preds = %if.else9
  %calltmp15 = call double @putchard(double 4.300000e+01)
  br label %if.cont

if.else16:                                        ; preds = %if.else9
  %calltmp17 = call double @putchard(double 4.200000e+01)
  br label %if.cont

if.cont:                                          ; preds = %if.else16, %if.then14
  %iftmp = phi double [ %calltmp15, %if.then14 ], [ %calltmp17, %if.else16 ]
  br label %if.cont18

if.cont18:                                        ; preds = %if.cont, %if.then7
  %iftmp19 = phi double [ %calltmp8, %if.then7 ], [ %iftmp, %if.cont ]
  br label %if.cont20

if.cont20:                                        ; preds = %if.cont18, %if.then
  %iftmp21 = phi double [ %calltmp, %if.then ], [ %iftmp19, %if.cont18 ]
  ret double %iftmp21
}
define double @mandelconverger(double %real, double %imag, double %iters, double %creal, double %cimag) {
entry:
  %cimag5 = alloca double, align 8
  %creal4 = alloca double, align 8
  %iters3 = alloca double, align 8
  %imag2 = alloca double, align 8
  %real1 = alloca double, align 8
  store double %real, ptr %real1, align 8
  store double %imag, ptr %imag2, align 8
  store double %iters, ptr %iters3, align 8
  store double %creal, ptr %creal4, align 8
  store double %cimag, ptr %cimag5, align 8
  %iters6 = load double, ptr %iters3, align 8
  %gttmp = fcmp ugt double %iters6, 2.550000e+02
  %booltmp = uitofp i1 %gttmp to double
  %real7 = load double, ptr %real1, align 8
  %real8 = load double, ptr %real1, align 8
  %multmp = fmul double %real7, %real8
  %imag9 = load double, ptr %imag2, align 8
  %imag10 = load double, ptr %imag2, align 8
  %multmp11 = fmul double %imag9, %imag10
  %addtmp = fadd double %multmp, %multmp11
  %gttmp12 = fcmp ugt double %addtmp, 4.000000e+00
  %booltmp13 = uitofp i1 %gttmp12 to double
  %binop = call double @"binary|"(double %booltmp, double %booltmp13)
  %if.cond = fcmp one double %binop, 0.000000e+00
  br i1 %if.cond, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %iters14 = load double, ptr %iters3, align 8
  br label %if.cont

if.else:                                          ; preds = %entry
  %real15 = load double, ptr %real1, align 8
  %real16 = load double, ptr %real1, align 8
  %multmp17 = fmul double %real15, %real16
  %imag18 = load double, ptr %imag2, align 8
  %imag19 = load double, ptr %imag2, align 8
  %multmp20 = fmul double %imag18, %imag19
  %subtmp = fsub double %multmp17, %multmp20
  %creal21 = load double, ptr %creal4, align 8
  %addtmp22 = fadd double %subtmp, %creal21
  %real23 = load double, ptr %real1, align 8
  %multmp24 = fmul double 2.000000e+00, %real23
  %imag25 = load double, ptr %imag2, align 8
  %multmp26 = fmul double %multmp24, %imag25
  %cimag27 = load double, ptr %cimag5, align 8
  %addtmp28 = fadd double %multmp26, %cimag27
  %iters29 = load double, ptr %iters3, align 8
  %addtmp30 = fadd double %iters29, 1.000000e+00
  %creal31 = load double, ptr %creal4, align 8
  %cimag32 = load double, ptr %cimag5, align 8
  %calltmp = call double @mandelconverger(double %addtmp22, double %addtmp28, double %addtmp30, double %creal31, double %cimag32)
  br label %if.cont

if.cont:                                          ; preds = %if.else, %if.then
  %iftmp = phi double [ %iters14, %if.then ], [ %calltmp, %if.else ]
  ret double %iftmp
}
define double @mandelconverge(double %real, double %imag) {
entry:
  %imag2 = alloca double, align 8
  %real1 = alloca double, align 8
  store double %real, ptr %real1, align 8
  store double %imag, ptr %imag2, align 8
  %real3 = load double, ptr %real1, align 8
  %imag4 = load double, ptr %imag2, align 8
  %real5 = load double, ptr %real1, align 8
  %imag6 = load double, ptr %imag2, align 8
  %calltmp = call double @mandelconverger(double %real3, double %imag4, double 0.000000e+00, double %real5, double %imag6)
  ret double %calltmp
}
define double @mandelhelp(double %xmin, double %xmax, double %xstep, double %ymin, double %ymax, double %ystep) {
entry:
  %x = alloca double, align 8
  %y = alloca double, align 8
  %ystep6 = alloca double, align 8
  %ymax5 = alloca double, align 8
  %ymin4 = alloca double, align 8
  %xstep3 = alloca double, align 8
  %xmax2 = alloca double, align 8
  %xmin1 = alloca double, align 8
  store double %xmin, ptr %xmin1, align 8
  store double %xmax, ptr %xmax2, align 8
  store double %xstep, ptr %xstep3, align 8
  store double %ymin, ptr %ymin4, align 8
  store double %ymax, ptr %ymax5, align 8
  store double %ystep, ptr %ystep6, align 8
  %ymin7 = load double, ptr %ymin4, align 8
  store double %ymin7, ptr %y, align 8
  br label %forentry

forentry:                                         ; preds = %forcont18, %entry
  %y8 = load double, ptr %y, align 8
  %ymax9 = load double, ptr %ymax5, align 8
  %lttmp = fcmp ult double %y8, %ymax9
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %xmin10 = load double, ptr %xmin1, align 8
  store double %xmin10, ptr %x, align 8
  br label %forentry11

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

forentry11:                                       ; preds = %forbody17, %forbody
  %x12 = load double, ptr %x, align 8
  %xmax13 = load double, ptr %xmax2, align 8
  %lttmp14 = fcmp ult double %x12, %xmax13
  %booltmp15 = uitofp i1 %lttmp14 to double
  %forcond16 = fcmp one double %booltmp15, 0.000000e+00
  br i1 %forcond16, label %forbody17, label %forcont18

forbody17:                                        ; preds = %forentry11
  %x19 = load double, ptr %x, align 8
  %y20 = load double, ptr %y, align 8
  %calltmp = call double @mandelconverge(double %x19, double %y20)
  %calltmp21 = call double @printdensity(double %calltmp)
  %xstep22 = load double, ptr %xstep3, align 8
  %x23 = load double, ptr %x, align 8
  %nextvar = fadd double %x23, %xstep22
  store double %nextvar, ptr %x, align 8
  br label %forentry11

forcont18:                                        ; preds = %forentry11
  %calltmp24 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double 0.000000e+00, double %calltmp24)
  %ystep25 = load double, ptr %ystep6, align 8
  %y26 = load double, ptr %y, align 8
  %nextvar27 = fadd double %y26, %ystep25
  store double %nextvar27, ptr %y, align 8
  br label %forentry
}
define double @mandel(double %realstart, double %imagstart, double %realmag, double %imagmag) {
entry:
  %imagmag4 = alloca double, align 8
  %realmag3 = alloca double, align 8
  %imagstart2 = alloca double, align 8
  %realstart1 = alloca double, align 8
  store double %realstart, ptr %realstart1, align 8
  store double %imagstart, ptr %imagstart2, align 8
  store double %realmag, ptr %realmag3, align 8
  store double %imagmag, ptr %imagmag4, align 8
  %realstart5 = load double, ptr %realstart1, align 8
  %realstart6 = load double, ptr %realstart1, align 8
  %realmag7 = load double, ptr %realmag3, align 8
  %multmp = fmul double %realmag7, 7.800000e+01
  %addtmp = fadd double %realstart6, %multmp
  %realmag8 = load double, ptr %realmag3, align 8
  %imagstart9 = load double, ptr %imagstart2, align 8
  %imagstart10 = load double, ptr %imagstart2, align 8
  %imagmag11 = load double, ptr %imagmag4, align 8
  %multmp12 = fmul double %imagmag11, 4.000000e+01
  %addtmp13 = fadd double %imagstart10, %multmp12
  %imagmag14 = load double, ptr %imagmag4, align 8
  %calltmp = call double @mandelhelp(double %realstart5, double %addtmp, double %realmag8, double %imagstart9, double %addtmp13, double %imagmag14)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %unop = call double @unary-(double 2.300000e+00)
  %unop1 = call double @unary-(double 1.300000e+00)
  %calltmp = call double @mandel(double %unop, double %unop1, double 5.000000e-02, double 7.000000e-02)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %unop = call double @unary-(double 2.000000e+00)
  %unop1 = call double @unary-(double 1.000000e+00)
  %calltmp = call double @mandel(double %unop, double %unop1, double 2.000000e-02, double 4.000000e-02)
  ret double %calltmp
}
define double @__anon_expr() {
entry:
  %unop = call double @unary-(double 9.000000e-01)
  %unop1 = call double @unary-(double 1.400000e+00)
  %calltmp = call double @mandel(double %unop, double %unop1, double 2.000000e-02, double 3.000000e-02)
  ret double %calltmp
}
