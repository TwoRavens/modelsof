*****Replication code for
*****Boycotting, Buycotting, and the Psychology of Political Consumerism
*****Cindy D. Kam and Maggie A. Deichert
*****Journal of Politics

**********STUDY 1**********
use "Kam Deichert Study 1.dta", clear
set more off

****** Recode treatments and DVS
*** recoding treatments to where 1=1, .=0
recode wrkpos wrkneg (1=1)(.=0), gen(posinfo neginfo)

***** recoding self-reprt behaviorial measures 
lab def likely 0 "Very Unlikely" 1"Very Likely"
lab def support 0 "Strongly Oppose" 1 "Strongly Support"
recode supstore (5=0)(3=.33)(2=.66)(1=1)(else = .), gen(support)
recode ctrl20min ctrl2min treat20min treat2min (4=0)(3=.33)(2=.66)(1=1)(else = .), gen(ctrlfar ctrlclose treatfar treatclose) lab(likely)

recode support (0/.35 = 0)(.6/1 = 1) , gen(supportdum)

**** combining shopping variables into one 
gen shop = .
replace shop  = ctrlclose if shop == .
replace shop = treatfar if shop == .
replace shop = treatclose if shop == .
replace shop = ctrlfar if shop == .
lab val shop likely 
tab shop

***** combining shopping variables by proximity only
gen shopfar = . 
replace shopfar = ctrlfar if shopfar == . 
replace shopfar = treatfar if shopfar == . 
lab val shopfar likely

gen shopclose = . 
replace shopclose = ctrlclose if shopclose == . 
replace shopclose = treatclose if shopclose == . 
lab val shopclose likely

tab1 shopfar shopclose

** dummies denoting proximity
gen close = .
replace close = 1 if ctrl2min<5 | treat2min<5
replace close = 0 if ctrl20min<5|treat20min<5
tab close
lab def close 1"2 min" 0"20 min"
lab val close close
lab var close "location: treatment"
tab close

***** creating expcond for balance check
gen expcond = .
replace expcond = 1 if posinfo == 1
replace expcond = -1 if neginfo == 1
replace expcond = 0 if control == 1
lab def expcond 1 "Worker:Pos" -1 "Worker:Neg" 0 "control", modify
lab val expcond expcond 

****** Recode covariates
*** age 
tab age
recode age (18/29=1)(30/94=0)(else=.), gen(age1829)
recode age (30/39=1)(18/29 40/94=0)(else=.), gen(age3039)
recode age (40/49=1)(18/39 50/94=0)(else=.), gen(age4049)
recode age (50/64=1)(18/49 65/94=0)(else=.), gen(age5064)
recode age (65/94=1)(18/64=0)(else=.), gen(age65pl)

*** us citizen
tab uscit
drop if uscit~=1

*** sex 
tab sex 
recode sex (1=0 "male")(2=1 "female")(else = .), gen(female)

*** educ
tab educ
recode educ (2=0 "less HS")(3=.2)(4=.4)(5=.6)(6=.8)(7=1 "Post grad")(else=.), gen(ed6cat)
tab ed6cat

*** race
tab race_1
recode race_1 (1=1 "yes")(.=0 "no"), gen(white)
recode race_2 (1=1 "yes")(.=0 "no"), gen(black)
recode race_3 (1=1 "yes")(.=0 "no"), gen(asian)
recode race_4 (1=1 "yes")(.=0 "no"), gen(hispanic)
recode race_5 (1=1 "yes")(.=0 "no"), gen(otherrace)

*** income
gen inc9cata= (income-1)/8
sum inc9cata

*** partisan id 
** seven point scale 
gen pid7cata = .
replace pid7cata = 0 if dem1 == 1
replace pid7cata = .17 if dem1 == 2
replace pid7cata = .33 if ind1 == 2
replace pid7cata = .5 if ind1 == 3
replace pid7cata = .67 if ind1 == 1
replace pid7cata = .83 if rep1 == 2
replace pid7cata = 1 if rep1 == 1
lab def pid7cata 0"Str Dem" 1"Str GOP"
lab val pid7cata pid7cata
tab pid7cata
recode pid7cata (0/.4 =1)(.4/1=0)(else=.), gen(dem)
recode pid7cata (0/.6 =0)(.6/1=1)(else=.), gen(rep)
recode pid7cata (0/.4 =0)(.6/1=1)(else=.), gen(pid2cat)


*** ideology 
recode ideo (1=0 "extreme lib")(2 =.17)(3=.33)(4 = .5)(5=.67)(6=.83)(7 = 1 "extreme con")(else = .), gen(lc7cat)
tab lc7cat

*** attitude on worker rights
tab wrkrights
recode wrkrights (1=1 "workers")(3=.5)(2=0 "business")(else = .), gen(workrights)
*only 30 Rs prioritize business over workers in this sample

*** recoding participation variables 
tab parti1_1 
lab def yes 1 "yes" 2 "no"
recode parti1_1 parti1_2 (1=1) (2=0)(else = .), gen(buycott boycott) lab(yes)
recode parti1_3 parti2_4 parti1_5 parti1_6 parti2_7 parti2_8 parti2_9 parti2_10 parti2_11 parti1_12 (1=1) (2=0)(else = .), gen(socialorg protest paperpet internetpet email wrtletter expviews attend givepoli giverelig) lab(yes)


****** Descriptive Statistics
sum shop ctrlfar ctrlclose treatfar treatclose 
sum age1829 age3039 age4049 age5064 age65pl female ed6cat white black asian hispanic otherrace
sum inc9cata pid7 lc7cat workrights
sum buycott boycott socialorg protest paperpet internetpet email wrtletter expviews
sum attend givepoli giverelig 


****** Balance Checks, reported in online appendix
mlogit expcond female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem, base(0)
est store balance_study1
est table balance_study1,  b(%9.2f) se(%9.2f) stats(N) eq(1) style(col)

****************************************
* DIRECT TREATMENT EFFECTS of POS/NEG Info on outcome****
****************************************

**** ORDERED PROBIT **** 
** without pretreatment covariates, reported in online appendix
oprobit shop posinfo neginfo close 
est store shop
oprobit shopfar posinfo neginfo 
est store shopfar
test posinfo=-neginfo
oprobit shopclose posinfo neginfo  
est store shopclose
test posinfo=-neginfo
est table shop shopfar shopclose, b(%9.2f) se(%9.2f) stats(N) eq(1) style(col)
est table shop shopfar shopclose, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col)

** with pretreatment covariates
*TABLE 1 SYNTAX*
oprobit shop posinfo neginfo close female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
est store shop
test posinfo=neginfo
oprobit shopfar posinfo neginfo female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
est store shopfar
test posinfo=-neginfo
oprobit shopclose posinfo neginfo female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
est store shopclose
test posinfo=-neginfo
est table shop shopfar shopclose, b(%9.2f) se(%9.2f) stats(N) eq(1) style(col)
est table shop shopfar shopclose, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col)


** predicted probabilities (reported in text)
preserve
collapse female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
replace female = 1
replace black =0
replace asian=0
replace hispanic=0
replace age1829=0
replace age3039=1
replace age4049=0
replace age5064=0
replace rep=0
replace dem=1
expand 3
gen expcond = 0
replace expcond = 1 in 2
replace expcond = -1 in 3
lab val expcond expcond
recode expcond (0 -1 =0)(1=1), gen(posinfo)
recode expcond (0 1 =0)(-1=1), gen(neginfo)
lab val expcond expcond
expand 2
gen close = 0
replace close = 1 in 4/6
est restore shop
predict p1 p2 p3 p4
table expcond, c(mean p1 mean p2 mean p3 mean p4) f(%9.2f) /* predicted probabilities of each shopping outcome by treatment/control*/ 
restore


*Fully interactive model: variables interacted with location of store, FN 7
program close_wrk_vars 
foreach v in posinfo neginfo female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem {
gen close`v'=close*`v'
}
end
close_wrk_vars
oprobit shop posinfo neginfo close* female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 



****************************************
*Conditioning on past behavior
****************************************
** relationship between boycott/buycott
tab boycott buycott, chi2 cell

***** regressions with boycott and buycott
gen boyneg = neginfo * boycott 
gen buyneg = neginfo * buycott
gen boypos = posinfo * boycott 
gen buypos = posinfo * buycott

****** regression with participation 
** alpha values
alpha socialorg protest paperpet internetpet email wrtletter expviews attend givepoli 
*** load together .77 

** generating participation variable
gen pastppn9 = (socialorg +protest+ paperpet+ internetpet+ email+ wrtletter +expviews+ attend+ givepoli)/9
gen pastppn9pos = posinfo * pastppn9
gen pastppn9neg = neginfo * pastppn9

*Table 2 with covariates*
oprobit shop posinfo neginfo boypos boyneg buypos buyneg boycott buycott close female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
est store shop
oprobit shop posinfo neginfo boypos boyneg buypos buyneg boycott buycott pastppn9pos pastppn9neg pastppn9 close female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
est store both
est table shop both , b(%9.2f) se stats(N) style(col)
est table shop both , b(%9.2f) star(.1 .05 .01) stats(N) style(col)


*Predicted probabilities
preserve
collapse female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata rep dem 
replace female = 1
replace black =0
replace asian=0
replace hispanic=0
replace age1829=0
replace age3039=1
replace age4049=0
replace age5064=0
replace rep=0
replace dem=1
expand 3
gen expcond = 0
replace expcond = 1 in 2
replace expcond = -1 in 3
lab val expcond expcond
recode expcond (0 -1 =0)(1=1), gen(posinfo)
recode expcond (0 1 =0)(-1=1), gen(neginfo)
expand 2
gen close = 0
replace close = 1 in 4/6
est restore shop
expand 2
gen boycott=0 in 1/6
replace boycott=1 in 7/12
expand 2
gen buycott=0 in 1/12
replace buycott=1 in 13/24
gen boyneg = neginfo * boycott 
gen buyneg = neginfo * buycott
gen boypos = posinfo * boycott 
gen buypos = posinfo * buycott
est restore shop
predict p1 p2 p3 p4
table expcond boycott, c(mean p1 mean p2 mean p3 mean p4) f(%9.2f)
table expcond buycott, c(mean p1 mean p2 mean p3 mean p4) f(%9.2f)
restore


** with pretreatment covariates by respondent pid (reported in FN 19 and online appendix)
//gather coefs & s.e.s in a separate dataset
program bypidstudy1
tempname memhold
postfile `memhold' b_posinfo se_posinfo b_neginfo se_neginfo using bypid, replace
foreach v of varlist rep dem {
	oprobit shop posinfo neginfo close female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata if `v' == 1
est store `v'_study1
post `memhold' (_b[posinfo]) (_se[posinfo]) (_b[neginfo]) (_se[neginfo])
} 
postclose `memhold'
end
bypidstudy1 
est table dem_study1 rep_study1, b(%9.2f) se stats(N) style(col)
est table dem_study1 rep_study1, b(%9.2f) star(.1 .05 .01) stats(N) style(col)

*fully interactive 
*program drop pid2cat_vars
program pid2cat_vars
foreach v in posinfo neginfo close female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata {
gen pid2cat`v'=pid2cat*`v'
}
end
pid2cat_vars
oprobit shop posinfo neginfo close pid2cat* female black asian hispanic ed6cat age1829 age3039 age4049 age5064 inc9cata 
est store fullystudy1
est table fullystudy1, b(%9.2f) se stats(N) style(col)
est table fullystudy1 , b(%9.2f) star(.1 .05 .01) stats(N) style(col)


**********STUDY 2**********
use "Kam Deichert Study 2.dta", clear
set more off
svyset [pw=weight]

*** recoding treatments where 1 = received, 0 otherwise
tab van403_t, nol
gen expcond = van403_t
lab def expcond 1 "A: pos, control" 2 "B: pos, instr" 3"C: pos, self" 4"D: neg, control" 5"E: neg, instr" 6"F: neg, self" 7"G: pure control"
lab val expcond expcond 
tab expcond
recode expcond (1 2 3=1)(4 5 6 7=0)(else=.), gen(posinfo)
recode expcond (1 2 3 7=0)(4 5 6=1)(else=.), gen(neginfo)
recode expcond (2 = 1)(1 3 4 5 6 7=0)(else=.), gen(posinstr)
recode expcond (3 = 1)(1 2 4 5 6 7=0)(else=.), gen(posself)
recode expcond (5 = 1)(1 2 3 4 6 7=0)(else=.), gen(neginstr)
recode expcond (6 = 1)(1 2 3 4 5 7=0)(else=.), gen(negself)
recode expcond (1 2 3=1 "Positive")(4 5 6=-1 "Negative")(7=0 "Control"), gen(expcond3cat)

** likelihood of shopping at store
recode VAN403 (1=1 "very likely")(2=.67)(3=.33)(4=0 "very unlikely")(else=.), gen(shop)

** other dependent variables 
recode VAN405abcg VAN405def VAN406abcg VAN406def VAN407abcg VAN407def (1=1)(2=.67)(3=.33)(4=0)(else=.), gen(postlinkshop_pro postlinkshop_anti rallyshop_pro rallyshop_anti contactshop_pro contactshop_anti)
gen postlinkshop = postlinkshop_pro
replace postlinkshop = postlinkshop_anti if expcond==4|expcond==5|expcond==6
gen rallyshop= rallyshop_pro
replace rallyshop= rallyshop_anti if expcond==4|expcond==5|expcond==6
gen contactshop= contactshop_pro
replace contactshop= contactshop_anti if expcond==4|expcond==5|expcond==6
alpha postlinkshop rallyshop contactshop
gen ppnshop = (postlinkshop+rallyshop+contactshop)/3
svy: mean ppnshop, over(expcond3cat)

/*recoding demographics*/

*Covariates
recode pp_pid7 (1=0 "Str Dem")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Str GOP"), gen(pid7cata)
recode pp_pid7 (1 2 3=0 "Dem")(4 8=.5)(5 6 7=1 "GOP")(else=.), gen(pid3cata)
recode pp_pid7 (1 2 3=0 "Dem")(5 6 7=1 "GOP")(else=.), gen(demgop)
recode pp_pid7 (1 2 3 4 8 =0)(5 6 7=1 "GOP"), gen(rep)
recode pp_pid7 (5 6 7 4 8 =0)(1 2 3=1 "DEM"), gen(dem)
recode pid7cata (0/.4 =0)(.6/1=1)(else=.), gen(pid2cat)


/*Race/ethnicity*/
tab race 
recode race (1=0 "white")(2=1 "black")(3=2 "Hispanic")(else=.), gen(race3cat)
recode race3cat (1=1)(0 2=0)(else=.), gen(black) 
recode race3cat (2=1)(0 1=0)(else=.), gen(hisp) 

/*Female*/
recode gender (1=0)(2=1 "female")(else=.), gen(female)

/*Income*/
tab faminc if faminc<97, nol
recode faminc (1/3=1)(4/97=0)(else=.), gen(incQ1)
recode faminc (1/3=0)(4/5=1)(6/97=0)(else=.), gen(incQ2)
recode faminc (1/3=0)(4/5=0)(6/8=1)(9/97=0)(else=.), gen(incQ3)
recode faminc (1/3=0)(4/5=0)(6/8=0)(9/31=1)(97=0)(else=.), gen(incQ4)
recode faminc (1/31=0)(97=1)(else=.), gen(incref)
recode faminc (1=0)(2=.125)(3=.25)(4=.375)(5=.5)(6=.625)(7 8 = .75)(9 10=.875)(11 12 13/16 31=1)(97=0), gen(inc9cata)

/*Age*/
gen ageyears = (2016-birthyr)
gen age01 = (ageyears-19)/(95-19)
recode ageyears (18/29 = 1)(30/95=0)(else=.), gen(age1829)
recode ageyears (30/39= 1)(19/29 40/95=0)(else=.), gen(age3039)
recode ageyears (40/49= 1)(19/39 50/95=0)(else=.), gen(age4049)
recode ageyears (50/64= 1)(19/49 65/95=0)(else=.), gen(age5064)
recode ageyears (65/95= 1)(19/64=0)(else=.), gen(age65pl)

/*Education*/
recode educ (1=0 "less HS")(2=.25)(3 4=.5)(5=.75)(6=1 "post BA")(else=.), gen(ed5cat)


** balance test, reported in online appendix

mlogit expcond3cat female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem, base(0)
est store balance_study2
est table balance_study2,  b(%9.2f) se(%9.2f) stats(N) eq(1) style(col)

****************************************
***** TABLE 3 ANALYSIS *****
****************************************
** without pretreatment covariates, unweighted, reported in online appendix
oprobit shop posinfo neginfo
est store basic
oprobit shop posinfo posinstr posself neginfo neginstr negself
est store allconditions
reg ppnshop posinfo neginfo
est store ppnshop
reg ppnshop posinfo posinstr posself neginfo neginstr negself
est store ppnshop_frame
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) se stats(N) eq(1) style(col)
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col)

** without pretreatment covariates, weighted, reported in online appendix
svy: oprobit shop posinfo neginfo
est store basic
svy: oprobit shop posinfo posinstr posself neginfo neginstr negself
est store allconditions
svy: reg ppnshop posinfo neginfo
est store ppnshop
svy: reg ppnshop posinfo posinstr posself neginfo neginstr negself
est store ppnshop_frame
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) se stats(N) eq(1) style(col)
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col)

** with pretreatment covariates, Table 3. 
svy: oprobit shop posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store basic
test posinfo=-neginfo
svy: oprobit shop posinfo posinstr posself neginfo neginstr negself female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store allconditions
svy: reg ppnshop posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store ppnshop
test posinfo=neginfo
svy: reg ppnshop posinfo posinstr posself neginfo neginstr negself female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store ppnshop_frame
test posinfo=neginfo
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col)
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) se stats(N) eq(1) style(col)

** predicted probabilities for shop dv selection with covariates included, weighted analysis
preserve
collapse female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
replace female = 1
replace black =0
replace hisp=0
replace age1829=0
replace age3039=0
replace age4049=0
replace age5064=1
replace rep=0
replace dem=1
replace incref=0
expand 3
gen expcond = 0
replace expcond = 1 in 2
replace expcond = -1 in 3
lab val expcond expcond
recode expcond (0 -1 =0)(1=1), gen(posinfo)
recode expcond (0 1 =0)(-1=1), gen(neginfo)
est restore basic
predict p1 p2 p3 p4
table expcond, c(mean p1 mean p2 mean p3 mean p4) f(%9.2f)
restore

** with pretreatment covariates without weights, in online appendix
oprobit shop posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store basic
oprobit shop posinfo posinstr posself neginfo neginstr negself female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store allconditions
reg ppnshop posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store ppnshop
reg ppnshop posinfo posinstr posself neginfo neginstr negself female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem 
est store ppnshop_frame
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col)
est table basic allconditions ppnshop ppnshop_frame, b(%9.2f) se stats(N) eq(1) style(col)


** by respondent pid 
program bypidstudy2
tempname memhold
postfile `memhold' b_posinfo se_posinfo b_neginfo se_neginfo using bypidstudy2, replace
foreach v of varlist rep dem {
	oprobit shop posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref if `v' == 1
est store `v'_study2
post `memhold' (_b[posinfo]) (_se[posinfo]) (_b[neginfo]) (_se[neginfo])

} 
foreach v of varlist rep dem {
	svy: oprobit shop posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref if `v' == 1
est store `v'_study2_wtd
post `memhold' (_b[posinfo]) (_se[posinfo]) (_b[neginfo]) (_se[neginfo])
}
postclose `memhold'
end
bypidstudy2

est table dem_study2 dem_study2_wtd rep_study2 rep_study2_wtd , b(%9.2f) se stats(N) style(col)
est table dem_study2 dem_study2_wtd rep_study2 rep_study2_wtd , b(%9.2f) star(.1 .05 .01) stats(N) style(col)


*fully interactive 
program pid2cat_vars_study2
foreach v in posinfo neginfo female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref  {
gen pid2cat`v'=pid2cat*`v'
}
end
pid2cat_vars_study2
oprobit shop posinfo neginfo pid2cat* female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref
est store fullystudy2
svy: oprobit shop posinfo neginfo pid2cat* female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref
est store fullystudy2_wtd

est table fullystudy2 fullystudy2_wtd, b(%9.2f) se stats(N) style(col)
est table fullystudy2 fullystudy2_wtd, b(%9.2f) star(.1 .05 .01) stats(N) style(col)


**********STUDY 3**********
use "Kam Deichert Study 3.dta", clear
set more off

*survey weight
svyset [pweight=weight]

*** recoding demographics
*Covariates
recode pid7 (1=0 "Str Dem")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Str GOP"), gen(pid7cata)
recode pid7 (1 2 3=0 "Dem")(4 8=.5)(5 6 7=1 "GOP")(else=.), gen(pid3cata)
recode pid7 (1 2 3=0 "Dem")(5 6 7=1 "GOP")(else=.), gen(demgop)
recode pid7 (1 2 3 4 8 =0)(5 6 7=1 "GOP"), gen(rep)
recode pid7 (5 6 7 4 8 =0)(1 2 3=1 "DEM"), gen(dem)
recode pid7cata (0/.4 =0)(.6/1=1)(else=.), gen(pid2cat)

/*Race/ethnicity*/
tab race 
recode race (1=0 "white")(2=1 "black")(3=2 "Hispanic")(else=.), gen(race3cat)
recode race3cat (1=1)(0 2=0)(else=.), gen(black) 
recode race3cat (2=1)(0 1=0)(else=.), gen(hisp) 

/*Female*/
recode gender (1=0)(2=1 "female")(else=.), gen(female)

/*Income*/
tab faminc if faminc<97, nol
recode faminc (1/3=1)(4/97=0)(else=.), gen(incQ1)
recode faminc (1/3=0)(4/5=1)(6/97=0)(else=.), gen(incQ2)
recode faminc (1/3=0)(4/5=0)(6/8=1)(9/97=0)(else=.), gen(incQ3)
recode faminc (1/3=0)(4/5=0)(6/8=0)(9/31=1)(97=0)(else=.), gen(incQ4)
recode faminc (1/31=0)(97=1)(else=.), gen(incref)
recode faminc (1=0)(2=.125)(3=.25)(4=.375)(5=.5)(6=.625)(7 8 = .75)(9 10=.875)(11 12 13/16 31=1)(97=0), gen(inc9cata)

/*Age*/
gen ageyears = (2017-birthyr)
gen age01 = (ageyears-19)/(95-19)
recode ageyears (18/29 = 1)(30/95=0)(else=.), gen(age1829)
recode ageyears (30/39= 1)(19/29 40/95=0)(else=.), gen(age3039)
recode ageyears (40/49= 1)(19/39 50/95=0)(else=.), gen(age4049)
recode ageyears (50/64= 1)(19/49 65/95=0)(else=.), gen(age5064)
recode ageyears (65/95= 1)(19/64=0)(else=.), gen(age65pl)

/*Education*/
recode educ (1=0 "less HS")(2=.25)(3 4=.5)(5=.75)(6=1 "post BA")(else=.), gen(ed5cat)


*** recoding treatments 

tab treat_raffle raffle_pick
recode treat_raffle (9/12 = 1 "negMC")(13/16 = 2 "posMC")(25/28 = 3 "negV")(29/32=4 "posV")(else=0 "no frame"), gen(frame)
recode treat_raffle (9 11 = 1 "negMC_15")(10/12 = 2 "negMC_125")(13 15 = 3 "posMC_75")(14 16 =4 "posMC_5")(25 27=5 "negV_15")(26 28=6 "negV_125")(29 31 =7 "posV_75")(30 32 =8 "posV_5")(else=0 "no frame"), gen(frame_mag)
recode treat_raffle (9/12 25/28 = 1 "negative")(else=0 "Neutral or positive"), gen(neginfo)
recode treat_raffle (13/16 29/32= 1 "positive")(else=0 "Neutral or negative"), gen(posinfo)
recode treat_raffle (9/12 25/28 = -1 "negative")(13/16 29/32= 1 "positive")(else=0 "Neutral"), gen(typeframe)

recode treat_raffle(9 10 11 12 =1)(else=0), gen(negMC)
recode treat_raffle(13 14 15 16 =1)(else=0), gen(posMC)
recode treat_raffle(25 26 27 28 =1)(else=0), gen(negV)
recode treat_raffle(29 30 31 32 =1)(else=0), gen(posV)

recode treat_raffle(9 10 11 12 25 26 27 28 =1)(1 2 5 6 17 18 21 22=0)(else=.), gen(neginfo_control)
recode treat_raffle(13 14 15 16 29 30 31 32=1)(3 4 7 8 19 20 23 24=0)(else=.), gen(posinfo_control)

recode treat_raffle(1/4 9 10 13 14 21/24 27/28 31/32 =1)(else=0), gen(rightV)

tab raffle_pick frame , col
tab raffle_pick frame_mag , col

//these are the comparisons of MC15 vs. Visa 10
recode treat_raffle (1 5 9 11 = 1 "MC15, V10")(else=0), gen(MC15_V10)
recode treat_raffle (2 6 10 12 = 1 "MC125, V10")(else=0), gen(MC125_V10)
recode treat_raffle (3 7 13 15 = 1 "MC075, V10")(else=0), gen(MC075_V10)
recode treat_raffle (4 8 14 16 = 1 "MC05, V10")(else=0), gen(MC05_V10)
recode treat_raffle (17 21 25 27 = 1 "V15, MC10")(else=0), gen(V15_MC10)
recode treat_raffle (18 22 26 28 = 1 "V125, MC10")(else=0), gen(V125_MC10)
recode treat_raffle (19 23 29 31 = 1 "V075, MC10")(else=0), gen(V075_MC10)
recode treat_raffle (20 24 30 32 = 1 "V05, MC10")(else=0), gen(V05_MC10)

*Specify Card A ($10) versus Card B

recode raffle_pick (1=0 "MC")(2=1 "Visa")(else=.), gen(pick_Visa)

recode treat_raffle (1/16 = 1 "Visa $10")(17/32=0 "MC $10")(else=.), gen(CardA_V)
recode treat_raffle (1/16 = 0 "Visa $10")(17/32=1 "MC $10")(else=.), gen(CardA_MC)
recode treat_raffle (1/16 = 1 "Visa $10")(17/32=0 "MC $10")(else=.), gen(CardB_MC)
recode treat_raffle (1/16 = 0 "Visa $10")(17/32=1 "MC $10")(else=.), gen(CardB_V)

recode treat_raffle (1 5 9 11 17 21 25 27 = 1 "Card B 15")(else=0), gen(CardB_15)
recode treat_raffle (2 6 10 12 18 22 26 28= 1 "Card B 12.50")(else=0), gen(CardB_1250)
recode treat_raffle (3 7 13 15 19 23 29 31= 1 "Card B 7.50")(else=0), gen(CardB_0750)
recode treat_raffle (4 8 14 16 20 24 30 32= 1 "Card B, 5")(else=0), gen(CardB_05)
recode treat_raffle (1 5 9 11 17 21 25 27 = 4 "Card B 15")(2 6 10 12 18 22 26 28= 3 "Card B 12.50")(3 7 13 15 19 23 29 31= 2 "Card B 7.50")(4 8 14 16 20 24 30 32= 1 "Card B, 5"), gen(Card_amounts)

gen pick_CardB = .
replace pick_CardB = 1 if CardB_V==1 & pick_Visa==1
replace pick_CardB = 0 if CardB_V==1 & pick_Visa==0
replace pick_CardB = 1 if CardB_V==0 & pick_Visa==0
replace pick_CardB = 0 if CardB_V==0 & pick_Visa==1
tab pick_CardB


*** balance tests for study 3, reported in online appendix
mlogit typeframe female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem, base(0)
est store balance_study3

est table balance_study3, b(%9.2f) se stats(N) eq(1) style(col)


//TABLE 4 proportions and standard errors for overall population
svy: mean pick_CardB if CardB_V==0, over(typeframe Card_amounts)
svy: mean pick_CardB if CardB_V==1, over(typeframe Card_amounts)

svy: reg pick_CardB neginfo if MC15_V10==1 
svy: reg pick_CardB neginfo if MC125_V10==1 
svy: reg pick_CardB posinfo if MC075_V10==1 
svy: reg pick_CardB posinfo if MC05_V10==1 

svy: reg pick_CardB neginfo if V15_MC10==1 
svy: reg pick_CardB neginfo if V125_MC10==1 
svy: reg pick_CardB posinfo if V075_MC10==1
svy: reg pick_CardB posinfo if V05_MC10==1

//TABLE 4 proportions and standard errors for overall population without weights, reported iin online appendix
table Card_amounts typeframe if CardB_V==0, c(mean pick_CardB N pick_CardB)
table Card_amounts typeframe if CardB_V==1, c(mean pick_CardB N pick_CardB)

prtest pick_CardB if MC15_V10==1, by(neginfo)
prtest pick_CardB if MC125_V10==1, by(neginfo)
prtest pick_CardB if MC075_V10==1, by(posinfo)
prtest pick_CardB if MC05_V10==1, by(posinfo)

prtest pick_CardB if V15_MC10==1, by(neginfo)
prtest pick_CardB if V125_MC10==1, by(neginfo)
prtest pick_CardB if V075_MC10==1, by(posinfo)
prtest pick_CardB if V05_MC10==1, by(posinfo)


//Regression analysis mentioned in text for Study 3 - Probit Version
svy: probit pick_CardB neginfo posinfo CardB_15 CardB_1250 CardB_0750 CardB_05, nocons
test neginfo = -posinfo 
est store basic
svy: probit pick_CardB neginfo posinfo CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem, nocons
test neginfo = -posinfo 
est store demos

*without weights
probit pick_CardB neginfo posinfo CardB_15 CardB_1250 CardB_0750 CardB_05, nocons 
test neginfo = -posinfo 
est store basic_nowt

probit pick_CardB neginfo posinfo CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref rep dem, nocons
test neginfo = -posinfo 
est store demos_nowt

est table basic basic_nowt demos demos_nowt, b(%9.2f) se(%9.2f) stats(N) eq(1) style(col) 
est table basic basic_nowt demos demos_nowt, b(%9.2f) star(.1 .05 .01) stats(N) eq(1) style(col) 


*by PID
//Regression analysis mentioned in text for Study 3 - Probit Version 
program bypidstudy3
tempname memhold
postfile `memhold' b_posinfo se_posinfo b_neginfo se_neginfo using bypidstudy3, replace
foreach v of varlist rep dem {
	probit pick_CardB posinfo neginfo CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref if `v' == 1, nocons
est store `v'_study3
post `memhold' (_b[posinfo]) (_se[posinfo]) (_b[neginfo]) (_se[neginfo])

} 
foreach v of varlist rep dem {
	svy: probit pick_CardB posinfo neginfo CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref if `v' == 1, nocons
est store `v'_study3_wtd
post `memhold' (_b[posinfo]) (_se[posinfo]) (_b[neginfo]) (_se[neginfo])
}
postclose `memhold'
end
bypidstudy3

est table dem_study3 dem_study3_wtd rep_study3 rep_study3_wtd , b(%9.2f) se stats(N) style(col)
est table dem_study3 dem_study3_wtd rep_study3 rep_study3_wtd , b(%9.2f) star(.1 .05 .01) stats(N) style(col)


*fully interactive 
program pid2cat_vars_study3
foreach v in posinfo neginfo CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref  {
gen pid2cat`v'=pid2cat*`v'
}
end
pid2cat_vars_study3
probit pick_CardB posinfo neginfo pid2cat* CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref
est store fullystudy3	
svy: probit pick_CardB posinfo neginfo pid2cat* CardB_15 CardB_1250 CardB_0750 CardB_05 female black hisp ed5cat age1829 age3039 age4049 age5064 inc9cata incref
est store fullystudy3_wtd	

est table fullystudy3 fullystudy3_wtd, b(%9.2f) se stats(N) style(col)
est table fullystudy3 fullystudy3_wtd, b(%9.2f) star(.1 .05 .01) stats(N) style(col)

est table fullystudy1 fullystudy2 fullystudy2_wtd fullystudy3 fullystudy3_wtd, b(%9.2f) se stats(N) style(col) eq(1)
est table fullystudy1 fullystudy2 fullystudy2_wtd fullystudy3 fullystudy3_wtd, b(%9.2f) star(.1 .05 .01) stats(N) style(col) eq(1)


//open-ended responses
*** recoding open-end codes
recode wrk_treat wrk_rel wrk_tradeoff wrk_irr wrk_nothingaboutother wrk_helpless wrk_men_needmoney (1=1)(.=0), gen(men_wrk wrk_relev wrk_men_tradeoff wrk_irrel wrk_nootherinfo wrk_cantdoany wrk_needmoney)
recode card_amt exp_raffle ambivalent liked_visa like_mc like_card prev_card (1=1)(.=0), gen(amount men_raffle ambiv liked_v liked_mc liked_card use_card)
recode unfamiliar_mc ben_visa ben_mc pol_active dislike_mc prev_v prev_mc other order (1=1)(.=0), gen(dk_mc pos_visa pos_mc active neg_mc use_v use_mc men_other men_order)
recode self instrumental support nopolitics notrsproblem anfindanotherjob rafflenopower supportother donotsupport (1=1)(.=0), gen(self_mech instr_mech sup_store no_pol notr_prblm another_job raffle_prblm sup_oth donot_sup)

*** descriptive statistics for open-end codes
replace men_wrk = 1 if wrk_relev == 1 & men_wrk == 0
replace men_wrk = 1 if wrk_men_tradeoff == 1 & men_wrk == 0
replace men_wrk = 1 if wrk_nootherinfo == 1 & men_wrk == 0
replace men_wrk = 1 if wrk_irrel == 1 & men_wrk == 0
replace men_wrk = 1 if wrk_cantdoany == 1 & men_wrk == 0
replace men_wrk = 1 if wrk_needmoney == 1 & men_wrk == 0

gen brand_pref = 0
replace brand_pref = 1 if liked_mc == 1 
replace brand_pref = 1 if pos_mc == 1
replace brand_pref = 1 if liked_v == 1
replace brand_pref = 1 if pos_v == 1
tab brand_pref

gen anyworker = 0
replace anyworker = 1 if wrk_relev == 1
replace anyworker = 1 if wrk_men_tradeoff == 1
replace anyworker = 1  if wrk_nootherinfo == 1
replace anyworker = 1  if wrk_irrel == 1
replace anyworker = 1  if wrk_cantdoany == 1
replace anyworker = 1  if wrk_needmoney == 1


*** TABLE 5 Results....Overall by information results
svy: tab amount typeframe, col
svy: reg amount neginfo posinfo 

svy: tab brand_pref typeframe, col
svy: reg brand_pref neginfo posinfo

svy: tab anyworker typeframe, col
svy: reg anyworker neginfo posinfo

svy: tab wrk_relev typeframe if anyworker==1 & typeframe~=0, col
svy: tab wrk_needmoney typeframe if anyworker==1 & typeframe~=0, col
svy: tab wrk_irrel typeframe if anyworker==1 & typeframe~=0, col


//TABLE 5 Results by behavior - given info did they boycott or buycott or not
gen boycottCardB = .
replace boycottCardB = 0 if pick_CardB==1 & typeframe==-1
replace boycottCardB = 1 if pick_CardB==0 & typeframe==-1
tab boycottCardB

gen buycottCardB = .
replace buycottCardB = 1 if pick_CardB==1 & typeframe==1
replace buycottCardB = 0 if pick_CardB==0 & typeframe==1
tab buycottCardB

svy: tab amount boycottCardB, col
svy: tab amount buycottCardB, col

svy: tab brand_pref boycottCardB, col
svy: tab brand_pref buycottCardB, col

svy: tab anyworker boycottCardB, col
svy: tab anyworker buycottCardB, col



svy: tab wrk_relev boycottCardB if anyworker==1, col
svy: tab wrk_relev buycottCardB if anyworker==1, col

svy: tab wrk_needmoney boycottCardB if anyworker==1, col
svy: tab wrk_needmoney buycottCardB if anyworker==1, col

svy: tab wrk_irrel boycottCardB if anyworker==1, col
svy: tab wrk_irrel buycottCardB if anyworker==1, col



*****Collecting results by PID across studies
clear
use bypid
gen Study1=1
gen rep = 1 in 1
gen dem = 1 in 2
append using bypidstudy2
gen Study2=1 in 3/6
replace rep = 1 in 3 
replace dem = 1 in 4
replace rep = 1 in 5 
replace dem = 1 in 6
gen wtd = 1 in 5/6
append using bypidstudy3
gen Study3 =1 in 7/10
replace rep = 1 in 7
replace dem = 1 in 8
replace rep = 1 in 9
replace dem = 1 in 10
replace wtd = 1 in 9/10

gen Study = .
replace Study = 1 if Study1==1
replace Study = 2 if Study2==1 & wtd~=1
replace Study = 3 if Study2==1 & wtd==1
replace Study = 4 if Study3==1 & wtd~=1
replace Study = 5 if Study3==1 & wtd==1
lab def Study 1 "MTurk 2015" 2"CCAP 2016, unweighted" 3"CCAP 2016, weighted" 4"YouGov 2017, unweighted" 5"YouGov 2017, weighted"
lab val Study Study 

gen LB_pos = b_posinfo -(1.96*se_posinfo)
gen UB_pos = b_posinfo +(1.96*se_posinfo)

gen LB_neg = b_neginfo -(1.96*se_neginfo)
gen UB_neg = b_neginfo +(1.96*se_neginfo)

eclplot b_posinfo LB_pos UB_pos Study if rep==1, horiz xline(0) xtitle("Positive Information") name(pos_rep, replace) title("Republicans")
eclplot b_neginfo LB_neg UB_neg Study if rep==1, horiz xline(0) xtitle("Negative Information") name(neg_rep, replace) title("Republicans")

eclplot b_posinfo LB_pos UB_pos Study if dem==1, horiz xline(0) xtitle("Positive Information") name(pos_dem, replace) title("Democrats")
eclplot b_neginfo LB_neg UB_neg Study if dem==1, horiz xline(0) xtitle("Negative Information") name(neg_dem, replace) title("Democrats")

graph combine pos_dem neg_dem pos_rep neg_rep, ycommon xcommon 


