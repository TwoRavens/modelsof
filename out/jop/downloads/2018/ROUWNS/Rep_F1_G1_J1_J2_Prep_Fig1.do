
* Tuungane -> women empowerment paper

* Need to install the function "parmby"
* Then only thing to change is the working directory below
* Output is saved to .xls (for tables) and .dta file (for figure)

* This do-files
	* Prepares all variables
	* Creates summary info (for table in appendix)
	* Creates attrition info (for table in appendix)
	* Analyses T1 -> women empowerment
		* all variables (except TUUNGANE) are standardized (mean=0, sd=1)
		* all analysis using fixed effects and clustering at CDC
	* Does all of the above by outcome variable (same order as in paper)
	* Finally, also explores whether policy results are driven by a preference of women
	
	clear
	clear mata
	set more off

* Set working directory (everything runs in same directory):
	cd "C:\Users\Peter\Dropbox\drc_womenempowerment\03_analysis"
	
* Run code for weighted index
	do Prog_MFI.do

* Initialize Excel document to store results
	est clear
		set obs 100
		gen Y=uniform()
		gen X=uniform()
		eststo: reg Y X
		estout using "summary.xls", replace keep() cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(NOTHING)
		estout using "summary_regs.xls", replace keep() cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(NOTHING)
	est clear
	
***********
* INFO: How much Step A/B/C/D data was collected?
***********

	** Merge data files together
	use DRC2012_ABD_INDIV_v2.dta, clear
	merge m:1 IDV using DRC2012_ABD_VILL_v2.dta
	drop _m
	merge m:1 IDV using TUUNGANE_v2.dta
	drop _m
	egen tagV=tag(IDV)
	
* Step A: 457 villages any data collected
	* =1 if anything was collected during step A in that village
	* i.e. (a_3_date_village_entry a_6_animateur_code am_3_ag_date) not empty
	g stepAx=1 if a_3_date_village_entry!="" | a_6_animateur_code!="" | am_3_ag_date!=""
	replace stepAx=0 if stepAx!=1
	by IDV, sort: egen stepA=mean(stepAx)
	tab stepA if tag==1
	
* Step B: 454. but some different than A
	* =1 if anything was collected during step D in that village
	* i.e. (b_3_date, b_4_hour, b_32_chief_imposed_C_menFG1, b10_rep_role_Rep1) not empty
	g stepBx=1 if b_3_date!="" | b_4_hour!="" | b_32_chief_imposed_C_menFG1!=. | b10_rep_role_Rep1!=.
	replace stepBx=0 if stepBx!=1
	by IDV, sort: egen stepB=mean(stepBx)
	tab stepB if tag==1

* Step D: 816 villages	
* Step D: 413 RAPID villages	
* Step D: 403 control villages	
	* =1 if anything was collected during step D in that village
	* i.e. (cq001_name_chefferie, cq007_date, dr000_date_Rep1, q000_consent_beg) not empty
	g stepDx=1 if cq001_name_chefferie!="" | cq007_date!="" | dr000_date_Rep1!="" | q000_consent_beg!=""
	replace stepDx=0 if stepDx!=1
	by IDV, sort: egen stepD=max(stepDx)
	tab stepD IDV_RAPID if tag==1	
	tab stepD IDS_DIS if tag==1	

* Step D households: 3,881 DML, 1,863 DMC

	g stepDhh=2 if q007_date!="" & q008_time!="" & q011_sex!=.
	tab stepDhh IDS_TYPE if stepD==1		

* Step D chief interviews
	* Data collected if (cq007_date cq010_chief_or_aid) are not empty for at least one observation of a village
	g something=1 if cq007_date!="" | cq010_chief_or_aid!=""
	by IDV, sort: egen somethingV =total(something)
	replace somethingV=1 if somethingV>0 & somethingV!=.
	tab somethingV if tagV==1,m
	
keep IDV IDS IDS_TYPE IDV_RAPID stepA stepB stepD stepDhh
keep if IDS_TYPE=="DML"
save collected.dta,replace
	
**********
* Outcome: Women's role in community
**********

** RAPID presence (Step A)

	* Get data
	use DRC2012_ABD_VILL_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	preserve
		use collected.dta,clear
		duplicates drop IDV, force
		tab stepA
		save collected_v.dta,replace	
	restore
	merge 1:1 IDV using collected_v.dta
	
	* Prep variable
	tab am_8_women_beg 
	tab am_9_men_beg
	replace am_9_men_beg=. if am_9_men_beg>1000	
	g sharewomenA = am_8_women_beg /(am_8_women_beg + am_9_men_beg) if am_8_women_beg!=. & am_9_men_beg!=.

	* Summary info
	summ am_8_women_beg
	summ am_9_men_beg
	summ sharewomenA
	est clear
	estpost summ sharewomenA
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ sharewomenA if TUUNGANE==1 
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ sharewomenA if TUUNGANE==0 
	estout using "summary.xls", append cells("count mean sd min max")
	est clear
	eststo:	areg sharewomenA TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)
	estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(sharewomenA)
	est clear
	
	* Attrition info
	g missing=0 
	replace missing= 1 if sharewomenA==. & IDV_RAPID==1
	tab sharewomenA
	tab missing stepA
	tab missing TUUNGANE
	reg missing TUUNGANE
	
	* Standardize
	foreach var of varlist sharewomenA{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}
	
	* Results
	parmby "areg sharewomenA TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)", lab saving(sharewomenA,replace) 
	
** Discussion dynamics (Step A)

	* Get data
	use DRC2012_A_DISC_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	preserve
		use collected.dta,clear
		duplicates drop IDV, force
		tab stepA
		save collected_v.dta,replace	
	restore
	drop IDV_RAPID
	merge n:1 IDV using collected_v.dta
	
	* Prep variable
	recode ad1_3_gender (1=0) (0=1)
	by IDV, sort: egen total_women=total(ad1_3_gender)
	recode ad1_3_gender (1=0) (0=1)
	by IDV, sort: egen total_men=total(ad1_3_gender)
	replace total_women=. if total_women==0 & total_men==0
	replace total_men=. if total_women==. & total_men==0
	g sharewomenDiscus= total_women/ (total_women + total_men)
	replace sharewomenDiscus=. if total_women==. & total_men==.
	duplicates drop IDV, force
	
	* Summary info
	est clear
	estpost summ sharewomenDiscus
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ sharewomenDiscus if TUUNGANE==1 
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ sharewomenDiscus if TUUNGANE==0 
	estout using "summary.xls", append cells("count mean sd min max")
	est clear
	eststo:	areg sharewomenDiscus TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)
	estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(sharewomenDiscus)
	est clear

	
	* Attrition info
	g missing=0 
	replace missing= 1 if sharewomenDiscus==. & IDV_RAPID==1
	tab missing stepA
	tab missing TUUNGANE
	reg missing TUUNGANE

	* Standardize
	foreach var of varlist sharewomenDiscus{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}

	* Results
	parmby "areg sharewomenDiscus TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)", lab saving(sharewomenDiscus,replace) 

** Committee Composition (Step B)

	* Get data
	use DRC2012_ABD_VILL_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	preserve
		use collected.dta,clear
		duplicates drop IDV, force
		tab stepA
		save collected_v.dta,replace	
	restore
	merge n:1 IDV using collected_v.dta
	
	* Prep variable
	foreach num of numlist 1/8{
		tab b13_rep_gender_Rep`num',m
		g x`num'=1 if b13_rep_gender_Rep`num'!=.
	}
	egen TOT=rsum(x*)
	egen N_MAL=rsum(b13_rep_gender_Rep*)
	replace TOT=. if b13_rep_gender_Rep1==. & b13_rep_gender_Rep2==. & b13_rep_gender_Rep3==. & b13_rep_gender_Rep4==. & b13_rep_gender_Rep5==. & b13_rep_gender_Rep6==. & b13_rep_gender_Rep7==. & b13_rep_gender_Rep8
	replace N_MAL=. if b13_rep_gender_Rep1==. & b13_rep_gender_Rep2==. & b13_rep_gender_Rep3==. & b13_rep_gender_Rep4==. & b13_rep_gender_Rep5==. & b13_rep_gender_Rep6==. & b13_rep_gender_Rep7==. & b13_rep_gender_Rep8
	gen N_FEM=TOT-N_MAL
	gen SHAREcommittee = N_FEM/TOT
	
	* Summary info
	est clear
	estpost summ SHAREcommittee
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ SHAREcommittee if TUUNGANE==1 
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ SHAREcommittee if TUUNGANE==0 
	estout using "summary.xls", append cells("count mean sd min max")
	est clear
	eststo:	areg SHAREcommittee TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)
	estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(SHAREcommittee)
	est clear
	
	* Attrition information
	g missing=0 
	replace missing= 1 if SHAREcommittee==. & IDV_RAPID==1
	tab SHAREcommittee
	tab missing stepB
	tab missing TUUNGANE
	reg missing TUUNGANE
	
	* Standardize
	foreach var of varlist SHAREcommittee{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}

	* Results
	parmby "areg SHAREcommittee TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)", lab saving(SHAREcommittee,replace)

**********
* Outcome: Women within household
**********
	
** Within household: Time allocation
** Asked to DML only, and only in survey-only villages

	* Get data
	use DRC2012_ABD_INDIV_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	merge n:1 IDV IDS using collected.dta
	
	* Prep variable
	foreach var of varlist ut000_0to1- ut23_23to24{
		tab `var' q011
		replace `var'=. if `var'<0 
	}
	* laundry 21: only 8x in data
	* cooking 22:
	foreach var of  varlist ut000_0to1 - ut23_23to24{
		g `var'cooking= `var'==22
	}
	egen cooking=rsum(ut000_0to1c - ut23_23to24c)
	replace cooking=. if ut000_0to1==. & ut001_1to2==. & ut002_2to3==. & ut003_3to4==. & ut004_4to5==. & ut005_5to6==. & ut006_6to7==. & ut007_7to8==. & ut008_8to9==. & ut009_9to10==. & ut010_10to11==. & ut011_11to12==. & ut012_12to13==. & ut013_13to14==. & ut014_14to15==. & ut15_15to16==. & ut16_16to17==. & ut17_17to18==. & ut18_18to19==. & ut19_19to20==. & ut20_20to21==. & ut21_21to22==. & ut22_22to23==. & ut23_23to24==.
	* collecting firewood 23: not in data
	* collecting water 24:
	foreach var of varlist ut000_0to1 - ut23_23to24{
		g `var'water= `var'==24
	}
	egen water=rsum(ut000_0to1w - ut23_23to24w)
	replace water=. if ut000_0to1==. & ut001_1to2==. & ut002_2to3==. & ut003_3to4==. & ut004_4to5==. & ut005_5to6==. & ut006_6to7==. & ut007_7to8==. & ut008_8to9==. & ut009_9to10==. & ut010_10to11==. & ut011_11to12==. & ut012_12to13==. & ut013_13to14==. & ut014_14to15==. & ut15_15to16==. & ut16_16to17==. & ut17_17to18==. & ut18_18to19==. & ut19_19to20==. & ut20_20to21==. & ut21_21to22==. & ut22_22to23==. & ut23_23to24==.
	* house cleaning 25:
	foreach var of  varlist ut000_0to1 - ut23_23to24{
		g `var'house= `var'==25
	}
	egen house=rsum(ut000_0to1h - ut23_23to24h)
	replace house=. if ut000_0to1==. & ut001_1to2==. & ut002_2to3==. & ut003_3to4==. & ut004_4to5==. & ut005_5to6==. & ut006_6to7==. & ut007_7to8==. & ut008_8to9==. & ut009_9to10==. & ut010_10to11==. & ut011_11to12==. & ut012_12to13==. & ut013_13to14==. & ut014_14to15==. & ut15_15to16==. & ut16_16to17==. & ut17_17to18==. & ut18_18to19==. & ut19_19to20==. & ut20_20to21==. & ut21_21to22==. & ut22_22to23==. & ut23_23to24==.
	* leisure 50:
	foreach var of  varlist ut000_0to1 - ut23_23to24{
		g `var'leisure= `var'==50
	}
	egen leisure=rsum(ut000_0to1l - ut23_23to24l)
	replace leisure=. if ut000_0to1==. & ut001_1to2==. & ut002_2to3==. & ut003_3to4==. & ut004_4to5==. & ut005_5to6==. & ut006_6to7==. & ut007_7to8==. & ut008_8to9==. & ut009_9to10==. & ut010_10to11==. & ut011_11to12==. & ut012_12to13==. & ut013_13to14==. & ut014_14to15==. & ut15_15to16==. & ut16_16to17==. & ut17_17to18==. & ut18_18to19==. & ut19_19to20==. & ut20_20to21==. & ut21_21to22==. & ut22_22to23==. & ut23_23to24==.
	* leisure in right direction for women
	g leisure2=leisure * -1

	g WEIGHT=1
	WMEANEFFECTS TUUNGANE WEIGHT cooking water house leisure2 if TUUNGANE!=., g(MFI_Timeuse)
	
	* DML only. Not RAPID only
	keep if IDS_TYPES=="DML"
	drop if IDS_RAPID==1
	
	* Summary info
	foreach var of varlist cooking water house leisure{
		est clear

		* women:
		estpost summ `var' if q011_==0
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==1 & q011_==0 
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==0 & q011_==0 
		estout using "summary.xls", append cells("count mean sd min max")
		est clear
		eststo:	areg `var' TUUNGANE if q011_==0,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)
		estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(`var')
		est clear

		* men:
		estpost summ `var' if q011_==1
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==1 & q011_==1
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==0 & q011_==1
		estout using "summary.xls", append cells("count mean sd min max")
		est clear
		eststo:	areg `var' TUUNGANE if q011_==1,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)
		estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(`var')
		est clear

	}
	
	* Attrition info
	foreach var of varlist cooking water house leisure{
		g missing=0 
		replace missing= 1 if `var'==.
		tab `var' if q011_==0
		tab missing stepD if q011_==0
		tab missing TUUNGANE if q011_==0
		reg missing TUUNGANE if q011_==0
		tab `var' if q011_==1
		tab missing stepD if q011_==1
		tab missing TUUNGANE if q011_==1
		reg missing TUUNGANE if q011_==1
		drop missing
	}
	
	* Standardize
	foreach var of varlist cooking water house leisure2{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}

	* Results
	parmby "areg MFI_Timeuse TUUNGANE if q011_==0,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)", lab saving(MFI_Timeuse_f,replace) 
	parmby "areg MFI_Timeuse TUUNGANE if q011_==1,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)", lab saving(MFI_Timeuse_m,replace) 

** Domestic violence
** DML only

	* Get data
	use DRC2012_ABD_INDIV_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	merge n:1 IDV IDS using collected.dta
	
	* Prep variable
	g Treat_DomViol= v7_sensitive_2nd=="VB" & v7_sensitive_2nd!=""
	* Q 96 (VA). W Désaccords parmi les membres du ménage; X Manque de nourriture/ nutrition; Z Manque dřaccès à lřeau potable
	* Q 98 (VB). W Désaccords parmi les membres du ménage; X Manque de nourriture/ nutrition; Y Violence domestique; Z Manque dřaccès à lřeau potable

	* DML only
	keep if IDS_TYPES=="DML"
	
	* Summary info
	* For women
	estpost summ q9698_sensitive if q011_==0
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ q9698_sensitive if TUUNGANE==1 & q011_==0 
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ q9698_sensitive if TUUNGANE==0 & q011_==0 
	estout using "summary.xls", append cells("count mean sd min max")
	est clear
	eststo:	areg q9698_sensitive TUUNGANE if q011_==0,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)
	estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(q9698_sensitive)
	est clear

	* For men
	estpost summ q9698_sensitive if q011_==1
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ q9698_sensitive if TUUNGANE==1 & q011_==1 
	estout using "summary.xls", append cells("count mean sd min max")
	estpost summ q9698_sensitive if TUUNGANE==0 & q011_==1 
	estout using "summary.xls", append cells("count mean sd min max")
	est clear
	eststo:	areg q9698_sensitive TUUNGANE if q011_==1,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)
	estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(q9698_sensitive)
	est clear
	
	* Attrition info
	tab q9698_sensitive
	g missing=0 
	replace missing= 1 if q9698_sensitive==.
	tab missing stepD
	tab missing TUUNGANE
	reg missing TUUNGANE
	
	* Standardize
	foreach var of varlist q9698_sensitive Treat_DomViol{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}
	
	* Results
	g DomViol_Tuun = Treat_DomViol*TUUNGANE
	parmby "areg q9698_sensitive Treat_DomViol TUUNGANE DomViol_Tuun if q011==0, cluster(IDS_CDCCODE) absorb(IDS_LOTT_BIN)", lab saving(list_f,replace)
	parmby "areg q9698_sensitive Treat_DomViol TUUNGANE DomViol_Tuun if q011==1, cluster(IDS_CDCCODE) absorb(IDS_LOTT_BIN)", lab saving(list_m,replace)

**********
* Outcome: RAPID project choice
**********

	* Get data
	use DRC2012_ABD_VILL_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	preserve
		use collected.dta,clear
		duplicates drop IDV, force
		tab stepA
		save collected_v.dta,replace	
	restore
	merge n:1 IDV using collected_v.dta
	
	* Prep variable
	* put projects into categories
	g RAPIDhealth=1 if b_23_project_has_been_chosen==21
	g RAPIDeducation=1 if b_23_project_has_been_chosen==20
	g RAPIDtransport=1 if b_23_project_has_been_chosen==26 | b_23_project_has_been_chosen==7 | b_23_project_has_been_chosen==46
	g RAPIDwatsan=1 if b_23_project_has_been_chosen==1 | b_23_project_has_been_chosen==2
	g RAPIDagriculture=1 if b_23_project_has_been_chosen==25 | b_23_project_has_been_chosen==19 | b_23_project_has_been_chosen==23 | b_23_project_has_been_chosen==8 | b_23_project_has_been_chosen==32 | b_23_project_has_been_chosen==13 | b_23_project_has_been_chosen==24 | b_23_project_has_been_chosen==11 | b_23_project_has_been_chosen==33 | b_23_project_has_been_chosen==10
	g RAPIDother=1 if b_23_project_has_been_chosen==31 | b_23_project_has_been_chosen==29 | b_23_project_has_been_chosen==28 | b_23_project_has_been_chosen==6 | b_23_project_has_been_chosen==43 | b_23_project_has_been_chosen==5 | b_23_project_has_been_chosen==16 | b_23_project_has_been_chosen==4 | b_23_project_has_been_chosen==18
	foreach var of varlist RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
		replace `var'=0 if `var'==. & b_23_project_has_been_chosen!=.
	}

	* Summary info

	foreach var of varlist RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
		est clear
		estpost summ `var'
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==1 
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==0 
		estout using "summary.xls", append cells("count mean sd min max")
		est clear
		eststo:	areg `var' TUUNGANE,cluster(IDV_CDC) absorb(IDV_LOTT_BIN)
		estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(`var')
		est clear
	}
	
	* Attrition info
	foreach var of varlist RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
		tab `var'
		g missing=0 
		replace missing= 1 if `var'==. & IDV_RAPID==1
		tab missing stepB,m
		tab missing TUUNGANE
		reg missing TUUNGANE
		drop missing
	}
	
	* Standardize
	foreach var of varlist RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}
	
	* Results
	foreach depvar of varlist RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
	parmby "areg `depvar' TUUNGANE, cluster(IDV_CDCCODE) absorb(IDV_LOTT_BIN)", lab saving(`depvar',replace)
	}
	
**********
* Outcome: Attitudes
* DML only
**********

	* Get data
	use DRC2012_ABD_INDIV_v2.dta, clear
	g CDCCODE=IDS_CDCCODE
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	merge n:1 IDV IDS using collected.dta
	
	* Prep variable
	* Note 1: There was a variation. Att=0 or Att=1. 
	* Note 2: Some statements go from pos->neg, neg->pos
	* All answers structured: (1) 2 = (very) agree with left, 5 (6) = (very) agree with right, -9=dont know, 0 = indifferent
	* qg000_Att_version indicates which version the respondent received (GA or GB). Same questions only statements switch sides
	** When Att=0 (GA, or page 228 of "20110606 ODS.pdf"): FLTR: qg8: neg <-> pos; qg9: pos <-> neg; qg10: pos <-> neg; qg11: neg <-> pos
	** When Att=1 (GB, or page 229 of "20110606 ODS.pdf"): FLTR: qg8: pos <-> neg; qg9: neg <-> pos; qg10: neg <-> pos; qg11: pos <-> neg
	* Make everything 0-4 scale, from neg (0) to pos (4)	
	* att=0, neg<->pos
	recode qg008_women qg011_women_pres (6=2) (5=1) (-8=.) (-9=.) (-7=.) (0=0) (2=-1) (1=-2) if qg000_Att_version==0
	* att=0, pos<->neg
	recode qg009_mistreatment qg010_socioadmin (6=-2) (5=-1)  (-8=.) (-9=.) (-7=.) (0=0) (2=1) (1=2) if qg000_Att_version==0
	* att=1, pos<->neg
	recode qg008_women qg011_women_pres  (6=-2) (5=-1) (-8=.) (-9=.) (-7=.) (0=0) (2=1) (1=2) if qg000_Att_version==1
	* att=1, neg<->pos
	recode qg009_mistreatment qg010_socioadmin (6=2) (5=1) (-8=.) (-9=.) (-7=.) (0=0) (2=-1) (1=-2) if qg000_Att_version==1
	* DML only
	keep if IDS_TYPES=="DML"
	g WEIGHT=1
	WMEANEFFECTS TUUNGANE WEIGHT qg008_women qg009_mistreatment qg010_socioadmin qg011_women_pres if TUUNGANE!=., g(MFI_attitude)

	* Summary info
	foreach var of varlist qg008_women qg009_mistreatment qg010_socioadmin qg011_women_pres{
		* For women
		estpost summ `var' if q011_==0
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==1 & q011_==0 
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==0 & q011_==0 
		estout using "summary.xls", append cells("count mean sd min max")
		est clear
		eststo:	areg `var' TUUNGANE if q011_==0,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)
		estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(`var')
		est clear

		* For men
		estpost summ `var' if q011_==1
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==1 & q011_==1 
		estout using "summary.xls", append cells("count mean sd min max")
		estpost summ `var' if TUUNGANE==0 & q011_==1 
		estout using "summary.xls", append cells("count mean sd min max")
		est clear
		eststo:	areg `var' TUUNGANE if q011_==1,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)
		estout using "summary_regs.xls", append keep(TUUNGANE) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(`var')
		est clear
	}
	
	* Attrition info
	foreach var of varlist qg008_women qg009_mistreatment qg010_socioadmin qg011_women_pres{
		tab `var'
		g missing=0 
		replace missing= 1 if `var'==.
		tab missing stepD
		tab missing TUUNGANE
		reg missing TUUNGANE
		drop missing
	}	

	* Standardize
	foreach var of varlist qg008_women qg011_women_pres qg009_mistreatment qg010_socioadmin{
		g `var'X= `var'
		drop `var'
		egen `var'=std(`var'X)
		drop `var'X
	}

	* Results
	foreach depvar of varlist qg008_women qg011_women_pres qg009_mistreatment qg010_socioadmin MFI_attitude{
	parmby "areg `depvar' TUUNGANE if q011_sex==0,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)", lab saving(`depvar'_f,replace) 
	parmby "areg `depvar' TUUNGANE if q011_sex==1,cluster(IDS_CDC) absorb(IDS_LOTT_BIN)", lab saving(`depvar'_m,replace)
	}

	
************************************************************************************* COMBINE DATA FOR FIG1
	
preserve

** Combine data	
	* attitudes
	use qg008_women_f, clear
	append using qg008_women_m
	append using qg011_women_pres_f
	append using qg011_women_pres_m
	append using qg009_mistreatment_f
	append using qg009_mistreatment_m
	append using qg010_socioadmin_f
	append using qg010_socioadmin_m
	append using MFI_attitude_f
	append using MFI_attitude_m
	* community
	append using sharewomenA
	append using sharewomenDiscus
	append using SHAREcommittee
	* household
	append using MFI_Timeuse_f
	append using MFI_Timeuse_m
	append using list_f
	append using list_m
	* project choice
	append using RAPIDhealth 
	append using RAPIDeducation 
	append using RAPIDtransport 
	append using RAPIDwatsan 
	append using RAPIDagriculture 
	append using RAPIDother
	
** Add depvar info
	local n=0
	g depvar=""
	foreach X in qg008_women_f qg008_women_m qg011_women_pres_f qg011_women_pres_m qg009_mistreatment_f qg009_mistreatment_m qg010_socioadmin_f qg010_socioadmin_m MFI_attitude_f MFI_attitude_m sharewomenA sharewomenDiscus SHAREcommittee MFI_Timeuse_f MFI_Timeuse_m list_f list_f list_m list_m RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
	local n =`n'+2
	replace depvar="`X'" if _n==`n'	
	replace depvar="`X'" if _n==`n'-1	
	}

	* Save output		
	saveold results.dta, replace version(12)

restore
	
** ERASE FILES

	erase qg008_women_m.dta
	erase qg008_women_f.dta
	erase qg011_women_pres_f.dta
	erase qg011_women_pres_m.dta
	erase qg009_mistreatment_f.dta
	erase qg009_mistreatment_m.dta
	erase qg010_socioadmin_f.dta
	erase qg010_socioadmin_m.dta
	erase MFI_attitude_f.dta
	erase MFI_attitude_m.dta
	erase sharewomenA.dta
	erase sharewomenDiscus.dta
	erase SHAREcommittee.dta
	erase MFI_Timeuse_f.dta
	erase MFI_Timeuse_m.dta
	erase list_f.dta
	erase list_m.dta
	erase RAPIDhealth.dta 
	erase RAPIDeducation.dta 
	erase RAPIDtransport.dta 
	erase RAPIDwatsan.dta 
	erase RAPIDagriculture.dta 
	erase RAPIDother.dta

************************************************************************************* APPENDIX

**********
* Is the projects results driven by a preference of women for watsan and less for health?
* Asked to DMC only during Step A
**********

	use DRC2012_ABD_INDIV_v2.dta, clear
	merge n:1 IDV using TUUNGANE_v2.dta
	drop _m
	drop if IDS_RAPID==0
	egen tag=tag(IDV)
	
	* Look
	tab av_14_bis_project_1 av_10_gender

	g pref=""
	replace pref="health" if av_14_bis_project_1==16 | av_14_bis_project_1==21 | av_14_bis_project_1==15
	replace pref="edu" if av_14_bis_project_1==20
	replace pref="transport" if av_14_bis_project_1==26 | av_14_bis_project_1==46 | av_14_bis_project_1==7
	replace pref="watsan" if av_14_bis_project_1==1 | av_14_bis_project_1==22 | av_14_bis_project_1==2
	replace pref="agri" if av_14_bis_project_1==19 | av_14_bis_project_1==33 | av_14_bis_project_1==23 | av_14_bis_project_1==13 | av_14_bis_project_1==42 | av_14_bis_project_1==32 | av_14_bis_project_1==24 | av_14_bis_project_1==25 | av_14_bis_project_1==8 | av_14_bis_project_1==34 | av_14_bis_project_1==11 | av_14_bis_project_1==10 | av_14_bis_project_1==41 | av_14_bis_project_1==9
	replace pref="other" if av_14_bis_project_1==31 | av_14_bis_project_1==12 | av_14_bis_project_1==14 | av_14_bis_project_1==28 | av_14_bis_project_1==5 | av_14_bis_project_1==27 | av_14_bis_project_1==29 | av_14_bis_project_1==6 | av_14_bis_project_1==43 | av_14_bis_project_1==3 | av_14_bis_project_1==18
	tab av_14_bis_project_1 pref 
	
	g pref_health= pref=="health" & pref!=""	
	g pref_edu= pref=="edu" & pref!=""	
	g pref_transport= pref=="transport" & pref!=""	
	g pref_watsan= pref=="watsan" & pref!=""	
	g pref_agri= pref=="agri" & pref!=""	
	g pref_other= pref=="other" & pref!=""	
	replace pref_health=. if pref==""
	replace pref_edu=. if pref==""
	replace pref_trans=. if pref==""
	replace pref_watsan=. if pref==""
	replace pref_agri=. if pref==""
	replace pref_other=. if pref==""
	
	* swap gender to get women == 1
	g female = av_10_gender
	recode female (1=0) (0=1)

	* DMC only (only asked to them)
	* keep if IDS_TYPES=="DMC"	

	tabstat pref_health pref_edu pref_transport pref_watsan pref_agri pref_other, statistics(mean)
	tabstat pref_health pref_edu pref_transport pref_watsan pref_agri pref_other if female==0, statistics(mean)
	tabstat pref_health pref_edu pref_transport pref_watsan pref_agri pref_other if female==1, statistics(mean)
		
	* Initialize output:	
	est clear
		eststo: reg IDV IDS
		estout using "PREFS_REG.xls", replace keep(IDS) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(NOTHING)
	est clear
	* Are preferences different for men and women?	
	foreach var of varlist pref_health pref_edu pref_transport pref_watsan pref_agri pref_other{
		eststo: xi: regress `var' female i.IDS_LOTT_BIN, cluster(IDS_CDCCODE)
		estout using "PREFS_REG.xls", append keep(female _cons) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(`var')
		est clear
	}

**********
* Male dominance over project choice?
**********

	* Are men/women preferences better predictors of rapid projects?

	* Add project data
	merge n:1 IDV using DRC2012_ABD_VILL_v2.dta
	drop _m
	drop if IDV_RAPID==0

** Coarse measure
	* put projects into sectors (same as above)
	g RAPIDhealth=1 if b_23_project_has_been_chosen==21
	g RAPIDeducation=1 if b_23_project_has_been_chosen==20
	g RAPIDtransport=1 if b_23_project_has_been_chosen==26 | b_23_project_has_been_chosen==7 | b_23_project_has_been_chosen==46
	g RAPIDwatsan=1 if b_23_project_has_been_chosen==1 | b_23_project_has_been_chosen==2
	g RAPIDagriculture=1 if b_23_project_has_been_chosen==25 | b_23_project_has_been_chosen==19 | b_23_project_has_been_chosen==23 | b_23_project_has_been_chosen==8 | b_23_project_has_been_chosen==32 | b_23_project_has_been_chosen==13 | b_23_project_has_been_chosen==24 | b_23_project_has_been_chosen==11 | b_23_project_has_been_chosen==33 | b_23_project_has_been_chosen==10
	g RAPIDother=1 if b_23_project_has_been_chosen==31 | b_23_project_has_been_chosen==29 | b_23_project_has_been_chosen==28 | b_23_project_has_been_chosen==6 | b_23_project_has_been_chosen==43 | b_23_project_has_been_chosen==5 | b_23_project_has_been_chosen==16 | b_23_project_has_been_chosen==4 | b_23_project_has_been_chosen==18
	foreach var of varlist RAPIDhealth RAPIDeducation RAPIDtransport RAPIDwatsan RAPIDagriculture RAPIDother{
		replace `var'=0 if `var'==. & b_23_project_has_been_chosen!=.
	}

	gen correct=0
	replace correct=1 if RAPIDhealth==1 & pref_health==1
	replace correct=1 if RAPIDeducation==1 & pref_edu==1
	replace correct=1 if RAPIDtransport==1 & pref_transport==1
	replace correct=1 if RAPIDwatsan==1 & pref_watsan==1
	replace correct=1 if RAPIDagriculture==1 & pref_agri==1
	replace correct=1 if RAPIDother==1 & pref_other==1	
	replace correct=. if b_23_project_has_been_chosen==. | av_14_bis_project_1==.

** Fine measure

	g correctFINE= b_23_project_has_been_chosen==av_14_bis_project_1
	replace correctFINE=. if b_23_project_has_been_chosen==. | av_14_bis_project_1==.
	* order correctF b_23_project_has_been_chosen av_14_bis_project_1
	
	gen femaleTUU=female*TUUNGANE

	* Initialize output:	
	est clear
		eststo: reg IDV IDS
		estout using "PREFSCHOICE_REG.xls", replace keep(IDS) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)title(NOTHING)
	est clear
		eststo: xi: reg correct TUUNGANE female femaleTUU i.IDS_LOTT_BIN, cluster(IDS_CDCCODE)
		estout using "PREFSCHOICE_REG.xls", append keep(TUUNGANE female femaleTUU) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)
	est clear
		eststo: xi: reg correctFINE TUUNGANE female femaleTUU i.IDS_LOTT_BIN, cluster(IDS_CDCCODE)
		estout using "PREFSCHOICE_REG.xls", append keep(TUUNGANE female femaleTUU) cells(b(fmt(2) star) se(fmt(2) par(`"="("'`")""'))) stats(N)  starl(*  .10 **  .05  ***  .01)
	est clear

**********
* Final cleanup
**********

erase collected.dta
erase collected_v.dta


	
* END *
