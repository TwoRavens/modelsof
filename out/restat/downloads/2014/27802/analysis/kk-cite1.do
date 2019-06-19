* William Kerr, TGG; 
* Cite Bilateral Analysis;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/kk-final;
cap n log close; log using kk-cite1.log, replace;
clear all; set matsize 1000; set more off;

************************;
** Bilateral Full     **;
************************;

cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;

*** Prepare patent full;
use ./svdata/citations_zip5_pat2, clear; des; ren ct pat;
collapse (sum) pat, by(zip) fast; sort zip; save temp1-at, replace;

*** Prepare grid components;
use zip using ./svdata/citations_zip5_pat2, clear; duplicates drop; sort zip; save temp1-zip, replace;
use zip1 zip2 dist if dist<=150 using ./svdata/SASZip-grid.dta; count; count if zip1==zip2;
ren zip1 zip; sort zip; merge zip using temp1-zip; tab _m; keep if _m==3; drop _m; ren zip zip1;
ren zip2 zip; sort zip; merge zip using temp1-zip; tab _m; keep if _m==3; drop _m; ren zip zip2;
erase temp1-zip.dta; compress; sum; count if zip1==zip2; replace dist=1 if dist<1; drop if dist>150;

*** Merge in patent counts;
ren zip1 zip; sort zip; merge zip using temp1-at; tab _m; keep if _m==3; drop _m; ren pat Spat; ren zip Szip;
ren zip2 zip; sort zip; merge zip using temp1-at; erase temp1-at.dta; tab _m; keep if _m==3; drop _m; ren pat Dpat; ren zip Dzip;

*********************************;
*** Build More General File     *;
*********************************;

*** Merge in observed citations by generations - keep non-SCAT citates;
for any D E F G H I R: !gunzip /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Xdist1.dta;
!gunzip /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip1_Rdist1.dta;
sort Szip Dzip; merge Szip Dzip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Ddist1, nok keep(ct_nof); 
tab _m; drop _m; for var ct_nof: ren X X1; ren Dzip Ezip; 
sort Szip Ezip; merge Szip Ezip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Edist1, nok keep(ct_nof); 
tab _m; drop _m; for var ct_nof: ren X X2; ren Ezip Fzip; 
sort Szip Fzip; merge Szip Fzip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Fdist1, nok keep(ct_nof); 
tab _m; drop _m; for var ct_nof: ren X X3; ren Fzip Gzip; 
sort Szip Gzip; merge Szip Gzip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Gdist1, nok keep(ct_nof); 
tab _m; drop _m; for var ct_nof: ren X X4; ren Gzip Hzip; 
sort Szip Hzip; merge Szip Hzip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Hdist1, nok keep(ct_nof); 
tab _m; drop _m; for var ct_nof: ren X X5; ren Hzip Izip;
sort Szip Izip; merge Szip Izip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip5_Idist1, nok keep(ct_nof); 
tab _m; drop _m; for var ct_nof: ren X X6; ren Izip Rzip; 
sort Szip Rzip; merge Szip Rzip using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip1_Rdist1, nok keep(ct_tot); 
tab _m; drop _m; ren ct_tot ct_nof0; ren Rzip Dzip;
for var ct*: replace X=0 if X==.; compress;

cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/kk-final;
compress; save kk-cite1, replace;

************************;
** Figure 3a Bilateral  ;
************************;

*** Combine zip code data;
egen zip1=rmin(Szip Dzip); gen pat1=Spat if zip1==Szip; replace pat1=Dpat if zip1==Dzip;
egen zip2=rmax(Szip Dzip); gen pat2=Spat if zip2==Szip; replace pat2=Dpat if zip2==Dzip;
collapse (sum) ct_* pat* (mean) dist, by(zip1 zip2) fast;
ren zip1 Szip; ren zip2 Dzip; 
ren pat1 Spat; ren pat2 Dpat;  

*** Generate distance rings;
gen int dist2=150; 
replace dist2=1 if (dist<=1);
replace dist2=3 if (dist>1 & dist<=3);
replace dist2=5 if (dist>3 & dist<=5);
for any 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100: replace dist2=X if (dist>X-5 & dist<=X);
for any 01 03 05 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100: gen byte zDX=(dist2==X);
compress; 

*** Generate aggregate groups;
gen ct_nof23=ct_nof2+ct_nof3;
gen ct_nof46=ct_nof4+ct_nof5+ct_nof6;

*** Prepare variables;
for num 0 1 23: gen lct_nofX=ln(1+ct_nofX); 
for num 1 23: egen Slct_nofX=mean(lct_nofX), by(Szip);
for num 1 23: egen Dlct_nofX=mean(lct_nofX), by(Dzip);
gen SDpat=Spat*Dpat; gen wt=int(SDpat); for var SDpat: gen lX=ln(X); 
compress;

*************;
** Core    **;
*************;

*** App Table 1;
for num 0 1 23: gen zct_nofX=int(ct_nofX) \ tab dist2 [fw=zct_nofX] \ drop zct_nofX;

*** App Table 2a;
gen const=1;
for num 1 23: areg lct_nofX zD* lSDpat lct_nof0 [aw=wt] if Szip!=Dzip, a(const) cl(dist2);
for num 1 23: areg lct_nofX zD* lSDpat lct_nof0 [aw=wt] if ct_nofX!=0 & Szip!=Dzip, a(const) cl(dist2);
for num 1 23: areg lct_nofX zD* lSDpat [aw=wt] if Szip!=Dzip, a(const) cl(dist2);
for num 1 23: areg lct_nofX zD* lSDpat lct_nof0 [aw=wt], a(const) cl(dist2);

*** End of program;
log close;