/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do


log using output/log_tableA1.txt, replace text



include code/set_globals.do


*-------------------------------------------------------
* table A1: descriptive statistics, 2004
*------------------------------------------------------- 
global summary_vars "tag_counties tag_county_years tag_dma_years tag_county_years turnout lag_turnout_pres*100 tot_pop_adult/1000 pop_share_white*100 pop_share_minority*100 edu_dropout*100 edu_hsplus*100 edu_colplus*100 income/1000 lfp*100 foreign_born_pct*100 pct_poverty*100 cand_visits vote_share2pty_rep vote_share2pty_dem cmag_prez_ptya_base cmag_prez_ptya_1knads cmag_oth_ptya_base cmag_prez_ptyd_base newspaper_slant document_count"

use input/sample_allcounties, clear

egen tag_counties = tag(state county)
egen tag_dma_years = tag(year dma_name) 
egen tag_county_years = tag(state county year)
gen vote_share2pty_party_margin = abs(vote_share_dem - vote_share_rep)
replace document_count = document_count / 100

foreach mat in 2004  {
    cap matrix drop MAT_`mat'
    cap matrix drop MAT_`mat'_BORDER
}
      
foreach year in 2004 {
    preserve
    if inlist("`year'","2004","2008","2012") keep if year == `year' 
    
    foreach type of global summary_vars {
        * This syntax allows for transformations of variables
        tempvar x
        gen `x' = `type'
        sum `x' 
        matrix MAT_`year' = (nullmat(MAT_`year') \ (r(N), r(mean), r(sd), r(min), r(max), r(sum)))
	sum `x' if border_county == 1
        matrix MAT_`year'_BORDER = (nullmat(MAT_`year'_BORDER) \ (r(N), r(mean), r(sd), r(min), r(max), r(sum)))
    }


    matrix rownames MAT_`year' = $summary_vars
    matrix colnames MAT_`year' = N mean sd min max sum
    matrix rownames MAT_`year'_BORDER = $summary_vars
    matrix colnames MAT_`year'_BORDER = N mean sd min max sum
    
    restore
}

foreach mat in 2004  {
    di "`mat'"
    putexcel set output/tables.xlsx, sheet("summary_`mat'", replace) modify
    putexcel A1=matrix(MAT_`mat'), names
    putexcel set output/tables.xlsx, sheet("summary_`mat'_border", replace) modify
    putexcel A1=matrix(MAT_`mat'_BORDER), names
}


log close
