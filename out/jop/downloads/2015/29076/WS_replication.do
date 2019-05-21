**commands to replication Models 1-6 (Table 1) in Wood and Sullivan (2015) "Doing Harm by Doing Good? Humanitarian Aid and Civilian Victimization during Civil Conflict", Journal of Politics 

use "/ [insert local path] JOPreplicationFiles/WS_jopdata.dta"

tsset gid year

**Model 1 (rebel OSV, RE NBR model)
xtnbreg rebel_osv_events c.laglnhumanaid gov_osv_events gov_osv_neighwtd rebel_osv_neighwtd nsagov_battle_events nsagov_battle_neighwtd lngcppc lnpop lnbd lncap rebel_c lagrebel_osv_events if conflictyear_2==1, nolog

**Model 2 (rebel OSV, FE NBR model)
xtnbreg rebel_osv_events c.laglnhumanaid gov_osv_events gov_osv_neighwtd rebel_osv_neighwtd nsagov_battle_events nsagov_battle_neighwtd lngcppc lnpop rebel_c if conflictyear_2==1, nolog fe

**Model 1 (gov OSV, RE NBR model)
xtnbreg gov_osv_events c.laglnhumanaid rebel_osv_events gov_osv_neighwtd rebel_osv_neighwtd nsagov_battle_events nsagov_battle_neighwtd lngcppc lnpop lnbd lncap rebel_c laggov_osv_events if conflictyear_2==1, nolog

**Model 2 (gov OSV, FE NBR model)
xtnbreg gov_osv_events c.laglnhumanaid rebel_osv_events gov_osv_neighwtd rebel_osv_neighwtd nsagov_battle_events nsagov_battle_neighwtd lngcppc lnpop rebel_c if conflictyear_2==1, nolog fe


**Commands for DiD model. Must switched to matched sample dataset***

use "/ [insert local path] JOPreplicationFiles/WS_jopdata_matchedDiD.dta"

**Model 5 (rebel osv)

gen id=1

gen cell=0

replace cell=1 in 1

replace id=id[_n-1]+1 if cell==0

expand 2

sort id

gen minus1=0

replace minus1=1 if id==id[_n-1]

gen plus1=0

replace plus1=1 if minus1==0

gen rebelosv=0

replace rebelosv=plus1reb_osv_events if plus1==1

replace rebelosv=lagrebel_osv_events if minus1==1

gen TT=0

replace TT=treat*plus1

nbreg rebelosv TT treat plus1, cluster(id)

clear 

**Model 5 (gov osv)

**Note: must reload matched data before proceeding

use "/ [insert local path] JOPreplicationFiles/WS_jopdata_matchedDiD.dta"


gen id=1

gen cell=0

replace cell=1 in 1

replace id=id[_n-1]+1 if cell==0

expand 2

sort id

gen minus1=0

replace minus1=1 if id==id[_n-1]

gen plus1=0

replace plus1=1 if minus1==0

gen govosv=0

replace govosv=plus1gov_osv_events if plus1==1

replace govosv=laggov_osv_events if minus1==1

gen TT=0

replace TT=treat*plus1

nbreg govosv TT treat plus1, cluster(id)


