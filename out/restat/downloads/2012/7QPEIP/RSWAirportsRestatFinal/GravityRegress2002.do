
#delimit ;
clear all;
capture log close;
log using logs\GravityRegress2002.log,replace;
set scheme s1mono;
set more off;
set mem 200m;
set matsize 800;
version 10;

************************************************************************;
**** THIS FILE GENERATES THE RESULTS IN TABLE 4 AND FIGURES 2 AND 3 ****;
************************************************************************;

******************************************;
**** Use Data and Transform Variables ****;
******************************************;

use data\Gravity2002-final.dta;
so exporter importer;

gen ldeppass=ln(1+deppass);
gen ldp=ln(deppass);

replace formig=0 if formig==.;
gen lformig=ln(1+formig);

replace subsy=0 if subsy==.;
gen lsubsy=ln(1+subsy);

gen dist2=dist*dist;

gen ldist=ln(dist);
gen ldist2=ldist*ldist;

gen tot_depart_e=dom_depart_e+for_depart_e;
gen tot_transit_e=dom_transit_e+for_transit_e;

gen transit=dom_transit_e if country_e==country_i;
replace transit=for_transit_e if country_e~=country_i;
gen ltransit=ln(transit);

gen lfor_transit_e=ln(for_transit_e);
gen ldom_transit_e=ln(dom_transit_e);
gen ltot_transit_e=ln(tot_transit_e);
gen lff_transit_e=ln(1+for_for_transit_e);
gen ldf_transit_e=ln(dom_for_transit_e);

gen ltot_tr_e2=ltot_transit_e*ltot_transit_e;
gen lfor_tr_e2=lfor_transit_e*lfor_transit_e;

gen lfmkpot=ln(fmkpot);
gen lfmbip=ln(fmbip);

************************************;
**** Variable names and dummies ****;
************************************;

gen dFRA=0;
replace dFRA=1 if expname=="Frankfurt";

gen dBLN=0;
replace dBLN=1 if expname=="Berlin";

gen dMUC=0;
replace dMUC=1 if expname=="Munich";

gen topten=0;
replace topten=1 if country_i=="Spanien"|country_i=="Türkei"|country_i=="UK"
|country_i=="USA"|country_i=="Italien"|country_i=="Frankreich"
|country_i=="Griechenland"|country_i=="Schweiz"
|country_i=="Österreich"|country_i=="Niederlande";

gen mainten=0;
replace mainten=1 if exporter=="BRE"|exporter=="DUS"|exporter=="HAM"
|exporter=="CGN"|exporter=="HAJ"|exporter=="FRA"
|exporter=="STR"|exporter=="NUE"
|exporter=="MUC"|exporter=="TXL";

egen dist_p50=pctile(dist), p(50);
so exporter importer;

gen med_dist=0;
replace med_dist=1 if dist>dist_p50;

gen mldist=ldist*med_dist;

encode exporter,gen(expnum);
encode importer,gen(impnum);
encode country_i,gen(imp_c);
encode continent_i,gen(cont_imp);

so exporter importer;
quietly by exporter: gen fob=1 if _n==1;

************************;
**** Transits Table ****;
************************;

replace tot_depart_e=tot_depart_e/1000;
replace tot_transit_e=tot_transit_e/1000;
replace dom_transit_e=dom_transit_e/1000;
replace for_transit_e=for_transit_e/1000;
replace for_for_transit_e=for_for_transit_e/1000;

egen mainten_tr=sum(tot_transit_e),by(importer);
egen mainten_dp=sum(tot_depart_e),by(importer);
so exporter importer;

gen sharetr=(tot_transit_e/mainten_tr)*100;
gen sharedp=(tot_depart_e/mainten_dp)*100;
gen pertrans=(tot_transit_e/tot_depart_e)*100;

format %10.2f tot_depart_e tot_transit_e sharetr sharedp pertrans;
list exporter tot_depart_e sharedp sharetr pertrans if fob==1;

replace sharetr=sharetr/100;
replace sharedp=sharedp/100;
replace pertrans=pertrans/100;

***************************;
**** DEFINE THE SAMPLE ****;
***************************;

egen min_dist=min(dist),by(importer);
so exporter importer;

gen dist_ab=0;
replace dist_ab=1 if min_dist>300;

gen dist_be=0;
replace dist_be=1 if min_dist<=300;

gen long_ldist=ldist*dist_ab;
gen short_ldist=ldist*dist_be;

gen reg_sample=0;
replace reg_sample=1 if min_dist>300&sample_dp==1;

*******************************;
**** Hierarchy of airports ****;
*******************************;

**** How many airports serve each importer;

egen nog=count(expnum) if deppass~=0&deppass~=.,by(importer);
egen noj=max(nog),by(importer);
so exporter importer;
tab noj;

tab exporter,gen(dd);
tab importer,gen(ii);
tab country_i,gen(cii);

********************************************;
**** Proximity to top-10 German markets ****;
********************************************;

format dist %10.2f;
tabulate country_i exporter if topten==1, summarize(dist) means ;
table country_i exporter if topten==1, c(mean dist) format(%10.2f) center ;

******************************************;
**** Distances to Individual Airports ****;
******************************************;

list exporter importer dist if (exporter=="FRA"|exporter=="TXL")&importer=="JFK";
list exporter importer dist if (exporter=="FRA"|exporter=="TXL")&importer=="SFO";
list exporter importer dist if (exporter=="FRA"|exporter=="TXL")&importer=="NRT";
su dist if exporter=="FRA"&reg_sample==1;
su dist if exporter=="TXL"&reg_sample==1;

*******************************************************************;
**** Compare market access and simple market potential measure ****;
*******************************************************************;

areg ldeppass ldist dd2-dd15 if reg_sample==1, cluster(country_i) abs(impnum);

predict fit_ldp, xbd;
predict fit_fe, d;

gen lsc = 0;
replace lsc= lsc  + _b[dd2]*dd2   + _b[dd3]*dd3   + _b[dd4]*dd4   + _b[dd5]*dd5
+ _b[dd6]*dd6     + _b[dd7]*dd7   + _b[dd8]*dd8   + _b[dd9]*dd9   + _b[dd10]*dd10
+ _b[dd11]*dd11   + _b[dd12]*dd12 + _b[dd13]*dd13 + _b[dd14]*dd14 + _b[dd15]*dd15;

gen lmc=fit_ldp-lsc;
gen mc=exp(lmc);
egen ma=sum(mc),by(exporter);
gen lma=ln(ma);

gen temp=deppassDE*(dist^-1);
egen mpot=sum(temp) if reg_sample==1, by(exporter);
drop temp;
gen lmpot=ln(mpot);

so exporter importer;

pwcorr ma mpot if fob==1, sig;

drop fit_ldp fit_fe lsc lmc mc ma lma mpot lmpot;

*******************************************;
**** Non-parametric OLS Decomposition  ****;
**** With Social and Business Networks ****;
*******************************************;

* Table 4, Column (1);

areg ldeppass ldist dd2-dd15 if reg_sample==1, cluster(country_i) abs(impnum);

* Table 4, Column (2);

areg ldeppass ldist lformig dd2-dd15 if reg_sample==1, cluster(country_i) abs(impnum);

* Table 4, Column (3);

areg ldeppass ldist lsubsy dd2-dd15 if reg_sample==1, cluster(country_i) abs(impnum);

* Table 4, Column (4);
* Regression for the decomposition;

areg ldeppass ldist lformig lsubsy dd2-dd15 if reg_sample==1, cluster(country_i) abs(impnum);

predict fit_ldp, xbd;
predict fit_fe, d;

** Market access and supplier capacity decomposition;

gen fit_dp=exp(fit_ldp);
egen fit_p=sum(fit_dp),by(exporter);
egen mn_fit_p=mean(fit_p);
so exporter importer;
gen temp=fit_p if exporter=="TXL";
egen fit_p_BLN=max(temp);
so exporter importer;
drop temp;
gen log_fit_p=ln(fit_p/fit_p_BLN);

egen sumdeppass=sum(deppass),by(exporter);
so exporter importer;
egen mn_sumdeppass=mean(sumdeppass);
so exporter importer;
gen temp=sumdeppass if exporter=="TXL";
egen sumdeppass_BLN=max(temp);
so exporter importer;
drop temp;
gen log_sumdeppass=ln(sumdeppass/sumdeppass_BLN);

gen lsc = 0;
replace lsc= lsc  + _b[dd2]*dd2   + _b[dd3]*dd3   + _b[dd4]*dd4   + _b[dd5]*dd5
+ _b[dd6]*dd6     + _b[dd7]*dd7   + _b[dd8]*dd8   + _b[dd9]*dd9   + _b[dd10]*dd10
+ _b[dd11]*dd11   + _b[dd12]*dd12 + _b[dd13]*dd13 + _b[dd14]*dd14 + _b[dd15]*dd15;

gen sc=exp(lsc);
egen mn_sc=mean(sc);
so exporter importer;
gen temp=sc if exporter=="TXL";
egen sc_BLN=max(temp);
so exporter importer;
drop temp;
gen lsa=ln(sc/sc_BLN);

gen lmc=fit_ldp-lsc;
gen mc=exp(lmc);
egen ma=sum(mc),by(exporter);
egen mn_ma=mean(ma);
so exporter importer;
gen temp=ma if exporter=="TXL";
egen ma_BLN=max(temp);
so exporter importer;
drop temp;
gen lma=ln(ma/ma_BLN);

gen test=log_fit_p-lsa-lma;
tab exporter importer if abs(test)>0.00001;

gen sa_share=abs(lsa/log_fit_p);

* Graph for paper;

set scheme s1mono;

graph bar (mean) lma lsa , over(expname, label(angle(90) labsize(small)))
bar(1, bcolor(black)) bar(2, bcolor(gray*0.6))
legend(lab(1 "Market Access") lab(2 "Source Airport Fixed Effect") size(small))
ytitle("Log Deviations from the Value for Berlin", margin(small) size(small))
title("Figure 2: The Role of Market Access", margin(small))
note("Note: the estimates of market access and the source airport fixed effects are derived from the gravity equation (6) for bilateral"
"passenger departures in the main text. The log deviations from Berlin for market access and the source airport fixed effects sum"
"to the log deviation from Berlin for fitted total departures.", size(vsmall));

graph export graphs\Figure2.eps , replace as(eps);

* Graph for presentation;

****set scheme s1color;

****graph bar (mean) lma lsa , over(expname, label(angle(90) labsize(small)))
bar(1, bcolor(red)) bar(2, bcolor(eltblue))
legend(lab(1 "Market Access") lab(2 "Source Airport Fixed Effect") size(small))
ytitle("Log Deviations from the Value for Berlin", margin(small) size(small))
title("Figure 2: The Role of Market Access", margin(small));

****graph export graphs\Figure2_present.eps , replace as(eps);

**** List export fixed effect and market access;

egen rk_lma=rank(lma), field by(importer);
egen rk_lsa=rank(lsa), field by(importer);
so exporter importer;

so exporter importer;

su deppass fit_dp;

format %12.2f log_fit_p log_sumdeppass test lma rk_lma lsa rk_lsa sa_share;

list exporter log_fit_p lma rk_lma lsa rk_lsa if fob==1;

list exporter log_fit_p lma lsa sa_share if fob==1;

************************************;
**** Total and Local Departures ****;
************************************;

gen ltot_depart_e=ln(tot_depart_e);

gen lbip_vbg50=ln(bip_vbg50);
gen lpop_vbg50=ln(pop_vbg50);
gen lbippc_vbg50=ln(bippc_vbg50);

gen lbip_vbg100=ln(bip_vbg100);
gen lpop_vbg100=ln(pop_vbg100);
gen lbippc_vbg100=ln(bippc_vbg100);

lab var lbip_vbg50 "Log Local GDP 50km";
lab var lbip_vbg100 "Log Local GDP 100km";

* Various local departures measures;

gen nofor_depart_e=tot_depart_e-for_for_transit_e;
gen notran_depart_e=tot_depart_e-tot_transit_e;

gen lnofor_depart_e=ln(nofor_depart_e);
gen lnotran_depart_e=ln(notran_depart_e);

* Preferred local departures measure;

gen noairtransit_depart_e=(1-pertran)*tot_depart_e;

gen nlocal=0;
replace nlocal=0.65 if exporter=="BRE";
replace nlocal=0.73 if exporter=="CGN"; 
replace nlocal=0.77 if exporter=="DRS"; 
replace nlocal=0.60 if exporter=="DUS"; 
replace nlocal=0.50 if exporter=="ERF"; 
replace nlocal=0.43 if exporter=="FMO"; 
replace nlocal=0.37 if exporter=="FRA"; 
replace nlocal=0.37 if exporter=="HAJ"; 
replace nlocal=0.69 if exporter=="HAM"; 
replace nlocal=0.44 if exporter=="LEJ"; 
replace nlocal=0.51 if exporter=="MUC"; 
replace nlocal=0.60 if exporter=="NUE"; 
replace nlocal=0.67 if exporter=="SCN"; 
replace nlocal=0.64 if exporter=="STR"; 
replace nlocal=0.85 if exporter=="TXL";

gen loc_depart_e=nlocal*noairtransit_depart_e;
gen lloc_depart_e=ln(loc_depart_e);

gen true_transit_e=tot_depart_e-loc_depart_e;
gen ltrue_transit_e=ln(true_transit_e);

gen grnd_transit_e=(1-nlocal)*noairtransit_depart_e;
gen lgrnd_transit_e=ln(grnd_transit_e);

**************************************************************************;
**** Four Panel Graph Breaking Out Total Departures                   ****;
**** Int Transits, Dom Transits, Ground Transits and Local Departures ****;
**************************************************************************;

replace tot_depart_e=tot_depart_e/1000;
replace nofor_depart_e=nofor_depart_e/1000;
replace notran_depart_e=notran_depart_e/1000;
replace loc_depart_e=loc_depart_e/1000;

reg tot_depart_e if fob==1;
predict tot_constant,residuals;

reg nofor_depart_e if fob==1;
predict nofor_constant,residuals;

reg notran_depart_e if fob==1;
predict notran_constant,residuals;

reg loc_depart_e if fob==1;
predict loc_constant, residuals;

* Graph for paper;

set scheme s1mono;

graph bar tot_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res1,replace) ytitle("Passengers (millions)") ti("Departures");
graph bar nofor_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res2,replace) ytitle("Passengers (millions)") ti("Departures - International Air Transits");
graph bar notran_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res3,replace) ytitle("Passengers (millions)") ti("Departures - (International + Domestic Air Transits)");
graph bar loc_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res4,replace) ytitle("Passengers (millions)") ti("Departures - (Air + Ground Transits)");
graph combine graphs\res1.gph graphs\res2.gph graphs\res3.gph graphs\res4.gph, rows(2) cols(2) iscale(*0.6)
title("Figure 3: Transit and Local Passenger Departures")
note("Note: international air transit passengers are those changing planes at an airport on route from a foreign source to a foreign destination. Domestic"
"air transit passengers are those changing planes at an airport with either a source or destination within Germany. Ground transit passengers"
"are those who travelled more than 50 kilometers to an airport using ground transporation. See the data appendix for further discussion of the"
"data sources.", size(vsmall));

graph export graphs\Figure3.eps , replace as(eps);

* Graph for presentation;

****set scheme s1color;

****graph bar tot_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res1,replace) ytitle("Passengers (millions)") ti(Departures);
graph bar nofor_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res2,replace) ytitle("Passengers (millions)") ti(Departures Minus International Air Transits);
graph bar notran_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res3,replace) ytitle("Passengers (millions)") ti(Departures Minus All Air Transits);
graph bar loc_depart_e if fob==1, over(expname, label(angle(90) labsize(small))) ylabel (0 5 10 15 20 25) 
saving(graphs\res4,replace) ytitle("Passengers (millions)") ti(Departures Minus All Transits);
graph combine graphs\res1.gph graphs\res2.gph graphs\res3.gph graphs\res4.gph, rows(2) cols(2) iscale(*0.6)
title("Figure 3: Transit and Local Passenger Departures");

****graph export graphs\Figure3_present.eps , replace as(eps);

log close;
