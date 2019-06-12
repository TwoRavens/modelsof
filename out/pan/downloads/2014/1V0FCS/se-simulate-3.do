 * se-simulate-3.do --- 
 * 
 * Filename: se-simulate-3.do
 * Author: Arzheimer & Evans
 * 
 *

 * Commentary: 
 * Simulate distribution of A'_1 etc. based on beta/V from multinomial model
 * For 18 three-party system scenarios
 * 
 *

 * Change log:
 * 
 * 
 *


clear all
set obs 50000

set seed 123456789

* Matrix containing party system
matrix v = J(18,3,0)

forvalues p = 1/9 {
	matrix v[`p',1] = (0.4,0.4,0.2)
	}

forvalues p = 10/18 {
	matrix v[`p',1] = (0.5,0.25,0.25)
	}


* Counters
local zfield "betaeins betazwei betadrei"

matrix scbetavmatrix = (-1.450e-15 , -.69314718 , .005 , .0025 , .0075 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.16519631 , -.85566611 , .00495369 , .00227273 , .00762032 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.40646561 , -1.0966143 , .005003 , .002 , .00798802 ) 
matrix scbetavmatrix = scbetavmatrix \ (.17067998 , -.52481187 , .0051197 , .00277778 , .00747261 ) 
matrix scbetavmatrix = scbetavmatrix \ (.44254678 , -.25274402 , .00547466 , .00333333 , .00762518 ) 
matrix scbetavmatrix = scbetavmatrix \ (4.956e-15 , -.57251919 , .00512821 , .0025641 , .00710956 ) 
matrix scbetavmatrix = scbetavmatrix \ (0 , -.40546511 , .00533333 , .00266667 , .00666667 ) 
matrix scbetavmatrix = scbetavmatrix \ (2.963e-15 , -.82320031 , .00487805 , .00243902 , .00799458 ) 
matrix scbetavmatrix = scbetavmatrix \ (-9.764e-15 , -1.0414539 , .00470588 , .00235294 , .00901961 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.69314718 , -.69314718 , .006 , .002 , .006 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.89381788 , -.89381788 , .00626263 , .00181818 , .00626263 ) 
matrix scbetavmatrix = scbetavmatrix \ (-1.2013097 , -1.206643 , .00691915 , .0016 , .00694759 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.49247649 , -.49247649 , .00585859 , .00222222 , .00585859 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.18072284 , -.18392284 , .00586155 , .00266667 , .00587179 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.69107893 , -.56324556 , .00620262 , .00207039 , .00570676 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.69314718 , -.38066599 , .00655022 , .00218341 , .00537829 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.69508329 , -.83194247 , .0058102 , .00193424 , .00637868 ) 
matrix scbetavmatrix = scbetavmatrix \ (-.69314718 , -1.0641574 , .00553506 , .00184502 , .00719261 ) 


* Generate betas

forvalues s = 1/18 {
	matrix means = scbetavmatrix[`s',1..2]
	matrix cov = scbetavmatrix[`s',3..5]
	corr2data betazwei_`s' betadrei_`s' ,means(means) cov(cov) cstorage(lower)

* Generate constant
	gen byte betaeins_`s' = 0
	
* Calculate A's
	forvalues z = 1/3 {
		local zaehler : word `z' of `zfield'
* Multiplier
		local faktor = (1- v[`s',`z']) / v[`s',`z']
* Denominator
		local denominator "1 + exp(betazwei_`s') + exp(betadrei_`s')"
		local innerfraction "exp(`zaehler'_`s') / (`denominator')"
* Do the math
		gen aprime_`z'_`s' = ln(`innerfraction' / (1 - `innerfraction') * `faktor')
		}
* Calculate B
	gen b_`s' = (abs(aprime_1_`s') + abs(aprime_2_`s') + abs(aprime_3_`s')) / 3
* Calculate B_w 
	gen bw_`s' = (abs(aprime_1_`s'*v[`s',1]) + abs(aprime_2_`s'*v[`s',2]) + abs(aprime_3_`s'*v[`s',3])) 
	}

drop b*
save party3simulations,replace



* se-simulate-3.do ends here
