/**************************************************************************
	
	Program: combine_data.do
	Last Update: February 2018
	JS/DT
	
	This file combines all data and creates data sets used in analysis. 
	
**************************************************************************/

	args year

/**************************************************************************

	1. Merge data

**************************************************************************/

	use if year == `year' using "$data/census.dta", clear
	
	merge 1:1 state county using "$data/`year'/pres_votes.dta", assert(2 3) keep(3) nogenerate
	
	merge 1:1 state county using "$data/`year'/congressional_districts.dta", assert(2 3) keep(3) keepusing(cd_*) nogenerate
	
	* Geolytics includes 2004 and 2008 educational values
	if inlist(`year',2004,2008) {
	
		merge 1:1 year state county using "$data/geolytics.dta", keep(1 3 4) assert(1 2 3 4) update 
		assert _merge != 1 if inlist(year,2004,2008)
		drop _merge

	}
	
	merge 1:1 state county using "$data/`year'/employment.dta", assert(2 3) keep(3) nogenerate  
		
	merge m:1 state county using "$data/`year'/factiva_newspaper_coverage.dta", keep(1 3) nogenerate
	
	merge m:1 year state county using "$data/newspapers.dta", keep(1 3) nogenerate
	
	merge 1:1 year state county using "$data/depvars_lag.dta", keep(1 3) nogenerate
	
	merge m:1 state county using "$data/segment.dta", assert(2 3) keep(3) nogenerate 
	
	merge m:1 state county using "$data/distances.dta", assert(2 3) keep(3) nogenerate 
	
	* Create DMA-county-level data 
	joinby state county using "$data/xwalk/dma_county_map.dta"
	
	merge m:1 year dma_name using "$data/news_measures.dta", keep(1 3) nogenerate
	
	merge m:1 dma_name using "$data/`year'/advertisements.dta", generate(sample_cmag)  
	
	assert inlist(sample_cmag,1,3) 
	
	keep if year == `year'
	
	merge m:1 dma_code using "$data/`year'/candidate_visits.dta", keepusing(cand_visits cand_visits_dem cand_visits_rep cand_visits_ptydf) assert(1 3) nogenerate
	
	recode sample_cmag (3=1) (1=0)
	
	recode cmag_* *_visits* (.=0)

/**************************************************************************

	2. Create variables

**************************************************************************/

	* Assign state-level average to missing values
	by state year, sort: egen dummy_state = mean(newspaper_slant)
	by year, sort: egen dummy_national = mean(newspaper_slant)
	gen newspaper_slant_missing = missing(newspaper_slant)
	replace newspaper_slant = dummy_state if missing(newspaper_slant) 
	replace newspaper_slant = dummy_national if missing(newspaper_slant) 
	drop dummy_state dummy_national

	* Factiva
	by state year, sort: egen dummy_state = mean(document_count)
	by year, sort: egen dummy_national = mean(document_count)
	gen document_count_missing = missing(document_count)
	replace document_count = dummy_state if missing(document_count) 
	replace document_count = dummy_national if missing(document_count) 
	drop dummy_state dummy_national
	
	* Voting population
	gen tot_pop_vote = max(tot_pop_adult, votes_dem + votes_rep)

	* Create variables for whether the DMA crosses battleground and/or non-battleground states
	egen dma_battleground = max(battleground), by(dma_name year)
	egen dma_nonbattleground = min(battleground), by(dma_name year)
	recode dma_nonbattleground (0=1) (1=0)
	gen dma_crossbattleground = (dma_battleground & dma_nonbattleground)

	* Create DMA population
	foreach type in adult all {
		egen market_pop_`type' = total(tot_pop_`type'), by(year dma_name)
	}

	egen market_female_adult = total(tot_female_adult), by(year dma_name)
	egen market_male_adult = total(tot_male_adult), by(year dma_name)
	egen market_vote_pop = total(tot_pop_adult), by(year dma_name)  
	egen market_state_pop = total(tot_pop_adult), by(year dma_name dma_code state)
	egen market_state_vote_pop = total(tot_pop_vote), by(year dma_name dma_code state)
	gen pct_market_pop = tot_pop_adult/market_pop_adult

	* Population share in battleground/non-battleground states
	gen tot_pop_all_battleground = tot_pop_all*battleground
	egen market_pop_all_battleground = total(tot_pop_all_battleground), by(year dma_name)
	gen battleground_pop_share = market_pop_all_battleground/market_pop_all
	
	* Create per capita measure of advertising
	foreach type in prez oth {
		foreach party in ptya ptyd dem rep {
		
			replace cmag_`type'_`party'_base = cmag_`type'_`party'_base/market_pop_adult  
			replace cmag_`type'_`party'_2plus = cmag_`type'_`party'_2plus/market_pop_all
			replace cmag_`type'_`party'_pro = cmag_`type'_`party'_pro/market_pop_adult
			replace cmag_`type'_`party'_neg = cmag_`type'_`party'_neg/market_pop_adult
			replace cmag_`type'_`party'_180days = cmag_`type'_`party'_180days/market_pop_adult
			replace cmag_`type'_`party'_120days = cmag_`type'_`party'_120days/market_pop_adult
			replace cmag_`type'_`party'_30days = cmag_`type'_`party'_30days/market_pop_adult
			replace cmag_`type'_`party'_natl = cmag_`type'_`party'_natl/market_pop_adult
		
		}
	}

	egen n_markets = total(1), by(year state county)
	gen mktwt = 1/n_markets
	egen tag_state = tag(state year dma_name)
	egen rank_state = rank(tag_state) if tag_state, by(year dma_name dma_code) unique
	egen n_states = max(rank_state), by(year dma_name)
	drop tag_state rank_state
	
/**************************************************************************

	2. Label variables

**************************************************************************/
		
	label variable sample_cmag "Year-Market Included in CMAG"
	
	label variable tot_pop_vote "Appx Voting Population (Ages 18+, adjusted so turnout <= 100%)" 
	label variable tot_pop_adult "Adult Population (Ages 18+)" 
	
	label variable npoverty "Total Number of People in Poverty"
	
	label variable pop_share_white "Percentage White (includes hispanic)"
	label variable pop_share_asian "Percentage Asian (includes hispanic)"
	label variable pop_share_black "Percentage Black (includes hispanic)"
	label variable pop_share_hispanic "Percentage Hispanic (includes all races)"
	label variable pop_share_minority "Percentage Non-White"
	label variable pop_share_other "Percentage Non-Hispanic, Non-White, Non-Black"
	
	label variable edu_dropout "Percentage with less than HS degree (25+ yo)"
	label variable edu_hsplus "Percentage with at least HS degree (25+ yo)"
	label variable edu_colplus "Percentage with less than college degree (25+ yo)"
	
	label variable income "Median Household Income"
	label variable pop10 "Population (SAIPE Data)"
	label variable aland_sqmi "Total Land Area (Sq Miles)"
	label variable intptlat "Latitude"
	label variable intptlong "Longitude"
	label variable density "Population Density"
	label variable pct_poverty "Percentage of all people in poverty"
	
	label variable votes_dem "Number of Democratic Votes (US Pres Election)"
	label variable votes_rep "Number of Republican Votes (US Pres Election)"
	label variable votes_total "Number of Total Votes (US Pres Election)"
	
	label variable market_viewers "Market Viewers"
	label variable market_vote_pop "Market Voting Population"
	label variable market_state_pop "Market-State Population"
	label variable market_state_vote_pop "Market-State Voting Population"
	label variable pct_market_pop "Share of Market Population"
	
	label variable n_markets "Number of Markets"
	label variable mktwt "1 / Number of Markets"
	label variable n_states "Number of States in Market"
	
	label variable cand_visits "All Candidate Visits (Pres + VP)"
	label variable cand_visits_rep "Republican Candidate Visits (Pres + VP)"
	label variable cand_visits_dem "Democratic Candidate Visits (Pres + VP)"
	label variable cand_visits_ptydf "Democratic minus Republican Candidate Visits (Pres + VP)"
	
/**************************************************************************

	3. Create county-level data 

**************************************************************************/

	collapse (mean) cmag_* pop_share_* lfp income edu_* pct_poverty ///
				sample_cmag lag_*, by(year state county region segment dma_* market_pop* market_vote_pop market_viewers* pct_market_pop ///
				votes* tot_pop* *visits* n_states battleground* cd_* foreign_* newspaper* document_count news_*) 
		
	keep state county region segment year dma_* market_pop* market_vote_pop market_viewers* pct_market_pop votes_total tot_pop_adult tot_pop_all ///
			pop_share_* lfp income edu_* pct_poverty   tot_pop_vote votes_rep ///
			votes_dem cmag_* *visits*  n_states sample_cmag lag_* battleground* cd_* foreign* newspaper* document_count news_*
	
	order state county region segment year dma_* market_pop* market_vote_pop market_viewers* pct_market_pop votes_total tot_pop_adult tot_pop_all ///
			pop_share_* lfp income edu_* pct_poverty  tot_pop_vote votes_rep ///
			votes_dem *visits* cmag_* n_states sample_cmag lag_* battleground* cd_* foreign* newspaper* document_count news_*
	
	egen country_pop_vote = total(tot_pop_vote), by(year)

	keep if sample_cmag == 1

	foreach yr in 2000 2004 2008 2012 {
		gen temp_x1 = (year == `yr')
		egen temp_x2 = total(temp_x1), by(dma_name)
		gen sample_cmag`yr' = (temp_x2 > 0)
		drop temp_x1 temp_x2
	}

	gen turnout = votes_total/tot_pop_vote*100
	gen votes_total_2pty = votes_rep + votes_dem
	gen vote_share2pty_rep = votes_rep/votes_total_2pty*100
	gen vote_share_rep = votes_rep/tot_pop_vote*100
	gen vote_share2pty_dem = votes_dem/votes_total_2pty*100
	gen vote_share_dem = votes_dem/tot_pop_vote*100
	gen vote_share_ptydf = vote_share_dem - vote_share_rep
	gen vote_share_ptydf_margin = abs(vote_share_ptydf)
	gen vote_share2pty_ptydf = vote_share2pty_dem - vote_share2pty_rep
	gen vote_share2pty_ptydf_margin = abs(vote_share2pty_ptydf)
	replace turnout = 100 if turnout > 100
	replace vote_share_rep = 100 if vote_share_rep > 100
	replace vote_share_dem = 100 if vote_share_dem > 100
	
	save "$data/`year'/sample.dta", replace

**************************************************************************

* END OF FILE
