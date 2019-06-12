/**************************************************************************
	
	Program: create_lag_values.do
	Political Advertising Project
	Last Update: July 2016
	JS/DT
	
	This file creates lagged dependent values used for analysis.
	
**************************************************************************/

	use "$data/census.dta", clear
	
	keep year state county tot_pop_adult 
	keep if inlist(year,2000,2004,2008)
	drop if state == 2
	sort year state county
	
	merge m:1 year state county using "$data/2000/pres_votes.dta", nogenerate update
	merge m:1 year state county using "$data/2004/pres_votes.dta", nogenerate update
	merge m:1 year state county using "$data/2008/pres_votes.dta", nogenerate update

	keep if inlist(year,2000,2004,2008)
	assert !missing(tot_pop_adult) & !missing(votes_dem) & !missing(votes_rep) 
	
	gen tot_pop_vote = max(tot_pop_adult, votes_dem + votes_rep)
	gen lag_turnout_pres = min(1,votes_total/tot_pop_vote)
	gen votes_total_2pty = votes_dem + votes_rep
	gen lag_vote_share_dem = votes_dem/tot_pop_vote
	gen lag_vote_share_rep = votes_rep/tot_pop_vote
	gen lag_vote_share_ptydf = (votes_dem - votes_rep)/tot_pop_vote
	gen lag_vote_share2pty_dem = votes_dem/votes_total_2pty
	gen lag_vote_share2pty_rep = votes_rep/votes_total_2pty
	gen lag_vote_share2pty_ptydf = (votes_dem - votes_rep)/votes_total_2pty
	keep year state county lag_turnout_pres lag_vote_share_ptydf lag_vote_share_dem lag_vote_share_rep lag_vote_share2pty_ptydf lag_vote_share2pty_dem lag_vote_share2pty_rep

	replace year = year + 4
	save "$data/depvars_lag.dta", replace
	
**************************************************************************

* END OF FILE
