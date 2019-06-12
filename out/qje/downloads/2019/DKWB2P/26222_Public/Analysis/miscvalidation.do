/* This do-file benchmarks IMS MIDAS data to OECD HealthStat and 
Medical Expenditure Panel Survey (MEPS) data for Appendix B.3 of Costinot, Donaldson, Kyle and Williams (QJE, 2019)
*/ 


capture log close
*set log
log using "${log_dir}miscvalidation.log", replace

*suppress graph window
set graphics off
	
* Part 1: validation using MEPS data (Appendix B.3.2)
use "${meps2012}H152A.dta", clear
	*make all variables names lower case
	rename _all, lower
	keep rxname perwt rxxp12x
	rename rxxp tot_exp
	drop if perwt==0
	assert !mi(perwt) & perwt > 0

	*we want average expenditure per drug
	*multiplying expenditure by weight of observation
	replace tot_exp=tot_exp*perwt

	drop if rxname==""

	replace rxname=lower(rxname)
	replace rxname=rtrim(itrim(trim(rxname)))
	assert !mi(rxname)

	collapse (sum) tot_exp, by (rxname)

	rename rxname prd
	
	compress
	save "${intersavedir}meps_consolidated_drug.dta", replace

	use "${rawdata2013}sales_rawdata2013_qtr.dta", clear

	* create year variable and keep year 2012
	gen year = yofd(dofq(period))
	keep if year == 2012

	* sum up four quarters to get yearly sales
	collapse (sum) standard_units sales_mnf sales_trd sales_pub counting_units units_qtr, by(id year)

	merge m:1 id using "${rawdata2013}bib_2000.dta"
	assert _merge==3
	drop _merge
	
	*retain only US expenditure
	keep if dest_ctry=="us"
	keep sales_mnf prd 
	replace prd=lower(prd)
	replace prd=rtrim(itrim(trim(prd)))

	collapse (sum) sales_mnf, by(prd)

	*sales are reported in thousands (refer to page 5/13 of 2010_MIDAS Data Elements Guide)
	replace sales_mnf=sales_mnf*1000

	save "${intersavedir}ims_drug_level_expenditure.dta", replace 

	*Merge both data sources
use "${intersavedir}ims_drug_level_expenditure.dta", clear
	merge 1:1 prd using  "${intersavedir}meps_consolidated_drug.dta"

	*calculating sales by merge
preserve
	collapse (sum) tot_exp sales_mnf, by(_merge)
	
	egen total_ims_sales = total(sales_mnf) if inlist(_merge, 1, 3)
	gen percent_sales_merged = 100*sales_mnf/total_ims_sales
	list
	* this shows that ~62% of IMS sales map to MEPS
restore
	drop if _merge!=3

	*changing units to millions
	replace tot_exp=tot_exp/1000000
	replace sales_mnf=sales_mnf/1000000

	corr sales_mnf tot_exp
	
	** reported correlation:
		di r(rho)
	
	sum tot_exp
	local meps_max = r(max)
	sum sales_mnf
	local ims_max = r(max) 

	local max = max(`meps_max', `ims_max')

	*generate Appendix Figure B.4
	graph twoway (scatter sales_mnf tot_exp) (lfit sales_mnf tot_exp, lp(dash)) (function y=x, range(0 `max')), xtitle(MEPS expenditure millions) ///
	ytitle(IMS sales millions) legend( lab(1 "expenditure per drug") lab(2 "line of best fit") lab(3 "45 degree line")) graphregion(color(white)) scheme(s1mono)
	graph export "${output_dir}figB4.pdf", replace




* Part 2: validation using OECD pharma data (Appendix B.3.1)

	*pharma countries
	import delimited using "${oecd_pharma}oecd_pharmaceuticals.csv", clear
	keep country
	duplicates drop
	rename country dest_ctry
	
	count
	assert r(N)==36
	
	replace dest_ctry=lower(dest_ctry)
	assert dest_ctry == trim(itrim(dest_ctry))
	list
	
	*renaming some countries to enable merge
	replace dest_ctry="czech" if dest_ctry=="czech republic"
	replace dest_ctry="us" if dest_ctry=="united states"
	replace dest_ctry="uk" if dest_ctry=="united kingdom"

	save "${intersavedir}country_pharma.dta", replace

	use "${rawdata2013}sales_rawdata2013_qtr.dta", clear
	* create year variable and keep year 2012
	gen year = yofd(dofq(period))
	keep if year == 2012

	merge m:1 id using "${rawdata2013}bib_2000.dta"
	assert _merge == 3
	drop _merge
	*retain only US expenditure
	drop if sales_mnf==.
	keep dest_ctry

	duplicates drop

	merge 1:1 dest_ctry using "${intersavedir}country_pharma.dta"
	
	keep if _merge==3
	drop _merge
	
	save "${intersavedir}final_country_list.dta", replace	


	*Using OECD pharmaceuticals data
	import delimited using "${oecd_pharma}oecd_pharmaceuticals.csv", clear
	rename country dest_ctry

	replace dest_ctry=lower(dest_ctry)

	*renaming some countries to enable merge
	replace dest_ctry="czech" if dest_ctry=="czech republic"
	replace dest_ctry="us" if dest_ctry=="united states"
	replace dest_ctry="uk" if dest_ctry=="united kingdom"

	*keeping values of total sales 
	keep if variable=="Total pharmaceutical sales"
	
	merge m:1 dest_ctry using "${intersavedir}final_country_list.dta"
	tab dest_ctry if _merge==2
	drop if _merge!=3
	drop _merge 

	keep if unit=="MTMOTCMT"
	isid dest_ctry
	assert year == 2012
	merge 1:1 dest_ctry using "${intersavedir}final_country_list.dta"
	tab dest_ctry if _merge==2
	drop if _merge!=3
	drop _merge 

	save "${intersavedir}oecd_exp.dta", replace
	
	*Finding matching values from the IMS data
	use "${rawdata2013}sales_rawdata2013_qtr.dta", clear
	* create year variable and keep year 2012
	gen year = yofd(dofq(period))
	keep if year == 2012

	merge m:1 id using "${rawdata2013}bib_2000.dta"
	assert _merge == 3
	drop _merge
	
	*retain only US expenditure
	drop if sales_mnf==.
	keep sales_mnf dest_ctry
	collapse (sum) sales_mnf, by(dest_ctry)
	
	*change some names to enable merge
	replace dest_ctry="china, mainland" if dest_ctry=="china"
	replace dest_ctry="korea, south" if dest_ctry=="korea"
	replace dest_ctry="usa" if dest_ctry=="united states"
	replace dest_ctry="czech republic" if dest_ctry=="czech"
	replace dest_ctry="united states" if dest_ctry=="us"
	replace dest_ctry="united kingdom" if dest_ctry=="uk"
	replace dest_ctry="united arab emirates" if dest_ctry=="uae"
	
	replace dest_ctry = upper(dest_ctry)

	merge 1:1 dest_ctry using "${intersavedir}lcu_dollar_2012.dta"
	replace dest_ctry = lower(dest_ctry)
	assert _merge!=1 if dest_ctry!="united states"
	assert dest_ctry=="united states" if _merge==1
	drop if _merge!=3
	drop _merge

	assert dest_ctry!="united states"
	replace sales_mnf = sales_mnf/lcu_dollar
	
	*change names back
	replace dest_ctry="china" if dest_ctry=="china, mainland"
	replace dest_ctry="korea" if dest_ctry=="korea, south"
	replace dest_ctry="czech" if dest_ctry=="czech republic"
	replace dest_ctry="uk" if dest_ctry=="united kingdom"
	replace dest_ctry="uae" if dest_ctry=="united arab emirates"

	*Merging both data sets together
	merge 1:1 dest_ctry using "${intersavedir}oecd_exp.dta"

	*check which countries did not match
	rename _merge _merge_m
	merge 1:1 dest_ctry using "${intersavedir}final_country_list.dta"
	tab dest_ctry if _merge!=3
	drop if _merge!=3

	*only retain countries that match
	drop if _merge_m!=3
	count
	assert r(N)==24

	*retaining values of interest
	keep sales_mnf dest_ctry value
		
	*sales in billions
	replace sales_mnf = sales_mnf/1000000
	replace value = value/1000

	*generating labels
	gen country = dest_ctry if  (sales_mnf > 25 | value > 19)
	replace country="" if country=="uk"

	corr sales_mnf value
	corr sales_mnf value if !inlist(dest_ctry, "canada", "italy", "turkey", "uk")
	
	sum value
	local oecd_max = r(max)
	sum sales_mnf
	local ims_max = r(max) 
	local max = max(`ims_max', `oecd_max')

	* Produce Appendix Figure B.2
	graph twoway (scatter sales_mnf value, mlabel(country)) (lfit sales_mnf value, lp(dash)) (function y=x, range(0 `max')), xtitle(OECD health expenditure billions) ///
	ytitle(IMS sales billions) legend( lab(1 "expenditure per country") lab(2 "line of best fit") lab(3 "45 degree line")) graphregion(color(white)) scheme(s1mono)
	graph export "${output_dir}figB2.pdf", replace

	*Distribute by ATC code1 using OECD pharmaceuticals data
	import delimited using "${oecd_pharma}oecd_pharmaceuticals.csv", clear
	rename country dest_ctry
	replace dest_ctry=lower(dest_ctry)
	assert dest_ctry == trim(itrim(dest_ctry))

	*we only have data that can be compared at the highest level of ATC codes
	gen keep=1 if regexm(variable, "A-Alimentary")
	replace keep=1 if regexm(variable, "B-Blood and")
	replace keep=1 if regexm(variable, "C-Cardiovascular")
	replace keep=1 if regexm(variable, "G-Genito urinary")
	replace keep=1 if regexm(variable, "H-Systemic")
	replace keep=1 if regexm(variable, "J-Antiinfectives")
	replace keep=1 if regexm(variable, "M-Musculo-skeletal")
	replace keep=1 if regexm(variable, "N-Nervous system")
	replace keep=1 if regexm(variable, "R-Respiratory")

	gen atc = substr(variable, 1,1)

	*renaming some countries to improve merge
	replace dest_ctry="czech" if dest_ctry=="czech republic"
	replace dest_ctry="us" if dest_ctry=="united states"
	replace dest_ctry="uk" if dest_ctry=="united kingdom"

	keep if keep==1
	merge m:1 dest_ctry using "${intersavedir}final_country_list.dta"
	tab dest_ctry if _merge==2
	drop if _merge!=3
	drop _merge

	keep if unit=="MTMOTCMT"
	merge m:1 dest_ctry using "${intersavedir}final_country_list.dta"
	tab dest_ctry if _merge==2
	drop if _merge!=3
	drop _merge

	save "${intersavedir}oecd_exp_atc.dta", replace
	
	*Finding matching values from the IMS data
	use "${rawdata2013}sales_rawdata2013_qtr.dta", clear

	* create year variable and keep year 2012
	gen year = yofd(dofq(period))
	keep if year == 2012
	
	merge m:1 id using "${rawdata2013}bib_2000.dta"
	assert _merge == 3
	drop _merge
	
	*retain only OECD expenditure
	gen atc=substr(atc4, 1,1)
	drop if sales_mnf==.
	keep sales_mnf dest_ctry atc
	collapse (sum) sales_mnf, by(dest_ctry atc)

	replace atc=upper(atc)
	tab atc
	
	*change some names to improve merge
	replace dest_ctry="china, mainland" if dest_ctry=="china"
	replace dest_ctry="korea, south" if dest_ctry=="korea"
	replace dest_ctry="usa" if dest_ctry=="united states"
	replace dest_ctry="czech republic" if dest_ctry=="czech"
	replace dest_ctry="united states" if dest_ctry=="us"
	replace dest_ctry="united kingdom" if dest_ctry=="uk"
	replace dest_ctry="united arab emirates" if dest_ctry=="uae"
	
	replace dest_ctry = upper(dest_ctry)
	
	merge m:1 dest_ctry using "${intersavedir}lcu_dollar_2012.dta"
	replace dest_ctry = lower(dest_ctry)
	assert _merge!=1 if dest_ctry!="united states"
	assert _merge==1 if dest_ctry=="united states"
	drop if _merge!=3
	drop _merge

	assert dest_ctry != "united states"
	replace sales_mnf=sales_mnf/lcu_dollar
	
	*change names back
	replace dest_ctry="china" if dest_ctry=="china, mainland"
	replace dest_ctry="korea" if dest_ctry=="korea, south"
	replace dest_ctry="czech" if dest_ctry=="czech republic"
	replace dest_ctry="uk" if dest_ctry=="united kingdom"
	replace dest_ctry="uae" if dest_ctry=="united arab emirates"
	
	merge 1:1 dest_ctry atc using "${intersavedir}oecd_exp_atc.dta"

	bys dest_ctry: egen sum = total(_merge==3)
	drop if sum==0
	drop sum

	bys atc: egen sum = total(_merge==3)
	drop if sum==0

	replace sales_mnf = 0 if sales_mnf == .
	replace value = 0 if value == .

	*retaining values of interest
	keep sales_mnf dest_ctry value atc
			
	*sales in billions
	replace sales_mnf=sales_mnf/1000000
	replace value=value/1000

	list dest_ctry if sales_mnf > 10

	*creating names for outliers
	gen country = dest_ctry + " " + atc if sales_mnf > 5
	replace country = dest_ctry + " " + atc if value > 7

	sum sales_mnf
	local max_sales = r(max)
	sum value
	local max_value = r(max)
	local max = max(`max_sales', `max_value')
	
	corr sales_mnf value	
	corr sales_mnf value if !inlist(dest_ctry, "canada", "italy", "turkey", "uk")
	
	gen pos = 3
	replace pos = 9 if country == "japan C"
	replace pos = 10 if country == "japan B"
	replace pos = 5 if country == "japan M"
	
	* Produce Appendix Figure B.3.
	graph twoway (scatter sales_mnf value, mlabel(country) mlabv(pos)) (lfit sales_mnf value, lp(dash)) (function y=x, range(0 `max')), xtitle(OECD health expenditure billions) ///
	ytitle(IMS sales billions) legend( lab(1 "expenditure per country ATC") lab(2 "line of best fit") lab(3 "45 degree line")) graphregion(color(white)) scheme(s1mono)
	graph export "${output_dir}figB3.pdf", replace


log close
