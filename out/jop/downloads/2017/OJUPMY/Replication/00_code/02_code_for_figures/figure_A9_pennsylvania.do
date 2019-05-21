clear 
use "01_data/voting_data/state_legislative_elections/PAStateLegislativeElection_12.dta"

graph bar (mean) rep, over(year) over(shale) ytitle("Republican Representatives (%)")  yscale(range(0 1)) ylabel(0(0.2)1)

graph export "03_figures/figure_A9_pennsylvania_election.pdf", replace
