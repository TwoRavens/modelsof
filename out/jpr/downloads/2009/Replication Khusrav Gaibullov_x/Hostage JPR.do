******Logistical success*****

****summary stats******
recode hostage (999=.)
recode highpweap (9=.)
recode protpersn (9=.)
gen hstgsqrt=sqrt(hostage)
sum logtksuc attkfrce nattersts hstgsqrt protpersn kidnap terwok highpweap if hostage!=.
gen attkf_hpw= attkfrce*highpweap

******************* estimation *******************
logit logtksuc attkfrce  highpweap attkf_hpw nattersts hstgsqrt kidnap protpersn terwok 
est store L1
inteff logtksuc attkfrce highpweap attkf_hpw nattersts hstgsqrt kidnap protpersn terwok   
mfx
logit logtksuc attkfrce highpweap attkf_hpw nattersts kidnap protpersn terwok 
est store L2
inteff logtksuc attkfrce highpweap attkf_hpw nattersts kidnap protpersn terwok 
mfx
logit logtksuc attkfrce nattersts hstgsqrt kidnap protpersn terwok 
est store L3
mfx
est table L1 L2 L3, stats(N, chi2) se p 


***Negot. success - nonkidnappings***

**** summary stats*****
recode hostage (999=.)
recode money (9=.)
recode hour (9999=.)
gen hstgsqrt=sqrt(hostage)
sum negsuc hstgsqrt terwok nonterwok tmdemnd money protpersn hour if hstgsqrt!=.

***************** Estimation *******************
logit negsuc hstgsqrt terwok nonterwok tmdemnd hour
est store L1
mfx
logit negsuc hstgsqrt terwok nonterwok tmdemnd hour money protpersn  
est store L2
mfx
logit negsuc terwok nonterwok tmdemnd hour money protpersn  
est store L3
mfx
est table L1 L2 L3, stats(N, chi2) se p


***Negot. success - kidnappings***

**** summary stats*****
recode money (9=.)
gen hstgsqrt=sqrt(hostage)
gen dsqrt=sqrt(day)
sum negsuc hstgsqrt terwok nonterwok tmdemnd money protpersn dsqrt

***************** estimation **************
logit negsuc hstgsqrt terwok nonterwok tmdemnd dsqrt
est store L1
mfx
logit negsuc hstgsqrt terwok nonterwok tmdemnd dsqrt money protpersn
est store L2
mfx
est table L1 L2, stats(N, chi2) se p





