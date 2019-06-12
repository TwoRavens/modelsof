*******************************
*Does Choice Bring Loyalty?   *
*Replication File, Elias Dinas*
*******************************


clear all
set more off

use ANES_Replication_File.dta


gen pid=VCF0301 
replace pid=. if VCF0301==0 | VCF0301>7

gen year=VCF0004
gen age=VCF0101


gen eligible=.
replace eligible=0 if (VCF0101==21 | VCF0101==20) & year>1972
replace eligible=1 if (VCF0101==22 | VCF0101==23) & year>1972
replace eligible=0 if (VCF0101==24 | VCF0101==23) & year<1972
replace eligible=1 if (VCF0101==25 | VCF0101==26) & year<1972


gen eligplacebo=.
replace eligplacebo=0 if (age==22 | age==23) & year>1972
replace eligplacebo=1 if (age==24 | age==25) & year>1972
replace eligplacebo=0 if (age==25 | age==26) & year<1972
replace eligplacebo=1 if (age==27 | age==28) & year<1972


gen voterep=0
replace voterep=1 if VCF0704a==2
replace voterep=. if VCF0704a==. |  VCF0706==3 | VCF0706==4


gen votedem=0
replace votedem=1 if VCF0704a==1
replace votedem=. if VCF0704a==. |  VCF0706==3 | VCF0706==4

gen repel=eligible*voterep
gen demel=eligible*votedem


gen repelplacebo=eligplacebo*voterep
gen demelplacebo=eligplacebo*votedem



gen male=0
replace male=1 if VCF0104==1
replace male=. if VCF0104==0



gen union=0
replace union=1 if  VCF0127==1



gen houseown=0
replace houseown=1 if VCF0146==1




gen white=0
replace white=1 if VCF0106==1
replace white=. if VCF0106==0 | VCF0106>3



gen black=0
replace black=1 if VCF0106==2
replace black=. if VCF0106==0 | VCF0106>3

gen other=0
replace other=1 if VCF0106==3
replace other=. if VCF0106==0 | VCF0106>3


gen pryear=0
replace pryear=1 if year==1952 | year==1956 | year==1960 | year==1964 | year==1968 | year==1972 | year==1976 | year==1980/*
*/ | year==1984 | year==1988 | year==1992 | year==1996  | year==2000 | year==2004





***********
*Table A.6*
***********

reg pid eligible votedem voterep repel demel i.year /*
*/ male black other union houseown i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111, cluster(VCF0901)

bootstrap diff=(_b[eligible]+_b[demel]),/*
*/ rep(100) cluster( VCF0901):reg pid eligible votedem voterep repel demel i.year /*
*/ male black other union houseown i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111

bootstrap diff=(_b[eligible]+_b[repel]),/*
*/ rep(100) cluster( VCF0901):reg pid eligible votedem voterep repel demel i.year /*
*/ male black other union houseown i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111


reg pid eligplacebo votedem voterep repelplacebo demelplacebo i.year /*
*/ male black other union houseown i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111, cluster(VCF0901)


bootstrap diff=(_b[eligplacebo]+_b[demelplacebo]),/*
*/ rep(100) cluster( VCF0901):reg pid eligplacebo votedem voterep repelplacebo demelplacebo i.year /*
*/ male black other union houseown i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111

bootstrap diff=(_b[eligplacebo]+_b[repelplacebo]),/*
*/ rep(100) cluster( VCF0901):reg pid eligplacebo votedem voterep repelplacebo demelplacebo i.year /*
*/ male black other union houseown i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111



***********
*Table A.7*
***********


reg polinf eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)
reg media eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)
reg intel eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)
reg intpol eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg discuss eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)
reg daily eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg effic eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)
reg know_maj_before eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)
reg know_maj_after eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg house_maj eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)***********
*Table A.8*
***********
reg polinf eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg media eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg intel eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg intpol eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg discuss eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg daily eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg effic eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg know_maj_before eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg know_maj_after eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)reg house_maj eligplacebo i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==1,cluster(VCF0901)***********
*Table A.9*
***********
reg polinf eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg media eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg intel eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg intpol eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg discuss eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg daily eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg effic eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg know_maj_before eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg know_maj_after eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)reg house_maj eligible i.year male houseown black other i.VCF0140 i.VCF0148a i.VCF0115 i.VCF0113 i.VCF0111 union /**/  if pryear==0,cluster(VCF0901)