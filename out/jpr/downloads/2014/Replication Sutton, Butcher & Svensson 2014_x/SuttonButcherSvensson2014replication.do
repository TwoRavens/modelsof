
**** Replication File, Sutton, Butcher and Svensson 2014 - "Explaining Political Jiu-Jitsu: Institution-Building and the Outcomes of Regime Violence Against Unarmed Protests"
**** Journal of Peace Research
**** Replication file as of 21 August 2014

**** TABLE 1 REPLICATION SVUP DATA
 * use "/INSERT DIRECTORY HERE/SuttonButcherSvenssonSVUPDatafinal.dta"

set more off
logit domjjsvup terr reform campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2 
est store M1
logit intjj terr reform campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2
est store M2

logit dommobjj terr reform campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2
est store M3
logit securitydefections campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2 
est store M4

*** Jujitsu and Success

logit success  terr reform conflict1 conflict2 dommobjj securitydefections intjj severe lnpop lnrgdpch polity2

est table M1 M2 M3 M4 , b(%8.3f)  star (.1 .05 .01)

**** internet and mobiles
logit domjjsvup terr reform campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2 internet mobiles
est store M1
logit intjj terr reform campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2 internet mobiles
est store M2

**** Marginal Effects - Campaigns and Domestic Mobilization

set seed 12345
estsimp logit domjjsvup terr reform campaignsvup conflict1 conflict2 severe lnpop lnrgdpch polity2  
setx mean 
setx campaignsvup 0
simqi, pr

setx campaignsvup 1
simqi, pr

drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10



***** TABLE 2 REPLICATION NAVCO 2.0 ANALYSIS
 * use "/INSERT DIRECTORY HERE/SuttonButcherSvenssonNAVCODatafinal.dta"

set more off
logit domjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=3 
est store M1 
logit intjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst  if prim_method==1 & repression>=3
est store M2 

logit dommobjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=3 
est store M3
logit domsecjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=3 
est store M4

est table M1 M2 M3 M4, b(%8.3f)  star (.1 .05 .01)

**** Dissagregating the Pi media variable
logit domjj terrgoals antiocc radflank lnpop lnrgdpch polity2 pi_tradmedia pi_newmedia if prim_method==1 & repression>=3 
est store M1 
logit intjj terrgoals antiocc radflank lnpop lnrgdpch polity2 pi_tradmedia pi_newmedia if prim_method==1 & repression>=3
est store M2 

**** without the economic and political controls
logit domjj terrgoals antiocc radflank mediainst if prim_method==1 & repression>=3 

logit intjj terrgoals antiocc radflank polity2 mediainst if prim_method==1 & repression>=3


**** re-testing with a lower repression threshold

logit domjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=2 
est store M1 
logit intjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst  if prim_method==1 & repression>=2
est store M2 

logit dommobjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=2 
est store M3
logit domsecjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=2 
est store M4

**** Jujitsu and success
 
logit successjj terrgoals antiocc radflank lnpop lnrgdpch polity2 polity2sq intjj domsecjj dommobjj mediainst if prim_method==1 & repression>=3 



**** Marginal Effects Media Institutions and Domestic and International Backfire.

set seed 12345
estsimp logit domjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst if prim_method==1 & repression>=3
setx mean 
setx mediainst 0
simqi, pr

setx mediainst 1
simqi, pr

drop b1 b2 b3 b4 b5 b6 b7 b8
set seed 12345
estsimp logit intjj terrgoals antiocc radflank lnpop lnrgdpch polity2 mediainst  if prim_method==1 & repression>=3
setx mean 
setx mediainst 0
simqi, pr

setx mediainst 1
simqi, pr

drop b1 b2 b3 b4 b5 b6 b7 b8

