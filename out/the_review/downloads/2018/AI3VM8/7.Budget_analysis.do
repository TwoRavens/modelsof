*******************************************************************
* Estimate the effect of the ID program on budget allocation
********************************************************************
	 clear all
	 set more off
	 pause on

****************************************************** 
 *Set working directory 

capture cd "replication_APSR"
	
******************************************************
  ** Bring in budget data
 use "budget_data.dta" 
 merge m:m subc_id subc_id using "Councilors_covariates_v2.dta", keepus(IPW)
 drop if _m==2
 drop _m
 
**************
* Treatment
**************
gen ID = 0
replace ID=1 if treat==1 | treat==3

* period var
gen post=0
replace post=1 if fyid>1

tab fyid, gen(year)
recode fyid (1=0)(2=1)(3=2), gen(period)

**************
* DV
**************
* 1. total number of projects
su numproj, de

gen lnumproj=log(numproj)
lab var lnumproj "Number of projects (log)"
kdensity lnumproj, scheme(lean1)
move lnumproj numproj

* 2. Number of projecs per capita
gen projpc1000 = projpc*1000
lab var projpc1000 "Projects per 1,000 residents"
kdensity projpc1000, scheme(lean1)
move projpc1000 projpc

* 3. Total spending  
gen lspending=log(spending)
lab var lspending "Log spending"
kdensity lspending
move lspending spending

* 4. Spending per capita
gen spendingpc=spending/pop
gen logpc=log(spendingpc)
lab var spendingpc "Spending per capita"
lab var logpc "Log spending per capita"
kdensity logpc 
move spendingpc spending
move logpc spending

* 4. Share of district budget in given year
encode dist_name, gen(distrid)
duplicates list subc_id fyid

* total district spending per financial year
bys dist_name fyid: egen totalspending=sum(spending)
gen logftotalspend = log(totalspending)

* share spending in the sub-county
gen spensdingshare=spending/totalspending

* standandardize outcome measures by financial year
bys fyid: center projpc1000 numproj lnumproj logpc lspending spensdingshare, standardize prefix(z_)

gl DVs z_projpc1000 z_lnumproj z_lspending z_logpc z_spensdingshare
su $DVs

foreach y in $DVs{
	reg `y' ID if fyid==1, cl(distrid)
	}

	
********************************************************
* Define covariates
******************************************************
gen pop1000 = pop/1000
lab var pop1000 "Subcounty population (thousands)"

* create a new binary var equal 1 if at least one councilors is in a competitive constituency 
gen competitive=0
replace competitive=1 if rc_competitive==1 | swc_competitive==1
tab competitive

* define covariates
gl covs rc_NRM swc_NRM rc_Edu swc_Edu rc_FirstTerm swc_FirstTerm rc_educ swc_educ rc_cterms swc_cterms rc_polexpterms swc_polexpterms rc_counterms swc_counterms pop1000 subc_hhi 

	* assign mean values of control to missing values of covariates (Lin, green and Coppock, 2015))
	foreach y in $covs {
	 egen `y'_mean=mean(`y')
	 gen `y'_miss = `y'==.
	 replace `y' = `y'_mean if `y'==.
	 }

gl controls rc_NRM swc_NRM rc_Edu swc_Edu  rc_FirstTerm swc_FirstTerm logpop subc_hhi rc_NRM_miss swc_NRM_miss rc_FirstTerm_miss swc_FirstTerm_miss subc_hhi_miss	 
su $controls

 
************************
* run regressions
************************
set more off
xtset subc_id fyid

foreach y in $DVs {

* M1: year and district FEs
	mixed `y' ID##post i.fyid logftotalspend i.distrid  || subc_id:, cl(subc_id)
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	est store `y'_m1
	
* M2: add councilor-level controls
	mixed `y' ID##post i.fyid logftotalspend $controls i.distrid  || subc_id:, cl(subc_id)
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	est store `y'_m2		
	
	********************************************************
	* effects conditional on competitiveness
	******************************************************

	mixed `y' ID##post i.fyid logftotalspend i.distrid if competitive==0 || subc_id:, cl(subc_id)
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	est store `y'_m3
	
	mixed `y' ID##post i.fyid logftotalspend $controls i.distrid if competitive==0 || subc_id:, cl(subc_id)
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	est store `y'_m4	
		
	mixed `y' ID##post i.fyid logftotalspend i.distrid if competitive==1 || subc_id:, cl(subc_id)
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	est store `y'_m5	
	
	mixed `y' ID##post i.fyid logftotalspend $controls i.distrid if competitive==1 || subc_id:, cl(subc_id)
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	est store `y'_m6		

	*********************************
	*Tables 21-23-24 online appendix
	*********************************
	
# delimit ; 
esttab  `y'_m1 `y'_m2 `y'_m3 `y'_m4 `y'_m5 `y'_m6
		using "tables/`y'.tex", replace
		keep( 1.ID 1.post 1.ID#1.post _cons)
	    order(1.ID 1.post 1.ID#1.post _cons)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Unconditional}" "\textbf{Low competition}" "\textbf{High competition}", pattern(1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(1.ID "ID"
				  1.post "Post"
				  1.ID#1.post "\$ID\times Post$"
				  _cons "Constant")
		stats(year district control N, labels("Year FE" "District FE" "Controls" "N")
		fmt(0 0 0 0 0 0 0)) collabels(none) label booktabs nonotes;
		#delimit cr	
}

* GLM (for modeling proportion as DV)

glm spensdingshare ID##post logftotalspend i.fyid i.distrid, cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	estadd local effect "GLM"
	est store spensdingshare_m1

glm spensdingshare ID##post logftotalspend $controls i.fyid i.distrid, cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	estadd local effect "GLM"
	est store spensdingshare_m2	
	
glm spensdingshare ID##post logftotalspend i.fyid i.distrid if competitive==0, cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	estadd local effect "GLM"
	est store spensdingshare_m3

glm spensdingshare ID##post logftotalspend $controls i.fyid i.distrid if competitive==0, cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	estadd local effect "GLM"
	est store spensdingshare_m4	
	
glm spensdingshare ID##post logftotalspend i.fyid i.distrid if competitive==1, cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	estadd local effect "GLM"
	est store spensdingshare_m5

glm spensdingshare ID##post logftotalspend $controls i.fyid i.distrid if competitive==1, cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	estadd local effect "GLM"
	est store spensdingshare_m6
	
****************************
*Table 25 online appendix
****************************

# delimit ;
esttab  spensdingshare_m1 spensdingshare_m2 spensdingshare_m3 spensdingshare_m4 spensdingshare_m5 spensdingshare_m6
		using "tables/spensdingshare.tex", replace
		keep( 1.ID 1.post 1.ID#1.post _cons)
	    order(1.ID 1.post 1.ID#1.post _cons)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Unconditional}" "\textbf{Low competition}" "\textbf{High competition}", pattern(1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(1.ID "ID"
				  1.post "Post"
				  1.ID#1.post "\$ID\times Post$"
				  _cons "Constant")
		stats(effect year district control N, labels("Model" "Year FE" "District FE" "Controls" "N")
		fmt(0 0 0 0 0 0 0)) collabels(none) label booktabs nonotes;
		#delimit cr		
	
* count model for number of development projects
set more off

xtpoisson numproj ID##post logftotalspend i.fyid i.distrid, irr 
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	estadd local effect "POISSON"
	est store numproj_m1

xtpoisson numproj ID##post logftotalspend $controls i.fyid i.distrid, irr 
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	estadd local effect "POISSON"
	est store numproj_m2

xtpoisson numproj ID##post logftotalspend i.fyid i.distrid if competitive==0, irr 
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	estadd local effect "POISSON"
	est store numproj_m3
	
xtpoisson numproj ID##post logftotalspend $controls i.fyid i.distrid if competitive==0, irr 
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	estadd local effect "POISSON"
	est store numproj_m4
	
xtpoisson numproj ID##post logftotalspend i.fyid i.distrid if competitive==1, irr 
	estadd local control ""
	estadd local year "X"
	estadd local district "X"
	estadd local effect "POISSON"
	est store numproj_m5
	
xtpoisson numproj ID##post logftotalspend $controls i.fyid i.distrid if competitive==1, irr 
	estadd local control "X"
	estadd local year "X"
	estadd local district "X"
	estadd local effect "POISSON"
	est store numproj_m6

****************************
*Table 22 online appendix
****************************
	
# delimit ;
esttab  numproj_m1 numproj_m2 numproj_m3 numproj_m4 numproj_m5 numproj_m6
		using "tables/numproj.tex", replace
		keep( 1.ID 1.post 1.ID#1.post _cons)
	    order(1.ID 1.post 1.ID#1.post _cons)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Unconditional}" "\textbf{Low competition}" "\textbf{High competition}", pattern(1 0 1 0 1 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(1.ID "ID"
				  1.post "Post"
				  1.ID#1.post "\$ID\times Post$"
				  _cons "Constant")
		stats(year district control effect N, labels("Year FE" "District FE" "Controls" "Model" "N")
		fmt(0 0 0 0 0 0 0)) collabels(none) label booktabs nonotes;
		#delimit cr			
	
************************	
* heterogenous effects
************************

gen IDP=ID*post
gen postP=post*competitive
gen IDC=ID*competitive 
gen IDPC=ID*post*competitive 


set more off	
tempfile z_projpc1000a z_projpc1000b z_projpc1000c
tempfile z_lnumproja z_lnumprojb z_lnumprojc
tempfile z_lspendinga z_lspendingb z_lspendingc
tempfile z_spensdingsharea z_spensdingshareb z_spensdingsharec


gl DVs z_projpc1000 z_lnumproj z_lspending z_spensdingshare  
su $DVs

foreach y in  $DVs {

* random effects model (no control)

mixed `y' ID competitive post IDP IDC postP IDPC logftotalspend i.distrid i.fyid  || subc_id:, cl(subc_id)
	estadd local year "X"
	estadd local district "X"
	estadd local control ""
	estadd local effects "MLV"
	est store `y'_m4
	margins, dydx(IDPC) atmeans 
	
mixed `y' ID IDP post logftotalspend i.distrid i.fyid if competitive==0  || subc_id:, cl(subc_id)
	est store `y'_m4_0
	margins, dydx(IDP)

mixed `y' ID IDP post logftotalspend i.distrid i.fyid if competitive==1  || subc_id:, cl(subc_id)
	est store `y'_m4_1
	margins, dydx(IDP)

* random effects model (with controls and district FEs) 
mixed `y' ID competitive post IDP IDC postP IDPC logftotalspend $controls i.distrid i.fyid  || subc_id:, cl(subc_id)
	estadd local year "X"
	estadd local district "X"
	estadd local control "X"
	estadd local effects "MLV"
	est store `y'_m5
	margins, dydx(IDPC) atmeans post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'a') 
	
mixed `y' ID IDP post logftotalspend $controls i.distrid i.fyid if competitive==0  || subc_id:, cl(subc_id)
	est store `y'_m5_0
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'b')

mixed `y' ID IDP post logftotalspend $controls i.distrid i.fyid if competitive==1  || subc_id:, cl(subc_id)
	est store `y'_m5_1
	margins, dydx(IDP) post
	parmest, label bmat(r(b)) vmat(r(V)) saving(``y'c')	
}

*********************************************	
* fit share of budget (proportion) using GLM
*********************************************
tempfile spensdingshared1 spensdingshared2 spensdingshared3 

glm spensdingshare ID competitive post IDP IDC postP IDPC logftotalspend $controls i.distrid i.fyid , cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local year "X"
	estadd local district "X"
	estadd local control "X"
	estadd local effects "GLM"
	est store spensdingshare_m6
	margins, dydx(IDPC) atmeans post
	parmest, label bmat(r(b)) vmat(r(V)) saving(`spensdingshared1') 

glm spensdingshare ID post IDP logftotalspend $controls i.distrid i.fyid if competitive==0  , cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local year "X"
	estadd local district "X"
	estadd local control "X"
	estadd local effects "GLM"
	est store spensdingshare_m7
	margins, dydx(IDP) atmeans post
	parmest, label bmat(r(b)) vmat(r(V)) saving(`spensdingshared2') 

glm spensdingshare ID post IDP logftotalspend $controls i.distrid i.fyid if competitive==1  , cl(subc_id) link(logit) family(binomial) nolog 	
	estadd local year "X"
	estadd local district "X"
	estadd local control "X"
	estadd local effects "GLM"
	est store spensdingshare_m8
	margins, dydx(IDP) atmeans post
	parmest, label bmat(r(b)) vmat(r(V)) saving(`spensdingshared3') 
/*	
*********************************************
*Table  online appendix
*********************************************

# delimit ; 
esttab  z_lspending_m4 z_lspending_m5
		z_lnumproj_m4 z_lnumproj_m5
		spensdingshare_m4 spensdingshare_m5 spensdingshare_m6
using "tables/ProjectsConditional.tex",
		keep(ID competitive post IDP IDC postP IDPC _cons)
	    order(ID competitive post IDP IDC postP IDPC _cons)
		cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par))
		starlevels(* .10 ** .05 *** .01) 					
		mgroups("\textbf{Log Spending}" "\textbf{N. Projects}" "\textbf{Share of Spending}", pattern(1 0 1 0 1 0 0)
		span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})) nomtitles
		varlabels(ID "ID"
					post "Post"
					competitive "Competitive"
					IDC "\$ID \times Competitive$"
					IDP "\$ID \times Post$"
					postP "\$Post \times Competitive$" 
					IDPC "\$ID \times Post \times Competitive$"
				  _cons "Constant")
		stats(effects year district control N, labels("Model" "Year FE" "District FE" "Controls" "N")
		fmt(0 0 0 0 0 0 0)) collabels(none) label booktabs nonotes
		replace;
#delimit cr
*/	
*********************************************	
* Save estimates model 5 to graph in R
*********************************************

preserve 
use `z_lspendinga', clear
append using `z_lspendingb'
append using `z_lspendingc' 
append using `z_lnumproja' 
append using `z_lnumprojb'
append using `z_lnumprojc'
append using `spensdingshared1' 
append using `spensdingshared2'
append using `spensdingshared3'

replace label="Diff" if parm=="IDPC" 
replace label = "C-Low" in 2
replace label = "C-High" in 3
replace label = "C-Low" in 5
replace label = "C-High" in 6
replace label = "C-Low" in 8
replace label = "C-High" in 9

replace parm="ID" if parm=="IDP" | parm=="IDPC"

gen DV="Spending (log)" 
replace DV="N. Projects (log)" in 4/6
replace DV="Spending share" in 7/9
saveold "estimates/BudgetCond.dta", replace
restore	



