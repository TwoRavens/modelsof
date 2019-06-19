***THIS DO FILE CREATES AGGREGATE EVENT DUMMIES 
***THAT EACH PARENT COMPANY EXPERIENCES IN ITS INVESTED COUNTRY,
***AS WELL AS COMPUTES MARKET RETURNS
***
***THIS ALSO CREATES SUBSIDIARY SIZE MEASURE FOR EACH PARENT
***BY USING intense_* AND employ_* VARIABLES


** CREATE AGGREGATE EVENT DUMMIES
clear
set mem 200m
set more off

*cd "M:\mg\craddatz\Shinsuke\HIPC&MDRI\Estimation"
*cd "Z:\HIPC Paper\Estimation"

use "Data_ZAF.dta", clear

duplicates drop ticker date, force

capture gen year = year(Date)
drop if year<1995 //years before 1996 are irrelevant for our event study, we use one year early for completeness

local countries "ago ben bfa bdi cmr caf tcd com zar	cog civ eri eth	gmb gha gin gnb ken lbr mdg mwi mli mrt moz ner rwa stp sen	sle som sdn tza tgo uga zmb"
local nohipc "ago ben bfa caf tcd com gnq eri gmb gha gin ken lbr mwi mli mrt sen	sle som tgo"  //Fill here the list of countries that were not elegible under the original HIPC initiative
local noehipc "ago gnq ken" //Fill here the list of countries that were not elegible under the enhanced HIPC initiative

gen dec_hipc =.
gen dec_ehipc =.
gen comp_hipc = .
gen comp_ehipc = .
gen hipc1_event = .
gen hipc2_event = .
gen ehipc1_event=.
gen ehipc1s_event=.
gen ehipc2_event=.
gen mdri0_event = .
gen mdri1_event = .
gen mdri1s_event = .
gen mdri2_event = .
gen mdri2alt_event = .


foreach c of local countries {
     di ("`c'")
     
    //Decision event under HIPC
    
    capture gen tmp = Dinv_`c'*dec_`c'
    if _rc~=0 gen tmp = 0
    egen tmp2 = rmax(dec_hipc tmp)
    replace dec_hipc = tmp2
    drop tmp tmp2
    
    //Decision event under enhanced HIPC
    
    capture gen tmp = Dinv_`c'*dec_e_`c'
    if _rc~=0 gen tmp = 0
    egen tmp2 = rmax(dec_ehipc tmp)
    replace dec_ehipc = tmp2
    drop tmp tmp2
    
 //Completion event under HIPC
    
    capture gen tmp = Dinv_`c'*comp_`c'
    if _rc~=0 gen tmp = 0
    egen tmp2 = rmax(comp_hipc tmp)
    replace comp_hipc = tmp2
    drop tmp tmp2

//Completion event under enhanced HIPC
    
    capture gen tmp = Dinv_`c'*comp_e_`c'
    if _rc~=0 gen tmp = 0
    egen tmp2 = rmax(comp_ehipc tmp)
    replace comp_ehipc = tmp2
    drop tmp tmp2


//NOTE: TREAT THE FOLLOWING 3 COUNTRIES AS NON-HIPC FOR CERTAIN TIME PERIODS.
//MALAWI BECAME HIPC SOME TIME BETWEEN JULY 1998 AND APRIL 1999.
//THE GAMBIA BECAME HIPC SOME TIME BETWEEN DECEMBER 1999 AND SEPTEMBER 2000 
//EQUATORIAL GUINEA BECAME NON-HIPC SOME TIME AFTER SEPTEMBER 1999.

    
//HIPC1
    
    capture gen tmp = Dinv_`c'*hipc1
    if _rc~=0 gen tmp = 0
    else if _rc==0 {
        if strpos("`nohipc'","`c")~=0 replace tmp=0
    }
    replace tmp=0 if strpos("mwi","`c'")~=0 
    replace tmp=0 if strpos("gmb","`c'")~=0 
    egen tmp2 = rmax(hipc1_event tmp)
    replace hipc1_event = tmp2
    drop tmp tmp2

//HIPC2
    
    capture gen tmp = Dinv_`c'*hipc2
    if _rc~=0 gen tmp = 0
    else if _rc==0 {
        if strpos("`nohipc'","`c")~=0 replace tmp=0
    }
    replace tmp=0 if strpos("mwi","`c'")~=0 
    replace tmp=0 if strpos("gmb","`c'")~=0 
    egen tmp2 = rmax(hipc2_event tmp)
    replace hipc2_event = tmp2
    drop tmp tmp2

//ENHANCED HIPC1
    
    capture gen tmp = Dinv_`c'*ehipc1
    if _rc~=0 gen tmp = 0
    else if _rc==0 {
        if strpos("`noehipc'","`c")~=0 {
        di "here"
        replace tmp=0
        }
    }
    replace tmp=0 if strpos("gmb","`c'")~=0 
    egen tmp2 = rmax(ehipc1_event tmp)
    replace ehipc1_event = tmp2
    drop tmp tmp2

//ENHANCED HIPC1s
    
    capture gen tmp = Dinv_`c'*ehipc1s
    if _rc~=0 gen tmp = 0
    else if _rc==0 {
        if strpos("`noehipc'","`c")~=0 {
        di "here"
        replace tmp=0
        }
    }
    replace tmp=0 if strpos("gmb","`c'")~=0 
    egen tmp2 = rmax(ehipc1s_event tmp)
    replace ehipc1s_event = tmp2
    drop tmp tmp2  

//ENHANCED HIPC2
    
    capture gen tmp = Dinv_`c'*ehipc2
    if _rc~=0 gen tmp = 0
    else if _rc==0 {
        if strpos("`noehipc'","`c")~=0 {
        di "here"
        replace tmp=0
        }
    }
    replace tmp=0 if strpos("gmb","`c'")~=0 
    egen tmp2 = rmax(ehipc2_event tmp)
    replace ehipc2_event = tmp2
    drop tmp tmp2 

//MDRI0

    capture gen tmp = Dinv_`c'*mdri0
    if _rc~=0 gen tmp = 0
    replace tmp=0 if strpos("gnq","`c'")~=0 
    egen tmp2 = rmax(mdri0_event tmp)
    replace mdri0_event = tmp2
    drop tmp tmp2
 
//MDRI1

    capture gen tmp = Dinv_`c'*mdri1
    if _rc~=0 gen tmp = 0
    replace tmp=0 if strpos("gnq","`c'")~=0 
    egen tmp2 = rmax(mdri1_event tmp)
    replace mdri1_event = tmp2
    drop tmp tmp2 

//MDRI1s

    capture gen tmp = Dinv_`c'*mdri1s
    if _rc~=0 gen tmp = 0
    replace tmp=0 if strpos("gnq","`c'")~=0 
    egen tmp2 = rmax(mdri1s_event tmp)
    replace mdri1s_event = tmp2
    drop tmp tmp2  
 
//MDRI2

    capture gen tmp = Dinv_`c'*mdri2
    if _rc~=0 gen tmp = 0
    replace tmp=0 if strpos("gnq","`c'")~=0 
    egen tmp2 = rmax(mdri2_event tmp)
    replace mdri2_event = tmp2
    drop tmp tmp2  

//MDRI2alt

    capture gen tmp = Dinv_`c'*mdri2alt
    if _rc~=0 gen tmp = 0
    replace tmp=0 if strpos("gnq","`c'")~=0 
    egen tmp2 = rmax(mdri2alt_event tmp)
    replace mdri2alt_event = tmp2
    drop tmp tmp2 
}

 



drop date year p_close vwap volume active
rename Date date

egen anyevent1 = rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc1_event ehipc1_event mdri1_event)
egen anyevent1summit = rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc1_event ehipc1s_event mdri1s_event)
egen anyevent2 = rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc2_event ehipc2_event mdri2_event)
egen anyevent2alt = rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc2_event ehipc2_event mdri2alt_event)

egen debtreliefevent = rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc)
egen debtrelief_hipc = rmax(dec_hipc comp_hipc)
egen debtrelief_ehipc = rmax(dec_ehipc comp_ehipc)

egen majorinitiative1 = rmax( hipc1_event ehipc1_event mdri1_event)
egen majorinitiative1summit = rmax(hipc1_event ehipc1s_event mdri1s_event)
egen majorinitiative2 = rmax( hipc2_event ehipc2_event mdri2_event)
egen majorinitiative2alt = rmax(hipc2_event ehipc2_event mdri2alt_event)
egen compevent        = rmax( comp_hipc comp_ehipc)
egen decevent         = rmax( dec_hipc dec_ehipc)


label var anyevent1  "rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc1_event ehipc1_event mdri1_event)"
label var anyevent1summit  "rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc1_event ehipc1s_event mdri1s_event)"
label var anyevent2 "rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc2_event ehipc2_event mdri2_event)"
label var anyevent2alt "rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc hipc2_event ehipc2_event mdri2alt_event)"
label var debtrelief_hipc "rmax(dec_hipc comp_hipc)"
label var debtrelief_ehipc "rmax(dec_ehipc comp_ehipc)"
label var debtreliefevent "rmax(dec_hipc dec_ehipc comp_hipc comp_ehipc)"
label var majorinitiative1 "rmax( hipc1_event ehipc1_event mdri1_event)"
label var majorinitiative1summit "Summit dates: rmax( hipc1_event ehipc0_event mdri0_event)"
label var majorinitiative2 "rmax( hipc2_event ehipc2_event mdri2_event)"
label var majorinitiative2alt "Correct MDRI date: rmax(hipc2_event ehipc2_event mdri2alt_event)"
label var compevent        "rmax( comp_hipc comp_ehipc)"
label var decevent         "rmax( dec_hipc dec_ehipc)"

label var	dec_hipc	"Dummy if a parent company had investment in any HIPC countries in their reaching a decision point under HIPC	"
label var	comp_hipc	"Dummy if a parent company had investment in any HIPC countries in their reaching a completion point under HIPC"
label var	dec_ehipc	"Dummy if a parent company had investment in any HIPC countries in their reaching a decision point under Enhanced HIPC"
label var	comp_ehipc	"Dummy if a parent company had investment in any HIPC countries in their reaching a completion point under Enhanced HIPC"
label var 	hipc1_event 	"Dummy if a parent company had investment in any HIPC countries when HIPC Initiative was agreed at G7 financial meeting"
label var 	hipc2_event     "Dummy if a parent company had investment in any HIPC countries when HIPC Initiative was approved by IMF and WB"
label var 	ehipc1_event 	"Dummy if a parent company had investment in any HIPC countries when EHIPC Initiative was agreed at G7 financial meeting"
label var 	ehipc1s_event 	"Dummy if a parent company had investment in any HIPC countries when EHIPC Initiative was agreed at G8 summit"
label var 	ehipc2_event     "Dummy if a parent company had investment in any HIPC countries when EHIPC Initiative was approved by IMF and WB"
label var 	mdri0_event 	"Dummy if a parent company had investment in any HIPC countries when G7 nations showed willingness to consider MDRI"
label var 	mdri1_event 	"Dummy if a parent company had investment in any HIPC countries when MDRI was agreed at G7 financial meeting"
label var 	mdri1s_event 	"Dummy if a parent company had investment in any HIPC countries when the MDRI concept was reaffirmed at G8 summit"
label var 	mdri2_event     "Dummy if a parent company had investment in any HIPC countries when MDRI was approved by IMF and WB"
label var 	mdri2alt_event 	"Dummy if a parent company had investment in any HIPC countries when MDRI was intensely discussed at the IMF and WB annual September meeting"

compress

format date %d

***CREATE SUBSIDIARY SIZE MEASURE FOR EACH PARENT AT EACH POINT IN TIME
replace intense_mwi = 0 if date<=14060 /*Ineligible before 6/30/1998*/ 
replace intense_gmb = 0 if date<=14578 /*Ineligible before 11/30/1999*/ 
replace intense_gnq = 0 if date>=14518 /*Ineligible after 10/1/1999*/ 
replace employ_mwi = . if date<=14060 /*Ineligible before 6/30/1998*/ 
replace employ_gmb = . if date<=14578 /*Ineligible before 11/30/1999*/ 
replace employ_gnq = . if date>=14518 /*Ineligible after 10/1/1999*/ 

egen size_intense = rsum(intense_*) /*Sum up number of subsidiaries over HIPC countries where invested*/ 
egen size_employ = rmean(employ_*) /*Equal weight on each HIPC country where invested*/

label var size_intense "Number of subsidiaries in HIPC countries at each point in time"
label var size_employ "Avg labor force over subsidiaries at each point in time"
 
saveold Event_Dates_ZAF_Parents, replace

