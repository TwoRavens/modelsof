version 13
#delimit;
set more off;

*last modified: 13 October 2014;

*This do-file runs models for the article published in
	Foreign Policy Analysis entitled "Why Professionalize? 
	Economic Modernization, Security, and Military	Professionalism";

clear;
clear matrix;
log using 
	"...20141013WhyProfessionalizeReplication.smcl";

quietly set mem 1000m;
quietly set matsize 800;
quietly use 
	"...20141013WhyProfessionalizeReplication.dta", 
	clear;

quietly xtset ccode year, yearly;

*Models for lnmilexsol;
*Model 1;
reg lnmilexsol aglabor democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop yr1820-yr2000 if military==1, 
        vce(cluster ccode);
*Model 2;
reg lnmilexsol perurban democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop yr1816-yr2000 if military==1, 
        vce(cluster ccode);
*Model 3;
reg lnmilexsol lnmadgdp democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop yr1816-yr2000 if military==1, 
        vce(cluster ccode);
*Model 4;
reg lnmilexsol lnmadgdp perurban aglabor 
		democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop yr1820-yr2000 if military==1, 
        vce(cluster ccode);
*Model 5;
reg lnmilexsol lnmadgdp perurban aglabor 
		democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop lnoilpercap yr1932-yr2000 if military==1, 
        vce(cluster ccode);

		
*Models for numacad;
*Model 6;
poisson numacad aglabor democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop france russia germany 
		yr1820-yr2000 if military==1, vce(cluster ccode);
*Model 7;
poisson numacad perurban democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop france russia germany 
		yr1816-yr2000 if military==1, vce(cluster ccode);
*Model 8;
poisson numacad lnmadgdp democ gpally statelife cinc postwar mid gpower 
        gppostwar lnpop france russia germany 
		yr1816-yr2000 if military==1, vce(cluster ccode);
*Model 9;
poisson numacad aglabor perurban lnmadgdp democ gpally 
		statelife cinc postwar mid gpower 
        gppostwar lnpop france russia germany 
		yr1820-yr2000 if military==1, vce(cluster ccode);
*Model 10;
poisson numacad aglabor perurban lnmadgdp democ gpally 
		statelife cinc postwar mid gpower 
        gppostwar lnpop lnoilpercap france russia germany 
		yr1932-yr2000 if military==1, vce(cluster ccode);
		
*Models for perdcls;
*Model 11;
nbreg perdcls aglabor democ gpally statelife cinc 
	postwar mid gpower gppostwar lnpop 
    us uk yr1820-yr2000 if military==1, vce(cluster ccode);
*Model 12;
nbreg perdcls perurban democ gpally statelife cinc 
	postwar mid gpower gppostwar lnpop 
    us uk yr1816-yr2000 if military==1, vce(cluster ccode);
*Model 13;
nbreg perdcls lnmadgdp democ gpally statelife cinc 
	postwar mid gpower gppostwar lnpop 
	us uk yr1816-yr2000 if military==1, vce(cluster ccode);
*Model 14;
nbreg perdcls aglabor perurban lnmadgdp democ gpally statelife cinc 
	postwar mid gpower gppostwar lnpop 
	us uk yr1820-yr2000 if military==1, vce(cluster ccode);
*Model 15;
nbreg perdcls aglabor perurban lnmadgdp democ gpally statelife cinc 
	postwar mid gpower gppostwar lnpop lnoilpercap 
	us uk yr1932-yr2000 if military==1, vce(cluster ccode);

log off;
