* This will replicate the examples in gologit2_sj
* Besides the gologit2 programs, you also need to have installed:
* spost, by Long and Freese

* Example 1: Parallel Lines Assumption Violated 
use http://www.indiana.edu/~jslsoc/stata/spex_data/ordwarm2.dta, clear
ologit warm yr89 male white age ed prst, nolog
brant
brant, detail
gologit2 warm yr89 male white age ed prst
gologit2 warm yr89 male white age ed prst, autofit lrforce

* Example 2: The Alternative Gamma Parameterization
gologit2 warm yr89 male white age ed prst, autofit lrforce gamma

* Example 3: svy estimation
use http://www.stata-press.com/data/r8/nhanes2f.dta
quietly sum age, meanonly
gen c_age = age - r(mean)
gen c_age2=c_age^2
gologit2 health female black c_age c_age2, svy auto

* Example 4: gologit 1.0 compatibility
use http://www.indiana.edu/~jslsoc/stata/spex_data/ordwarm2.dta, clear
* Use the v1 option to save internally stored results in gologit 1.0 format
quietly gologit2 warm yr89 male white age ed prst, pl(yr89 male) lrf v1
* Use spost routines.  Get predicted probability for a 30 year old 
* average white woman in 1989
prvalue, x(male=0 yr89=1 age=30) rest(mean)
* Now do 70 year old average black male in 1977
prvalue, x(male=1 yr89=0 age=70) rest(mean)

* Example 5: The predict command
quietly gologit2 warm yr89 male white age ed prst, pl(yr89 male) lrf
predict p1 p2 p3 p4
list p1 p2 p3 p4 in 1/10

* Example 6: Alternatives to autofit
* Least constrained model - same as the original gologit
quietly gologit2 warm yr89 male white age ed prst, store(gologit)
* Partial Proportional Odds Model, fitted using autofit
quietly gologit2 warm yr89 male white age ed prst, store(gologit2) autofit
* ologit clone
quietly gologit2 warm yr89 male white age ed prst, store(ologit) pl
* Confirm that ologit is too restrictive
lrtest ologit gologit
* Confirm that partial proportional odds is not too restrictive
lrtest gologit gologit2

* Example 7: Constrained Logistic Regression
use http://www.indiana.edu/~jslsoc/stata/spex_data/ordwarm2.dta, clear
recode warm (1 2 = 0)(3 4 = 1), gen(agree)
* Estimate logistic regression model using logit command
logit agree yr89 male white age ed prst, nolog
* Equivalent model fitted by gologit2
gologit2 agree yr89 male white age ed prst, lrf store(unconstrained)
* Constrain the effects of male and white to be equal
constraint 1 male = white
* Estimate the constrained model
gologit2 agree yr89 male white age ed prst, lrf store(constrained) c(1)
* Test the equality constraint
lrtest constrained unconstrained

* Example 8: A Detailed Replication and Extension of Published Work
use http://www.nd.edu/~rwilliam/gologit2/lall, clear
* Confirm that ologit's assumptions are violated. Contrast ologit (constrained)
* and gologit (unconstrained)
quietly gologit2 hstatus heart smoke, npl lrf store(unconstrained)
quietly gologit2 hstatus heart smoke, pl lrf store(constrained)
lrtest unconstrained constrained
* Now use autofit to fit partial proportional odds model
gologit2 hstatus heart smoke, auto gamma lrf
* Totally unconstrained model
gologit2 hstatus heart smoke, lrf npl gamma
* Use constraints to get an even more parsimonious model
constraint 1 [#1=#2]:smoke
gologit2 hstatus heart smoke, lrf gamma pl(heart) constraint(1)
