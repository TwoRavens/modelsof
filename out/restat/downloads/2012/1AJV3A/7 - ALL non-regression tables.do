/*Open log file, set memory, etc*/
clear all 
set mem 150m
set matsize 150
version 9
global datapath "C:\Users\Michael McMahon\Dropbox\GSOEP21"
cd "$datapath\GiavazziMcMahonReStat"

use final.dta, replace

*BASELINE SAVING RESULTS

drop if age>68
drop if age<24

bysort new_hhnum: gen obs = _N
drop if obs!=6

drop if foreign==1

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
gen job_2nd_hours_pw = job_2nd_total/52

* FOR THE TABLES JUST PASTE THE RESULTS AS A TABLE INTO EXCEL AND THEN USE THE EXCEL TO LATEX TOOL

*TABLE 1
tabulate affected_pop labour_split if year==1998, cell  

tabulate affected_pop zero_saver if year==1998, cell 

*TABLE 2
tabstat   sr_y_pos  if year==1998 , statistics(  count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)
bysort affected: tabstat   sr_y_pos if year==1998 , statistics( count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)

tabstat   hours if year==1998 , statistics(  count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)
bysort affected: tabstat   hours if year==1998 , statistics( count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)

tabstat   workers if year==1998 , statistics(  count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)
bysort affected: tabstat  workers if year==1998 , statistics( count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f) 

tabstat   hours if year==1998 & labour_split==3, statistics(  count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)
bysort affected: tabstat   hours if year==1998 & labour_split==3 , statistics( count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f) 

tabstat   job_2nd_hours_pw if year==1998 , statistics(  count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f)
bysort affected: tabstat     job_2nd_hours_pw if year==1998 , statistics( count   mean  sd    min  max         p10     p25  median p75 p90) format(%9.1f) 

*TABLE 5
table zero_saver year ,  stubwidth(32) contents(count new_hhnum) row
table zero_saver year if affected==0 ,  stubwidth(32) contents(count new_hhnum) row
table zero_saver year  if affected==1 ,  stubwidth(32) contents(count new_hhnum) row

