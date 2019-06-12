	gen prob0=1/(1+exp(-x_betahat0))
    gen prob1=1/(1+exp(-x_betahat1))
    gen diff=prob1-prob0
    egen probhat0=mean(prob0)
    egen probhat1=mean(prob1)
    egen diffhat=mean(diff)
    tempname ME SET SIM prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi
    scalar `ME' = marginaleffect
    scalar `SET' = setvalue
    scalar `SIM' = simulation 
	*_pctile prob0, p(5,95)
    _pctile prob0, p(2.5,97.5)
    scalar `lo0' = r(r1)
    scalar `hi0' = r(r2)  
	*_pctile prob1, p(5,95)
    _pctile prob1, p(2.5,97.5)
    scalar `lo1'= r(r1)
    scalar `hi1'= r(r2) 
	*_pctile diff, p(5,95)
    _pctile diff, p(2.5,97.5)
    scalar `diff_lo'= r(r1)
    scalar `diff_hi'= r(r2) 
    scalar `prob_hat0'=probhat0
    scalar `prob_hat1'=probhat1
    scalar `diff_hat'=diffhat   
    post mypost (`ME') (`SET') (`SIM') (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') (`diff_hat') (`diff_lo') (`diff_hi') 
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat
