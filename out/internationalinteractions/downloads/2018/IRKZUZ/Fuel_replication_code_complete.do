use fuel_replication_data.dta, clear //Note: This dataset contains variables for all regressions in this file, including those for Figures 2 and 3. 

stset endnd, id(stsetid) time0(startnd) failure(failure) //Note: You must run this command before you run any regressions in this file, including those for Figures 2 and 3. You only need to run this command one time for each session. 

*************************************************************************************************************************
*****************************************   Tables    *******************************************************************
*************************************************************************************************************************

***********
//Table 1: All civil conflicts
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time


***********
//Table 2:Major conflicts only
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ucdpmajor ==1, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ucdpmajor ==1, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ucdpmajor ==1, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ucdpmajor ==1, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ucdpmajor ==1, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ucdpmajor ==1, dist(w) frailty(gamma) shared(ccode) nolog forceshared time


***********
//Table 3: Correlation matrix of key variables
corr num_raptotal num_slow num_hydro_met_clim gdpint_ln_onset imr_onset ethfrac_int relfrac_int discpop_dum if coupx==0



*************************************************************************************************************************
*****************************************   Figures   *******************************************************************
*************************************************************************************************************************

//////////Figure 2: Marginal Effects
*rapid-onset disaster marginal effects graph
quietly streg num_raptotal coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog  forceshared time
margins, at(num_raptotal = (0(1)5))
marginsplot,  recast(line) ciopts(recast(rline) lpattern(dash))
graph save T1_2, replace

*climate disater marginal effects graph
quietly streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
margins, at(num_hydro_met_clim = (0(1)5)) 
marginsplot,  recast(line) ciopts(recast(rline) lpattern(dash))
graph save T1_5, replace

*combine marginal effects graphs
graph combine T1_2.gph T1_5.gph, cols(2)


//////////Figure 3: Survival Curves
*rapid-onset disaster survival curve
streg num_raptotal coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog  forceshared time
stcurve, survival at1(num_raptotal =0) at2(num_raptotal =2) at3(num_raptotal =5) scheme(s2mono) ytitle("Pr(Survival)") xtitle("Conflict Duration (Years)" name(rap_surv)) legend(ring(0) pos(3) cols(1))  
graph save rap_surv, replace

*climate disaster survival curve
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
stcurve, survival at1(num_hydro_met_clim =0) at2(num_hydro_met_clim =2) at3(num_hydro_met_clim =5) scheme(s2mono) ytitle("Pr(Survival)") xtitle("Conflict Duration (Years)" name(hmc_surv)) legend(ring(0) pos(3) cols(1))  
graph save hmc_surv, replace

*combine survival curves
graph combine rap_surv.gph hmc_surv.gph, cols(2)



////////// Figure 1: Map
use fuel_map_replication.dta, clear //New dataset. 
 
*disaster map 
spmap num_total_avg using coordinates.dta if iso_num_1!=10, id(id) fcolor(Greys) clmethod(q) 
graph save num_tot, replace

*conflict/years map
spmap year_totalconf using coordinates.dta if iso_num_1!=10, id(id) fcolor(Greys) clmethod(q)  
graph save tot_conf, replace

*combine maps
graph combine num_tot.gph tot_conf.gph, cols(1) rows(2)




*************************************************************************************************************************
*****************************************   Tables in Appendix A   ******************************************************
*************************************************************************************************************************


use fuel_replication_data.dta, clear ////Note: tThis dataset contains variables for all regressions in Appendix A. 

stset endnd, id(stsetid) time0(startnd) failure(failure) //Note: You must run this command before any regressions in this file. You only need to run this command one time for each session.

***********
//Table A1: Summary statistics
summ num_raptotal num_slow num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop imr_onset ln_area if coupx==0

***********
//Table A2: Correlation matrix
summ num_raptotal num_slow num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop imr_onset ln_area if coupx==0

***********
//Table A3: stcox 
stcox num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, frailty(gamma) shared(ccode) nolog forceshared
stcox num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, frailty(gamma) shared(ccode) nolog forceshared
stcox num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, frailty(gamma) shared(ccode) nolog forceshared
stcox num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, frailty(gamma) shared(ccode) nolog forceshared
stcox num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, frailty(gamma) shared(ccode) nolog forceshared
stcox num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, frailty(gamma) shared(ccode) nolog forceshared

*********** 
//Table A4:  with coups.
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area,      dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area,      dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area,      dist(w) frailty(gamma) shared(ccode) time nolog forceshared

*********** 
//Table A5: onset variables.
streg num_raptotal_onset       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_raptotal_onset       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow_onset           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow_onset           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim_onset coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim_onset coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared

*********** 
//Table A6: Alternate geographic and conflict control variables
streg num_raptotal       coldwar confbord lndistx figcapdum hydrod allgemsp gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_raptotal       coldwar confbord lndistx figcapdum hydrod allgemsp imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow           coldwar confbord lndistx figcapdum hydrod allgemsp gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow           coldwar confbord lndistx figcapdum hydrod allgemsp imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim coldwar confbord lndistx figcapdum hydrod allgemsp gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim coldwar confbord lndistx figcapdum hydrod allgemsp imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) time nolog forceshared

***********
//Table A7: Model estimations including only observations for years >= 1980
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1979, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1979, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1979, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1979, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1979, dist(w) frailty(gamma) shared(ccode) time nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1979, dist(w) frailty(gamma) shared(ccode) time nolog forceshared

***********  
//Table A8: Model estimations including only observations for years >= 1970
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1969, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1969, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1969, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1969, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1969, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1969, dist(w) frailty(gamma) shared(ccode) nolog forceshared time

***********
//Table A9: Model estimations including only observations for years >= 1960  
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1959, dist(w) frailty(gamma) shared(ccode) nolog forceshared		
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1959, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1959, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1959, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & year >1959, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & year >1959, dist(w) frailty(gamma) shared(ccode) nolog forceshared

***********
//Table A10: Model estimations including decadal dummies
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop decade_1950s decade_1960s decade_1970s decade_1980s decade_1990s if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      decade_1950s decade_1960s decade_1970s decade_1980s decade_1990s if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop decade_1950s decade_1960s decade_1970s decade_1980s decade_1990s if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      decade_1950s decade_1960s decade_1970s decade_1980s decade_1990s if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop decade_1950s decade_1960s decade_1970s decade_1980s decade_1990s if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      decade_1950s decade_1960s decade_1970s decade_1980s decade_1990s if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared

***********
//Table A11: Model estimations dropping India and the Philippines. 
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ccode !=750 & ccode != 840, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ccode !=750 & ccode != 840, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ccode !=750 & ccode != 840, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ccode !=750 & ccode != 840, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ccode !=750 & ccode != 840, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int imr_onset ln_area ncontig_int      if coupx==0 & ccode !=750 & ccode != 840, dist(w) frailty(gamma) shared(ccode) nolog forceshared

***********
//Table A12: Model estimations omitting states with area > 2sd above the mean
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ln_area <= 16.01141, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ln_area <= 16.01141, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ln_area <= 16.01141, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ln_area <= 16.01141, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int gdpint_ln_onset ln_pop ncontig_int if coupx==0 & ln_area <= 16.01141, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ln_area <= 16.01141, dist(w) frailty(gamma) shared(ccode) nolog forceshared

***********
//Table A13: Model estimations omitting states with area > 1sd above the mean
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ln_area <= 14.587905, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ln_area <= 14.587905, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ln_area <= 14.587905, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ln_area <= 14.587905, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int gdpint_ln_onset ln_pop if coupx==0 & ln_area <= 14.587905, dist(w) frailty(gamma) shared(ccode) nolog forceshared
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int imr_onset ln_area      if coupx==0 & ln_area <= 14.587905, dist(w) frailty(gamma) shared(ccode) nolog forceshared

***********
//Table A14: Controlling for Disaster Vulnerability (disasters at onset)
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int num_raptotal_onset gdpint_ln_onset ln_pop       if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int num_raptotal_onset imr_onset ln_area            if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int num_slow_onset gdpint_ln_onset ln_pop           if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int num_slow_onset imr_onset ln_area                if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int num_hydro_met_clim_onset gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int num_hydro_met_clim_onset imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time

***********
//Table A15: Controlling for Disaster Vulnerability (5-year moving average)
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg5_numrap gdpint_ln_onset ln_pop  if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg5_numrap imr_onset ln_area       if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg5_numslow gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg5_numslow imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg5_numhmc gdpint_ln_onset ln_pop  if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg5_numhmc imr_onset ln_area       if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time

***********
//Table A16: Controlling for Disaster Vulnerability (3-year moving average)
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg3_numrap gdpint_ln_onset ln_pop  if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg3_numrap imr_onset ln_area       if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg3_numslow gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg3_numslow imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg3_numhmc gdpint_ln_onset ln_pop  if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int moveavg3_numhmc imr_onset ln_area       if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time

***********
//Table A17: Controlling for ongoing civil conflicts
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int ongoing_conflicts_count gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_raptotal       coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int ongoing_conflicts_count imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int ongoing_conflicts_count gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_slow           coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int ongoing_conflicts_count imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int ongoing_conflicts_count gdpint_ln_onset ln_pop if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time
streg num_hydro_met_clim coldwar ethfrac_int relfrac_int discpop_dum lmtnest_int ncontig_int ongoing_conflicts_count imr_onset ln_area      if coupx==0, dist(w) frailty(gamma) shared(ccode) nolog forceshared time





