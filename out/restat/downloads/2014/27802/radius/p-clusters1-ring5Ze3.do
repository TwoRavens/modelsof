* William Kerr, TGG; 
* Cite Bilateral Prep;
* Last Updated Nov 2012;

#delimit;
cap n log close; log using p-clusters1-ring5Ze3.log, replace;
clear all; set matsize 1000; set more off;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;
* do /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1/p-clusters1-ring5Ze3.do;

************************;
** Bilateral Full     **;
************************;

*** Prepare grid components;
use zip using ./svdata/citations_zip5_pat2, clear; duplicates drop; sort zip; save temp1-zip, replace;
use zip1 zip2 dist if dist<=150 using ./svdata/SASZip-grid.dta; count; count if zip1==zip2;
ren zip1 zip; sort zip; merge zip using temp1-zip; tab _m; keep if _m==3; drop _m; ren zip zip1;
ren zip2 zip; sort zip; merge zip using temp1-zip; tab _m; keep if _m==3; drop _m; ren zip zip2;
erase temp1-zip.dta; compress; save temp1-grid-us, replace; sum; count if zip1==zip2;

*** Cross cities BY SCAT to form baseline grid of activity within 150 miles;
use scat using ./svdata/citations_zip5_pat2, clear; duplicates drop; sort scat; levelsof scat, local(scatI);
foreach Q4 of local scatI {;
use temp1-grid-us, clear; gen scat=`Q4';
ren zip1 zip; sort scat zip; merge scat zip using ./svdata/citations_zip5_pat2, nok keep(ct);
keep if _m==3; drop _m; ren ct Spat; ren zip Szip; ren scat Sscat;
ren zip2 zip; gen scat=Sscat; sort scat zip; merge scat zip using ./svdata/citations_zip5_pat2, nok keep(ct);
keep if _m==3; drop _m; ren ct Dpat; ren zip Dzip; ren scat Dscat;
keep if (Spat>0 & Dpat>0); drop if (Spat==. | Dpat==.); save temp1-gridus-`Q4', replace; sum;
};
use scat using ./svdata/citations_zip5_pat2, clear; duplicates drop; drop if scat==11; sort scat; levelsof scat, local(scatJ);
use temp1-gridus-11, clear; erase temp1-gridus-11.dta;
foreach Q5 of local scatJ {;
append using temp1-gridus-`Q5';
erase temp1-gridus-`Q5'.dta;
};
replace dist=1 if dist<1; drop if dist>150;
compress; erase temp1-grid-us.dta;

*********************************;
*** Add Extras and Save         *;
*********************************;

*** Merge in observed citations by generations;
sort Szip Sscat Dzip; merge Szip Sscat Dzip using ./svdata/citations_zip5_Ddist2, nok keep(ct_scat); 
tab _m; drop _m; for var ct_scat: ren X X1; ren Dzip Ezip; 
sort Szip Sscat Ezip; merge Szip Sscat Ezip using ./svdata/citations_zip5_Edist2, nok keep(ct_scat); 
tab _m; drop _m; for var ct_scat: ren X X2; ren Ezip Fzip; 
sort Szip Sscat Fzip; merge Szip Sscat Fzip using ./svdata/citations_zip5_Fdist2, nok keep(ct_scat); 
tab _m; drop _m; for var ct_scat: ren X X3; ren Fzip Gzip; 
sort Szip Sscat Gzip; merge Szip Sscat Gzip using ./svdata/citations_zip5_Gdist2, nok keep(ct_scat); 
tab _m; drop _m; for var ct_scat: ren X X4; ren Gzip Hzip; 
sort Szip Sscat Hzip; merge Szip Sscat Hzip using ./svdata/citations_zip5_Hdist2, nok keep(ct_scat); 
tab _m; drop _m; for var ct_scat: ren X X5; ren Hzip Izip;
sort Szip Sscat Izip; merge Szip Sscat Izip using ./svdata/citations_zip5_Idist2, nok keep(ct_scat); 
tab _m; drop _m; for var ct_scat: ren X X6; ren Izip Rzip; 
for var ct*: replace X=0 if X==.; compress;

*** Save temp file;
save ./svdata/citations_cluster1_ring5Z3, replace;

cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;

*** End of program;
log close;