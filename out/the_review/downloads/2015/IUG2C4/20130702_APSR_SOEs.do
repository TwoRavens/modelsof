
/*June 27, 2013--- Creation of Instrument from GSO Enterprise Census Data*/

/*Set-Up*/
#delimit;
set more off;
log using soe_investment.smcl, replace;


/*I have created a folder called census stacked, where I have stored all the DN Modules from the Enterprise Census*/
cd "C:\Users\ejm5\Dropbox\GSO Enterprise Census (1)";



/********************************************************Open 2011 Census Data**************************/

#delimit;
use dn2011.dta, clear;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts251	"The cost of construction in progress at the beginning of the year";
lab var ts252	"The cost of construction in progress at the ending of the year";
lab var ts381	"Total capital sources at the beginning of the year";
lab var ts382	"Total capital sources at the ending of the year";
lab var ts391	"Liabilities at the beginning of the year";
lab var ts392	"Liabilities at the ending of the year";
lab var ts401	"Equity at the beginning of the year";
lab var ts402	"Equity at the ending of the year";




#delimit;
drop if lhdn>5;
generate central_soe=1 if lhdn==1|lhdn==3;
replace central_soe=0 if lhdn==2|lhdn==4|lhdn==5;

destring  tinh, generate(tinh_no);
lab var tinh_no "GSO Province Code)";
sort tinh_no;
merge tinh_no using "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\pci_id_crosswalk2.dta";
order pci_id;

#delimit;
collapse (mean) von_nn ts11 ts12 kqkdc ld11 ld21 (sum) sum_ts11=ts11 sum_ts12=ts12 sum_ld11=ld11 sum_ld12=ld12 ts251 ts252 ts381 ts382 ts391 ts392 ts401 ts402, by(pci_id central_soe);
generate year=2011;


/*sum ts391, detail;
drop if ts391>=r(p99);
drop if ts391<=r(p1);
sum ts401, detail;
drop if ts401>=r(p99);
drop if ts401<=r(p1);*/



drop if pci_id==.;
rename ts251 ts201;
rename ts252 ts202;
rename ts381 ts211;
rename ts382 ts212;
rename ts391 ts221;
rename ts392 ts222;
rename ts401 ts231;
rename ts402 ts232;

save "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\SOE_2011.dta", replace;


/********************************************************Open 2010 Census Data**************************/
#delimit;
use dn2010.dta, clear;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts201	"The cost of construction in progress at the beginning of the year";
lab var ts202	"The cost of construction in progress at the ending of the year";
lab var ts211	"Total capital sources at the beginning of the year";
lab var ts212	"Total capital sources at the ending of the year";
lab var ts221	"Liabilities at the beginning of the year";
lab var ts222	"Liabilities at the ending of the year";
lab var ts231	"Equity at the beginning of the year";
lab var ts232	"Equity at the ending of the year";

#delimit;
drop if lhdn>5;
generate central_soe=1 if lhdn==1|lhdn==3;
replace central_soe=0 if lhdn==2|lhdn==4|lhdn==5;

destring  tinh, generate(tinh_no);
lab var tinh_no "GSO Province Code)";
sort tinh_no;
merge tinh_no using "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\pci_id_crosswalk2.dta";
order pci_id;


#delimit;
collapse (mean) von_nn ts11 ts12 kqkdc ld11 ld21 (sum) sum_ts11=ts11 sum_ts12=ts12 sum_ld11=ld11 sum_ld12=ld12 ts201 ts202 ts211 ts212 ts221 ts222 ts231 ts232, by(pci_id central_soe);
generate year=2010;

/*sum ts221, detail;
drop if ts221>=r(p99);
drop if ts221<=r(p1);
sum ts231, detail;
drop if ts231>=r(p99);
drop if ts231<=r(p1);
drop if pci_id==.;*/

save "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\SOE_2010.dta", replace;


/********************************************************Open 2009 Census Data**************************/
#delimit;
use dn2009.dta, clear;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts201	"The cost of construction in progress at the beginning of the year";
lab var ts202	"The cost of construction in progress at the ending of the year";
lab var ts211	"Total capital sources at the beginning of the year";
lab var ts212	"Total capital sources at the ending of the year";
lab var ts221	"Liabilities at the beginning of the year";
lab var ts222	"Liabilities at the ending of the year";
lab var ts231	"Equity at the beginning of the year";
lab var ts232	"Equity at the ending of the year";

#delimit;
drop if lhdn>5;
generate central_soe=1 if lhdn==1|lhdn==3;
replace central_soe=0 if lhdn==2|lhdn==4|lhdn==5;

destring  tinh, generate(tinh_no);
lab var tinh_no "GSO Province Code)";
sort tinh_no;
merge tinh_no using "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\pci_id_crosswalk2.dta";
order pci_id;

#delimit;
collapse (mean) von_nn ts11 ts12 kqkdc ld11 ld21 (sum) sum_ts11=ts11 sum_ts12=ts12 sum_ld11=ld11 sum_ld12=ld12 ts201 ts202 ts211 ts212 ts221 ts222 ts231 ts232, by(pci_id central_soe);
generate year=2009;

/*drop if pci_id==.;
sum ts221, detail;
drop if ts221>=r(p99);
drop if ts221<=r(p1);
sum ts231, detail;
drop if ts231>=r(p99);
drop if ts231<=r(p1);*/

save "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\SOE_2009.dta", replace;

/********************************************************Open 2008 Census Data**************************/
#delimit;
use dn2008.dta, clear;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts201	"The cost of construction in progress at the beginning of the year";
lab var ts202	"The cost of construction in progress at the ending of the year";
lab var ts211	"Total capital sources at the beginning of the year";
lab var ts212	"Total capital sources at the ending of the year";
lab var ts221	"Liabilities at the beginning of the year";
lab var ts222	"Liabilities at the ending of the year";
lab var ts231	"Equity at the beginning of the year";
lab var ts232	"Equity at the ending of the year";

#delimit;
drop if lhdn>5;
generate central_soe=1 if lhdn==1|lhdn==3;
replace central_soe=0 if lhdn==2|lhdn==4|lhdn==5;

destring  tinh, generate(tinh_no);
lab var tinh_no "GSO Province Code)";
sort tinh_no;
merge tinh_no using "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\pci_id_crosswalk2.dta";
order pci_id;


#delimit;
collapse (mean) von_nn ts11 ts12 kqkdc ld11 ld21 (sum) sum_ts11=ts11 sum_ts12=ts12 sum_ld11=ld11 sum_ld12=ld12 ts201 ts202 ts211 ts212 ts221 ts222 ts231 ts232, by(pci_id central_soe);
generate year=2008;
drop if pci_id==.;



save "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\SOE_2008.dta", replace;

/********************************************************Open 2007 Census Data**************************/
#delimit;
use dn2007.dta, clear;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts201	"The cost of construction in progress at the beginning of the year";
lab var ts202	"The cost of construction in progress at the ending of the year";
lab var ts211	"Total capital sources at the beginning of the year";
lab var ts212	"Total capital sources at the ending of the year";
lab var ts221	"Liabilities at the beginning of the year";
lab var ts222	"Liabilities at the ending of the year";
lab var ts231	"Equity at the beginning of the year";
lab var ts232	"Equity at the ending of the year";

#delimit;
drop if lhdn>5;
generate central_soe=1 if lhdn==1|lhdn==3;
replace central_soe=0 if lhdn==2|lhdn==4|lhdn==5;

destring  tinh, generate(tinh_no);
lab var tinh_no "GSO Province Code)";
sort tinh_no;
merge tinh_no using "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\pci_id_crosswalk2.dta";
order pci_id;




#delimit;
collapse (mean) von_nn ts11 ts12 kqkdc ld11 ld21 (sum) sum_ts11=ts11 sum_ts12=ts12 sum_ld11=ld11 sum_ld12=ld12 ts201 ts202 ts211 ts212 ts221 ts222 ts231 ts232, by(pci_id central_soe);
generate year=2007;

/*drop if pci_id==.;
sum ts221, detail;
drop if ts221>=r(p99);
drop if ts221<=r(p1);
sum ts231, detail;
drop if ts231>=r(p99);
drop if ts231<=r(p1);*/

save "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\SOE_2007.dta", replace;

/********************************************************Open 2006 Census Data**************************/
#delimit;
use dn2006.dta, clear;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts171	"The cost of construction in progress at the beginning of the year";
lab var ts172	"The cost of construction in progress at the ending of the year";
lab var ts181	"Total capital sources at the beginning of the year";
lab var ts182	"Total capital sources at the ending of the year";
lab var ts191	"Liabilities at the beginning of the year";
lab var ts192	"Liabilities at the ending of the year";
lab var ts201	"Equity at the beginning of the year";
lab var ts201	"Equity at the ending of the year";


#delimit;
drop if lhdn>5;
generate central_soe=1 if lhdn==1|lhdn==3;
replace central_soe=0 if lhdn==2|lhdn==4|lhdn==5;

destring  tinh, generate(tinh_no);
lab var tinh_no "GSO Province Code)";
sort tinh_no;
merge tinh_no using "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\pci_id_crosswalk2.dta";
order pci_id;

;


#delimit;
collapse (mean) von_nn ts11 ts12 kqkdc ld11 ld21 (sum) sum_ts11=ts11 sum_ts12=ts12 sum_ld11=ld11 sum_ld12=ld12 ts171 ts172 ts181 ts182 ts191 ts192 ts201 ts202, by(pci_id central_soe);
generate year=2006;
drop if pci_id==.;
sum ts191, detail;
drop if ts191>=r(p99);
drop if ts191<=r(p1);
sum ts201, detail;
drop if ts201>=r(p99);
drop if ts201<=r(p1);
rename ts201 ts231;
rename ts202 ts232;
rename ts171 ts201;
rename ts172 ts202;
rename ts181 ts211;
rename ts182 ts212;
rename ts191 ts221;
rename ts192 ts222;


save "C:\Users\ejm5\Dropbox\District People Councils\Statafiles\SOE_2006.dta", replace;

/*******************************************************************CREATE FUll DATA SET**************************/
#delimit;
cd "C:\Users\ejm5\Dropbox\District People Councils\Statafiles";
use SOE_2011.dta, clear;
append using SOE_2010.dta;
append using SOE_2009.dta;
append using SOE_2008.dta;
append using SOE_2007.dta;
append using SOE_2006.dta;
order year pci_id central_soe;

#delimit;
lab var ts11 "Total Assets at Beginning of Year";
lab var ts12 "Total Assets at End of Year";
lab var kqkdc "Net Revenue by Main Economic Activity";
lab var ld11 "Employees at Beginning of Year";
lab var ld21 "Employees at End of Year";
lab var ts201	"The cost of construction in progress at the beginning of the year";
lab var ts202	"The cost of construction in progress at the ending of the year";
lab var ts211	"Total capital sources at the beginning of the year";
lab var ts212	"Total capital sources at the ending of the year";
lab var ts221	"Liabilities at the beginning of the year";
lab var ts222	"Liabilities at the ending of the year";
lab var ts231	"Equity at the beginning of the year";
lab var ts232	"Equity at the ending of the year";
lab var sum_ts11 "Sum of assets at beginning of year";
lab var sum_ts12 "Sum of assets at end of year";
lab var  sum_ld11 "Sum of labor at beginning of year";
lab var  sum_ld12 "Sum of labor at end of year";

sort year pci_id central_soe;
save ts_province_SOE_data.dta, replace;

******************************Investment Data*************************************/

#delimit;
set more off;
use "C:\Users\ejm5\Dropbox\GSO Enterprise Census (1)\20130623_PanelData\2005to2011_panel.dta", clear;

#delimit;
drop if year==2005;
drop if ent_type>5;
generate central_soe=1 if ent_type==1|ent_type==3;
replace central_soe=0 if ent_type==2|ent_type==4|ent_type==5;


sum investment, detail;
drop if investment>=r(p99);
drop if investment<=r(p1);


#delimit;
collapse (sum) investment, by(year pci_id central_soe);

sort year pci_id central_soe;
save ts_province_SOEinv_data.dta, replace;

/*******************Merge in Investment Data****************************************/

merge year pci_id central_soe using ts_province_SOE_data.dta;
save ts_province_SOE_final_data.dta, replace;

drop _merge;
sort pci_id year;
merge pci_id year using population.dta;

#delimit;
drop _merge;
sort pci_id year;
merge pci_id year using gdp.dta;

#delimit;
drop _merge;
sort pci_id year;
merge pci_id year using nominal_gdp_long.dta;

rename  pop_stacked population;
replace population=population*1000;
generate city=1 if pci_id<=5;
replace city=0 if pci_id>5;

#delimit;
generate treatment=1 if pci_id==67|pci_id==2|pci_id==53|pci_id==47|pci_id==10|pci_id==3|pci_id==15|pci_id==4|pci_id==33|pci_id==22;
replace treatment=0 if treatment==.;


#delimit;
generate capital_gdp=(ts211*1000000)/(nominalgdp_*1000000000);
generate liabilities_gdp=(ts221*1000000)/(nominalgdp_*1000000000);
generate equity_gdp=(ts231*1000000)/(nominalgdp_*1000000000);
generate assets_gdp=(ts11*1000000)/(nominalgdp_*1000000000);
generate invest_gdp=(investment*1000000)/(nominalgdp_*1000000000);
generate construct_gdp=(ts201*1000000)/(nominalgdp_*1000000000);


#delimit;
ttest  capital_gdp if year>=2008 & year<=2010 & central_soe==1, by(treatment);
ttest  liabilities_gdp  if year>=2008 & year<=2010 & central_soe==1, by(treatment);
ttest  equity_gdp if year>=2008 & year<=2010 & central_soe==1, by(treatment);
ttest  assets_gdp if year>=2008 & year<=2010 & central_soe==1, by(treatment);
ttest  invest_gdp if year>=2008 & year<=2010 & central_soe==1, by(treatment);
ttest  construct_gdp if year>=2008 & year<=2010 & central_soe==1, by(treatment);

#delimit;
ttest  capital_gdp if year>=2008 & year<=2010 & central_soe==0, by(treatment);
ttest  liabilities_gdp  if year>=2008 & year<=2010 & central_soe==0, by(treatment);
ttest  equity_gdp if year>=2008 & year<=2010 & central_soe==0, by(treatment);
ttest  assets_gdp if year>=2008 & year<=2010 & central_soe==0, by(treatment);
ttest  invest_gdp if year>=2008 & year<=2010 & central_soe==0, by(treatment);
ttest  construct_gdp if year>=2008 & year<=2010 & central_soe==0, by(treatment);

save ts_province_SOE_final_data.dta, replace;


/***************************************T-Tests of provincial averages**********************************************/
#delimit;
set more off;
preserve;
drop if central_soe==0;
xtset pci_id year;


#delimit;
foreach x in capital_gdp liabilities_gdp equity_gdp invest_gdp construct_gdp assets_gdp{;
generate g_`x'=(`x'-l2.`x') if year==2010;
ttest `x' if year>2008 & year<2011, by(treatment);
generate mean_c_`x'=r(mu_1);
generate mean_t_`x'=r(mu_2);
generate t_`x'=r(t);
generate p_`x'=r(p);
ttest g_`x' if year==2010, by(treatment);
generate gt_`x'=r(t);
generate gp_`x'=r(p);
generate gmean_c_`x'=r(mu_1);
generate gmean_t_`x'=r(mu_2);
};

#delimit;
collapse mean*  t_* p_* gmean* gt_* gp_*;
outsheet using "SOE_tests", comma replace;


restore;


/****GRAPHS CENTRAL SOES**************/


/*Collapse to Aggregates*/
#delimit;

replace capital_gdp=capital_gdp*100;
replace liabilities_gdp=liabilities_gdp*100;
replace invest_gdp=invest_gdp*100;
replace construct_gdp=construct_gdp*100;
replace equity_gdp=equity_gdp*100;

#delimit;
collapse (mean) capital_gdp  liabilities_gdp equity_gdp assets_gdp invest_gdp construct_gdp 
(semean) sek=capital_gdp seliab=liabilities_gdp seequity=equity_gdp seassets=assets_gdp seinv=invest_gdp seconstruct=construct_gdp , by(treatment year central_soe);


generate low_inv= invest_gdp-(1.6*seinv);
generate high_inv= invest_gdp+(1.6*seinv);

generate low_asset=  assets_gdp-(1.6*seassets);
generate high_asset=  assets_gdp +(1.6*seassets);

generate low_liab= liabilities_gdp-(1.6*seliab);
generate high_liab= liabilities_gdp+(1.6*seliab);

generate low_construct= construct_gdp-(1.6*seconstruct);
generate high_construct= construct_gdp+(1.6*seconstruct);

generate low_capital= capital_gdp-(1.6*sek);
generate high_capital= capital_gdp+(1.6*sek);


generate low_equity= equity_gdp-(1.6*sek);
generate high_equity= equity_gdp+(1.6*sek);

/*Graph - Liabilities*/
#delimit;
twoway (rcap low_liab high_liab year if treatment==0 & central_soe==1, lcolor(gs7) lwidth(thick)) (rcap low_liab high_liab year if treatment==1 & central_soe==1,  lcolor(gs13) lwidth(thick)) 
(line  liabilities_gdp year if treatment==0 & central_soe==1, lpattern(dash) lcolor(gs3) lwidth(medthick))   (line  liabilities_gdp year if treatment==1 & central_soe==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Share of Provincial GDP (%)", size(medium) margin(small)) ylab(,labsize(small)) xlab(,labsize(small))  
subtitle("T-test of Growth in Control v. Treatment ('08-'10): p=0.78", size(small)) title("5. Central SOE Liabilities", size(large)) legend(off)
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save liabilities.gph, replace;


/*Owner Equity*/
#delimit;
twoway (rcap low_equity high_equity year if treatment==0 & central_soe==1, lcolor(gs7) lwidth(thick)) (rcap low_equity high_equity year if treatment==1 & central_soe==1,  lcolor(gs13) lwidth(thick)) 
(line  equity_gdp year if treatment==0 & central_soe==1, lpattern(dash) lcolor(gs3) lwidth(medthick))   (line equity_gdp year if treatment==1 & central_soe==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Share of Provincial GDP (%)", size(medium) margin(small))  ylab(,labsize(small)) ylab(,labsize(small))  
subtitle("T-test of Growth in Control v. Treatment ('08-'10): p=0.78", size(small)) title("6. State Equity in Central SOEs", size(large)) legend(off)
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save equity.gph, replace;



/*Investment*/
#delimit;
twoway (rcap low_inv high_inv year if treatment==0 & central_soe==1, lcolor(gs7) lwidth(thick)) (rcap low_inv high_inv year if treatment==1 & central_soe==1,  lcolor(gs13) lwidth(thick)) 
(line  invest_gdp year if treatment==0 & central_soe==1, lpattern(dash) lcolor(gs3) lwidth(medthick))   (line  invest_gdp year if treatment==1 & central_soe==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Share of Provincial GDP (%)", size(medium) margin(medsmall))  ylab(,labsize(small)) xlab(,labsize(small))  
legend(rows(2) size(vsmall) position(6) lab(1 90% CI - Control) lab(2 90% CI - Treat) lab(3 Mean - Control) lab(4 Mean - Treat) 
note("T-test of Growth in Control v. Treatment ('08-'10): p=0.9333", size(vsmall) )) title("New Investment", size(medlarge));
graph save investment.gph, replace;


/*Assets*/
#delimit;
twoway (rcap low_asset high_asset year if treatment==0 & central_soe==1, lcolor(gs7) lwidth(thick)) (rcap low_asset high_asset year if treatment==1 & central_soe==1,  lcolor(gs13) lwidth(thick)) 
(line assets_gdp year if treatment==0 & central_soe==1, lpattern(dash) lcolor(gs3) lwidth(medthick))   (line assets_gdp year if treatment==1 & central_soe==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Share of Provincial GDP (%)", size(medium) margin(medsmall))  ylab(,labsize(small)) xlab(,labsize(small))  
legend(rows(2) size(vsmall) position(6) lab(1 90% CI - Control) lab(2 90% CI - Treat) lab(3 Mean - Control) lab(4 Mean - Treat) 
note("T-test of Growth in Control v. Treatment ('08-'10): p= 0.2308", size(vsmall) )) title("Assets", size(medlarge))
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save assets.gph, replace;

/*Construct*/
#delimit;
twoway (rcap low_construct high_construct year if treatment==0 & central_soe==1, lcolor(gs7) lwidth(thick)) (rcap low_construct high_construct year if treatment==1 & central_soe==1,  lcolor(gs13) lwidth(thick)) 
(line  construct_gdp year if treatment==0 & central_soe==1, lpattern(dash) lcolor(gs3) lwidth(medthick))   (line construct_gdp year if treatment==1 & central_soe==1, lpattern(solid) lcolor(black) lwidth(medthick)) ,   
xtitle("") ytitle("Share of Provincial GDP (%)", size(medium) margin(medsmall))  ylab(,labsize(small)) xlab(,labsize(small))  
legend(rows(2) size(vsmall) position(6) lab(1 90% CI - Control) lab(2 90% CI - Treat) lab(3 Mean - Control) lab(4 Mean - Treat) 
note("T-test of Growth in Control v. Treatment ('08-'10): p=0.2472", size(vsmall) )) title("Construction Outlays", size(medlarge))
graphregion(fcolor(white) ifcolor(white)) plotregion(fcolor(white) ifcolor(white)) ;
graph save construction.gph, replace;




#delimit;
graph combine liabilities.gph equity.gph assets.gph construction.gph, rows(2) cols(2) xcommon;
graph save csoes_budget.gph, replace;




