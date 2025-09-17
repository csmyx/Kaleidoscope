declare double @printd(double)
define double @__anon_expr() {
entry:
  br label %forentry

forentry:                                         ; preds = %forbody, %entry
  %i = phi double [ 0.000000e+00, %entry ], [ %nextvar, %forbody ]
  %lttmp = fcmp ult double %i, 3.000000e+00
  %booltmp = uitofp i1 %lttmp to double
  %forcond = fcmp one double %booltmp, 0.000000e+00
  br i1 %forcond, label %forbody, label %forcont

forbody:                                          ; preds = %forentry
  %calltmp = call double @printd(double 9.700000e+01)
  %nextvar = fadd double %i, 1.000000e+00
  br label %forentry

forcont:                                          ; preds = %forentry
  ret double 0.000000e+00
}