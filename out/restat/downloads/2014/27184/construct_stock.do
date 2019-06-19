******do file to construct training as a stock variable*****


****General idea
****Stock_t = (1-d)*stock_t-1 + flow_t
****where d equals the depreciation rate
****d can be firm specific or just equal to a fixed depreciation rate, the same for all firms 



use masterfile.dta
***********************************************************************************************

****discount factor = (1-d1)*(1-outshare_it)
tsset mark year
gen double outshare = outfte/(l.endemplfte+infte)

replace outshare = 1 if outshare > 1 & outshare ~= . 	

local disc 25 30 35 40 45 50		//different arbitrary depreciation rates
foreach d of local disc {
	gen discount`d' = (1-(`d'/100)) *(1-outshare)
	}
***********************************************************************************************

************************************************************************************************
****cleaning****
gen trainlshare = trainl/(avemplfull + avemplpart)
gen traincshare = trainc/staffcostfte
gen trainhshare = trainh / hoursfte
gen traincav = trainc/avemplfte
drop if traincav > 10 & traincav ~= . 		
drop if trainlshare > 2 & trainlshare ~= .
drop if traincshare > 1 & traincshare ~= .
drop if trainhshare > 1 & trainhshare ~= .
************************************************************************************************

************************************************************************************************
**computing training stock
************************************************************************************************


sort idnumber year
keep mark idnumber train*  avemplfte-traincav year
//making dataset smaller


fillin idnumber year
drop mark
replace trainl = 0 if trainl == .	
					// make sure that every firm gets a stock value of zero training  
					// before entry; otherwise it would have a missing value
replace trainh = 0 if trainh == .
replace trainc = 0 if trainc == .

****************************
*counting gaps in dataset
****************************
	egen mark = group(idnumber)
	tsset mark year
	gen begin = 1 if avemplfte == . & l.avemplfte ~= .
	gen end = 1 if avemplfte == . & f.avemplfte ~= .
	bysort idnumber: gen gap = sum(begin) if avemplfte == .
	// can be multiple gaps
	
	gen year1 = year if gap == 1
	gen year2 = year if gap == 2
	gen year3 = year if gap == 3
	gen year4 = year if gap == 4

	egen first1 = first(year1), by(idnumber)
		//first year of the block of missings
	egen last1 = lastnm(year1), by(idnumber)
		//last year of the block of missings
	gen ind1 = 1 if year == last1 & end == 1
		//indicate blocks missing data that "end"
	bysort idnumber : egen temp = mean(ind1)
	replace ind1 = temp if gap == 1
	drop temp

	egen first2 = first(year2), by(idnumber)
	egen last2 = lastnm(year2), by(idnumber)
		//defining blocks of missing data
	gen ind2 = 1 if year == last2 & end == 1
		//indicate blocks missing data that "end"
	bysort idnumber : egen temp = mean(ind2)
	replace ind2 = temp if gap == 2
	drop temp

	egen first3 = first(year3), by(idnumber)
	egen last3 = lastnm(year3), by(idnumber)
		//defining blocks of missing data
	gen ind3 = 1 if year == last3 & end == 1
		//indicate blocks missing data that "end"
	bysort idnumber : egen temp = mean(ind3)
	replace ind3 = temp if gap == 1
	drop temp

	egen first4 = first(year4), by(idnumber)
	egen last4 = lastnm(year4), by(idnumber)
		//defining blocks of missing data
	gen ind4 = 1 if year == last4 & end == 1
		//indicate blocks missing data that "end"
	bysort idnumber : egen temp = mean(ind4)
	replace ind4 = temp if gap == 1
	drop temp

	gen indgap = ind1 
	replace indgap = ind2 if indgap == .
	replace indgap = ind3 if indgap == .
	replace indgap = ind4 if indgap == .
		//final indicator for gaps
	gen firstgapyear = first1 
	replace firstgapyear = first2 if firstgapyear ==.
	replace firstgapyear = first3 if firstgapyear ==.
	replace firstgapyear = first4 if firstgapyear ==.
		//final indicator for first year of a gap
	gen lastgapyear = last1
	replace lastgapyear = last2 if lastgapyear ==.
	replace lastgapyear = last3 if lastgapyear ==.
	replace lastgapyear = last4 if lastgapyear ==.

	drop ind1 ind2 ind3 ind4 first1-first4 last1-last4 year1-year4

*****************************************************


*put discount rate equal to zero if employment is zero

local disc 25 30 35 40 45 50
foreach d of local disc {
	replace discount`d' = 0 if avemplfte == 0
}



**************************************************
***COMPUTE STOCK VALUES
***************************************************

drop endemplmfte-endemplothfte
compress
	//to save memory
	
	*First: just value of the flow in the entering year

		gen tempyear = year if avemplfte ~= .
		sort idnumber year
		bysort idnumber: egen enter = first(tempyear)
			// displays the first year the firm enters the dataset

		
		gen t_trainl = trainl
		replace t_trainl = . if avemplfte == .
		gen t_trainh = trainh
		replace t_trainh = . if avemplfte == .
		gen t_trainc = trainc
		replace t_trainc = . if avemplfte == .
		bysort idnumber: ipolate t_trainl year, gen(_trainl)
		bysort idnumber: ipolate t_trainh year, gen(_trainh)
		bysort idnumber: ipolate t_trainc year, gen(_trainc)
			//these values can be used to compute the stock
	
	
		local disc 25 40 50
		foreach d of local disc {	

			bysort idnumber: ipolate discount`d' year, gen(_discount`d')
	}
	
		******************************************
		*Computing value for first year in dataset
		******************************************
			tsset mark year
			destring incorpyear, replace
			gen temp = enter - incorpyear
			gen flagincorp = 1 if temp > 3 
			replace flagincorp = 0 if temp <= 3
				// if firm was incorporated more than three years before entry, we use flow/d_it as the stock
				// if only recently being incorporated, we use the flow as the stock for the first year
			drop temp
			gen stockl_temp = (_trainl + f._trainl + f2._trainl)/3   /*
				*/ if year == enter
			replace stockl_temp = (_trainl + f._trainl)/2 /* 
				*/ if year == enter & (f2._trainl == . & f._trainl ~=.)
			replace stockl_temp = (_trainl) /* 
				*/ if year == enter & f._trainl == .& f2._trainl == .
				
			gen stockh_temp = (_trainh + f._trainh + f2._trainh)/3 if year == enter
			replace stockh_temp = (_trainh + f._trainh)/2 if year == enter & (f2._trainh == . & f._trainh~=.)
			replace stockh_temp = _trainh if year == enter & f._trainh==. & f2._trainh ==. 

			
			local disc 25 40 50
			foreach d of local disc {	
				
				*first option: initial value is the flow of the year of entry
					gen stockl`d' = trainl if year == enter
					gen stockh`d' = trainh if year == enter
			
				*second option: initial value computed according perpetual inventory method
					*initial stock = F_i0/d_i1
					gen stockl`d'pim = trainl/(1-f._discount`d') if year == enter & flagincorp == 1 
					replace stockl`d'pim = trainl/(`d'/100) if year == enter & flagincorp == 1 & f._discount`d' == .
					replace stockl`d'pim = trainl if year == enter & flagincorp == 0
				
					gen stockh`d'pim = trainh/(1-f._discount`d') if year == enter & flagincorp == 1
					replace stockh`d'pim = trainh/(`d'/100) if year == enter & flagincorp == 1 & f._discount`d' == .
					replace stockh`d'pim = trainh if year == enter & flagincorp == 0
						//initial stock is flow_it/d_it, but d_it not reported in the entering year as 
						// we need lagged employment to compute it
				
					*d_i0 = average(d_i1, d_i2); flow_i0 = average(flow_i0, flow_i1, flow_i2)
					tsset mark year
					gen discount`d'_temp = (f._discount`d' + f2._discount`d')/2 /* 
						*/ if year == enter & (f._discount`d' ~=. & f2._discount`d' ~= .)
					replace discount`d'_temp = (f._discount`d') /* 
						*/ if year == enter & (f2._discount`d' == . & f._discount`d' ~= .)
					replace discount`d'_temp = (f2._discount`d') /*
						*/ if year == enter & (f2._discount`d'~= . & f._discount`d' ==. )
					replace discount`d'_temp = (`d'/100) if f._discount`d' == . & f2._discount`d' ==. & year == enter
						//in principle in year of entry no discount rate observed as outshare was needed to compute it
						// For some firms still discount rate reported because of the cleaning in the beginning
						// (unreasonable high training values were dropped, but could compute discount rate
						// as still lagged employment was reported and thus outshare as well). 
						// Anyway, does not really matter)
				
					gen stockh`d'pim2 = stockh_temp/(1-discount`d'_temp)  if year == enter & flagincorp == 1
					replace stockh`d'pim2 = trainh if year == enter & flagincorp == 0
					gen stockl`d'pim2 = stockl_temp/(1-discount`d'_temp) if year == enter & flagincorp == 1
					replace stockl`d'pim2 = trainl if year == enter & flagincorp == 0
						//initial stock is flow_it/d_it; flow_it and d_it computed as the average over the first 3 years
				
				drop discount`d'_temp
			}
		
			drop stockl_temp stockh_temp 
			drop t_trainl t_trainh t_trainc
	
		******************************************
		*COMPUTING VALUES FOR THE OTHER YEARS
		******************************************
		
			local disc 25 40 50
			foreach d of local disc {
				tsset mark year	
				replace _discount`d' = (1-(`d'/100)) if outshare == . & year ~= enter & _discount`d' == .
				
				replace stockl`d' = _discount`d'*l.stockl`d' + _trainl if year ~= enter
									//stock_it = (1-d_it)*stock_it-1 + flow_it
									//except for the year of entry

				replace stockl`d'pim = _discount`d'*l.stockl`d'pim + _trainl if year ~= enter
				
				replace stockl`d'pim2 = _discount`d'*l.stockl`d'pim2 + _trainl if year ~= enter
				
				replace stockh`d' = _discount`d'*l.stockh`d' + _trainh if year ~= enter
					//computing average training hours stock per employee
				
				replace stockh`d'pim = _discount`d'*l.stockh`d'pim + _trainh if year ~= enter
				
				replace stockh`d'pim2 = _discount`d'*l.stockh`d'pim2 + _trainh if year ~= enter
			}

**********************************************************************************************************


*******************************
*CONSTRUCTING THE SHARES
*******************************


	drop if avemplfte ==. 
	drop if avemplfte == 0

	local disc 25 40 50
	foreach d of local disc {
		gen stockl`d'share = stockl`d'/avemplfte
		gen stockl`d'pimshare = stockl`d'pim/avemplfte
		gen stockl`d'pim2share = stockl`d'pim2/avemplfte
		gen stockh`d'perl = stockh`d'/avemplfte	
		gen stockh`d'pimperl = stockh`d'pim/avemplfte
		gen stockh`d'pim2perl = stockh`d'pim2/avemplfte
	}

	gen trainhperl = trainh/avemplfte

*****************************
*SOME CLEANING
*****************************

	gen flagh = 1 if stockh25perl > 150 & stockh25perl ~= .
	replace flagh = 1 if stockh25pimperl > 150 & stockh25pimperl ~= .
	replace flagh = 1 if stockh25pim2perl > 150 & stockh25pim2perl ~= .

	gen flagl = 1 if stockl25share > 4 & stockl25share ~= .
	replace flagl = 1 if stockl25pimshare > 4 & stockl25share ~= .
	replace flagl = 1 if stockl25pim2share > 4 & stockl25share ~= .


	gen wage = staffcostfte/avemplfte
	drop if wage > 107
	drop if wage < 5
	
	sort idnumber year
	save trainingstock_tomerge


	***************************************
	*For Table D.1. in the appendix
	*************************************
	gen dep25 = 1 - discount25
	gen dep40 = 1 - discount40
	gen dep50 = 1 - discount50
	
	tabstat dep*, stats(mean sd)
	tabstat stockl25pimshare stockl40pimshare stockl50pimshare trainlshare if flagl ~= 1 , stats(mean sd)
	tabstat stockl25pimshare stockl40pimshare stockl50pimshare trainlshare /*
		*/ if flagl ~= 1 & stockl25pimshare > 0, stats(mean sd)
	tabstat stockh25pimperl stockh40pimperl stockh50pimperl trainhperl if flagh ~= 1 , stats(mean sd)
	tabstat stockh25pimperl stockh40pimperl stockh50pimperl trainhperl /* 
		*/ if flagh ~= 1 & stockh25pimperl > 0, stats(mean sd)

	***************************************
	*FOR GRAPHS
	***************************************

	bysort year: egen totempl_h = sum(avemplfte) if flagh ~= 1
	bysort year: egen totempl_l = sum(avemplfte) if flagl ~= 1

	*Generating average values for the different stock indicators
	local disc 25 40 50
	foreach d of local disc {

		bysort year: egen mposstockh`d'perl = mean(stockh`d'perl) if flagh ~= 1 & stockh`d'perl > 0
		bysort year: egen mposstockl`d'share = mean(stockl`d'share) if flagl ~= 1 & stockl`d'share > 0
		
		bysort year: egen mposstockh`d'pimperl = mean(stockh`d'pimperl) if flagh ~= 1 & stockh`d'pimperl > 0
		bysort year: egen mposstockl`d'pimshare = mean(stockl`d'pimshare) if flagl ~= 1 & stockl`d'pimshare > 0

		bysort year: egen mposstockh`d'pim2perl = mean(stockh`d'pim2perl) if flagh ~= 1 & stockh`d'pim2perl > 0
		bysort year: egen mposstockl`d'pim2share = mean(stockl`d'pim2share) if flagl ~= 1 & stockl`d'pim2share > 0
		
		bysort year: egen mstockh`d'perl = mean(stockh`d'perl) if flagh ~= 1 
		bysort year: egen mstockl`d'share = mean(stockl`d'share) if flagl ~= 1 
		
		bysort year: egen mstockh`d'pimperl = mean(stockh`d'pimperl) if flagh ~= 1 
		bysort year: egen mstockl`d'pimshare = mean(stockl`d'pimshare) if flagl ~= 1 

		bysort year: egen mstockh`d'pim2perl = mean(stockh`d'pim2perl) if flagh ~= 1 
		bysort year: egen mstockl`d'pim2share = mean(stockl`d'pim2share) if flagl ~= 1 

	}


	bysort year: egen mtrainlshare = mean(trainlshare) if flagl~=1
	bysort year: egen mtrainhperl = mean(trainhperl) if flagh~=1

	bysort year: egen mpostrainlshare = mean(trainlshare) if flagl~=1 & trainlshare > 0
	bysort year: egen mpostrainhperl = mean(trainhperl) if flagh~=1 & trainhshare > 0

	***************************************************************************************************

	****************************************************************************************************
	***destroys dataset to make graphs

	collapse tot* mpos* mstock* mtrain*, by(year)


	*graph D.1. of Appendix
	twoway (connected mstockh25pimperl year) /* 
		*/ (connected mstockh40pimperl year, msymbol(T)) /*
		*/ (connected mstockh50pimperl year, msymbol(S)) /*
		*/ (connected mtrainhperl year) /*
		*/, graphregion(fcolor(white)) title("Average Stock Training Hours") /*
		*/ subtitle("Initial value = Flow/Depreciation") ytitle("Training Hours per Worker") /*
		*/ legend(order(1 "25% Depreciation" 2 "40% Depreciation" 3 "50% Depreciation" 4 "Flow") size(small) col(3))
	
	*graph D.2. of Appendix
	twoway (connected mstockl25pimshare year) /*
		*/ (connected mstockl40pimshare year, msymbol(T)) /*
		*/ (connected mstockl50pimshare year, msymbol(S)) /*
		*/ (connected mtrainlshare year), graphregion(fcolor(white)) /* 
		*/ title("Average Stock Trained Workers") subtitle("Initial value = Flow/Depreciation") /*
		*/ ytitle("Share of Trained Workers") /*
		*/ legend(order(1 "25% Depreciation" 2 "40% Depreciation" 3 "50% Depreciation" 4 "Flow") size(small))	


	***************************************************************************************************


