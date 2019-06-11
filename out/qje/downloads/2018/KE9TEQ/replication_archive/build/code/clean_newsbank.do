/**************************************************************************
	
	Program: clean_newsbank.do
	Last Update: January 2018
	JS/DT

	
**************************************************************************/

	global search_terms "obama biden mccain palin election president campaign"
	
	* DMA xwalk with non-missing values
	use dma_name newsbank_dma using "$data/xwalk/dma_map", clear
	keep if !missing(newsbank_dma)
	tempfile dma_map_xwalk_newsbank
	save `dma_map_xwalk_newsbank', replace

	* Import terms data
	use "$input/newsbank/terms.dta", clear

	gen distributor = substr(channel,-4,.)	
	gen stata_date = DMY
	format stata_date %td
	gen halfhour = floor(min/30)
	gen dow = dow(stata_date)
	gen weekend = inlist(dow,0,6)

	collapse (sum) num_words *_count, by(distributor channel market stata_date hour halfhour weekend)

	* Identify distributors included in Nielsen data

	merge m:1 distributor stata_date hour halfhour using "$data/nielsen/nielsen_ratings2008_30m", keep(1 3) keepusing(tv_pp_all_2_plus tv_nads_30m) gen(_merge_nielsen)
	rename market newsbank_dma
	merge m:1 newsbank_dma using `dma_map_xwalk_newsbank', keep(3) nogenerate
	merge m:1 dma_name using "$data/nielsen/2008/nielsen_data.dta", keep(3) keepusing(market_viewers_a2_p) nogenerate 

	* Calculate GRPs and impute values for missing ads
	gen imps_newsbank      = tv_pp_all_2_plus / tv_nads_30m
	gen grp_newsbank       = imps_newsbank / (market_viewers_a2_p*10) 
	egen grp_newsbank_mean = mean(grp_newsbank), by(distributor weekend hour)
	replace grp_newsbank   = grp_newsbank_mean if missing(imps_newsbank)    

	replace channel = strupper(channel)
	replace channel = strtrim(channel)
	gen network=5
	replace network = 1 if substr(channel,1,3) == "ABC"
	replace network = 2 if substr(channel,1,3) == "CBS"
	replace network = 3 if substr(channel,1,3) == "NBC"
	replace network = 4 if substr(channel,1,3) == "FOX"

	gen all_terms_freq  = 0
	gen all_terms_count = 0

	
	foreach term in $search_terms {
	
		gen `term'_freq = (`term'_count / num_words)* grp_newsbank
		replace `term'_count   = `term'_count * grp_newsbank

		replace all_terms_freq  = all_terms_freq  + `term'_freq
		replace all_terms_count = all_terms_count + `term'_count

	}
   
	foreach term in all_terms {

		areg `term'_freq i.network i.halfhour i.stata_date, absorb(dma_name)
		predict news_`term'_freq_fe, d
		
		areg `term'_count i.network i.halfhour i.stata_date, absorb(dma_name)
		predict news_`term'_count_fe, d
	
	}
	
	collapse (mean) news_*_fe, by(dma_name) 
	gen year = 2008

	rename news_all_terms_freq_fe news_ptya_freq
	rename news_all_terms_count_fe news_ptya_count

	keep dma_name year news_ptya_freq news_ptya_count

	compress

	save "$data/news_measures", replace
 
**************************************************************************

* END OF FILE	
	

