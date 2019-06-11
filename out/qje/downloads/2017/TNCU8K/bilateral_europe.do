clear
set memory 40m
set matsize 800
set more off
use bilateral_europe, replace

* Define Variables

gen gendist_fst_europe=fst_dist_europe/10000
label variable gendist_fst_europe "Fst genetic distance in Europe"
gen dlinc1995=abs(log(rgdpch1995_1)-log(rgdpch1995_2))
label variable dlinc1995 "Absolute difference in log income, 1995, WB"
gen dlinc1870=abs(log(income1870_1)-log(income1870_2))
label variable dlinc1870 "Absolute difference in log income, 1870, Maddison"

* Geography
label variable comlang_ethno "1 if common language (9% threshold)"
replace av_av_elev=av_av_elev/1000
replace min_av_elev=min_av_elev/1000
replace dist=dist/1000
label variable dist "Geodesic Distance (1000s of km)"
gen difflat=abs(latitude_cia_2-latitude_cia_1)/100
label variable difflat "Absolute difference in latitudes"
* Note the correct definition of longitudinal difference below [does not matter for Europe]
gen difflong=abs(longitude_cia_1-longitude_cia_2)
replace difflong=360-difflong if difflong>180
replace difflong=difflong/100
label variable difflong "Absolute difference in longitudes"
gen iron_curtain=(iron_curtain_1~=iron_curtain_2)
label variable iron_curtain "=1 if countries were a different side of the Iron Curtain"
gen landlock_1=(coastline_km_1==0)
gen landlock_2=(coastline_km_2==0)
gen landlock_dummy=(landlock_1==1 | landlock_2==1)
drop landlock_1 landlock_2
label variable landlock_dummy "=1 if either country is landlocked"
gen island_1=(land_boundaries_km_1==0)
replace island_1=1 if (country_1=="Ireland" | country_1=="United Kingdom")
gen island_2=(land_boundaries_km_2==0)
replace island_1=1 if (country_1=="Ireland" | country_1=="United Kingdom")
gen island_dummy=(island_1==1 | island_2==1)
label variable island_dummy "=1 if either country is an island"
drop island_1 island_2
gen common_water=common_sea+common_ocean+common_bay+common_channel+common_gulf
replace common_water=1 if common_water>1
label variable common_water "=1 if pair shares at least one sea or ocean"
replace freight_cost_surface=freight_cost_surface/1000
label variable freight_cost_surface "Freight rate (surface transport)"
label variable min_av_elev "Average elevation between countries"

* Culture
gen lingdist_dom_formula=((15-lingprox_dominant)/15)^.5
label variable lingdist_dom_formula "Linguistic Distance Index, plurality languages"
gen lingdist_weighted_formula=((15-lingprox_weighted)/15)^.5
label variable lingdist_weighted_formula "Linguistic Distance Index, weighted"
replace cognate_dominant=1-(cognate_dominant/1000)
label variable cognate_dominant "1 - %cognate, plurality groups"
replace cognate_weighted=1-(cognate_weighted/1000)
label variable cognate_weighted "1 - %cognate, weighted"
gen reldist_dominant_formula=((5-relprox_dominant_fearon)/5)^.5
label variable reldist_dominant_formula "Religious Distance Index, plurality religions"
gen reldist_weighted_formula=((5-relprox_weighted_fearon)/5)^.5
label variable reldist_weighted_formula "Religious Distance Index, weighted"
gen reldist_dominant_formula_WCD=((3-relprox_dominant_WCD)/3)^.5
label variable reldist_dominant_formula_WCD "Religious Distance Index, plurality religions, WCD"
gen reldist_weighted_formula_WCD=((3-relprox_weighted_WCD)/3)^.5
label variable reldist_weighted_formula_WCD "Religious Distance Index, weighted, WCD"

* Define relative measures of geographic distance
* First relative to UK
gen reldist_UK=abs(dist_1_to_UK-dist_2_to_UK)
replace reldist_UK=reldist_UK/1000
label variable reldist_UK "Geodesic distance, relative to UK"
gen reldifflat_UK=abs(difflat_1_to_UK-difflat_2_to_UK)
label variable reldifflat_UK "Latitude difference, relative to UK"
gen reldifflong_UK=abs(difflong_1_to_UK-difflong_2_to_UK)
label variable reldifflong_UK "Longitude difference, relative to UK"
gen relfreight_UK=abs(freight_cost_surface_1_to_UK-freight_cost_surface_2_to_UK)
label variable relfreight_UK "Freight cost, surface transport, relative to the UK"

* Second relative to Germany
gen reldist_DEU=abs(dist_1_to_DEU-dist_2_to_DEU)
replace reldist_DEU=reldist_DEU/1000
label variable reldist_DEU "Geodesic distance, relative to Germany"
gen reldifflat_DEU=abs(difflat_1_to_DEU-difflat_2_to_DEU)
label variable reldifflat_DEU "Latitude difference, relative to Germany"
gen reldifflong_DEU=abs(difflong_1_to_DEU-difflong_2_to_DEU)
label variable reldifflong_DEU "Longitude difference, relative to Germany"
gen relfreight_DEU=abs(freight_cost_surface_1_to_DEU-freight_cost_surface_2_to_DEU)
label variable relfreight_DEU "Freight cost, surface transport, relative to Germany"

* Third relative to US
gen reldist_USA=abs(dist_1_to_USA-dist_2_to_USA)
replace reldist_USA=reldist_USA/1000
label variable reldist_USA "Geodesic distance, relative to USA"
gen reldifflat_USA=abs(difflat_1_to_USA-difflat_2_to_USA)
label variable reldifflat_USA "Latitude difference, relative to USA"
gen reldifflong_USA=abs(difflong_1_to_USA-difflong_2_to_USA)
label variable reldifflong_USA "Longitude difference, relative to USA"
gen relfreight_USA=abs(freight_cost_surface_1_to_USA-freight_cost_surface_2_to_USA)
label variable relfreight_USA "Freight cost, surface transport, relative to USA"

* Define relative measures of genetic and cultural distance
* First relative to UK
gen relgendist_fst=abs(fst_dist_europe_to_UK_1-fst_dist_europe_to_UK_2)/10000
label variable relgendist_fst "Genetic distance, relative to the English"
gen rellingdist_dom_formula=abs((((15-lingprox_dominant_to_UK_1)/15)^.5)-(((15-lingprox_dominant_to_UK_2)/15)^.5))
label variable rellingdist_dom_formula "Linguistic distance, plurality languages, relative to English"
gen rellingdist_weighted_formula=abs((((15-lingprox_weighted_to_UK_1)/15)^.5)-(((15-lingprox_weighted_to_UK_2)/15)^.5))
label variable rellingdist_weighted_formula "Linguistic Distance Index, weighted, relative to UK"
replace cognate_dominant_to_UK_1=1-(cognate_dominant_to_UK_1/1000)
replace cognate_dominant_to_UK_2=1-(cognate_dominant_to_UK_2/1000)
replace cognate_weighted_to_UK_1=1-(cognate_weighted_to_UK_1/1000)
replace cognate_weighted_to_UK_2=1-(cognate_weighted_to_UK_2/1000)
gen relcognate_dominant=abs(cognate_dominant_to_UK_1-cognate_dominant_to_UK_2)
label variable relcognate_dominant "1-% cognate, plurality languages, relative to English"
gen relcognate_weighted=abs(cognate_weighted_to_UK_1-cognate_weighted_to_UK_2)
label variable relcognate_weighted "1-% cognate, weighted, relative to the UK"
gen relreldist_dominant_formula=abs((((5-relprox_dominant_fearon_to_UK_1)/5)^.5)-(((5-relprox_dominant_fearon_to_UK_2)/5)^.5))
label variable relreldist_dominant_formula "Religious distance, plurality religions, relative to Anglicans"
gen relreldist_weighted_formula=abs((((5- relprox_weighted_fearon_to_UK_1)/5)^.5)-(((5- relprox_weighted_fearon_to_UK_2)/5)^.5))
label variable relreldist_weighted_formula "Religious distance, weighted, relative to the UK"

* Second relative to Germany
generate relgendist_fst_DEU=abs(fst_dist_europe_to_DEU_1-fst_dist_europe_to_DEU_2)/10000
label variable relgendist_fst_DEU "Genetic Distance, relative to Germany"
gen rellingdist_dom_formula_DEU=abs((((15-lingprox_dominant_to_DEU_1)/15)^.5)-(((15-lingprox_dominant_to_DEU_2)/15)^.5))
label variable rellingdist_dom_formula_DEU "Linguistic Distance Index, plurality languages, relative to German"
gen rellingdist_weighted_formula_DEU=abs((((15-lingprox_weighted_to_DEU_1)/15)^.5)-(((15-lingprox_weighted_to_DEU_2)/15)^.5))
label variable rellingdist_weighted_formula_DEU "Linguistic Distance Index, weighted, relative to Germany"
replace cognate_dominant_to_DEU_1=1-(cognate_dominant_to_DEU_1/1000)
replace cognate_dominant_to_DEU_2=1-(cognate_dominant_to_DEU_2/1000)
replace cognate_weighted_to_DEU_1=1-(cognate_weighted_to_DEU_1/1000)
replace cognate_weighted_to_DEU_2=1-(cognate_weighted_to_DEU_2/1000)
gen relcognate_dominant_DEU=abs(cognate_dominant_to_DEU_1-cognate_dominant_to_DEU_2)
label variable relcognate_dominant_DEU "1-% cognate, plurality languages, relative to DEU"
gen relcognate_weighted_DEU=abs(cognate_weighted_to_DEU_1-cognate_weighted_to_DEU_2)
label variable relcognate_weighted_DEU "1-% cognate, weighted, relative to Germany"
gen relreldist_dominant_formula_DEU=abs((((5-relprox_dominant_fearon_to_DEU_1)/5)^.5)-(((5-relprox_dominant_fearon_to_DEU_2)/5)^.5))
label variable relreldist_dominant_formula_DEU "Religious Distance Index, plurality religions, relative to Lutherans"
gen relreldist_weighted_formula_DEU=abs((((5-relprox_weighted_fearon_to_DEU_1)/5)^.5)-(((5-relprox_weighted_fearon_to_DEU_2)/5)^.5))
label variable relreldist_weighted_formula_DEU "Religious Distance Index, weighted, relative to Germany"

* Do preliminary exploration using UK as baseline frontier

preserve
keep if (wacziarg_1==176 | wacziarg_2==176)
gen wacziarg=wacziarg_2 if wacziarg_1==176
replace wacziarg=wacziarg_1 if wacziarg_2==176
gen country=country_2 if wacziarg_1==176
replace country=country_1 if wacziarg_2==176

order wacziarg country
gen rgdpch1995=rgdpch1995_2 if wacziarg_1==176
replace rgdpch1995=rgdpch1995_1 if wacziarg_2==176
keep if (rgdpch1995<10000000 & dist<100000000)

set obs 26
replace wacziarg=176 in 26
replace rgdpch1995=21248.87 in 26
replace gendist_fst_europe=0 in 26
replace dist=0 in 26
replace difflat=0 in 26
replace difflong=0 in 26
replace dist=0 in 26
replace contig=1 in 26
replace island_dummy=0 in 26
replace landlock_dummy=0 in 26
replace common_water=1 in 26
replace lingdist_weighted_formula=0 in 26
replace lingdist_dom_formula=0 in 26
replace cognate_weighted=0 in 26
replace cognate_dominant=0 in 26
replace reldist_weighted_formula=0 in 26
replace reldist_dominant_formula=0 in 26
replace min_av_elev=0 in 26
replace freight_cost_surface=0 in 26
replace country="United Kingdom" in 26

#delimit ;
gen linc1995=log(rgdpch1995);
label variable linc1995 "Log per capita income 1995";


sort wacziarg;
merge wacziarg using codes.dta;
drop if _merge==2;
drop country pwt60 pwt56 barro ccode _merge;
graph twoway (scatter linc1995 gendist_fst_europe, msymbol(i) mlabel(code) mlabposition(0)) (lfit linc1995 gendist_fst_europe, clwidth(medthick)), 
legend(off) ylabel(8.5(1)10.5) saving(regressions\figure5, replace) title("Figure 4 - Log Income in 1995 and Genetic Distance to the English, Europe Dataset", size(medsmall)) 
ytitle("Log per capita income 1995", size(medsmall)) xtitle("FST genetic distance to the English", size(medsmall)) 
graphregion(fcolor(white));
graph export regressions\figure4.ps, replace logo(off) orientation(landscape) mag(150);

restore;

* Table X - Summary statistics for the European dataset;
log using regressions\TableX.doc, replace text;
* a. Correlations between the main variables;
corr dlinc1995 gendist_fst_europe relgendist_fst dist freight_cost_surface rellingdist_dom_formula relreldist_dominant_formula_DEU;
* b. Summary statistics;
sum dlinc1995 gendist_fst_europe relgendist_fst dist freight_cost_surface rellingdist_dom_formula relreldist_dominant_formula_DEU if relreldist_dominant_formula_DEU<10000;
log close;

* Table 9 - Univariate and geographic controls - regressions with relative distance to the UK;

* Columns 1 and 2 - univariate regressions first;

cgmreg dlinc1995 gendist_fst_europe, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum gendist_fst_europe if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table9.doc, sigsymb(**,**,*) se ctitle("No controls, simple GD") bdec(3) 
title("Table 9 - Results for the European dataset (two-way clustered standard errors)") replace;

cgmreg dlinc1995 relgendist_fst, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table9.doc, sigsymb(**,**,*) se ctitle("No controls, relative GD") bdec(3) merge;

* Column 3 - Add geographic distance measures and trade costs;

cgmreg dlinc1995 relgendist_fst difflat difflong dist contig island_dummy landlock_dummy common_water min_av_elev freight_cost_surface, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table9.doc, sigsymb(**,**,*) se ctitle("Add micro-geography") bdec(3) merge;

* Column 4 - 1870 Regression - pay attention to singular matrix - exclude landlock_dummy (too few obs.);

cgmreg dlinc1870 relgendist_fst difflat difflong dist contig island_dummy common_water min_av_elev freight_cost_surface, cluster(wacziarg_1 wacziarg_2);
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if dlinc1870<10000000; scalar sdgd=r(sd);
sum dlinc1870 if dlinc1870<10000000; scalar sdinc1870=r(sd); scalar effect=100*coeff*sdgd/sdinc1870;
predict fit if e(sample); gen err=dlinc1870-fit; egen meaninc=mean(dlinc1870) if e(sample); gen devsq=(dlinc1870-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
scalar list effect RSQ;
outreg using regressions\Table9.doc, sigsymb(**,**,*) se ctitle("1870 Income data") bdec(3) merge;

* Table 10 - Control for cultural distance measures;
* Note: dropping Iceland due to lack of Fearon data;

* Column 1 - Baseline regression without Iceland - remove island dummy due to singularity;
cgmreg dlinc1995 relgendist_fst difflat difflong dist contig landlock_dummy common_water min_av_elev freight_cost_surface if (rellingdist_dom_formula<10000 & 
relreldist_dominant_formula_DEU<10000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table10.doc, sigsymb(**,**,*) se title("Table 10: Controlling for cultural distance in the Europe dataset (two-way clustered standard errors)")
ctitle("Baseline") bdec(3) replace;

* Columns 2 - add cultural distance measures, together;

cgmreg dlinc1995 relgendist_fst difflat difflong dist contig landlock_dummy common_water min_av_elev freight_cost_surface rellingdist_dom_formula 
relreldist_dominant_formula_DEU, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table10.doc, sigsymb(**,**,*) se ctitle("Both measures, weighted") bdec(3) merge;

* Now include 1 - % cognate measures (different sample - lose Hungary and Finland);

* Column 3 - Baseline with sample for which 1- % cognate (dominant) is not missing - drop island dummy to avoid singularity;
cgmreg dlinc1995 relgendist_fst difflat difflong dist contig landlock_dummy common_water min_av_elev freight_cost_surface if (relcognate_dominant<10000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table10.doc, sigsymb(**,**,*) se ctitle("% cognate, plurality") bdec(3) merge;

* Column 4 - Add 1 - % cognate (dominant) - drop island dummy to avoid singularity;
cgmreg dlinc1995 relgendist_fst difflat difflong dist contig landlock_dummy common_water min_av_elev freight_cost_surface relcognate_dominant, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1]; sum relgendist_fst if e(sample); scalar sdgd=r(sd);
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd); scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table10.doc, sigsymb(**,**,*) se ctitle("% cognate, plurality") bdec(3) merge;
