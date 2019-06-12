version 11.2

set more off



*********************************************************************************
*********************************************************************************
*   																			*
*  Replicate Table 3 in Conrad, Conrad and Young (2013)                         *
*   Data file:  ConradConradYoung ISQ13 Data.dta                                *
*  											                                    *
*                                                                               *
*********************************************************************************
*********************************************************************************


nbreg ITERATE single1w military1w dynastic1w other1w personal1w  nondynastic1w interregnaw interregnademw hybrid1w rgdpllog  poplog historyITERATE conflict frac_eth frac_rel Europe Asia America Africa, robust 


preserve

set seed 10101

drawnorm JC_b1-JC_b21, n(1000) means(e(b)) cov(e(V)) clear
save simulated_betas, replace
restore

 merge using simulated_betas

drop _merge


scalar h_v1 = 0
scalar h_v2 = 0
scalar h_v3 = 0
scalar h_v4 = 0
scalar h_v5 = 0
scalar h_v6 = 0
scalar h_v7 = 0
scalar h_v8 = 0
scalar h_v9 = 0
scalar h_v10 = 8.33444
scalar h_v11 = 15.69992
scalar h_v12 = 2.312751
scalar h_v13 = 0
scalar h_v14 = 0.4387381
scalar h_v15 = 0.4376383
scalar h_v16 = 0
scalar h_v17 = 0
scalar h_v18 = 0
scalar h_v19 = 0
scalar h_con = 1


******DEMOCRACY******
generate x_betahat1 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_v9+JC_b10*h_v10+JC_b11*h_v11+JC_b12*h_v12+JC_b13*h_v13+JC_b14*h_v14+JC_b15*h_v15+JC_b16*h_v16+JC_b17*h_v17+JC_b18*h_v18+JC_b19*h_v19+JC_b20*h_con

generate prob_hat1 = exp(x_betahat1)

sum prob_hat1

centile prob_hat1, centile(2.5 97.5)


*******PERSONALIST*****                                                      
scalar h_v5 = 1

generate x_betahat2 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_v9+JC_b10*h_v10+JC_b11*h_v11+JC_b12*h_v12+JC_b13*h_v13+JC_b14*h_v14+JC_b15*h_v15+JC_b16*h_v16+JC_b17*h_v17+JC_b18*h_v18+JC_b19*h_v19+JC_b20*h_con

generate prob_hat2 = exp(x_betahat2)

sum prob_hat2

centile prob_hat2, centile(2.5 97.5)

generate diffd = prob_hat2- prob_hat1

sum prob_hat1 prob_hat2 diffd

centile prob_hat1 prob_hat2 diffd, centile(2.5 97.5)

drop x_betahat2 prob_hat2 diffd

*******NON-DYNASTIC MONARCHY*****                                                      
scalar h_v5 = 0
scalar h_v6 = 1

generate x_betahat2 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_v9+JC_b10*h_v10+JC_b11*h_v11+JC_b12*h_v12+JC_b13*h_v13+JC_b14*h_v14+JC_b15*h_v15+JC_b16*h_v16+JC_b17*h_v17+JC_b18*h_v18+JC_b19*h_v19+JC_b20*h_con

generate prob_hat2 = exp(x_betahat2)

sum prob_hat2

centile prob_hat2, centile(2.5 97.5)

generate diffd = prob_hat2- prob_hat1

sum prob_hat1 prob_hat2 diffd

centile prob_hat1 prob_hat2 diffd, centile(2.5 97.5)

drop x_betahat2 prob_hat2 diffd


*******TRANSITIONAL 1*****                                                      
scalar h_v6 = 0
scalar h_v7 = 1

generate x_betahat2 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_v9+JC_b10*h_v10+JC_b11*h_v11+JC_b12*h_v12+JC_b13*h_v13+JC_b14*h_v14+JC_b15*h_v15+JC_b16*h_v16+JC_b17*h_v17+JC_b18*h_v18+JC_b19*h_v19+JC_b20*h_con

generate prob_hat2 = exp(x_betahat2)

sum prob_hat2

centile prob_hat2, centile(2.5 97.5)

generate diffd = prob_hat2- prob_hat1

sum prob_hat1 prob_hat2 diffd

centile prob_hat1 prob_hat2 diffd, centile(2.5 97.5)

drop x_betahat2 prob_hat2 diffd


*******TRANSITIONAL 2*****                                                      
scalar h_v7 = 0
scalar h_v8 = 1

generate x_betahat2 = JC_b1*h_v1+JC_b2*h_v2+JC_b3*h_v3+JC_b4*h_v4+JC_b5*h_v5+JC_b6*h_v6+JC_b7*h_v7+JC_b8*h_v8+JC_b9*h_v9+JC_b10*h_v10+JC_b11*h_v11+JC_b12*h_v12+JC_b13*h_v13+JC_b14*h_v14+JC_b15*h_v15+JC_b16*h_v16+JC_b17*h_v17+JC_b18*h_v18+JC_b19*h_v19+JC_b20*h_con

generate prob_hat2 = exp(x_betahat2)

sum prob_hat2

centile prob_hat2, centile(2.5 97.5)

generate diffd = prob_hat2- prob_hat1

sum prob_hat1 prob_hat2 diffd

centile prob_hat1 prob_hat2 diffd, centile(2.5 97.5)

drop x_betahat1 prob_hat1 x_betahat2 prob_hat2 diffd

 

exit
