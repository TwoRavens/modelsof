/*********************************************************************************/
/*TABLE A1*/
/*Running this do-file produces the descriptive statistics displayed in Table A1.*/
/*********************************************************************************/
qui clear all
qui set more off
use "smartvote_jop.dta",clear
qui reg smartvote diff_top_ptv email $controls   , robust
qui replace sample=cond(e(sample)==1,1,0)
qui keep if sample==1
/*********************************************************************************/
* Difference for every party before and after
gen FDPchange=n1_61_6_1 - v1_97_1
replace FDPchange=. if v1_97_1 >10 | n1_61_6_1>10
gen CVPchange=n1_61_6_2 - v1_97_2
replace CVPchange=. if v1_97_2 >10 | n1_61_6_2>10
gen SVPchange=n1_61_6_3 - v1_97_3
replace SVPchange=. if v1_97_3 >10 | n1_61_6_3>10
gen SPchange=n1_61_6_4 - v1_97_4
replace SPchange=. if v1_97_4 >10 | n1_61_6_4>10
gen Grchange=n1_61_6_5 - v1_97_5
replace Grchange=. if v1_97_5 >10 | n1_61_6_5>10
gen GLPchange=n1_61_6_6 - v1_97_6
replace GLPchange=. if v1_97_6 >10 | n1_61_6_6>10
gen BDPchange=n1_61_6_7 - v1_97_7
replace BDPchange=. if v1_97_7 >10 | n1_61_6_7>10
gen EVPchange=n1_61_6_8 - v1_97_8
replace EVPchange=. if v1_97_8 >10 | n1_61_6_8>10
/*********************************************************************************/
#delimit;
local statlist "
v1_97_1 v1_97_2 v1_97_3 v1_97_4 v1_97_5 v1_97_6 v1_97_7 v1_97_8 n1_61_6_1 n1_61_6_2 n1_61_6_3 n1_61_6_4 n1_61_6_5 n1_61_6_6 n1_61_6_7 n1_61_6_8
FDPchange CVPchange SVPchange SPchange Grchange GLPchange BDPchange EVPchange";
/*********************************************************************************/
foreach stat of local statlist{;
qui replace `stat'=. if `stat'>10;
};
/*********************************************************************************/
foreach stat of local statlist{;
di "`stat'";
qui sum `stat'  if email==0;
qui scalar du0=r(mean);
qui sum `stat'  if email==1;
qui scalar du1=r(mean);
qui scalar diff_TO=du1-du0;
qui ttest `stat', by(email);
qui scalar p=abs(r(p));
scalar list du0 du1 diff_TO p;
};
/*********************************************************************************/
