***********************************************************************************************
***Do All Good Things Go Together? Development Assistance and Insurgent Violence in Civil War"*
***Michael Weintraub***************************************************************************
***The Journal of Politics*************************************************************************
***********************************************************************************************

*For the following analysis, use "Weintraub_CCT_final_Jan15.dta"
 
***********************************************************************************************
***Figure 1. FARC Violence Across Treatment and Control Communities
***********************************************************************************************

*bysort treated year: egen mean_kciv_FARC  = mean(kciv_FARC) 
*bysort treated year: egen mean_attacks_farc  = mean(attacks_FARC) 
*bysort treated year: egen mean_indiscrim_FARC = mean(indiscrim_FARC)

twoway (line mean_kciv_FARC  year if treated ==0 & year>1995 & year<2005) ///
(line mean_kciv_FARC  year if treated ==1 & year>1995 & year<2005), legend(label(1 "Control") label(2 "Treatment"))

twoway (line mean_attacks_farc  year if treated ==0 & year>1995 & year<2005) ///
(line mean_attacks_farc year if treated ==1 & year>1995 & year<2005), legend(label(1 "Control") label(2 "Treatment"))

twoway (line mean_indiscrim_FARC  year if treated ==0 & year>1995 & year<2005) ///
(line mean_indiscrim_FARC year if treated ==1 & year>1995 & year<2005) , legend(label(1 "Control") label(2 "Treatment"))

***********************************************************************************************
***Table 2: Effect of Familias en Acción on FARC Killings, Attacks, and Indiscriminate Violence
***********************************************************************************************

eststo clear
eststo Model1: poisson kciv_FARC did treated period if period2002_2003~=., cluster(divipola) 
eststo Model2: poisson attacks_FARC did treated period if period2002_2003~=., cluster(divipola) 
eststo Model3: poisson indiscrim_FARC did treated period if period2002_2003~=., cluster(divipola) 

esttab using table2.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps replace 

***********************************************************************************************
***Table 3: Effects of Familias en Acción on Army Raids
***********************************************************************************************

eststo clear
eststo Model1: poisson armyraids did treated period if period2002_2003~=., cluster(divipola)
esttab using table3.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps replace 

***********************************************************************************************
***Figure 2: Army Raids
***********************************************************************************************

*bysort treated year: egen mean_armyraids  = mean(armyraids) 

twoway (line mean_armyraids  year if treated ==0 & year>1995 & year<2005) ///
(line mean_armyraids year if treated ==1 & year>1995 & year<2005), legend(label(1 "Control") label(2 "Treatment"))

***********************************************************************************************
***Figure 3: Heterogeneous Treatment Effects, Poverty and Coca
***********************************************************************************************

*Poverty
eststo clear
eststo Model1: poisson kciv_FARC did treated period if NBI_level==0 & period2002_2003~=., cluster(divipola) irr
eststo Model2: poisson kciv_FARC did treated period if NBI_level==1 & period2002_2003~=., cluster(divipola) irr
eststo Model3: poisson kciv_FARC did treated period if NBI_level==2 & period2002_2003~=., cluster(divipola) irr
eststo Model4: poisson kciv_FARC did treated period if NBI_level==3 & period2002_2003~=., cluster(divipola) irr
coefplot Model1 Model2 Model3 Model4, keep(did) level(90) xline(1) eform 

*Coca
eststo clear
eststo Model1: poisson kciv_FARC did treated period if quartpercentarea_coca_19972001 ==1, cluster(divipola) irr
eststo Model2: poisson kciv_FARC did treated period if quartpercentarea_coca_19972001 ==10, cluster(divipola) irr
coefplot Model1 Model2 , keep(did) level(90) xline(1) eform 

***********************************************************************************************
***Appendix
***********************************************************************************************

*Table A1. Pre-Treatment Balance Tests
eststo clear
estpost ttest mean_armyraids_1998_2001 mean_indiscrim_FARC_1998_2001 mean_attacks_FARC_1998_2001 mean_kciv_FARC_1998_2001  mean_attacks_para_1998_2001 mean_kciv_para_1998_2001  mean_pargueclash_1998_2001 mean_govgueclash_1998_2001 border oil gems coca_hectares_2002 prop_NBI_total_2005 population_2005 share1998 share2002 dist_current_road roads_ln dismercado orgncap2 if year==2001, by(treated)
esttab using balancetests.tex, starlevels(* 0.1 ** 0.05  *** 0.01 )  cell(mu_1 mu_2 b p) se nogaps label replace

*Table A2. Lasting Effects
eststo clear
eststo Model1: poisson kciv_FARC did_lasting period_lasting treated if period2002_2004~=., cluster(divipola)
eststo Model2: poisson attacks_FARC did_lasting period_lasting treated if period2002_2004~=., cluster(divipola)
eststo Model3: poisson indiscrim_FARC did_lasting period_lasting treated if period2002_2004~=., cluster(divipola)
esttab using lastingeffects.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps  replace 

*Table A3. Placebo Tests
eststo clear
eststo Model1: poisson kciv_FARC  did_2001_2002 period2001_2002 treated if period2001_2002 ~=., cluster(divipola)
eststo Model2: poisson attacks_FARC did_2001_2002 period2001_2002 treated if period2001_2002 ~=., cluster(divipola) 
eststo Model3: poisson indiscrim_FARC did_2001_2002 period2001_2002 treated if period2001_2002 ~=., cluster(divipola) 
esttab using placebo.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps  replace 

*Table A4. Inclusion of Pre-Treatment Covariates
eststo clear
eststo Model1: poisson kciv_FARC did period treated gems oil coca_hectares_2002  population border prop_NBI_total_2005 roads_ln share1998 share2002 if period2002_2003~=., cluster(divipola)
eststo Model2: poisson attacks_FARC did period treated gems oil coca_hectares_2002  population border prop_NBI_total_2005 roads_ln share1998 share2002 if period2002_2003~=., cluster(divipola)
eststo Model3: poisson indiscrim_FARC did period treated gems oil coca_hectares_2002  population border prop_NBI_total_2005 roads_ln share1998 share2002 if period2002_2003~=., cluster(divipola)
esttab using withcovariates.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps  replace 

*Figure A2. Paramilitary Violence

*bysort treated year: egen  mean_kciv_para  = mean(kciv_para ) 
*bysort treated year: egen  mean_attacks_para  = mean(attacks_para ) 

twoway (line mean_kciv_para  year if treated ==0 & year>1995 & year<2005) ///
(line mean_kciv_para  year if treated ==1 & year>1995 & year<2005), legend(label(1 "Control") label(2 "Treatment"))
twoway (line mean_attacks_para  year if treated ==0 & year>1995 & year<2005) ///
(line mean_attacks_para  year if treated ==1 & year>1995 & year<2005), legend(label(1 "Control") label(2 "Treatment"))
 
*Table A5. Paramilitary Violence
eststo clear
eststo Model1: poisson kciv_para did period treated if period2002_2003~=., cluster(divipola)
eststo Model2: poisson attacks_para did period treated if period2002_2003~=., cluster(divipola)
esttab using CCT-dec5-paras.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps  replace 
coefplot Model13 Model14 Model15, keep(Tdyear2 ) xline(0) levels(90)  mcolor(black) mlcolor(black) mfcolor(black)

*Figure A3. Longer Temporal Span for FARC Violence
twoway (line mean_kciv_FARC  year if treated ==0 & year>1995 & year<2011) ///
(line mean_kciv_FARC  year if treated ==1 & year>1995 & year<2011), legend(label(1 "Control") label(2 "Treatment"))
twoway (line mean_attacks_farc  year if treated ==0 & year>1995 & year<2011) ///
(line mean_attacks_farc  year if treated ==1 & year>1995 & year<2011), legend(label(1 "Control") label(2 "Treatment"))
twoway (line mean_indiscrim_FARC  year if treated ==0 & year>1995 & year<2011) ///
(line mean_indiscrim_FARC year if treated ==1 & year>1995 & year<2011), legend(label(1 "Control") label(2 "Treatment"))
 
*Table A5. Negative Binomial Estimator 
eststo clear
eststo Model1: nbreg kciv_FARC did period treated gems oil coca_hectares_2002  population border prop_NBI_total_2005 roads_ln share1998 share2002 if period2002_2003~=., cluster(divipola)
eststo Model2: nbreg attacks_FARC did period treated gems oil coca_hectares_2002  population border prop_NBI_total_2005 roads_ln share1998 share2002 if period2002_2003~=., cluster(divipola)
eststo Model3: nbreg indiscrim_FARC did period treated gems oil coca_hectares_2002  population border prop_NBI_total_2005 roads_ln share1998 share2002 if period2002_2003~=., cluster(divipola)
esttab using negativebinomial.tex,  b(3) se(3) starlevels(* 0.1 ** 0.05  *** 0.01 ) mtitles constant label nogaps  replace 

*Figure A6. Historical Patterns of Insurgent Mobilization
eststo clear
eststo Model1: poisson kciv_FARC did period treated if period2002_2003~=. & orgncap1==0, cluster(divipola) 
eststo Model2: poisson kciv_FARC did period treated if period2002_2003~=. & orgncap1==1, cluster(divipola) 
eststo Model3: poisson attacks_FARC did period treated if period2002_2003~=. & orgncap1==0, cluster(divipola) 
eststo Model4: poisson attacks_FARC did period treated if period2002_2003~=. & orgncap1==1, cluster(divipola) 
eststo Model5: poisson indiscrim_FARC did period treated if period2002_2003~=. & orgncap1==0, cluster(divipola) 
eststo Model6: poisson indiscrim_FARC did period treated if period2002_2003~=. & orgncap1==1, cluster(divipola) 
coefplot Model1 Model2 Model3 Model4 Model5 Model6, keep(did) level(90) xline(0)  
