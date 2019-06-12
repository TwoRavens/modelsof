use  "experiment data.dta", clear

gen utilityA=-(self_placement-5)^2 if divergence==0
replace utilityA=-(self_placement-2)^2 if divergence==1

gen utilityB=-(self_placement-7)^2 if divergence==0
replace utilityB=-(self_placement-10)^2 if divergence==1

gen advantageAquad=utilityA-utilityB

svyset [pw=weight]

** Table 2

svy: logit preferA i.divergence##c.advantageAquad info
svy: logit preferA info c.advantageAquad##c.divergence party7 age educ i.race female income
svy: logit preferA i.divergence##c.advantageAquad info if self_placement > 3 & self_placement <9
svy: logit preferA info c.advantageAquad##c.divergence party7 age educ i.race female income if self_placement > 3 & self_placement <9


** Generate predicted probabilities for Figure 2

margins,vce(unconditional) at(advantage=(-8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8) diverge=0)
margins,vce(unconditional) at(advantage=(-8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8) diverge=1)
