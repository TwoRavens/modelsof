#delimit ;
clear;
clear all;
set more off;
capture log close;
log using logs\Simulation2002_rev.log,replace;
set mem 200m;
set matsize 800;
version 10;

********************************************************************;
**** THIS PROGRAM GENERATES THE RESULTS IN TABLE 5 IN THE PAPER ****;
**** AND CREATES FIGURE 4                                       ****;
********************************************************************;

******************************************;
**** Use Data and Transform Variables ****;
******************************************;
				
use data\Gravity2002-final.dta;
so exporter importer;

gen ldeppass=ln(1+deppass);
gen ldist=ln(dist);

replace formig=0 if formig==.;
gen lformig=ln(1+formig);
replace subsy=0 if subsy==.;
gen lsubsy=ln(1+subsy);

encode importer,gen(impnum);
encode exporter,gen(expnum);
tab exporter,gen(dd);

**********************************;
**** Define Regression Sample ****;
**********************************;

egen min_dist=min(dist),by(importer);
so exporter importer;

gen reg_sample=0;
replace reg_sample=1 if international==1&min_dist>300&sample_dp==1;

********************************************;
***** Choose new hub for the simulation ****;
********************************************;

local newhub="TXL";

**************************************;
**** Replicate Gravity Regression ****;
**************************************;

areg ldeppass ldist lformig lsubsy dd2-dd15 if reg_sample==1, cluster(country_i) abs(impnum);
predict fit_ldeppass, xb;

gen coedist=_b[ldist];

***********************************************;
**** Generate Variables for the Simulation ****;
***********************************************;

* Exporters comprise the fifteen German airports;
* Importers comprise the fifteen German airports and other destinations;

* Store the bilateral distances from the new hub to all destinations;
* Store these distances both when the new hub is an exporter;
* and when the new hub is an importer;

* Note that the data are balanced in the sense that each exporter;
* has the same number of importers (excluding itself);

gen temp=ldist if exporter=="`newhub'";
egen ldist_`newhub'_e=max(temp),by(importer);
so exporter importer;
drop temp;

gen temp=ldist if importer=="`newhub'";
egen ldist_`newhub'_i=max(temp),by(exporter);
so exporter importer;
drop temp;

gen temp=dist if exporter=="`newhub'";
egen dist_`newhub'_e=max(temp),by(importer);
so exporter importer;
drop temp;

gen temp=dist if importer=="`newhub'";
egen dist_`newhub'_i=max(temp),by(exporter);
so exporter importer;
drop temp;

* Store the distance from the existing hub in FRA to the new hub (though this is not used in the code);

gen temp=dist if exporter=="FRA"&importer=="`newhub'";
egen bil_dist_nh=max(temp);
so exporter importer;
drop temp;

* Replace bilateral distances for the current hub in Frankfurt with those of the hypothetical hub;

gen ldist_S=ldist;
replace ldist_S=ldist_`newhub'_e if exporter=="FRA";
replace ldist_S=ldist_`newhub'_i if importer=="FRA";

gen dist_S=dist;
replace dist_S=dist_`newhub'_e if exporter=="FRA";
replace dist_S=dist_`newhub'_i if importer=="FRA";

*******************************;
**** Define Scaling Factor ****;
*******************************;

* Create a scale factor for each destination which depends on the ratio of the distance;
* from the destination to the new hypothetical hub relative to distance to the existing hub in Frankfurt;
* The ratio of distances is raised to the power of the distance coefficient from the;
* gravity equation estimation;

* Note that because data do not exist on an airport's departures with itself, and this is true for both;
* dist and dist_S, it follows that the scaling factor is missing for bilateral departures between;
* FRA and the new hypothetical hub;

* We use this feature of the data in the code below to leave passenger departures between FRA and the new;
* hypothetical hub unchanged;

gen scale=(dist_S/dist)^coedist if exporter=="FRA"|importer=="FRA";

* Check the impact of scale on overall departures;

egen existing=sum(deppass),by(exporter);
egen new=sum(deppass*scale),by(exporter);
so exporter importer;
gen impact=(new/existing)*100;
su impact if exporter=="FRA";
drop existing new impact;

***********************;
**** Program Notes ****;
***********************;

* The dataset is bilateral from fifteen German airports (exporters) to;
* the fifteen German airports and many other destinations (importers);

* The variable fob is created to store information in the first observation;
* for each exporter without duplicating the information for all importer;
* observations for that exporter;

so exporter importer;
quietly by exporter: gen fob=1 if _n==1;

*****************************************************;
**** Define the Various Categories of Passengers ****;
*****************************************************;

* International Air Transits;
* Domestic Air Transits;
* Ground Transits arriving by ground from more than 50km away;
* Local Departures arriving by ground from less than 50km away;

gen tot_transit_e=dom_transit_e+for_transit_e;
gen int_transit_e=for_for_transit_e;
replace dom_transit_e=tot_transit_e-for_for_transit_e;

gen grnd_depart_e=total_depart_e-tot_transit_e;

* Shares of passengers originating from within 50km of each airport;
* from the Wilken survey;

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

gen loc_depart_e=nlocal*grnd_depart_e;
gen grnd_transit_e=grnd_depart_e-loc_depart_e;

gen test=(int_transit_e+dom_transit_e+grnd_transit_e+loc_depart_e)-total_depart_e;

format total_depart_e int_transit_e dom_transit_e grnd_transit_e loc_depart_e test %14.2fc;

list exporter total_depart_e int_transit_e dom_transit_e grnd_transit_e loc_depart_e test if fob==1;

***********************************************************;
**** Construct Shares of Transits in Total Departures *****;
***********************************************************;

* Note that the transits variables are airport (exporter) specific;
* and do not vary bilaterally;
* We want to divide up bilateral departures from the hub into each;
* category of passengers using the shares of transits in total departures;

* Air transit departures are identified at the hub;
* Therefore we use Frankfurt's share to measure domestic air transits;
* Note that we are only going to simulate the impact of the relocation of the;
* hub on bilateral departures emanating from the current location;
* of the hub in Frankfurt;
* Therefore only the values on bilateral routes emanating from Frankfurt;
* are of interest even if the variables are created for other bilateral;
* routes;

* Define shares of transits in total departures for each airport;

gen int_share=int_transit_e/total_depart_e;
gen dom_share=dom_transit_e/total_depart_e;
gen grnd_share=grnd_transit_e/total_depart_e;
gen loc_share=loc_depart_e/total_depart_e;

* Store the values of domestic air transits for Frankfurt;

gen temp=dom_share if exporter=="FRA";
egen dom_share_FRA=max(temp);
so exporter importer;
replace dom_share=dom_share_FRA;
drop temp;

* Now that we have given every airport Frankfurt's shares of domestic air transits;
* the shares of each category of passengers in total departures now longer;
* sum to one for airports other than Frankfurt;

* For purely domestic-domestic routes we want dom_share+grnd_share+loc_share;
* to sum to one so that when we split bilateral departures up into these three;
* categories the sum of the three categories equals total departures;
* (N.B. for purely domestic-domestic routes there can be no international transits);

* Therefore for use on domestic-domestic routes we define a variables which is;
* sum_dom_share=dom_share+grnd_share+loc_share;
* To split up bilateral departures on domestic-domestic routes, we will use;
* the following shares;
* ;
* dom_share/(dom_share+grnd_share+loc_share);
* grnd_share/(dom_share+grnd_share+loc_share);
* loc_share/(dom_share+grnd_share+loc_share);
* ;
* These three shares sum to one by construction;

gen sum_dom_share=dom_share+grnd_share+loc_share;

su sum_dom_share, d;

************************************************************************;
**** Now divide up bilateral departures into the various categories ****;
**** of passengers distinguishing between international and         ****;
**** domestic routes                                                ****;
************************************************************************;

* INTERNATIONAL ROUTES;

* International-international transits;
* Multiply bilateral departures by share of international transits;

gen intdep=int_share*deppass if international==1;
replace intdep=0 if international==0;

* Domestic-International transits;
* Multiply bilateral departures by share of domestic transits;

gen domdep=dom_share*deppass if international==1;

* Domestic-International ground departures;
* Multiply bilateral departures by share of ground transits;

gen grnddep=grnd_share*deppass if international==1;

* Domestic-International local departures;
* Multiply bilateral departures by share of local departures;

gen locdep=loc_share*deppass if international==1;

* DOMESTIC ROUTES;

* Domestic-Domestic transits;
* Multiply bilateral departures by share of domestic transits;
* making the adjustment discussed above so that the shares sum to one;

replace domdep=(dom_share/sum_dom_share)*deppass if international==0;

* Domestic-Domestic ground departures;
* Multiply bilateral departures by share of ground transits;
* making the adjustment discussed above so that the shares sum to one;

replace grnddep=(grnd_share/sum_dom_share)*deppass if international==0;

* Domestic-Domestic local departures;
* Multiply bilateral departures by share of local departures;
* making the adjustment discussed above so that the shares sum to one;

replace locdep=(loc_share/sum_dom_share)*deppass if international==0;

***************************************************************************;
**** Having created each category of passenger on each bilateral route ****;
**** define pre-treatment total passenger departures                   ****;
***************************************************************************;

egen pre_totdep=sum(deppass),by(exporter);
egen pre_intdep=sum(intdep),by(exporter);
egen pre_domdep=sum(domdep),by(exporter);
egen pre_grnddep=sum(grnddep),by(exporter);
egen pre_locdep=sum(locdep),by(exporter);
so exporter importer;

* Note that pre_totdep is not equal to pre_intdep+pre_domdep+pre_grnddep+pre_locdep;
* because of the use of Frankfurt's shares of transit traffic which imply that;
* the shares of the four categories of passengers do not necessarily sum to one;
* for other airports;
* Note we are only going to evaluate the impact of the relocation;
* of the hub on bilateral departures emanating from Frankfurt below;
* Clearly the shares sum to one for Frankfurt;

drop test;
gen test=pre_totdep-(pre_intdep+pre_domdep+pre_grnddep+pre_locdep);
gen pre_sumcomp=pre_intdep+pre_domdep+pre_grnddep+pre_locdep;

format pre_totdep pre_intdep pre_domdep pre_grnddep pre_locdep test %14.2fc;
list exporter pre_totdep pre_intdep pre_domdep pre_grnddep pre_locdep test if fob==1;

******************************************************************;
**** Now we will adjust each category of passenger departures ****;
**** for the relocation of the hub                            ****;
******************************************************************;

* We make the adjustments at the current location of the hub FRA;
* taking into account the impact of the relocation of the hub;
* on each category of passengers;
* We are only interested in the change in passenger departures;
* on routes emanating from the current location of the hub in FRA;
* as a result of its relocation to another city;

*********************************************************************;
**** International departures                                    ****;
**** The first-order effect of the relocation of the hub is that ****;
**** international transits have to fly a longer or shorter      ****;
**** distance to the new location of the hub                     ****;
*********************************************************************;

* Note that scale is missing for bilateral departures between;
* FRA and the new hypothetical hub as discussed above;
* Therefore the command below leaves unchanged the current flow of;
* departures from FRA to the new location of the hub;
* Implicitly we assume that a similar flow would arise from the new;
* location of the hub to FRA;

* Note that only international departures from the current location of the;
* hub in Frankfurt are affected by the relocation of the hub and therefore;
* we only change international departures from Frankfurt in the code below;

gen sim_intdep=intdep;
replace sim_intdep=intdep*scale if (exporter=="FRA"|importer=="FRA")&scale~=.;

egen post_intdep=sum(sim_intdep),by(exporter);
so exporter importer;

format post_intdep %14.2fc;
list exporter pre_intdep post_intdep if fob==1;

*********************************************************************;
**** Domestic departures                                         ****;
**** The first-order effect of the relocation of the hub is that ****;
**** domestic transits have to fly a longer or shorter           ****;
**** distance to the new location of the hub                     ****;
*********************************************************************;

* Note that scale is missing for bilateral departures between;
* FRA and the new hypothetical hub as discussed above;
* Therefore the command below leaves unchanged the current flow of;
* departures from FRA to the new location of the hub;
* Implicitly we assume that a similar flow would arise from the new;
* location of the hub to FRA;

gen sim_domdep=domdep;
replace sim_domdep=domdep*scale if (exporter=="FRA"|importer=="FRA")&scale~=.;

egen post_domdep=sum(sim_domdep),by(exporter);
so exporter importer;

* Note that domestic departures from every other German airport (except the ;
* new location of the hub as discussed above) are affected by the relocation;
* of the hub. Instead of flying to Frankfurt domestic transits from or to;
* these other airports have to fly to the new location of the hub;
* Calculate the impact for each other German airport, sum them,;
* and store the sum in the observation for Frankfurt;

* Note that post_domdep and pre_domdep only differ on routes emanating;
* from the current location of the hub in FRA;

gen imp_domdep=post_domdep-pre_domdep;
egen agg_imp_domdep=sum(imp_domdep) if fob==1;
replace agg_imp_domdep=0 if exporter~="FRA"&fob==1;
so exporter importer;

format post_domdep %14.2fc;
list exporter pre_domdep post_domdep if fob==1;

**************************************************************;
**** Ground transits                                      ****;
**** Adjust the volume of ground transits at the current  ****;
**** location of the hub in Frankfurt for the differences ****;
**** in the surrounding concentration of local economic   ****;
**** activity at the new location of the hub              ****;
**************************************************************;

egen ngrnd_transit_e=sum(grnddep),by(exporter);
so exporter importer;

gen lngrnd_transit_e=ln(ngrnd_transit_e);
gen lmkpot=ln(mkpot);
gen lfmkpot=ln(fmkpot);
gen lGTpop=ln(GTpop);
gen lmbip=ln(mbip);
gen lfmbip=ln(fmbip);
gen lGTbip=ln(GTbip);

* Regress ground transits on local economic activity;
* Use the fitted values to make the adjustment to;
* the current volume of ground transits at Frankfurt;
* for the change in the surrounding concentration;
* of economic activity at the new location of the hub;

* Note that pre_grnddep and post_grnddep only differ for the;
* current location of the hub in FRA;

** reg lngrnd_transit_e lmbip if fob==1, robust;
reg lngrnd_transit_e lmbip if fob==1&exporter~="FRA"&exporter~="MUC", robust;
predict fit_lgt,xb;
gen fit_gt=exp(fit_lgt);

gen temp=fit_gt if exporter=="FRA";
egen fit_gt_FRA=max(temp);
so exporter importer;
drop temp;
gen temp=fit_gt if exporter=="`newhub'";
egen fit_gt_`newhub'=max(temp);
so exporter importer;
drop temp;

gen post_grnddep=ngrnd_transit_e;
replace post_grnddep=ngrnd_transit_e-(fit_gt_FRA-fit_gt_`newhub') if exporter=="FRA";

format post_grnddep %14.2fc;
list exporter pre_grnddep post_grnddep if fob==1;

**************************************************************;
**** Local departures                                     ****;
**** Local departures are unaffected by the relocation of ****;
**** the hub and so we leave them unchanged               ****;
**** We explore the relationship between local departures ****;
**** and the surrounding concentration of local economic  ****;
**** activity                                             ****;
**************************************************************;

gen post_locdep=pre_locdep;

* Tight relationship between local departures and local characteristics;

gen lloc_depart_e=ln(loc_depart_e);
gen lbip_vbg50=ln(bip_vbg50);
reg lloc_depart_e lbip_vbg50 if fob==1,robust;
predict fitted_loc, xb;

lab var lbip_vbg50 "ln GDP within 50km";

set scheme s1mono;

replace exporter="BLN" if exporter=="TXL";

* Graph for paper;

twoway (scatter lloc_depart_e lbip_vbg50 if fob==1, msymbol(i) mlab(exporter) mlabposition(0))
(scatter fitted_loc lbip_vbg50 , msymbol(i) c(l)),
title("Figure 4: Local Departures and Local GDP", margin(small)) 
ytitle("log local departures", margin(medium) size(small))
xtitle("log local GDP", margin(small) size(small))
legend(off)
note("Note: local departures are those who travelled less than 50 kilometers to an airport. Local GDP is calculated from the"
"population of all municipalities within 50 kilometers of an airport and the GDP per capita of the counties ('Kreise')"
"in which the municipalities are located. The three letter codes are: BLN: Berlin; BRE: Bremen; CGN: Cologne;"
"DUS: Dusseldorf; DRS: Dresden; ERF: Erfurt; FRA: Frankfurt; HAM: Hamburg; HAJ: Hanover; LEJ: Leipzig;"
"FMO: Munster; MUC: Munich; NUE: Nuremberg; SCN: Saarbrucken; STR: Stuttgart.", size(vsmall));

graph export graphs\Figure4.eps , replace as(eps);

* Graph for presentation;

****twoway (scatter lloc_depart_e lbip_vbg50 if fob==1, msymbol(i) mlab(exporter) mlabposition(0))
(scatter fitted_loc lbip_vbg50 , msymbol(i) c(l)),
title("Figure 4: Local Departures and Local GDP", margin(small)) 
ytitle("log Passenger Departures within 50km", margin(medium) size(small))
xtitle("log GDP within 50km", margin(small) size(small))
legend(off);

****graph export graphs\Figure4_present.eps , replace as(eps);

replace exporter="TXL" if exporter=="BLN";

* local departures per head of population;

gen grnd_dep_pc=grnd_depart_e/fmkpot;
gen loc_dep_pc=loc_depart_e/pop_vbg50;

format loc_dep_pc grnd_dep_pc %14.2fc;

list exporter loc_dep_pc grnd_dep_pc if fob==1;

************************;
**** Overall effect ****;
************************;

gen imp_intdep=post_intdep-pre_intdep;
gen imp_grnddep=post_grnddep-pre_grnddep;
gen imp_locdep=post_locdep-pre_locdep;

gen imp_trandep=imp_intdep+imp_domdep;

gen imp_totdep=imp_intdep+agg_imp_domdep+imp_grnddep+imp_locdep;
gen post_totdep=post_intdep+post_domdep+post_grnddep+post_locdep;

egen german_predep=sum(pre_totdep) if fob==1;
so exporter importer;
replace german_predep=0 if exporter~="FRA"&fob==1;

gen pimpact=(imp_totdep/german_predep)*100;
replace pimpact=0 if exporter~="FRA"&fob==1;

*************************************;
**** Results Reported in Table 5 ****;
*************************************;

display "Select New Hub Location at Top of Program";
display "New Hub Location is";
display "`newhub'";
display "Impact of Hub Relocation";

format post_totdep imp_totdep imp_intdep imp_domdep imp_trandep imp_grnddep imp_locdep german_predep pimpact %14.2fc;

list exporter imp_trandep imp_grnddep imp_totdep pimpact if fob==1&exporter=="FRA";

log close;
