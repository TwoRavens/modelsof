clear
set memory 60m
set matsize 400
set more off
use bilateral

* Last updated January 8 2008
* Define Variables

replace dist=dist/1000
label variable dist "Geodesic Distance (1000s of km)"
gen gendist_fst=fst_distance_dominant/10000
label variable gendist_fst "Fst Genetic Distance"
replace gendist_fst_1500=gendist_fst_1500/10000
replace fst_distance_weighted=fst_distance_weighted/10000
label variable fst_distance_weighted "Weighted Fst Genetic Distance"
label variable gendist_fst_1500 "Fst Genetic Distance, 1500 match"
gen gendist_nei=nei_distance_dominant/10000
label variable gendist_nei "Nei Genetic Distance"
gen gendist_nei_weighted=nei_distance_weighted/10000
label variable gendist_nei_weighted "Nei Genetic Distance, weighted"
replace gendist_nei_1500=gendist_nei_1500/10000
label variable gendist_nei_1500 "Nei Genetic Distance, 1500 match"
label variable relgendist_fst_weighted_USA "Fst gen. dist. relative to the USA, weighted"
gen difflat=(abs(latitude_cia_2-latitude_cia_1))/100
label variable difflat "Absolute difference in latitudes"
* Note the correct definition of longitudinal difference below
gen difflong=abs(longitude_cia_1-longitude_cia_2)
replace difflong=360-difflong if difflong>180
replace difflong=difflong/100
label variable difflong "Absolute difference in longitudes"
gen dlinc1960=abs(log(rgdpch1960_1)-log(rgdpch1960_2))
label variable dlinc1960 "Absolute difference in log income (PWT), 1960"
gen dlinc1995=abs(log(wb_gdppc1995_2)-log(wb_gdppc1995_1))
label variable dlinc1995 "Absolute difference in log income (WB), 1995"
label variable comlang_ethno "1 if common language (9% threshold)"
label variable relgendist_fst_USA "Fst genetic distance relative to the USA"
replace cognate_dominant=1-(cognate_dominant/1000)
label variable cognate_dominant "1 - % cognate, dominant languages"
replace cognate_weighted=1-(cognate_weighted/1000)
label variable cognate_weighted "1 - % cognate, weighted"
replace cognate_dom_to_USA_1=1-(cognate_dom_to_USA_1/1000)
replace cognate_weighted_to_USA_1=1-(cognate_weighted_to_USA_1/1000)
replace cognate_dom_to_USA_2=1-(cognate_dom_to_USA_2/1000)
replace cognate_weighted_to_USA_2=1-(cognate_weighted_to_USA_2/1000)

gen eurasia_1=weurope_1+eeurope_1+nafrica_1+seasia_1+soasia_1+scasia_1+mideast_1
gen eurasia_2=weurope_2+eeurope_2+nafrica_2+seasia_2+soasia_2+scasia_2+mideast_2
gen diamond_gap=abs(eurasia_2-eurasia_1)
drop eurasia_1 eurasia_2
label variable diamond_gap "Diamond Gap"
#delimit ;
gen climate_area=(100*(abs(kg_a_af_1-kg_a_af_2)+abs(kg_a_am_1-kg_a_am_2)+abs(kg_a_aw_1-kg_a_aw_2)+abs(kg_a_bs_1-kg_a_bs_2)
+abs(kg_a_bw_1-kg_a_bw_2)+abs(kg_a_cf_1-kg_a_cf_2)+abs(kg_a_cs_1-kg_a_cs_2)+abs(kg_a_cw_1-kg_a_cw_2)
+abs(kg_a_dw_1-kg_a_dw_2)+abs(kg_a_df_1-kg_a_df_2)+abs(kg_a_h_1-kg_a_h_2)+abs(kg_a_e_1-kg_a_e_2)))/12;
gen climate_pop=(100*(abs(kg_p_af_1-kg_p_af_2)+abs(kg_p_am_1-kg_p_am_2)+abs(kg_p_aw_1-kg_p_aw_2)+abs(kg_p_bs_1-kg_p_bs_2)
+abs(kg_p_bw_1-kg_p_bw_2)+abs(kg_p_cf_1-kg_p_cf_2)+abs(kg_p_cs_1-kg_p_cs_2)+abs(kg_p_cw_1-kg_p_cw_2)
+abs(kg_p_dw_1-kg_p_dw_2)+abs(kg_p_df_1-kg_p_df_2)+abs(kg_p_e_1-kg_p_e_2)+abs(kg_p_h_1-kg_p_h_2)))/12;
label variable climate_area "Measure of climatic difference of land areas, by 12 KG zones";
label variable climate_pop "Measure of climatic difference of populations, by 12 KG zones";
gen relig_diff=(abs(buddis00_1-buddis00_2)+abs(cath00_1-cath00_2)+abs(easrel00_1-easrel00_2)+abs(hindu00_1-hindu00_2)
+abs(jews00_1-jews00_2)+abs(muslim00_1-muslim00_2)+abs(nonrel00_1-nonrel00_2)+abs(orth00_1-orth00_2)
+abs(othchrist00_1-othchrist00_2)+abs(othrel00_1-othrel00_2)+abs(prot00_1-prot00_2))/11;
label variable relig_diff "Religious Difference, based on Barrett Data";
#delimit cr
gen dtropics=abs(kgatr_2-kgatr_1)
label variable dtropics "Difference in % land area in KG tropical climates (Am+Af+Aw)"

* Define microgeography variables
gen common_water=common_sea+common_ocean+common_bay+common_channel+common_gulf
replace common_water=1 if common_water>1
label variable common_water "=1 if pair shares at least one sea or ocean"
gen diff_elev=abs((elevation_1/1000)-(elevation_2)/1000)
label variable diff_elev "Absolute value of difference in average elevation"
gen landlock_1=(coastline_km_1==0)
gen landlock_2=(coastline_km_2==0)
gen landlock_dummy=(landlock_1==1 | landlock_2==1)
label variable landlock_dummy "=1 if either country is landlocked"
gen island_1=(land_boundaries_km_1==0)
gen island_2=(land_boundaries_km_2==0)
gen island_dummy=(island_1==1 | island_2==1)
label variable island_dummy "=1 if either country is an island"
replace freight_cost_surface= freight_cost_surface/1000

gen europe_1=weurope_1+eeurope_1
gen europe_2=weurope_2+eeurope_2
gen asia_1=(asiae_1+seasia_1+soasia_1+scasia_1+mideast_1)
replace asia_1=1 if asia_1==2
gen asia_2=(asiae_2+seasia_2+soasia_2+scasia_2+mideast_2)
replace asia_2=1 if asia_2==2
gen africa_1=nafrica_1+ssafrica_1
gen africa_2=nafrica_2+ssafrica_2
gen both_in_asia=(asia_1==1 & asia_2==1)
label variable both_in_asia "Both in Asia Dummy"
gen both_in_africa=(africa_1==1 & africa_2==1)
label variable both_in_africa "Both in Africa Dummy"
gen both_in_europe=(europe_1==1 & europe_2==1)
label variable both_in_europe "Both in Europe Dummy"
gen both_in_namerica=(namerica_1==1 & namerica_2==1)
label variable both_in_namerica "Both in North America Dummy"
gen both_in_samerica=(laamcarib_1==1 & laamcarib_2==1)
label variable both_in_samerica "Both in Latin America/Caribbean dummy"
gen both_in_oceania=(oceania_1==1 & oceania_2==1)
label variable both_in_oceania "Both in Oceania Dummy"
gen same_continent=(both_in_asia==1 | both_in_africa==1 | both_in_europe==1 | both_in_namerica==1 | both_in_samerica==1 | both_in_oceania==1)
label variable same_continent "Same Continent dummy"

gen one_in_asia=(asia_1==1 | asia_2==1)
replace one_in_asia=one_in_asia-both_in_asia
label variable one_in_asia "Dummy if one and only one country is in Asia"
gen one_in_africa=(africa_1==1 | africa_2==1)
replace one_in_africa=one_in_africa-both_in_africa
label variable one_in_africa "Dummy if one and only one country is in Africa"
gen one_in_europe=(europe_1==1 | europe_2==1)
replace one_in_europe=one_in_europe-both_in_europe
label variable one_in_europe "Dummy if one and only one country is in Europe"
gen one_in_namerica=(namerica_1==1 | namerica_2==1)
replace one_in_namerica=one_in_namerica-both_in_namerica
label variable one_in_namerica "Dummy if one and only one country is in North America"
gen one_in_samerica=(laamcarib_1==1 | laamcarib_2==1)
replace one_in_samerica=one_in_samerica-both_in_samerica
label variable one_in_samerica "Dummy if one and only one country is in South America"
gen one_in_oceania=(oceania_1==1 | oceania_2==1)
replace one_in_oceania=one_in_oceania-both_in_oceania
label variable one_in_oceania "Dummy if one and only one country is in Oceania"
gen different_continent=(one_in_asia==1 | one_in_africa==1 | one_in_europe==1 | one_in_namerica==1 | one_in_samerica==1 | one_in_oceania==1)
label variable different_continent "Different Continent dummy"

* Define relative geographic distance to USA
gen reldist_USA=(abs(dist_1_to_USA-dist_2_to_USA))/1000
label variable reldist_USA "Geodesic Distance, relative to USA"
gen reldifflat_USA=(abs(difflat_1_to_USA-difflat_2_to_USA))/100
label variable reldifflat_USA "Latitude difference, relative to USA"
gen reldifflong_USA=(abs(difflong_1_to_USA-difflong_2_to_USA))/100
label variable reldifflong_USA "Longitude difference, relative to USA"
gen relfreight_USA=(abs(freight_cost_surface_1_to_USA-freight_cost_surface_2_to_USA))/1000
label variable relfreight_USA "Freight cost (surface transport), relative to the USA"

* Define cultural measures
gen lingdist_dom_formula=((15-lingprox_dominant)/15)^.5
label variable lingdist_dom_formula "Linguistic Distance Index, dominant languages"
gen lingdist_weighted_formula=((15-lingprox_weighted)/15)^.5
label variable lingdist_weighted_formula "Linguistic Distance Index, weighted"
gen reldist_dominant_formula=((5-relprox_dominant_fearon)/5)^.5
label variable reldist_dominant_formula "Religious Distance Index, dominant religions, Fearon"
gen reldist_weighted_formula=((5-relprox_weighted_fearon)/5)^.5
label variable reldist_weighted_formula "Religious Distance Index, weighted, Fearon"

* Now compute measures of relative cultural distance to the USA
gen lingdist_dom_formula_to_USA_1=((15-lingprox_dom_to_USA_1)/15)^.5
gen lingdist_w_formula_to_USA_1=((15-lingprox_weighted_to_USA_1)/15)^.5
gen reldist_dom_formula_to_USA_1=((5-relprox_dom_fearon_to_USA_1)/5)^.5
gen reldist_w_formula_to_USA_1=((5-relprox_weighted_fearon_to_USA_1)/5)^.5
gen lingdist_dom_formula_to_USA_2=((15-lingprox_dom_to_USA_2)/15)^.5
gen lingdist_w_formula_to_USA_2=((15-lingprox_weighted_to_USA_2)/15)^.5
gen reldist_dom_formula_to_USA_2=((5-relprox_dom_fearon_to_USA_2)/5)^.5
gen reldist_w_formula_to_USA_2=((5-relprox_weighted_fearon_to_USA_2)/5)^.5

gen rel_lingdist_dom_formula_to_USA=abs(lingdist_dom_formula_to_USA_1-lingdist_dom_formula_to_USA_2)
label variable rel_lingdist_dom_formula_to_USA "Linguistic distance index, relative to USA, plurality"
gen rel_lingdist_w_formula_to_USA=abs(lingdist_w_formula_to_USA_1-lingdist_w_formula_to_USA_2)
label variable rel_lingdist_w_formula_to_USA "Linguistic distance index, relative to USA, weighted"
gen rel_reldist_dom_formula_to_USA=abs(reldist_dom_formula_to_USA_1-reldist_dom_formula_to_USA_2)
label variable rel_reldist_dom_formula_to_USA "Religious distance index, relative to USA, plurality"
gen rel_reldist_w_formula_to_USA=abs(reldist_w_formula_to_USA_1-reldist_w_formula_to_USA_2)
label variable rel_reldist_w_formula_to_USA "Religious distance index, relative to USA, weighted"
gen rel_cognate_dom_to_USA=abs(cognate_dom_to_USA_1-cognate_dom_to_USA_2)
label variable rel_cognate_dom_to_USA "1-% cognate, relative to USA, plurality"
gen rel_cognate_weighted_to_USA=abs(cognate_weighted_to_USA_1-cognate_weighted_to_USA_2)
label variable rel_cognate_weighted_to_USA "1-% cognate, relative to USA, weighted"

* Define Maddison Historical Income Data
gen dlinc1500=abs(log(y1500_1)-log(y1500_2))
gen dlinc1700=abs(log(y1700_1)-log(y1700_2))
gen dlinc1820=abs(log(y1820_1)-log(y1820_2))
gen dlinc1870=abs(log(y1870_1)-log(y1870_2))
gen dlinc1913=abs(log(y1913_1)-log(y1913_2))

* Select observations to ensure same sample in all regressions
* Note: delete the following line to maximize the sample size per regression
drop if dist>10000000 | freight_cost_surface>10000 | climate_area>100000 | rel_lingdist_w_formula_to_USA>1000000 | rel_reldist_w_formula_to_USA>1000000 | fst_distance_weighted>100000

* Do preliminary exploration using US as baseline frontier

preserve
keep if (wacziarg_1==177 | wacziarg_2==177)
gen wacziarg=wacziarg_2 if wacziarg_1==177
replace wacziarg=wacziarg_1 if wacziarg_2==177
order wacziarg
gen wb_gdppc1995=wb_gdppc1995_2 if wacziarg_1==177
replace wb_gdppc1995=wb_gdppc1995_1 if wacziarg_2==177
keep if (wb_gdppc1995<10000000)

set obs 137
replace wacziarg=177 in 137
replace wb_gdppc1995=27819.87 in 137
replace fst_distance_weighted=0 in 137
replace dist=0 in 137
replace difflat=0 in 137
replace difflong=0 in 137
replace dist=0 in 137
replace contig=1 in 137
replace island_dummy=0 in 137
replace landlock_dummy=0 in 137
replace common_water=1 in 137
replace lingdist_weighted_formula=0 in 137
replace cognate_weighted=1 in 137
replace reldist_weighted_formula=0 in 137
replace freight_cost_surface=0 in 137

#delimit ;
gen linc1995=log(wb_gdppc1995);
label variable linc1995 "Log per capita income 1995";
regress linc1995 fst_distance_weighted, robust beta;
outreg using regressions\Table1.doc, sigsymb(**,**,*) se ctitle("Univariate") bdec(3) title("Table 1 - Income level regressions") replace;
regress linc1995 fst_distance_weighted difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface, robust beta;
outreg using regressions\Table1.doc, sigsymb(**,**,*) se ctitle("Add geographic distance") bdec(3) merge;
regress linc1995 fst_distance_weighted difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface lingdist_weighted_formula reldist_weighted_formula, robust beta;
outreg using regressions\Table1.doc, sigsymb(**,**,*) se ctitle("Add cultural distance") bdec(3) merge;

sort wacziarg;
merge wacziarg using codes.dta;
drop if _merge==2;
drop country pwt60 pwt56 barro ccode _merge;
*graph twoway (scatter linc1995 fst_distance_weighted, msymbol(i) mlabel(code) mlabposition(0)) (lfit linc1995 fst_distance_weighted, clwidth(medthick)), 
legend(off) ylabel(5(1)11) saving(regressions\figure3, replace) title("Figure 3 - Log Income in 1995 and Genetic Distance to the USA", size(medsmall)) 
ytitle("Log per capita income 1995", size(medsmall)) xtitle("FST Genetic distance to the USA, weighted", size(medsmall)) 
graphregion(fcolor(white));
*graph export regressions\figure3.ps, replace logo(off) orientation(landscape) mag(150);
restore;

#delimit ;

* Table 2;
log using regressions\Table2.doc, text replace;
* Table 2 - Summary statistics for the main variables;
* Panel a. Simple correlations among genetic and economic distance measures (World Dataset);
corr fst_distance_weighted relgendist_fst_weighted_USA gendist_fst_1500 gendist_nei_weighted dlinc1995 if dist<1000000;
corr fst_distance_weighted relgendist_fst_weighted_USA gendist_fst_1500 gendist_nei_weighted dlinc1995 dlinc1500 if dist<1000000;
corr fst_distance_weighted relgendist_fst_weighted_USA gendist_fst_1500 gendist_nei_weighted dlinc1995 dlinc1870 if dist<1000000;
*Panel b. Means and standard deviations;
tabstat fst_distance_weighted relgendist_fst_weighted_USA gendist_fst_1500 gendist_nei_weighted dlinc1995 if dist<1000000, casewise statistics(count, mean, sd, min, max);
tabstat fst_distance_weighted relgendist_fst_weighted_USA gendist_fst_1500 gendist_nei_weighted dlinc1995 dlinc1500 if dist<1000000, casewise statistics(count, mean, sd, min, max);
tabstat fst_distance_weighted relgendist_fst_weighted_USA gendist_fst_1500 gendist_nei_weighted dlinc1995 dlinc1870 if dist<1000000, casewise statistics(count, mean, sd, min, max);
log close;

* Baseline Regressions, univariate;

cgmreg dlinc1995 gendist_fst if (dist<10000 & fst_distance_weighted<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;

* Setup scalars to compute effects in Table 3;
sum dlinc1995 if e(sample);
scalar sdinc1995=r(sd);
sum gendist_fst if e(sample);
scalar sdgdfst=r(sd);
sum relgendist_fst_USA if e(sample);
scalar sdrgd=r(sd);
sum fst_distance_weighted if e(sample);
scalar sdwgd=r(sd);
sum relgendist_fst_weighted_USA if e(sample);
scalar sdwrgd=r(sd);
sum gendist_nei if e(sample);
scalar sdgdnei=r(sd);

matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdgdfst/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table3.doc, sigsymb(**,**,*) se ctitle("FST Gen. Dist.") bdec(3) 
title("Table 3 - Univariate regressions (Dependent variable: absolute value of log income differences, 1995)") replace;

cgmreg dlinc1995 relgendist_fst_USA if (dist<10000 & fst_distance_weighted<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar releff=coeffs[1,1]; scalar effect=100*releff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table3.doc, sigsymb(**,**,*) se ctitle("FST Gen Dist, relative to US") bdec(3) merge;

cgmreg dlinc1995 fst_distance_weighted if (dist<10000 & fst_distance_weighted<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar wfsteff=coeffs[1,1]; scalar effect=100*wfsteff*sdwgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table3.doc, sigsymb(**,**,*) se ctitle("Weighted FST Gen. Dist.") bdec(3) merge;

cgmreg dlinc1995 relgendist_fst_weighted_USA if (dist<10000 & fst_distance_weighted<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar relweff=coeffs[1,1]; scalar effect=100*relweff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table3.doc, sigsymb(**,**,*) se ctitle("Weighted FST Gen. Dist., relative to US") bdec(3) merge;

cgmreg dlinc1995 gendist_nei_weighted if (dist<10000 & fst_distance_weighted<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar neieff=coeffs[1,1]; scalar effect=100*neieff*sdgdnei/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table3.doc, sigsymb(**,**,*) se ctitle("Weighted Nei Gen. Dist.") bdec(3) merge;

gen fststerr=(1147-fst_stderr_dominant)/1147;
cgmreg dlinc1995 gendist_fst if (dist<10000 & fst_distance_weighted<100000) [aweight=fststerr], cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar fsteffw=coeffs[1,1]; scalar effect=100*fsteffw*sdgdfst/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table3.doc, sigsymb(**,**,*) se ctitle("Weighted regression") bdec(3) merge;

* Table 4 - Controlling for geographic distance;

* Setup scalars to compute effects in Table 4;
sum dlinc1995 if (dist<1000000 & relgendist_fst_weighted_USA<100000 & freight_cost_surface<10000 & climate_area<100000);
scalar sdinc1995=r(sd);
sum dlinc1995 if (dist<1000000 & relgendist_fst_weighted_USA<100000 & freight_cost_surface<10000 & climate_area<100000);
scalar sdinc1995w=r(sd);
sum relgendist_fst_weighted_USA if (dist<1000000 & dlinc1995<10000 & relgendist_fst_weighted_USA<100000 & freight_cost_surface<10000 & climate_area<100000);
scalar sdwrgd=r(sd);

* Column 1 - replicate baseline for comparability;

cgmreg dlinc1995 relgendist_fst_weighted_USA if (dist<10000 & freight_cost_surface<10000 & climate_area<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se title("Table 4 - Controlling for geographic distance (Dependent variable: absolute value of log income differences, 1995)")
ctitle("Baseline") bdec(3) replace;

* Column 2 - Simple measures of distance;

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist if (freight_cost_surface<10000 & climate_area<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se ctitle("Distance Metrics") bdec(3) merge;

* Column 3 - Add measures of microgeography - Note adding diff_elev and itc2 lead to no change but large loss of observations;

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water if (freight_cost_surface<10000 & climate_area<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se ctitle("Add microgeography controls") bdec(3) merge;

* Column 4 - Now add new measure of transportation costs;

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if (climate_area<100000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se ctitle("Add transport costs") bdec(3) merge;

* Columns 5 - Add continent dummies (both same and different continent versions);

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface
both_in_asia both_in_africa both_in_europe both_in_namerica both_in_samerica both_in_oceania 
one_in_asia one_in_africa one_in_europe one_in_namerica one_in_samerica if climate_area<100000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se ctitle("Continent dummies") bdec(3) merge;

* Columns 6-7: Control for Koeppen-Geiger climatic difference;

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface climate_area, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se ctitle("Climatic difference control") bdec(3) merge;

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface dtropics, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar fsteff=coeffs[1,1]; scalar effect=100*fsteff*sdwrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table4.doc, sigsymb(**,**,*) se ctitle("Tropical difference control") bdec(3) merge;

* Table 5 - Tests of the Diamond hypothesis and IV results;

* Column 1: Use 1500 GDs as instruments for current GDs - requires doing 2SLS for correct SEs;
* Note: Two way clustering not available;
* First stage;
cgmreg relgendist_fst_weighted_USA relgendist_fst_1500_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if (dlinc1995<100000 & climate_area<100000), cluster(wacziarg_1 wacziarg_2);
predict fitted_gd, xb;
replace fitted_gd=. if relgendist_fst_weighted_USA>10000;
replace fitted_gd=. if dlinc1995>10000;
replace fitted_gd=. if climate_area>100000;
cgmreg dlinc1995 fitted_gd difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface 
if climate_area<100000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; sum dlinc1995 if e(sample); scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_USA if e(sample); scalar sdrgd=r(sd); scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table5.doc, sigsymb(**,**,*) se title("Table 5 - Endogeneity of genetic distance and Diamond gap (two-way clustered standard errors)")
ctitle("2SLS with 1500 GD") bdec(3) replace;

* Column 2 - Drop New World;

preserve;
drop if (oceania_1==1 | oceania_2==1 | namerica_1==1 | laamcarib_1==1 | namerica_2==1 | laamcarib_2==1);
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; sum dlinc1995 if e(sample); scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_USA if e(sample); scalar sdrgd=r(sd); scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table5.doc, sigsymb(**,**,*) se ctitle("Without New World") bdec(3) merge;

* Columns 3-4: Diamond Gap Regressions;
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface diamond_gap, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; sum dlinc1995 if e(sample); scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_USA if e(sample); scalar sdrgd=r(sd); scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table5.doc, sigsymb(**,**,*) se ctitle("Diamond Gap, w/o New World") bdec(3) merge;
restore;

cgmreg dlinc1500 relgendist_fst_1500_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface diamond_gap, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1500-fit; egen meaninc=mean(dlinc1500) if e(sample); gen devsq=(dlinc1500-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; sum dlinc1500 if e(sample); scalar sdinc1500=r(sd);
sum relgendist_fst_1500_UK if e(sample); scalar sdrgd=r(sd); scalar effect=100*eff*sdrgd/sdinc1500;
scalar list effect RSQ;
outreg using regressions\Table5.doc, sigsymb(**,**,*) se ctitle("Income 1500, Diamond Gap") bdec(3) merge;

* Tables 6 - 8 - Controling for common history and cultural similarity variables - use relative cultural distance;

* Table 6 - Summary statistics for genetic distance and measures of cultural distance;
log using regressions\Table6.doc, text replace;

* Panel a: Correlations between genetic distance and various measures of cultural distance;
corr fst_distance_weighted lingdist_weighted_formula reldist_weighted_formula relgendist_fst_weighted_USA rel_lingdist_w_formula_to_USA rel_reldist_w_formula_to_USA 
if (dlinc1995<10000 & dist<1000000 & freight_cost_surface<10000);
* Panel b: Summary statistics for genetic distance and various measures of cultural distance;
tabstat fst_distance_weighted lingdist_weighted_formula reldist_weighted_formula relgendist_fst_weighted_USA rel_lingdist_w_formula_to_USA rel_reldist_w_formula_to_USA 
if (dlinc1995<10000 & dist<1000000 & freight_cost_surface<100000), casewise statistics(count, mean, sd, min, max);

log close;

* Table 7;
* Column 1 - Replicate baseline;
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface 
if (rel_lingdist_w_formula_to_USA<1000000 & rel_reldist_w_formula_to_USA<1000000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; 
sum dlinc1995 if e(sample); scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_USA if e(sample); scalar sdrgd=r(sd); 
scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7.doc, sigsymb(**,**,*) se title("Table 7 - Controlling for common history and cultural distance (two-way clustered standard errors)")
ctitle("Baseline") bdec(3) replace;

* Column 2 - Add colonial history controls;
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface smctry colony comcol curcol 
if (rel_lingdist_w_formula_to_USA<1000000 & rel_reldist_w_formula_to_USA<1000000), cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7.doc, sigsymb(**,**,*) se ctitle("Colonial history controls") bdec(3) merge;

* Columns 3 - Add linguistic similarity measure based on Fearon's tree data - weighted;
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface smctry colony comcol curcol rel_lingdist_w_formula_to_USA 
if rel_reldist_w_formula_to_USA<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7.doc, sigsymb(**,**,*) se ctitle("Linguistic distance, weighted") bdec(3) merge;

* Columns 4 - Add religious distance measures;
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface smctry colony comcol curcol rel_reldist_w_formula_to_USA 
if rel_lingdist_w_formula_to_USA<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7.doc, sigsymb(**,**,*) se ctitle("Religious distance, weighted") bdec(3) merge;

* Columns 5 - Add both religious and linguistic distance measures together;
cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface smctry colony comcol curcol rel_reldist_w_formula_to_USA 
rel_lingdist_w_formula_to_USA, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7.doc, sigsymb(**,**,*) se ctitle("Religious + Linguistics, weighted") bdec(3) merge;

* Table 7b - Add lexicostatistical measure (dominant);

* Replicate baseline for sample for which dominant lexicostatistical data is available;
sum dlinc1995 if (dist<1000000 & relgendist_fst_weighted_USA<100000 & rel_cognate_dom_to_USA<1000000 & freight_cost_surface<100000);
scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_USA if (dist<1000000 & dlinc1995<10000 & rel_cognate_dom_to_USA<1000000 & freight_cost_surface<100000);
scalar sdrgd=r(sd);

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface smctry colony comcol curcol
if rel_cognate_dom_to_USA<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7b.doc, sigsymb(**,**,*) se ctitle("Baseline") bdec(3) title("Table 7b - Controlling for lexicostatistical measures (two-way clustered standard errors)") replace;

* Now add dominant lexico measure - notes small sample due to Indoeuropean only;

cgmreg dlinc1995 relgendist_fst_weighted_USA difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface smctry colony comcol curcol
rel_cognate_dom_to_USA, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar eff=coeffs[1,1]; scalar effect=100*eff*sdrgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table7b.doc, sigsymb(**,**,*) se ctitle("% cognate, dominant") bdec(3) merge;

* Table 8 - Historical Regressions, using PWT and Maddison Historical Data;
* Start with unconstrained samples;

cgmreg dlinc1500 relgendist_fst_1500_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1500-fit; egen meaninc=mean(dlinc1500) if e(sample); gen devsq=(dlinc1500-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1500 if e(sample);
scalar sdinc1500=r(sd);
sum relgendist_fst_1500_UK if e(sample);
scalar sdgd1500=r(sd);
scalar effect=100*coeff*sdgd1500/sdinc1500;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1500") 
title("Table 8 - Regressions using historical income data (two-way clustered standard errors)") bdec(3) replace;

cgmreg dlinc1700 relgendist_fst_1500_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1700-fit; egen meaninc=mean(dlinc1700) if e(sample); gen devsq=(dlinc1700-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1700 if e(sample);
scalar sdinc1700=r(sd);
sum relgendist_fst_1500_UK if e(sample);
scalar sdrgd1500=r(sd);
scalar effect=100*coeff*sdrgd1500/sdinc1700;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1700") bdec(3) merge;

cgmreg dlinc1820 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1820-fit; egen meaninc=mean(dlinc1820) if e(sample); gen devsq=(dlinc1820-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1820 if e(sample);
scalar sdinc1820=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1820;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1820") bdec(3) merge;

cgmreg dlinc1870 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1870-fit; egen meaninc=mean(dlinc1870) if e(sample); gen devsq=(dlinc1870-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1870 if e(sample);
scalar sdinc1870=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1870;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1870") bdec(3) merge;

cgmreg dlinc1913 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1913-fit; egen meaninc=mean(dlinc1913) if e(sample); gen devsq=(dlinc1913-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1913 if e(sample);
scalar sdinc1913=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1913;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1913") bdec(3) merge;

cgmreg dlinc1960 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1960-fit; egen meaninc=mean(dlinc1960) if e(sample); gen devsq=(dlinc1960-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1960 if e(sample);
scalar sdinc1960=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1960;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1960") bdec(3) merge;

cgmreg dlinc1995 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface , cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1995 if e(sample);
scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect RSQ;
outreg using regressions\Table8.doc, sigsymb(**,**,*) se ctitle("Income 1995") bdec(3) merge;

* Now constrained samples [for standardized beta of common sample in Table 10];

cgmreg dlinc1500 relgendist_fst_1500_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1500-fit; egen meaninc=mean(dlinc1500) if e(sample); gen devsq=(dlinc1500-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1500 if e(sample);
scalar sdinc1500=r(sd);
sum relgendist_fst_1500_UK if e(sample);
scalar sdgd1500=r(sd);
scalar effect=100*coeff*sdgd1500/sdinc1500;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1500") 
title("Table 8b - Regressions using Historical Income Data (two-way clustered standard errors)") bdec(3) replace;

cgmreg dlinc1700 relgendist_fst_1500_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1700-fit; egen meaninc=mean(dlinc1700) if e(sample); gen devsq=(dlinc1700-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1700 if e(sample);
scalar sdinc1700=r(sd);
sum relgendist_fst_1500_UK if e(sample);
scalar sdrgd1500=r(sd);
scalar effect=100*coeff*sdrgd1500/sdinc1700;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1700") bdec(3) merge;

cgmreg dlinc1820 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1820-fit; egen meaninc=mean(dlinc1820) if e(sample); gen devsq=(dlinc1820-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1820 if e(sample);
scalar sdinc1820=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1820;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1820") bdec(3) merge;

cgmreg dlinc1870 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1870-fit; egen meaninc=mean(dlinc1870) if e(sample); gen devsq=(dlinc1870-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1870 if e(sample);
scalar sdinc1870=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1870;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1870") bdec(3) merge;

cgmreg dlinc1913 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1913-fit; egen meaninc=mean(dlinc1913) if e(sample); gen devsq=(dlinc1913-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1913 if e(sample);
scalar sdinc1913=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1913;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1913") bdec(3) merge;

cgmreg dlinc1960 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1 wacziarg_2);
predict fit if e(sample); gen err=dlinc1960-fit; egen meaninc=mean(dlinc1960) if e(sample); gen devsq=(dlinc1960-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1960 if e(sample);
scalar sdinc1960=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1960;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1960") bdec(3) merge;

regress dlinc1995 relgendist_fst_weighted_UK difflat difflong dist contig island_dummy landlock_dummy common_water freight_cost_surface if dlinc1500<1000000, cluster(wacziarg_1);
predict fit if e(sample); gen err=dlinc1995-fit; egen meaninc=mean(dlinc1995) if e(sample); gen devsq=(dlinc1995-meaninc)^2;
gen SST=sum(devsq); scalar SSqT=SST[_N]; gen errsq=err^2; gen SSE=sum(errsq); scalar SSqE=SSE[_N]; scalar RSQ=1-SSqE/SSqT; drop err fit meaninc devsq SST SSE errsq;
matrix coeffs=e(b); scalar coeff=coeffs[1,1];
sum dlinc1995 if e(sample);
scalar sdinc1995=r(sd);
sum relgendist_fst_weighted_UK if e(sample);
scalar sdgd=r(sd);
scalar effect=100*coeff*sdgd/sdinc1995;
scalar list effect;
outreg using regressions\Table8b.doc, sigsymb(**,**,*) se ctitle("Income 1995") bdec(3) merge;

