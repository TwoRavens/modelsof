* William Kerr, TGG; 
* Secondary Cite Prep File for Agglomeration Work;
* Last Updated Oct 2012;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;
cap n log close; log using p-clusters1-scite5a.log, replace;
clear all; set matsize 1000; set more off;

******************;
** Merger File  **;
******************;

*** Generate short second file of second citations that excludes own citations; 
use Sciting Dcited Dzip Dayear Dscat Duspc dist firm
    if dist<=250 & firm==0
    using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip1_raw, clear; drop dist firm;
ren Sciting patent; ren Dcited citation; sort patent citation; 
merge patent citation using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_2009_selfcite.dta, nok keep(invcite);
tab _m; drop _m; drop if invcite==1; drop invcite;
ren patent Sciting; ren citation Dcited;
renpfix D E; ren Sciting Zcited;
compress; sort Zcited; save ./svdata/citation_temp_cites1, replace;

******************;
** Second (E)   **;
******************;

*** Expand basic citations file;
use Sciting Szip Sayear Sscat Suspc Dcited dist firm
    if dist<=150 & firm==0
    using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_zip1_raw, clear; drop dist firm;
ren Sciting patent; ren Dcited citation; sort patent citation; 
merge patent citation using /export/projects/wkerr_h1b_project/kerr/mainwork-2009/svdata/citations_2009_selfcite.dta, nok keep(invcite);
tab _m; drop _m; drop if invcite==1; drop invcite;
ren patent Sciting; ren citation Dcited;
ren Dcited Zcited; sort Zcited; count; 
merge m:m Zcited using ./svdata/citation_temp_cites1;
tab _m; keep if _m==3; drop _m Zcited;  

*** Merge in zip code coordinates and calculate distances;
ren Szip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat1; ren lon lon1; ren zip Szip;
ren Ezip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat2; ren lon lon2; ren zip Ezip;
gen Edist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
sum Edist; keep if Edist<=150; drop lat* lon*;

*** Save expanded citation file;
compress; aorder; order S*; sort Sciting; sum; 
save ./svdata/citations_zip5_rawE, replace;

******************;
** Third (F)    **;
******************;

*** Expand basic citations file;
ren Ecited Zcited; drop E*; sort Zcited; count; 
merge m:m Zcited using ./svdata/citation_temp_cites1;
tab _m; keep if _m==3; drop _m Zcited;  

*** Merge in zip code coordinates and calculate distances;
ren Szip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat1; ren lon lon1; ren zip Szip;
ren Ezip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat2; ren lon lon2; ren zip Ezip;
gen Edist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
sum Edist; keep if Edist<=150; drop lat* lon*;

*** Save expanded citation file;
compress; renpfix E F; aorder; order S*; sum; sort Sciting;
save ./svdata/citations_zip5_rawF, replace;

******************;
** Fourth (G)   **;
******************;

*** Expand basic citations file;
ren Fcited Zcited; drop F*; sort Zcited; count; 
merge m:m Zcited using ./svdata/citation_temp_cites1;
tab _m; keep if _m==3; drop _m Zcited;  

*** Merge in zip code coordinates and calculate distances;
ren Szip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat1; ren lon lon1; ren zip Szip;
ren Ezip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat2; ren lon lon2; ren zip Ezip;
gen Edist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
sum Edist; keep if Edist<=150; drop lat* lon*;

*** Save expanded citation file;
compress; renpfix E G; aorder; order S*; sum; sort Sciting;
save ./svdata/citations_zip5_rawG, replace;

******************;
** Fifth (H)    **;
******************;

*** Expand basic citations file;
ren Gcited Zcited; drop G*; sort Zcited; count; 
merge m:m Zcited using ./svdata/citation_temp_cites1;
tab _m; keep if _m==3; drop _m Zcited;  

*** Merge in zip code coordinates and calculate distances;
ren Szip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat1; ren lon lon1; ren zip Szip;
ren Ezip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat2; ren lon lon2; ren zip Ezip;
gen Edist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
sum Edist; keep if Edist<=150; drop lat* lon*;

*** Save expanded citation file;
compress; renpfix E H; aorder; order S*; sum; sort Sciting;
save ./svdata/citations_zip5_rawH, replace;

******************;
** Sixth (I)    **;
******************;

*** Expand basic citations file;
ren Hcited Zcited; drop H*; sort Zcited; count; 
merge m:m Zcited using ./svdata/citation_temp_cites1;
tab _m; keep if _m==3; drop _m Zcited;  

*** Merge in zip code coordinates and calculate distances;
ren Szip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat1; ren lon lon1; ren zip Szip;
ren Ezip zip; sort zip; merge zip using ./svdata/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat2; ren lon lon2; ren zip Ezip;
gen Edist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
sum Edist; keep if Edist<=150; drop lat* lon*;

*** Save expanded citation file;
compress; renpfix E I; aorder; order S*; sum; sort Sciting;
save ./svdata/citations_zip5_rawI, replace;

*** End of program;
log close; 