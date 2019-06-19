/*create needed matrices to calculate bootstrapped se's */
svmat m1_400
svmat prob1_400
svmat cov1_400

/* transform matrix of estimated bootstrap coefficients of the selection eq. into variables */
/* create rho and sigma_e */
gen rho_ev = cov1_4003 /* this undoes the transformation that stata's heckman command uses */
/* rho_ev = correlation between the error terms */
gen sigma_e = cov1_4002 /*  undoes stata transformation: sigma_e = s.d. of the error term of the investment equation */
gen sigma_nu = 1/abs(cov1_4001) /* sigma_nu = s.d. of the error term of the selection equation */
gen rho = (rho_ev/sigma_e)*sigma_nu  /* sigma_nu0 = s.d. of the part of the selection error that is uncorrelated with the investment eqn's error term */
gen sigma_nu0 = 0
replace sigma_nu0 = sqrt((sigma_nu)^2-(rho^2)*(sigma_e^2)) if ((sigma_nu)^2-(rho^2)*(sigma_e^2)>0)
/* create t_vectors which are used to calculate bs-se's from bs_coeffs */
/* investment equation */
local i = 1
while `i' < 25 {
gen t_`i' = m1_400`i'
local i = `i'+1
}

/* create nonparametric confidence intervals 0.5% two-tailed */
centile t_* rho_ev sigma_e sigma_nu rho sigma_nu0, centile(0.5 99.5)
/* create nonparametric confidence intervals 2.5% two-tailed */
centile t_* rho_ev sigma_e sigma_nu rho sigma_nu0, centile(2.5 97.5)
/* create nonparametric confidence intervals 5% two-tailed */
centile t_* rho_ev sigma_e sigma_nu rho sigma_nu0, centile(5 95)
/* create nonparametric confidence intervals 6.25% two-tailed */
centile t_* rho_ev sigma_e sigma_nu rho sigma_nu0, centile(6.25 93.75)
/* create nonparametric confidence intervals 7.5% two-tailed */
centile t_* rho_ev sigma_e sigma_nu rho sigma_nu0, centile(7.5 92.5)

/* create the bs_se's */
collapse (sd) t_* rho* sigma_*/* extract only the se's (=sd's of estimated bootstrapped coeff's) */

/* generate coefficient estimates: c_est is the actual coeffient vector: NOTE: ML estimation was used */
svmat c_est
/* these are the same as above, this time for the actual coefficients */
gen crh_ev = (exp(2*c_est55)-1)/(exp(2*c_est55)+1)
gen csig_e = exp(c_est56)
gen csig_nu = 1/abs(c_est53)
gen crh = (crh_ev/csig_e)*csig_nu
gen csig_nu0 = 0
replace csig_nu0 = sqrt((csig_nu)^2-(crh^2)*(csig_e^2)) if ((csig_nu)^2-(crh^2)*(csig_e^2)>0)
/* create investment equation coefficients */
local i = 1
while `i' < 25 {
gen cb_`i' = c_est`i'
local i = `i'+1
}

/* reporting of 1) coeffs 2) bs-se's for the investment equation */
sum cb_* crh_ev csig* crh
sum t_* rho_ev sigma_* rho
 
