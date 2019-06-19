
clear all

global dataDir "../1-datasets"

// Macros for background color
global bg "graphregion(color(white)) bgcolor(white)"
global st "subtitle(,bcolor(white))"
global lg "legend(region(lcolor(white)))"

////////////////////////////////////////
// TABLE 1

use "$dataDir/dataset_contPanel.dta", clear
label var contest_length "Contest length (days)"
label var top_prize "Prize value (US\$)"
label var players "No. of players"
label var designs "No. of designs"
label var num_rated5 "$\quad$ 5-star designs"
label var num_rated4 "$\quad$ 4-star designs"
label var num_rated3 "$\quad$ 3-star designs"
label var num_rated2 "$\quad$ 2-star designs"
label var num_rated1 "$\quad$ 1-star designs"
label var num_rated0 "$\quad$ Unrated designs"
label var num_rated "Number rated"
label var pct_rated "Fraction rated"
label var guaranteed "Prize committed"
label var awarded "Prize awarded"
replace top_prize=100*top_prize
fsum contest_length top_prize ///
  players designs num_rated5 ///
  num_rated4 num_rated3 ///
  num_rated2 num_rated1 ///
  num_rated0 num_rated ///
  pct_rated guaranteed awarded, ///
stats(mean sd p25 p50 p75) ///
format(%9.2f) uselabel

////////////////////////////////////////
// TABLE 2

use "$dataDir/dataset_main_phash.dta", clear
label define ratinglabels ///
  1 "1 star"  ///
  2 "2 stars" ///
  3 "3 stars" ///
  4 "4 stars" ///
  5 "5 stars"
label values subrating ratinglabels
tab subrating if subrating>0

////////////////////////////////////////
// TABLE 3

use "$dataDir/dataset_main_phash.dta", clear
label var max_phash_own "Max. similarity to any own designs"
label var bst_max_phash_own "Max. similarity to best own designs"
label var bst_max_phash_oth "Max. similarity to best others' designs"
label var batchsim_p_intra "Intra-batch avg. similarity"
fsum max_phash_own ///
  bst_max_phash_own ///
  bst_max_phash_oth, ///
  stats(mean sd p1 p10 p50 p90 p99) ///
  format(%9.2f) uselabel
fsum batchsim_p_intra ///
  if newbatch==1 & batchmiss==0, ///
  stats(mean sd p1 p10 p50 p90 p99) ///
  format(%9.2f) uselabel

use "$dataDir/dataset_main_dhash.dta", clear
label var max_dhash_own "Max. similarity to any own designs"
label var bst_max_dhash_own "Max. similarity to best own designs"
label var bst_max_dhash_oth "Max. similarity to best others' designs"
label var batchsim_d_intra "Intra-batch avg. similarity"
fsum max_dhash_own ///
  bst_max_dhash_own ///
  bst_max_dhash_oth, ///
  stats(mean sd p1 p10 p50 p90 p99) ///
  format(%9.2f) uselabel
fsum batchsim_d_intra ///
  if newbatch==1 & batchmiss==0, ///
  stats(mean sd p1 p10 p50 p90 p99) ///
  format(%9.2f) uselabel

////////////////////////////////////////
// FIGURE 2

use "$dataDir/dataset_main_phash.dta", clear

replace subrating=. if subrating==0
gen competitive=(obs_oth5s>=1)
label var competitive "Competitive?"

label var max_phash_own ///
"Max. similarity to own prior entries"

label define lbl_competitive ///
0 "No top-rated competition" ///
1 "w/ Top-rated competition"
label values competitive lbl_competitive

replace best_rating_own=0 if best_rating_own==.

hist max_phash_own if best_rating_own==0, ///
by(competitive, title("No prior rating", color(black) size(vlarge)) note("") $bg) ///
$st frac width(0.2) xlabel(0(0.5)1, format(%9.1f)) xscale(r(0 1)) ///
ylabel(0(0.1)0.7, angle(horizontal) format(%9.1f)) yscale(r(0 0.7)) ///
xtitle(,size(large)) ytitle(,size(large))
gr_edit .plotregion1.subtitle[1].style.editstyle size(vlarge) editcopy
gr_edit .plotregion1.subtitle[2].style.editstyle size(vlarge) editcopy
graph export "Figure_2_0.png", replace

forval r=1/5 {
  hist max_phash_own if best_rating_own==`r', ///
  by(competitive, title("Best prior rating = `r'", color(black) size(vlarge)) note("") $bg) ///
  $st frac width(0.2) xlabel(0(0.5)1, format(%9.1f)) xscale(r(0 1)) ///
  ylabel(0(0.1)0.7, angle(horizontal) format(%9.1f)) yscale(r(0 0.7)) ///
  xtitle(,size(large)) ytitle(,size(large))
  gr_edit .plotregion1.subtitle[1].style.editstyle size(vlarge) editcopy
  gr_edit .plotregion1.subtitle[2].style.editstyle size(vlarge) editcopy
	graph export "Figure_2_`r'.png", replace
}
