/////////////////////////////////////
/// CAMS TIME-USE VARIABLES DATASET CONSTRUCTION ///
/////////////////////////////////////

clear
clear matrix
clear mata
set mem 500m
set maxvar 15000
set matsize 800
set more off

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                         Working Directory                                    //

cd "C:\Users\User\Dropbox\LAPTOP_db\RAND\Data\"

//////////////////////////////////////////////////////////////////////////////////////////////////
// Use ALL PANEL: longitudinal file with all waves with raw consumption data and time-use variables

use "cams2\all_panel.dta", clear

rename incams01 camswave1
rename incams03 camswave2
rename incams05 camswave3
rename incams07 camswave4
rename incams09 camswave5
rename incams11 camswave6

tostring hhidpn, gen(hhidpnstr)
gen hhnrhstr = regexs(0) if(regexm(hhidpnstr, "[0-9][0-9][0-9][0-9][0-9]")) & hhidpn<=99999999
replace hhnrhstr = regexs(0) if(regexm(hhidpnstr, "[0-9][0-9][0-9][0-9][0-9][0-9]")) & hhidpn>99999999
destring hhnrhstr, gen(hhnrh)
egen hhnr=max(hhnrh), by(hhidpn)

forvalues i=1(1)6 {

//Check item non-response
egen w`i'_miss_a1_31 = rowmiss(w`i'a1-w`i'a31) if camswave`i'==1
egen w`i'_miss_a1_33 = rowmiss(w`i'a1-w`i'a33) if camswave`i'==1 & `i'>1
gen w`i'_miss=w`i'_miss_a1_33
replace w`i'_miss=w`i'_miss_a1_31 if `i'==1

forvalues j=1(1)33 {
gen w`i'_miss_`j'=(w`i'_miss==`j')
} 

//sum w?_miss?
//sum w?_miss??
//Item non-response fairly small. ~5% of persons with 1 non-response in all waves.

	 //Replace . by 0
	forvalues j=1(1)33 {
	gen tw`i'a`j'=w`i'a`j'
	recode w`i'a`j' (.=0) //Otherwise sums will be zero due to item non-response. (No large effect Hurd & Rohwedder 2007)
	}

     //Construct time-use categories per wave
	 gen tuw`i'_work  		= w`i'a10
     gen tuw`i'_clean 		= w`i'a13
     gen tuw`i'_wash  		= w`i'a14
     gen tuw`i'_yrd   		= w`i'a15
     gen tuw`i'_shop  		= w`i'a16
     gen tuw`i'_cook  		= w`i'a17
     gen tuw`i'_monmng		= w`i'a25/4.3
	 gen tuw`i'_entrtn 		= w`i'a28/4.3
     gen tuw`i'_diy   		= w`i'a31/4.3
     gen tuw`i'_car   		= w`i'a32/4.3
     gen tuw`i'_dinout  	= w`i'a33/4.3
	 
	 //replace non-existing vars for wave 1
	 replace tuw`i'_car =. if `i'==1
     replace tuw`i'_dinout =. if `i'==1
	 
	 //construct leisure categories per wave
	 gen tuw`i'_tv  		= w`i'a1
	 gen tuw`i'_read1  		= w`i'a2
	 gen tuw`i'_read2  		= w`i'a3
	 gen tuw`i'_music  		= w`i'a4
	 gen tuw`i'_sleep  		= w`i'a5
	 gen tuw`i'_walk  		= w`i'a6
	 gen tuw`i'_sports 		= w`i'a7
	 gen tuw`i'_visit  		= w`i'a8
	 gen tuw`i'_comm  		= w`i'a9
	 gen tuw`i'_compu  		= w`i'a11
	 gen tuw`i'_pray  		= w`i'a12
	 gen tuw`i'_hyg  		= w`i'a18
	 gen tuw`i'_pets  		= w`i'a19
	 gen tuw`i'_affect 		= w`i'a20
	 gen tuw`i'_help  		= w`i'a21/4.3
	 gen tuw`i'_volunt  	= w`i'a22/4.3
	 gen tuw`i'_reli  		= w`i'a23/4.3
 	 gen tuw`i'_relim  		= w`i'a24/4.3
	 gen tuw`i'_health 		= w`i'a26/4.3
	 gen tuw`i'_games  		= w`i'a27/4.3
	 gen tuw`i'_sing  		= w`i'a29/4.3
	 gen tuw`i'_knit  		= w`i'a30/4.3

	
	 
	 //*LEVELS
	 //construct sum of substitutes levels
	 gen tuw`i'_subst =w`i'a13 + w`i'a14 + w`i'a15 + w`i'a16 + w`i'a17 + tuw`i'_monmng + tuw`i'_diy if `i'==1 //a32 not available for wave1
     replace tuw`i'_subst =w`i'a13 + w`i'a14 + w`i'a15 + w`i'a16 + w`i'a17 + tuw`i'_monmng + tuw`i'_diy+ tuw`i'_car if `i'>1

	 //construct sum of complements levels
     gen tuw`i'_comp = tuw`i'_entrtn if `i'==1
	 replace tuw`i'_comp = tuw`i'_entrtn + tuw`i'_dinout if `i'>1
	 
	 //construct sum of leisure
	 gen tuw`i'_leisure = tuw`i'_tv + tuw`i'_read1 + tuw`i'_read2 + tuw`i'_music + tuw`i'_sleep + tuw`i'_walk + tuw`i'_sports + tuw`i'_visit + tuw`i'_comm + tuw`i'_compu + tuw`i'_pray + tuw`i'_hyg + tuw`i'_pets + tuw`i'_affect + tuw`i'_help + tuw`i'_volunt + tuw`i'_reli + tuw`i'_relim + tuw`i'_health + tuw`i'_games + tuw`i'_sing + tuw`i'_knit

	 //construct sum of total time-use
	 egen tuw`i'_a1_20  =rsum(w`i'a1-w`i'a20)      //if camswave`i'==1
     egen tuw`i'_a21_31 =rsum(w`i'a21-w`i'a31)     //if camswave`i'==1
	 egen tuw`i'_a32_33 =rsum(w`i'a32-w`i'a33)  if `i'>1 //a32 and a33 missing in wave1
     gen tuw`i'_all     =tuw`i'_a1_20*4.3+tuw`i'_a21_31 if `i'==1
	 replace tuw`i'_all =tuw`i'_a1_20*4.3+tuw`i'_a21_31+tuw`i'_a32_33 if `i'>1
	 
	 
	 //*FRACTION OF TOTAL HOURS IN A MONTH
	 foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp all {
	 gen tufw`i'_`x'=(tuw`i'_`x'*4.3)/720
	 }
	 
	 foreach x in tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
	 gen tufw`i'_`x'=(tuw`i'_`x'*4.3)/720
	 }	 
	 
	 
	 //*BUDGET SHARES
	 //construct time-use budget shares
	 gen tbsw`i'_work   = w`i'a10*4.3 / tuw`i'_all
     gen tbsw`i'_clean  = w`i'a13*4.3 / tuw`i'_all
     gen tbsw`i'_wash   = w`i'a14*4.3 / tuw`i'_all
     gen tbsw`i'_yrd    = w`i'a15*4.3 / tuw`i'_all
     gen tbsw`i'_shop   = w`i'a16*4.3 / tuw`i'_all
     gen tbsw`i'_cook   = w`i'a17*4.3 / tuw`i'_all
     gen tbsw`i'_monmng = w`i'a25     / tuw`i'_all
     gen tbsw`i'_entrtn = w`i'a28     / tuw`i'_all
     gen tbsw`i'_diy    = w`i'a31     / tuw`i'_all
	 gen tbsw`i'_car	= w`i'a32	  / tuw`i'_all
	 gen tbsw`i'_dinout	= w`i'a33	  / tuw`i'_all

	 replace tbsw`i'_car=. if `i'==1
	 replace tbsw`i'_dinout=. if `i'==1
	 
	 gen tbsw`i'_tv  		= w`i'a1*4.3 / tuw`i'_all
	 gen tbsw`i'_read1  	= w`i'a2*4.3 / tuw`i'_all
	 gen tbsw`i'_read2  	= w`i'a3*4.3/ tuw`i'_all
	 gen tbsw`i'_music  	= w`i'a4*4.3/ tuw`i'_all
	 gen tbsw`i'_sleep  	= w`i'a5*4.3/ tuw`i'_all
	 gen tbsw`i'_walk  		= w`i'a6*4.3/ tuw`i'_all
	 gen tbsw`i'_sports 	= w`i'a7*4.3/ tuw`i'_all
	 gen tbsw`i'_visit  	= w`i'a8*4.3/ tuw`i'_all
	 gen tbsw`i'_comm  		= w`i'a9*4.3/ tuw`i'_all
	 gen tbsw`i'_compu  	= w`i'a11*4.3/ tuw`i'_all
	 gen tbsw`i'_pray  		= w`i'a12*4.3/ tuw`i'_all
	 gen tbsw`i'_hyg  		= w`i'a18*4.3/ tuw`i'_all
	 gen tbsw`i'_pets  		= w`i'a19*4.3/ tuw`i'_all
	 gen tbsw`i'_affect 	= w`i'a20*4.3/ tuw`i'_all
	 gen tbsw`i'_help  		= w`i'a21/ tuw`i'_all
	 gen tbsw`i'_volunt  	= w`i'a22/ tuw`i'_all
	 gen tbsw`i'_reli  		= w`i'a23/ tuw`i'_all
 	 gen tbsw`i'_relim  	= w`i'a24/ tuw`i'_all
	 gen tbsw`i'_health 	= w`i'a26/ tuw`i'_all
	 gen tbsw`i'_games  	= w`i'a27/ tuw`i'_all
	 gen tbsw`i'_sing  		= w`i'a29/ tuw`i'_all
	 gen tbsw`i'_knit  		= w`i'a30/ tuw`i'_all
	 

	 foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit {
	 replace tbsw`i'_`x'=0 if tuw`i'_all==0
	 }
	 
	 //construct sum of substitutes budget shares
     gen tbsw`i'_subst =(tbsw`i'_clean + tbsw`i'_wash + tbsw`i'_yrd + tbsw`i'_shop + tbsw`i'_cook + tbsw`i'_monmng + tbsw`i'_diy) if `i'==1
	 replace tbsw`i'_subst =(tbsw`i'_clean + tbsw`i'_wash + tbsw`i'_yrd + tbsw`i'_shop + tbsw`i'_cook + tbsw`i'_monmng + tbsw`i'_diy + tbsw`i'_car) if `i'>1 //a32 not available for wave1
	 
	 //construct sum of complements budget shares
     gen tbsw`i'_comp = tbsw`i'_entrtn if `i'==1
	 replace tbsw`i'_comp = tbsw`i'_entrtn + tbsw`i'_dinout if `i'>1
	 
	 //construct sum of leisure budget share
 	 gen tbsw`i'_leisure = (tbsw`i'_tv + tbsw`i'_read1 + tbsw`i'_read2 + tbsw`i'_music + tbsw`i'_sleep + tbsw`i'_walk + tbsw`i'_sports + tbsw`i'_visit + tbsw`i'_comm + tbsw`i'_compu + tbsw`i'_pray + tbsw`i'_hyg + tbsw`i'_pets + tbsw`i'_affect + tbsw`i'_help + tbsw`i'_volunt + tbsw`i'_reli + tbsw`i'_relim + tbsw`i'_health + tbsw`i'_games + tbsw`i'_sing + tbsw`i'_knit)

	 gen test_sumall`i' = tbsw`i'_work + tbsw`i'_leisure + tbsw`i'_subst + tbsw`i'_comp
	 
	 
	 
	 //Construct HOUSEHOLD LEVEL vars
	//Time-use variables at the HOUSEHOLD level
	//LEVEL
	foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp all tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
	egen tuw`i'_`x'_hh=sum(tuw`i'_`x') if tuw`i'_`x'~=. & camswave`i'==1, by(hhnr)
	//replace tuwx_`x'_hh=tuwx_`x'_hh/2 if tuwx_`x'~=. & shhidpn>0 //normalize to single household
	}

	//FRACTION
	//foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp all {
	//egen frac_tuwx_`x'_hh=sum(frac_tuwx_`x'), by(hxhhid camswave)
	//replace frac_tuwx_`x'_hh=tuwx_`x'_hh/2 if shhidpn>0 //normalize to single household
	//}

	//BUDGET SHARE
	foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
	gen tbsw`i'_`x'_hh=tuw`i'_`x'_hh/tuw`i'_all_hh
	}

}

sum tuw?_*
sum tufw?_*
sum tbsw?_*

/*
//Differences in time-use between waves
foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst {
forvalues j=2(1)6 {
local i=`j'-1 
gen dtuw`j'_`x' = tuw`j'_`x' - tuw`i'_`x'
gen dtbsw`j'_`x' = (tbsw`j'_`x' - tbsw`i'_`x')/tbsw`i'_`x'
}
}

sum dtuw?_*
sum dtbsw?_*
*/


/*
//EXTRA questions wave4-6
forvalues i=4(1)6 {
gen tuw`i'_dinhome=w`i'a34-tuw`i'_dinout

gen w`i'a35=w`i'a35a
replace w`i'a35=w`i'a35b/4.3
replace w`i'a35=w`i'a35c/52

gen w`i'a37=w`i'a37a
replace w`i'a37=w`i'a37b/4.3
replace w`i'a37=w`i'a37c/52
}
*/



save "cams2\cams_time-use_wide.dta", replace

keep hhidpn tuw?_* tbsw?_* tufw?_* tw?a* w?a37 w?a38 w?a40 w?a41 a44 a45


// Merging Time-use and cams_reg (Marco) //
sort hhidpn 
merge 1:m hhidpn  using "cams2\cams_reg.dta"
drop if _merge==1 //Persons from Wave1 are not in cams_reg.dta (waves2-6)
//drop _merge

sort hhidpn camswave

//Make long variables for time-use
foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp all tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
gen tuwx_`x'=.
gen tuwx_`x'_hh=.
gen tufwx_`x'=.
}

foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
gen tbswx_`x'=.
}

foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp all tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
forvalues i=1(1)6 {
replace tuwx_`x'=tuw`i'_`x' if camswave==`i'
replace tuwx_`x'_hh=tuw`i'_`x'_hh if camswave==`i'
replace tuwx_`x'_hh=tuw`i'_`x' if camswave==`i' & hcpl==0 //singles
replace tufwx_`x'=tufw`i'_`x' if camswave==`i'
}
}

foreach x in work clean wash yrd shop cook monmng entrtn diy car dinout subst comp tv read1 read2 music sleep walk sports visit comm compu pray hyg pets affect help volunt reli relim health games sing knit leisure {
forvalues i=1(1)6 {
replace tbswx_`x'=tbsw`i'_`x' if camswave==`i'
}
}

//Long variables for . test
forvalues j=1(1)33 {
gen twxa`j'=.
}

forvalues i=1(1)6 {
forvalues j=1(1)33 {
replace twxa`j'=tw`i'a`j' if camswave==`i'
}
}

//TIME ON FILLING OUT SURVEY
gen fillout = a45


//Drop wide variables
forvalues i=1(1)6 {
drop tuw`i'_*
drop tufw`i'_*
drop tbsw`i'_*
drop tw`i'a*
}




//The 7 categories of Aguiar et al AER 2013
gen tuwx_mp = tuwx_work //Market Work
//included in working for pay //Other income generating activities
//not in the CAMS //Job search
//not in the CAMS //Childcare
gen tuwx_hp = tuwx_cook + tuwx_clean + tuwx_wash + tuwx_car + tuwx_diy + tuwx_monmng + tuwx_yrd + tuwx_shop //Home production
gen tuwx_l = tuwx_leisure + tuwx_comp - tuwx_health - tuwx_reli - tuwx_relim - tuwx_volunt //Leisure
gen tuwx_other = tuwx_health + tuwx_reli + tuwx_relim + tuwx_volunt //Other

gen tuwx_mp_hh = tuwx_work_hh //Market Work
gen tuwx_hp_hh = tuwx_cook_hh + tuwx_clean_hh + tuwx_wash_hh + tuwx_car_hh + tuwx_diy_hh + tuwx_monmng_hh + tuwx_yrd_hh + tuwx_shop_hh //Home production
gen tuwx_l_hh = tuwx_leisure_hh + tuwx_comp_hh - tuwx_health_hh - tuwx_reli_hh - tuwx_relim_hh - tuwx_volunt_hh //Leisure
gen tuwx_other_hh = tuwx_health_hh + tuwx_reli_hh + tuwx_relim_hh + tuwx_volunt_hh //Other

gen tufwx_mp = tufwx_work //Market Work
gen tufwx_hp = tufwx_cook + tufwx_clean + tufwx_wash + tufwx_car + tufwx_diy + tufwx_monmng + tufwx_yrd + tufwx_shop //Home produfction
gen tufwx_l = tufwx_leisure + tufwx_comp - tufwx_health - tufwx_reli - tufwx_relim - tufwx_volunt //Leisufre
gen tufwx_other = tufwx_health + tufwx_reli + tufwx_relim + tufwx_volunt //Other

gen tbswx_mp = tbswx_work //Market Work
gen tbswx_hp = tbswx_cook + tbswx_clean + tbswx_wash + tbswx_car + tbswx_diy + tbswx_monmng + tbswx_yrd + tbswx_shop //Home production
gen tbswx_l = tbswx_leisure + tbswx_comp - tbswx_health - tbswx_reli - tbswx_relim - tbswx_volunt //Leisure
gen tbswx_other = tbswx_health + tbswx_reli + tbswx_relim + tbswx_volunt //Other





xtset hhidpn camswave
keep if tuwx_all>0 //delete people that did not fill out time-use at all.
keep if camswave>=2


save "cams2\cams_long_cons_time-use", replace






