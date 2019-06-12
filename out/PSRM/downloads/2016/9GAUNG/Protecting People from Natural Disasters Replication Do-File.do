
/********************************************************************/
/**************** Bring data ******************/
/********************************************************************/

#delimit;

cd "/Users/alejandro/Dropbox/Papers Essex/Selectorate/";

log using "Protecting_People_DataAnalysis_Log_PSRM.smcl",replace;

#delimit;
set seed 7777777;

#delimit;
use "Protecting People from Natural Disasters Replication Data.dta",clear;

/********************************************************************/
/************************* Stations ************************************/
/********************************************************************/

/*p. 14--Mean*/
#delimit;
sum stations, detail;

/*p. 14--Proportion*/
#delimit;
tab stations;

/*p.14--Top number of stations*/
#delimit;
gsort -stations;
list ccode statenme stations in 1/4;

/*p.14--Total number of stations in the analysis*/
#delimit;
sort ccode;
egen tot_station=total(stations);
sum tot_station;
drop tot_station;

/*p. 15--Fig 1*/
#delimit;
histogram stations, fcolor(lavender) lcolor(black) normal 
normopts(lcolor(pink) lwidth(medthick) lpattern(solid))
title(Number of Sea-Level Stations by Country (02/14)) ytitle(Percent)
xtitle(Stations) percent xlabel(0(25)250);
/*graph save Graph "Fig2_rev.gph",replace;*/


/********************************************************************/
/************************* Capital Distance ************************************/
/********************************************************************/

/*p.16--Median distance in kilometers from the capital to nearest shore*/
#delimit;
sum distance_km, detail;

/*p.17--Fig 3*/
#delimit;
histogram distance_km , fcolor(lavender) lcolor(black) normal 
normopts(lcolor(pink) lwidth(medthick) lpattern(solid))
title(Distance from National Capitals to the Nearest Shore) ytitle(Percent)
xtitle(Kilometers) percent xlabel(0(200)1200);
/*graph save Graph "Fig3_rev.gph",replace;*/

/*p.18--Sea Capital*/
#delimit;
tab capital_sea_50p;

/********************************************************************/
/***************** Summary Statistics Appendix 3 ********************/
/********************************************************************/

#delimit;
sutex stations W distance_km pop2000_lecz_pc
stm_dis coastline pacific ioc_mship dipl_rep_num 
ship_cntc ln_gdppc ln_pop fdi_pcgdp stm_dead, digits(3) nobs;

/********************************************************************/
/***************** Table 1 ********************/
/********************************************************************/

#delimit;
nbreg stations ln_distance_km lnstm_dis 
lncoast pop2000_lecz_pc  pacific ioc_mship dipl_rep_num;
estimates store m1, title(Model 1);

#delimit;
nbreg stations W ln_distance_km lnstm_dis lncoast 
pop2000_lecz_pc pacific ioc_mship dipl_rep_num ship_cntc;
estimates store m2, title(Model 2);

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
estimates store m3, title(Model 3);

#delimit;
zinb stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num
ship_cntc, inflate(W lnstm_dead Wlnstm_dead);
estimates store m4, title(Model 4);

#delimit;
estout m1 m2 m3 m4, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) ///
   	starlevels(* 0.10 ** 0.05 *** 0.01)  ///
   	legend  ///
   	varlabels(W W ln_distance_km ln(Capital Distance) capital_sea_50p 
   	CapitalSea CapitalDistance pop2000_lecz_pc LECZPopulationPc
   	lnstm_dis NumberStorms lncoast LengthCoast 
   	pacific Pacific ioc_mship IOCMembership
   	dipl_rep_num DiplomaticRepresentation
    ln_gdppc ln(GDPpc) ln_pop ln(Population) fdi_pcgdp FDI
 	ship_cntc Shipping lnstm_dead ln(Deaths) Wlnstm_dead (W)ln(Deaths)
 	_cons Intercept) 	///
   	stats(N ll , fmt(%9.4f) label(N LogLikelihood )) ///
	style(tex) ;



/********************************************************************/
/******************* Substantive Interpretations *********************/
/********************************************************************/

/************************** Model 2 *********************************/

#delimit;
nbreg stations W ln_distance_km lnstm_dis lncoast 
pop2000_lecz_pc pacific ioc_mship dipl_rep_num ship_cntc;
/*estimates store m2, title(Model 2);*/

/*p 24--Predicted number of stations when W=0 moves to W=1*/
#delimit;
margins, at((mean) _all W=(0 1)) ;

/************************** Model 3 *********************************/

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
/*estimates store m3, title(Model 3);*/

/*p. 24--Predicted number of stations when W=0 moves to W=1*/
#delimit;
margins, at((mean) _all W=(0 1)) ;

/*Footnote 18--LR test for interaction (W)(Sea Capital)*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
estimates store m3u, title(Model 3u);
#delimit;
nbreg stations W capital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
estimates store m3r, title(Model 3r);
lrtest m3r m3u;
/*Models are not nested--interaction is significant*/

/*p. 24-25--Effect of interaction (W)(Sea Capital)*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
/*estimates store m3, title(Model 3);*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*Figure 4*/
#delimit;
lincom capital_sea_50p +Wcapital_sea_50p;
scalar w1e=r(estimate);
scalar w1se=r(se);

lincom capital_sea_50p +.75*Wcapital_sea_50p;
scalar w7e=r(estimate);
scalar w7se=r(se);

lincom capital_sea_50p +.5*Wcapital_sea_50p;
scalar w5e=r(estimate);
scalar w5se=r(se);

lincom capital_sea_50p +.25*Wcapital_sea_50p;
scalar w2e=r(estimate);
scalar w2se=r(se);

lincom capital_sea_50p +0*Wcapital_sea_50p;
scalar w0e=r(estimate);
scalar w0se=r(se);

#delimit;
gen est=.;
gen se=.;
gen valueW=_n if _n<=5;
replace est = w1e in 1;
replace est = w7e in 2;
replace est = w5e in 3;
replace est = w2e in 4;
replace est = w0e in 5;
replace se = w1se in 1;
replace se = w7se in 2;
replace se = w5se in 3;
replace se = w2se in 4;
replace se = w0se in 5;

#delimit;
serrbar est se valueW if valueW<=5, mvopts(mcolor(pink)) lcolor(pink) lwidth(medthick)
ytitle(Stations) xtitle(Winning Coalition Size) title(Estimate of (Sea Capital)+
(W)(Sea Capital)) 
scale(1.645) xlabel(1(1)5) yline(0, lwidth(medthick) lcolor(blue) lpattern(dash))
note(95% CIs);
/*graph save Graph "Fig4_rev.gph",replace;*/
/*Note: the labels for the x-axis are in the range of [1,5]. They represent*/
/*the values of the winning coalition [1,0] as properly labelled in the paper*/


/*p. 26--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
/*estimates store m3, title(Model 3);*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 
Wcapital_sea_50p=0)  level (95);
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 
Wcapital_sea_50p=0)  level (90);


/************************** Model 4 *********************************/

#delimit;
zinb stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num
ship_cntc, inflate(W lnstm_dead Wlnstm_dead);
/*estimates store m4, title(Model 4);*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p 24--Predicted number of stations when W=0 moves to W=1*/
#delimit;
margins, at((mean) _all W=(0 1)) ;

/*p. 26--Effect of interaction (W)(Sea Capital)*/
#delimit;
zinb stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num
ship_cntc, inflate(W lnstm_dead Wlnstm_dead);
/*estimates store m4, title(Model 4);*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p. 26--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
zinb stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num
ship_cntc, inflate(W lnstm_dead Wlnstm_dead);
/*estimates store m4, title(Model 4);*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 
Wcapital_sea_50p=0)  level (90);


/********************************************************************/
/********************************************************************/
/******************* Robustness: Appendix 4 *********************/
/********************************************************************/
/********************************************************************/


/************************** Model 3r *********************************/

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc
ln_gdppc ln_pop fdi_pcgdp;
estimates store m3r, title(Model 3r);


/************************** Model 5: Polynomial *************************/

*Create quadratic polynomial of a capitalÕs distance to the shore*/
#delimit;
gen distance_km2= distance_km^2;
gen Wdistance_km= W* distance_km;
gen Wdistance_km2= W* distance_km2;

#delimit;
nbreg stations W distance_km distance_km2 Wdistance_km Wdistance_km2
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num ship_cntc;
estimates store m5, title(Model 5);

/*p.29--Point estimates of the restriction on polynomial*/
lincom distance_km +distance_km2;
lincom distance_km +distance_km2+Wdistance_km +Wdistance_km2;


/************************** Model 6: Storm deaths *********************/

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc lnstm_dead;
estimates store m6, title(Model 6);

/*p.28--Point estimates of the restriction (Sea Capital)+(W)(Sea Capital)*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p. 29--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 Wcapital_sea_50p=0)  level (95);


/*************** Model 7: Drop UK, Chile, France, and US *******************/

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc if stations<=40;
estimates store m7, title(Model 7);

/*p.28--Point estimates of the restriction (Sea Capital)+(W)(Sea Capital)*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p. 29--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 Wcapital_sea_50p=0)  level (95);


/*************** Model 8: Drop UK, France, and US *******************/

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc if ccode!=2 & ccode!=200 & ccode!=220;
estimates store m8, title(Model 8);

/*p.28--Point estimates of the restriction (Sea Capital)+(W)(Sea Capital)*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p. 29--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 Wcapital_sea_50p=0)  level (95);


/*************** Model 9: Drop US and Russia *******************/

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc if ccode!=2 & ccode!=365;
estimates store m9, title(Model 9);

/*p.28--Point estimates of the restriction (Sea Capital)+(W)(Sea Capital)*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p. 29--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 Wcapital_sea_50p=0)  level (95);


/*************** Model 10: Drop wealthy countries *******************/

#delimit;
sum ln_gdppc,detail;
#delimit;
list ccode statenme if ln_gdppc>10.152615 & ln_gdppc!=.;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc if ln_gdppc<10.152615 & ln_gdppc!=.;
estimates store m10, title(Model 10);

/*p.28--Point estimates of the restriction (Sea Capital)+(W)(Sea Capital)*/
lincom capital_sea_50p +Wcapital_sea_50p;

/*p. 29--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 Wcapital_sea_50p=0)  level (95);


/*************** Model 11: Drop democracies *******************/

#delimit;
list ccode statenme if W==1 & W!=.;
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc if W<1;
estimates store m11, title(Model 11);

/*p.28--Point estimates of the restriction (Sea Capital)+(W)(Sea Capital)*/
lincom capital_sea_50p +.75*Wcapital_sea_50p;

/*p. 29--Predicted number of stations when capital_sea=0 moves to 
capital_sea=1 and W=0*/
#delimit;
margins, at((mean) _all capital_sea_50p =(0 1) W=0 Wcapital_sea_50p=0)  level (95);

/********************************************************************/
/********************************************************************/
/***************** Appendix 4: Table  ********************/
/********************************************************************/
/********************************************************************/

#delimit;
estout m3r m5 m6 m7 m8 m9 m10 m11, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) ///
   	starlevels(* 0.10 ** 0.05 *** 0.01)  ///
   	legend  ///
   	varlabels(W W ln_distance_km ln(Capital Distance) capital_sea_50p 
   	CapitalSea CapitalDistance pop2000_lecz_pc LECZPopulationPc
   	lnstm_dis NumberStorms lncoast LengthCoast 
   	pacific Pacific ioc_mship IOCMembership
   	dipl_rep_num DiplomaticRepresentation
    ln_gdppc ln(GDPpc) ln_pop ln(Population) fdi_pcgdp FDI
 	ship_cntc Shipping lnstm_dead ln(Deaths) Wlnstm_dead (W)ln(Deaths)
 	_cons Intercept) 	///
   	stats(N ll , fmt(%9.4f) label(N LogLikelihood )) ///
	style(tex) ;


/********************************************************************/
/********************************************************************/
/************************ Footnote 16 *********************************/
/********************************************************************/
/********************************************************************/

/*Footnote 16: Model 3--LR tests for economics covariates*/

/*Model 3 in paper*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship 
dipl_rep_num ship_cntc;
/*estimates store m3, title(Model 3);*/

/*Model 3 with covariates--unrestricted*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num
ln_gdppc ln_pop fdi_pcgdp ship_cntc;
estimates store e3u, title(Model 1);
gen sample= e(sample);
test ln_gdppc ln_pop fdi_pcgdp ship_cntc;

/*Model 3 without covariates--restricted*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p 
lnstm_dis lncoast pop2000_lecz_pc pacific ioc_mship dipl_rep_num if sample==1;
estimates store e3r, title(Model 1);
lrtest e3r e3u;
drop sample;
/*Models are nested--economic covariates are not needed*/

/*Shipping connectivity is significant*/
#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p pop2000_lecz_pc lnstm_dis 
lncoast pacific ioc_mship dipl_rep_num
ln_gdppc ;
estimates store e3r1, title(Model 1);

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p pop2000_lecz_pc lnstm_dis 
lncoast pacific ioc_mship dipl_rep_num
ln_pop ;
estimates store e3r2, title(Model 1);

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p pop2000_lecz_pc lnstm_dis 
lncoast pacific ioc_mship dipl_rep_num
fdi_pcgdp ;
estimates store e3r3, title(Model 1);

#delimit;
nbreg stations W capital_sea_50p Wcapital_sea_50p pop2000_lecz_pc lnstm_dis 
lncoast pacific ioc_mship dipl_rep_num
ship_cntc ;
estimates store e3r4, title(Model 1);

log close;
