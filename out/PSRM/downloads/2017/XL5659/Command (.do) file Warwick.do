*Table 2.
*SS1
use "Simulation Set 1r.dta", clear
reg govt_position1 parl_mean1 if lopsided==0,b

*SS2
use "Simulation Set 2r.dta", clear
reg govt_position1 parl_mean1 if lopsided==0,b

*TABLE 3.
*Model 1.
use "Simulation Set 3r.dta", clear
summ onesided absbalance absdistance if lopsided==0
*Model 2.
use "Simulation Set 4r.dta", clear
summ onesided absbalance absdistance if lopsided==0
 *Model 3.
use "Simulation Set 5r.dta", clear
summ onesided absbalance absdistance if lopsided==0
*Model 4.
use "Simulation Set 6r.dta", clear
summ onesided absbalance absdistance if lopsided==0
*Model 5.
use "Simulation Set 7r.dta", clear
summ onesided absbalance absdistance if lopsided==0
*Model 6.
use "Simulation Set 7r.dta", clear
gen neffweight=normalden(neff,3.71,1.21)
summ onesided absbalance absdistance  if lopsided==0  [weight=neffweight]
*TABLE 4.
*SS8.
use "Simulation Set 8r.dta", clear
summ onesided absbalance absdistance  absvaldistance if lopsided==0
reg absbalance beta_valence absvaldistance if lopsided==0,b
reg absdistance beta_valence absvaldistance if lopsided==0,b
*SS9.
use "Simulation Set 9r.dta", clear
summ onesided absbalance absdistance  absvaldistance if lopsided==0
reg absbalance beta_valence absvaldistance if lopsided==0,b
reg absdistance beta_valence absvaldistance if lopsided==0,b
*SS10.
use "Simulation Set 10r.dta", clear
summ onesided absbalance absdistance  absvaldistance if lopsided==0
reg absbalance beta_valence absvaldistance omega if lopsided==0
reg absdistance beta_valence absvaldistance omega if lopsided==0,b
*TABLE 5.
*SS11.
use "Simulation Set 11r.dta", clear
summ onesided absbalance absdistance if lopsided==0
*SS12.
use "Simulation Set 12r.dta", clear
summ onesided absbalance absdistance if lopsided==0
*FIGURES.
*Fig.1.
use "Simulation Set 2r.dta", clear
histogram voter_median if lopsided==0,percent width(.05)  addplot (histogram govt_position1 if lopsided==0,percent width(.05) )
graph save Figure1

*Fig. 2.
use "Simulation Set 2r.dta", clear
histogram balance if lopsided==0, percent addplot (histogram balance if lopsided==0&spg~=1,percent)
graph save Figure2




