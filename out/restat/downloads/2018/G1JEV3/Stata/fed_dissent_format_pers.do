capture log close

log using "$pathF2\\FED_dissent_governors_pers.log", replace  
// Dissent behavior by individual governors (some do a substantial lot of dissent!)

// 1993-2014
use "$pathF2\\FED_dissent93_13f.dta", clear
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
pwcorr id_d nr_votes
pwcorr id_d nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d

// 1993-2002
use "$pathF2\\FED_dissent93_13f.dta", clear
keep if FOMC_public_vote==0
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
pwcorr id_d nr_votes
pwcorr id_d nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d

// 2002-2018
use "$pathF2\\FED_dissent93_13f.dta", clear
keep if FOMC_public_vote==1
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
pwcorr id_d nr_votes
pwcorr id_d nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d

// 2002-2007
use "$pathF2\\FED_dissent93_13f.dta", clear
keep if FOMC_public_vote==1
drop if year<2002
drop if year>2007
drop if year==2007 & month>=3  //& quarter>=2
drop if year==2007 & month==2 & day>=20
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
pwcorr id_d nr_votes
pwcorr id_d nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d

// 2007-2009
use "$pathF2\\FED_dissent93_13f.dta", clear
keep if FOMC_public_vote==1
drop if year<2002
drop if year<2007
drop if year==2007 & month<=1 //& quarter<=1
drop if year==2007 & month==2 & day<=19
drop if year>2009
drop if year==2009 & month>=7 //& quarter>=3
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
pwcorr id_d nr_votes
pwcorr id_d nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d

// 2009-2018
use "$pathF2\\FED_dissent93_13f.dta", clear
keep if FOMC_public_vote==1
drop if year<2002
drop if year<2009
drop if year==2009 & month<=6 //& quarter<=2
collapse nr_votes id_d id_ma id_la, by(id_member members)
g dissent_one_or_more = (id_d>0)
tab dissent_one_or_more
pwcorr id_d nr_votes
pwcorr id_d nr_votes if dissent_one_or_more==1
sum nr_votes if id_d>0, d
sum id_d if dissent_one_or_more==1, d

log close
