************************
*** Help is Close - R&P
*** Replication File
************************


use "Help is Close replication data.dta", clear
log using help_is_close, replace


*************
*** Figure 1
*************
gen eventdate = ym(year, mon)
format eventdate %tm
label var osvAll "Civilian deaths"
twoway (line contig_pk_percent eventdate if mission == "MONUA", c(1) yaxis(1)) (scatter osvAll eventdate if mission == "MONUA", yaxis(2)), scheme(plotplain) legend(position(6) cols(2) label(1 "% of peacekeepers from contiguous countries") label(2 "Civilian deaths")) xtitle("")
graph export monua.pdf, replace


************
*** Table 1
************
xtset conflict_id time
* Model 1
xtnbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop FracTroop PolTroop Nparticipant, fe i(conflict_id) 
* Model 2
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop FracTroop PolTroop Nparticipant, cluster(conflict_id) 
* Model 3
nbreg osvAll lag_contig_pk_percent troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors, robust
* Model 4
nbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors, robust
* Model 5
nbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors FracTroop PolTroop Nparticipant, robust


*************
*** Figure 2
*************
set seed 1234567
estsimp nbreg osvAll lag_contig_pk_percent troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum epduration lntpop num_neighbors, robust
setx mean
setx osvAllLagDum 0
setx lag_contig_pk_percent 0
simqi
setx lag_contig_pk_percent 2
simqi
setx lag_contig_pk_percent 4
simqi
setx lag_contig_pk_percent 6
simqi
setx lag_contig_pk_percent 8
simqi
setx lag_contig_pk_percent 10
simqi
setx lag_contig_pk_percent 12
simqi
setx lag_contig_pk_percent 14
simqi
setx lag_contig_pk_percent 16
simqi
setx lag_contig_pk_percent 18
simqi
setx lag_contig_pk_percent 20
simqi
setx lag_contig_pk_percent 22
simqi
setx lag_contig_pk_percent 24
simqi
setx lag_contig_pk_percent 26
simqi
drop b1-b10



*************
*** Figure 3
*************
nbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors, robust

matrix b=e(b)
matrix V=e(V)

matrix list b
matrix list V

local k = colsof(b)
foreach c of numlist 1(1)`k' {
	local b`c' = b[1,`c']
	local varb`c' = V[`c',`c']
	foreach r of numlist 1(1)`k' {
		local covb`r'b`c' = V[`r',`c']
	}
}

tempname int
postfile `int' Z ME_X SE_X LO_X HI_X X ME_Z SE_Z LO_Z HI_Z using "Marginal Effects.dta", replace

foreach i of numlist 0(1)43 {
	local ME_X = `b1' + (`b3' * `i')
	local SE_X = sqrt(`varb1'+((`i'^2)*`varb3')+(2*`i'*`covb1b3'))
	local LO_X = `ME_X' - (1.96 * `SE_X')
	local HI_X = `ME_X' + (1.96 * `SE_X')

	post `int' (`i') (`ME_X') (`SE_X') (`LO_X') (`HI_X') (.) (.) (.) (.) (.) 

}

foreach i of numlist 0(1)26 {
	local ME_Z = `b2' + (`b3' * `i')
	local SE_Z = sqrt(`varb2'+((`i'^2)*`varb3')+(2*`i'*`covb2b3'))
	local LO_Z = `ME_Z' - (1.96 * `SE_Z')
	local HI_Z = `ME_Z' + (1.96 * `SE_Z')
	
	post `int' (.) (.) (.) (.) (.) (`i') (`ME_Z') (`SE_Z') (`LO_Z') (`HI_Z') 
}
postclose `int'

preserve
	use "Marginal Effects.dta", clear
	twoway (line ME_X Z) (line LO_X Z, lpattern(dash)) (line HI_X Z, lpattern(dash)), /*
	*/	xtitle("Fear of Conflict Diffusion", size(small)) ytitle("Marginal Effect of Proximate Peacekeepers on Civilian Deaths", size(small)) yline(0, lpattern(dot)) legend(off) scheme(plotplain)
	graph export interaction.pdf, replace
restore


*************
*** Figure 4
*************
gen limit = .
replace limit = 0 if contig_pk_percent < 5
replace limit = 5 if contig_pk_percent >= 5 & contig_pk_percent < 10
replace limit = 10 if contig_pk_percent >= 10 & contig_pk_percent < 15
replace limit = 15 if contig_pk_percent >= 15 & contig_pk_percent < 20
replace limit = 20 if contig_pk_percent >= 20 & contig_pk_percent < 25
replace limit = 25 if contig_pk_percent >= 25 & contig_pk_percent < 30
hist limit, discrete percent start(0) xtitle ("Percentage of peacekeepers from proximate countries") ytitle("Percentage of observations") scheme(plotplain) xscale(range(0 30)) xlabel(0 "0 - <5" 5 "5 - <10" 10 "10 - <15" 15 "15 - <20" 20 "20 - <25" 25 "25 - <30") addlabel addlabopts(yvarformat(%4.2f))
drop limit


************
*** Table 2
************
sum osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop FracTroop PolTroop Nparticipant num_neighbors lag_contig_pk_percent thou_lag_sum thou_interaction1 lag_african_pk_percent if osvAll != . & troopLag != . & policeLag != . & militaryobserversLag != . & brv_AllLag != . & osvAllLagDum != . & incomp != . & epduration != . & lntpop != . & FracTroop != . & PolTroop != . & Nparticipant != ., detail
tab osvAllLagDum, m
tab incomp, m


*************
*** Figure 5
*************
reg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors
lvr2plot, scheme(plotplain)


************
*** Table 3
************
* Model 6
xtnbreg osvAll lag_contig_pk_percent troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors, fe i(conflict_id)
* Model 7
xtnbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors, fe i(conflict_id)
* Model 8
xtnbreg osvAll lag_contig_pk_percent troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors FracTroop PolTroop Nparticipant, fe i(conflict_id)
* Model 9
xtnbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors FracTroop PolTroop Nparticipant, fe i(conflict_id)


************
*** Table 4
************
* Model 10
nbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 lag_african_pk_percent troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors, robust


************
*** Table 5
************
btscs osvAll time conflict_id, g(duration_months)
gen duration_months2=duration_months^2
gen duration_months3=duration_months^3
nbreg osvAll lag_contig_pk_percent thou_lag_sum thou_interaction1 troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop num_neighbors duration_months duration_months2 duration_months3, robust


log close


