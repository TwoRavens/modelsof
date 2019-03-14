/********************************************************************************/
/*TABLE 1*/
/*Running this do-file produces the descriptive statistics displayed in Table 1.*/
/********************************************************************************/
qui clear all
qui set more off
use "smartvote_jop.dta",clear
qui reg smartvote diff_top_ptv email $controls   , robust
qui replace sample=cond(e(sample)==1,1,0)
qui keep if sample==1
#delimit;
local statlist "
email smartvote pi_not $controls
";
/********************************************************************************/
foreach stat of local statlist{;
qui sum `stat'  if email==0;
qui scalar du0=r(mean);
qui sum `stat'  if email==1;
qui scalar du1=r(mean);
qui scalar diff_TO=du1-du0;
qui ttest `stat', by(email);
qui scalar p=abs(r(p));
di "`stat'";
scalar list du0 du1 diff_TO p;
};
/********************************************************************************/
sum email if email==0 ;
sum email if email==1 ;
/********************************************************************************/
