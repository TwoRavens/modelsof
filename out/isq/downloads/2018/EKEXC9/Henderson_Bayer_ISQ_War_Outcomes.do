*Estimations for Henderson and Bayer - Wallets, Ballots, or Bullets: Does Wealth, Democracy, or Military Capabilities Determine War Outcomes? International Studies Quarterly 2013

*Tables 7,8, 10, and 11
*Probit Models

use "Henderson_Bayer_ISQ_War_Outcomes_Probit"

*Table 7
probit wdl polini poltarg init concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4, robust
probit wdl polini poltarg init capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 morerev , robust
probit wdl polini poltarg init concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 morerev, robust
probit wdl polini poltarg init capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 relgdp1 , robust
probit wdl polini poltarg init concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 relgdp1, robust

*Table 8 
probit wdl politics init concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4, robust
probit wdl politics init capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 morerev, robust
probit wdl politics init concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 morerev, robust
probit wdl politics init capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 relgdp1 , robust
probit wdl politics init concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 relgdp1 , robust

*Table 10 
probit wdl bdemoc west bdemocwest init  concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4, robust
probit wdl bdemoc west bdemocwest init  relgdp1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4, robust
probit wdl bdemoc nonwst bdemocnonwst init relgdp1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 , robust
probit wdl bdemoc nonwst bdemocnonwst init  concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 , robust
 
*Table 11
probit wdl bdemoc westwithisr bdemocwestwithisr init  concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 , robust
probit wdl bdemoc westwithisr bdemocwestwithisr  init  relgdp1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 , robust
probit wdl bdemoc nonwst  bdemocnonwstnoisr init  concap1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 , robust
probit wdl bdemoc nonwestnoisr  bdemocnonwstnoisr init relgdp1 capasst1 qualrat1 terrain straterr  strat1 strat2 strat3 strat4 , robust


*Table 9
*Hazard Models
use "Henderson_Bayer_ISQ_War_Outcomes_Hazard"

streg bofadj oadm oada oadp opda Rterrain  Rterrstr   summper1 sumpop1 popratio qualrat surpdiff salscale reprsum demosum adis3010 nactors , dist(weibull) nohr time robust
streg adjboe oadm oada oadp opda Rterrain  Rterrstr   summper1 sumpop1 popratio qualrat surpdiff salscale reprsum demosum adis3010 nactors, dist(weibull) nohr time robust
streg bofadj adjboe oadm oada oadp opda Rterrain  Rterrstr   summper1 sumpop1 popratio qualrat surpdiff salscale reprsum demosum adis3010 nactors, dist(weibull) nohr time robust
