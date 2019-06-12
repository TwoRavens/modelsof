global root "D:\Dropbox\unequal_gains\QJE revision plan\analysis\CEX"

forvalues year = 2015(-1)2004 { 

	local filetype = "int"
	import excel "$root/Raw/CEX/Codebook/csxintstub`year'.xlsx", clear
	rename (A-G) (primaryline level uccname ucc survey multfactor uccgroup) // primaryline = 2 if it's th second line of the title
	cap replace primaryline = "1" if primaryline == "*"
	cap replace level = "" if level == "*"
	destring primaryline level, replace

	gen stubline = _n

	keep if primaryline==1
	drop primaryline

	// Big categories (15 within EXPEND)
	gen category = uccname if level==2
	replace category = category[_n-1] if mi(category)
	replace category = "" if uccgroup=="CUCHARS"

	gen lettergroup = ucc if mi(real(ucc)) & !mi(real(ucc[_n+1])) // it's the smallest group if it's followed by a numeric ucc
	replace lettergroup = lettergroup[_n-1] if !mi(real(ucc))
	replace lettergroup = "" if uccgroup=="CUCHARS"
	gen lettergroupname = uccname if mi(real(ucc)) & !mi(real(ucc[_n+1])) // it's the smallest group if it's followed by a numeric ucc
	replace lettergroupname = lettergroupname[_n-1] if !mi(real(ucc))
	replace lettergroupname = "" if uccgroup=="CUCHARS"

	replace ucc = "0"*(6-length(ucc)) + ucc if length(ucc)>0 & length(ucc)<6 & !mi(real(ucc))

	replace uccgroup = "EXPEND" if uccgroup=="FOOD" // no need to distinguish

	replace uccgroup  = "IMPUTEDRENTS" if inlist(ucc,"910050","910100","910101","910102","910103") // estimated rental value of homes
	replace category  = "Imputed rents" if uccgroup=="IMPUTEDRENTS"

	replace uccgroup  = "MORTGAGE" if (inlist(ucc, "830101", "830201", "830203", "880120", "830102", "830202", "830204", "880320") | /// mortgage principal reduction, from ASSETS (includes "Special lump sum")
		inlist(ucc, "790910", "790920", "790940", "880220"))  & category=="Net change in total liabilities"
	replace category  = "Mortgage principal" if uccgroup=="MORTGAGE"

	save "$root/Processed/CEX/Codebook/csxintstub`year'_with_groups", replace

	keep if !mi(real(ucc))
	gen consumption = uccgroup=="EXPEND" | uccgroup  == "IMPUTEDRENTS" // dropping assets & income & cuchars. ImputedRents is debated.
	*gen consumption = uccgroup=="EXPEND" | uccgroup  == "MORTGAGE" // 
	gsort ucc survey -consumption
	by ucc survey : keep if _n==1 | consumption==1 // if repeated, keep the best one
	isid ucc survey
	
	if `year'>2010  {  // use 2015 version
	gen uccclass = ""
		replace uccclass = "Food at home" if inrange(stubline,51,197)
		replace uccclass = "Food away" if inrange(stubline,198,238) // exclude meals as pay
		replace uccclass = "Alcohol" if inrange(stubline,239,271)
		replace uccclass = "Owned dwelling" if inrange(stubline,274,312) | inrange(stubline,1099,1104) // include imputed rents
		replace uccclass = "Rented dwelling" if inrange(stubline,313,375) //
		replace uccclass = "Utilities" if inrange(stubline,376,423)
		replace uccclass = "Domestic services and childcare" if inrange(stubline,425,455)
		replace uccclass = "Housekeeping supplies" if inrange(stubline,456,467)
		replace uccclass = "Furnishings and equipment" if inrange(stubline,468,541)
		replace uccclass = "Apparel" if inrange(stubline,543,600)
		replace uccclass = "Footwear" if inrange(stubline,601,605)
		replace uccclass = "Other apparel" if inrange(stubline,606,618)
		replace uccclass = "Transportation" if inrange(stubline,619,693)
		replace uccclass = "Healthcare" if inrange(stubline,694,734)
		replace uccclass = "Entertainment, reading" if inrange(stubline,735,832) | inrange(stubline,847,854)
		replace uccclass = "Personal care" if inrange(stubline,833,846)
		replace uccclass = "Education" if inrange(stubline,855,870)
		replace uccclass = "Smoking" if inrange(stubline,871,875)
		replace uccclass = "Misc" if inrange(stubline,876,895)
		replace uccclass = "Cash contributions" if inrange(stubline,896,905)
		replace uccclass = "Personal insurance" if inrange(stubline,906,915)
	}

	if `year'<2011 {  // use 2008 version
		gen uccclass = ""
		replace uccclass = "Food at home" if inrange(stubline,51,198)
		replace uccclass = "Food away from home" if inrange(stubline,199,238) // exclude meals as pay
		replace uccclass = "Alcohol" if inrange(stubline,240,272)
		replace uccclass = "Owned dwelling" if inrange(stubline,275,316) | inrange(stubline,344,380) | inrange(stubline,1163,1170) // include vac.homes and imputed rents
		replace uccclass = "Rented dwelling" if inrange(stubline,317,343) | inrange(stubline,381,382) // include trips & at school
		replace uccclass = "Utilities" if inrange(stubline,382,430)
		replace uccclass = "Domestic services and childcare" if inrange(stubline,431,464)
		replace uccclass = "Housekeeping supplies" if inrange(stubline,465,475)
		replace uccclass = "Furnishings and equipment" if inrange(stubline,476,566)
		replace uccclass = "Apparel" if inrange(stubline,567,633)
		replace uccclass = "Footwear" if inrange(stubline,634,638)
		replace uccclass = "Other apparel" if inrange(stubline,639,651)
		replace uccclass = "Transportation" if inrange(stubline,652,740)
		replace uccclass = "Healthcare" if inrange(stubline,741,782)
		replace uccclass = "Entertainment, reading" if inrange(stubline,783,880) | inrange(stubline,895,901)
		replace uccclass = "Personal care" if inrange(stubline,881,894)
		replace uccclass = "Education" if inrange(stubline,902,915)
		replace uccclass = "Smoking" if inrange(stubline,916,920)
		replace uccclass = "Miscellaneous" if inrange(stubline,921,939)
		replace uccclass = "Cash contributions" if inrange(stubline,940,949)
		replace uccclass = "Personal insurance" if inrange(stubline,950,959)
		
		gen uccclass2 = uccclass // a bit closer to Aguiar-Bils, still not quite
		replace uccclass2 = "Shoes and other apparel" if uccclass=="Footwear" | uccclass=="Other apparel"
		replace uccclass2 = "Housing" if uccclass=="Owned dwelling" | uccclass=="Rented dwelling"
		replace uccclass2 = "Health and insurance" if uccclass=="Healthcare" | uccclass=="Personal insurance"
	}
	
	save "$root/Processed/CEX/Codebook/csxintstub`year'", replace
}

