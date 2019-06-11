
use AEJApp20070006gamedata.dta, clear

*Table 5 - All okay

reg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice if (round<=6), robust cluster(uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & game_type!=19 & game_type!=20), fe i(uid) vce(cluster uid)
reg risky jlgame monitor talking ptnrchoice if (round<=6 & dynamic==0), robust cluster(uid)
xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (round<=6 & dynamic==0), fe i(uid) vce(cluster uid)
reg risky jlgame monitor talking ptnrchoice if (round<=6 & dynamic==1), robust cluster(uid)
xtreg risky jlgame monitor talking ptnrchoice round1 round3-round6 if (round<=6 & dynamic==1), fe i(uid) vce(cluster uid)

*Table 6 - All okay

reg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice if (round<=6), robust cluster(uid)
xtreg repay dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6), fe i(uid) vce(cluster uid)
reg repay jlgame monitor talking ptnrchoice if (round<=6 & dynamic==0), robust cluster(uid)
xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (round<=6 & dynamic==0), fe i(uid) vce(cluster uid)
reg repay jlgame monitor talking ptnrchoice if (round<=6 & dynamic==1), robust cluster(uid)
xtreg repay jlgame monitor talking ptnrchoice round1 round3-round6 if (round<=6 & dynamic==1), fe i(uid) vce(cluster uid)

*Table 7 - All okay

xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6), fe i(uid) vce(cluster uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & female==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & younger==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & older==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & secondary==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & gss2pos==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic jlgame monitor talking ptnrchoice Djlgame Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & saves_bank==1), fe i(uid) vce(cluster uid)

*Table 8 - problems - cols 3, 5, & 6 completely off - have to switch around uid 131 for columns 5 & 6

xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 &jlgame==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (round<=6 &jlgame==1 ), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice Bsafewithrisky Briskywithsafe round1 round3-round6 if (round<=6 &jlgame==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 &jlgame==1 & theta1==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 &jlgame==1 & theta1==0 & theta3==0 ), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 &jlgame==1 & theta3==1), fe i(uid) vce(cluster uid)

*Corrections - unable to find a specification that matches column 3

replace theta3 = 0 if uid == 131

xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 &jlgame==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice safewithrisky riskywithsafe round1 round3-round6 if (round<=6 &jlgame==1 ), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & jlgame==1 & theta1==1), fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & jlgame==1 & theta1==0 & theta3==0) , fe i(uid) vce(cluster uid)
xtreg risky dynamic monitor talking ptnrchoice Dmonitor Dtalking Dptnrchoice round1 round3-round6 if (round<=6 & jlgame==1 & theta3==1), fe i(uid) vce(cluster uid)


*Table 9 - All okay

mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==0), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==1), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==0 & theta1pair==1), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==1  & theta1pair==1), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==0 & mixedpair==1), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==1  & mixedpair==1), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==0 & riskypair==1), baseoutcome(0) cluster(pairid)
mlogit pairoutcome monitor talking ptnrchoice days_played round1 round3-round6 if (round<=6 & jlgame==1 & dynamic==1  & riskypair==1), baseoutcome(0) cluster(pairid)

keep if round <= 6

save DatGJKM, replace

