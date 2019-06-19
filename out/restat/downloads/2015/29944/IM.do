set more 1
clear
set mem 100m

use C:\Dropbox\mystuff\BehrensFisher\Replication\DalBoFrechette\dal_bo_2010a_data.dta, clear

replace maxround=. if round>1
table session r, c(max clientid mean maxmatch mean maxround) by(delta)
table session r if match==1 & round==1, c(max totalpayoff mean totalpayoff min totalpayoff) by(delta)
table delta r if match==1 & round==1, c(max totalpayoff mean totalpayoff min totalpayoff) scol 
sum totalpayoff if match==1 & round==1
table delta if clientid==1, c(mean maxround) 

* bottom right panel
table delta r, c(mean coop)
probit coop treat_2 if (treat_1==1|treat_2==1), cluster(date)
probit coop treat_4 if (treat_1==1|treat_4==1), cluster(date)
probit coop treat_6 if (treat_1==1|treat_6==1), cluster(date)
probit coop treat_3 if (treat_2==1|treat_3==1), cluster(date)
probit coop treat_5 if (treat_2==1|treat_5==1), cluster(date)
probit coop treat_6 if (treat_3==1|treat_6==1), cluster(date)
probit coop treat_5 if (treat_4==1|treat_5==1), cluster(date)
probit coop treat_6 if (treat_5==1|treat_6==1), cluster(date)

egen group2 = group(date)
sum group2
scalar numgroups = r(max)

matrix betas = (.,.,.,.)
matrix SEs = (.,.,.,.)

forvalues Y = 1/6{
matrix tempbeta = (.)
matrix tempSEs = (.)

forvalues X = 1/`=numgroups'{
sum coop if treat_`Y'==1 & group2 == `X'
scalar yon = r(N)
if yon > 0{
display `Y' `X'
probit coop if treat_`Y'==1 & group2 == `X', cluster(clientiddate)
matrix tempbeta = (tempbeta, _b[_cons])
matrix tempSEs = (tempSEs, _se[_cons])
}
}
matrix betas = (betas \ tempbeta)
matrix SEs = (SEs \ tempSEs)
}

matrix list betas
matrix list SEs



