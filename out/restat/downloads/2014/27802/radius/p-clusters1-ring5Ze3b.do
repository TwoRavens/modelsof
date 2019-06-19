* William Kerr, TGG; 
* Cite Bilateral Analysis;
* Last Updated Nov 2012;

#delimit;
cap n log close; log using p-clusters1-ring5Ze3b.log, replace;
clear all; set matsize 1000; set more off;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;
* do /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1/p-clusters1-ring5Ze3b.do;

************************;
** Joint Test a      ***;
************************;

*** Open combined zip code data;
use if dist<=150 & Szip!=Rzip using ./svdata/citations_cluster1_ring5Z3, clear; ren Rzip Dzip;
ren ct_scat1 ct1; gen ct23=ct_scat2+ct_scat3; drop ct_* Dscat; ren Sscat scat; 
egen city1a=group(Szip); egen city2a=group(Dzip);
egen temp1=rmin(city1a city2a); gen zip1=Szip if city1a==temp1; replace zip1=Dzip if city2a==temp1; drop temp1;
egen temp2=rmax(city1a city2a); gen zip2=Szip if city1a==temp2; replace zip2=Dzip if city2a==temp2; drop temp2;
keep ct1 ct23 Spat Dpat dist zip1 zip2 scat;
collapse (sum) ct1 ct23 Spat Dpat (mean) dist, by(zip1 zip2 scat) fast;
compress; count; ren zip1 Szip; ren zip2 Dzip;
gen SDpat=Spat*Dpat; gen wt=int(SDpat); for var SDpat dist: gen lX=ln(X); 

*** Test joint; 
gen byte qD10=(dist<=10);
gen byte qD30=(dist>10 & dist<=30);
log off;
levelsof scat, local(scatI);
foreach Q4 of local scatI {;
for Z in any 10 30: gen byte qDZ_`Q4'=qDZ*(scat==`Q4');
};
log on; 

for num 1 23: gen lctX=ln(1+ctX);

keep lct1 lct2 qD10_* qD30_* lSDpat wt scat; compress;
for var lct1 lct2 qD10_* qD30_* lSDpat: egen temp1=mean(X), by(scat) \ replace X=X-temp1 \ drop temp1 \ compress;
regress lct1 qD10_* qD30_* lSDpat [aw=wt], vce(r);
regress lct2 qD10_* qD30_* lSDpat [aw=wt], vce(r);

************************;
** Joint Test b      ***;
************************;

*** Open combined zip code data;
use if dist<=150 & Szip!=Rzip using ./svdata/citations_cluster1_ring5Z3, clear; ren Rzip Dzip;
ren ct_scat1 ct1; gen ct23=ct_scat2+ct_scat3; drop ct_* Dscat; ren Sscat scat; 
egen city1a=group(Szip); egen city2a=group(Dzip);
egen temp1=rmin(city1a city2a); gen zip1=Szip if city1a==temp1; replace zip1=Dzip if city2a==temp1; drop temp1;
egen temp2=rmax(city1a city2a); gen zip2=Szip if city1a==temp2; replace zip2=Dzip if city2a==temp2; drop temp2;
keep ct1 ct23 Spat Dpat dist zip1 zip2 scat;
collapse (sum) ct1 ct23 Spat Dpat (mean) dist, by(zip1 zip2 scat) fast;
compress; count; ren zip1 Szip; ren zip2 Dzip;
gen SDpat=Spat*Dpat; gen wt=int(SDpat); for var SDpat dist: gen lX=ln(X); 

*** Test joint; 
gen byte qD10=(dist<=10);
gen byte qD30=(dist>10 & dist<=30);
log off;
levelsof scat, local(scatI);
foreach Q4 of local scatI {;
for Z in any 10 30: gen byte qDZ_`Q4'=qDZ*(scat==`Q4');
};
log on; 

for num 1 23: gen lctX=ln(1+ctX);

keep lct1 lct2 qD10_* qD30_* lSDpat wt scat; compress;
areg lct1 qD10_* qD30_* lSDpat [aw=wt], a(scat) r;
areg lct2 qD10_* qD30_* lSDpat [aw=wt], a(scat) r;

*** End of program;
log close;