////////////////////////////////////////////////
/// CREATING REGRESSION SAMPLE AND VARIABLES ///
////////////////////////////////////////////////

clear
clear matrix
clear mata
set mem 500m
set maxvar 15000
set matsize 800
set more off

////////////////////////////////////////////////////////////////////////////////////////////
//                                    Working Directory                                   //

cd "/nfs/sch-data1/projects/dua-data-projects/HRS/angrisan/Paper_CAMS/Data"

use "cams_working.dta", clear

////////////////////////////////////////////////////////////////////////////////////////////

tsset hhidpn camswave

////////////////////////////////////////////////////////////////////////////////////////////
/// SAMPLE SELECTION                                                                     ///
/// 1) Drop CAMS respondents younger than 40 and older than 90                           ///
/// 2) Use CAMS respondent if he/she is between 51 and 90                                ///
/// 3) Use CAMS respondent's spouse if CAMS respondent is younger than 51 and older than ///
////////////////////////////////////////////////////////////////////////////////////////////

drop if rage<41 | rage>90

local l_age = 51
local u_age = 90

** Age Indicator **
    gen usvar = 1 if rage<`l_age' | (rage>`u_age' & rage<.)
replace usvar = 0 if rage>=`l_age' & rage<=`u_age'
bys hhidpn: egen usvar2 = max(usvar)

** Switching Individual Characteristics when Spouse is Selected **
    gen age = rage if usvar2==0
replace age = sage if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen health = rshlt if usvar2==0
replace health = sshlt if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen education = reduc if usvar2==0
replace education = seduc if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen work = rwork if usvar2==0
replace work = swork if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen labforce = rlbrf if usvar2==0
replace labforce = slbrf if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen henum = rhenum if usvar2==0
replace henum = shenum if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen higov = rhigov if usvar2==0
replace higov = shigov if usvar2==1 & sage>=`l_age' & sage<=`u_age'

    gen beq10k = rbeq10k if usvar2==0
replace beq10k = sbeq10k if usvar2==1 & sage>=`l_age' & sage<=`u_age'
    gen beq100 = rbeq100 if usvar2==0
replace beq100 = sbeq100 if usvar2==1 & sage>=`l_age' & sage<=`u_age'
    gen beqany = rbeqany if usvar2==0
replace beqany = sbeqany if usvar2==1 & sage>=`l_age' & sage<=`u_age'

drop usvar*

/////////////////////
// TIME INDICATORS //
/////////////////////

forval i=2/6 {
local a = `i'+4
gen d`i'_cams = (camswave==`i')
}

gen postcrisis = (d4_cams==1 | d5_cams==1)

/////////
// AGE //
/////////

recode age (51/55=1) (56/60=2) (61/65=3) (66/70=4) (71/75=5) (76/80=6) (81/85=7) (86/90=8), gen (age_cat)
label define age_cat 1 "1.51-55" 2 "2.56-60" 3 "3.61-65" 4 "4.66-70" 5 "5.71-75" 6 "6.76-80" 7 "7.81-85" 8 "8.86-90", replace
label values age_cat age_cat
gen age2 = age^2
forval i = 1/8 {
gen age_`i' = (age_cat==`i') if !missing(age_cat)
}

///////////////
// EDUCATION //
///////////////

recode education (1/2=1) (3=2) (4=3) (5=4), gen (edu_cat)
label define edu_cat 1 "1.Less Than HS" 2 "2.HS" 3 "3.Some College" 4 "4.College or More", replace
label values edu_cat edu_cat
gen edu_cat1 = (edu_cat==1) if !missing(edu_cat)
gen edu_cat2 = (edu_cat==2) if !missing(edu_cat)
gen edu_cat3 = (edu_cat==3) if !missing(edu_cat)
gen edu_cat4 = (edu_cat==4) if !missing(edu_cat)

///////////////////////////////////////
// MARITAL STATUS and HOUSEHOLD SIZE //
///////////////////////////////////////
 
recode hhhres (0/1=1) (5/15=5), gen (hsize)
gen usvar = F.hhhres-hhhres
    gen change_hsize = 0 if usvar==0
replace change_hsize = 1 if usvar<0 & !missing(usvar)
replace change_hsize = 2 if usvar>0 & !missing(usvar)
label define change_hsize 0 "0.No Change" 1 "1.Decrease" 2 "2.Increase", replace
label value change_hsize change_hsize
drop usvar

gen d_hhhres = F.hhhres-hhhres

recode rmstat (1/3=1) (4/6=2) (7=3) (8=4), gen (marital_cat)
gen usvar = F.hcpl-hcpl 
    gen change_marr = 0 if usvar==0
replace change_marr = 1 if usvar==-1
replace change_marr = 2 if usvar==1
label define change_marr 0 "0.No Change" 1 "1.From Partnered to Single" 2 "2.From Single to Partnered", replace
label value change_marr change_marr
drop usvar

gen change_marr0 = (change_marr==0) if !missing(change_marr)
gen change_marr1 = (change_marr==1) if !missing(change_marr)
gen change_marr2 = (change_marr==2) if !missing(change_marr)

/////////////////
// WORK STATUS //
/////////////////

    gen d_work = 0 if F.work==0 & work==0
replace d_work = 1 if F.work==1 & work==1
replace d_work = 2 if F.work==1 & work==0
replace d_work = 3 if F.work==0 & work==1
label define d_work 0 "0.NW-NW" 1 "1.W-W" 2 "2.NW-W" 3 "3.W-NW", replace
label values d_work d_work
gen d_work0 = (d_work==0) if !missing(d_work)
gen d_work1 = (d_work==1) if !missing(d_work)
gen d_work2 = (d_work==2) if !missing(d_work)
gen d_work3 = (d_work==3) if !missing(d_work)

///////////////////////////////////////////
// CHANGE IN SELF-REPORTED HEALTH STATUS //
///////////////////////////////////////////

    gen d_health = F.health-health
replace d_health = 1 if d_health>0 & !missing(d_health)
replace d_health = 2 if d_health<0 & !missing(d_health)
label define d_health 0 "0.No Change" 1 "1.Worsening" 2 "2.Improvement", replace
label values d_health d_health
gen d_health0 = (d_health==0) if !missing(d_health)
gen d_health1 = (d_health==1) if !missing(d_health)
gen d_health2 = (d_health==2) if !missing(d_health)

//////////////////////
// HEALTH INSURANCE //
//////////////////////

    gen private = .
replace private = 0 if henum==0       
replace private = 1 if henum>0  & henum<15
label var private "R has private insurance"

    gen unins = .
replace unins = 0 if higov==1 | private==1 
replace unins = 1 if higov==0 & private==0 	
label var unins "R has no health insurance"

gen funins = F.unins

    gen hi_status = . 
replace hi_status = 1 if higov == 0 & private==0
replace hi_status = 2 if higov == 1 & private==0
replace hi_status = 3 if private == 1
label var hi_status "Mutually exclusive health insurance status"

    gen d_unins = 0 if F.unins==0 & unins==0
replace d_unins = 1 if F.unins==1 & unins==1
replace d_unins = 2 if F.unins==1 & unins==0
replace d_unins = 3 if F.unins==0 & unins==1
label var d_unins "Change in unins (from t to t+1)"
label define d_unins 0 "0.no-no" 1 "1.yes-yes" 2 "2.no-yes" 3 "3.yes-no", replace
label values d_unins d_unins

/////////////
// BEQUEST //
/////////////

gen d_beq10k = (F.beq10k-beq10k)/100
gen d_beq100 = (F.beq100-beq100)/100
gen d_beqany = (F.beq10k-beqany)/100

////////////////////////////////////////////////////
// ASSET OWNERSHIP and EXPOSURE TO FINANCIAL RISK //
////////////////////////////////////////////////////

gen busi_own  = (habsns>0) if !missing(habsns)
gen ira_own   = (haira>0)  if !missing(haira)
gen stock_own = (hastck>0) if !missing(hastck)
gen chck_own  = (hachck>0) if !missing(hachck)
gen cd_own    = (hacd>0)   if !missing(hacd)
gen bond_own  = (habond>0) if !missing(habond)

    gen fin_exposure1 = stock_own
    gen fin_exposure2 = .
replace fin_exposure2 = 1 if stock_own==1 | ira_own==1
replace fin_exposure2 = 0 if stock_own==0 & ira_own==0
    gen fin_exposure3 = .
replace fin_exposure3 = 1 if stock_own==1 | ira_own==1 | bond_own==1
replace fin_exposure3 = 0 if stock_own==0 & ira_own==0 & bond_own==0
    gen fin_exposure4 = .
replace fin_exposure4 = 1 if stock_own==1 | bond_own==1 | busi_own==1
replace fin_exposure4 = 0 if stock_own==0 & bond_own==0 & busi_own==0
    gen fin_exposure5 = .
replace fin_exposure5 = 1 if stock_own==1 | ira_own==1 | bond_own==1 | busi_own==1
replace fin_exposure5 = 0 if stock_own==0 & ira_own==0 & bond_own==0 & busi_own==0

    gen house_own = .
replace house_own = 1 if hafhous<=5
replace house_own = 0 if hafhous==6
    gen house2_own = .
replace house2_own = 1 if hafhoub<=5
replace house2_own = 0 if hafhoub==6

    gen mortgage = .
replace mortgage = 0  if hafmort==6
replace mortgage = 1  if inlist(hafmort, 1, 2, 3, 5)	
replace mortgage = 1  if hafmort>9 & hafmort<26

    gen creditline = .
replace creditline = 0  if hafhmln==6
replace creditline = 1  if inlist(hafhmln, 1, 2, 3, 5)	
replace creditline = 1  if hafhmln>9 & hafhmln<76

    gen negequity = . 
replace negequity = 0 if hatoth>=0 & !missing(hatoth)
replace negequity = 1 if hatoth<0

gen debt1 = hamort + hahmln
gen debt2 = hamort + hahmln + hamrtb
gen debt3 = hadebt

//////////////////////////////////
// HOUSE AND STOCK TRANSACTIONS //
//////////////////////////////////

    gen tran_house = .
replace tran_house = 0 if boughtsold_home==5 & (house_own==1 | house2_own==1) & camswave==2
replace tran_house = 0 if boughtsold_home==. & (house_own==0 & house2_own==0) & camswave==2
replace tran_house = 1 if boughtsold_home==1 & (house_own==1 | house2_own==1) & camswave==2
forval i = 3/6 {
replace tran_house = 0 if boughtsold_home==5 & ((house_own==1 | house2_own==1) | (l.house_own==1 | l.house2_own==1)) & camswave==`i'
replace tran_house = 0 if boughtsold_home==. & ((house_own==0 & house2_own==0) & (l.house_own==0 & l.house2_own==0)) & camswave==`i'
replace tran_house = 1 if boughtsold_home==1 & ((house_own==1 | house2_own==1) | (l.house_own==1 | l.house2_own==1)) & camswave==`i'
}

by hhidpn: egen tran_house2 = max(tran_house)

    gen tran_stock = .
replace tran_stock = 0 if boughtstock==5 & soldstock==5   & stock_own==1 & camswave==2
replace tran_stock = 0 if boughtstock==. & soldstock==.   & stock_own==0 & camswave==2
replace tran_stock = 0 if boughtstock==5 & soldstock==.   & stock_own==1 & camswave==2
replace tran_stock = 0 if boughtstock==. & soldstock==5   & stock_own==1 & camswave==2
replace tran_stock = 1 if (boughtstock==1 | soldstock==1) & stock_own==1 & camswave==2
forval i = 3/6 {
replace tran_stock = 0 if boughtstock==5 & soldstock==5   & (stock_own==1 | l.stock_own==1) & camswave==`i'
replace tran_stock = 0 if boughtstock==. & soldstock==.   & (stock_own==0 & l.stock_own==0) & camswave==`i'
replace tran_stock = 0 if boughtstock==5 & soldstock==.   & (stock_own==1 | l.stock_own==1) & camswave==`i'
replace tran_stock = 0 if boughtstock==. & soldstock==5   & (stock_own==1 | l.stock_own==1) & camswave==`i'
replace tran_stock = 1 if (boughtstock==1 | soldstock==1) & (stock_own==1 | l.stock_own==1) & camswave==`i'
}

by hhidpn: egen tran_stock2 = max(tran_stock)

////////////////////////////////////////
// HOUSE PRICE AND STOCK MARKET INDEX //
////////////////////////////////////////

local list_market "sp djca wind master intrate ur_usa ur_bydiv ur_bystate cra_bystate cs hpi_usa hpi_bydiv hpi_bystate mort_bystate hown_bystate hvac_bystate"

foreach var in `list_market' {
gen l_`var' = ln(`var')
label var l_`var' "`var' in log"
gen d_`var' = F.`var'-`var'
label var d_`var' "changes in `var' (from t to t+1)"
gen dl_`var' = F.l_`var'-l_`var'
label var d_`var' "changes in log `var' (from t to t+1)"
}

////////////////////////////////////////////
// ALTERNATIVE INCOME AND WEALTH MEASURES //
////////////////////////////////////////////

gen finw1  = hastck + hacd + hachck + habond
gen finw2  = hastck + hacd + hachck + habond + haira
gen finw3  = hastck + habond
gen finw4  = hastck + habond + haira
gen saving = hacd + hachck 

gen tothw = hahous + hahoub
gen totw1 = hahous + finw1
gen totw2 = hahous + finw2 
gen totw3 = hahous + harles + hatran + habsns + hastck + hachck + hacd + habond + haothr
gen totw4 = hahous + harles + hatran + habsns + hastck + habond + haothr
gen totw5 = tothw + finw1
gen totw6 = tothw + finw2 
gen totw7 = tothw + harles + hatran + habsns + hastck + hachck + hacd + habond + haothr
gen totw8 = tothw + harles + hatran + habsns + hastck + habond + haothr

gen usvar1 = siearn
gen usvar2 = sissdi
gen usvar3 = siunwc
gen usvar4 = sigxfr
replace usvar1 = 0 if missing(siearn)
replace usvar2 = 0 if missing(sissdi)
replace usvar3 = 0 if missing(siunwc)
replace usvar4 = 0 if missing(sigxfr)
gen hinc1 = riearn + usvar1 + hxpen + hxann + hxss 
gen hinc2 = riearn + usvar1 + hxpen + hxann + hxss + rissdi + usvar2 + riunwc + usvar3 + rigxfr + usvar4
drop usvar*

////////////////////////////////////////////////////////////////////
// EXPRESSING INCOME AND WEALTH VARIABLES IN THOUSANDS OF DOLLARS //
////////////////////////////////////////////////////////////////////

local list_1 = "hitot hatotb hatota hatotw hatotf hatotn hatoth hahous hahoub hamort hanethb hastck hachck haira" 
foreach var in `list_1' {
replace `var' = `var'/1000
label var `var' "`var' in 1000 of $"
}
local list_2 = "hinc1 hinc2 debt1 debt2 debt3 finw1 finw2 finw3 finw4 saving tothw totw1 totw2 totw3 totw4 totw5 totw6 totw7 totw8"
foreach var in `list_2' {
replace `var' = `var'/1000
label var `var' "`var' in 1000 of $"
}


/////////////////////////////////////////////////////
// TRANSFORMATIONS FOR INCOME AND WEALTH VARIABLES //
/////////////////////////////////////////////////////

// Original Variables //

local list_1 = "hitot hatotb hatota hatotw hatotf hatotn hatoth hahous hahoub hamort hanethb hastck hachck haira"
foreach var in `list_1' {
* Log and Inverse Hyperbolic Sine *
gen l_`var' = ln(`var')
label var l_`var' "`var' in log" 
gen ihs_`var' = ln(`var'+(`var'^2+1)^(0.5))
label var ihs_`var' "`var' in ihs" 
* Differences *
gen d_`var' = F.`var'-`var'
label var d_`var' "change in `var'"
gen per_`var' = ((F.`var'-`var')/`var')*100
label var d_`var' "% change in `var'"
gen dl_`var' = F.l_`var'-l_`var'
label var dl_`var' "change in log `var'" 
gen dihs_`var' = F.ihs_`var'-ihs_`var'
label var dihs_`var' "change in ihs `var'" 
* Ratio *
gen r_`var' = F.`var'/`var'
label var r_`var' "ratio of `var' (t+1/t)" 
}
local list_2 = "hinc1 hinc2 debt1 debt2 debt3 finw1 finw2 finw3 finw4 saving tothw totw1 totw2 totw3 totw4 totw5 totw6 totw7 totw8"
foreach var in `list_2' {
* Log and Inverse Hyperbolic Sine *
gen l_`var' = ln(`var')
label var l_`var' "`var' in log" 
gen ihs_`var' = ln(`var'+(`var'^2+1)^(0.5))
label var ihs_`var' "`var' in ihs" 
* Differences *
gen d_`var' = F.`var'-`var'
label var d_`var' "change in `var'"
gen per_`var' = ((F.`var'-`var')/`var')*100
label var d_`var' "% change in `var'"
gen dl_`var' = F.l_`var'-l_`var'
label var dl_`var' "change in log `var'" 
gen dihs_`var' = F.ihs_`var'-ihs_`var'
label var dihs_`var' "change in ihs `var'" 
* Ratio *
gen r_`var' = F.`var'/`var'
label var r_`var' "ratio of `var' (t+1/t)" 
}

gen dum_debt1 = (d_debt1>0) if !missing(d_debt1)
gen dum_debt2 = (d_debt2>0) if !missing(d_debt2)
gen dum_debt3 = (d_debt3>0) if !missing(d_debt3)

////////////////////////////
// CONSUMPTION AGGREGATES //
////////////////////////////

gen wxutil    = wxelectric + wxwater + wxheat + wxtelecom
gen wxhoop    = wxhlthins + wxdrugs + wxhlthsvc + wxmedsup
gen wxleisure = wxtripvac + wxhob_min + wxsprteq + wxtickts
gen wxhhold   = wxhsekpsup + wxhsekpsvc + wxyrdsup + wxyrdsvc
gen wxhousing = wxmort + wxrent + wxhmrepsup + wxhmrepsvc + wxhmrntins
gen wxtrans   = wxxarpay + wxvhclins + wxvhclmnt
gen wxdongift = wxcashgift + wxconts

gen wxoutlay2 = wxoutlay - wxhousing
gen wxoutlay3 = wxoutlay - wxmort
 
///////////////////////////////////////////////
// TRANSFORMATIONS FOR CONSUMPTION VARIABLES //
///////////////////////////////////////////////

// Original Variables //

local list_c = "wxtc wxoutlay wxoutlay2 wxoutlay3 wxtotcons wxtcdurable wxtcndurable wxfdbev wxdinout wxcloth wxutil wxhoop wxleisure wxhhold wxhousing wxtrans wxdongift"

foreach var in `list_c' {
* Log and Inverse Hyperbolic Sine *
gen l_`var' = ln(`var')
label var l_`var' "`var' in log" 
gen ihs_`var' = ln(`var'+(`var'^2+1)^(0.5))
label var ihs_`var' "`var' in ihs" 
* Differences *
gen d_`var' = F.`var'-`var'
label var d_`var' "change in `var'"
gen per_`var' = ((F.`var'-`var')/`var')*100
label var d_`var' "% change in `var'" 
gen dl_`var' = F.l_`var'-l_`var'
label var dl_`var' "change in log `var'" 
gen dihs_`var' = F.ihs_`var'-ihs_`var'
label var dihs_`var' "change in ihs `var'" 
* Ratio *
gen r_`var' = F.`var'/`var'
label var r_`var' "ratio of `var' (t+1/t)" 
}

/////////////////////////
// TRIMMING INDICATORS //
/////////////////////////

local l_lim = 1
local u_lim = 100 - `l_lim'
local eps = 0.0001

// For changes in total spending //
gen trim_dlc = .
forval i = 2/5 {
centile dl_wxoutlay if camswave==`i', centile (`l_lim' `u_lim')
replace trim_dlc = 1 if dl_wxoutlay<r(c_1)-`eps' & camswave==`i' 
replace trim_dlc = 2 if dl_wxoutlay>r(c_2)+`eps' & dl_wxoutlay<. & camswave==`i'
}

// For changes in housing wealth //
gen trim_dlhw = .
forval i = 2/5 {
centile dl_hahous if camswave==`i', centile (`l_lim' `u_lim')
replace trim_dlhw = 1 if dl_hahous<r(c_1)-`eps' & camswave==`i' 
replace trim_dlhw = 2 if dl_hahous>r(c_2)+`eps' & dl_hahous<. & camswave==`i'
}

// For changes in financial wealth //
gen trim_dlfw = .
forval i = 2/5 {
centile dl_finw1 if camswave==`i', centile (`l_lim' `u_lim')
replace trim_dlfw = 1 if dl_finw1<r(c_1)-`eps' & camswave==`i' 
replace trim_dlfw = 2 if dl_finw1>r(c_2)+`eps' & dl_finw1<. & camswave==`i'
}

/////////////////////////////////////////
/// CENSUS DIVISION AND STATE DUMMIES ///
/////////////////////////////////////////

forval i = 1/9 {
gen div`i' = (rcendiv==`i') if !missing(rcendiv)
}
forval i = 1/51 {
gen s`i' = (state==`i') if !missing(state)
}

//////////////////
// INTERACTIONS //
//////////////////

local list_1 "dl_hahous dihs_hahous dl_tothw dihs_tothw dl_finw1 dihs_finw1 dl_finw2 dihs_finw2 dl_finw3 dihs_finw3 dl_finw4 dihs_finw4 dl_hastck dihs_hastck dl_saving dihs_saving"
foreach var in `list_1' {
gen `var'_crisis = `var'*d4_cams
}
local list_2 "dl_sp dl_djca dl_wind dl_master dl_intrate dl_hpi_bystate dl_ur_bystate dl_mort_bystate dl_hown_bystate dl_hvac_bystate d_cra_bystate dl_cra_bystate"
foreach var in `list_2' {
gen `var'_crisis = `var'*d4_cams
}

save "cams_reg.dta", replace
