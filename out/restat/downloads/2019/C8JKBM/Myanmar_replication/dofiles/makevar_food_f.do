// create scores and variables for food data 
set more off

use "$root/panel_basic_food.dta", clear 

// management practices score ************************************************************************************

// production monitoring and target -----------------------------------------------------------------------------

/// who see the record 
tab whosee_s1 year
tab whosee_s2 year

*** manager -- point 2, other -- point 1 
local m whosee 

gen scr_`m' = .
replace scr_`m' = 1 if `m'_s1 == 0 | `m'_s1 == .    // no one 

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
tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
bysort year: sum scr_whosee 

gen rscr_`m' = (scr_`m' -1)/4

/// meeting 
tab prodmtg year, m 
local m prodmtg
gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 4 | `m' == 3
replace scr_`m' = 3 if `m' == 2
replace scr_`m' = 4 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

bysort year: sum scr_prodmtg

gen rscr_`m' = (scr_`m' -1)/3

// production monitoring index 
gen idx_prod = 0 
gen nobs_prod =0 
gen rscr_prod = 0
foreach k in whosee prodmtg { 
replace idx_prod = idx_prod + idx_`k' if idx_`k'!=. 
replace nobs_prod = nobs_prod + 1 if idx_`k'!=. 
replace rscr_prod  = rscr_`k' + rscr_prod  if rscr_`k'!=. 
}
replace idx_prod = idx_prod/nobs_prod
label var idx_prod "Production monitoring and target: sum of z-scores of each question" 

replace rscr_prod = rscr_prod/3   // divided by max point
label var rscr_prod "Production monitoring and target: 0-1" 
bysort year: sum idx_prod

sum idx_prod
gen scr_prod = (idx_prod - r(mean))/r(sd)
label var scr_prod "Production monitoring and target: z-score"  


foreach x in scr_prod rscr_prod {
replace `x' = . if year == 2014 
} 


// quality control -----------------------------------------------------------------------------

// quality meeting 

tab qualmtg year, m 
local m qualmtg  

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 4
replace scr_`m' = 3 if `m' == 3 
replace scr_`m' = 4 if `m' == 2
replace scr_`m' = 5 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

sum scr_`m'
 
gen rscr_`m' = (scr_`m' -1)/4
 
 // defectstypes - record defect  
gen scr_defectrecord= .
replace scr_defectrecord = 1 if defectrecord == 2 
replace scr_defectrecord = 2 if defectrecord == 1

local m defectrecord
tab scr_`m' year , m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

sum scr_`m'

gen rscr_`m' = scr_`m' -1

// quality index 
gen idx_quality = 0 
gen nobs_quality =0 
gen rscr_quality = 0
foreach k in defectrecord qualmtg {                    
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

foreach x in scr_quality rscr_quality {
replace `x' = . if year == 2014 
} 


// machines -----------------------------------------------------------------------------

// machine downtime recorded
tab dtimerecord year , m 
local m dtimerecord 
gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2
replace scr_`m' = 2 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
sum scr_`m'

gen rscr_`m' = scr_`m' -1

// machine downtime analysis
local m dtimeanalysis 
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0
replace scr_`m' = 2 if `m' == 4
replace scr_`m' = 3 if `m' == 3
replace scr_`m' = 4 if `m' == 5
replace scr_`m' = 5 if `m' == 2
replace scr_`m' = 6 if `m' == 1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)
sum scr_`m'

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

foreach x in scr_machine rscr_machine {
replace `x' = . if year == 2014 
} 


// human capital -----------------------------------------------------------------------------

/// reward for non-managerial staffs  
local m rewardmanag
tab `m' year, m 

gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2 | `m'==. 
replace scr_`m' = 2 if `m' == 1  
replace scr_`m' = . if year == 2014 

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
replace scr_`m' = . if year == 2014 

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1

// human management index 
gen idx_human = 0 
gen nobs_human =0 
gen rscr_human =0 
foreach k in rewardmanag rewardnon  {    
replace idx_human = idx_human + idx_`k'  if idx_`k'!=. 
replace nobs_human = nobs_human + 1 if idx_`k'!=. 
replace rscr_human = rscr_human + rscr_`k' if rscr_`k'!=. 
}

replace idx_human = idx_human/nobs_human 
label var idx_human "Human capital: sum of z-scores of each question" 

replace rscr_human = rscr_human/2
label var rscr_human "Human capital: 0-2" 

sum idx_human
gen scr_human = (idx_human - r(mean))/r(sd)
label var scr_human "Human capital: z-score" 

// overall management score -----------------------------------------------------------------------------

gen idx_manag = 0
gen idx_manag_woit = 0
gen idx_manag_woitic = 0
gen nobs_manag = 0 
gen nobs_manag_woit = 0 
gen nobs_manag_woitic = 0 
gen rscr_manag_woit = 0
gen rscr_manag_woitic = 0


// score not including IT usage 
foreach sec in prod quality machine human {
replace idx_manag_woit = idx_manag_woit + scr_`sec' if idx_`sec'!=. 
replace nobs_manag_woit = nobs_manag_woit + 1 if idx_`sec'!=.
replace rscr_manag_woit = rscr_manag_woit + rscr_`sec' if rscr_`sec'!=. 
}

// score not including incentive and IT usage  
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

sum idx_manag_woitic
gen scr_manag_woitic = (idx_manag_woitic - r(mean))/r(sd) 
replace scr_manag_woitic = . if nobs_manag_woitic<=2    // at least 2 categories are non-missing 

replace rscr_manag_woit = rscr_manag_woit/ nobs_manag_woit
replace rscr_manag_woit = . if nobs_manag_woit<=2    // at least 2 categories are non-missing 

replace rscr_manag_woitic = rscr_manag_woitic/ nobs_manag_woitic
replace rscr_manag_woitic = . if nobs_manag_woitic<=2    // at least 2 categories are non-missing 

label var scr_manag_woit "Management z Score: excl IT" 
label var scr_manag_woitic "Management z Score: excl IT, incentive" 


foreach x in scr_manag_woit scr_manag_woitic rscr_manag_woit rscr_manag_woitic {
replace `x' = . if year == 2014 
} 


// working conditions *****************************************************************

// working hours -------------------------------------------------------------------
gen hwork_weektt = (hwork + overtime)*days
label var hwork_weektt "Total hours of work per week" 

gen longhw = (hwork_weektt - 60)*(hwork_weektt - 60>0)
label var longhw "Hours of work over 60 hrs/wk" 

gen wage = salaryd/(hwork_weektt*30/7)
gen lwage = log(wage) 

// Fire safety ************************************************************************************
/// number of fire safety equipment 
gen scr_fsafety_equip = fexit +  fextg + fhose + falarm + fmap
local m fsafety_equip
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

bysort year: sum idx_`m' 

gen rscr_fsafety_equip = scr_fsafety_equip/5

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

// Health ************************************************************************************
//  nurse/doctor  
local m nurseplant
gen scr_`m' = .
replace scr_`m' = 1 if `m' == 0 
replace scr_`m' = 2 if `m' == 1  

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1

/// injury record  
local m injuryrec 
gen scr_`m' = .
replace scr_`m' = 1 if `m' == 2 
replace scr_`m' = 2 if `m' == 1  

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m' -1

// hospital contract-hospital list 
local m hosp_conlist
gen scr_`m' = . 
replace scr_`m' = 0 if hosplist==0 & hospcontract==0 
replace scr_`m' = 1 if hosplist==1 & hospcontract==0 
replace scr_`m' = 2 if hosplist==0 & hospcontract==1
replace scr_`m' = 3 if hosplist==1 & hospcontract==1

tab scr_`m', m
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_`m' = scr_`m'/3


// health score 

gen idx_health = (idx_nurseplant + idx_hosp_conlist + idx_injuryrec)/3
sum idx_health
gen scr_health = (idx_health -r(mean))/r(sd)

gen rscr_health = (rscr_nurseplant + rscr_hosp_conlist + rscr_injuryrec)/3

bysort year: sum scr_health 
label var scr_health "health service at plant" 

// Union and communication with workers ***************************************************************************
tab mtgwleader year, m  // asked only in 2013 

// meeting regularly with a workers' leader appointed by workers 
gen scr_wleader = . 
replace scr_wleader = 3 if mtgwleader==1 | mtgwleader==2 // weekly or monthly 
replace scr_wleader = 2 if mtgwleader==3 // yearly 
replace scr_wleader = 1 if mtgwleader==0 // no meeting 

gen no_wleader = (mtgwleader==0)
gen appoint_w = 0 

local m wleader 
sum scr_`m'
gen idx_`m' = (scr_`m' -r(mean))/r(sd)

gen rscr_wleader = (scr_`m'-1)/2 

tab suggestionbox, m  
replace suggestionbox=0 if suggestionbox==2 | suggestionbox==0 
gen  suggestionbox15 =  suggestionbox if year == 2015 
bysort id15: egen  suggestionbox15_i  = mean(suggestionbox) 
replace suggestionbox = suggestionbox15_i if year == 2014
replace suggestionbox = 1 if suggestionbox>0 & suggestionbox<1 
gen rscr_suggestionbox = suggestionbox

gen rscr_union = (rscr_wleader + rscr_suggestionbox )/ 2 


// workplace overal  *************************************************************************
gen idx_wkp = 0
gen nobs_wkp = 0
gen idx_sftu = 0
gen nobs_sftu= 0


foreach sec in fsafety health {
replace idx_sftu = idx_sftu + scr_`sec' if idx_`sec'!=. 
replace nobs_sftu = nobs_sftu + 1 if idx_`sec'!=.
}

replace idx_sftu = idx_sftu/nobs_sftu   // average over nonmissing index
sum idx_sftu  
gen scr_sftu = (idx_sftu - r(mean))/r(sd) 
replace scr_sftu = . if nobs_sftu <=1    // at least 2 categories are non-missing 

gen rscr_sftu = (rscr_fsafety + rscr_health + rscr_union)/3 if rscr_fsafety!=. & rscr_health!=. & rscr_union!=. 
replace rscr_sftu = (rscr_fsafety + rscr_health)/3 if rscr_fsafety!=. & rscr_health!=. & rscr_union==. 

label var scr_sftu "workplace condition: excluding hours and payment" 

// production data *****************************************************************
// product category defined by the major product 

gen labor = hwork_weektt * emp 
gen log_labor = log(labor) 

// labor productivity (sales)  - adjusted to value added
gen log_emp = log(emp)
gen log_sales = log(sales)  
gen lp = log_sales - log_emp 
label var lp "log labor productivity"
label var log_emp "log employment"
label var log_sales "log sales ($)"
label var lp "log labor prod ($)"

// ID 
gen panel = 1 if id13!=. & id14!=. & id15!=.
replace panel = 2 if id13==. & id14!=. & id15!=.
replace panel = 3 if id13!=. & id14==. & id15!=.
replace panel = 4 if id13!=. & id14!=. & id15==.
replace panel = 5 if id13==. & id14==. & id15!=.
replace panel = 6 if id13==. & id14!=. & id15==.
replace panel = 7 if id13==. & id14==. & id15!=.

tab panel 
gen idall = id14 + 10000 if panel ==1 | panel ==2 
replace idall = id15+18000 if panel ==4
replace idall = id15+22000 if panel ==7

gen industry=2 

gen ap_timeo = ap_time 
gen izo = iz 
gen city_timeo = city_time

label var ap_time "Airport Time" 
label var ap_timeo "Airport Time" 
label var iz "Industrial Zone" 
label var izo "Industrial Zone" 
label var city_time "City Time" 
label var city_timeo "City Time" 

gen mandalay_i = (district==2) 
gen ap_in1hr = (ap_timeo<1) if ap_timeo!=. 

replace injuryrec = (injuryrec==1) if injuryrec!=. 

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
bysort idall: egen fdi_any_i = max(fdi_any) 

gen fdi_fsty = fdi13_i if id13!=. 
replace fdi_fsty = fdi14_i if id13==. & id14!=.
replace fdi_fsty = fdi15_i if id13==. & id14==. & id15!=. 
label var fdi_fsty "FDI in the first year in the data" 

label var export_sh "Export share"
label var export "Exporting" 
label var export_JP "Exporting to Japan" 
label var export_JP_sh "Export to Japan (share of sales)" 
label var emp "Employment" 
label var sales "Sales (USD)"
label var longhw "Hours $\ge60$/week" 
label var ap_in1hr "Near airport (within 1 hour) (2005)" 
label var rscr_sftu "Working conditions score" 
label var fexit "Fire exit" 
label var fextg "Fire extinguisher" 
label var fhose "Fire hose"
label var falarm "Fire alarm"
label var fmap "Evacuation route map" 
label var fdril "Practice fire drill"
label var nurseplant "Nurse at plant" 
label var injuryrec "Record injury" 
label var hosplist "List of hospitals for emergency" 
label var hospcontract "Private contract with clinic" 
label var no_wleader "No workers' leader" 
label var wage "Hourly wage (USD)"
label var longhw "Hours over 60 per week" 
label var rscr_manag_woitic "Management average score"
label var rscr_prod "Management: production monitoring score"
label var rscr_quality "Management: quality control score" 
label var rscr_machine "Management: machine maintenance score" 
label var mandalay_i "Plant in Mandalay region" 
label var firmage "Firm's years of operation" 
label var ap_timeo "Time to airport (hours)" 
label var ap_in1hr "Near airport (within 1 hour)"
label var city_timeo "Travel time to city center"
label var izo "Plant in an industrial zone"  
label var bev "Beverage" 
label var fdi_any_i "FDI at any point in 2013-2015" 

save "$root/myanmar_food_analysis.dta", replace
