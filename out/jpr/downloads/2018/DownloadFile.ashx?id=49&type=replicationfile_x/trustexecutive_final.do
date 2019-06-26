******Trust in the executive: Requiring consensus and turn-taking in the experimental lab
******Thomas Clark Durant, Michael Weintraub, Daniel Houser, and Shuwen Li
******Journal of Peace Research


**Table III


mat T = J(6,4,.)

ttest value if DV==0, by(consensus) 
mat T[1,1] = r(mu_1)
mat T[1,2] = r(mu_2)
mat T[1,3] = r(mu_1) - r(mu_2)
mat T[1,4] = r(p)


ttest value if DV==0, by(rolereversal) unequal
mat T[2,1] = r(mu_1)
mat T[2,2] = r(mu_2)
mat T[2,3] = r(mu_1) - r(mu_2)
mat T[2,4] = r(p)
*t-test for unequal variance is used given that sample sizes and variance differ between groups. 

ttest value if DV==2, by(consensus)  
mat T[3,1] = r(mu_1)
mat T[3,2] = r(mu_2)
mat T[3,3] = r(mu_1) - r(mu_2)
mat T[3,4] = r(p)

ttest value if DV==2, by(rolereversal) unequal
mat T[4,1] = r(mu_1)
mat T[4,2] = r(mu_2)
mat T[4,3] = r(mu_1) - r(mu_2)
mat T[4,4] = r(p)
*t-test for unequal variance is used given that sample sizes and variance differ between groups. 

ttest value if DV==1, by(consensus) 
mat T[5,1] = r(mu_1)
mat T[5,2] = r(mu_2)
mat T[5,3] = r(mu_1) - r(mu_2)
mat T[5,4] = r(p)

ttest value if DV==1, by(rolereversal) unequal
mat T[6,1] = r(mu_1)
mat T[6,2] = r(mu_2)
mat T[6,3] = r(mu_1) - r(mu_2)
mat T[6,4] = r(p)
*t-test for unequal variance is used given that sample sizes and variance differ between groups. 

mat rownames T = H1a H1b H2a H2b H3a H3b

frmttable using ttest.doc, statmat(T) varlabels replace ///
	ctitle("", "Institution A Mean", "Institution B Mean", Difference, "p-value")
