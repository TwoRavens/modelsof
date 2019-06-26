
*Unraveling the Ties that Bind Multinomial Logit commands for Stata
*Journal of Peace Research 
*Michelle Benson
*mbenson2@buffalo.edu
*University at Buffalo, SUNY

*note that the HOSTLEVD Democ Capratio Geodistance Contiguity Alliance variables were obtained from the latest version of Eugene (Bennett and Stam, 2000).  
*The Peaceyears variable was obtained from Beck, Katz, and Tucker's (1998) BTSCS program.


*Model 1
mlogit  HOSTLEVD DyadEconDissim IntOrderEconDist DyadicSecDissim IntOrderSecDist  Democ Capratio Geodistance Contiguity Alliance Peaceyears, robust cluster(dyadid) rrr
listcoef

*Model 1 without controls
mlogit  HOSTLEVD DyadEconDissim IntOrderEconDist DyadicSecDissim IntOrderSecDist, robust cluster(dyadid) rrr
listcoef


*Model 2
mlogit  HOSTLEVD DyadEconDissim IntOrderEconDist DyadicSecDissim IntOrderSecDist IntOrderTotalDist DyadicTotalDissim TotalDistDissim Democ Capratio Geodistance Contiguity Alliance Peaceyears, robust cluster(dyadid) rrr
listcoef

*Model 2 without controls
mlogit  HOSTLEVD DyadEconDissim IntOrderEconDist DyadicSecDissim IntOrderSecDist IntOrderTotalDist DyadicTotalDissim , robust cluster(dyadid) rrr
listcoef

*Model 3
mlogit  HOSTLEVD DyadEconDissim IntOrderEconDist DyadicSecDissim IntOrderSecDist TotalDistDissim Democ Capratio Geodistance Contiguity Alliance Peaceyears, robust cluster(dyadid) rrr
listcoef

*Model 3 without controls
mlogit  HOSTLEVD DyadEconDissim IntOrderEconDist DyadicSecDissim IntOrderSecDist TotalDistDissim , robust cluster(dyadid) rrr
listcoef
