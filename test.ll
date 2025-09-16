declare double @x()
declare double @y()
define double @z(double %a) {
entry:
  %ifcond = fcmp one double %a, 0.000000e+00
  br i1 %ifcond, label %then, label %else

then:                                             ; preds = %entry
  %calltmp = call double @x()
  br label %ifcont

else:                                             ; preds = %entry
  %calltmp1 = call double @y()
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %iftmp = phi double [ %calltmp, %then ], [ %calltmp1, %else ]
  ret double %iftmp
}
