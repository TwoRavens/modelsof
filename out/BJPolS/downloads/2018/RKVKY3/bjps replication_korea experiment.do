**** recode variables *****
gen duty=pre_duty
	recode duty 0=. 1=1 2=0

	
gen mobileinterest=pre_mobileinterest
	recode mobileinterest 0=. 3/4=0 2=1 1=2
	
gen polint=pre_polint
	recode polint 0=. 4=0 3=1 2=2 1=3
	
gen female=sex
	recode female 1=0 2=1

gen ageyrs=age
	recode ageyrs 0=.
	replace ageyrs=ageyrs+19
	
gen educ=educat
	recode educ 0=.
	recode educ 1/2=0 3/4=1 5/6=2 //hs or lower, college, graduate
		
recode nectime 0=. //in years


**** experiment results ****
//unmatched

ttest duty, by(treatment)
ttest vote, by(treatment)

//matched control-treatment pairs

findit pscore //install pscore package via link

global treatment treatment
global xlist ageyrs female nectime educ if pre_finish!=.
global breps 100

pscore $treatment $xlist, pscore(pscore) blockid(myblock) comsup

attnd duty $treatment $xlist, pscore(pscore) comsup boot reps($breps) dots
attnd vote $treatment $xlist, pscore(pscore) comsup boot reps($breps) dots



