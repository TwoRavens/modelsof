/* Tax Progressivity Project: BDM Downs and Smith October 2013   */
/* delta test file */
/* revisions in October 2014 -- Alastair Smith */ 

#delimit;
clear;

use "taxProgessivityReplicationData.dta";

/**** rescale progressivity *****/


replace ARP_all=100*ARP_all;
replace MRP_all=100*MRP_all;

keep if year>=1970;
keep if ccode~=.;

tsset ccode year;
gen L3W=L3.W; gen L3W2=(L3.W)^2; gen L3Dem=L3.demaut; gen L3incomepc=L3.lnGDPpc;
gen L3war=L3.war; gen L3civilwar=L3.civilwar;
gen L3Oil=L3.OIL; gen L3Ore=L3.ORE;
gen L5Oil=L5.OIL; gen L5Ore=L5.ORE;
gen L3WOilOre=L3W*(L3Oil+L3Ore); gen L3DemOilOre=L3Dem*(L3Oil+L3Ore);
gen L5WOilOre=L5.W*(L5Oil+L5Ore); gen L5DemOilOre=L5.demaut*(L5Oil+L5Ore);
replace ARP_all=0 if ARP_all<0;
gen flat=AR_y==AR_4y & AR_y~=0 & AR_y~=.; 
replace flat=. if ARP_all==.;
gen rateflat=AR_4y if flat==1;
gen rateprog=MR_4y-MR_y ; replace rateprog=. if MR_y==. | MR_4y ==.;
gen ginialter=gini_net-gini_gross;
gen L3gini_gross=L3.gini_gross;
gen L3Wgini_gross= L3gini_gross*L3W;
gen L3Wincome=L3W*L3incomepc;
gen L3Demincome=L3Dem*L3incomepc;
gen L3aid_gdp=L3.aid_g;
gen lnaid=ln(aid+1);
gen L3lnaid=L3.lnaid;
rename necong GovExpWB;
gen L3GovExpWB=L3.GovExpWB;
gen L3WGovExpWB=L3W*L3GovExpWB;
gen L3DemGovExpWB=L3Dem*L3GovExpWB;



gen L3lnPOP=L3.lnPOP; 
gen L5lnPOP=L5.lnPOP;
gen L5war=L5.war; gen L5civilwar=L5.civilwar;
gen NoTax=AR_y==0 & AR_2y==0 & AR_3y==0 & AR_4y==0; replace NoTax=. if AR_y==. | AR_2y==.|AR_3y==.|AR_4y==.;
gen notaxlevel=0; replace notaxlevel=1 if AR_y==0 & AR_2y~=0; replace notaxlevel=2 if AR_y==0&AR_2y==0&AR_3y~=0;
replace notaxlevel=3 if AR_y==0&AR_2y==0&AR_3y==0&AR_4y~=0; replace notaxlevel=4 if AR_y==0&AR_2y==0&AR_3y==0&AR_4y==0; replace notaxlevel=. if notax==.;
gen flatnotax=0; replace flatnotax=1 if AR_y==AR_4y & AR_y~=.; replace flatnotax=. if ARP_all==.;
gen L5HiMidLow=L5.HiMidLow;
gen L5AR_y=L5.AR_y;
gen L3AR_y=L3.AR_y;

capture gen lnARP=ln(1+ARP_all);
gen triW=0 if W==0|W==.25|W==.5; replace triW=.75 if W==.75; replace triW=1 if W==1;

tsset ccode year; gen L5W=L5.W;  gen L5binW=L5.binW; gen L5income=l5.lnGDPpc;
gen L5Wincome=L5W*L5income; gen L5Dem=L5.demaut; gen L5Demincome=L5Dem*L5income;
gen L5Dem2=(L5.demaut)^2;

gen L5W2=L5W^2;
gen L3OilOre=L3Oil+L3Ore;
gen L5OilOre=L5Oil+L5Ore;
gen L3LargeOil=L3Oil>=10;
replace L3LargeOil=. if L3Oil==.;
gen L3LargeResource=L3OilOre>=10;
gen L5LargeResource=L5.OILORE>=10;
replace L5LargeResource=. if L5.OILORE==.;
replace L3LargeResource=. if L3OilOre==.;
gen L3WLargeResource=L3W*L3LargeResource;
gen L5WLargeResource=L5W*L5LargeResource;
gen L5DemLargeResource=L5Dem*L5LargeResource;
gen littleaid=lnaid<5;
replace littleaid=. if aid==0 | aid==.;
gen littleaidW=littleaid*L3W;
 gen L5gini_gross=L5.gini_gross;
gen L5Wgini_gross=L5W*L5gini_gross;
gen L5Demgini_gross=L5Dem*L5gini_gross;



xtset ccode year;

save temp,replace;
#delimit;

/* Table 1*/
sort W;
by W: sum NoTax flat; 
tab L3W NoTax, all row;


estpost summarize   ARP_all MRP_all flatnotax  L5W  L5income L5lnPOP L5OilOre L5LargeR if ARP_all ~=. ;
esttab ., cells("count mean sd min max") noobs;

estpost summarize gini_net gini_gross ginial;
esttab ., cells("count mean sd min max") noobs;
 

/* table of averages */
#delimit;
gen OilOre=oil+ore;
gen LargeResource=OilOre>=.1; 
replace LargeResource=. if OilOre==.;
/* Table 2: Composition of Tax Progressivity Data */ 
table HiMidLow triW ,c(mean ARP_all  mean AR_y mean flat mean NoT n ARP_all ) format(%9.2f);

table L5binW L5LargeR, c(mean ARP_all  mean MRP_all mean flatnotax n flatnotax  )format(%9.2f);


table L5binW L5LargeR, c(mean ARP_all  mean MRP_all mean flatnotax n flatnotax  )format(%9.2f);

table L5binW L5LargeR, c(	mean ginialter n ginialter)  format(%9.2f);



/* Flat Tax , No Tax? */
#delimit;
xtlogit flatnotax L5W L5W2 L5income  L5lnPOP , fe i(regyr);
estimates store m1, title(Model 1);
test L5W L5W2; 
test L5W+ L5W2=0;
xtlogit flatnotax L5W L5W2  L5income  L5lnPOP L5OilOre L5WOilOre, fe i(regyr);
estimates store m2, title(Model 2);
gen temp =e(sample);
test L5W L5W2; 
test L5W+ L5W2=0;test L5OilOre L5WOilOre; test L5OilOre+ L5WOilOre=0;

xtlogit flatnotax L5W L5W2 L5income  L5lnPOP if temp==1, fe i(regyr);
test L5W L5W2; 
test L5W+ L5W2=0;
xtlogit flatnotax L5W L5W2  L5income  L5lnPOP L5AR_y, fe i(regyr);
estimates store m3, title(Model 3);test L5W L5W2; 
test L5W+ L5W2=0;
xtlogit flatnotax L5W L5W2  L5income  L5lnPOP L5OilOre L5WOilOre L5AR_y, fe i(regyr);
estimates store m4, title(Model 4);test L5W L5W2; 
test L5W+ L5W2=0; test L5OilOre L5WOilOre; test L5OilOre+ L5WOilOre=0;

/* Table 3*/
estout m1 m2 m3 m4 , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	varlabel(_cons	Constant L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$   )
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);

/* Robustness Tests: Flat/No Tax */ 
#delimit;
xtlogit flatnotax L5Dem L5Dem2 L5income  L5lnPOP , fe i(regyr);
estimates store m1a, title(Model 1a);
xtlogit flatnotax L5Dem L5Dem2  L5income  L5lnPOP L5OilOre L5DemOilOre, fe i(regyr);
estimates store m2a, title(Model 2a);
xtlogit flatnotax L5Dem L5Dem2  L5income  L5lnPOP L5OilOre L5DemOilOre L5war L5civilwar, fe i(regyr);
estimates store m25a, title(Model 25a);
xtlogit flatnotax L5Dem L5Dem2  L5income  L5lnPOP L5AR_y, fe i(regyr);
estimates store m3a, title(Model 3a);
xtlogit flatnotax L5Dem L5Dem2  L5income  L5lnPOP L5OilOre L5DemOilOre L5AR_y, fe i(regyr);
estimates store m4a, title(Model 4a);
xtlogit flatnotax L5Dem L5Dem2  L5income  L5lnPOP L5OilOre L5DemOilOre L5AR_y L5war L5civilwar, fe i(regyr);
estimates store m45a, title(Model 45a);
/* Table 1: A:  Appendix */
estout m1a m2a m25a m3a m4a m45a , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	varlabel(_cons	Constant L5Dem \$Demo_{t-5}$ L5Dem2 \$Demo^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5DemOilOre \$Demo_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$  )
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	

#delimit;
xtlogit flatnotax L3W L3W2 L3income  L3lnPOP , fe i(regyr);
estimates store m1b, title(Model 1b);
xtlogit flatnotax L3W L3W2  L3income  L3lnPOP L3OilOre L3WOilOre, fe i(regyr);
estimates store m2b, title(Model 2b);
xtlogit flatnotax L3W L3W2  L3income  L3lnPOP L3AR_y, fe i(regyr);
estimates store m3b, title(Model 3b);
xtlogit flatnotax L3W L3W2  L3income  L3lnPOP L3OilOre L3WOilOre L3AR_y, fe i(regyr);
estimates store m4b, title(Model 4b);
/* Table 2: B: Appendix */
estout m1b m2b m3b m4b , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	varlabel(_cons	Constant L3W \$W_{t-3}$ L3W2 \$W^{2}_{t-3}$ L3income \$ln(Income_{t-3})$
	L3lnPOP \$ln(Population_{t-3})$ year Year L3OilOre \$OilOre_{t-3}$ L3WOilOre \$W_{t-3}*OilOre_{t-3}$ 
	L3AR_y \$Avg.Tax_{t-3}$   )
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	
	
	
	
/*  Basic specification of ARP_all */ 
#delimit;
reg ARP_all L5W L5W2 L5income  L5lnPOP year if NoTax==0,  vce(cluster ccode);
estimates store m5, title(Model 5); test L5W L5W2; test L5W+ L5W2=0; 
reg ARP_all L5W L5W2 L5income  L5lnPOP i.year if NoTax==0, vce(cluster ccode) ;
estimates store m6, title(Model 6); test L5W L5W2; test L5W+ L5W2=0; 

xtreg ARP_all L5W L5W2 L5income  L5lnPOP year  if NoTax==0, fe i(ccode) vce(cluster ccode) ;
estimates store m7, title(Model 7);test L5W L5W2; test L5W+ L5W2=0; 
xtreg ARP_all L5W L5W2 L5income  L5lnPOP  if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m8, title(Model 8);test L5W L5W2; test L5W+ L5W2=0; 
#delimit;
/* Table 4*/
estout m5 m6 m7 m8 , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	drop(*.year)
   	varlabel(_cons	Constant L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$ L5lnPOP \$ln(Population_{t-5})$ year Year)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);

/* Robustness: basic specification */ 	
#delimit;
reg ARP_all L5Dem L5Dem2 L5income  L5lnPOP year if NoTax==0,  vce(cluster ccode);
estimates store m5a, title(Model 5a); 
reg ARP_all L5Dem L5Dem2 L5income  L5lnPOP i.year if NoTax==0, vce(cluster ccode) ;
estimates store m6a, title(Model 6a); 
xtreg ARP_all L5Dem L5Dem2 L5income  L5lnPOP year  if NoTax==0, fe i(ccode) vce(cluster ccode) ;
estimates store m7a, title(Model 7a);
xtreg ARP_all L5Dem L5Dem2 L5income  L5lnPOP  if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m8a, title(Model 8a);
#delimit;
/* Table 3: A: appendix */
estout m5a m6a m7a m8a , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	drop(*.year)
   	varlabel(_cons	Constant L5Dem \$Demo_{t-5}$ L5Dem2 \$Demo^{2}_{t-5}$ L5income \$ln(Income_{t-5})$ L5lnPOP \$ln(Population_{t-5})$ year Year)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	
	

	#delimit;
reg ARP_all L3W L3W2 L3income  L3lnPOP  year if NoTax==0,  vce(cluster ccode);
estimates store m5b, title(Model 5b); 
reg ARP_all L3W L3W2 L3income  L3lnPOP  i.year if NoTax==0, vce(cluster ccode) ;
estimates store m6b, title(Model 6b); 
xtreg ARP_all L3W L3W2 L3income  L3lnPOP  year  if NoTax==0, fe i(ccode) vce(cluster ccode) ;
estimates store m7b, title(Model 7b);
xtreg ARP_all L3W L3W2 L3income  L3lnPOP   if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m8b, title(Model 8b);
#delimit;
/* Table 4 B: Appendix */
estout m5b m6b m7b m8b , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	drop(*.year)
   	varlabel(_cons	Constant L3W \$W_{t-3}$ L3W2 \$W^{2}_{t-3}$ L3income \$ln(Income_{t-3})$
	L3lnPOP \$ln(Population_{t-3})$ year Year L3OilOre \$OilOre_{t-3}$ L3WOilOre \$W_{t-3}*OilOre_{t-3}$ 
	L3AR_y \$Avg.Tax_{t-3}$   year Year)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	
	
#delimit;
reg MRP_all L5W L5W2 L5income  L5lnPOP year if NoTax==0,  vce(cluster ccode);
estimates store m5c, title(Model 5c); 
reg MRP_all L5W L5W2 L5income  L5lnPOP i.year if NoTax==0, vce(cluster ccode) ;
estimates store m6c, title(Model 6c); 

xtreg MRP_all L5W L5W2 L5income  L5lnPOP year  if NoTax==0, fe i(ccode) vce(cluster ccode) ;
estimates store m7c, title(Model 7c);
xtreg MRP_all L5W L5W2 L5income  L5lnPOP  if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m8c, title(Model 8c);
#delimit;
/* Table 5: C: Appendix */
estout m5c m6c m7c m8c , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
	drop(*.year)
   	varlabel(_cons	Constant L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$ L5lnPOP \$ln(Population_{t-5})$ year Year)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	
	
	


	
	/* residual plots */
	#delimit;
	reg ARP_all L5W L5W2 L5income  L5lnPOP year if NoTax==0 ,  vce(cluster ccode);
	capture drop xb5 res5;predict xb5; gen res5=ARP_all-xb5; 
twoway 
           (scatter res5 xb5 if L5W<1&NoTax==0,msymbol(Th))
		   (scatter res5 xb5 if L5W==1&NoTax==0, msymbol(Oh)) 
		   ,legend(label(2 "W=1") label(1  "W<1")) ytitle(Residual) t1title(Residuals in Model 5);

#delimit;
	xtreg ARP_all L5W L5W2 L5income  L5lnPOP year if NoTax==0,  fe i(regyr);
	capture drop xb8 res8;predict xb8; gen res8=ARP_all-xb8; 
twoway 
           (scatter res8 xb8 if L5W<1&NoTax==0 ,msymbol(Th))
		   (scatter res8 xb8 if L5W==1&NoTax==0, msymbol(Oh)) 
		   ,legend(label(2 "W=1") label(1  "W<1")) ytitle(Residual) t1title(Residuals in Model 8);

		   
		   
/* Progressivity with more comprehensive controls  */

#delimit;
xtreg ARP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m9, title(Model 9);test L5W L5W2; test L5W+ L5W2=0; 
#delimit;
xtreg ARP_all L5W L5W2 L5income  L5lnPOP L5OilOre L5WOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m10, title(Model 10);test L5W L5W2; test L5W+ L5W2=0; test L5OilOre L5WOilOre ;test L5OilOre +L5WOilOre =0;
#delimit;
xtreg ARP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y L5OilOre L5WOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m11, title(Model 11);test L5W L5W2; test L5W+ L5W2=0; test L5OilOre L5WOilOre ;test L5OilOre +L5WOilOre =0;
#delimit;
xtreg ARP_all L5W L5W2 L5income  L5lnPOP  L5gini_gross L5Wgini_gross if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m12, title(Model 12);test L5W L5W2; test L5W+ L5W2=0; 

#delimit;
/* Table 5 */
estout m9 m10 m11 m12, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$  L5gini_gross \$GINI_{t-5}$ L5Wgini_gross \$W_{t-5}*GINI_{t-5}$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);

/* Robustness Tests */
#delimit;
xtreg ARP_all L5Dem L5Dem2 L5income  L5lnPOP L5war L5civilwar L5AR_y if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m9a, title(Model 9a);
#delimit;
xtreg ARP_all L5Dem L5Dem2 L5income  L5lnPOP L5OilOre L5DemOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m10a, title(Model 10a);
#delimit;
xtreg ARP_all L5Dem L5Dem2 L5income  L5lnPOP L5war L5civilwar L5AR_y L5OilOre L5DemOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m11a, title(Model 11a);
#delimit;
xtreg ARP_all L5Dem L5Dem2 L5income  L5lnPOP  L5gini_gross L5Demgini_gross if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m12a, title(Model 12a);

#delimit;
/* Table 6: A: Appendix */
estout m9a m10a m11a m12a, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L5Dem \$Demo_{t-5}$ L5Dem2 \$Demo^{2}_{t-5}$  L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5DemOilOre \$Demo_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$  L5gini_gross \$GINI_{t-5}$ L5Demgini_gross \$Demo_{t-5}*GINI_{t-5}$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	
	
	
#delimit;
xtreg ARP_all L3W L3W2 L3income  L3lnPOP L3war L3civilwar L3AR_y if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m9b, title(Model 9b);
#delimit;
xtreg ARP_all L3W L3W2 L3income  L3lnPOP L3OilOre L3WOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m10b, title(Model 10b);
#delimit;
xtreg ARP_all L3W L3W2 L3income  L3lnPOP L3war L3civilwar L3AR_y L3OilOre L3WOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m11b, title(Model 11b);
#delimit;
xtreg ARP_all L3W L3W2 L3income  L3lnPOP  L3gini_gross L3Wgini_gross if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m12b, title(Model 12b);

#delimit;
/* Table 7: B: Appendix */
estout m9b m10b m11b m12b, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L3W \$W_{t-3}$ L3W2 \$W^{2}_{t-3}$ L3income \$ln(Income_{t-3})$
	L3lnPOP \$ln(Population_{t-3})$ year Year L3OilOre \$OilOre_{t-3}$ L3WOilOre \$W_{t-3}*OilOre_{t-3}$ 
	L3AR_y \$Avg.Tax_{t-3}$ L3war \$War_{t-3}$  L3civilwar \$CivilWar_{t-3}$  L3gini_gross \$GINI_{t-3}$ L3Wgini_gross \$W_{t-3}*GINI_{t-3}$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);	
	
#delimit;
xtreg MRP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m9c, title(Model 9c);
#delimit;
xtreg MRP_all L5W L5W2 L5income  L5lnPOP L5OilOre L5WOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m10c, title(Model 10c);
#delimit;
xtreg MRP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y L5OilOre L5WOilOre if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m11c, title(Model 11c);
#delimit;
xtreg MRP_all L5W L5W2 L5income  L5lnPOP  L5gini_gross L5Wgini_gross if NoTax==0, fe i(regyr) vce(cluster regyr);
estimates store m12c, title(Model 12c);

#delimit;
/* Table 8: C:  : Appendix */
estout m9c m10c m11c m12c, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$  L5gini_gross \$GINI_{t-5}$ L5Wgini_gross \$W_{t-5}*GINI_{t-5}$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);		
	
	/*** Control for AR1 error process */

	#delimit;
	tsset ccode year ;
	xtregar ARP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y if NoTax==0, fe ;
estimates store m7d, title(Model 8d);
xtregar ARP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y if NoTax==0, fe ;
estimates store m9d, title(Model 9d);
#delimit;
xtregar ARP_all L5W L5W2 L5income  L5lnPOP L5OilOre L5WOilOre if NoTax==0, fe ;
estimates store m10d, title(Model 10d);
xtregar ARP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y L5OilOre L5WOilOre if NoTax==0, fe ;
estimates store m11d, title(Model 11d);
xtregar ARP_all L5W L5W2 L5income  L5lnPOP  L5gini_gross L5Wgini_gross if NoTax==0, fe ;
estimates store m12d, title(Model 12d);

#delimit;
/* Table 9: D: Appendix */
estout m7d m9d m10d m11d m12d, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$  L5gini_gross \$GINI_{t-5}$ L5Wgini_gross \$W_{t-5}*GINI_{t-5}$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);
	

	
	
/* Plot the residuals for Model 11 */ 
#delimit;
set more off;
	xtreg ARP_all L5W L5W2 L5income  L5lnPOP L5war L5civilwar L5AR_y L5OilOre L5WOilOre if NoTax==0,  fe i(regyr);
	capture drop xb11 res11;predict xb11; gen res11=ARP_all-xb11; 
twoway 
           (scatter res11 xb11 if L5W==0&NoTax==0, msymbol(Sh))
		   (scatter res11 xb11 if L5W<1 &L5W>0 &NoTax==0 ,msymbol(smx))
		   (scatter res11 xb11 if L5W==1&NoTax==0, msymbol(Oh)) 
		   ,legend(label(2 "0<W<1") label(3  "W=1") label(1 "W=0")) ytitle(Regressive      Residuals       Progressive)
		 
		   t1title(Residuals in Model 11);
graph export residual11.pdf,replace;

#delimit;
  twoway         (scatter res11 year if ccode==160 & year <2006 &year>1984, msymbol(Ss)  )
	(scatter res11 year if ccode==140& year <2006 &year>1984, msymbol(Th)  )
	,legend( label(1  "Argentina") label(2 "Brazil"))
	ytitle(Regressive      Residuals       Progressive) xtitle(Year) t1title(Residuals in Model 11);
graph export ResidualArgBra.pdf,replace;
  
#delimit;
twoway 
           (scatter res11 xb11 if L5W==0&NoTax==0, msymbol(Sh) yscale(range(-10,10)))
		  
		   (scatter res11 xb11 if L5W==1&NoTax==0, msymbol(Oh) yscale(range(-10,10))) 
		   , legend(off) ytitle(Residuals) text(5 1 "W=0", place(e)) text(5 8 "W=1", place(e))
		 name(smallbig,replace);
  
 twoway 
           
		   (scatter res11 xb11 if L5W<1 &L5W>0 &NoTax==0 ,msymbol(smx) yscale(range(-10,10)))
		   
		   ,ytitle(Residuals)  text(5 4.5 "0<W<1", place(e))
		  name(middle,replace);
  
  graph combine smallbig middle, row(2) t1title("Residuals in Model 11, by W") ycommon; 
graph export residual11ALT.pdf,replace;


/* Review complained that there was no control for AR process in error structure*/ 
/* Adding AR1 structure suggests a stronger result for W -- footnote this result only */
#delimit;
/* table 2d */
#delimit;
capture qui : tab year,gen(Year);

tsset ccode year ;
xtregar ARP_all L5W L5W2 L5income  L5lnPOP  , fe  ;
estimates store m2d, title(Model 2b);

xtregar ARP_all L5W L5W2 L5income  L5lnPOP  L5OilOre L5WOilOre, fe  ;
estimates store m4d, title(Model 4b);


#delimit;
estout   m2d  m4d  , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   		
   	stats(N N_g rho, fmt(%9.4f) label(N Fixed Effects )) ///
   	style(tex);



#delimit;
xtset ccode year;
xtregar ARP_all L5W L5income  L5lnPOP , fe ;
xtregar ARP_all L5W L5income  L5lnPOP  L5OilOre L5WOilOre, fe ;

/* Examine the proportion of the variance explained by various sources */
#delimit;
xtreg ARP_all L5W L5income  L5lnPOP year L5OilOre L5WOilOre if L5W==1, fe i(ccode) vce(cluster ccode);
xtreg ARP_all L5W L5income  L5lnPOP year L5OilOre L5WOilOre if L5W<1, fe i(ccode) vce(cluster ccode);



/* table 5*/
#delimit;
reg  ginialter L5W L5income L5lnPOP year, cluster(ccode);
estimates store g1, title(Model xx);
reg  ginialter L5W L5income L5lnPOP year ARP_all, cluster(ccode);
estimates store g2, title(Model xx);

/* Robustness  in appendix : Table 2A*/ 
#delimit;
xtreg ARP_all L5Dem L5income  L5lnPOP year, fe i(regyr) vce(cluster regyr);
estimates store m1a, title(Model 1a);
xtreg ARP_all L5Dem L5income  L5lnPOP year, fe i(ccode) vce(cluster ccode);
estimates store m2a, title(Model 2a);
xtreg ARP_all L5Dem L5income  L5lnPOP year L5OilOre L5DemOilOre, fe i(regyr) vce(robust);
estimates store m3a, title(Model 3a);
xtreg ARP_all L5Dem L5income  L5lnPOP year L5OilOre L5DemOilOre, fe i(ccode) vce(cluster ccode);
estimates store m4a, title(Model 4a);


xtlogit flatnotax L5Dem L5income  L5lnPOP , fe i(regyr);
estimates store m5a, title(Model 5a);
xtlogit flatnotax L5Dem L5income  L5lnPOP L5OilOre L5DemOilOre, fe i(regyr);
estimates store m6a, title(Model 6a);

logit flatnotax L5Dem L5income  L5lnPOP year if  AR_4y~=0;
estimates store m5a, title(Model 5a);
logit flatnotax L5Dem L5income  L5lnPOP L5OilOre L5DemOilOre year if  AR_4y~=0 ;
estimates store m6a, title(Model 6a);

#delimit;
estout m1a m2a m3a m4a m5a m6a , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   		
   	stats(N N_g , fmt(%9.4f) label(N Fixed Effects )) ///
   	style(tex);




#delimit;
xtreg ARP_all L5Dem L5income  L5lnPOP year, fe i(ccode) vce(robust);
estimates store m1a, title(Model 1a);
xtreg ARP_all L5Dem L5income  L5lnPOP year L5OilOre L5DemOilOre, fe i(ccode) vce(robust);
estimates store m2a, title(Model 2a);

xtreg MRP_all L5Dem L5income  L5lnPOP year, fe i(ccode) vce(robust);
estimates store m3a, title(Model 3a);
xtreg MRP_all L5Dem L5income  L5lnPOP year L5OilOre L5DemOilOre, fe i(ccode) vce(robust);
estimates store m4a, title(Model 4a);
xtlogit flatnotax L5Dem L5income  L5lnPOP , fe i(regyr);
estimates store m5a, title(Model 5a);
xtlogit flatnotax L5Dem L5income  L5lnPOP  L5OilOre L5DemOilOre , fe i(regyr) ;
estimates store m6a, title(Model 6a);

estout m1a m2a m3a m4a m5a m6a, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	
   	stats(N N_g , fmt(%9.4f) label(N Fixed Effects )) ///
   	style(tex);




/* lag three years */
#delimit;
xtreg ARP_all L3W L3income  L3lnPOP year, fe i(ccode) vce(robust);
estimates store mca, title(Model 1c);
xtreg ARP_all L3W L3income  L3lnPOP year L3OilOre L3WOilOre, fe i(ccode) vce(robust);
estimates store m2c, title(Model 2c);

 	
/*** Box Plots to show effects of Income ARP_all */
#delimit;
graph box ARP_all , over(W)  
 cw ytitle(Redistribution)  name(gini_changeW,replace) ysize(10)  title(Average Rate of Progressivity by W);
/*graph export  "graphs/ARP_by_W.pdf", as(pdf) name(boxploxARP) replace;*/
sort W;
by W: sum gini*;

graph box ARP_all if HiM==1, over(W)  
 cw ytitle(Redistribution)  name(gini_changeW,replace) ysize(10)  title(Average Rate of Progressivity by W)
 subtitle(Middle Income Countries);
/*graph export  "graphs/ARP_by_W_MidIncome.pdf", as(pdf) name(boxplosARP_midIn) replace;*/


/***** Predictions Related to t rate heteroskedacity and W */
/* Prediction that in small W systems the tax rate are more heteroscedsaatic because big difference between rich and poor coalition groups*/
/* in large groups the coalition is much more diverse */ 
#delimit;
sort W;
by W: sum AR_y;
twoway ( kdensity AR_y if W<.75) ( kdensity AR_y if W==.75) 
( kdensity AR_y if W==1), legend(label(1 "W<.75") label(2 "W=.75") label (3 "W=1"));
#delimit;
twoway ( kdensity AR_4y if W<.75) ( kdensity AR_4y if W==.75) 
( kdensity AR_4y if W==1), legend(label(1 "W<.75") label(2 "W=.75") label (3 "W=1"));
#delimit;
capture program drop skedasticreg;
program skedasticreg;
    args lnf xb lnsigma;
  local y "$ML_y1";
  quietly replace `lnf' = ln(normalden(`y', `xb',exp(`lnsigma')));
  end;
#delimit;
capture program drop fancyFIX; 
program define fancyFIX; 
capture drop missx;
egen missx=rmiss($y $x $xs); 
keep if missx==0; 
capture keep $cond;
global z " $y $x ";
sort regyr; 
local k: word count $z;
local count=1; while `count'<=`k' {; 
local temp: word `count' of $z ; 
egen ttt = mean(`temp') $cond  , by(regyr); replace `temp'=`temp'-ttt; drop ttt;
local count=`count'+1;};  
end;
#delimit;
capture program drop fancyFIXccode; 
program define fancyFIXccode; 
capture drop missx;
egen missx=rmiss($y $x $xs); 
keep if missx==0; 
capture keep $cond;
global z " $y $x ";
sort ccode; 
local k: word count $z;
local count=1; while `count'<=`k' {; 
local temp: word `count' of $z ; 
egen ttt = mean(`temp') $cond  , by(ccode); replace `temp'=`temp'-ttt; drop ttt;
local count=`count'+1;};  
end;

  
/* Heteroskedastic regression */
  #delimit;
  use temp,clear; 
   capture gen sL5W=L5W; capture gen sL5W2=L5W2; capture gen sL5income =L5income ; 
   capture gen sL5lnPOP=L5lnPOP;  capture gen syear=year; capture gen sL5AR_y =L5AR_y ; 
   global y " ARP_all"; global x " L5W L5W2 L5income L5lnPOP   ";
   global cond " if NoTax==0 ";
 keep if NoTax==0; 
    /*average band rate*/
 #delimit; 
 fancyFIX;
 ml model lf skedasticreg (xb: ARP_all = L5W L5W2 L5income L5lnPOP   ) 
 (lnsigma:  sL5W sL5W2  sL5income sL5lnPOP ),vce(cluster ccode);
 ml maximize;
  estimates store m13, title(Model 13);
  test L5W L5W2;test L5W+ L5W2=0;  test sL5W sL5W2;test sL5W+ sL5W2=0;
  xtreg ARP_all  L5W L5W2 L5income L5lnPOP, fe i(regyr); 
  #delimit;
  use temp,clear; 
   capture gen sL5W=L5W; capture gen sL5W2=L5W2; capture gen sL5income =L5income ; 
   capture gen sL5lnPOP=L5lnPOP;  capture gen syear=year; capture gen sL5AR_y =L5AR_y ; 
   global y " ARP_all"; global x " L5W L5W2 L5income L5lnPOP  L5AR_y L5war L5civilwar ";
   global cond " if NoTax==0 ";
 keep if NoTax==0; 
 fancyFIX;
  
  #delimit; 
 ml model lf skedasticreg (xb: ARP_all = L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar) 
 (lnsigma:  sL5W sL5W2  sL5income sL5lnPOP  sL5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m14, title(Model 14);
  test L5W L5W2;test L5W+ L5W2=0;  test sL5W sL5W2;test sL5W+ sL5W2=0; 
    xtreg ARP_all  L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar, fe i(regyr);
 #delimit;
  use temp,clear; 
   capture gen sL5W=L5W; capture gen sL5W2=L5W2; capture gen sL5income =L5income ; 
   capture gen sL5lnPOP=L5lnPOP;  capture gen syear=year; capture gen sL5AR_y =L5AR_y ; 
   global y " ARP_all"; global x " L5W L5W2 L5income L5lnPOP  L5AR_y L5war L5civilwar L5OilOre L5WOilOre";
   global cond " if NoTax==0 ";
 keep if NoTax==0; 
 fancyFIX;
  
  #delimit; 
 ml model lf skedasticreg (xb: ARP_all = L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar L5OilOre L5WOilOre) 
 (lnsigma:  sL5W sL5W2  sL5income sL5lnPOP  sL5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m15, title(Model 15);
   test L5W L5W2;test L5W+ L5W2=0;  test sL5W sL5W2;test sL5W+ sL5W2=0;
   xtreg ARP_all  L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar L5OilOre L5WOilOre, fe i(regyr);
  #delimit;

  use temp,clear; 
   capture gen sL5W=L5W; capture gen sL5W2=L5W2; capture gen sL5income =L5income ; 
   capture gen sL5lnPOP=L5lnPOP;  capture gen syear=year; capture gen sL5AR_y =L5AR_y ; 
   global y " ARP_all"; global x " L5W L5W2 L5income L5lnPOP  L5gini_gross L5Wgini_gross";
   global cond " if NoTax==0 ";
 keep if NoTax==0; 
 fancyFIX;
 
  #delimit; 
 ml model lf skedasticreg (xb: ARP_all = L5W L5W2 L5income L5lnPOP L5gini_gross L5Wgini_gross) 
 (lnsigma:  sL5W sL5W2  sL5income sL5lnPOP  sL5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m16, title(Model 16);
   test L5W L5W2;test L5W+ L5W2=0;  test sL5W sL5W2;test sL5W+ sL5W2=0;
   xtreg ARP_all  L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar L5OilOre L5WOilOre, fe i(regyr);
  #delimit;
  
  /* Table 6 */
estout m13 m14 m15 m16 , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	\_cons L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$ 
	sL5W \$W_{t-5}$ sL5W2 \$W^{2}_{t-5}$ sL5income \$ln(Income_{t-5})$
	sL5lnPOP \$ln(Population_{t-5})$ 
	sL5AR_y \$Avg.Tax_{t-5}$ )
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);

	
/*  Robustness tests: do without fixed effects */ 
  
  #delimit; 
  use temp,clear;
  
  ml model lf skedasticreg (xb: ARP_all = L5Dem L5Dem2 L5income L5lnPOP   ) 
 (lnsigma:  L5Dem L5Dem2  L5income L5lnPOP ),vce(cluster ccode);
 ml maximize;
  estimates store m13a, title(Model 13a);
  
  ml model lf skedasticreg (xb: ARP_all = L5Dem L5Dem2 L5income L5lnPOP L5AR_y L5war L5civilwar) 
 (lnsigma:  L5Dem L5Dem2  L5income L5lnPOP L5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m14a, title(Model 14a);
  
  ml model lf skedasticreg (xb: ARP_all = L5Dem L5Dem2 L5income L5lnPOP L5AR_y L5war L5civilwar L5OilOre L5DemOilOre) 
 (lnsigma:  L5Dem L5Dem2  L5income L5lnPOP L5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m15a, title(Model 15a);
  ml model lf skedasticreg (xb: ARP_all =  L5Dem L5Dem2 L5income  L5lnPOP  L5gini_gross L5Demgini_gross) 
 (lnsigma:  L5Dem L5Dem2  L5income L5lnPOP L5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m16a, title(Model 16a);
  
  #delimit;
  /* Table 10 : appendix*/ 
estout m13a m14a m15a m16a , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L5Dem \$Demo_{t-5}$ L5Dem2 \$Demo^{2}_{t-5}$  L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5DemOilOre \$Demo_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$  L5gini_gross \$GINI_{t-5}$ L5Demgini_gross \$Demo_{t-5}*GINI_{t-5}$)
   
   	stats(N , fmt(%9.0f) label(N  )) ///
   	style(tex);

  
  
  #delimit; 
  use temp,clear;
  
 ml model lf skedasticreg (xb: ARP_all = L3W L3W2 L3income L3lnPOP   ) 
 (lnsigma:  L3W L3W2  L3income L3lnPOP ),vce(cluster ccode);
 ml maximize;
  estimates store m13b, title(Model 13b);
  
  ml model lf skedasticreg (xb: ARP_all = L3W L3W2 L3income L3lnPOP L3AR_y L3war L3civilwar) 
 (lnsigma:  L3W L3W2  L3income L3lnPOP  L3AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m14b, title(Model 14b);
  
 ml model lf skedasticreg (xb: ARP_all = L3W L3W2 L3income L3lnPOP L3AR_y L3war L3civilwar L3OilOre L3WOilOre) 
 (lnsigma:  L3W L3W2  L3income L3lnPOP  L3AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m15b, title(Model 15b);
  ml model lf skedasticreg (xb: ARP_all =  L3W L3W2 L3income  L3lnPOP  L3gini_gross L3Wgini_gross) 
 (lnsigma:  L3W L3W2  L3income L3lnPOP  L3AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m16b, title(Model 16b);
  
  
  #delimit;
  /* Table 11 : appendix*/ 
estout m13b m14b m13b m16b , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant L3W \$W_{t-3}$ L3W2 \$W^{2}_{t-3}$ L3income \$ln(Income_{t-3})$
	L3lnPOP \$ln(Population_{t-3})$ year Year L3OilOre \$OilOre_{t-3}$ L3WOilOre \$W_{t-3}*OilOre_{t-3}$ 
	L3AR_y \$Avg.Tax_{t-3}$ L3war \$War_{t-3}$  L3civilwar \$CivilWar_{t-3}$ 
	sL3W \$W_{t-3}$ sL3W2 \$W^{2}_{t-3}$ sL3income \$ln(Income_{t-3})$
	sL3lnPOP \$ln(Population_{t-3})$ 
	sL3AR_y \$Avg.Tax_{t-3}$ L3gini_gross \$GINI_{t-3}$ L3Wgini_gross \$W_{t-3}*GINI_{t-3}$)
   	stats(N N_g , fmt(%9.0f) label(N  )) ///
   	style(tex);
   	

	 #delimit; 
  use temp,clear;

 ml model lf skedasticreg (xb: MRP_all = L5W L5W2 L5income L5lnPOP   ) 
 (lnsigma:  L5W L5W2  L5income L5lnPOP ),vce(cluster ccode);
 ml maximize;
  estimates store m13c, title(Model 13c);
  
  ml model lf skedasticreg (xb: MRP_all = L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar) 
 (lnsigma:  L5W L5W2  L5income L5lnPOP  L5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m14c, title(Model 14c);
  
 ml model lf skedasticreg (xb: MRP_all = L5W L5W2 L5income L5lnPOP L5AR_y L5war L5civilwar L5OilOre L5WOilOre) 
 (lnsigma:  L5W L5W2  L5income L5lnPOP  L5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m15c, title(Model 15c);
  ml model lf skedasticreg (xb: MRP_all =  L5W L5W2 L5income  L5lnPOP  L5gini_gross L5Wgini_gross) 
 (lnsigma:  L5W L5W2  L5income L5lnPOP  L5AR_y),vce(cluster ccode);
 ml maximize;
  estimates store m16c, title(Model 16c);
  
  
  #delimit;
    /* Table 12 : appendix*/
estout m13c m14c m15c m16c , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	\_cons L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$ 
	sL5W \$W_{t-5}$ sL5W2 \$W^{2}_{t-5}$ sL5income \$ln(Income_{t-5})$
	sL5lnPOP \$ln(Population_{t-5})$ 
	sL5AR_y \$Avg.Tax_{t-5}$ L5gini_gross \$GINI_{t-5}$ L5Wgini_gross \$W_{t-5}*GINI_{t-5}$)
   	stats(N N_g , fmt(%9.0f) label(N  )) ///
   	style(tex);
   		
	
	
	
	
	
	


  
 /********* Redistribution and Inequality ***********/
 
 #delimit;

xtreg ginialter L5W L5W2 L5income L5lnPOP  ,fe i(regyr);
estimates store m17, title(Model 17);test L5W L5W2; test L5W+L5W2=0;

xtreg ginialter L5W L5W2 L5income L5lnPOP L5OilOre L5WOilOre ,fe i(regyr);
estimates store m18, title(Model 18);test L5OilOre+ L5WOilOre=0;test L5W L5W2; test L5W+L5W2=0;
xtreg ginialter L5W L5W2 L5income L5lnPOP L5OilOre L5WOilOre L5war L5civilwar L5AR_y ,fe i(regyr);
estimates store m19, title(Model 19);
test L5OilOre+ L5WOilOre=0;test L5W L5W2; test L5W+L5W2=0;
xtreg ginialter L5W L5W2 L5income L5lnPOP L5OilOre L5WOilOre L5war L5civilwar L5AR_y L5gini_gross L5Wgini_gross,fe i(regyr);
estimates store m20, title(Model 20);
test L5OilOre+ L5WOilOre=0;test L5W L5W2; test L5W+L5W2=0;


xtreg ginialter L5Dem L5income L5lnPOP , fe i(ccode); 
estimates store m9a, title(Model 9A);
xtreg ginialter L5Dem L5income L5lnPOP , fe i(regyr); 
estimates store m10a, title(Model 10A);
xtreg ginialter L5Dem L5income L5lnPOP L5OilOre L5DemOilOre , fe i(ccode); 
estimates store m11a, title(Model 11A);
xtreg ginialter L5Dem L5income L5lnPOP L5OilOre L5DemOilOre , fe i(regyr); 
estimates store m12a, title(Model 12A);

  #delimit;
  /* Table 13 Appendix */ 
estout m17 m18 m19 m20, cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	\_cons L5W \$W_{t-5}$ L5W2 \$W^{2}_{t-5}$ L5income \$ln(Income_{t-5})$
	L5lnPOP \$ln(Population_{t-5})$ year Year L5OilOre \$OilOre_{t-5}$ L5WOilOre \$W_{t-5}*OilOre_{t-5}$ 
	L5AR_y \$Avg.Tax_{t-5}$ L5war \$War_{t-5}$  L5civilwar \$CivilWar_{t-5}$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex);


/*********************************************/
/*********************************************/
/* Organize the data into five year averages */ 
/*********************************************/
/*********************************************/
#delimit;
use temp,clear; 

gen last = 1 if (year==1985|year==1990|year==1995|year==2000|year==2005);
capture drop period;
gen period =1 if year>1980&year<=1985;
replace period =2 if year>1985&year<=1990;
replace period =3 if year>1990&year<=1995;
replace period =4 if year>1995&year<=2000;
replace period =5 if year>2000&year<=2005;
/* gen LC=Leaders-1;*/
gen ARP_allEnd=ARP_all if last==1; 
gen AR_4yEnd=AR_4y if last==1; 
gen sdARP=ARP_all;
keep ARP_allE sdARP worldbankcode regyr ARP_all AR_y gini_gross  war civilwar MRP_all AR_y AR_4y* demaut ccode longname W  OILORE lnGDPpc WOILlnGDP lnPOP ginialter ccode year period;
collapse (sd) sdARP (mean)  ARP_allEnd regyr AR_y war gini_gross  civilwar ARP_all MRP_all  AR_4y* demaut W  OILORE lnGDPpc WOILlnGDP lnPOP ginialter, by(ccode period);
gen WOILORE=W*OILORE; gen ratio =ARP_all/sd;
gen groupW= 0;replace groupW=1 if W>.6;replace groupW=2 if W>.9;
sort groupW; by groupW: sum ratio ARP_all sd;
gen W2=W^2; gen Wgini_gross=W*gini_gross;
twoway (kdensity sd if groupW==0) (kdensity sd if groupW==1) (kdensity sd if groupW==2)  ;

twoway (kdensity ratio if groupW==0) (kdensity ratio if groupW==1) (kdensity ratio if groupW==2)  ;
#delimit;
xtreg ARP_allE W W2 lnGDPpc lnPOP   , fe i(regyr) vce(robust); 
estimates store m21, title(Model 21);
xtreg ARP_allE W W2 lnGDPpc lnPOP  OILORE WOILORE  , fe i(regyr) vce(cluster regyr);
estimates store m22, title(Model 22);
xtreg ARP_allE W W2 lnGDPpc lnPOP  OILORE WOILORE AR_y war civilwar  , fe i(regyr) vce(cluster regyr);
estimates store m23, title(Model 23);
xtreg ARP_allE W W2 lnGDPpc lnPOP   OILORE WOILORE AR_y war civilwar gini_gross Wgini_gross  , fe i(regyr) vce(cluster regyr);
estimates store m24, title(Model 24);

 #delimit;
 /* Table 14 Appendix */
estout m21 m22 m23 m24 , cells(b(star  fmt(%9.4f)) se(par fmt(%9.3f))) ///
	starlevels(* 0.10 ** 0.05 *** 0.01) ///
   	legend label ///
   	varlabel(_cons	Constant W \$W$ W2 \$W^{2}$ lnGDPpc \$ln(Income)$
	lnPOP \$ln(Population)$ year Year OILORE \$OilOre$ WOILORE \$W*OilOre$ 
	AR_y \$Avg.Tax$ war \$War$  civilwar \$CivilWar$ 
	gini_gross \$GINI$ Wgini_gross \$W*GINI$)
   	stats(N N_g , fmt(%9.0f) label(N Fixed Effects )) ///
   	style(tex); 
 
/* Organize graphs and tables of basic statistics */
#delimit;
use  temp,clear; 
/****************************************************************/
/****************************************************************/
/********* show construction with a graph ***********************/ 
/****************************************************************/
/****************************************************************/
 
keep  GDPpcWB AR* year ccode id_un name_un ARP_all  HiMidLow MR* W demaut S gini_net gini_gross ginialter;
keep if ARP_all ~=.;
expand 4;
sort id_un year;
by id_un year: gen y=_n;
gen rate = AR_y if y==1;
replace rate = AR_2y if y==2;
replace rate = AR_3y if y==3;
replace rate = AR_4y if y==4;
gen lnY=ln(y);
#delimit;
regress rate lnY if ccode==2 &year==1990;
li ARP* if ccode==2 &year==1990;
gen income =GDPpc*y ;
gen logincome=ln(income);
label var rate "Avg. Tax Rate";
label var logincome "Log(Income)";


gen marker ="";
replace marker ="US,1981" if ccode==2 &year==1981 &y==4;
replace marker ="US,1985" if ccode==2 &year==1985&y==4;
replace marker ="US,1990" if ccode==2 &year==1990&y==4;
replace marker ="US,2004" if ccode==2 &year==2004&y==4;

replace marker ="UK,1997" if ccode==200 &year==1997;
replace marker ="UK,2002" if ccode==200 &year==2002;
replace marker ="UK,2005" if ccode==200 &year==2005;


#delimit; 
/* US */
 twoway (scatter rate logincome  if ccode==2 &year==1990, msymbol(circle)   mlabel(marker)) 
 (lfit rate logincome  if ccode==2 &year==1990,  lpattern(solid))
 (scatter rate logincome  if ccode==2 &year==1985,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate logincome  if ccode==2 &year==1985,  lpattern(dash))
 (scatter rate logincome  if ccode==2 &year==2004,   mlabel(marker) msymbol(square) ) 
 (lfit rate logincome  if ccode==2 &year==2004,  lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(US: Tax Rate Progressvity);
 /*graph export "graphs/US_Progressivity.pdf" ,as(pdf) replace;*/
/* UK */
#delimit;
 twoway (scatter rate logincome  if ccode==200 &year==1997, msymbol(circle)   mlabel(marker)) 
 (lfit rate logincome  if ccode==200 &year==1997,  lpattern(solid))
 (scatter rate logincome  if ccode==200 &year==2002,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate logincome  if ccode==200 &year==2002,lpattern(dash))
 (scatter rate logincome  if ccode==200 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate logincome  if ccode==200 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(UK: Tax Rate Progressvity);
 /*graph export "graphs/UK_Progressivity.pdf" ,as(pdf) replace;*/
 
 /* Argentina */ 
 replace marker ="ARG,1985" if ccode==160 &year==1985;
replace marker ="ARG,1995" if ccode==160 &year==1995;
replace marker ="ARG,2005" if ccode==160 &year==2005;
 #delimit;
 twoway (scatter rate logincome  if ccode==160 &year==1985, msymbol(circle)   mlabel(marker)) 
 (lfit rate logincome  if ccode==160 &year==1985,  lpattern(solid))
 (scatter rate logincome  if ccode==160 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate logincome  if ccode==160 &year==1995,lpattern(dash))
 (scatter rate logincome  if ccode==160 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate logincome  if ccode==160 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(Argentina: Tax Rate Progressvity);
/*graph export "graphs/ArgProgressivity.pdf" ,as(pdf) replace;*/
 
 
 /* Mexico */ 
 #delimit;
 replace marker ="MEX,1985" if ccode==70 &year==1985;
replace marker ="MEX,1995" if ccode==70 &year==1995;
replace marker ="MEX,2005" if ccode==70 &year==2005;
 #delimit;
 twoway (scatter rate logincome  if ccode==70 &year==1985, msymbol(circle)   mlabel(marker)) 
 (lfit rate logincome  if ccode==70 &year==1985,  lpattern(solid))
 (scatter rate logincome  if ccode==70 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate logincome  if ccode==70 &year==1995,lpattern(dash))
 (scatter rate logincome  if ccode==70 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate logincome  if ccode==70 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(Mexico: Tax Rate Progressvity);
/*graph export "graphs/MexProgressivity.pdf" ,as(pdf) replace;*/

 /* South Korea */ 
 #delimit;
 replace marker ="KOR,1985" if ccode==732 &year==1985;
replace marker ="KOR,1995" if ccode==732 &year==1995;
replace marker ="KOR,2005" if ccode==732 &year==2005;
 #delimit;
 twoway (scatter rate y  if ccode==732 &year==1985, msymbol(circle)   mlabel(marker)) 
 (lfit rate y  if ccode==732 &year==1985,  lpattern(solid))
 (scatter rate y  if ccode==732 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate y  if ccode==732 &year==1995,lpattern(dash))
 (scatter rate y  if ccode==732 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate y  if ccode==732 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(S. Korea: Tax Rate Progressvity);
/* graph export "graphs/KoreaProgressivity.pdf" ,as(pdf) replace;*/

/* India and Pakistan */

 #delimit;
 replace marker ="IND,1985" if ccode==750 &year==1985;
replace marker ="IND,1995" if ccode==750 &year==1995;
replace marker ="IND,2005" if ccode==750 &year==2005;
 #delimit;
 twoway (scatter rate y  if ccode==750 &year==1985, msymbol(circle)   mlabel(marker)) 
 (lfit rate y if ccode==750 &year==1985,  lpattern(solid))
 (scatter rate y if ccode==750 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate y if ccode==750 &year==1995,lpattern(dash))
 (scatter rate y  if ccode==750 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate y if ccode==750 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(India: Tax Rate Progressvity);
/*graph export "graphs/IndiaProgressivity.pdf" ,as(pdf) replace;*/

 #delimit;
 replace marker="" if ccode==770;
 replace marker ="PAK,1985" if ccode==770 &year==1985 &y==3;
replace marker ="PAK,1995" if ccode==770 &year==1995&y==3;
replace marker ="PAK,2005" if ccode==770 &year==2005&y==3;
 #delimit;

 twoway (scatter rate y  if ccode==770 &year==1985, log msymbol(circle)   mlabel(marker)) 
 (lfit rate y if ccode==770 &year==1985,  lpattern(solid)  lwidth(medthick))
 (scatter rate y if ccode==770 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate y if ccode==770 &year==1995,lpattern(dash) lwidth(medthick))
 (scatter rate y  if ccode==770 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate y if ccode==770 &year==2005,lpattern(dot) lwidth(thick)), legend(off) ytitle("Avg. Tax Rate") 
 xtitle("Income (in multiples of GDPpc)")  title(Pakistan: Tax Rate Progressvity)
 text(3 3.5 "W=.75", place(e))   text(1.7 3.5 "W=.25", place(e))  text(.4 3.5 "W=.0", place(e));
graph export "graphs/PakistanProgressivity.pdf" ,as(pdf) replace;

#delimit;
 twoway (scatter rate logincome   if ccode==770 &year==1985, msymbol(circle) mlabel(marker)) 
 (lfit rate logincome  if ccode==770 &year==1985,  lpattern(solid))
 (scatter rate logincome  if ccode==770 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate logincome  if ccode==770 &year==1995,lpattern(dash))
 (scatter rate logincome   if ccode==770 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate logincome  if ccode==770 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(Pakistan: Tax Rate Progressvity);
/*graph export "graphs/PakistanProgressivity2.pdf" ,as(pdf) replace;*/


 #delimit;
 replace marker ="GHA,1982" if ccode==452 &year==1982;
replace marker ="GHA,1995" if ccode==452 &year==1995;
replace marker ="GHA,2005" if ccode==452 &year==2005;
#delimit;
 twoway (scatter rate logincome   if ccode==452 &year==1982, msymbol(circle)   mlabel(marker)) 
 (lfit rate logincome   if ccode==452 &year==1982,  lpattern(solid))
 (scatter rate logincome   if ccode==452 &year==1995,  msymbol(triangle)  mlabel(marker)) 
 (lfit rate logincome   if ccode==452 &year==1995,lpattern(dash))
 (scatter rate logincome   if ccode==452 &year==2005,   mlabel(marker) msymbol(square) ) 
 (lfit rate logincome   if ccode==452 &year==2005,lpattern(dot)), legend(off) ytitle("Avg. Tax Rate")  title(Ghana: Tax Rate Progressvity);
 /*graph export "graphs/GhanaProgressivity.pdf" ,as(pdf) replace;*/
#delimit;

table W HiMidLow  if ARP_all~=. , c( mean MRP_all freq);
sort W; by W: sum MRP_all;
sort HiMidL; by HiMidL: sum MRP_all;
table W HiM if ginia~=. , c(mean gini_net mean gini_gross mean ginia freq); 


#delimit;
graph box rate if rate<60, over(y) over(W) 
 cw ytitle(Avg. Tax Rate) name(Wincome,replace) ysize(10) by(HiMi, cols(1)) by(,title(Tax Rates by W and Income));
/*graph export  "graphs/taxRateWincome.pdf", as(pdf) name(taxrateWincome) replace;*/

#delimit;
graph box ginia , over(W)  
 cw ytitle(Redistribution) name(gini_change,replace) ysize(10) by(HiMi, cols(1)) by(,title(Change in Gini));

#delimit;
graph box ginia , over(W)  
 cw ytitle(Redistribution)  name(gini_changeW,replace) ysize(10)  title(Change in Gini by Coalition Size);
/*graph export  "graphs/gini_change.pdf", as(pdf) name(gini_change) replace;*/

#delimit;/* this graph is restricted to observations for which we have tax progressity data */
graph box ginia if HiM==1 & ARP_all ~=., over(W)  
 cw ytitle(Redistribution)  name(gini_changeW,replace) ysize(10)  title(Change in Gini by Coalition Size)
 subtitle(Middle Income Countries);
*/graph export  "graphs/gini_changeMidIncome.pdf", as(pdf) name(gini_changeMidIncome) replace;*/

#delimit;
use temp,clear;
/* this graph replicates the graph above but includes all possible observation ( note main difference is extra observations for W=0 nations */
graph box ginia if HiM==1 , over(W)  
 cw ytitle(Redistribution)  name(gini_changeW,replace) ysize(10)  title(Change in Gini by Coalition Size)
 subtitle(Middle Income Countries);
*/graph export  "graphs/gini_changeMidIncome.pdf", as(pdf) name(gini_changeMidIncome) replace;*/




