/*Open tableH.dta*/

/*latwe1 = positively worded identity item*/

/*latid1 = reverse worded identity item*/

/*latid1 has been rescaled so that higher values indicate greater identity strength*/

tab latwe1 if latid1==1
tab latwe1 if latid1==2

ttest time4=time5
