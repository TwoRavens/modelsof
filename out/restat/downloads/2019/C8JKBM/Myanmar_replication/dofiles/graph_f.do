
// histogram 
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results"
// Workplace condition 
hist rscr_sftu if obs_enterbf05==1, ///
 title("Working conditions score") xtitle("Working conditions score") msize(vsmall)  width(0.1) start(0) frac
graph save hist_rscr_sftu, replace 

hist rscr_fsafety if obs_enterbf05==1, ///
 title("Fire safety score") xtitle("Fire safety score") msize(vsmall)  width(0.1) start(0) frac
graph save hist_rscr_fsafety, replace 

hist rscr_health if obs_enterbf05==1, ///
 title("Health score") xtitle("Health management score") msize(vsmall)  width(0.1) start(0) frac
graph save hist_rscr_health, replace 

hist rscr_union if obs_enterbf05==1, ///
 title("Negotiation score") xtitle("Negotiation score") msize(vsmall)  width(0.1) start(0) frac
graph save hist_rscr_union, replace 

gr combine  hist_rscr_fsafety.gph hist_rscr_health.gph hist_rscr_union.gph hist_rscr_sftu.gph, saving(rscr_sftu, replace) title("Working conditions scores")
gr export rscr_sftu.png, replace

