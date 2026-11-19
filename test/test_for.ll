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
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}
define double @__anon_expr() {
entry:
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8
}
define double @__anon_expr() {
entry:
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00
}
define double @__anon_expr() {
entry:
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00

entry24:                                          ; No predecessors!
  %calltmp25 = call double @testBegin(double 3.000000e+00)
  ret double %calltmp25
}
define double @__anon_expr() {
entry:
  %i27 = alloca double, align 8
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00

entry24:                                          ; No predecessors!
  %calltmp25 = call double @testBegin(double 3.000000e+00)
  ret double %calltmp25

entry26:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i27, align 8
  br label %forentry28

forentry28:                                       ; preds = %forbody33, %entry26
  %i29 = load double, ptr %i27, align 8
  %lttmp30 = fcmp ult double %i29, 0.000000e+00
  %booltmp31 = uitofp i1 %lttmp30 to double
  %forcond32 = fcmp one double %booltmp31, 0.000000e+00
  br i1 %forcond32, label %forbody33, label %forcont34

forbody33:                                        ; preds = %forentry28
  %i35 = load double, ptr %i27, align 8
  %calltmp36 = call double @printI32(double %i35)
  %calltmp37 = call double @putchard(double 1.000000e+01)
  %binop38 = call double @"binary:"(double %calltmp36, double %calltmp37)
  %i39 = load double, ptr %i27, align 8
  %nextvar40 = fadd double %i39, 2.000000e+00
  store double %nextvar40, ptr %i27, align 8
  br label %forentry28

forcont34:                                        ; preds = %forentry28
  ret double 0.000000e+00
}
define double @__anon_expr() {
entry:
  %i27 = alloca double, align 8
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00

entry24:                                          ; No predecessors!
  %calltmp25 = call double @testBegin(double 3.000000e+00)
  ret double %calltmp25

entry26:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i27, align 8
  br label %forentry28

forentry28:                                       ; preds = %forbody33, %entry26
  %i29 = load double, ptr %i27, align 8
  %lttmp30 = fcmp ult double %i29, 0.000000e+00
  %booltmp31 = uitofp i1 %lttmp30 to double
  %forcond32 = fcmp one double %booltmp31, 0.000000e+00
  br i1 %forcond32, label %forbody33, label %forcont34

forbody33:                                        ; preds = %forentry28
  %i35 = load double, ptr %i27, align 8
  %calltmp36 = call double @printI32(double %i35)
  %calltmp37 = call double @putchard(double 1.000000e+01)
  %binop38 = call double @"binary:"(double %calltmp36, double %calltmp37)
  %i39 = load double, ptr %i27, align 8
  %nextvar40 = fadd double %i39, 2.000000e+00
  store double %nextvar40, ptr %i27, align 8
  br label %forentry28

forcont34:                                        ; preds = %forentry28
  ret double 0.000000e+00

entry41:                                          ; No predecessors!
  %calltmp42 = call double @testBegin(double 4.000000e+00)
  ret double %calltmp42
}
define double @__anon_expr() {
entry:
  %j = alloca double, align 8
  %i44 = alloca double, align 8
  %i27 = alloca double, align 8
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00

entry24:                                          ; No predecessors!
  %calltmp25 = call double @testBegin(double 3.000000e+00)
  ret double %calltmp25

entry26:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i27, align 8
  br label %forentry28

forentry28:                                       ; preds = %forbody33, %entry26
  %i29 = load double, ptr %i27, align 8
  %lttmp30 = fcmp ult double %i29, 0.000000e+00
  %booltmp31 = uitofp i1 %lttmp30 to double
  %forcond32 = fcmp one double %booltmp31, 0.000000e+00
  br i1 %forcond32, label %forbody33, label %forcont34

forbody33:                                        ; preds = %forentry28
  %i35 = load double, ptr %i27, align 8
  %calltmp36 = call double @printI32(double %i35)
  %calltmp37 = call double @putchard(double 1.000000e+01)
  %binop38 = call double @"binary:"(double %calltmp36, double %calltmp37)
  %i39 = load double, ptr %i27, align 8
  %nextvar40 = fadd double %i39, 2.000000e+00
  store double %nextvar40, ptr %i27, align 8
  br label %forentry28

forcont34:                                        ; preds = %forentry28
  ret double 0.000000e+00

entry41:                                          ; No predecessors!
  %calltmp42 = call double @testBegin(double 4.000000e+00)
  ret double %calltmp42

entry43:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i44, align 8
  br label %forentry45

forentry45:                                       ; preds = %forcont59, %entry43
  %i46 = load double, ptr %i44, align 8
  %lttmp47 = fcmp ult double %i46, 1.000000e+01
  %booltmp48 = uitofp i1 %lttmp47 to double
  %forcond49 = fcmp one double %booltmp48, 0.000000e+00
  br i1 %forcond49, label %forbody50, label %forcont51

forbody50:                                        ; preds = %forentry45
  %i52 = load double, ptr %i44, align 8
  store double %i52, ptr %j, align 8
  br label %forentry53

forcont51:                                        ; preds = %forentry45
  ret double 0.000000e+00

forentry53:                                       ; preds = %forbody58, %forbody50
  %j54 = load double, ptr %j, align 8
  %lttmp55 = fcmp ult double %j54, 1.000000e+01
  %booltmp56 = uitofp i1 %lttmp55 to double
  %forcond57 = fcmp one double %booltmp56, 0.000000e+00
  br i1 %forcond57, label %forbody58, label %forcont59

forbody58:                                        ; preds = %forentry53
  %calltmp60 = call double @putchard(double 4.200000e+01)
  %j61 = load double, ptr %j, align 8
  %nextvar62 = fadd double %j61, 1.000000e+00
  store double %nextvar62, ptr %j, align 8
  br label %forentry53

forcont59:                                        ; preds = %forentry53
  %calltmp63 = call double @putchard(double 1.000000e+01)
  %binop64 = call double @"binary:"(double 0.000000e+00, double %calltmp63)
  %i65 = load double, ptr %i44, align 8
  %nextvar66 = fadd double %i65, 1.000000e+00
  store double %nextvar66, ptr %i44, align 8
  br label %forentry45
}
define double @__anon_expr() {
entry:
  %j = alloca double, align 8
  %i44 = alloca double, align 8
  %i27 = alloca double, align 8
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00

entry24:                                          ; No predecessors!
  %calltmp25 = call double @testBegin(double 3.000000e+00)
  ret double %calltmp25

entry26:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i27, align 8
  br label %forentry28

forentry28:                                       ; preds = %forbody33, %entry26
  %i29 = load double, ptr %i27, align 8
  %lttmp30 = fcmp ult double %i29, 0.000000e+00
  %booltmp31 = uitofp i1 %lttmp30 to double
  %forcond32 = fcmp one double %booltmp31, 0.000000e+00
  br i1 %forcond32, label %forbody33, label %forcont34

forbody33:                                        ; preds = %forentry28
  %i35 = load double, ptr %i27, align 8
  %calltmp36 = call double @printI32(double %i35)
  %calltmp37 = call double @putchard(double 1.000000e+01)
  %binop38 = call double @"binary:"(double %calltmp36, double %calltmp37)
  %i39 = load double, ptr %i27, align 8
  %nextvar40 = fadd double %i39, 2.000000e+00
  store double %nextvar40, ptr %i27, align 8
  br label %forentry28

forcont34:                                        ; preds = %forentry28
  ret double 0.000000e+00

entry41:                                          ; No predecessors!
  %calltmp42 = call double @testBegin(double 4.000000e+00)
  ret double %calltmp42

entry43:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i44, align 8
  br label %forentry45

forentry45:                                       ; preds = %forcont59, %entry43
  %i46 = load double, ptr %i44, align 8
  %lttmp47 = fcmp ult double %i46, 1.000000e+01
  %booltmp48 = uitofp i1 %lttmp47 to double
  %forcond49 = fcmp one double %booltmp48, 0.000000e+00
  br i1 %forcond49, label %forbody50, label %forcont51

forbody50:                                        ; preds = %forentry45
  %i52 = load double, ptr %i44, align 8
  store double %i52, ptr %j, align 8
  br label %forentry53

forcont51:                                        ; preds = %forentry45
  ret double 0.000000e+00

forentry53:                                       ; preds = %forbody58, %forbody50
  %j54 = load double, ptr %j, align 8
  %lttmp55 = fcmp ult double %j54, 1.000000e+01
  %booltmp56 = uitofp i1 %lttmp55 to double
  %forcond57 = fcmp one double %booltmp56, 0.000000e+00
  br i1 %forcond57, label %forbody58, label %forcont59

forbody58:                                        ; preds = %forentry53
  %calltmp60 = call double @putchard(double 4.200000e+01)
  %j61 = load double, ptr %j, align 8
  %nextvar62 = fadd double %j61, 1.000000e+00
  store double %nextvar62, ptr %j, align 8
  br label %forentry53

forcont59:                                        ; preds = %forentry53
  %calltmp63 = call double @putchard(double 1.000000e+01)
  %binop64 = call double @"binary:"(double 0.000000e+00, double %calltmp63)
  %i65 = load double, ptr %i44, align 8
  %nextvar66 = fadd double %i65, 1.000000e+00
  store double %nextvar66, ptr %i44, align 8
  br label %forentry45

entry67:                                          ; No predecessors!
  %calltmp68 = call double @testBegin(double 5.000000e+00)
  ret double %calltmp68
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
  %j = alloca double, align 8
  %i44 = alloca double, align 8
  %i27 = alloca double, align 8
  %i10 = alloca double, align 8
  %i = alloca double, align 8
  %calltmp = call double @testBegin(double 1.000000e+00)
  ret double %calltmp

entry1:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i, align 8
  br label %forentry

forentry:                                         ; preds = %forbody, %entry1
  %i2 = load double, ptr %i, align 8
  %lttmp = fcmp ult double %i2, 5.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %i3 = load double, ptr %i, align 8
  %calltmp4 = call double @printI32(double %i3)
  %calltmp5 = call double @putchard(double 1.000000e+01)
  %binop = call double @"binary:"(double %calltmp4, double %calltmp5)
  %i6 = load double, ptr %i, align 8
  %nextvar = fadd double %i6, 1.000000e+00
  store double %nextvar, ptr %i, align 8
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00

entry7:                                           ; No predecessors!
  %calltmp8 = call double @testBegin(double 2.000000e+00)
  ret double %calltmp8

entry9:                                           ; No predecessors!
  store double 0.000000e+00, ptr %i10, align 8
  br label %forentry11

forentry11:                                       ; preds = %forbody16, %entry9
  %i12 = load double, ptr %i10, align 8
  %lttmp13 = fcmp ult double %i12, 5.000000e+00
  %booltmp14 = uitofp i1 %lttmp13 to double
  %forcond15 = fcmp one double %booltmp14, 0.000000e+00
  br i1 %forcond15, label %forbody16, label %forcont17

forbody16:                                        ; preds = %forentry11
  %i18 = load double, ptr %i10, align 8
  %calltmp19 = call double @printI32(double %i18)
  %calltmp20 = call double @putchard(double 1.000000e+01)
  %binop21 = call double @"binary:"(double %calltmp19, double %calltmp20)
  %i22 = load double, ptr %i10, align 8
  %nextvar23 = fadd double %i22, 2.000000e+00
  store double %nextvar23, ptr %i10, align 8
  br label %forentry11

forcont17:                                        ; preds = %forentry11
  ret double 0.000000e+00

entry24:                                          ; No predecessors!
  %calltmp25 = call double @testBegin(double 3.000000e+00)
  ret double %calltmp25

entry26:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i27, align 8
  br label %forentry28

forentry28:                                       ; preds = %forbody33, %entry26
  %i29 = load double, ptr %i27, align 8
  %lttmp30 = fcmp ult double %i29, 0.000000e+00
  %booltmp31 = uitofp i1 %lttmp30 to double
  %forcond32 = fcmp one double %booltmp31, 0.000000e+00
  br i1 %forcond32, label %forbody33, label %forcont34

forbody33:                                        ; preds = %forentry28
  %i35 = load double, ptr %i27, align 8
  %calltmp36 = call double @printI32(double %i35)
  %calltmp37 = call double @putchard(double 1.000000e+01)
  %binop38 = call double @"binary:"(double %calltmp36, double %calltmp37)
  %i39 = load double, ptr %i27, align 8
  %nextvar40 = fadd double %i39, 2.000000e+00
  store double %nextvar40, ptr %i27, align 8
  br label %forentry28

forcont34:                                        ; preds = %forentry28
  ret double 0.000000e+00

entry41:                                          ; No predecessors!
  %calltmp42 = call double @testBegin(double 4.000000e+00)
  ret double %calltmp42

entry43:                                          ; No predecessors!
  store double 0.000000e+00, ptr %i44, align 8
  br label %forentry45

forentry45:                                       ; preds = %forcont59, %entry43
  %i46 = load double, ptr %i44, align 8
  %lttmp47 = fcmp ult double %i46, 1.000000e+01
  %booltmp48 = uitofp i1 %lttmp47 to double
  %forcond49 = fcmp one double %booltmp48, 0.000000e+00
  br i1 %forcond49, label %forbody50, label %forcont51

forbody50:                                        ; preds = %forentry45
  %i52 = load double, ptr %i44, align 8
  store double %i52, ptr %j, align 8
  br label %forentry53

forcont51:                                        ; preds = %forentry45
  ret double 0.000000e+00

forentry53:                                       ; preds = %forbody58, %forbody50
  %j54 = load double, ptr %j, align 8
  %lttmp55 = fcmp ult double %j54, 1.000000e+01
  %booltmp56 = uitofp i1 %lttmp55 to double
  %forcond57 = fcmp one double %booltmp56, 0.000000e+00
  br i1 %forcond57, label %forbody58, label %forcont59

forbody58:                                        ; preds = %forentry53
  %calltmp60 = call double @putchard(double 4.200000e+01)
  %j61 = load double, ptr %j, align 8
  %nextvar62 = fadd double %j61, 1.000000e+00
  store double %nextvar62, ptr %j, align 8
  br label %forentry53

forcont59:                                        ; preds = %forentry53
  %calltmp63 = call double @putchard(double 1.000000e+01)
  %binop64 = call double @"binary:"(double 0.000000e+00, double %calltmp63)
  %i65 = load double, ptr %i44, align 8
  %nextvar66 = fadd double %i65, 1.000000e+00
  store double %nextvar66, ptr %i44, align 8
  br label %forentry45

entry67:                                          ; No predecessors!
  %calltmp68 = call double @testBegin(double 5.000000e+00)
  ret double %calltmp68

entry69:                                          ; No predecessors!
  %calltmp70 = call double @circle(double 1.000000e+01)
  ret double %calltmp70
}
