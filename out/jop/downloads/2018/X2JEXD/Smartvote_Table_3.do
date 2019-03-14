/*******************************************************************/
/*TABLE 3*/
/*Running this do-file produces the estimates displayed in Table 3.*/
/*******************************************************************/
qui clear all
qui set more off
use "smartvote_jop.dta",clear
#delimit;
/*******************************************************************/
/*Outcome: Smartvote used*/
qui reg smartvote email $controls   , robust;
qui replace sample=cond(e(sample)==1,1,0);
sum smartvote if sample==1 & email==0;
reg smartvote email               if sample==1 , robust;
reg smartvote email $controls     if sample==1 , robust;
/*******************************************************************/
/*Outcome: Difference in top PTV score*/
sum diff_top_ptv if sample==1 & email==0;
reg diff_top_ptv email            if sample==1 , robust;
reg diff_top_ptv email $controls  if sample==1 , robust;
/*******************************************************************/
/*Outcome: Same top PTV party*/
sum same_top_ptv if sample==1 & email==0;
reg same_top_ptv email            if sample==1 , robust;
reg same_top_ptv email $controls  if sample==1 , robust;
/*******************************************************************/
/*Outcome: Change in multiple intentions*/
sum changemptv if sample==1 & email==0;
reg changemptv email               if sample==1 , robust;
reg changemptv email $controls     if sample==1 , robust;
/*******************************************************************/
/*Outcome: Newly available to electoral competition*/
sum newmult if sample==1 & email==0;
reg newmult email               if sample==1 , robust;
reg newmult email $controls     if sample==1 , robust;
/*******************************************************************/
