
***************************************

 /* Researchers interested in replicating the results should obtain the required authorization (see Campa_Serafinelli_ReSTAT_Replication-README.pdf) */
   /* If you have any questions on this do file do not hesitate to contact us */
   
log using Table_2, replace

*****TABLE 2****

* col 1 
reg dmean_attitudes_prov dempl, rob
reg dmean_attitudes_prov dempl, cluster(Dist_code)
*boottest dempl=0, reps(1000)
outreg2 using instrument.tex, dec(3) replace nocons adjr addtext(N clusters, 14, Bootstrapped p-value, 0.332) label
 

label var dempl "$\Delta$ Fem Empl"
label var dmean_at "$\Delta$ Women's attitudes"
label var Instrument "IV"

* col 2
reg dempl Instr if treated==1 & dmean_attitudes_prov!=., rob
reg dempl Instr if treated==1 & dmean_attitudes_prov!=., cluster(Dist_code)
*boottest Instr=0, reps(1000)
outreg2 using instrument.tex, dec(3) append nocons adjr addtext(N clusters, 14, Bootstrapped p-value, 0.046, F-test, 6.18) label

* col 3
reg dmean_attitudes_prov Instr if treated==1, rob
reg dmean_attitudes_prov Instr if treated==1, cluster(Dist_code)
*boottest Instr=0, reps(1000)
outreg2 using instrument.tex, dec(3) append nocons adjr addtext(N clusters, 14, Bootstrapped p-value, 0.126) label

* col 4
ivreg2 dmean_attitudes_prov (dempl=Instr) if treated==1, rob
ivreg2 dmean_attitudes_prov (dempl=Instr) if treated==1, cluster(Dist_code)
*boottest dempl=0, reps(1000)
outreg2 using instrument.tex, dec(3) append nocons adjr addtext(N clusters, 14, Bootstrapped p-value, 0.152) label
log c


exit

