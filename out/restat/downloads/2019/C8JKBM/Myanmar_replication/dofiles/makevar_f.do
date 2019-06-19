// create scores and variables 
set more off
use "$root/panel_basic.dta", clear 

// management practices score ************************************************************************************

// production monitoring and target -----------------------------------------------------------------------------
tab prodrecord_s1 year, m

/// production record 
local m prodrecord_s1

gen scr_prodrecord = .
replace scr_prodrecord = 1 if prodrecord_s1 == 5
replace scr_prodrecord = 2 if prodrecord_s1 == 4 
replace scr_prodrecord = 3 if prodrecord_s1 == 3 
replace scr_prodrecord = 4 if prodrecord_s1 == 2
replace scr_prodrecord = 5 if prodrecord_s1 == 1 

tab scr_prodrecord, m
sum scr_prodrecord
gen idx_prodrecord = (scr_prodrecord -r(mean))/r(sd)

bysort year: sum scr_prodrecord

gen rscr_prodrecord = (scr_prodrecord -1)/4

/// display 
local m disp
tab `m' year, m 

gen scr_disp = .
replace scr_disp = 1 if disp == 0 | disp==. 
replace scr_disp = 2 if disp == 4
replace scr_disp = 3 if disp == 3 
replace scr_disp = 4 if disp == 2 
replace scr_disp = 5 if disp == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

bysort year: sum scr_disp

gen rscr_`m' = (scr_`m' -1)/4

/// who see the record 
local m whosee_s1
tab `m' year, m 

local m whosee_s2
tab `m' year, m 

local m whosee_s3
tab `m' year, m 

local m whosee_s4
tab `m' year, m 

local m whosee_s5
tab `m' year, m 

*** manager -- point 2, other -- point 1 
local m whosee

gen scr_`m' = .
replace scr_`m' = 1 if `m'_s1 == 0 |  `m'_s1 == .    // no one 

** someone other than manager
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == .        // only supervisor 
replace scr_`m' = 2 if `m'_s1 == 3 & `m'_s2 == .        // only technician
replace scr_`m' = 2 if `m'_s1 == 4 & `m'_s2 == .        // only office staff  
replace scr_`m' = 2 if `m'_s1 == 5 & `m'_s2 == .        // only operator   
replace scr_`m' = 2 if `m'_s1 == 6 & `m'_s2 == .        // only trade partner  
replace scr_`m' = 2 if `m'_s1 == 8 & `m'_s2 == .        // only QC 

replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 3 & `m'_s3 == .   	  // supervisor + technician
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 4 & `m'_s3 == .   	  // supervisor + technician
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 5 & `m'_s3 == .      // supervisor + trade partner 
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 6 & `m'_s3 == .      // supervisor + trade partner 
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 7 & `m'_s3 == .      // supervisor + trade partner 
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 8 & `m'_s3 == .      // supervisor + trade partner 
replace scr_`m' = 2 if `m'_s1 == 3 & `m'_s2 == 7 & `m'_s3 == .      // supervisor + trade partner 
replace scr_`m' = 2 if `m'_s1 == 3 & `m'_s2 == 8 & `m'_s3 == .      // supervisor + trade partner 
replace scr_`m' = 2 if `m'_s1 == 4 & `m'_s2 == 8 & `m'_s3 == .   	  
replace scr_`m' = 2 if `m'_s1 == 2 & `m'_s2 == 6 & `m'_s3 == 8   	

**  only manager
replace scr_`m' = 3 if `m'_s1 == 7 & `m'_s2 == .        // only owner    - but supervisor should be collecting  
replace scr_`m' = 3 if `m'_s1 == 1 & `m'_s2 == .        // only manager  - but supervisor should be collecting  

** manager and someone (small group) 
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == .      // manager + supervisor
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 3 & `m'_s3 == .   	// manager + technician
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 4 & `m'_s3 == .   	// manager + technician
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 5 & `m'_s3 == .   	// manager + technician
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 7 & `m'_s3 == .      // manager + other 
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 8 & `m'_s3 == .      // manager + other 
replace scr_`m' = 4 if `m'_s1 == 1 & `m'_s2 == 7 & `m'_s3 == 8      // manager + other 

** manager and someone (large group) 
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 3 & `m'_s4 == .     // manager + supervisor + technician  
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 5 & `m'_s4 == .     // manager + supervisor + technician  
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 8 & `m'_s4 == .     // manager + supervisor + technician  
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 7 & `m'_s4 == .     // manager + supervisor + other 
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 4 & `m'_s4 == .     // manager + supervisor + technician  
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 3 & `m'_s4 == 6     // manager + supervisor + technician  
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 7 & `m'_s3 == 3   
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 8
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 3 & `m'_s4 == 4 
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 3 & `m'_s4 == 5
replace scr_`m' = 5 if `m'_s1 == 1 & `m'_s2 == 2 & `m'_s3 == 7 & `m'_s4 == 8 

local m whosee
list `m'_s1  `m'_s2  `m'_s3  `m'_s4 year if  scr_`m' ==. , nolabel 

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
bysort year: sum scr_whosee 

gen rscr_`m' = (scr_`m' -1)/4

/// meeting 
local m prodmtg
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 4
replace scr_`m' = 3 if `m' == 3
replace scr_`m' = 4 if `m' == 2
replace scr_`m' = 5 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

bysort year: sum scr_prodmtg

gen rscr_`m' = (scr_`m' -1)/4

// production monitoring index 
gen idx_prod = 0 
gen nobs_prod =0 
gen rscr_prod = 0
foreach k in prodrecord disp whosee prodmtg { 
replace idx_prod = idx_prod + idx_`k' if idx_`k'!=. 
replace nobs_prod = nobs_prod + 1 if idx_`k'!=. 
replace rscr_prod  = rscr_`k' + rscr_prod  if rscr_`k'!=. 
}
replace idx_prod = idx_prod/nobs_prod
label var idx_prod "Production monitoring and target: sum of z-scores of each question" 
replace rscr_prod = rscr_prod/4   // divided by max point
label var rscr_prod "Production monitoring and target: 0-1" 

bysort year: sum idx_prod

sum idx_prod
gen scr_prod = (idx_prod - r(mean))/r(sd)
label var scr_prod "Production monitoring and target: z-score"  


// quality control -----------------------------------------------------------------------------

// defectstypes
local m defectstypes  
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2
replace scr_`m' = 2 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

bysort year: sum scr_defectstypes

gen rscr_`m' = scr_`m' -1

// quality meeting 
local m qualmtg  
tab `m' year, m  

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 4 
replace scr_`m' = 3 if `m' == 3 
replace scr_`m' = 4 if `m' == 2
replace scr_`m' = 5 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = (scr_`m' -1)/4

// quality index 
gen idx_quality = 0 
gen nobs_quality =0 
gen rscr_quality = 0
foreach k in defectstypes qualmtg {                    
replace idx_quality = idx_quality + idx_`k' if idx_`k'!=. 
replace nobs_quality = nobs_quality + 1 if idx_`k'!=. 
replace rscr_quality = rscr_quality + rscr_`k' if rscr_`k'!=. 
}
replace idx_quality = idx_quality/nobs_quality
label var idx_quality "Quality control: sum of z-scores of each question" 

replace rscr_quality = rscr_quality/2 
label var idx_quality "Quality control: 0-1" 

// sum the scores before converting to index
sum idx_quality 
gen scr_quality = (idx_quality - r(mean))/r(sd)
label var scr_quality "Quality control: z-score"  

// machines -----------------------------------------------------------------------------

// machine downtime recorded
local m dtimerecord 
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2
replace scr_`m' = 2 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1


// machine downtime analysis
local m dtimeanalysis
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 5
replace scr_`m' = 3 if `m' == 4
replace scr_`m' = 4 if `m' == 3
replace scr_`m' = 5 if `m' == 2
replace scr_`m' = 6 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = (scr_`m' -1)/5

// machine maintenance index 
gen idx_machine = 0 
gen nobs_machine =0 
gen rscr_machine=0
foreach k in dtimerecord dtimeanalysis { 
replace idx_machine = idx_machine + idx_`k' if idx_`k'!=. 
replace nobs_machine = nobs_machine + 1 if idx_`k'!=. 
replace rscr_machine = rscr_machine + rscr_`k' if rscr_`k'!=. 
}

replace idx_machine = idx_machine/nobs_machine
label var idx_machine "Machine maintenance: sum of z-scores of each question" 

replace rscr_machine = rscr_machine/2 
label var rscr_machine "Machine maintenance: 0-1" 

sum idx_machine
gen scr_machine = (idx_machine - r(mean))/r(sd)
label var scr_machine "Machine maintenance: z-score"  


// human capital -----------------------------------------------------------------------------

/// reward for non-managerial staffs 
local m rewardmanag
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2 | `m'==. 
replace scr_`m' = 2 if `m' == 1  

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1

/// reward for non-managerial staffs 
local m rewardnon
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2 | `m'==. 
replace scr_`m' = 2 if `m' == 1  

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1

// human management index 
gen idx_human = 0 
gen nobs_human =0 
gen rscr_human = 0 
foreach k in rewardmanag rewardnon  {    
replace idx_human = idx_human + idx_`k'  if idx_`k'!=. 
replace nobs_human = nobs_human + 1 if idx_`k'!=. 
replace rscr_human = rscr_human + rscr_`k'  if rscr_`k'!=. 
}

replace idx_human = idx_human/nobs_human 
label var idx_human "Human capital: sum of z-scores of each question" 

replace rscr_human = rscr_human/2
label var rscr_human "Human capital: 0-2" 

sum idx_human
gen scr_human = (idx_human - r(mean))/r(sd)
label var scr_human "Human capital: z-score" 


// overall management score -----------------------------------------------------------------------------
*** index_z = average of categories, not standardized among z, but standardized in finer categories 
*** score_z = standardized average of categories, standardized among z 
gen idx_manag = 0
gen idx_manag_woit = 0
gen idx_manag_woitic = 0
gen nobs_manag = 0 
gen nobs_manag_woit = 0 
gen nobs_manag_woitic = 0 
gen rscr_manag_woit = 0
gen rscr_manag_woitic = 0


// score (not including IT usage)
foreach sec in prod quality machine human {
replace idx_manag_woit = idx_manag_woit + scr_`sec' if idx_`sec'!=. 
replace nobs_manag_woit = nobs_manag_woit + 1 if idx_`sec'!=.
replace rscr_manag_woit = rscr_manag_woit + rscr_`sec' if rscr_`sec'!=. 
}

// score (not including incentive and IT usage)  
foreach sec in prod quality machine {
replace idx_manag_woitic = idx_manag_woitic + scr_`sec' if idx_`sec'!=. 
replace nobs_manag_woitic = nobs_manag_woitic + 1 if idx_`sec'!=.
replace rscr_manag_woitic = rscr_manag_woitic + rscr_`sec' if rscr_`sec'!=. 
}

replace idx_manag = idx_manag/nobs_manag   // average over nonmissing index
replace idx_manag_woit = idx_manag_woit/nobs_manag_woit   // average over nonmissing index
replace idx_manag_woitic = idx_manag_woitic/nobs_manag_woitic  // average over nonmissing index

sum idx_manag_woit
gen scr_manag_woit = (idx_manag_woit - r(mean))/r(sd) 
replace scr_manag_woit = . if nobs_manag_woit<=2    // at least 2 categories are non-missing 

replace rscr_manag_woit = rscr_manag_woit/ nobs_manag_woit
replace rscr_manag_woit = . if nobs_manag_woit<=2    // at least 2 categories are non-missing 

replace rscr_manag_woitic = rscr_manag_woitic/ nobs_manag_woitic
replace rscr_manag_woitic = . if nobs_manag_woitic<=2    // at least 2 categories are non-missing 

sum idx_manag_woitic
gen scr_manag_woitic = (idx_manag_woitic - r(mean))/r(sd) 
replace scr_manag_woitic = . if nobs_manag_woitic<=2    // at least 2 categories are non-missing 

label var scr_manag_woit "Management z Score: excl IT" 
label var scr_manag_woitic "Management z Score: excl IT, incentive" 

*hist idx_manag, bin(12) 


// working conditions *****************************************************************

// working hours -------------------------------------------------------------------
gen hwork_weektt = (hwork + overtime)*days
label var hwork_weektt "Total hours of work per week" 

gen longhw = (hwork_weektt - 60)*(hwork_weektt - 60>0)
label var longhw "Hours of work over 60 hrs/wk" 

// fire safety ---------------------------------------------------------------------

/// number of fire safety equipment 
gen scr_fsafety_equip = fexit +  fextg + fhose + falarm + fmap
local m fsafety_equip
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

bysort year: sum idx_`m' 

gen rscr_fsafety_equip = (scr_fsafety_equip -1)/4

// fire drill 
gen scr_drill = fdrill 
local m drill 
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' 

gen idx_fsafety = (idx_fsafety_equip + idx_drill)/2 
local m fsafety
sum idx_`m'
gen scr_`m' = (idx_`m' -r(mean))/r(sd)

gen rscr_fsafety = (rscr_fsafety_equip + rscr_drill)/2

label var scr_fsafety "fire safety at plant" 

bysort year: sum scr_fsafety if panel==1 
bysort year: sum fexit if panel==1 



// health --------------------------------------------------------------------- 

//  nurse/doctor  
local m nurseplant
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0 
replace scr_`m' = 2 if `m' == 1  

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
gen rscr_`m' = scr_`m' -1

// hospital contract and list 
local m hosp_conlist
gen scr_`m' = . 
replace scr_`m' = 0 if hosplist==0 & hospcontract==0 
replace scr_`m' = 1 if hosplist==1 & hospcontract==0 
replace scr_`m' = 2 if hosplist==0 & hospcontract==1
replace scr_`m' = 3 if hosplist==1 & hospcontract==1

sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
gen rscr_`m' = scr_`m'/3

// injury record  
local m injuryrec 
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 1  

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1 

// health score 
gen idx_health = (idx_nurseplant + idx_hosp_conlist + idx_injuryrec)/3
sum idx_health
gen scr_health = (idx_health -r(mean))/r(sd)

gen nobs_health = 0 
gen rscr_health = 0 
foreach sec in nurseplant injuryrec hosp_conlist { 
replace rscr_health = rscr_health + rscr_`sec' if rscr_`sec'!=.
replace nobs_health = nobs_health + 1 if rscr_`sec'!=.
}

replace rscr_health=  rscr_health/nobs_health

bysort year: sum scr_health 
bysort year: sum scr_health if panel==1 

label var scr_health "health service at plant" 


// union and communication with workers  --------------------------------------------------------------------- 
tab mtgwleader year, m  
tab appointment, m 

gen scr_wleader = . 

// meeting regularly with a workers' leader appointed by workers 
replace scr_wleader = 5 if appointment==2 & year ==2015 & (mtgwleader=="1" | mtgwleader=="1,2" | mtgwleader=="1,4" | mtgwleader=="2" | mtgwleader=="3" | mtgwleader=="3,4") 
replace scr_wleader = 4 if appointment==2 & year ==2015 & (mtgwleader=="4" | mtgwleader=="5") 
replace scr_wleader = 3 if appointment==1 & year ==2015 & (mtgwleader=="1" | mtgwleader=="1,2" | mtgwleader=="1,4" | mtgwleader=="2" | mtgwleader=="3" | mtgwleader=="3,4") 
replace scr_wleader = 2 if appointment==1 & year ==2015 & (mtgwleader=="4" | mtgwleader=="5") 

replace scr_wleader = 5 if appointment==2 & year ==2014 & (mtgwleader=="1" | mtgwleader=="1,2" | mtgwleader=="1,4" | mtgwleader=="2" | mtgwleader=="3" | mtgwleader=="3,4") 
replace scr_wleader = 4 if appointment==2 & year ==2014 & (mtgwleader=="4" | mtgwleader=="5") 
replace scr_wleader = 3 if appointment==1 & year ==2014 & (mtgwleader=="1" | mtgwleader=="1,2" | mtgwleader=="1,4" | mtgwleader=="2" | mtgwleader=="3" | mtgwleader=="3,4") 
replace scr_wleader = 2 if appointment==1 & year ==2014 & (mtgwleader=="4" | mtgwleader=="5") 

replace scr_wleader = 1 if (year ==2014 | year== 2015) & (mtgwleader=="0" | appointment==. | appointment==0)

replace scr_wleader = 3 if year == 2013 & (mtgwleader=="1" | mtgwleader=="1,2" | mtgwleader=="1,4" | mtgwleader=="2" | mtgwleader=="3" | mtgwleader=="3,4") 
replace scr_wleader = 2 if year == 2013 & (mtgwleader=="4" | mtgwleader=="5") 
replace scr_wleader = 1 if year == 2013 & (mtgwleader=="0" | mtgwleader==".") 

local m wleader 
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
gen rscr_`m' = (scr_`m' -1)/4

gen no_wleader = (mtgwleader=="0" | appointment==. | appointment==0)
gen appoint_w = (appointment==1 & no_wleader==0)

// suggestion box 
tab suggestionbox 
replace suggestionbox = 2 if suggestionbox==. 
replace suggestionbox = 2 if suggestionbox==-8 
replace suggestionbox = 0 if suggestionbox ==2 
local m sugbox
gen scr_`m' = (suggestionbox == 1) 
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m'

// union score 
gen idx_union = (idx_wleader + idx_sugbox)/2
sum idx_union
gen scr_union = (idx_union -r(mean))/r(sd)

gen rscr_union = (rscr_wleader + rscr_sugbox)/2

// workplace overal --------------------------------------------------------------------- 
gen idx_wkp = 0
gen nobs_wkp = 0
gen idx_sftu = 0
gen nobs_sftu= 0
gen nobs_sftu_alt = 0
gen rscr_sftu= 0
gen rscr_sftu_alt= 0

// overall working conditions score 
foreach sec in fsafety health union {
replace idx_sftu = idx_sftu + scr_`sec' if idx_`sec'!=. 
replace nobs_sftu = nobs_sftu + 1 if rscr_`sec'!=.
replace rscr_sftu = rscr_sftu + rscr_`sec' if rscr_`sec'!=.
}

replace idx_wkp = idx_wkp/nobs_wkp   // average over nonmissing index
sum idx_wkp  
gen scr_wkp = (idx_wkp - r(mean))/r(sd) 
replace scr_wkp = . if nobs_wkp <=2    // at least 2 categories are non-missing 

replace idx_sftu = idx_sftu/nobs_sftu   // average over nonmissing index
sum idx_sftu  
gen scr_sftu = (idx_sftu - r(mean))/r(sd) 
replace scr_sftu = . if nobs_sftu <=1    // at least 2 categories are non-missing 

replace rscr_sftu = rscr_sftu/nobs_sftu   // average over nonmissing index
replace scr_sftu = . if nobs_sftu <=1    // at least 2 categories are non-missing 

label var scr_wkp "working conditions core: z-score" 
label var rscr_sftu "working conditions score"

drop idx_* nobs_*

// social audit 
tab socialaudit year, m  
replace socialaudit = (socialaudit==1) if year == 2014 | year == 2015

// District *********************************************************************************
gen mandalay = (district==2) 
tab mandalay year
label var mandalay "Mandalay dummy" 

// ownership *****************************************************************
gen fdi = (fshare>50) if fshare!=.  
capture drop fdi14
capture drop fdi15
gen fdi13 = fdi if year==2013 
bysort id13: egen fdi13_i = max(fdi13) 
gen fdi14 = fdi if year==2014
bysort id14: egen fdi14_i = max(fdi14) 
gen fdi15 = fdi if year==2015 
bysort id15: egen fdi15_i = max(fdi15) 
gen fdi_any = 0
replace fdi_any = 1 if fdi13_i ==1 
replace fdi_any = 1 if fdi14_i ==1 
replace fdi_any = 1 if fdi15_i ==1 

label var fdi_any "FDI at least in one year during 2013-2015"

gen oeducu = (oeduc>=3) if oeduc!=. 

// production data *****************************************************************

// labor productivity (sales)  - adjusted to value added 
gen vadd = sales12d if sales12d>0 & year == 2013
local fsh 0.6552113    // estimated using custom's data 

replace vadd = sales12d*(1-`fsh') if sales12d>0 & cmp==2 & year == 2013
replace vadd = sales12d*(1-`fsh') if longyi==1 & year == 2013
gen log_vadd = log(vadd) 
label var vadd "value added ($) 2012"
label var log_vadd "log value added ($) 2012"

gen log_emp = log(emp)  
gen log_nsewm = log(nsewm)

gen lp12 = sales12d/emp if sales12d>0 & year == 2013
replace lp12 = sales12d*(1-`fsh')/emp if sales12d>0 & cmp==2 & year == 2013
gen log_lp = log(lp12) if year == 2013 
gen lp = lp12 if year == 2013 
gen log_sales = log_vadd if year == 2013

gen lhwork_weektt = log(hwork_weektt) 
gen hwork_monthtt = hwork_weektt*(31/7)
gen wage = salaryd/hwork_monthtt
gen lwage = log(wage)

label var nsewm "num. sewing machine" 
label var log_nsewm "log num. sewing machine" 
label var log_sales "log sales ($)"
label var log_lp "log labor prod ($)"
label var lp "labor prod ($)"

capture drop ap_unknown
gen ap_unknown = 1 
replace ap_unknown = 0 if add04==1 |  ((plantage>=7 & year==2013) | (plantage>=8 & year==2014) | (plantage>=9 & year==2015))
replace ap_unknown = 0 if (id13 == 16 | id13 == 18 | id13 == 29 | id13 == 122 | id13 == 134 | id13 == 152 | id13 == 161 /// 
| id13 == 163 | id14 == 95 | id14 == 212)

gen obs_enterbf05 = 0
replace obs_enterbf05 = 1 if (((firmage>=7 & year==2013) | (firmage>=8 & year==2014) | (firmage>=9 & year==2015)) | obs2006==1 | obs2003==1 | dgarment05_i==1)  ///
		 & year!=. & dnonknitbf05 !=. ///
		 & log_emp!=. & rscr_manag_woitic!=. & rscr_sftu!=. & fdi_any ==0

gen obs_airport = 0
replace obs_airport = 1 if (((firmage>=7 & year==2013) | (firmage>=8 & year==2014) | (firmage>=9 & year==2015)) | obs2006==1 | obs2003==1 | dgarment05_i==1)  ///
		 & year!=.  & ap_timeo!=. & ap_unknown==0 ///
		 & log_emp!=. & scr_manag_woit!=. & rscr_sftu!=. &  fdi_any ==0

gen plantage_i = plantage	 
replace plantage_i = 10 if plantage==. 
replace plantage_i = 10 if obs_airport == 1 & ap_timeo!=. // keep in the data if old plant address is measured
gen obs_airport_fd = 0 
replace obs_airport_fd = 1 if ((firmage>=3 & year==2013 & plantage_i>=3) | (firmage>=4 & year==2014 & plantage_i>=4) | (firmage>=5 & year==2015  & plantage_i>=5))  ///    
		 & year!=. ///
		 & log_emp!=. & scr_manag_woit!=. & rscr_sftu!=. & fdi_any == 0  

// standardization  
foreach var in scr_manag_woit scr_manag_woitic scr_prod scr_quality scr_machine scr_human ///
     scr_sftu scr_fsafety scr_health scr_union {
sum `var' if obs_enterbf05 ==1 
replace `var' = (`var'-r(mean))/r(sd) 
} 

// airport time = distance from old airport location, if old plant address is measured
replace ap_time = ap_timeo if ap_timeo!=. & ((plantage_i<3 & year==2013) | (plantage_i<4 & year==2014) | (plantage_i<5 & year==2015))
gen ap_in1hr = (ap_timeo<1) 

gen y14 = (year==2014) 
gen y15 = (year==2015) 

// label 
label var export "Export"
label var export_JP "Exporting to Japan" 
label var export_EUUS "Exporting to EU/US"
label var emp "Employment" 
label var log_emp "Ln Employment" 
label var nsewm "Number of sewing machines" 
label var nfor "Number of foreign staff" 
label var salaryd "Monthly salary (USD, including overtime)" 
label var dnonknitbf05 "Woven (2005)" 
label var ap_timeo "Time to airport (2005)"
label var city_timeo "Travel time to city center (2005)" 
label var izo "Plant in an industrial zone (2005)" 
label var ap_time "Time to airport (2005-2011)"
label var oeducu "Owner college graduate" 
label var ochinese "Owner ethnic Chinese"
label var firmage "Firm age" 
label var socialaudit "Firm's years of operation (firm age)" 
label var vadd "Value added (USD)" 
label var bsend_suggest "Buyer staff visit plant & suggest how to improve" 
label var socialaudit "Ever received labor/environmental compliance audit" 
label var wage "Hourly wage (USD)"
label var hwork_weektt "Hours of work per week (incl. overtime) "
label var rscr_sftu "Working conditions score" 
label var rscr_fsafety "Fire safety score" 
label var fexit "Fire exit"
label var fextg "Fire extinguisher" 
label var fhose "Fire hose"
label var falarm "Fire alarm"
label var fmap "Evacuation route map"
label var fdrill "Practice fire drill" 
label var rscr_health "Health score" 
label var rscr_union "Negotiation score"
label var rscr_manag_woitic "Management average score"
label var rscr_prod "Management: production monitoring score"
label var rscr_quality "Management: quality control score"
label var rscr_machine "Management: machine maintenance score"
label var nurseplant "Nurse at plant" 
label var hosplist "List of hospitals for emergency" 
label var injuryrec "Record injury" 
label var no_wleader "No workers' leader"
label var appoint_w "There is a workers' leader appointed by workers" 
label var suggestionbox "Suggestion box" 
label var export_sh "Export share"
label var lhwork_weektt "Log Hours"
label var lwage "Ln Wage" 
label var ap_in1hr "Near airport" 


// Count the number of unique plants in Table 1
preserve 
collapse (mean) rscr_sftu if obs_airport ==1 , by(idall) 
sum rscr_sftu 
restore 

save "$root/myanmarpanel_analysis", replace 
