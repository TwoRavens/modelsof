use "LeedsAnacIIrep.dta", clear

**Results reported in Table 4 and 5
logit honor3 milinst formal chcap2d dinstch2 origtar1

**actual vs. predicted values
predict prhona
gen prhonad=0
recode prhonad 0=1 if prhona>.5
tab honor3 prhonad

**substantive effects with clarify
estsimp logit honor3 milinst formal chcap2d dinstch2 origtar1
setx mean
simqi, fd(pr) changex(milinst min max)
simqi, fd(pr) changex(formal min max)
simqi, fd(pr) changex(chcap2d min max)
simqi, fd(pr) changex(dinstch2 min max)
simqi, fd(pr) changex(origtar1 min max)
drop b1 b2 b3 b4 b5 b6

*Fnote 12 (Recode those alliances in which some members honor and some violate in other ways)
logit honor2 milinst formal chcap2d dinstch2 origtar1

*Fnote 14 (Aggregate capabilities)
logit honor3 milinst formal chalcapd dinstch2 origtar1

*Fnote 15 (20% threshold on capability change)
logit honor3 milinst formal chcp2d20 dinstch2 origtar1

*Fnote 16 (Regime change)
tab regch2 honor3

*Fnote 20 (Non-wartime only)
logit honor3 milinst formal chcap2d dinstch2 origtar1 if wartime==0

*Fnote 20 (Active assistance only)
logit honor3 milinst formal chcap2d dinstch2 origtar1 if active==1

*Fnote 20 (Control for bilateral/multilateral)
logit honor3 milinst formal chcap2d dinstch2 origtar1 bilat
