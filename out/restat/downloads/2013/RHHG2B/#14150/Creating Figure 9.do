/* Select Patents Belonging to Sample Firms */

/* This do-file allows the user to recreate Figure 9 from the paper. The user should download all the necessary source files for replicating Table I
and run the requisite do-file before running this do-file */ 

/* Create Measures of Interest */

use "C:/Stata/#14150/pat76_06_assg.dta", clear
duplicates drop patent, force
keep patent appyear gyear cat subcat asscode country

sort patent 
merge patent using "C:/Stata/#14150/software_patents_newdef_76_06.dta"
drop if _merge==2
rename _merge software_patent
replace software_patent=0 if software_patent==1
replace software_patent=1 if software_patent==3

gen it_patent=0
replace it_patent=1 if cat==2
replace it_patent=1 if subcat==41
replace it_patent=1 if subcat==46

gen nonsof_it_patent=0
replace nonsof_it_patent=1 if it_patent==1 & software_patent==0

sort patent
merge patent using "C:/Stata/#14150/Patents Belonging to Sample Firms.dta"
keep if _merge==3
drop _merge
drop appyear asscode cat country subcat 

sort patent
merge patent using "C:/Stata/#14150/inv_location_patents.dta"
drop if _merge==2
replace location_firstinventor="Other" if _merge==1
replace location_allinventors="None" if _merge==1
drop _merge
drop if location_allinventors=="Both"
drop if location_allinventors=="None"

log using "C:/Stata/#14150/results-log.smcl", append

/* Figure 9 Data*/

ttest software_patent if firm_from_geography=="US", by(location_allinventors) 
ttest software_patent if firm_from_geography=="JP", by(location_allinventors) 

ttest software_patent if firm_from_geography=="JP" & industry==1, by(location_allinventors) 
ttest software_patent if firm_from_geography=="JP" & industry==2, by(location_allinventors) 
ttest software_patent if firm_from_geography=="JP" & industry==3, by(location_allinventors) 

ttest software_patent if firm_from_geography=="JP" & location_allinventors=="US" & industry!=1, by(industry) 
ttest software_patent if firm_from_geography=="JP" & location_allinventors=="US" & industry!=2, by(industry) 
ttest software_patent if firm_from_geography=="JP" & location_allinventors=="US" & industry!=3, by(industry) 

ttest software_patent if firm_from_geography=="JP" & location_allinventors=="JP" & industry!=1, by(industry) 
ttest software_patent if firm_from_geography=="JP" & location_allinventors=="JP" & industry!=2, by(industry) 
ttest software_patent if firm_from_geography=="JP" & location_allinventors=="JP" & industry!=3, by(industry) 

log off
log close


sort patent
merge patent using "C:/Stata/#14150/cite76_06_int.dta", nokeep
drop cited
gen citation=0
replace citation=1 if _merge==3
drop _merge
drop software_patent
keep if nonsof_it_patent==1
gen software_citation=0
replace software_citation=1 if software_patent_cited==1
collapse (sum) software_citation (sum) citation, by(patent gyear firm_from_geography location_allinventors location_firstinventor industry)
gen software_citation_share=software_citation/citation


log using "C:/Stata/#14150/results-log.smcl", append

/* Figure 9 Data - Continued*/

ttest software_citation_share if firm_from_geography=="US", by(location_allinventors) 
ttest software_citation_share if firm_from_geography=="JP", by(location_allinventors) 

ttest software_citation_share if firm_from_geography=="JP" & industry==1, by(location_allinventors) 
ttest software_citation_share if firm_from_geography=="JP" & industry==2, by(location_allinventors) 
ttest software_citation_share if firm_from_geography=="JP" & industry==3, by(location_allinventors) 

ttest software_citation_share if firm_from_geography=="JP" & location_allinventors=="US" & industry!=1, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & location_allinventors=="US" & industry!=2, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & location_allinventors=="US" & industry!=3, by(industry) 

ttest software_citation_share if firm_from_geography=="JP" & location_allinventors=="JP" & industry!=1, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & location_allinventors=="JP" & industry!=2, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & location_allinventors=="JP" & industry!=3, by(industry) 

log off
log close

