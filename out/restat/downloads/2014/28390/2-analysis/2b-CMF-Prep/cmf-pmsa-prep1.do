#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; 
set more off;
chdir $coaggl/growth/cmf;
log using cmf-pmsa-prep1.log, replace;

clear; set mem 1g; set matsize 10000;

* William Kerr ;
* Growth Paper CMF File Prep;
* Last Modified: 23 July 2009;

***********************************************************;
*** Initial CMF 1963 Dataset Prep                        **;
***********************************************************;

*** Prepare historical patterns of mfg firms by city;
!gunzip coaggl-cmf2-pmsa-sic3.dta;
use coaggl-cmf2-pmsa-sic3.dta, clear;
!gzip coaggl-cmf2-pmsa-sic3.dta;
des; sum; drop pmsa_sic3_bir* pmsa_sic3_con* pmsa_sic3_dth* pmsa_sic3_one*;

*** Restrict to 1963 average size;
keep if yr==1963; drop if pmsa==9999;
renpfix pmsa_sic3_ C63_;
for var C63_*: gen MX=X if (sic3>=330 & sic3<=339);
collapse (sum) C63* MC63*, by(pmsa) fast;
sort pmsa; save CMF63_PMSA1, replace; 
sum; count if MC63_tot_ct==0;
egen temp1=group(pmsa); sum temp1; drop temp1;

***********************************************************;
*** Merge with City Entry Files                          **;
***********************************************************;

*** Load JUE working file of cities in 1992-1999 and collapse on SIC1;
* Restricting explanatory variables to 1992-1993 values;
chdir $coaggl/jue;
use ./lbd/data/scratch-jue-lbd-pmsa-prep2, clear;
keep if (yr>=1992 & yr<=1999); 
tab sic2; gen sic1=int(sic2/10); replace sic1=2 if sic1==3; replace sic1=7 if sic1==8;
for var tot0_emp: gen zX99=X if yr==1999;
for var tot* ct* emp* hi* climate* paysh: replace X=. if (yr<1992 | yr>1993);
collapse (mean) bir* tot* ztot* ct* emp* hi* climate* paysh st, by(pmsal pmsa sic2) fast;
sum; egen temp1=group(pmsa); sum temp1; drop temp1;

*** Merge in bach share of city and industry;
sort pmsa; merge pmsa using ./climate/pmsa90, nok keep(s_ed_bach90 s_ed_hs90);
tab _m; drop _m;
sort sic2; merge sic2 using ./climate/bashare_sic2_natl_rev, nok;
tab _m; tab sic2 if _m!=3, s(_m); drop _m; sum col;
gen sic1=int(sic2/10); egen temp1=mean(col), by(sic1);
replace col=temp1 if col==.; sum col; drop temp1;

*** Merge in 2nd climate (toggle on manually);
sort pmsa; merge pmsa using ./climate/climate-price, nok keep(climateX1);
tab _m; *replace climate=climateX1; drop climateX1 _m;

*** Merge in 1963 CMF data;
chdir $coaggl/growth/cmf;
sort pmsa; merge pmsa using CMF63_PMSA1;
tab _m; tab pmsal if (pmsa==3320 | pmsa==380); 
drop if (pmsa==3320 | pmsa==380); drop if (st==2 | st==15);
tab _m; keep if _m==3; drop _m;

*** Prepare 1963 CMF sizes;
gen C63sz=C63_tot_emp/C63_tot_ct;
gen C63sz_su=C63_tot_emp_su/C63_tot_ct_su;
gen C63sz_mu=C63_tot_emp_mu/C63_tot_ct_mu;
format C63sz* %7.1f; sum C63sz*; 
gsort sic2 -C63sz; list pmsal C63sz C63_tot_emp C63_tot_ct in 1/15;
gsort sic2 -C63sz_su; list pmsal C63sz_su C63_tot_emp_su C63_tot_ct_su in 1/15;
gsort sic2 -C63sz_mu; list pmsal C63sz_mu C63_tot_emp_mu C63_tot_ct_mu in 1/15;
for var C63sz*: gen lX=ln(X);

*** Generate weights (means are not sensitive to recodes);
egen temp1=mean(tot0_emp), by(pmsa);
egen temp2=mean(tot0_emp), by(sic2);
gen wt1=ln(temp1)*ln(temp2); format wt1 %8.0f; drop temp*;
gsort wt1; list pmsal sic2 wt1 in 1/10;
gsort -wt1; list pmsal sic2 wt1 in 1/10;
egen cityind=group(pmsa sic2);

*** Prepare small firm share;
egen temp1=sum(tot1_emp_su+tot6_emp_su), by(pmsa);
egen temp2=sum(tot0_emp), by(pmsa);
gen sh20_c=temp1/temp2; drop temp*;
gen sh20_ci=(tot1_emp_su+tot6_emp_su)/tot0_emp;
for any sh20_c sh20_ci: replace X=0 if X==.;

*** Prepare average firm size;
gen tot0_size_ci=tot0_emp/tot0_ct;
egen temp1=sum(tot0_emp), by(pmsa);
egen temp2=sum(tot0_ct), by(pmsa);
gen tot0_size_c=temp1/temp2; drop temp*;
sum tot0_size*;

*** Prepare HHI over city-industries;
egen temp1=sum(tot0_emp), by(pmsa);
egen hi_agg=sum((tot0_emp/temp1)^2), by(pmsa); drop temp*;
format hi_agg %5.4f; tab pmsal, s(hi_agg);

*** Prepare entry variables;
log off; 
for var bir* tot* ztot*: replace X=1 if X<1;
for var bir* tot* ztot* ct* emp* hi* pay* s_* sh* col: gen lX=ln(X); 
log on;

*** Create uniform concentration variables;
gen temp0=0;
for any hi_ci sh20_ci tot0_size_ci: replace temp0=1 if (X==. | X==0);
sum hi_ci sh20_ci tot0_size_ci tot0_emp bir0_emp if temp0==1;
count; for any sic2 pmsal: tab X if temp0==1; 
ren temp0 lbound; sum; sum if lbound==0;
egen temp1=group(sic2); sum temp1; drop temp1;

***********************************************************;
*** Regressions - Entry and Small Firms                  **;
***********************************************************;
gen mfg=1 if (sic2>=20 & sic2<=39);
gen srv=1 if (sic2>=70 & sic2<=89);
xi i.sic2;

*drop if lbound==1;

*** Test if 1963 MFG impacts current 1992-1993 MFG;
areg ltot0_size_ci lC63sz if mfg==1 [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz_mu if mfg==1 [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz_su if mfg==1 [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz if mfg==1, a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz if mfg==1 & lbound!=0 [aw=wt1], a(sic2) cl(pmsa);

areg lbir0_emp_su lC63sz if mfg==1 [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz_mu if mfg==1 [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz_su if mfg==1 [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz if mfg==1, a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz if mfg==1 & lbound!=0 [aw=wt1], a(sic2) cl(pmsa);

*** Test if 1963 MFG impacts current 1992-1993 city average;
regress ltot0_size_c lC63sz if sic2==10 [aw=wt1];
regress ltot0_size_c lC63sz_mu if sic2==10 [aw=wt1];
regress ltot0_size_c lC63sz_su if sic2==10 [aw=wt1];
regress ltot0_size_c lC63sz_su if sic2==10;
regress ltot0_size_c lC63sz_su if sic2==10 & lbound!=0 [aw=wt1];

*** Test if 1963 MFG impacts current 1992-1993 services size;
areg ltot0_size_ci lC63sz if srv==1 [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz_mu if srv==1 [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz_su if srv==1 [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz if srv==1, a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz if srv==1 & lbound!=0 [aw=wt1], a(sic2) cl(pmsa);

areg lbir0_emp_su lC63sz if srv==1 [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz_mu if srv==1 [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz_su if srv==1 [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz if srv==1, a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz if srv==1 & lbound!=0 [aw=wt1], a(sic2) cl(pmsa);

*** Test if 1963 MFG impacts current 1992-1993 all sectors;
areg ltot0_size_ci lC63sz [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz_mu [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz_su [aw=wt1], a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz, a(sic2) cl(pmsa);
areg ltot0_size_ci lC63sz if lbound!=0, a(sic2) cl(pmsa);

areg lbir0_emp_su lC63sz [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz_mu [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz_su [aw=wt1], a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz, a(sic2) cl(pmsa);
areg lbir0_emp_su lC63sz if lbound!=0 [aw=wt1], a(sic2) cl(pmsa);

*** End of Program;
cap n log close;

***********************************************************;
***********************************************************;
*** SAVED MATERIALS                                      **;
***********************************************************;
***********************************************************;
