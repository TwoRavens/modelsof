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
log using gr-sic2-5yr-1.log, replace;

clear; clear matrix; set mem 4g; set matsize 10000;

* William Kerr;
* Mining-Growth Paper - SIC2 frameworks;
* Last Modified: 30 July 2010;

***********************************************************;
*** Merge with City Entry Files                          **;
***********************************************************;

*** Create transfer file of city traits;
use $coaggl/jue/lbd/data/scratch-jue-lbd-prep1, clear;
gen ct=1; collapse (sum) ct, by(pmsa pmsal r9 st);
drop ct; sort pmsa; save temp1-pmsa-s2, replace;

*** Calculate city employments and counts for growth metrics;
use $lbd10/lbdc-bcd-s3-2010, clear; 
tab yr, s(tot_emp); 
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; list fips cityname if _m==2; keep if _m==3; drop _m; codebook pmsa;
cap n drop sic2; gen sic2=int(sic3/10);
drop if (sic2<10 | sic2==40 | sic2==66 | sic2>=90);
egen temp1=count(tot_emp), by(sic2 yr); egen temp2=min(temp1), by(sic2); 
table yr sic2 if temp2<50, c(sum tot_ct); drop if temp2<50; drop temp*;
table yr sic2, c(sum tot_emp) f(%8.0f); table yr sic2, c(sum tot_ct) f(%8.0f); 
keep if (yr==1977 | yr==1982 | yr==1987 | yr==1992 | yr==1997 | yr==2002 | yr==2005);
replace yr=2007 if yr==2005;
collapse (sum) tot_emp tot_ct, by(pmsa sic2 yr) fast;
renpfix tot_ A; 
reshape wide A*, i(pmsa sic2) j(yr);
gen SZ1977T=Aemp1977/Act1977;
for any emp ct: 
\ gen GRX1982T=ln(AX1982/AX1977) 
\ gen GRX1987T=ln(AX1987/AX1982) 
\ gen GRX1992T=ln(AX1992/AX1987) 
\ gen GRX1997T=ln(AX1997/AX1992) 
\ gen GRX2002T=ln(AX2002/AX1997) 
\ gen GRX2007T=ln(AX2007/AX2002)
\ gen GRX7702T=ln(AX2002/AX1977) 
\ gen GRX8202T=ln(AX2002/AX1982) 
\ gen GRX8292T=ln(AX1992/AX1982) 
\ gen GRX9202T=ln(AX2002/AX1992); 
for any emp: 
\ gen GRX8202T2=(AX2002-AX1982)*2/(AX2002+AX1982) 
\ gen GRX8292T2=(AX1992-AX1982)*2/(AX1992+AX1982) 
\ gen GRX9202T2=(AX2002-AX1992)*2/(AX2002+AX1992); 
format GR* %4.3f; format A* SZ* %8.0f; sum;
sort pmsa; save temp1-pmsa-s3-gr5-ext, replace;

*** Calculate birth rates for growth metrics;
use $lbd10/lbdc-bcd-s3-2010, clear; sum yr;
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
keep if _m==3; drop _m;
sort pmsa; merge pmsa using temp1-pmsa-s2; erase temp1-pmsa-s2.dta; tab _m; drop if _m==2; drop _m;
replace bir_emp=bir_emp_su; replace bir_ct=bir_ct_su;
keep if (yr>=1977 & yr!=.); gen yr2=.;
for num 1982 1987 1992 1997 2002 2007: replace yr2=X if (yr>=X-5 & yr<=X-4); 
keep if (yr2==1982 | yr2==1987 | yr2==1992 | yr2==1997 | yr2==2002 | yr2==2007); 
table yr yr2; drop yr; ren yr2 yr;
cap n drop sic2; gen sic2=int(sic3/10);
egen temp1=count(tot_emp), by(sic2 yr); egen temp2=min(temp1), by(sic2); 
table yr sic2 if temp2<50, c(sum tot_ct); drop if temp2<50; drop temp*;
table yr sic2, c(sum tot_emp) f(%8.0f); table yr sic2, c(sum tot_ct) f(%8.0f); 
drop if (sic2<10 | sic2==40 | sic2==66 | sic2>=90);
keep if (yr==1982 | yr==1987 | yr==1992 | yr==1997 | yr==2002 | yr==2007);
collapse (sum) tot_emp tot_ct bir_emp bir_ct
         (mean) r9 st, by(pmsal pmsa sic2 yr) fast;
for any emp ct: gen lBSHXT=ln(bir_X/tot_X) \ gen lBX=ln(bir_X); 
for any emp ct:
\ egen temp1=sum(bir_X), by(pmsa yr)
\ egen temp2=sum(tot_X), by(pmsa yr)
\ gen lBSHCXT=ln(temp1/temp2) \ drop temp*;
keep pmsal pmsa sic2 yr r9 st lB*;
reshape wide lB*, i(pmsa sic2) j(yr);
gen lBSHempT7702=lBSHempT1982;
gen lBSHempT8202=lBSHempT1987;
gen lBSHempT8292=lBSHempT1987;
gen lBSHempT9202=lBSHempT1997;
gen lBSHCempT8202=lBSHCempT1987;
gen lBSHCempT8292=lBSHCempT1987;
gen lBSHCempT9202=lBSHCempT1997;
format lBS* %4.3f; sum;

*** Merge together;
sort pmsa; merge pmsa using temp1-pmsa-s3-gr5-ext;
tab _m; drop _m; erase temp1-pmsa-s3-gr5-ext.dta;

*** Merge mine data - external;
ren pmsa msa; sort msa; merge msa using msamines_june10; drop central;
*for num 1/3: list msa pmsal msaname if _m==X; 
drop if _m==2; drop _m msaname; ren msa pmsa;
renpfix mines_copper_ MC;  renpfix mines_zinc_ MZ;
renpfix mines_gold_ MG;    renpfix mines_silver_ MS;
renpfix mines_lead_ ML;    renpfix mines_iron_ MI;
drop *_past *_cur *_75 *_75ml *_ml;
for num 50 100 250 500:
\ gen MTX=MCX+MZX+MGX+MSX+MLX+MIX
\ drop MCX MZX MGX MSX MLX
\ gen MTX_00=MCX_00+MZX_00+MGX_00+MSX_00+MLX_00+MIX_00
\ drop MCX_00 MZX_00 MGX_00 MSX_00 MLX_00
\ gen MTX_00ml=MCX_00ml+MZX_00ml+MGX_00ml+MSX_00ml+MLX_00ml+MIX_00ml
\ drop MCX_00ml MZX_00ml MGX_00ml MSX_00ml MLX_00ml;
for any 500 500_00 500_00ml: gen MOX=MTX-MIX; sum;

*** Merge mine data - internal;
sort pmsa; merge pmsa using lbd_mining3, keep(T*);
tab _m; drop if _m==2; drop _m;

*** Prepare mine data;
for var MT500_00:
\ sum X, d \ count if X==0
\ egen temp20=pctile(X), p(20)
\ egen temp40=pctile(X), p(40)
\ egen temp60=pctile(X), p(60)
\ egen temp80=pctile(X), p(80)
\ gen QX=1
\ replace QX=2 if X>temp20 & X<=temp40
\ replace QX=3 if X>temp40 & X<=temp60
\ replace QX=4 if X>temp60 & X<=temp80
\ replace QX=5 if X>temp80 & X!=.
\ drop temp*;
for var T* MT* MI* MO*: sum X \ count if X==0 \ gen lX=ln(1+X);

*** Merge in 1963 CMF data;
chdir $coaggl/growth/cmf;
sort pmsa; merge pmsa using CMF63_PMSA1;
tab _m; drop if (pmsa==3320 | pmsa==380); 
cap n drop if (st==2 | st==15);
tab _m; keep if _m==3; drop _m;

*** Merge in covariates;
sort pmsa; merge pmsa using pmsa-covariates, 
   nok keep(climate climateX1 index1995 indexgr unaval);
tab _m; drop if _m==2; drop _m;
for var index1995 indexgr unaval: gen lX=ln(X);

*** Merge in covariates 2;
sort pmsa; merge pmsa using geo_controls_msas, 
   keep(JulTemp JanTemp baPct1970 housing1970 dens1970 pop1970 WTR_*);
tab _m; drop if _m==2; drop _m;
for var JulTemp JanTemp baPct1970 housing1970 dens1970 pop1970 WTR_*: gen lX=ln(X);
tab pmsal if baPct1970==.; drop if baPct1970==.;

*** Prepare 1963 CMF sizes;
gen C63sz=C63_tot_emp/C63_tot_ct;
gen C63sz_su=C63_tot_emp_su/C63_tot_ct_su;
gen C63sz_mu=C63_tot_emp_mu/C63_tot_ct_mu;
format C63sz* %7.1f; sum C63sz*; 
for var SZ* C63_tot_emp* C63sz*: gen lX=ln(X);

*** Prepare lagged employment and size;
gen ALemp1982=Aemp1977; gen ALemp1987=Aemp1982; gen ALemp1992=Aemp1987; 
gen ALemp1997=Aemp1992; gen ALemp2002=Aemp1997; gen ALemp2007=Aemp2002;
gen ALemp7702=Aemp1977; gen ALemp8202=Aemp1982; 
gen ALemp8292=Aemp1982; gen ALemp9202=Aemp1992;
gen ALsize1982=(Aemp1977/Act1977); gen ALsize1987=(Aemp1982/Act1982);
gen ALsize1992=(Aemp1987/Act1987); gen ALsize1997=(Aemp1992/Act1992);
gen ALsize2002=(Aemp1997/Act1997); gen ALsize2007=(Aemp2002/Act2002);
gen ALsize7702=(Aemp1977/Act1977); gen ALsize8202=(Aemp1982/Act1982);
gen ALsize8292=(Aemp1982/Act1982); gen ALsize9202=(Aemp1992/Act1992);
egen temp1=sum(Aemp1982), by(pmsa); egen temp2=sum(Act1982), by(pmsa); 
gen ALCsize8202=temp1/temp2; drop temp*; gen ALCsize8292=ALCsize8202;
egen temp1=sum(Aemp1992), by(pmsa); egen temp2=sum(Act1992), by(pmsa); 
gen ALCsize9202=temp1/temp2; drop temp*;
for var A*: gen lX=ln(X);

*** Generate region 4;
gen r4=1 if r9==1 | r9==2;
replace r4=2 if r9==3 | r9==4 | r9==5;
replace r4=3 if r9==6 | r9==7;
replace r4=4 if r9==8 | r9==9;
gen sw=(r4==2 | r4==4); tab sw;

*** Generate weights (means are not sensitive to recodes);
egen temp1=mean(Aemp1977), by(pmsa);
egen temp2=mean(Aemp1977), by(sic2);
gen wt1=ln(temp1)*ln(temp2); format wt1 %8.0f; drop temp*;
gsort wt1; list pmsal sic2 wt1 in 1/10;
gsort -wt1; list pmsal sic2 wt1 in 1/10;
gen mfg=1 if (sic2>=20 & sic2<=39);
gen srv=1 if (sic2>=70 & sic2<=89);
egen r9s2=group(r9 sic2);

*** Save working file;
xi i.r9s2 i.pmsa; compress;
save gr-sic2-5yr-1, replace; 

***********************************************************;
*** Regressions - Entry and Small Firms                  **;
***********************************************************;

use gr-sic2-5yr-1, clear;

*** Prepare final sample;
drop if (sic2>=10 & sic2<=14); drop if (sic2==32 | sic2==33); drop if sic2>=88;
drop if lBSHempT8202==. | lALsize8202==. | GRemp8202T==.;
egen temp1=rmin(Aemp1977 Aemp1982 Aemp1987 Aemp1992 Aemp1997 Aemp2002);
sum temp1, d; drop if (temp1==. | temp1<100); drop temp1;

*** Apply 2% Trim;
log off;
for var GRemp* GRct* lSZ* lC63* lAL* lB* lM* lT*
        lbaPct1970 lhou lden lpop lJul lJan:
\ egen temp1=pctile(X), p(98) \ replace X=temp1 if X>temp1 & X!=. \ drop temp1
\ egen temp1=pctile(X), p(02) \ replace X=temp1 if X<temp1 & X!=. \ drop temp1;
for var lALemp* lMT500_00: gen XSQ=X^2;
log on; 
for var ldevt ldevm lcort lcorm lmob: gen lMT500_00_X=lMT500_00*X;

gen warm=(JanTemp>=34); gen cl=r9;

areg GRemp8202T lALsize8202 
     lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9s2) cl(cl);
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ _Ip*, a(r9s2) cl(cl);
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ _Ip* if sic2<40, a(r9s2) cl(cl);
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ _Ip* if sic2>=40, a(r9s2) cl(cl);
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ _Ip* if warm==0, a(r9s2) cl(cl);
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ _Ip* if warm==1, a(r9s2) cl(cl);
areg GRemp8292T lALsize8202 lALemp8202 lALemp8202SQ _Ip*, a(r9s2) cl(cl);
areg GRemp9202T lALsize9202 lALemp9202 lALemp9202SQ _Ip*, a(r9s2) cl(cl);

areg GRemp8202T lBSHempT8202
     lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9s2) cl(cl);
areg GRemp8202T lBSHempT8202 lALemp8202 lALemp8202SQ _Ip*, a(r9s2) cl(cl);
areg GRemp8202T lBSHempT8202 lALemp8202 lALemp8202SQ _Ip* if sic2<40, a(r9s2) cl(cl);
areg GRemp8202T lBSHempT8202 lALemp8202 lALemp8202SQ _Ip* if sic2>=40, a(r9s2) cl(cl);
areg GRemp8202T lBSHempT8202 lALemp8202 lALemp8202SQ _Ip* if warm==0, a(r9s2) cl(cl);
areg GRemp8202T lBSHempT8202 lALemp8202 lALemp8202SQ _Ip* if warm==1, a(r9s2) cl(cl);
areg GRemp8292T lBSHempT8202 lALemp8202 lALemp8202SQ _Ip*, a(r9s2) cl(cl);
areg GRemp9202T lBSHempT9202 lALemp9202 lALemp9202SQ _Ip*, a(r9s2) cl(cl);

*** End of Program;
cap n log close;

***********************************************************;
***********************************************************;
*** SAVED MATERIALS                                      **;
***********************************************************;
***********************************************************;
