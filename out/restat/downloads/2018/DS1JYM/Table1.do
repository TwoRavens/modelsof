

***********************

 /* Researchers interested in replicating the results should obtain the required authorization (see Campa_Serafinelli_ReSTAT_Replication-README.pdf) */
   /* If you have any questions on this do file do not hesitate to contact us */
   
log using Table_1, replace

* Table 1
* (here with cluster(kkz_rek), below robust SE)

gen Femalexnear_distc1=Female*near_distc1
gen Femalexcutoffxnear_distc1=Female*cutoff*near_distc1


* col 1
reg imp_succ_job_binary cutoff Female Femalexcutoff, cluster(kkz_rek)
estadd ysumm 
outreg2 cutoff industrial using diffindisc_cluster.tex, replace nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, NO)

gen kwt=max(0, 200-abs(near_distc1)) 

* col 2
reg imp_succ_job_binary  near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], cluster(kkz_rek)
estadd ysumm 
outreg2 cutoff using diffindisc_cluster.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)

* col 3
replace kwt=max(0, 150-abs(near_distc1)) 
reg imp_succ_job_binary  near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], cluster(kkz_rek)
estadd ysumm 
outreg2 cutoff industrial using diffindisc_cluster.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)

* col 4
replace kwt=max(0, 100-abs(near_distc1)) 
reg imp_succ_job_binary near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], cluster(kkz_rek)
estadd ysumm 
outreg2 cutoff industrial using diffindisc_cluster.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)

* col 5
replace kwt=max(0, 50-abs(near_distc1)) 
reg imp_succ_job_binary near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], cluster(kkz_rek)
estadd ysumm 
outreg2 cutoff industrial using diffindisc_cluster.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)


**robust standard errors**


reg imp_succ_job_binary cutoff Female Femalexcutoff, rob
estadd ysumm 
outreg2 cutoff industrial using diffindisc_cluster.tex, replace nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, NO)


replace kwt=max(0, 200-abs(near_distc1)) 
reg imp_succ_job_binary  near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], robust
estadd ysumm 
outreg2 cutoff industrial using diffindisc_robust.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)


replace kwt=max(0, 150-abs(near_distc1)) 
reg imp_succ_job_binary  near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], robust
estadd ysumm 
outreg2 cutoff industrial using diffindisc_robust.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)


replace kwt=max(0, 100-abs(near_distc1)) 
reg imp_succ_job_binary near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], robust
estadd ysumm 
outreg2 cutoff industrial using diffindisc_robust.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)


replace kwt=max(0, 50-abs(near_distc1)) 
reg imp_succ_job_binary near_distc1 cutoff near_distc1xcutoff Female Femalexcutoff i.near_fidc [pw=kwt], robust
estadd ysumm 
outreg2 cutoff industrial using diffindisc_robust.tex, append nocon /*
*/  label  dec(3) adjr2 addtext(Border segment FE.s, YES)


log c
exit

