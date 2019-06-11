cd "O:\Fixed vs Random\LATEST\for PSRM\sims"

forvalues i=1/8 {

use simulations`i', clear
collapse(mean) MBias* RMSE* opt*, by(N n Contextual L2corX5 L2Var L1Var)
save simscollapsed`i', replace
}

use simscollapsed1, clear
append using simscollapsed2 simscollapsed3 simscollapsed4 simscollapsed5 ///
simscollapsed6 simscollapsed7 simscollapsed8

save simscollapsedALL, replace

forvalues i=1/8 {

use simulations`i'unb, clear
collapse(mean) MBias* RMSE* opt*, by(N n Contextual L2corX5 L2Var L1Var)
save simsunbcollapsed`i', replace
}

use simsunbcollapsed1, clear
append using simsunbcollapsed2 simsunbcollapsed3 simsunbcollapsed4 ///
simsunbcollapsed5 simsunbcollapsed6 simsunbcollapsed7 simsunbcollapsed8

save simscollapsedunbALL, replace

append using simscollapsedALL, generate(balanced)

save simscollapsedALLall, replace

sum RMSE* if N==30 & n==20 & balanced==1 & Contextual==1
sum MBias* if N==30 & n==20 & balanced==1 & Contextual==1
sum opt* if N==30 & n==20 & balanced==1 & Contextual==1

sum RMSE* if N==30 & n==20 & balanced==0 & Contextual==1
sum MBias* if N==30 & n==20 & balanced==0 & Contextual==1
sum opt* if N==30 & n==20 & balanced==0 & Contextual==1
