

** Replication File for manuscript PSRM-OA-2016-0059 van Gruisen, P., Vangerven, P. and Crombez, C. 2016: 'Voting Behavior in the Council of the European Union: The Effect of the Trio Presidency'
** Analysis conducted in STATA 13.

* Note: the variable 'extra' refers to additional data to test the lagged effect of the Trio Presidency and is only employed for Footnote 19. Accordingly it equals 0 in all other models tested. 


********************************
*****************************
**			
**				Table 1
**
*****************************
********************************

* Model A
probit Yes TrioPresidency if extra==0, vce(cluster Text_adopted)
* Model B
probit Yes Presidency TrioPresidency if extra==0, vce(cluster Text_adopted)
* Model C
probit Yes Presidency TrioSemester1 TrioSemester2 TrioSemester3 if extra==0, vce(cluster Text_adopted)
* Model D
probit Yes Presidency TrioSemester1 TrioSemester2 TrioSemester3 Newmember size_1 size_2 EU_support Receiver if extra==0, vce(cluster Text_adopted)
* Model E
probit Yes Presidency TrioSemester1 TrioSemester2 TrioSemester3 i.countrycode if extra==0, vce(cluster Text_adopted)


******************************************
*************************************
**
**				Figure 1 
**							
*************************************
******************************************

probit Yes i.TrioTime Newmember size_1 size_2 EU_support Receiver if extra==0, vce(cluster Text_adopted)
margins, at (TrioTime=(0 1 2 3)) atmeans
marginsplot, recast(line) recastci(rarea)


*****************************************
************************************
**
**			Table 2
**
************************************
*****************************************

codebook VoteChoice
oprobit VoteChoice Presidency TrioPresidency Newmember size_1 size_2 EU_support Receiver if extra==0, vce(cluster Text_adopted)
describe VoteChoice
tabulate VoteChoice
mfx, predict (outcome(0))
mfx, predict (outcome(1))
mfx, predict (outcome(2))


****************************************
**********************************
**
**			Table A1
**
**********************************
****************************************

sum Yes Presidency TrioPresidency TrioSemester1 TrioSemester2 TrioSemester3 Newmember size_1 size_2 EU_support Receiver if extra==0


****************************************
***********************************
**
**			Table A2
**
***********************************
****************************************

corr Presidency TrioPresidency TrioSemester1 TrioSemester2 TrioSemester3 Newmember size_1 size_2 EU_support Receiver if extra==0


****************************************
***********************************
**
**			Table A3
**
***********************************
****************************************

* Model A.
probit Yes TrioFakeSix FormTrioSix Presidency if extra==0
* Model B.
probit Yes TrioFakeTwelve FormTrioTwelve Presidency if extra==0


***********************************
*****************************
**
**			Footnote 19
**
*****************************
***********************************

probit Yes Presidency i.TrioTimeLagged, vce(cluster Text_adopted)

