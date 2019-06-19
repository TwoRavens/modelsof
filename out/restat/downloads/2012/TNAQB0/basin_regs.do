#delimit;
clear;
set more off;

global temp /Sastemp;
global path ~;
set mem 5000m;

/*================================================
 Program: basin_regs.do
 Author:  Avi Ebenstein
 Created: August 2007
 Purpose: Historical output by basin
=================================================*/

use ~/pollution/industries/datafiles/industry_basins_2000, replace;
drop if year>=1990;
bysort dspcode: egen totmanufacturing=sum(output6);

bysort dspcode: egen totman_70_00=sum(output6) if year>=1970 & year<=2000;
bysort dspcode: egen totman_80_00=sum(output6) if year>=1980 & year<=2000;
bysort dspcode: egen totman_90_00=sum(output6) if year>=1990 & year<=2000;

bysort dspcode: egen totman_70_79=sum(output6) if year>=1970 & year<=1979;
bysort dspcode: egen totman_80_89=sum(output6) if year>=1980 & year<=1989;
bysort dspcode: egen totman_90_99=sum(output6) if year>=1990 & year<=1999;


bysort dspcode: egen totman_70_84=sum(output6) if year>=1970 & year<=1984;
bysort dspcode: egen totman_85_99=sum(output6) if year>=1985 & year<=1999;
bysort dspcode: egen totman_00=sum(output6) if year==2000;


forvalues j=1970(5)1995{;
                        local k=`j'+4;
                        bysort dspcode: egen totman_`j'=sum(output6) if (year>=`j' & year<=`k');
                        bysort dspcode: egen m_totman_`j'=mean(totman_`j');

                        drop totman_`j';
                        rename m_totman_`j' totman_`j';
                        gen ln_totman_`j'=ln(totman_`j');
                  };


global mylist "totman_70_00 totman_80_00 totman_90_00 totman_70_84 totman_85_99 totman_00 totman_70_79 totman_80_89 totman_90_99";
foreach i of global mylist{;
                           bysort dspcode: egen m`i'=mean(`i');
                           drop `i';
                           rename m`i' `i';
                           gen ln_`i'=ln(`i');
                         };

bysort dspcode: keep if _n==1;


global controls "totmanufacturing yrsed farmer urban lnairpollution  i.region";
global controls2 "lntotmanufacturing yrsed farmer urban lnairpollution  i.region";
global controls3 " yrsed farmer urban lnairpollution  i.region i.cla3";


gen lncancer_rate=ln(cancer_o);
gen lndeathrate9=ln(deathrate9);
     
for any 090 091 095: gen lndeathrate_X=ln(deathrate_X);
for any 090 091 095: replace lndeathrate_X=0 if lndeathrate_X==.;

gen lntotmanufacturing=ln(totmanufacturing);
replace lntotmanufacturing=0 if lntotmanufacturing==.;

xi: reg lndeathrate9 lntotmanufacturing   [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out, replace   se bdec(3) tdec(3);
xi: reg lndeathrate_090 lntotmanufacturing  [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_091 lntotmanufacturing  [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_095 lntotmanufacturing  [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);

xi: reg lndeathrate9 lntotmanufacturing $controls3  [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out, append   se bdec(3) tdec(3);
xi: reg lndeathrate_090 lntotmanufacturing $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_091 lntotmanufacturing $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_095 lntotmanufacturing $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);

xi: reg lndeathrate9 lntotmanufacturing overall_q $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_090 lntotmanufacturing overall_q $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_091 lntotmanufacturing overall_q $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);
xi: reg lndeathrate_095 lntotmanufacturing overall_q $controls3 [w=totalpop],cluster(provgb) robust;
outreg2 using ~/pollution/industries/industryregs.out,append   se bdec(3) tdec(3);

type ~/pollution/industries/industryregs.out;
exit;
