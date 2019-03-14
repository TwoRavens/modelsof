/******************************************************************************/
/*TABLE 5*/
/*Running this do-file produces the relative likelihoods displayed in Table 5.*/
/******************************************************************************/
qui clear all
qui set more off
use "smartvote_jop.dta",clear
#delimit;
qui reg smartvote diff_top_ptv email $controls   , robust;
qui replace sample=cond(e(sample)==1,1,0);
qui keep if sample==1;
/******************************************************************************/
qui gen above_median_age=cond(age>23,1,0);
qui gen pknow=cond(polknow>=6,1,0) if polknow!=.;
local statlist "female above_median_age highschool bachelor_university master_university social medicine natural law econ pi_rnot pi_r pi_very";
foreach stat of local statlist{;
qui reg smartvote email               if sample==1 & `stat'==1, robust;
qui mat A=e(b);
qui scalar BAT=A[1,1];
qui reg smartvote email               if sample==1 , robust;
qui mat A=e(b);
qui scalar CAT=A[1,1];
qui scalar DAT=BAT/CAT;
qui sum `stat';
qui scalar EAT=r(mean);
qui scalar FAT=DAT*EAT;
di "`stat'";
scalar list EAT FAT DAT ;
};
/******************************************************************************/
