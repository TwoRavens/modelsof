*****************************************************
*Replication file for "Hafner-Burton, Hyde and Jablonski. 
*Surviving Elections: Election Violence, Incumbent Victory, and Post-Election Repercussions" 
*British Journal of Political Science. Accepted November 2015
*
*Estimates Table A1
*These models were stimated using Stata/SE 13.0
*****************************************************

use BJPSReplicationBarometer12112015, clear


xtset countryid
local controls " gender employed education ma_polity2 uncertain compulsory multipleround labar"
xi:logit vote preelecviolence oppositionsupporter `controls' , 

local controls " gender employed education ma_polity2 uncertain compulsory multipleround labar"
xi:logit vote violenceXopp preelecviolence oppositionsupporter  `controls', 

local controls " gender employed education ma_polity2 uncertain compulsory multipleround"
xi:logit vote violenceXopp preelecviolence oppositionsupporter  `controls' if labar==1 , 

local controls "electric withoutfood gender education respondant_age employed hoh ma_polity2 uncertain compulsory multipleround "
xi:logit vote violenceXopp preelecviolence oppositionsupporter `controls' if labar==0 , 
