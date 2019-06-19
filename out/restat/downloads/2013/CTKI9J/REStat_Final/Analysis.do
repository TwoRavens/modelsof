/*
Analysis for Sunk Costs, Depreciation, and Industry Dynamics
Authors:Adelina Gschwandtner and Val E. Lambson
RA's: Jason Cook and Daniel Sullivan
Last Modified:5/3/2011

Inputs:  bigfirm.dta, sic2.dta, sic3.dta, 92_sales_raw.dta, dep_index_final.dta, dynamic_us_98_06.dta, flowtable1992_raw.dta, gdp_deflate.dta, 
		industry_code_sic_conversion_raw.dta, K_expend.dta, naics_sic.dta, & sales_92_02_raw.dta
Outputs: Regressions for all Tables 

Outline of Do-File:
i. Assign Directory Globals
I. Prepare Dataset for Tables 3-6
	1. Creates naics->sic conversion datasets 
		a. Drop bad observations and clean data
		b. Get substrings of sic and naics for more general merges
		c. If we have multiple naics codes for one sic then make the naics more general to include all sic codes
		d. make a more general conversion to catch straggelers
	2. Creates Depreciation Indeces dataset 
		a. Get industry to sic conversion
		b. Get sales rates for 1992 (Adelina's data)
		c.  Get sales rates for 2002
		d. Get depreciation indeces
	3. Creates K Expeditures dataset
		a. Clean the Data
		b. Get the mean expenditures by naics code
		c. Expand the multiple reported naics codes
		d. Final formatting
		e. Systematically collapse the mean expenditures on more and more general naics codes to later be merged
	4. Combine this data into main dataset
		a. Format the main data of firm changes
		b. Merge in deflation rates
		c. Merge in capital expenditures data for different generalities of naics code
		d. Merge in the depreciation data
		e. Merge in sales data 
		f. Deflate sales and capexp in terms of 2005 $
		g. Create log variables
II. Tables 1 & 2 Range and Variance of Number of Firms
	1. Prepare Dataset for Tables 1 & 2
		a. Initial Prep work
		b. Create firm value from outstanding shares and deflate value and sales to 2005 dollars
		c. Get firm deprecitation indeces
	2. Create the Tables
III.  Table 3
IV.   Table 4
V.  Table 5: ln(range of L/mean(L))
VI. Table 6: ln(range of firms)
VII.Table 7: ln(range of K/mean(K)) 
VIII.  Table 8: Descriptive Statistics */


*** i. Assign Directory Globals
	global mainDir "ADD MAIN PATH HERE" //add in the path for the main folder
	global dataDir "$mainDir\data" //add in the path for the data folder
	global tempDir "$mainDir\temp" //add in the path for a temp folder
	global resultDir "$mainDir\results" //add in the path for an output folder

*** I. Prepare Dataset for Tables 5-8
	** 1. Creates naics->sic conversion datasets 
		*Inputs:  naics_sic.dta		Outputs: sic_naics_4digit.dta, sic_naics_3digit.dta, sic_naics_2digit.dta
		use "$dataDir\naics_sic.dta",clear
		* a. Drop bad observations and clean data
			drop if naics2_title=="" & sic_title==""
			drop if naics==. & sic=="" & naics2==""
			tostring(naics),replace
			replace naics="" if naics=="."
			for X in any  naics2 naics: replace X=X[_n-1] if X==""
			drop if sic==""
			replace sic=subinstr(sic,"*","",.)
			gsort sic -naics 
			order sic naics
			drop if sic==sic[_n-1]
			keep sic naics naics2
			sort sic
			save "$tempDir\sic_naics_4digit",replace

		* b. Get substrings of sic and naics for more general merges
			replace sic=substr(sic,1,3)
			replace naics=substr(naics,1,4)
			sort sic naics
			drop if naics==naics[_n-1] & sic==sic[_n-1]
			bys sic:gen num=_N
		* c. If we have multiple naics codes for one sic then make the naics more general to include all sic codes
			replace naics=substr(naics,1,3) if num>1
			drop num
			sort sic naics
			drop if naics==naics[_n-1] & sic==sic[_n-1]
			bys sic:gen num=_N
			sort sic naics
			collapse(first) naics,by(sic) //these multiples do not have similarites so we will just take the first code
			save "$tempDir\sic_naics_3digit",replace

		* d. make a more general conversion to catch straggelers
			replace sic=substr(sic,1,2)
			replace naics=substr(naics,1,4)
			sort sic naics
			drop if naics==naics[_n-1] & sic==sic[_n-1]
			bys sic:gen num=_N
			*If we have multiple naics codes for one sic then make the naics more general to include all sic codes
			replace naics=substr(naics,1,3) if num>1
			sort sic naics
			drop if naics==naics[_n-1] & sic==sic[_n-1]
			drop num
			bys sic:gen num=_N
			*If we have multiple naics codes for one sic then make the naics more general to include all sic codes
			replace naics=substr(naics,1,2) if num>1
			sort sic naics
			drop if naics==naics[_n-1] & sic==sic[_n-1]
			drop num
			bys sic:gen num=_N
			sort sic naics
			collapse(first) naics,by(sic) //these multiples do not have similarites so we will just take the first code
			save "$tempDir\sic_naics_2digit",replace
			
	** 2. Creates Depreciation Indeces dataset 
		/* This do-files calculates the depreciation indeces according to equation (3.2) in the paper.
			Inputs: industry_code_sic_conversion_raw.dta, 92_sales_raw.dta, sales_97_02_raw.dta, flowtable1992_raw.dta, 
			Outputs: dep_index_final.dta, dep_index_final4.dta, dep_index_final3.dta, dep_index_final2.dta	*/

		* a. Get industry to sic conversion
			use "$dataDir\industry_code_sic_conversion_raw",clear
			split sic,p(,)
			drop sic
			reshape long sic,i(industry_code) j(sic_code)
			drop if sic==""
			drop sic_code
			*Manually fix a few anomalies
			replace industry_code=100 if industry_code==102
			replace industry_code=700 if industry_code==789
			replace industry_code=1520 if industry_code==1567
			replace sic="737" if sic== " 737 except 7377"
			sort industry_code
			save "$tempDir\industry_sic_conv",replace

		* b. Get sales rates for 1992 (Adelina's data)
			use "$dataDir\92_sales_raw.dta",clear
			*Convert industry codes to sic codes
			merge 1:m industry_code using $tempDir\industry_sic_conv
			drop _m
			replace sic=subinstr(sic," ","",.)
			*Convert sic codes to naics codes using 4 digit conversions
			merge m:1 sic using "$tempDir\sic_naics_4digit.dta"
			drop if _m==2
			drop _m
			*Merge on systematically more general codes to catch the missing observations
			foreach i of numlist 3 2{
			merge m:1 sic using "$tempDir\sic_naics_`i'digit.dta",update
				drop if _m==2
				gen merged`i'=_m
				drop _m
			}
			drop if naics==""
			*First compile the data so we have one observation per industry (Note: multiple observations have same sales values)
			sort industry_code naics //I added this
			collapse (first) sales naics ,by(industry_code)
			*Now sum up the sales across naics codes
			collapse (sum) sales,by(naics)
			gen year=1992
			save "$tempDir\sales_92",replace

		* c.  Get sales rates for 2002
			use "$dataDir\sales_97_02_raw.dta",clear
			*get sales into integer format
			replace sales=subinstr(sale,",","",.)
			destring (sales),replace
			keep naics year sales
			sort naics year
			append using $tempDir\sales_92
			save "$tempDir\tempSales",replace
			
			*Get the average sales by year and naics code
			collapse(mean) sales,by(naics year)
			save "$tempDir\avg_sales",replace

			*make substrings of naics to try to catch stragglers
			foreach i of numlist 4 3 2{
				replace naics=substr(naics,1,`i')
				*since the naics code is more general now sum across similar naics codes
				collapse(mean)sales,by(naics year)
				replace naics=subinstr(naics," ","",.)
				save "$tempDir\avg_sales`i'",replace
			}
			
			*Get mean sales by naics code
			use "$tempDir\tempSales",replace
			collapse(mean) sales,by(naics)
			save "$tempDir\avg_sales_by_naics",replace	

		* d. Get depreciation indeces
			use "$dataDir\flowtable1992_raw",clear
			*format the data and clean up unneeded symbols
			foreach var in hw1 hw2 bea{
				replace `var'=subinstr(`var',"…","",.)
				replace `var'=subinstr(`var',",",".",.)
				destring(`var'),replace
			}
			foreach var of varlist sic*{
				replace `var'="" if `var'=="............"
				replace `var'=subinstr(`var',",","",.)
				destring(`var'),replace
				for X in any hw1 hw2 bea: gen X_`var'=X*`var'
			}
			collapse (sum) hw* bea*
			drop hw1 hw2 bea
			gen id=_n
			reshape long bea_sic hw1_sic hw2_sic, i(id) j(sic)
			drop id
			for X in any hw1 hw2 bea: rename X_sic X

			*get sic codes for industry codes
			rename sic industry_code
			*manually fix some anomolies
			replace industry_code=100 if industry_code==102
			replace industry_code=700 if industry_code==789
			replace industry_code=1520 if industry_code==1567
			merge 1:m industry_code using $tempDir\industry_sic_conv
			drop _m

			*get naics codes
			replace sic=subinstr(sic," ","",.)
			merge m:1 sic using "$tempDir\sic_naics_4digit.dta"
			drop if _m==2
			drop _m
			*Merge on systematically more general codes to catch the straggelers
			foreach i of numlist 3 2{
				merge m:1 sic using "$tempDir\sic_naics_`i'digit.dta",update
				drop if _m==2
				gen merged`i'=_m
				drop _m
			}
			drop if naics==""
			*First compile the data so we have one observation per industry (Note: multiple observations have same sales values)
			gsort industry_code -naics
			collapse (mean)hw* bea (first) sic naics ,by(industry_code)
			*Now get total depreciation indeces by naics code
			collapse (first) sic (sum) hw* bea,by(naics)
			
			*bring in sales to normalize
			merge 1:1 naics using "$tempDir\avg_sales_by_naics"
			drop if _m==2
			drop _m
			for X in any hw1 hw2 bea:replace X=X/sales
			drop sales
			save "$tempDir\dep_index_final",replace


			*make substrings of naics to try to catch stragglers
			foreach i of numlist 4 3 2{
				replace naics=substr(naics,1,`i')
				*since the naics code is more general now sum across similar naics codes
				collapse(first) sic (sum)hw* bea,by(naics)
				save "$tempDir\dep_index_final`i'",replace
			}

			*make substrings of sics to try to catch stragglers
			foreach i of numlist 3 2{
				replace sic=substr(sic,1,`i')
				*since the naics code is more general now sum across similar naics codes
				collapse(sum)hw* bea,by(sic)
				save "$tempDir\dep_index_sic`i'",replace
			}

	
	** 3. Creates K Expeditures dataset
		/*This portion calculates mean capital expenditures by naics codes
			Inputs: K_expend.dta
			Outputs: cap_exp2.dta cap_exp3.dta cap_exp4.dta	*/

		* a. Clean the Data
			use "$dataDir\K_expend.dta",clear
			for X in any  total_expenditures total_new_expenditures :rename X99 X_1999
			for X in any  total_expenditures total_new_expenditures :rename X2000 X_2000
			rename  total_new_expenditures_206  total_new_expenditures_2006
			*remove commas so we can get into number format
			forv i=1999(1)2006{
				foreach X in total_expenditures total_new_expenditures{
				cap{
					replace `X'_`i'=subinstr(`X'_`i',",","",.)
					destring(`X'_`i'),replace
					}
				}
			}
			reshape long  total_expenditures_ total_new_expenditures_, i(naics) j(year)

		* b. Get the mean expenditures by naics code
			collapse (mean)meancapexp=total_expenditures meannewcapexp=total_new_expenditures_ ,by(naics year)
			sort naics year
			*drop some group naics codes
			split naics,p("-")
			drop if naics2!=""
			drop naics1 naics2

		* c. Expand the multiple reported naics codes
			split naics,p(",")
			gen exp=1
			for X in any naics2 naics3 naics4 naics5 naics6: replace exp=exp+1 if X!=""
			expand exp,gen(expanded)
			bys naics year: gen num=_n
			for X in any 1 2 3 4 5 6:replace naics=naicsX if num==X
			for X in any 1 2 3 4 5 6:drop naicsX
			drop exp* num
			replace naics="624" if naics=="624 (except 6244)"

		* d. Final formatting
			drop if naics=="By industry" | naics=="Total_expenditures_" //drop non-numeric observations
			replace naics=subinstr(naics," ","",.) //remove spaces
			save "$tempDir\temp1",replace

		* e. Systematically collapse the mean expenditures on more and more general naics codes to later be merged
			forv i=2(1)4{
				use $tempDir\temp1,clear
				replace naics=substr(naics,1,`i')
				*destring(naics),replace
				collapse (mean) meancapexp meannewcapexp,by(naics year)
				sort naics
				save "$tempDir\cap_exp`i'",replace
			}

	** 4. Combine this data into main dataset
		* a. Format the main data of firm changes
			use "$dataDir\dynamic_us_98_06.dta",clear //this is raw data with firm changes
			replace naics=subinstr(naics,"-","",.)
			sort naics_title naics
			drop if naics==""
			keep state naics beg_yr beg_yr yr1_estabs_tot nchange_tot birth_tot death_tot cont_exp_tot cont_con_tot yr1_emp_tot nchange_emp_tot birth_emp_tot death_emp_tot
			for X in any 2 3: gen naicsX=substr(naics,1,X)
			for X in any [ ] i j k: replace yr1_emp_tot=subinstr(yr1_emp_tot,"X","",.)
			destring(yr1_emp_tot),replace
			gen netentry=birth_tot - death_tot //Define net entry

		* b. Merge in deflation rates
			rename beg_yr year
			merge m:1 year using "$dataDir\gdp_deflate"
			drop _merge

			//get deflator base year
			summ gdp_def if year==2005
			local def05 = r(mean)							

			tostring(naics),gen (naics4)

		* c. Merge in capital expenditures data for different generalities of naics code
			forv i=2(1)4{
				merge m:1 naics year using "$tempDir\cap_exp`i'",update
				drop if _m==2
				drop _m
			}

			*Catch some of the stragglers
			gen temp=naics
			tostring(naics),replace
			replace naics=substr(naics,1,3)
			merge m:1 naics year using "$tempDir\cap_exp3",update
			drop if _==2
			replace naics=temp
			drop temp _m

		* d. Merge in the depreciation data
			tostring(naics),replace
			merge m:1 naics using "$tempDir\dep_index_final"
			drop _m
			*merge with different naics generalities
			foreach i of numlist 4 3 2{
				merge m:1 naics using "$tempDir\dep_index_final`i'",update
				drop if _m==2
				drop _m
			}

		* e. Merge in sales data 
			merge m:1 naics year using "$tempDir\avg_sales"
			drop if _m==2
			drop if naics==""
			drop _m
			*merge with different naics generalities
			foreach i of numlist 4 3 2{
				merge m:1 naics year using "$tempDir\avg_sales`i'",update
				drop if _m==2
				drop _m
			}
			
			for X in any hw1 hw2 bea: gen raw_X=X  //keep un-normalized dep. rates for Desc. Statistics later
			for X in any hw1 hw2 bea:gen X_sales_norm=X/sales
			for X in any hw1 hw2 bea:replace X=X/sales
			
		* f. Deflate sales and capexp in terms of 2005 $
			gen def_sales= sales*`def05'/gdp_def
			for X in any meancapexp meannewcapexp:gen def_X=X*`def05'/gdp_def

		* g. Create log variables
			for X in any def_sales def_meancapexp def_meannewcapexp hw1 hw2 bea: gen ln_X=ln(X)
			save "$tempDir\temp",replace
			
*** II. Tables 1 & 2
	** 1. Prepare Dataset for Tables 1 & 2
		* a. Initial Prep work
			cd $tempDir

			clear all
			set mem 100m
			use "$dataDir\bigfirm",clear  //use compustat data

			//Period of interest
			global startyear 1970
			global endyear 2008

			rename fyear year
			
			merge m:1 year using "$dataDir\gdp_deflate" //Get deflation rates
			drop _merge

			//get deflator base year
			summ gdp_def if year==2005
			local def05 = r(mean)							

			keep if inrange(year,$startyear,$endyear)
		* b. Create firm value from outstanding shares and deflate value and sales to 2005 dollars
			gen liabilities = lt*`def05'/gdp_def
			gen firmvalue = prcc_f*csho*`def05'/gdp_def 	
			gen firmsales = revt*`def05'/gdp_def	
			replace ppegt = ppegt*`def05'/gdp_def

			//Normalize by Labor and find net firm value
			gen normppe = ppegt/emp
			gen normval = (firmvalue+lt)/emp

			//Get Maximum and minimum firm values
			bys gvkey: egen maxnormval = max(normval)
			bys gvkey: egen minnormval = min(normval)
			bys gvkey: egen sdnormval = sd(normval)


			//Create range of firm value
			gen normrange = maxnormval - minnormval

			//Create substrings of sic code to match base depreciation numbers (\lambda_{i}P_{iF}*/S_{F})
			gen sic3 = substr(sic,1,3)
			gen sic2 = substr(sic,1,2)

			//Collapse to means and counts, one observation per firm
			collapse (mean) sales = firmsales ppe = normppe normrange=normrange emp=emp lt=lt sdnormval= sdnormval (count) years = year, by(gvkey sic sic2 sic3)
		* c. Get firm deprecitation indeces
			merge m:1 sic using dep_index_final, keepusing(hw* bea)	
			drop if _m ==2
			drop _m
			//Merge in industry-level depreciation numbers, match to firms at three significant digits
			gen sic4=sic
			replace sic=sic3
			merge m:1 sic using dep_index_sic3, keepusing(hw* bea) update	
			drop if _m==2
			drop _m
			
			//Merge in industry-level depreciation numbers, match to firms at two significant digits
			replace sic=sic2
			merge m:1 sic using dep_index_sic2, keepusing(hw* bea) update
			drop if _m==2
			drop _m
			
			//Create depreciation numbers at firm level
			gen ai13= hw1*sales				
			gen ai13r = hw2*sales
			gen ai13bea = bea*sales

			//Gen log variables
			gen logai13 = ln(ai13)
			gen logai13r = ln(ai13r)
			gen logai13bea = ln(ai13bea)
			gen lnormrange = ln(normrange)
			gen lnormvar = 2*ln(sdnormval)
			gen lnormppe = ln(ppe)

			//Labels
			lab var lnormppe "Log-Normalized PPE"
			lab var lnormrange "Log-Normalized Value Range"
			lab var lnormvar "Log-Normalized Value Variance"
			lab var sales "Average sales"
			lab var lt "Total Liabilities"
			lab var emp "Labor"

	** 2. Create Tables 1 & 2
		local vars lt ai13 ai13r ai13bea ppe lnormppe lnormvar years sales emp lnormrange lnormvar
		
		foreach lhv in range var {
			local i =1
			foreach deprec in logai13 logai13r logai13bea {
				reg lnorm`lhv' lnormppe `deprec' years, cluster(sic)
				if ("`lhv'"=="range" & "`deprec'"=="logai13") gen samp = e(sample)
				est sto `lhv'_`i'
				local i = `i' + 1	
			}
		}
		outreg2 [range_1 range_2 range_3 var_1 var_2 var_3] using "$resultDir\Tables_1_2.txt", replace lab

		log using "$resultDir\summaryTables1_2.txt", t replace
		summ `vars' if samp, sep(0)
		log close

		summ `vars' if samp, d

*** III. Table 3
	use "$dataDir\bigfirm", clear
	rename fyear year

	merge m:1 year using "$dataDir\gdp_deflate"
	drop _merge

	//get deflator base year
	summ gdp_def if year==2005
	local def05 = r(mean)							

	//Create firm value from outstanding shares and deflate value and sales to 2005 dollars
	gen liabilities = lt*`def05'/gdp_def
	gen firmvalue = prcc_f*csho*`def05'/gdp_def 	
	gen firmsales = revt*`def05'/gdp_def
	replace ppegt = ppegt*`def05'/gdp_def		
			

	//Normalize by Labor and find net firm value
	gen normppe = ppegt/emp
	gen normval = (firmvalue+lt)/emp

	//Get Maximum and minimum firm values
	bys gvkey: egen maxnormval = max(normval)
	bys gvkey: egen minnormval = min(normval)
	bys gvkey: egen sdnormval = sd(normval)


	//Create range of firm value
	gen normrange = maxnormval - minnormval

	//Create substrings of sic code to match base depreciation numbers (\lambda_{i}P_{iF}*/S_{F})
	gen sic3 = substr(sic,1,3)
	gen sic2 = substr(sic,1,2)

	foreach period in 1970,1979 1980,1989 1990,1999 2000,2008 {
		preserve
		keep if inrange(year,`period')

		//Collapse to means and counts, one observation per firm
		collapse (mean) sales = firmsales ppe = normppe normrange=normrange emp=emp lt=lt sdnormval= sdnormval (count) years = year, by(gvkey sic sic2 sic3)
		
		//Merge in industry-level depreciation numbers, match to firms at three significant digits
		gen sic4=sic
		replace sic=sic3
		merge m:1 sic using dep_index_sic3, keepusing(hw* bea) update	
		drop if _m==2
		drop _m
		
		//Merge in industry-level depreciation numbers, match to firms at two significant digits
		replace sic=sic2
		merge m:1 sic using dep_index_sic2, keepusing(hw* bea) update
		drop if _m==2
		drop _m
		
		//Create depreciation numbers at firm level
		gen ai13= hw1*sales				
		gen ai13r = hw2*sales
		gen ai13bea = bea*sales
		
		//Gen log variables
		gen logai13 = ln(ai13)
		gen logai13r = ln(ai13r)
		gen logai13bea = ln(ai13bea)
		gen lnormrange = ln(normrange)
		gen lnormvar = 2*ln(sdnormval)
		gen lnormppe = ln(ppe)
		
		//Labels
		lab var lnormppe "Log-Normalized PPE"
		lab var lnormrange "Log-Normalized Value Range"
		lab var lnormvar "Log-Normalized Value Variance"
		lab var sales "Average sales"
		lab var lt "Total Liabilities"
		lab var emp "Labor"

		local vars lt ai13 ai13r ai13bea ppe lnormppe lnormvar years sales emp lnormrange lnormvar

		local base=substr("`period'",1,4)
		
		* Create Table 3
		foreach lhv in range var {
			local i =1
			foreach deprec in logai13 logai13r logai13bea {
				reg lnorm`lhv' lnormppe `deprec' years, cluster(sic)
				if ("`lhv'"=="range" & "`deprec'"=="logai13") gen samp = e(sample)
				est sto `lhv'_`i'
				local i = `i' + 1	
			}
		}
		
		outreg2 [range_1 var_1] using "$resultDir\Table3\big_`base'.txt", replace lab

		log using "$resultDir\Table3\summary`base'.txt", t replace
		summ `vars' if samp, sep(0)
		log close
		restore
}
	
*** IV. Table 4
	use "$dataDir\bigfirm",clear
	set more off

	rename fyear year

	merge m:1 year using "$dataDir\gdp_deflate"
	drop _merge

	//get deflator base year
	summ gdp_def if year==2005
	local def05 = r(mean)							

	//Create firm value from outstanding shares and deflate value and sales to 2005 dollars
	gen liabilities = lt*`def05'/gdp_def
	gen firmvalue = prcc_f*csho*`def05'/gdp_def 	
	gen firmsales = revt*`def05'/gdp_def
	replace ppegt = ppegt*`def05'/gdp_def		
				

	//Normalize by Labor and find net firm value
	gen normppe = ppegt/firmsales
	gen normval = (firmvalue+lt)/firmsales

	//Get Maximum and minimum firm values
	bys gvkey: egen maxnormval = max(normval)
	bys gvkey: egen minnormval = min(normval)
	bys gvkey: egen sdnormval = sd(normval)


	//Create range of firm value
	gen normrange = maxnormval - minnormval

	//Create substrings of sic code to match base depreciation numbers (\lambda_{i}P_{iF}*/S_{F})
	gen sic3 = substr(sic,1,3)
	gen sic2 = substr(sic,1,2)

	foreach period in 1970,1979 1980,1989 1990,1999 2000,2008 {
		preserve
		keep if inrange(year,`period')

		//Collapse to means and counts, one observation per firm
		collapse (mean) sales = firmsales ppe = normppe normrange=normrange emp=emp lt=lt sdnormval= sdnormval (count) years = year, by(gvkey sic sic2 sic3)

		//Merge in industry-level depreciation numbers, match to firms at three significant digits
		gen sic4=sic
		replace sic=sic3
		merge m:1 sic using dep_index_sic3, keepusing(hw* bea) update	
		drop if _m==2
		drop _m
		
		//Merge in industry-level depreciation numbers, match to firms at two significant digits
		replace sic=sic2
		merge m:1 sic using dep_index_sic2, keepusing(hw* bea) update
		drop if _m==2
		drop _m

		//Create depreciation numbers at firm level
		gen ai13= hw1*sales				
		gen ai13r = hw2*sales
		gen ai13bea = bea*sales

		//Gen log variables
		gen logai13 = ln(ai13)
		gen logai13r = ln(ai13r)
		gen logai13bea = ln(ai13bea)
		gen lnormrange = ln(normrange)
		gen lnormvar = 2*ln(sdnormval)
		gen lnormppe = ln(ppe)
		
		//Labels
		lab var lnormppe "Log-Normalized PPE"
		lab var lnormrange "Log-Normalized Value Range"
		lab var lnormvar "Log-Normalized Value Variance"
		lab var sales "Average sales"
		lab var lt "Total Liabilities"
		lab var emp "Labor"

		local vars lt ai13 ai13r ai13bea ppe lnormppe lnormvar years sales emp lnormrange lnormvar

		local base=substr("`period'",1,4)
		
		*Create Table 4
		foreach lhv in range var {
			local i =1
			foreach deprec in logai13 logai13r logai13bea {
				reg lnorm`lhv' lnormppe `deprec' years, cluster(sic)
				if ("`lhv'"=="range" & "`deprec'"=="logai13") gen samp = e(sample)
				est sto `lhv'_`i'
				local i = `i' + 1	
			}
		}
		outreg2 [range_1 var_1] using "$resultDir\Table4\big_`base'_sales.txt", replace lab

		
		log using "$resultDir\Table4\summary`base'_sales.txt", t replace
		summ `vars' if samp, sep(0)
		log close
		restore
	}
	
*** V. Table 5: ln(range of L/mean(L))
	use "$tempDir\temp",clear
	*Get firm level observations
	collapse(max) maxemp=yr1_emp_tot (min) minemp=yr1_emp_tot (mean) mean_L=yr1_emp_tot mean_K=def_meancapexp ln* raw*, by(naics)
	for X in any hw1 hw2 bea:rename raw_X X //rename dep. rates to use for desc. statistics later
	
	*Generate range of employment
	gen range_L_norm=(maxemp/mean_L-minemp/mean_L)
	gen ln_range_L_norm=ln(range_L_norm)

	*Generate K measure
	gen ln_mean_K=ln(mean_K)

	*Create Table 5
	reg ln_range_L_norm ln_hw1
	outreg2 using "$resultDir\Table5",replace
	foreach X in ln_hw1 ln_hw2 ln_bea{
		reg ln_range_L_norm `X'  ln_mean_K,r //old K regression
		outreg2 using "$resultDir\Table5",append  dec(3)
	}
	
	*Get Descriptive Statistics for indepedent variables
	gen stats=e(sample)
	qui sum hw1 if stats,detail
	matrix define DescStats=(.,.,.)
	matrix define DescStats=(DescStats\r(mean),r(p50),r(sd)) //generate inital matrix
	
	foreach X in hw2 bea mean_K{
	qui sum `X' if stats,detail
		matrix define DescStats=(DescStats\r(mean),r(p50),r(sd))
	}
	
	*Get Descriptive Statistics for depedent variables
	matrix define DescStats=(DescStats\.,.,.)
	qui sum range_L_norm if stats,detail
	matrix define DescStats=(DescStats\r(mean),r(p50),r(sd))
	matrix rownames DescStats=IndepVars hw1 hw2 bea mean_K DepVars range_L_norm
	matrix colnames DescStats=Mean Median SD
	mat list DescStats

*** VI. Table 6: ln(range of firms)
	use "$tempDir\temp",clear
	*Get firm level observations
	sum yr1_emp_tot
	gen netentry_norm=netentry/r(mean)
	collapse (max) maxnetentry=netentry (min) minnetentry=netentry  (mean)ln* mean_K= def_meancapexp meanL=yr1_emp_tot,by(naics)

	*Generate range of firms
	gen maxmin=maxnetentry -minnetentry
	gen maxmin_Lnorm=maxmin/meanL
	gen ln_maxmin_Lnorm=ln(maxmin_Lnorm)

	*Generate K measure
	gen ln_mean_K=ln(mean_K)

	*Create Table 6
	reg ln_maxmin_Lnorm ln_hw1
	outreg2 using "$resultDir\Table6",replace
	foreach X in ln_hw1 ln_hw2 ln_bea{
		reg ln_maxmin_Lnorm `X'  ln_mean_K,r //old K regression
		outreg2 using "$resultDir\Table6",append dec(3)
	}
	
	*Get Descriptive Statistics for depedent variable
	gen stats=e(sample)
	qui sum maxmin_Lnorm if stats,detail
	matrix define DescStats=(DescStats\r(mean),r(p50),r(sd))
	mat rownames DescStats=IndepVars hw1 hw2 bea mean_K DepVars range_L_norm range_firms_norm
	mat list DescStats
	
*** VII. Table 7: ln(range of K/mean(K))
	use "$tempDir\temp",clear
	*Get firm level observations
	collapse (max) maxK=def_meancapexp (min) minK=def_meancapexp (mean) mean_K=def_meancapexp ln_*, by(naics)

	*Generate range of K
	gen range_K_norm=(maxK/mean_K-minK/mean_K)
	gen ln_range_K_norm=ln(range_K_norm)

	*Generate K measure
	gen ln_mean_K=ln(mean_K)

	*Create Table 7: LHS normed w/o years 
	reg ln_range_K_norm ln_hw1
	outreg2 using "$resultDir\Table7",replace
	foreach X in ln_hw1 ln_hw2 ln_bea{
		reg ln_range_K_norm `X'  ln_mean_K,r //old K regression
		outreg2 using "$resultDir\Table7",append dec(3)
	}
	
	*Get Descriptive Statistics for depedent variable
	gen stats=e(sample)
	qui sum range_K_norm if stats,detail
	matrix define DescStats=(DescStats\r(mean),r(p50),r(sd))
	mat rownames DescStats=IndepVars hw1 hw2 bea mean_K DepVars range_L_norm range_firms_norm range_K_norm
	mat list DescStats
	
	do "$mainDir\mat2txt.do" //load matrix-> txt conversion if not alread loaded
	
***	VIII. Table 8: Descriptive Statistics
	mat2txt, matrix(DescStats) saving("$resultDir\DescStats") title(Table 8. Descriptive Statistics) replace  //Put the Desc. Statistics into a .txt file
