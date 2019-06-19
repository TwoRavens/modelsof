/*use of the consolidated database with panel dummy*/
use  "$data\final_data.dta", clear 


/* Variables */

local variables1 = "sales employ fixas numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5 exp_prc_sales" 
local variables2 = "constrqA constrqB constrqD constrqE constrqF constrqG constrqH constrqJ constrqK constrqL constrqM constrqN constrqO constrqP constrqC constrqALL15" 
local variables3 = "labunsec age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR perfqH  perfqI  perfqJ_winsor  perfqG  perfqW_winsor" 
local variables4 = "BI_constrqA BI_constrqB BI_constrqD BI_constrqE BI_constrqF BI_constrqG BI_constrqH BI_constrqJ BI_constrqK BI_constrqL BI_constrqM BI_constrqN BI_constrqO BI_constrqP BI_constrqC BI_constrqALL15" 


*************************** PANEL 1 ********************************

** Columns 1-3
preserve
collapse (count) `variables1' `variables3' if year!=1999, by(year) fast
gen stat = "Obs."
tempfile column1
save `column1', replace
restore

preserve
collapse (mean) `variables1' `variables3' if year!=1999, by(year) fast
gen stat = "Mean"
tempfile column2
save `column2', replace
restore

preserve
collapse (sd)   `variables1' `variables3' if year!=1999, by(year) fast
gen stat = "Std. Dev."
tempfile column3
save `column3', replace
restore

preserve
use `column1', clear
append using `column2'
append using `column3'
gen sample = "All"
order sample stat
tempfile file1
save `file1', replace
restore

** Columns 4-12

preserve
collapse (count) `variables1' `variables3' if year!=1999, by(regmac) fast
gen stat = "Obs."
tempfile column1
save `column1', replace
restore

preserve
collapse (mean) `variables1' `variables3' if year!=1999, by(regmac)  fast
gen stat = "Mean"
tempfile column2
save `column2', replace
restore

preserve
collapse (sd)   `variables1' `variables3' if year!=1999, by(regmac) fast
gen stat = "Std. Dev."
tempfile column3
save `column3', replace
restore

use `column1', clear
append using `column2'
append using `column3'
gen sample = string(regmac)
drop regmac
order sample stat
append using `file1'


replace sample = "Full Sample" if sample=="All"
replace sample = "CEB" if sample=="1"
replace sample = "SEE" if sample=="2"
replace sample = "CIS" if sample=="3"


drop if sample=="CEB" | sample=="CIS" | sample=="SEE"



gen id = 1 if stat=="Obs."
replace id = 2 if stat=="Mean"
replace id = 3 if stat=="Std. Dev."
drop sample stat
order id year


xpose, clear


foreach var of varlist v1-v6{
 gen aux = string(`var')
 drop `var'
 ren aux `var'
 }

gen variable = ""
replace variable = "Variable"                                            in 1
replace variable = "Year"                                                in 2
replace variable = "Sales                                            "   in 3
replace variable = "Employment                                       "   in 4
replace variable = "Fixed Assets                                     "   in 5
replace variable = "Number of Competitors                            "   in 6
replace variable = "Ownership [Privatization]                        "   in 7
replace variable = "Ownership [New Private]                          "   in 8
replace variable = "Ownerschip [State]                               "   in 9
replace variable = "Ownership [Other]                                "   in 10
replace variable = "Ownership [Foreign]                              "   in 11
replace variable = "Exports as % of Sales                            "   in 12
replace variable = "Workforce Ratio: University / Secondary Education"   in 13
replace variable = "Company Age                                      "   in 14
replace variable = "University / Secondary Education x Age           "   in 15
replace variable = "Permanent Employment 3 years ago                 "   in 16
replace variable = "Parttime Employment 3 Years ago                  "   in 17
replace variable = "% change in Fixed Assets (3 year period)           "   in 18
replace variable = "% change in Exports (3 year period)                "   in 19
replace variable = "% change in Employment (3 year period)             "   in 20 
replace variable = "% change in Sales (3 year period)                  "   in 21
replace variable = "% change in Sales per Worker (3 year period)       "   in 22

ren v1 obs_1
ren v2 obs_2
ren v3 mean_1
ren v4 mean_2
ren v5 sd_1
ren v6 sd_2


order variable
compress

count
local n = r(N)+3
set obs `n'

save "$tables/table1_part1.dta", replace


*************************** PANEL 2 ********************************

/*use of the consolidated database with panel dummy*/
use  "$data\final_data.dta", clear 


table branch year, c(N comps mean comps sd comps) replace

ren table1 obs
ren table2 mean
ren table3 sd

reshape wide  obs mean sd, i(branch) j(year)
ren  obs2002  obs_1
ren  mean2002  mean_1
ren  sd2002  sd_1
ren  obs2005  obs_2
ren  mean2005  mean_2
ren  sd2005 sd_2
ren  branch variable

local stringize = "obs_1 obs_2 mean_1 mean_2 sd_1 sd_2"
foreach s of local stringize{
  gen aux = string(`s')
  drop `s'
  ren aux `s'
  }
  

decode  variable, gen(aux)
drop variable
gen variable = proper(aux)
drop aux
order variable

count
local n = r(N)+3
set obs `n'


save "$tables/table1_part2.dta", replace


*************************** PANEL 3 ********************************

/*use of the consolidated database with panel dummy*/
use  "$data\final_data.dta", clear 


preserve
collapse (count) `variables2', by(year) fast
gen sample = "Full Sample"
tempfile file1
gen stat = "Obs."
save `file1', replace
restore

preserve
collapse (mean) `variables2', by(year) fast
gen sample = "Full Sample"
tempfile file2
gen stat = "Mean"
save `file2', replace
restore

preserve
collapse (sd) `variables2', by(year) fast
gen sample = "Full Sample"
tempfile file3
gen stat = "Std. Dev."
save `file3', replace
restore

use `file1', clear
append using `file2'
append using `file3'


gen id = 1 if stat=="Obs."
replace id = 2 if stat=="Mean"
replace id = 3 if stat=="Std. Dev."
drop sample stat
order id year

xpose, clear


foreach var of varlist v1-v6{
 gen aux = string(`var')
 drop `var'
 ren aux `var'
 }

gen variable = ""
replace variable = "Variable"                               in 1
replace variable = "Year"                                   in 2
replace variable = "Access to financing                   " in 3
replace variable = "Cost of financing                     " in 4
replace variable = "Tax rates                             " in 5
replace variable = "Tax administration                    " in 6
replace variable = "Custom/foreign trade regulations      " in 7
replace variable = "Business licencing & permit           " in 8
replace variable = "Labour regulations                    " in 9
replace variable = "Uncertainty about regulatory policies " in 10
replace variable = "Macroeconomic instability             " in 11
replace variable = "Functioning of the judiciary          " in 12
replace variable = "Corruption                            " in 13
replace variable = "Street crime theft & disorder         " in 14
replace variable = "Organised crime mafia                 " in 15
replace variable = "Anti-competitive practices            " in 16
replace variable = "Infrastructure                        " in 17
replace variable = "Average of all constraints            " in 18

ren v1 obs_1
ren v2 obs_2
ren v3 mean_1
ren v4 mean_2
ren v5 sd_1
ren v6 sd_2


count
local n = r(N)+3
set obs `n'
      
save "$tables/table1_part3.dta", replace



********************* COMPILE TABLE ****************************

use           "$tables/table1_part1.dta"
append using  "$tables/table1_part2.dta"
append using  "$tables/table1_part3.dta"
order  variable obs_1 mean_1 sd_1

outsheet using "$tables/table1.csv", comma replace

erase "$tables/table1_part1.dta"
erase "$tables/table1_part2.dta"
erase "$tables/table1_part3.dta"
