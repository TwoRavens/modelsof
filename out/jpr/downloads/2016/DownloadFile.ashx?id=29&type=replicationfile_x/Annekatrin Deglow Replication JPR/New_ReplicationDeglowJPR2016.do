*	Program setup
	log using ReplicationDeglow2016JPR.log, replace
	version 13.0 
	set more off

*   Author:     Annekatrin Deglow 	
*	Contact:	annekatrin.deglow@pcr.uu.se
*	Do-file:    ReplicationDeglow2016JPR.do
*   Dataset:	ReplicationDeglow2016JPR.dta
*	Article:	"Localized legacies of civil war: Postwar violent crime in Northern Ireland" (JPR, 2016)
*	Date:		28 June 2016


********************************
*** MAIN ANALYSIS IN ARTICLE ***
********************************

* TABLE I: SUMMARY STATISTICS
sum 		vc_0206 total perc_rep perc_loy rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv 

* Please note a typo on p.793 in the main article: 'perc_unemp' measures the percentage of unemployed individuals between 16 and pensionable age over each 
* ward’s total employable population, and not over each ward's total population.


* TABLE II: NBRM (DV = VIOLENT CRIME COUNTS)
nbreg 		vc_0206 total slv //Model 1
nbreg 		vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv //Model 2
nbreg 		vc_0206 perc_rep slv //Model 3
nbreg 		vc_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv //Model 4
nbreg 		vc_0206 perc_loy rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv //Model 5


* POST-ESTIMATION ANALYSIS OF H1 (based on Model 2)
// Independent variable moving from 10th to 90th percentile 
estsimp		nbreg vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
setx 		total p10 rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
simqi
drop 		b* 

estsimp 	nbreg vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
setx 		total p90 rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
simqi
drop 		b* 

// Independent variable moving from minimum to maximum value 
estsimp 	nbreg vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
setx 		total min rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
simqi
drop 		b* 

estsimp 	nbreg vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
setx 		total max rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
simqi
drop 		b*

// Figure 2: Graph of expected violent crime counts as exposure to violence (fatalities) increases, with 95% CI (based on Model 2)
local 		IV 		total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
local 		DV 		vc_0206
local 		xaxis 	total 

estsimp 	nbreg `DV' `IV'

generate 	predcount = .
generate 	uci = .
generate 	lci = .

summarize 	`xaxis'
local xmax = ceil(r(max))
local xmin = floor(r(min))
local range = `xmax'-`xmin'

generate 	xaxis = `xmin'+_n-1 in 1/`range'

setx 		rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
	
forval 		i=`xmin'/`xmax' {
			setx `xaxis' `i'	
			simqi, genev(pi)
			_pctile pi, p(2.5,97.5)

			replace lci = r(r1) if xaxis ==`i'
			replace uci = r(r2) if xaxis ==`i'

			sum pi
			replace predcount = r(mean) if xaxis ==`i'
			drop pi

}

twoway 		(rline uci lci xaxis, lpattern(dash) graphregion(color(white))) ///
			(line predcount xaxis, lcolor(black)), ytitle(Predicted violent crime counts) ///
			yscale(range(0 300)) ylabel(0(50)300) xtitle(Exposure to violence (fatalities)) ///
			xscale(range(0 142)) xlabel(0(10)142) legend(size(small) ///
			order(2 "Predicted violent crime counts" 1 "95% CI")) 

drop 		b* predcount uci lci xaxis


* POST-ESTIMATION ANALYSIS OF H2 (based on Model 4)
// Independent variable moving from minimum to maximum value
estsimp 	nbreg vc_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
setx 		perc_rep min rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
simqi
drop 		b*

estsimp 	nbreg vc_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
setx 		perc_rep max rural min mixed min RI min peaceline min sect_comp_par mean males1624 mean perc_unemp mean perc_he mean log_pop_0206 mean slv mean
simqi
drop 		b* 


* RESULTS REPORTED IN FOOTNOTE 5 & 15
// Dependent variable = homicide ocurrence (footnote 5)
logit		h_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slh
logit		h_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slh
logit		h_0206 perc_loy rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slh

// Independent variable = Violence count for anti-govt/pro-state groups (footnote 15)
nbreg		vc_0206 republican tot_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv
nbreg		vc_0206 loyalist tot_loy rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv



******************************************
*** ONLINE APPENDIX (Robustness checks)***
******************************************

* TABLE I: NBRM (DV = RECORDED CRIME COUNTS)
nbreg 		rc_0206 total slc //Model 1
nbreg 		rc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slc //Model 2
nbreg 		rc_0206 perc_rep slc //Model 3
nbreg 		rc_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206  slc //Model 4


* TABLE II: NBRM (DV = RECORDED CRIME COUNTS EXCLUDING SECTARIAN OFFENSES)
nbreg 		vpure_0506 total slvp //Model 1
nbreg 		vpure_0506 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0506 slvp //Model 2
nbreg 		vpure_0506 perc_rep slvp //Model 3
nbreg 		vpure_0506 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0506 slvp //Model 4



* TABLE IV: NBRM (DV = VIOLENT CRIME COUNTS): ALTERNATIVE SPATIAL LAG (2nd ORDER QUEEN)
nbreg 		vc_0206 total slv2 //Model 1
nbreg 		vc_0206 total rural mixed RI peaceline sect_comp_par males1624 perc_unemp perc_he log_pop_0206 slv2 //Model 2
nbreg 		vc_0206 perc_rep slv2 //Model 3
nbreg 		vc_0206 perc_rep rural mixed RI peaceline sect_comp_par males1624 perc_unemp perc_he log_pop_0206 slv2 //Model 4



* TABLE VI:	SUMMARY STATISTICS FOR VARIABLES USED IN TABLE I, II AND IV
sum			vc_0206 rc_0206 vpure_0506 total perc_rep rural mixed RI peaceline sect_comp_par males1624 perc_unemp perc_he log_pop_0206 ///
			log_pop_0506 slc slvp slv2

* TABLE V: NBRM (DV = VIOLENT CRIME COUNTS): ADDITIONAL PEACELINES
replace peaceline =1 if ward_name=="Holly Mount"
replace peaceline =1 if ward_name=="The Diamond"
replace peaceline =1 if ward_name=="Brandywell"
replace peaceline= 1 if ward_name=="Strand (Derry LGD)"
replace peaceline =1 if ward_name=="Altnagelvin"


nbreg 		vc_0206 total slv //Model 1
nbreg 		vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv //Model 2
nbreg 		vc_0206 perc_rep slv //Model 3
nbreg 		vc_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slv //Model 4


* TABLE VIII:	SUMMARY STATISTICS FOR VARIABLES USED IN TABLE V (ADDITIONAL PEACELINES)
sum			vc_0206 total perc_rep rural mixed RI peaceline sect_comp_par males1624 perc_unemp perc_he log_pop_0206 slv
			  

			
* TABLE III: NBRM (DV = VIOLENT CRIME COUNTS): EXCLUDING DERRY 
// Drop wards in Derry City Council (as of 2001) 
drop if 	lgd=="Derry"

nbreg 		vc_0206 total slvderry //Model 1
nbreg 		vc_0206 total rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slvderry //Model 2
nbreg 		vc_0206 perc_rep slvderry // Model 3
nbreg 		vc_0206 perc_rep rural mixed RI peaceline sect_comp males1624 perc_unemp perc_he log_pop_0206 slvderry //Model 4


* TABLE VII:	SUMMARY STATISTICS FOR VARIABLES USED IN TABLE III (EXLUDING DERRY)
sum			vc_0206 total perc_rep rural mixed RI peaceline sect_comp_par males1624 perc_unemp perc_he log_pop_0206 slvderry


**********
log 		close



