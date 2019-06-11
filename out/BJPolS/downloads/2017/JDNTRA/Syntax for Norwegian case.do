* MCP, GENDER AND RADICAL RIGHT IN NORWAY
* =======================================

* MCP
recode  dv35_1 dv35_2 dv35_3 dv35_4 (97 98=.)
alpha dv35_1 dv35_2 dv35_3 dv35_4, reverse(dv35_1 dv35_2 dv35_3 dv35_4) std item gen(mcp)
gen mcp2 = (8-dv35_1)+(8-dv35_2)+(8-dv35_3)+(8-dv35_4)

* anti-immigrant
recode  dv25 dv26 dv27 dv28 dv29_1 dv29_3 dv29_4  dv29_5 (97 98=.)
alpha dv29_1 dv29_3 dv29_4 dv29_5, reverse(dv29_3 dv29_4 dv29_5) std item gen(immscale)
gen immscale2 = (8-dv29_1)+(8-dv29_3)+(8-dv29_4)+(8-dv29_5)

* voting
recode k3 (3=1) (97 98=.) (nonmissing=0), gen(RRvote)
recode k6_3 (97=.), gen(likeFrP)

* gender
recode P1 (2=0), gen(gender)
label define gndr 0 "female" 1 "male"
label values gender gndr

* other variables
recode P4 (97=.), gen(education)
recode k25_1 (3=.), gen(income)
recode  k8_1 (97 99=.), gen(leftright)
rename P5_1 age

* standardizing
egen std_mcp = std(mcp)
egen std_immscale = std(immscale)
 
* descriptives
sum gender RRvote mcp2 immscale2 if mcp!=.
 
  * Listwise deletion
*foreach var of varlist gender immscale mcp {
*drop if `var'==.
*}

 
* Descriptives
* ============

egen mcp3g = cut(mcp), group(3)
lab define mcp3Lab 0 "low" 1 "medium" 2 "high"
lab value mcp3g mcp3Lab

egen immscale3 = cut(immscale), group(3)
lab define immscale3Lab 0 "low" 1 "medium" 2 "high"
lab value immscale3 immscale3Lab

tab mcp3g gender, nofreq column chi
tab immscale3 gender, nofreq column chi

tab mcp3, gen(mcp3)
ttest mcp31, by(gender)
ttest mcp32, by(gender)
ttest mcp33, by(gender)
tab immscale3, gen(immscale3)
ttest immscale31, by(gender)
ttest immscale32, by(gender)
ttest immscale33, by(gender)

mean std_mcp std_immscale, over(gender)
ttest std_mcp, by(gender)
ttest std_immscale, by(gender)

kdensity mcp if gender == 0, plot(kdensity mcp if gender == 1) ///
  legend(label(1 "Women") label(2 "Men") rows(1))
 
* Tests: voting for RR
* ====================

* Main models
logit RRvote gender
listcoef, std constant
logit RRvote gender immscale
listcoef, std constant
logit RRvote gender mcp
listcoef, std constant
logit RRvote gender mcp immscale
listcoef, std constant

* With controls
logit RRvote gender					i.education income leftright age
estimates store m1
listcoef, std constant
logit RRvote gender immscale		i.education income leftright age
estimates store m2
listcoef, std constant
logit RRvote gender mcp				i.education income leftright age
estimates store m3
listcoef, std constant
logit RRvote gender mcp immscale	i.education income leftright age
estimates store m4
listcoef, std constant

esttab m1 m2 m3 m4, cells(b(star fmt(%9.3f)))  stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant)

* ===
* CFA
* ===

sem (MCP -> dv35_1 dv35_2 dv35_3 dv35_4) (IMMSCALE -> dv29_1 dv29_3 dv29_4 dv29_5), stand
* chi2(19) = 118.19
sem (ONE_LATENT -> dv35_1 dv35_2 dv35_3 dv35_4 dv29_1 dv29_3 dv29_4 dv29_5), stand
* chi2(20) = 738.11
