
#delimit;
clear all;
set mem 400m;
set matsize 1200;
version 10;

**********************************************************************************;
**** THIS PROGRAM GENERATES THE STATISTICS ON DIRECT CONNECTIONS IN THE 1930s ****;
**** DISCUSSED IN SECTION 6.1 OF THE PAPER                                    ****;
**********************************************************************************;

**** The source for these data is the Summer schedule of Deutsche Lufthansa AG 1935;
**** in: Nachrichten fuer Luftfahrer 1936, 17 Jahrgang (Berlin 1936);

u data\directconnections1930s.dta;

gen munster=.;
gen saarbrucken=.;
ren halle__leipzig leipzig;
ren koeln cologne;
ren duesseldorf dusseldorf;
ren muenchen munich;
ren nuernberg nurenberg;
gen obs=_n;
egen max_obs=max(obs);

local airports="berlin bremen dresden dusseldorf erfurt frankfurt hamburg hannover cologne
leipzig munich nurenberg stuttgart munster saarbrucken";

foreach var in `airports' {;
ren `var' direct`var';
};

reshape long direct , i(destination) j(expname) string;
replace direct=0 if direct==.;
replace expname=proper(expname);
lab var direct "Dummy==1 if direct connections in 1935";

order expname destination;

egen num_dir=sum(direct), by(expname);
so expname destination;

gen hubindex=num_dir/max_obs;

graph bar (mean) hubindex , over(expname, label(angle(90) labsize(small)))
bar(1, bcolor(black))
legend(lab(1 "Hub Index") size(small))
ytitle("Hub Index", margin(small) size(small))
title("Figure: Hub Index 1935", margin(small))
note("Note: Hub index is number of direct connections divided by number of possible direct connections.", size(vsmall));
