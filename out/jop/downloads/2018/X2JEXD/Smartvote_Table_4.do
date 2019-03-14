/*******************************************************************/
/*TABLE 4*/
/*Running this do-file produces the estimates displayed in Table 4.*/
/*******************************************************************/
qui clear all
qui set more off
use "smartvote_jop.dta",clear
#delimit;
qui reg smartvote diff_top_ptv email $controls   , robust;
qui replace sample=cond(e(sample)==1,1,0);
/*******************************************************************/
/*Outcome: Difference in top PTV score*/
reg diff_top_ptv smartvote                                  if sample==1 , robust;
reg diff_top_ptv smartvote $controls                        if sample==1 , robust;
ivregress 2sls diff_top_ptv (smartvote=email)               if sample==1 , robust;
ivregress 2sls diff_top_ptv (smartvote=email) $controls     if sample==1 , robust;
/*******************************************************************/
/*Outcome: Same top PTV party*/
reg same_top_ptv  smartvote                                 if sample==1 , robust;
reg same_top_ptv  smartvote $controls                       if sample==1 , robust;
ivregress 2sls same_top_ptv  (smartvote=email)              if sample==1 , robust;
ivregress 2sls same_top_ptv  (smartvote=email) $controls    if sample==1 , robust;
/*******************************************************************/
/*Outcome: Change in multiple preferences*/
reg changemptv  smartvote                                   if sample==1 , robust;
reg changemptv  smartvote $controls                         if sample==1 , robust;
ivregress 2sls changemptv  (smartvote=email)                if sample==1 , robust;
ivregress 2sls changemptv  (smartvote=email) $controls      if sample==1 , robust;
/*******************************************************************/
/*Outcome: Newly available to electoral competition*/
reg newmult  smartvote                                      if sample==1 , robust;
reg newmult  smartvote $controls                            if sample==1 , robust;
ivregress 2sls newmult  (smartvote=email)                   if sample==1 , robust;
ivregress 2sls newmult  (smartvote=email) $controls         if sample==1 , robust;
/*******************************************************************/
