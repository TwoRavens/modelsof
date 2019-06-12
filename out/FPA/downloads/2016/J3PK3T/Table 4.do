version 11.2
set more off




*Military/ITERATE PREDICTED PROBABILITIES			

oprobit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag ITERATELoclag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

sum p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag ITERATELoclag RstrctAccess dissentlag if e(sample), d

preserve

set seed 10101

drawnorm JC_b1-JC_b14, n(1000) means(e(b)) cov(e(V)) clear

save simulated_betas, replace

restore

merge using simulated_betas

summarize _merge

drop _merge

***Scenario1 ITT=0****
scalar h_p_polity2lag = 3.413096

scalar h_gdppclag = 6021.553

scalar h_poplag = 33674.49

scalar h_civilwarlag = 0

scalar h_ucdp_type2lag = 0
 
scalar h_catlag = 1

scalar h_ITERATELoclag = 0

scalar h_RstrctAccess = 0

scalar h_dissentlag = 0




generate x_betahat1a = JC_b10-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1a = normal(x_betahat1a)

sum prob_hat1a

centile prob_hat1a, centile(2.5 97.5)

***Scenario1 ITT=1***
generate x_betahat1b = JC_b11-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1b = normal(x_betahat1b)- normal(x_betahat1a)

sum prob_hat1b

centile prob_hat1b, centile(2.5 97.5)

***Scenario1 ITT=2***
generate x_betahat1c = JC_b12-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1c = normal(x_betahat1c)- normal(x_betahat1b)

sum prob_hat1c

centile prob_hat1c, centile(2.5 97.5)

***Scenario1 ITT=3***

generate x_betahat1d = JC_b13-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1d = normal(x_betahat1d)- normal(x_betahat1c)

sum prob_hat1d

centile prob_hat1d, centile(2.5 97.5)

***Scenario1 ITT=4***

generate x_betahat1e = JC_b14-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1e = normal(x_betahat1e)- normal(x_betahat1d)

sum prob_hat1e

centile prob_hat1e, centile(2.5 97.5)

***Scenario1 ITT=5***

generate prob_hat1f = 1 - normal(x_betahat1e)

sum prob_hat1f

centile prob_hat1f, centile(2.5 97.5)



 
***Scenario2 ITT=0***
scalar h_ITERATELoclag = 20

generate x_betahat2a = JC_b10-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2a = normal(x_betahat2a)

sum prob_hat2a

centile prob_hat2a, centile(2.5 97.5)

***Scenario2 ITT=1***
generate x_betahat2b = JC_b11-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2b = normal(x_betahat2b)- normal(x_betahat2a)

sum prob_hat2b

centile prob_hat2b, centile(2.5 97.5)

***Scenario2 ITT=2***
generate x_betahat2c = JC_b12-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2c = normal(x_betahat2c)- normal(x_betahat2b)

sum prob_hat2c

centile prob_hat2c, centile(2.5 97.5)

***Scenario2 ITT=3***

generate x_betahat2d = JC_b13-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2d = normal(x_betahat2d)- normal(x_betahat2c)

sum prob_hat2d

centile prob_hat2d, centile(2.5 97.5)

***Scenario2 ITT=4***

generate x_betahat2e = JC_b14-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_ITERATELoclag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2e = normal(x_betahat2e)- normal(x_betahat2d)

sum prob_hat2e

centile prob_hat2e, centile(2.5 97.5)

***Scenario2 ITT=5***

generate prob_hat2f = 1 - normal(x_betahat2e)

sum prob_hat2f

centile prob_hat2f, centile(2.5 97.5)

 
***Difference: 0 Category***
generate diff0 = prob_hat2a- prob_hat1a

sum prob_hat1a prob_hat2a diff0

centile prob_hat1a prob_hat2a diff0, centile(2.5 97.5)

***Difference 1: Category***
generate diff1 = prob_hat2b- prob_hat1b

sum prob_hat1b prob_hat2b diff1

centile prob_hat1b prob_hat2b diff1, centile(2.5 97.5)

***Difference 2: Category***
generate diff2 = prob_hat2c- prob_hat1c

sum prob_hat1c prob_hat2c diff2

centile prob_hat1c prob_hat2c diff2, centile(2.5 97.5)

***Difference 3: Category***
generate diff3 = prob_hat2d- prob_hat1d

sum prob_hat1d prob_hat2d diff3

centile prob_hat1d prob_hat2d diff3, centile(2.5 97.5)

***Difference 4: Category***
generate diff4 = prob_hat2e- prob_hat1e

sum prob_hat1e prob_hat2e diff4

centile prob_hat1e prob_hat2e diff4, centile(2.5 97.5)

***Difference 5: Category***
generate diff5 = prob_hat2f- prob_hat1f

sum prob_hat1f prob_hat2f diff5

centile prob_hat1f prob_hat2f diff5, centile(2.5 97.5)


drop JC_b1 JC_b2 JC_b3 JC_b4 JC_b5 JC_b6 JC_b7 JC_b8 JC_b9 JC_b10 JC_b11 JC_b12 JC_b13 JC_b14 x_betahat1a x_betahat1b x_betahat1c x_betahat1d x_betahat1e   prob_hat1a prob_hat1b prob_hat1c prob_hat1d prob_hat1e prob_hat1f prob_hat2a prob_hat2b prob_hat2c prob_hat2d  prob_hat2e prob_hat2f x_betahat2a x_betahat2b x_betahat2c x_betahat2d x_betahat2e diff0 diff1 diff2 diff3 diff4 diff5



*Military/Domestic PREDICTED PROBABILITIES	

oprobit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDDomesticlag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

sum LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDDomesticlag RstrctAccess dissentlag if e(sample), d

preserve

set seed 10101

drawnorm JC_b1-JC_b14, n(1000) means(e(b)) cov(e(V)) clear

save simulated_betas, replace

restore

merge using simulated_betas

summarize _merge

drop _merge

***Scenario1 ITT=0****
scalar h_p_polity2lag = 3.424194

scalar h_gdppclag = 6028.74

scalar h_poplag = 33654.54

scalar h_civilwarlag = 0

scalar h_ucdp_type2lag = 0
 
scalar h_catlag = 1

scalar h_GTDDomesticlag = 0

scalar h_RstrctAccess = 0

scalar h_dissentlag = 0




generate x_betahat1a = JC_b10-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1a = normal(x_betahat1a)

sum prob_hat1a

centile prob_hat1a, centile(2.5 97.5)

***Scenario1 ITT=1***
generate x_betahat1b = JC_b11-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1b = normal(x_betahat1b)- normal(x_betahat1a)

sum prob_hat1b

centile prob_hat1b, centile(2.5 97.5)

***Scenario1 ITT=2***
generate x_betahat1c = JC_b12-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1c = normal(x_betahat1c)- normal(x_betahat1b)

sum prob_hat1c

centile prob_hat1c, centile(2.5 97.5)

***Scenario1 ITT=3***

generate x_betahat1d = JC_b13-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1d = normal(x_betahat1d)- normal(x_betahat1c)

sum prob_hat1d

centile prob_hat1d, centile(2.5 97.5)

***Scenario1 ITT=4***

generate x_betahat1e = JC_b14-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1e = normal(x_betahat1e)- normal(x_betahat1d)

sum prob_hat1e

centile prob_hat1e, centile(2.5 97.5)

***Scenario1 ITT=5***

generate prob_hat1f = 1 - normal(x_betahat1e)

sum prob_hat1f

centile prob_hat1f, centile(2.5 97.5)



 
***Scenario2 ITT=0***
scalar h_GTDDomesticlag = 20

generate x_betahat2a = JC_b10-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2a = normal(x_betahat2a)

sum prob_hat2a

centile prob_hat2a, centile(2.5 97.5)

***Scenario2 ITT=1***
generate x_betahat2b = JC_b11-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2b = normal(x_betahat2b)- normal(x_betahat2a)

sum prob_hat2b

centile prob_hat2b, centile(2.5 97.5)

***Scenario2 ITT=2***
generate x_betahat2c = JC_b12-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2c = normal(x_betahat2c)- normal(x_betahat2b)

sum prob_hat2c

centile prob_hat2c, centile(2.5 97.5)

***Scenario2 ITT=3***

generate x_betahat2d = JC_b13-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2d = normal(x_betahat2d)- normal(x_betahat2c)

sum prob_hat2d

centile prob_hat2d, centile(2.5 97.5)

***Scenario2 ITT=4***

generate x_betahat2e = JC_b14-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDDomesticlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2e = normal(x_betahat2e)- normal(x_betahat2d)

sum prob_hat2e

centile prob_hat2e, centile(2.5 97.5)

***Scenario2 ITT=5***

generate prob_hat2f = 1 - normal(x_betahat2e)

sum prob_hat2f

centile prob_hat2f, centile(2.5 97.5)

 
***Difference: 0 Category***
generate diff0 = prob_hat2a- prob_hat1a

sum prob_hat1a prob_hat2a diff0

centile prob_hat1a prob_hat2a diff0, centile(2.5 97.5)

***Difference 1: Category***
generate diff1 = prob_hat2b- prob_hat1b

sum prob_hat1b prob_hat2b diff1

centile prob_hat1b prob_hat2b diff1, centile(2.5 97.5)

***Difference 2: Category***
generate diff2 = prob_hat2c- prob_hat1c

sum prob_hat1c prob_hat2c diff2

centile prob_hat1c prob_hat2c diff2, centile(2.5 97.5)

***Difference 3: Category***
generate diff3 = prob_hat2d- prob_hat1d

sum prob_hat1d prob_hat2d diff3

centile prob_hat1d prob_hat2d diff3, centile(2.5 97.5)

***Difference 4: Category***
generate diff4 = prob_hat2e- prob_hat1e

sum prob_hat1e prob_hat2e diff4

centile prob_hat1e prob_hat2e diff4, centile(2.5 97.5)

***Difference 5: Category***
generate diff5 = prob_hat2f- prob_hat1f

sum prob_hat1f prob_hat2f diff5

centile prob_hat1f prob_hat2f diff5, centile(2.5 97.5)


drop JC_b1 JC_b2 JC_b3 JC_b4 JC_b5 JC_b6 JC_b7 JC_b8 JC_b9 JC_b10 JC_b11 JC_b12 JC_b13 JC_b14 x_betahat1a x_betahat1b x_betahat1c x_betahat1d x_betahat1e   prob_hat1a prob_hat1b prob_hat1c prob_hat1d prob_hat1e prob_hat1f prob_hat2a prob_hat2b prob_hat2c prob_hat2d  prob_hat2e prob_hat2f x_betahat2a x_betahat2b x_betahat2c x_betahat2d x_betahat2e diff0 diff1 diff2 diff3 diff4 diff5



*Military/All Attacks PREDICTED PROBABILITIES	

oprobit LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDlag RstrctAccess dissentlag, robust cluster (ccodecow) nolog

sum LoTMilitaryRecode p_polity2lag gdppclag poplag civilwarlag ucdp_type2lag catlag GTDlag RstrctAccess dissentlag if e(sample),d

preserve

set seed 10101

drawnorm JC_b1-JC_b14, n(1000) means(e(b)) cov(e(V)) clear

save simulated_betas, replace

restore

merge using simulated_betas

summarize _merge

drop _merge

***Scenario1 ITT=0****
scalar h_p_polity2lag = 3.420032

scalar h_gdppclag = 6037.956

scalar h_poplag = 33507.82

scalar h_civilwarlag = 0

scalar h_ucdp_type2lag = 0
 
scalar h_catlag = 1

scalar h_GTDlag = 0

scalar h_RstrctAccess = 0

scalar h_dissentlag = 0




generate x_betahat1a = JC_b10-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1a = normal(x_betahat1a)

sum prob_hat1a

centile prob_hat1a, centile(2.5 97.5)

***Scenario1 ITT=1***
generate x_betahat1b = JC_b11-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1b = normal(x_betahat1b)- normal(x_betahat1a)

sum prob_hat1b

centile prob_hat1b, centile(2.5 97.5)

***Scenario1 ITT=2***
generate x_betahat1c = JC_b12-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1c = normal(x_betahat1c)- normal(x_betahat1b)

sum prob_hat1c

centile prob_hat1c, centile(2.5 97.5)

***Scenario1 ITT=3***

generate x_betahat1d = JC_b13-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1d = normal(x_betahat1d)- normal(x_betahat1c)

sum prob_hat1d

centile prob_hat1d, centile(2.5 97.5)

***Scenario1 ITT=4***

generate x_betahat1e = JC_b14-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat1e = normal(x_betahat1e)- normal(x_betahat1d)

sum prob_hat1e

centile prob_hat1e, centile(2.5 97.5)

***Scenario1 ITT=5***

generate prob_hat1f = 1 - normal(x_betahat1e)

sum prob_hat1f

centile prob_hat1f, centile(2.5 97.5)



 
***Scenario2 ITT=0***
scalar h_GTDlag = 20

generate x_betahat2a = JC_b10-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2a = normal(x_betahat2a)

sum prob_hat2a

centile prob_hat2a, centile(2.5 97.5)

***Scenario2 ITT=1***
generate x_betahat2b = JC_b11-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2b = normal(x_betahat2b)- normal(x_betahat2a)

sum prob_hat2b

centile prob_hat2b, centile(2.5 97.5)

***Scenario2 ITT=2***
generate x_betahat2c = JC_b12-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2c = normal(x_betahat2c)- normal(x_betahat2b)

sum prob_hat2c

centile prob_hat2c, centile(2.5 97.5)

***Scenario2 ITT=3***

generate x_betahat2d = JC_b13-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2d = normal(x_betahat2d)- normal(x_betahat2c)

sum prob_hat2d

centile prob_hat2d, centile(2.5 97.5)

***Scenario2 ITT=4***

generate x_betahat2e = JC_b14-(JC_b1*h_p_polity2lag + JC_b2*h_gdppclag + JC_b3*h_poplag + JC_b4*h_civilwarlag + JC_b5*h_ucdp_type2lag + JC_b6*h_catlag + JC_b7*h_GTDlag + JC_b8*h_RstrctAccess + JC_b9*h_dissentlag)

generate prob_hat2e = normal(x_betahat2e)- normal(x_betahat2d)

sum prob_hat2e

centile prob_hat2e, centile(2.5 97.5)

***Scenario2 ITT=5***

generate prob_hat2f = 1 - normal(x_betahat2e)

sum prob_hat2f

centile prob_hat2f, centile(2.5 97.5)

 
***Difference: 0 Category***
generate diff0 = prob_hat2a- prob_hat1a

sum prob_hat1a prob_hat2a diff0

centile prob_hat1a prob_hat2a diff0, centile(2.5 97.5)

***Difference 1: Category***
generate diff1 = prob_hat2b- prob_hat1b

sum prob_hat1b prob_hat2b diff1

centile prob_hat1b prob_hat2b diff1, centile(2.5 97.5)

***Difference 2: Category***
generate diff2 = prob_hat2c- prob_hat1c

sum prob_hat1c prob_hat2c diff2

centile prob_hat1c prob_hat2c diff2, centile(2.5 97.5)

***Difference 3: Category***
generate diff3 = prob_hat2d- prob_hat1d

sum prob_hat1d prob_hat2d diff3

centile prob_hat1d prob_hat2d diff3, centile(2.5 97.5)

***Difference 4: Category***
generate diff4 = prob_hat2e- prob_hat1e

sum prob_hat1e prob_hat2e diff4

centile prob_hat1e prob_hat2e diff4, centile(2.5 97.5)

***Difference 5: Category***
generate diff5 = prob_hat2f- prob_hat1f

sum prob_hat1f prob_hat2f diff5

centile prob_hat1f prob_hat2f diff5, centile(2.5 97.5)


drop JC_b1 JC_b2 JC_b3 JC_b4 JC_b5 JC_b6 JC_b7 JC_b8 JC_b9 JC_b10 JC_b11 JC_b12 JC_b13 JC_b14 x_betahat1a x_betahat1b x_betahat1c x_betahat1d x_betahat1e   prob_hat1a prob_hat1b prob_hat1c prob_hat1d prob_hat1e prob_hat1f prob_hat2a prob_hat2b prob_hat2c prob_hat2d  prob_hat2e prob_hat2f x_betahat2a x_betahat2b x_betahat2c x_betahat2d x_betahat2e diff0 diff1 diff2 diff3 diff4 diff5




exit

