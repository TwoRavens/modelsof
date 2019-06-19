*stata do-file to calculate pseudo r-squares for flogit regressions, and add them to the stored estimates

predict cross_prob_hat if e(sample)
cor cross_prob cross_prob_hat
scalar rhox=r(rho)
estadd scalar r2=rhox^2
drop cross_prob_hat
