clear 
set mem 200m

use data1.dta
*Data1 refers to Chinese leadership travel to all developing or non-OECD states

btscs cvisit styear sidea sideb, g(peaceyrs) nspline(3)
gen pop1=ln(pop)
gen bitrade1=ln(bitrade+0.00000000001)
gen oil1=ln(oil+0.00000000001)
*The next command is used to generate the results of Model 1 in Table I
logit cvisit cutradep cuigo usvisit1 cwtradep cwvisit terclaim c3igo rstate usally1 sanction pop1 bitrade1 asia oil1 peaceyrs _spline1 _spline2 _spline3  
*The next command is used to generate the results of Model 3 in Table I
logit cvisit gdpratio cuigo usvisit1 cwtradep cwvisit c3igo rstate usally1 sanction pop1 bitrade1 asia oil1 peaceyrs _spline1 _spline2 _spline3 

*The next command is used to generate the predicted probabilities in Table II (Model 3)
prvalue, x(gdpratio=max) 
prvalue, x(gdpratio=min)
prvalue, x(cuigo=max)
prvalue, x(cuigo=min)
prvalue, x(usvisit1=max)
prvalue, x(usvisit1=min)
prvalue, x(pop1=max)
prvalue, x(pop1=min)
prvalue, x(bitrade1=max)
prvalue, x(bitrade1=min)


clear 
set mem 200m

use data2.dta
*Data2 refers to Chinese leadership travel to all authoritarian states

btscs cvisit styear sidea sideb, g(peaceyrs) nspline(3)
gen pop1=ln(pop)
gen bitrade1=ln(bitrade+0.00000000001)
gen oil1=ln(oil+0.00000000001)
*The next command is used to generate the results of Model 2 in Table I
logit cvisit cutradep cuigo usvisit1 cwtradep cwvisit terclaim c3igo rstate usally1 sanction pop1 bitrade1 asia oil1 peaceyrs _spline1 _spline2 _spline3  
*The next command is used to generate the results of Model 4 in Table I
logit cvisit gdpratio cuigo usvisit1 cwtradep cwvisit c3igo rstate usally1 sanction pop1 bitrade1 asia oil1 peaceyrs _spline1 _spline2 _spline3 

*The next command is used to generate the predicted probabilities in Table II (Model 4)
prvalue, x(gdpratio=max) 
prvalue, x(gdpratio=min)
prvalue, x(cuigo=max)
prvalue, x(cuigo=min)
prvalue, x(usvisit1=max)
prvalue, x(usvisit1=min)
prvalue, x(pop1=max)
prvalue, x(pop1=min)
prvalue, x(bitrade1=max)
prvalue, x(bitrade1=min)
