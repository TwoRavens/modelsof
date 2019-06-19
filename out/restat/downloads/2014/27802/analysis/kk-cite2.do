* William Kerr, TGG; 
* Cite Ring Analysis;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/kk-final;
cap n log close; log using kk-cite2.log, replace;
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
compress; save kk-cite2, replace;

************************;
** Ring Test - Excl Own ;
************************;

*** Generate distance rings;
gen int dist2=150; 
replace dist2=1 if (dist<=1);
replace dist2=3 if (dist>1 & dist<=3);
replace dist2=5 if (dist>3 & dist<=5);
for any 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100: replace dist2=X if (dist>X-5 & dist<=X);

*** Collapse data on distance bands by zip code;
replace dist2=0 if Szip==Dzip;
collapse (sum) ct_* Dpat (mean) Spat dist, by(Szip dist2) fast; sum; 
for any 01 03 05 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100: gen byte zDX=(dist2==X);
gen byte EzD00=(dist2==0); replace zD01=0 if (dist2==0);

*** Generate aggregate groups;
gen ct_nof23=ct_nof2+ct_nof3;

*** Prepare variables;
for num 0 1 23: gen lct_nofX=ln(1+ct_nofX); 
gen SDpat=Spat*Dpat; gen wt=int(SDpat); for var SDpat: gen lX=ln(X); 
compress;

*** Count regressions with zip FE;
for num 1 23: 
\ areg lct_nofX zD* lSDpat lct_nof0 [aw=wt] if dist2!=0, a(Szip) cl(dist2)
\ areg lct_nofX zD* lSDpat lct_nof0 [aw=wt] if dist2!=0 & ct_nofX!=0, a(Szip) cl(dist2)
\ areg lct_nofX zD* lSDpat [aw=wt] if dist2!=0, a(Szip) cl(dist2)
\ areg lct_nofX EzD* zD* lSDpat lct_nof0 [aw=wt], a(Szip) cl(dist2);
replace zD01=1 if dist2==0;
for num 1 23: 
\ areg lct_nofX zD* lSDpat lct_nof0 [aw=wt], a(Szip) cl(dist2);

*** End of program;
log close;