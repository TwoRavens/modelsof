********************************************************************************
******************  	Interview Intel. Ratings Analysis 	 	 ***************
******************		    --- motta018@umn.edu ----  	 	 	 ***************
********************************************************************************

* RUN SCRIPT #1, THEN RUN THIS . . . 

svyset [pweight=weight_full], strata(strata_full) psu(psu_full)

* Run prep file from KVI Folder

cd "WORKING DIRECTORY"

********************************************************************************
* Figure One
********************************************************************************

gen junkwt=weight_ftf*10000

gen intel_prepost=(intel_pre + intel_post)/2
	label values intel_prepost hl
	label variable intel_prepost "Combined Intelligence Rating"
	fre intel_prepost

hist intel_prepost [fw=junkwt], width(0.2) scheme(s1mono) ytitle("Density") ///
	fcolor(white) lwidth(medthick) lcolor(black) title("Interviewer Rating") xtitle(" ")
	graph save "f1a", replace

hist intelligence [fw=junkwt] , width(0.2) scheme(s1mono) ytitle(" ") ///
	fcolor(white) lwidth(medthick) lcolor(black) title("WORDSUM") xtitle(" ") ///
	note("r = ")
	graph save "f1b", replace
	
graph twoway (scatter intel_prepost intelligence, scheme(s1mono) jitter(15) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost intelligence, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Rating") xtitle("WORDSUM") ///
		note("Weighted r = 0.38", ring(0) position(4)))
	
	graph save "f1c", replace
	
	graph combine "f1a" "f1b", ycommon scheme(s1mono) rows(2)
		graph save "f1ab", replace
		
	graph combine "f1ab" "f1c", scheme(s1mono) cols(2)
		graph export "figure1.pdf"
		
********************************************************************************
* Figure Two
********************************************************************************

// Knowledge

graph twoway (scatter intel_prepost knowcount, scheme(s1mono) jitter(10) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost knowcount, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Rating") xtitle("Political Knowledge") ///
		note("Weighted r = 0.41", ring(0) position(4)))
		
		graph save "corr1", replace
	
// Interest

graph twoway (scatter intel_prepost polinterest, scheme(s1mono) jitter(10) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost polinterest, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Rating") xtitle("Political Interest") ///
		note("Weighted r = 0.39", ring(0) position(4)))
		
		graph save "corr2", replace

// Media Attn

graph twoway (scatter intel_prepost campmediaindex, scheme(s1mono) jitter(5) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost campmediaindex, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Rating") xtitle("Media Attention") ///
		note("Weighted r = 0.47", ring(0) position(4)))
		
		graph save "corr3", replace

// Income

graph twoway (scatter intel_prepost income, scheme(s1mono) jitter(5) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost income, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Rating") xtitle("Income") ///
		note("Weighted r = 0.39", ring(0) position(4)))
		
		graph save "corr4", replace
		
// Education

gen eductest=(dem_edugroup_x-1)/4
graph twoway (scatter intel_prepost eductest, scheme(s1mono) jitter(10) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost eductest, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Rating") xtitle("Education") ///
		note("Weighted r = 0.51", ring(0) position(4)))
	drop eductest
	
		graph save "corr5", replace
		
	graph combine "corr1" "corr2" "corr3" "corr4" "corr5", ycommon scheme(s1mono)
		graph export "scatters.pdf", replace
	

********************************************************************************
* Table One
********************************************************************************

** Education = College Dummy; Pre

svy: reg intel_pre intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID	
	college income female black hisp age // Demos
	
	est store pre1
	
	test intelligence=knowcount
	test intelligence=polinterest
	test intelligence=campmediaindex // p < 0.01
	test intelligence=democrat
	test intelligence=gop
	test intelligence=income
	test intelligence=college

** Educaton = Full Educ; Post

svy: reg intel_pre intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age // Demos
	
	est store pre2
	
	test intelligence=knowcount
	test intelligence=polinterest
	test intelligence=campmediaindex // p < 0.01
	test intelligence=democrat
	test intelligence=gop
	test intelligence=income
	test intelligence=dem_edugroup_x
	
** Education = College Dummy; Post

svy: reg intel_post intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	college income female black hisp age // Demos
	
	est store post1
	
	test intelligence=knowcount
	test intelligence=polinterest
	test intelligence=campmediaindex // p < 0.01
	test intelligence=democrat
	test intelligence=gop
	test intelligence=income
	test intelligence=college

** Educaton = Full Educ; Post

svy: reg intel_post intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age  // Demos
	
	est store post2
	
	test intelligence=knowcount
	test intelligence=polinterest
	test intelligence=campmediaindex // p < 0.01
	test intelligence=democrat
	test intelligence=gop
	test intelligence=income
	test intelligence=dem_edugroup_x

** Full Intelligence Outcome (Prepost)

	
	pwcorr intel_pre intel_post
	
svy: reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	college income female black hisp age // Demos
	
	est store prepost1
	
	test intelligence=knowcount
	test intelligence=polinterest
	test intelligence=campmediaindex // p < 0.01
	test intelligence=democrat
	test intelligence=gop
	test intelligence=income
	test intelligence=college
	
svy: reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	dem_edugroup_x income female black hisp age // Demos
	
	est store prepost2
	
	test intelligence=knowcount
	test intelligence=polinterest
	test intelligence=campmediaindex // p < 0.01
	test intelligence=democrat
	test intelligence=gop
	test intelligence=income
	test intelligence=dem_edugroup_x
	

** Table One
	
estout pre1 pre2 post1 post2 prepost1 prepost2,  ///
 	cells(b (star fmt(2)  vacant("-")) se(par(( )))) ///
  	starlevels(+ 0.10 * 0.05) stats(N, fmt(0)) ///
  	varlabels(intelligence "Intelligence" knowcount "Pol. Know." ///
	democrat "Democrat" gop "Republican" conservatism "Conservatism" ///
	age "Age" female "Female" income "Income" college "College" campmediaindex "Media Use (Index)" ///
	tvuse "Television" radiouse "Radio" newspaperuse "Newspaper" internetuse "Internet" siteuse "Camp. Sites" /// 
	_cons "Constant" hisp "Hispanic" black "Black" open "Openness" ///
	online "Internet Mode" strength "Strength" ///
	consci "Conscientiousness" agree "Agreeableness" extra "Extraversion" ///
	neuro "Neuroticism" ne "Need to Eval" author "Authoritarianism" polinterest "Political Interest" ///
	dem_edugroup_x "Education (Categorical)" ///
	trust "Generalized Trust" efficacy "External Efficacy" govtherm "Fed. Govt. Attitudes") ///
 	order(intelligence knowcount polinterest campmediaindex ///
	democrat gop conservatism strength age female income college dem_edugroup_x hisp black online) style(tex)

********************************************************************************
** Figure Two
********************************************************************************
	
	// Run Full Model
	
svy: reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	college income female black hisp age  // Demos
	
	// Probe

margins, at(knowcount=0 knowcount=1)
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Political Knowledge") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black))
		
		graph save "mfx1", replace
	
margins, at(campmediaindex=0 campmediaindex=1)
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Campaign Media Attn.") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black))
	
		graph save "mfx2", replace

margins, at(polinterest=0 polinterest=1)
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Political Interest") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black))
	
		graph save "mfx3", replace

margins, at(college=0 college=1)
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("College Education")  ///
		xlabel(0 "No Coll." 1 "College") xtitle(" ") plot1opts(fcolor(white) lcolor(black))
	
		graph save "mfx4", replace
		
margins, at(income=0 income=1)
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Household Income")  ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black))
	
		graph save "mfx5", replace

margins, at(intelligence=0 intelligence=1)
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Intelligence (n.s.)")  ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black))
	
		graph save "mfx6", replace

		
	graph combine "mfx1" "mfx2" "mfx3" "mfx4" "mfx5" "mfx6", ycommon scheme(s1mono) cols(3)
		graph export "figure2.pdf", replace


********************************************************************************
* Table A1 - Re-estimation of Table 1 (Cols 1-4) with Ordered Probit
* RQ1: What shapes interviewer ratings of intelligence?
********************************************************************************

** Education = College Dummy; Pre

gen intel_pre_ordered=intel_pre*4
		fre intel_pre_ordered

svy: oprobit intel_pre_ordered intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID	
	college income female black hisp age // Demos
	
	est store a1_pre1

** Educaton = Full Educ; Post

svy: oprobit intel_pre_ordered intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age // Demos
	
	est store a1_pre2
	
	drop intel_pre_ordered
	
** Education = College Dummy; Post

	gen intel_post_ordered=intel_post*4
		fre intel_post_ordered

svy: oprobit intel_post_ordered intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	college income female black hisp age // Demos
	
	est store a1_post1

** Educaton = Full Educ; Post

svy: oprobit intel_post_ordered intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age // Demos
	
	est store a1_post2
	
	drop intel_post_ordered
	
	
** Table A1
	
estout a1_pre1 a1_pre2 a1_post1 a1_post2,  ///
 	cells(b (star fmt(2)  vacant("-")) se(par(( )))) ///
  	starlevels(+ 0.10 * 0.05) stats(N, fmt(0)) ///
  	varlabels(intelligence "Intelligence" knowcount "Pol. Know." ///
	democrat "Democrat" gop "Republican" conservatism "Conservatism" ///
	age "Age" female "Female" income "Income" college "College" campmediaindex "Media Use (Index)" ///
	tvuse "Television" radiouse "Radio" newspaperuse "Newspaper" internetuse "Internet" siteuse "Camp. Sites" /// 
	_cons "Constant" hisp "Hispanic" black "Black" open "Openness" ///
	online "Internet Mode" strength "Strength" ///
	consci "Conscientiousness" agree "Agreeableness" extra "Extraversion" ///
	neuro "Neuroticism" ne "Need to Eval" author "Authoritarianism" polinterest "Political Interest" ///
	dem_edugroup_x "Education (Categorical)" ///
	trust "Generalized Trust" efficacy "External Efficacy" govtherm "Fed. Govt. Attitudes") ///
 	order(intelligence knowcount polinterest campmediaindex ///
	democrat gop conservatism strength age female income college dem_edugroup_x hisp black online) style(tex)

	
	
********************************************************************************
* Table A2 - Re-estimation of Table 1 (Cols 1-4) with Ordered Probit
* RQ1: What shapes interviewer ratings of INFORMATION?
********************************************************************************

gen info_prepost=(info_pre + info_post)/2
	label values info_prepost hl
	label variable info_prepost "Combined Intelligence Rating"
	fre info_prepost

pwcorr info_prepost intel_prepost [fw=junkwt]

** Education = College Dummy; Pre

svy: reg info_pre intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID	
	college income female black hisp age // Demos
	
	est store a2_pre1

** Educaton = Full Educ; Post

svy: reg info_pre intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age // Demos
	
	est store a2_pre2
	
** Education = College Dummy; Post

svy: reg info_post intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	college income female black hisp age // Demos
	
	est store a2_post1

** Educaton = Full Educ; Post

svy: reg info_post intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age  // Demos
	
	est store a2_post2
	
** Full Intelligence Outcome (Prepost)
	
	pwcorr info_pre info_post
	
svy: reg info_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	college income female black hisp age // Demos
	
	est store prepost2a
	
** Full Intelligence Outcome (Prepost)
	
	pwcorr info_pre info_post
	
svy: reg info_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	dem_edugroup_x income female black hisp age // Demos
	
	est store prepost2b
	

	
** Table A1
	
estout a2_pre1 a2_pre2 a2_post1 a2_post2 prepost2a prepost2b,  ///
 	cells(b (star fmt(2)  vacant("-")) se(par(( )))) ///
  	starlevels(+ 0.10 * 0.05) stats(N, fmt(0)) ///
  	varlabels(intelligence "Intelligence" knowcount "Pol. Know." ///
	democrat "Democrat" gop "Republican" conservatism "Conservatism" ///
	age "Age" female "Female" income "Income" college "College" campmediaindex "Media Use (Index)" ///
	tvuse "Television" radiouse "Radio" newspaperuse "Newspaper" internetuse "Internet" siteuse "Camp. Sites" /// 
	_cons "Constant" hisp "Hispanic" black "Black" open "Openness" ///
	online "Internet Mode" strength "Strength" ///
	consci "Conscientiousness" agree "Agreeableness" extra "Extraversion" ///
	neuro "Neuroticism" ne "Need to Eval" author "Authoritarianism" polinterest "Political Interest" ///
	dem_edugroup_x "Education (Categorical)" ///
	trust "Generalized Trust" efficacy "External Efficacy" govtherm "Fed. Govt. Attitudes") ///
 	order(intelligence knowcount polinterest campmediaindex ///
	democrat gop conservatism strength age female income college dem_edugroup_x hisp black online) style(tex)

	
** Summary Correlation


graph twoway (scatter intel_prepost info_prepost, scheme(s1mono) jitter(15) mcolor(white) mlcolor(gs8)) ///
	(lfit intel_prepost info_prepost, lpattern(dash) lcolor(black) lwidth(thick) ///
		xtitle(" ") legend(off) title(" ") ytitle("Intelligence Rating") xtitle("Information Rating") ///
		note("Weighted r = 0.80", ring(0) position(4)))
		
		graph export "infointel.pdf", replace

		
	
********************************************************************************
* Table A3 - Collinearity Check 
* Columns 5-6 of Table One
********************************************************************************

** Education = College Dummy; Pre

reg intel_pre intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID	
	college income female black hisp age [pw=weight_ftf] // Demos
	
	estat vif

** Educaton = Full Educ; Post

reg intel_pre intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age [pw=weight_ftf] // Demos
	
	estat vif
	
** Education = College Dummy; Post

reg intel_post intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	college income female black hisp age [pw=weight_ftf] // Demos

	estat vif

** Educaton = Full Educ; Post

reg intel_post intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID
	dem_edugroup_x income female black hisp age [pw=weight_ftf] // Demos
	
	estat vif

** Full Intelligence Outcome (Prepost)
	
reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	college income female black hisp age [pw=weight_ftf] // Demos
	
	estat vif

	
reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	dem_edugroup_x income female black hisp age [pw=weight_ftf] // Demos
	
	estat vif

	
	
	
********************************************************************************
* Table A4 - Re-Run of Table One with Clustered Robust Standard Errors
* Just columns 5-6
********************************************************************************


** Full Intelligence Outcome (Prepost)
	
reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	college income female black hisp age [pw=weight_ftf], /// Demos
	robust cluster(caseid)
	
	est store a4a
	
reg intel_prepost intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	democrat gop conservatism strength /// PID
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	dem_edugroup_x income female black hisp age [pw=weight_ftf], /// Demos
	robust cluster(caseid)
	
	est store a4b
	

** Table One
	
estout a4a a4b,  ///
 	cells(b (star fmt(2)  vacant("-")) se(par(( )))) ///
  	starlevels(+ 0.10 * 0.05) stats(N, fmt(0)) ///
  	varlabels(intelligence "Intelligence" knowcount "Pol. Know." ///
	democrat "Democrat" gop "Republican" conservatism "Conservatism" ///
	age "Age" female "Female" income "Income" college "College" campmediaindex "Media Use (Index)" ///
	tvuse "Television" radiouse "Radio" newspaperuse "Newspaper" internetuse "Internet" siteuse "Camp. Sites" /// 
	_cons "Constant" hisp "Hispanic" black "Black" open "Openness" ///
	online "Internet Mode" strength "Strength" ///
	consci "Conscientiousness" agree "Agreeableness" extra "Extraversion" ///
	neuro "Neuroticism" ne "Need to Eval" author "Authoritarianism" polinterest "Political Interest" ///
	dem_edugroup_x "Education (Categorical)" ///
	trust "Generalized Trust" efficacy "External Efficacy" govtherm "Fed. Govt. Attitudes") ///
 	order(intelligence knowcount polinterest campmediaindex ///
	democrat gop conservatism strength age female income college dem_edugroup_x hisp black online) style(tex)


	
********************************************************************************
* Figure A1 & A2 - F3, but Probing Pr(Highly Intel) from Ordered Models
* Just PRE, College
********************************************************************************

cd "/Users/mmotta/Google Drive/Minnesota/Look Smart/R&P Submission/R&R/"


** Education = College Dummy; Pre

gen intel_pre_ordered=intel_pre*4
		fre intel_pre_ordered

svy: oprobit intel_pre_ordered intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID	
	college income female black hisp age // Demos
	
	
margins, at(knowcount=0 knowcount=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Political Knowledge") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle("Pr(Much Above Avg.)" " ")
		
		graph save "mfx1", replace
	
margins, at(campmediaindex=0 campmediaindex=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Campaign Media Attn.") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx2", replace

margins, at(polinterest=0 polinterest=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Political Interest") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx3", replace

margins, at(college=0 college=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("College Education")  ///
		xlabel(0 "No Coll." 1 "College") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle("Pr(Much Above Avg.)" " ")
	
		graph save "mfx4", replace
		
margins, at(income=0 income=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Household Income")  ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx5", replace

margins, at(intelligence=0 intelligence=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Intelligence (n.s.)")  ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx6", replace

		
	graph combine "mfx1" "mfx2" "mfx3" "mfx4" "mfx5" "mfx6", ycommon scheme(s1mono) cols(3)
		graph export "fa1.pdf", replace

		
** Education = College Dummy; Pre

gen intel_post_ordered=intel_post*4
		fre intel_post_ordered

svy: oprobit intel_post_ordered intelligence /// Cognitive Ability
	knowcount campmediaindex polinterest /// Motivation (POL)
	extra agree consci neuro open ne author /// Motivatoin (PSYCH)
	democrat gop conservatism strength /// PID	
	college income female black hisp age // Demos
	
	
margins, at(knowcount=0 knowcount=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Political Knowledge") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle("Pr(Much Above Avg.)" " ")
		
		graph save "mfx1", replace
	
margins, at(campmediaindex=0 campmediaindex=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Campaign Media Attn.") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx2", replace

margins, at(polinterest=0 polinterest=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Political Interest") ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx3", replace

margins, at(college=0 college=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("College Education")  ///
		xlabel(0 "No Coll." 1 "College") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle("Pr(Much Above Avg.)" " ")
	
		graph save "mfx4", replace
		
margins, at(income=0 income=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Household Income")  ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx5", replace

margins, at(intelligence=0 intelligence=1) predict(outcome(4))
	marginsplot, recast(bar) recastci(rspike) scheme(s1mono) title("Intelligence (n.s.)")  ///
		xlabel(0 "Lowest" 1 "Highest") xtitle(" ") plot1opts(fcolor(white) lcolor(black)) ///
		ytitle(" ")
	
		graph save "mfx6", replace

		
	graph combine "mfx1" "mfx2" "mfx3" "mfx4" "mfx5" "mfx6", ycommon scheme(s1mono) cols(3)
		graph export "fa2.pdf", replace

