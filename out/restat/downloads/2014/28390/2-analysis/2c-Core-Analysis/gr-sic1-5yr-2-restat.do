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
log using gr-sic1-5yr-2.log, replace;

clear; clear matrix; set mem 3g; set matsize 10000;

* William Kerr;
* Growth Paper CMF File Prep - AEA;
* Last Modified: Dec 2010;

***********************************************************;
*** Merge with City Entry Files                          **;
***********************************************************;

*** Create transfer file of city traits;
use $coaggl/jue/lbd/data/scratch-jue-lbd-prep1, clear;
gen ct=1; collapse (sum) ct, by(pmsa pmsal r9 st);
drop ct; sort pmsa; save temp1-pmsa, replace;

*** Calculate city employments and counts for growth metrics;
use $lbd10/lbdc-bcd-2010, clear;
sum; tab yr, s(tot_emp);
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; list fips cityname if _m==2; keep if _m==3; drop _m; codebook pmsa;
collapse (sum) tot_emp tot_ct tot1_emp tot6_emp, by(pmsa yr) fast;
gen SH=(tot1_emp+tot6_emp)/tot_emp; drop tot1 tot6;
tab yr, s(tot_emp); table yr pmsa, c(sum tot_emp) f(%7.0f); renpfix tot_ A; 
*drop if yr==2002; *replace yr=2002 if yr==2001;
keep if (yr==1977 | yr==1982 | yr==1987 | yr==1992 | yr==1997 | yr==2002 | yr==2005);
replace yr=2007 if yr==2005;
reshape wide A* SH*, i(pmsa) j(yr);
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
format GR* SH* %4.3f; format A* SZ* %8.0f; sum;
sort pmsa; save temp1-pmsa-gr5-ext, replace;

*** Calculate city employments and counts for growth metrics;
use $lbd10/lbdc-bcd-s3-2010, clear;
sum; tab yr, s(tot_emp); gen sic2=int(sic3/10);
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; list fips cityname if _m==2; keep if _m==3; drop _m; codebook pmsa;
gen tot_Memp=tot_emp if (sic2>=10 & sic2<=39); gen tot_Mct=tot_ct if (sic2>=10 & sic2<=39);
gen tot_Nemp=tot_emp if (sic2>=40 & sic2<=89); gen tot_Nct=tot_ct if (sic2>=40 & sic2<=89);
sort sic3; merge sic3 using sic3-aggl, nok keep(aggl);
gen tot_A1emp=tot_emp if (aggl==1); gen tot_A1ct=tot_ct if (aggl==1);
gen tot_A2emp=tot_emp if (aggl==2); gen tot_A2ct=tot_ct if (aggl==2);
gen tot_A3emp=tot_emp if (aggl==3); gen tot_A3ct=tot_ct if (aggl==3);
gen tot_A4emp=tot_emp if (aggl==3 & sic2>=40); gen tot_A4ct=tot_ct if (aggl==3 & sic2>=40);
collapse (sum) tot_Memp tot_Nemp tot_A1emp tot_A2emp tot_A3emp tot_A4emp
               tot_Mct tot_Nct tot_A1ct tot_A2ct tot_A3ct tot_A4ct, by(pmsa yr) fast;
drop if yr==2002; replace yr=2002 if yr==2001;
keep if (yr==1982 | yr==1992 | yr==2002);
renpfix tot_ A; reshape wide A*, i(pmsa) j(yr);
for any emp: 
\ gen GRX8202M=ln(AMX2002/AMX1982) 
\ gen GRX8292M=ln(AMX1992/AMX1982) 
\ gen GRX9202M=ln(AMX2002/AMX1992) 
\ gen GRX8202N=ln(ANX2002/ANX1982) 
\ gen GRX8292N=ln(ANX1992/ANX1982) 
\ gen GRX9202N=ln(ANX2002/ANX1992)
\ gen GRX8202A1=ln(AA1X2002/AA1X1982) 
\ gen GRX8292A1=ln(AA1X1992/AA1X1982) 
\ gen GRX9202A1=ln(AA1X2002/AA1X1992)
\ gen GRX8202A2=ln(AA2X2002/AA2X1982) 
\ gen GRX8292A2=ln(AA2X1992/AA2X1982) 
\ gen GRX9202A2=ln(AA2X2002/AA2X1992)
\ gen GRX8202A3=ln(AA3X2002/AA3X1982) 
\ gen GRX8292A3=ln(AA3X1992/AA3X1982) 
\ gen GRX9202A3=ln(AA3X2002/AA3X1992)
\ gen GRX8202A4=ln(AA4X2002/AA4X1982) 
\ gen GRX8292A4=ln(AA4X1992/AA4X1982) 
\ gen GRX9202A4=ln(AA4X2002/AA4X1992);
keep pmsa GR* A*; format GR* %4.3f; format A* %8.0f; sum;
sort pmsa; save temp1-pmsa-gr5-ext2, replace;

*** Calculate city pay and wages;
* Worst pay years are 78 and 83-86;
use $lbd10/lbdc-pay-2010, clear; 
sum; tab yr, s(tot_pay_tr);
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; list fips cityname if _m==2; keep if _m==3; drop _m; codebook pmsa;
collapse (rawsum) tot_pay tot_pay_tr tot_emp_tr
         (mean) wage (median) wage_p50 [aw=tot_emp_tr]
         , by(pmsa yr) fast; 
ren tot_pay Bpay; ren tot_pay_tr Bpaytr; gen Bwage2=Bpaytr/tot_emp_tr; drop tot_emp_tr; 
ren wage Bwage; ren wage_p50 Bwage_p50;
keep if (yr==1977 | yr==1982 | yr==1987 | yr==1992 | yr==1997 | yr==2002 | yr==2005);
replace yr=2007 if yr==2005;
reshape wide B*, i(pmsa) j(yr);
for any pay paytr wage wage2 wage_p50: 
\ gen GRX1982T=ln(BX1982/BX1977) 
\ gen GRX1987T=ln(BX1987/BX1982) 
\ gen GRX1992T=ln(BX1992/BX1987) 
\ gen GRX1997T=ln(BX1997/BX1992) 
\ gen GRX2002T=ln(BX2002/BX1997) 
\ gen GRX2007T=ln(BX2007/BX2002)
\ gen GRX7702T=ln(BX2002/BX1977) 
\ gen GRX8202T=ln(BX2002/BX1982) 
\ gen GRX8292T=ln(BX1992/BX1982) 
\ gen GRX9202T=ln(BX2002/BX1992);  
format GR* %4.3f; format B* %8.0f; sum;
sort pmsa; save temp1-pmsa-pay5-ext, replace;

*** Calculate birth rates for growth metrics;
use $lbd10/lbdc-bcd-2010, clear; sum yr;
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
keep if _m==3; drop _m;
sort pmsa; merge pmsa using temp1-pmsa; erase temp1-pmsa.dta; tab _m; drop if _m==2; drop _m;
replace bir_emp=bir_emp_su; replace bir_ct=bir_ct_su;
keep if (yr>=1977 & yr!=.); gen yr2=.;
for num 1982 1987 1992 1997 2002 2007: replace yr2=X if (yr>=X-5 & yr<=X-4); 
keep if (yr2==1982 | yr2==1987 | yr2==1992 | yr2==1997 | yr2==2002 | yr2==2007); 
table yr yr2; drop yr; ren yr2 yr;
collapse (sum) tot_emp tot_ct bir_emp bir_ct
         (mean) r9 st, by(pmsal pmsa yr) fast;
for any emp ct: gen lBSHXT=ln(bir_X/tot_X) \ gen lBX=ln(bir_X); 
keep pmsal pmsa yr r9 st lB*;
reshape wide lB*, i(pmsa) j(yr);
gen lBSHempT7702=lBSHempT1982;
gen lBSHempT8202=lBSHempT1987;
gen lBSHempT8292=lBSHempT1987;
gen lBSHempT9202=lBSHempT1997;
gen lBSHctT8202=lBSHctT1987;
format lBS* %4.3f; sum;

*** Merge together;
sort pmsa; merge pmsa using temp1-pmsa-gr5-ext;
tab _m; drop _m; erase temp1-pmsa-gr5-ext.dta;
sort pmsa; merge pmsa using temp1-pmsa-gr5-ext2;
tab _m; drop _m; erase temp1-pmsa-gr5-ext2.dta;
sort pmsa; merge pmsa using temp1-pmsa-pay5-ext;
tab _m; drop _m; erase temp1-pmsa-pay5-ext.dta;

*** Merge mine data - external;
ren pmsa msa; sort msa; merge msa using minesdata_june10-29; drop central;
for num 1/3: list msa pmsal msaname if _m==X; 
drop if _m==2; drop _m msaname; ren msa pmsa;
renpfix mines_copper_ MC;  renpfix mines_zinc_ MZ;
renpfix mines_gold_ MG;    renpfix mines_silver_ MS;
renpfix mines_lead_ ML;    renpfix mines_iron_ MI;
drop *_past *_cur *_75 *_75ml *_ml;
for num 50 100 250 500:
\ gen MTXb=mines_total_X
\ gen MTX_00b=mines_total_X_00
\ gen MTX_00mlb=mines_total_X_00ml
\ gen MTX=MCX+MZX+MGX+MSX+MLX+MIX
\ drop MCX MZX MGX MSX MLX
\ gen MTX_00=MCX_00+MZX_00+MGX_00+MSX_00+MLX_00+MIX_00
\ drop MCX_00 MZX_00 MGX_00 MSX_00 MLX_00
\ gen MTX_00ml=MCX_00ml+MZX_00ml+MGX_00ml+MSX_00ml+MLX_00ml+MIX_00ml
\ drop MCX_00ml MZX_00ml MGX_00ml MSX_00ml MLX_00ml;
for any 50_00 100_00 250_00 500_00: gen MOX=MTXb-MIX;
drop mines_total*; sum;

*** Adjust mine data to ring structure;
gen MT500_00d=MT500_00b-MT250_00b;
gen MT250_00d=MT250_00b-MT100_00b;
gen MT100_00d=MT100_00b-MT50_00b;
gen MT500_00c1=MT500_00b-MT50_00b;
gen MT500_00c2=MT500_00b-MT100_00b;
for any MI MO:
\ gen X500_00d=X500_00-X250_00
\ gen X250_00d=X250_00-X100_00
\ gen X100_00d=X100_00-X50_00
\ gen X500_00c1=X500_00-X50_00
\ gen X500_00c2=X500_00-X100_00;

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
for var T* MT500* MI500* MO500*: sum X \ count if X==0 \ gen lX=ln(X);

*** List data (pre-cuts below);
for var MT500 MT500_00 MT100 MT100_00 MI500 MI500_00 MI100 MI100_00:
\ gsort -X \ list pmsal pmsa X in 1/50;
gen MLsh500=MT500_00ml/MT500_00;
gen MIsh500=MI500_00/MT500_00;
for var MLsh MIsh: replace X=0 if X==. \ sum X, d;

*** Merge in 1963 and 1967 CMF data;
chdir $coaggl/growth/cmf;
sort pmsa; merge pmsa using CMF63_PMSA1;
tab _m; drop if (pmsa==3320 | pmsa==380); 
cap n drop if (st==2 | st==15);
tab _m; keep if _m==3; drop _m;
sort pmsa; merge pmsa using CMF63_PMSA1-67;
tab _m; keep if _m==3; drop _m; ren rt67 C67rt;

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
tab pmsal if baPct1970==.; drop if baPct1970==.; drop if JanTemp==.;

*** Prepare 1963 CMF sizes and 67 rates;
gen C63sz=C63_tot_emp/C63_tot_ct;
gen C63sz_su=C63_tot_emp_su/C63_tot_ct_su;
gen C63sz_mu=C63_tot_emp_mu/C63_tot_ct_mu;
format C63sz* %7.1f; sum C63sz*; 
for var SZ* C63_tot_emp* C63sz* C67rt: gen lX=ln(X);

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
gen ALMsize8202=(AMemp1982/AMct1982); 
gen ALNsize8202=(ANemp1982/ANct1982); 
for var A* SH*: gen lX=ln(X);

*** Generate region identifiers;
gen r4=1 if r9==1 | r9==2;
replace r4=2 if r9==3 | r9==4;
replace r4=3 if r9==5 | r9==6 | r9==7;
replace r4=4 if r9==8 | r9==9;
gen sw=(r4==3 | r4==4); tab sw;
gen ec=(r9==1 | r9==2 | r9==3 | r9==5 | r9==6); tab ec;
gen warm=(JanTemp>=34 & JanTemp!=.); tab warm;
pwcorr sw ec warm;

*** Generate weights of log city size;
gen wt1=ln(Aemp1977); format wt1 %8.0f;

*** Incorporate returns;
sort pmsa; merge pmsa using pmsa-returns97;
tab _m; drop _m; for var return*: gen lX=ln(X);

*** Save working file;
xi i.r9;
save gr-sic1-5yr-2, replace;

*** End of Program;
cap n log close;

***********************************************************;
***********************************************************;
*** SAVED MATERIALS                                      **;
***********************************************************;
***********************************************************;
