
#delimit;
clear all;
capture log close;
set mem 400m;
set matsize 1200;
version 10;

***************************************************;
**** THIS FILE GENERATES FIGURE 5 IN THE PAPER ****;
***************************************************;

capture log close;
log using logs\AllMunicipalities100km.log,replace;

************************************;
**** Analyze Muncipalities Data ****;
************************************;

clear;
u data\AllMunicipalities.dta;

egen rk_MunPop50km=rank(MunPop50km), field;
gen lMunPop50km=ln(MunPop50km);
gen lrk_MunPop50km=ln(rk_MunPop50km);

egen rk_MunGDP50km=rank(MunGDP50km), field;
gen lMunGDP50km=ln(MunGDP50km);
gen lrk_MunGDP50km=ln(rk_MunGDP50km);

egen rks_MunPop50km=rank(MunPop50km) if stadtkreis==1, field;
gen lrks_MunPop50km=ln(rks_MunPop50km);

egen rks_MunGDP50km=rank(MunGDP50km) if stadtkreis==1, field;
gen lrks_MunGDP50km=ln(rks_MunGDP50km);

egen rkf_MunPop50km=rank(MunPop50km) if MunPop>50000, field;
gen lrkf_MunPop50km=ln(rkf_MunPop50km);

egen rkf_MunGDP50km=rank(MunGDP50km) if MunPop>50000, field;
gen lrkf_MunGDP50km=ln(rkf_MunGDP50km);

gen sample=1;
replace sample=0 if OriginName=="Helgoland";

set scheme s1mono;

*  Figure for all German cities with a population bigger than 50,000 in 2002;

graph twoway (scatter lrkf_MunGDP50 lMunGDP50km if sample==1&MunPop>50000&expname=="", msymbol(oh) msize(small) mcolor(gray))
(scatter lrkf_MunGDP50 lMunGDP50km if sample==1&expname~=""&MunPop>50000, msymbol(O) msize(medium) mcolor(black))
(scatter lrkf_MunGDP50 lMunGDP50km if sample==1&MunPop>50000, msymbol(i) mlabel(expname) mlabposition(2)),
ytitle(log rank) xtitle(log local GDP)
legend(off)
title(Figure 5: Local GDP for German Cities)
note("Note: Figure displays German cities with a population greater than 50,000 in 2002. Local GDP is the sum of GDP in all municipalities"
"whose centroids lie within 50km of the centroid of a city. Municipality GDP is constructed using municipality population and GDP per"
"capita in the county where the municipality is located. Rank is defined so that the city with the largest local GDP has a rank of 1."
"See the footnote to Figure 4 for the list of three letter codes.", size(vsmall));

graph export graphs\Figure5.eps , replace as(eps);

