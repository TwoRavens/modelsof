qui set more off 
capture cd "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/Kstan_Data/"
*capture cd "C:\Dropbox\ICC Kyrgyzstan\Kstan_Data\"

use kstan_working_2016_05_21.dta, clear


global ctrls_old approve_gov1 uzbek_nat age_under50 male postsec_educ employed income_av
global ctrls uzbek_nat age_under50 male postsec_educ employed income_av
global full heard_icc kyrgyzlang age_under50 male postsec_educ employed income_av govsatis getbetter sarah_tmt
global dvs approve_inv approve_inv_num approve_icc approve_icc_num dkrta

label var tmt "Treatment"
label var approve_gov1 "Kyrgyz Gov. Approv."
label var uzbek_nat "Uzbek"
label var age_under50 "Under 50"
label var male "Male"
label var postsec_educ "Any PS Educ."
label var employed "Employed"
label var income_av "Income Ab. Av."




***
* Summary statistics table
* Table 1 in manuscript
***

* Summary Statistics Table, Top (Full, Osh/NO, Osh subregions) Bottom (Other regions)
estpost su tmt $dvs heard_icc $ctrls
	est store full
estpost su tmt $dvs heard_icc $ctrls if oshobjal == 0
	est store osh
estpost su tmt $dvs heard_icc $ctrls if oshobjal == 1
	est store nonosh
forvalues r = 1(1)9 {
	estpost su tmt $dvs heard_icc $ctrls if region == `r'
		est store region`r'
		}
*	* Making the table just Full/Osh/NonOsh
	esttab full osh nonosh region9 region6 region7 ///
		using "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/sumstatstop.tex", replace ///
		cells(mean(fmt(2))) nodep nonum  ///
		mtitle("Full" "Osh/Ob./Jal." "Non-Osh" "Osh city" "Osh oblast" "Jalal-Abad") ///
		coeflabels(tmt "Treatment" approve_inv "App. Inv." approve_inv_num "App. Inv. Num." approve_icc "App. ICC" approve_icc_num "App. ICC Num." dkrta "DK/RTA" ///
		heard_icc "Heard of ICC" approve_gov1 "Government Approval" uzbek_nat "Uzbek" kyrgyzlang "Kyrgyz Lang." age_under50 "Age Under 50" male "Male" postsec_educ "Post Sec. Ed." employed "Employed" income_av "Inc. Aver.") ///

	esttab region1 region2 region3 region4 region5 region8  ///
		using "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/sumstatsbot.tex", replace ///
		cells(mean(fmt(2))) nodep nonum  ///
		mtitle("Bishkek" "Chui" "Issyk-Kul" "Naryn" "Talas" "Batken") ///
		coeflabels(tmt "Treatment" approve_inv "App. Inv." approve_inv_num "App. Inv. Num." approve_icc "App. ICC" approve_icc_num "App. ICC Num." dkrta "DK/RTA"  ///
		heard_icc "Heard of ICC" approve_gov1 "Government Approval" uzbek_nat "Uzbek" kyrgyzlang "Kyrgyz Lang." age_under50 "Age Under 50" male "Male" postsec_educ "Post Sec. Ed." employed "Employed" income_av "Inc. Aver.") ///


		
		
		

***
* Descriptive Analysis:
* In appendix A1.1-1.3
***


* Simple descriptor of treatment effects table (Inv) (Table 1, Appendix):
* Top half
bysort tmt: su approve_inv if dkrta == 0
reg approve_inv tmt if dkrta == 0
* Bottom half
bysort tmt: tab Q15 if dkrta == 0

* Simple descriptor of treatment effects table (ICC) (Table 3, Appendix):
* Top half
bysort tmt: su approve_icc if dkrta_icc == 0
reg approve_icc tmt if dkrta_icc == 0
* Bottom half
bysort tmt: tab Q16 if dkrta_icc == 0



***
* Appendix figures, distributions of categorical approval levels
*	In appendix, Figures 1-6
***

/*
preserve
* Recoding so that higher numbers mean more approval
recode Q15 (4=1) (3=2) (2=3) (1=4)
recode Q16 (4=1) (3=2) (2=3) (1=4)

* Distributions of approve_inv, by treatment and control
qui twoway (hist Q15 if tmt == 1 & Q15 != 5, color(gray)) ///
	(hist Q15 if tmt == 0 & Q15 != 5, fcolor(none) lcolor(black)), ///
	legend(order(1 "Treatment" 2 "Control"))
	graph export "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/approve_inv_dist.eps", as(eps) preview(off) replace

* Distributions of approve_icc, by treatment and control
qui twoway (hist Q16 if tmt == 1 & Q16 != 5, color(gray)) ///
	(hist Q16 if tmt == 0 & Q16 != 5, fcolor(none) lcolor(black)), ///
	legend(order(1 "Treatment" 2 "Control"))
	graph export "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/approve_icc_dist.eps", as(eps) preview(off) replace

* Distributions of approve_inv, by treatment and control, for Osh
qui twoway (hist Q15 if tmt == 1 & Q15 != 5 & oshobjal == 1, color(gray) bin(19)) ///
	(hist Q15 if tmt == 0 & Q15 != 5 & oshobjal == 1, fcolor(none) lcolor(black) bin(19)), ///
	legend(order(1 "Treatment" 2 "Control"))
	graph export "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/approve_inv_dist_osh.eps", as(eps) preview(off) replace

	* Distributions of approve_icc, by treatment and control, for Osh
qui twoway (hist Q16 if tmt == 1 & Q16 != 5 & oshobjal == 1, color(gray) bin(19)) ///
	(hist Q16 if tmt == 0 & Q16 != 5 & oshobjal == 1, fcolor(none) lcolor(black) bin(19)), ///
	legend(order(1 "Treatment" 2 "Control"))
	graph export "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/approve_icc_dist_osh.eps", as(eps) preview(off) replace

* Distributions of approve_inv, by treatment and control, for non-Osh
qui twoway (hist Q15 if tmt == 1 & Q15 != 5 & oshobjal == 0, color(gray)) ///
	(hist Q15 if tmt == 0 & Q15 != 5 & oshobjal == 0, fcolor(none) lcolor(black)), ///
	legend(order(1 "Treatment" 2 "Control"))
	graph export "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/approve_inv_dist_nonosh.eps", as(eps) preview(off) replace
		
* Distributions of approve_icc, by treatment and control, for non-Osh
qui twoway (hist Q16 if tmt == 1 & Q16 != 5 & oshobjal == 0, color(gray)) ///
	(hist Q16 if tmt == 0 & Q16 != 5 & oshobjal == 0, fcolor(none) lcolor(black)), ///
	legend(order(1 "Treatment" 2 "Control"))
	graph export "/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/approve_icc_dist_nonosh.eps", as(eps) preview(off) replace

restore
*/	
	
	
***
* Analysis: Logit Regressions
* In appendix A1.1-1.3
***

* Setup commands for the regressions

xtset region
*preserve
replace approve_inv = . if Q15 == 5
replace approve_icc = . if Q16 == 5
	* Both the tables above and these regressions exclude the DKRTAs.  This section does the exclusion here.  The top section has "if dkrta == 0" and "if dkrta_icc == 0".

*	Regression Treatment effects, logit	(Appendix Tables 2 and 4)
foreach dv in inv icc {
logit approve_`dv' tmt, cluster(region)
	est2vec `dv'_ndkrta, replace name(`dv'1) vars(tmt $ctrls _cons)
xtlogit approve_`dv' tmt, fe
	est2vec `dv'2, replace name(fereg) addto(`dv'_ndkrta)
logit approve_`dv' tmt $ctrls, cluster(region)
	est2vec `dv'2, replace name(ctrls) addto(`dv'_ndkrta)
xtlogit approve_`dv' tmt $ctrls, fe
	est2vec `dv'2, replace name(fectrls) addto(`dv'_ndkrta)
	est2tex `dv'_ndkrta, preserve label path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero
	}
*


***
* Heard of ICC and Gov Appr Interaction terms
***
*	For the investigations DV, in A1.1-1.3; Table 5
gen tmt_aware = tmt*heard_icc
gen govapp = .
replace govapp = 1 if Q7 == 1 | Q7 == 2
replace govapp = 0 if Q7 == 3 | Q7 == 4
gen tmt_govapp = tmt*govapp

* Heard of ICC, Investigation DV, Table 9 in Appendix
logit approve_inv tmt heard_icc tmt_aware, cluster(region)
	est2vec aware_ndkrta, replace name(aware1) vars(tmt heard_icc tmt_aware $ctrls _cons)
xtlogit approve_inv tmt heard_icc tmt_aware, fe
	est2vec aware2, replace name(fe) addto(aware_ndkrta)
logit approve_inv tmt heard_icc tmt_aware $ctrls, cluster(region)
	est2vec aware2, replace name(ctrlclust) addto(aware_ndkrta)
xtlogit approve_inv tmt heard_icc tmt_aware $ctrls
	est2vec aware2, replace name(fectrl) addto(aware_ndkrta)
	est2tex aware_ndkrta, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero

bysort tmt: su approve_inv if heard_icc == 1
bysort tmt: su approve_inv if heard_icc == 0	
	
* Government approval, investigation DV, Table 8
logit approve_inv tmt govapp tmt_govapp, cluster(region)
	est2vec govapp_ndkrta, replace name(aware1) vars(tmt govapp tmt_govapp $ctrls _cons)
xtlogit approve_inv tmt govapp tmt_govapp, fe
	est2vec govapp2, replace name(fe) addto(govapp_ndkrta)
logit approve_inv tmt govapp tmt_govapp $ctrls, cluster(region)
	est2vec govapp2, replace name(ctrl) addto(govapp_ndkrta)
xtlogit approve_inv tmt govapp tmt_govapp $ctrls, fe
	est2vec govapp2, replace name(fectrl) addto(govapp_ndkrta)
	est2tex govapp_ndkrta, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero

*	For the ICC DV, contained in the appendix, Table 6

logit approve_icc tmt heard_icc tmt_aware, cluster(region)
	est2vec aware_ndkrta_icc, replace name(aware1) vars(tmt heard_icc tmt_aware $ctrls _cons)
xtlogit approve_icc tmt heard_icc tmt_aware, fe
	est2vec aware2, replace name(fe) addto(aware_ndkrta_icc)
logit approve_icc tmt heard_icc tmt_aware $ctrls, cluster(region)
	est2vec aware2, replace name(ctrlclust) addto(aware_ndkrta_icc)
xtlogit approve_icc tmt heard_icc tmt_aware $ctrls
	est2vec aware2, replace name(fectrl) addto(aware_ndkrta_icc)
	est2tex aware_ndkrta_icc, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero

logit approve_icc tmt govapp tmt_govapp, cluster(region)
	est2vec govapp_ndkrta_icc, replace name(aware1) vars(tmt govapp tmt_govapp $ctrls _cons)
xtlogit approve_icc tmt govapp tmt_govapp, fe
	est2vec govapp2, replace name(fe) addto(govapp_ndkrta_icc)
logit approve_icc tmt govapp tmt_govapp $ctrls, cluster(region)
	est2vec govapp2, replace name(ctrl) addto(govapp_ndkrta_icc)
xtlogit approve_icc tmt govapp tmt_govapp $ctrls, fe
	est2vec govapp2, replace name(fectrl) addto(govapp_ndkrta_icc)
	est2tex govapp_ndkrta_icc, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero

	
		
***
* Apendix A1,4: Uzbek/Non-Uzbek Analysis, Full, and Osh/Ob/Jal vs non-Osh
***
*		These are the logit regressions to match the Uzbek/Non Uzbek Beta Figures
* 		Table 7
gen uzbek_tmt = uzbek_nat*tmt

foreach dv in inv icc  {
 logit approve_`dv' tmt uzbek_nat uzbek_tmt, cluster(region)
	est2vec uzbek`dv'_ndkrta_bot, replace name(`dv'1) vars(tmt uzbek_tmt $ctrls _cons)
 logit approve_`dv' tmt uzbek_tmt $ctrls, cluster(region)
	est2vec `dv'2, replace name(wctrls) addto(uzbek`dv'_ndkrta_bot)

 logit approve_`dv' tmt uzbek_nat uzbek_tmt if oshobjal == 1, cluster(region)
	est2vec `dv'2, replace name(osh) addto(uzbek`dv'_ndkrta_bot)
 logit approve_`dv' tmt uzbek_tmt $ctrls if oshobjal == 1, cluster(region)
	est2vec `dv'2, replace name(oshwctrls) addto(uzbek`dv'_ndkrta_bot)

	est2tex uzbek`dv'_ndkrta_bot, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero
	}
*
	
	
***
* Apendix A1.7: Analysis WITH the DKRTA responses, coded as non-approval
***

gen approve_inv_wdkrta = approve_inv	
replace approve_inv_wdkrta = 0 if Q15 == 5

gen approve_icc_wdkrta = approve_icc	
replace approve_icc_wdkrta = 0 if Q16 == 5

* Simple table, Table 10
tab approve_inv_wdkrta
* Simple descriptor of treatment effects table (Inv):
bysort tmt: su approve_inv_wdkrta
reg approve_inv_wdkrta tmt
* Simple descriptor of treatment effects table (ICC):
bysort tmt: su approve_icc_wdkrta
reg approve_icc_wdkrta tmt

* Main logits table, Table 11
foreach dv in inv  {
logit approve_`dv'_wdkrta tmt, cluster(region)
	est2vec `dv'_ydkrta, replace name(`dv'1) vars(tmt $ctrls _cons)
xtlogit approve_`dv'_wdkrta tmt, fe
	est2vec `dv'2, replace name(fereg) addto(`dv'_ydkrta)
logit approve_`dv'_wdkrta tmt $ctrls, cluster(region)
	est2vec `dv'2, replace name(ctrls) addto(`dv'_ydkrta)
xtlogit approve_`dv'_wdkrta tmt $ctrls, fe
	est2vec `dv'2, replace name(fectrls) addto(`dv'_ydkrta)
	est2tex `dv'_ydkrta, preserve label path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero
	}
*

* Awareness/Gov App Interactions, WITH DKRTA, Table 12
logit approve_inv_wdkrta tmt heard_icc tmt_aware, cluster(region)
	est2vec aware_ydkrta, replace name(aware1) vars(tmt heard_icc tmt_aware $ctrls _cons)
xtlogit approve_inv_wdkrta tmt heard_icc tmt_aware, fe
	est2vec aware2, replace name(fe) addto(aware_ydkrta)
logit approve_inv_wdkrta tmt heard_icc tmt_aware $ctrls, cluster(region)
	est2vec aware2, replace name(ctrlclust) addto(aware_ydkrta)
xtlogit approve_inv_wdkrta tmt heard_icc tmt_aware $ctrls
	est2vec aware2, replace name(fectrl) addto(aware_ydkrta)
	est2tex aware_ydkrta, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero

logit approve_inv_wdkrta tmt govapp tmt_govapp, cluster(region)
	est2vec govapp_ydkrta, replace name(aware1) vars(tmt govapp tmt_govapp $ctrls _cons)
xtlogit approve_inv_wdkrta tmt govapp tmt_govapp, fe
	est2vec govapp2, replace name(fe) addto(govapp_ydkrta)
logit approve_inv_wdkrta tmt govapp tmt_govapp $ctrls, cluster(region)
	est2vec govapp2, replace name(ctrl) addto(govapp_ydkrta)
xtlogit approve_inv_wdkrta tmt govapp tmt_govapp $ctrls, fe
	est2vec govapp2, replace name(fectrl) addto(govapp_ydkrta)
	est2tex govapp_ydkrta, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero
	
	
	

	
	
	
***
* Apendix A1.8: Effect of treatment on DKRTA
* Table 13
***

* Did treatment effect likelihood of DKRTA?
gen dkrta_inv = dkrta

foreach dv in dkrta_inv {
	logit `dv' tmt
	est2vec any`dv'_fx, replace name(`dv'1) vars(tmt)

	logit `dv' tmt if oshobjal == 1
	est2vec `dv'2, replace name(osh) addto(any`dv'_fx)
	logit `dv' tmt if oshobjal == 0
	est2vec `dv'2, replace name(nonosh) addto(any`dv'_fx)

	logit `dv' tmt if uzbek_nat == 1
	est2vec `dv'2, replace name(uzbek) addto(any`dv'_fx)
	logit `dv' tmt if uzbek_nat == 0
	est2vec `dv'2, replace name(nonuzbek) addto(any`dv'_fx)

	logit `dv' tmt if uzbek_nat == 1 & oshobjal == 1
	est2vec `dv'2, replace name(uzbekooj) addto(any`dv'_fx)
	
	
	est2tex any`dv'_fx, preserve path("/Users/robertchaudoin/Dropbox/ICC Kyrgyzstan/CC_KStan_Drafts/") mark(stars) fancy replace levels(90 95 99) leadzero
	}
*
	
	
	
	
	
	
	
	
	

	
	
	
	
	
