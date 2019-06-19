/*
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
*/


	version 12

	project, doinfo
	local pdir "`r(pdir)'"							// the project's main dir.
	local dofile "`r(dofile)'"						// do-file's stub name
	local sig {bind:{hi:[RP : `dofile'.do]}}		// a signature in notes
	
	
* The original data used in this project were prepared in a separate project
* to protect the provenance and confidentiality of the source. Make the
* read me file part of the project

	project, relies_on("from_other_project/_READ_ME.txt")
	

* The datasets are original data for the purpose of this project

	project, original("from_other_project/operational.dta")
	project, original("from_other_project/hotel_level.dta")
	project, original("from_other_project/market.dta")
	
	
* The market data include a monthly tourism variable stored in
* wide format. Convert the market data from wide to long 

	use "from_other_project/market.dta"
	reshape long m_tour, i(market_id) j(month)
	label var m_tour "Tourism Intensity - monthly"
	tempfile market
	qui save "`market'"
	

* Combine monthly operational data with hotel level data

	use "from_other_project/operational.dta"
	merge m:1 hotel_id using "from_other_project/hotel_level.dta", ///
		assert(match) nogen
		

* Combine with market variables (reshaped to long format for monthly
* tourism data)

	merge m:1 market_id month using "`market'", keep(master match) nogen
	
	
* Convert to monthly dates

	gen monthdate = ym(year,month)
	format %tm monthdate
	label var monthdate "Monthly Date" 
	sum monthdate, format
	

* The initial number of hotels

	countby hotel_id	// see ado project directory
		
	
* Proportion of other hotels franchised in market

	gen franchised = orgform == "Franchised":orgform if !mi(orgform)
	label var franchised "Hotel is Franchised"
	drop if mi(franchised)
	
	sort market_id monthdate
	by market_id monthdate: gen Nobs = _N
	by market_id monthdate: egen Nfran = total(franchised) 
	
	gen propofran = cond(franchised, Nfran - 1, Nfran) / Nobs
	label var propofran "Proportion of other hotels franchised"
	drop Nfran Nobs
	
	
* Hotel Density

	bys hotel_id (monthdate): gen hotel1 = _n == 1
	bys market_id: egen density = total(hotel1)
	label var density "Own Hotels in Market in Period"
	drop hotel1
	

* Drop brand with no change in organizational form

	bys brand_id (franchised): drop if franchised[1] == franchised[_N]
	
	
* Declare data to be panel and lag variables
                 
	tsset hotel_id monthdate 
	
	gen Loccrate = L.occrate
	label var Loccrate "Lag of occrate"
	gen Lroomprice = L.roomprice
	label var Lroomprice "Lag of roomprice"


* Hotel age
	
	gen age = year - openyear + 1
	label var age "Age of Hotel"
	
	
* Calculate -revpar- and drop if missing

	gen revpar = occrate * roomprice
	label var revpar "RevPar"
	
	replace revpar = revpar / 100	// rescale for tables
	drop if mi(revpar)
	
	
* The number of hotels in our sample

	countby hotel_id	// see ado project directory

	
* Clean up and save
	
	label data "Operational combined with hotel and market data"
	
	isid hotel_id year month, sort
		
	save "`dofile'.dta", replace
	des
	project, creates("`dofile'.dta")
