
#delimit;
clear all;
set mem 400m;
set matsize 1200;
version 10;

*****************************************************************************;
**** THIS PROGRAM GENERATES THE STATISTICS ON DIRECT CONNECTIONS IN 2002 ****;
**** DISCUSSED IN SECTION 6.1 OF THE PAPER                               ****;
*****************************************************************************;

******************************************;
**** Use Data and Transform Variables ****;
******************************************;

use data\Gravity2002-final.dta;
so exporter importer;

****************************;
**** Generate Hub Index ****;
****************************;

drop if exporter==importer;

encode importer,gen(impnum);
encode exporter,gen(expnum);

egen noj_imp=count(impnum),by(exporter);
egen max_noj_imp=max(noj_imp);
su max_noj;

* There are 376 destinations for each exporter;
* (Not including exporter==importer);

replace deppass=. if deppass==0;
gen direct=0;
replace direct=1 if deppass~=.;

keep if direct==1;

egen numdirect=sum(direct),by(expname);
so expname; 

gen hubindex=numdirect/376;

graph bar (mean) hubindex , over(expname, label(angle(90) labsize(small)))
bar(1, bcolor(black))
legend(lab(1 "Hub Index") size(small))
ytitle("Hub Index", margin(small) size(small))
title("Figure: Hub Index 2002", margin(small))
note("Note: Hub index is number of direct connections divided by number of possible direct connections.", size(vsmall));

collapse (mean) hubindex ,by(exporter);
