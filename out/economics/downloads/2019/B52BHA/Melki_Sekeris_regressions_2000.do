******************************************************************************************************************************** This do-file runs the regression of Table 1-Column 5 for "Media-Driven Polarization. Evidence from the US" ********************************************************************************************************************************


************************************************************************* Load state-level media data from Campante & Do *************************************************************************
clear all
use "${path}/CampanteDo_MainData.dta", clear
* keep only the 2000 year of the panel dataset
keep if year==2000
* keep useful variables
keep fips pc1_gwahr pc1_swahr
*drop year
save "use "${path}/temp.dta", replace

************************************************************************* Load & Merge 2000 ANES data *************************************************************************
clear all
use "${path}/ANES_2000.dta", clear
* Genere year variabe = 2000
gen year=2000
* Rename state fips: V000080
rename V000080 fips
* Drop unidentified fips
drop if fips==96|fips==99
* Merge ANES and state data
merge m:1 fips using "${path}/temp.dta"
drop _merge
save "${path}/ANES_2000.dta", replace
erase "${path}/temp.dta"
* Keep relevant variables 
keep fips pc1_gwahr pc1_swahr V000446 V001201 V000333 V000337 V000303 V000908 V000994 V000913 V000041 V001029 ///
V000092 V000301

************************************************************************* Genere variables of interest *************************************************************************

* Genere Ideological variables******************************
* Genere "ideologic1" var. based on the 7-point scale
	* Notes: V000446: pre-election summary self plcmnt lib-con scale/  ==> 1 (lib) to 7 (cons)
	* clean: replace "Refused", "Don't know", "Haven't thought much about it"
	replace V000446=. if V000446==-7|V000446==-8|V000446==-9
	* Genere ideological voters variable
	gen 	ideologic1=1 if V000446==1|V000446==7
	replace	ideologic1=0 if V000446==2|V000446==3|V000446==4|V000446==5|V000446==6
* Genere "ideologic2": alternative var. based on the 7-point scale. Considers "liberal" and "conservative" as ideological
	gen 	ideologic2=ideologic
	replace ideologic2=1 if V000446==2|V000446==6

* Genere Information/interest variables********************************
* Not available in the 2000 ANES: Genere "info": V083303 "PRE IWR OBS: R level of information" from 1=very high to 5=very low
* Genere "interest" based on V001201
	* V001201 "Interested in following campaigns"
	replace V001201=. if V001201==-1|V001201==-9
	gen 	interest=1 if V001201==1|V001201==2
	replace interest=0 if V001201==3|V001201==4|V001201==5
* Genere "follow"
	*V000301 "CSES: How closely did R follow the election campaign"
	*clean
	replace V000301=. if V000301<0
	gen 	follow=1 if V000301==1|V000301==2
	replace follow=0 if V000301==3|V000301==4
* Genere "local_news"
	*V000333 "[OLD] Attention to local news"
	*clean
	replace V000333=. if V000333<0
	gen 	local_news=1 if V000333==1|V000333==2
	replace local_news=0 if V000333==3|V000333==4|V000333==5

* Genere Media variables************************
* Genere "attention_paper"
	* Notes: V000337 "Attention to newspaper articles"
	* clean for INAP
	replace V000337 =. if V000337<0
	gen 	attention_paper=1 if V000337==1|V000337==2
	replace attention_paper=0 if V000337==3|V000337==4|V000337==5
	* genere "attention_paper2"
	gen 	attention_paper2=attention_paper
	replace	attention_paper2=1 if V000337==3
 
************************************************************************* Genere control variables *************************************************************************
rename V000908 age
* household income
rename V000994 income
rename V000913 educ
	label var educ education
rename V000041 household
gen male=1 if V001029==1
replace male=0 if V001029 ==2
* not availavle: rename urban

*V000092 "Census Region"
qui tab V000092, gen(region_)
qui tab fips, gen(state_)
* genere macro
local indiv_cov age income educ male household
* genere interactions
foreach x of varlist educ interest follow local_news attention_paper {
	gen `x'_gwahr=`x'*pc1_gwahr
	gen `x'_swahr=`x'*pc1_swahr
	}

************************************************************************* Table 1. Polarization and Media Coverage - Column 5 *************************************************************************
	* Column 5
	prob ideologic2 interest interest_gwahr `indiv_cov' state_*
	outreg2 using anes2000.doc, nocons keep(interest interest_gwahr) addtext(Controls, "X", State dummies,"X") label replace

************************************************************************* End *************************************************************************
