**** merging datasets together
**** this file merges all the data sets together for the US analysis and then runs the US models
*** start with our CCES survey data
use "cces06081012 election.dta"
sort fips_code grouping
save, replace
use "newelectiondemo.dta", clear
**** we now add the district level data which came from the census and bureau of labor statitics 
**** to see US census variable sources, enter notes in this data set
sort fips_code grouping
merge fips_code grouping using "cces06081012 election.dta"
keep if _merge ==3
drop _merge
save "CCESplusdemo.dta", replace
sort fips_code grouping
save, replace
**** we now add the casualty data
**** first the interelection data
use "inter-election casulaties.dta", clear
sort fips_code grouping
merge fips_code grouping using "CCESplusdemo.dta"
replace casualty_sum =0 if _merge==2
drop if _merge ==1
drop _merge
save "CCES intercas demo.dta", replace
sort fips_code year
save, replace
**** now we add the 30 days prior casualty data
use "30daycas.dta",
sort fips_code year
merge fips_code year using "CCES intercas demo.dta",
replace cas30 =0 if _merge ==2
drop if _merge ==1
drop _merge
save "CCES intercascas30 demo.dta", replace
sort fips_code year
save, replace
*** now we add the 60 days prior casualty data
use "60daycas.dta"
sort fips_code year
merge fips_code year using "CCES intercascas30 demo.dta",
replace cas60 =0 if _merge ==2
drop if _merge ==1
drop _merge
save"CCES intercascas30cas60 demo.dta", replace
**** this section transforms variables for the analysis

gen presyr =1 if grouping==2
replace presyr=1 if grouping ==4
replace presyr=0 if presyr==.
gen lnpop = ln(population)
gen median1000 = median/1000
replace income=. if income>15
gen college = 1 if education>3
replace college = 0 if college ==.
replace pres_approve=. if pres_approve>4



egen panelid = group(fips_code grouping)
xtset panelid
***CCES models
***The following produces models 1, 2 and 3 of table 3 figures 1 and 2 and tabel 4a of supplementary material 
*** this produces model 1 of table 3: Interelection casualties
xtprobit turnout2 c.casualty_sum i.low_interest c.casualty_sum##i.low_interest female married income age college white pres_approve presyr  strong_party economy_good unemployed mistake_iraq  unemployment median1000 pctwhite lnpop
*** this produces figure 1
margins i.low_interest, at(casualty_sum==(0(5)50)(median)) level(95)
marginsplot

graph save Graph "figure1 final.gph"

*** this produces table 4 a summary statistics in supplemental material except for 30 and 60 day casualty measures see below model 2
summarize turnout2 c.casualty_sum i.low_interest c.casualty_sum##i.low_interest female married income age college white pres_approve presyr  strong_party economy_good unemployed mistake_iraq  unemployment median1000 pctwhite lnpop if e(sample)

***this section produces model 2 of table 3 and the summary statistic of 30 days prior casualties 
xtprobit turnout2 c.cas30 i.low_interest c.cas30##i.low_interest casualty_sum  female married income college  pres_approve presyr white age strong_party economy_good unemployed mistake_iraq  unemployment median1000 pctwhite lnpop
****this produces figure 2
margins i.low_interest, at(cas30==(0(1)5) casualty_sum=5 (median)) level(95)
marginsplot

graph save Graph "figure2 final.gph"
*** descriptive statistic for 30 days variable fot table 4a of supplementary material 
summarize cas30 if e(sample)

***this produces model 3 of table 3: 60 days prior casualties

xtprobit turnout2 c.cas60 i.low_interest c.cas60##i.low_interest c.casualty_sum female married income college white pres_approve presyr age strong_party economy_good unemployed mistake_iraq  unemployment median1000 pctwhite lnpop

*** descriptive statistic for 60 days variable for table 4a of supplementary material 
summarize cas60 if e(sample)


****Table 5 of supplemental material plus figure 5 : Model of Independents 
generate independent =1 if party_id3 ==3 
replace independent =0 if independent ==.
xtprobit turnout2 c.casualty_sum i.independent c.casualty_sum##i.independent low_interest female married income  age college white strong_party pres_approve presyr  strong_party economy_good unemployed mistake_iraq  unemployment median1000 pctwhite lnpop
*** Figure 5 suplemental material 
margins i.independent, at(casualty_sum==(0(5)50)(median)) level(95)
marginsplot
graph save Graph "supplemental graph final.gph"
