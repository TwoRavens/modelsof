/* Creating Table 3 - Software Intensity: Unit of Observation = Patent */

/* This do-file allows the user to recreate Table III from the paper. The user should download all the necessary source files for replicating Table I
and run the requisite do-file before running this do-file */ 

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


log using "C:/Stata/#14150/results-log.smcl", append

/* Table III Data */
ttest software_patent if firm_from_geography=="US" & industry!=1 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_patent if firm_from_geography=="US" & industry!=2 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_patent if firm_from_geography=="US" & industry!=3 & gyear>=1983 & gyear<=2004, by(industry) 

ttest software_patent if firm_from_geography=="JP" & industry!=1 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_patent if firm_from_geography=="JP" & industry!=2 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_patent if firm_from_geography=="JP" & industry!=3 & gyear>=1983 & gyear<=2004, by(industry) 

log off
log close


/* Creating Table 3 - Software Intensity: Unit of Observation = Firm */

sort firm_id industry
gen patent_count=1
collapse (sum) software_patent (sum) patent_count, by(firm_id industry firm_from_geography)
gen sofshare=software_patent/patent_count


log using "C:/Stata/#14150/results-log.smcl", append

/* Table III Data - Contd */

ttest sofshare if industry!=1 & firm_from_geography=="US", by(industry)
ttest sofshare if industry!=2 & firm_from_geography=="US", by(industry)
ttest sofshare if industry!=3 & firm_from_geography=="US", by(industry)

ttest sofshare if industry!=1 & firm_from_geography=="JP", by(industry)
ttest sofshare if industry!=2 & firm_from_geography=="JP", by(industry)
ttest sofshare if industry!=3 & firm_from_geography=="JP", by(industry)

log off
log close



/* Creating Table 3 - Citation Share: Unit of Observation = Patent */

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
merge patent using "C:/Stata/#14150/cite76_06_int.dta", nokeep
drop cited
gen citation=0
replace citation=1 if _merge==3
drop _merge
drop software_patent
keep if nonsof_it_patent==1
gen software_citation=0
replace software_citation=1 if software_patent_cited==1
collapse (sum) software_citation (sum) citation, by(patent gyear firm_from_geography industry firm_id)
gen software_citation_share=software_citation/citation


log using "C:/Stata/#14150/results-log.smcl", append

/* Table III Data - Contd */

ttest software_citation_share if firm_from_geography=="US" & industry!=1 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_citation_share if firm_from_geography=="US" & industry!=2 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_citation_share if firm_from_geography=="US" & industry!=3 & gyear>=1983 & gyear<=2004, by(industry) 

ttest software_citation_share if firm_from_geography=="JP" & industry!=1 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & industry!=2 & gyear>=1983 & gyear<=2004, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & industry!=3 & gyear>=1983 & gyear<=2004, by(industry) 

log off
log close


/* Creating Table 3 - Citation Share: Unit of Observation = Firm */

keep if gyear>=1983 & gyear<=2004
sort firm_id industry
collapse (mean) software_citation_share, by(firm_id industry firm_from_geography)


log using "C:/Stata/#14150/results-log.smcl", append

/* Table III Data - Contd */

ttest software_citation_share if firm_from_geography=="US" & industry!=1, by(industry) 
ttest software_citation_share if firm_from_geography=="US" & industry!=2, by(industry) 
ttest software_citation_share if firm_from_geography=="US" & industry!=3, by(industry) 

ttest software_citation_share if firm_from_geography=="JP" & industry!=1, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & industry!=2, by(industry) 
ttest software_citation_share if firm_from_geography=="JP" & industry!=3, by(industry) 

log off
log close



































