*Load replication dataset
use "...\160127_RTW_Replication.dta", clear

*Specify directory for saving output
cd "...\Tables"
cd "C:\Users\kogan.18\Box Sync\RTW\Replication\Test"
set more off
xtset st year

*The following commands replicate Table 1
char year[omit] 1947
xi: xtreg  top1_ps RTW i.year if year>=1940, fe cluster(st)
outreg2 using table1_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES)
char year[omit] 1947
xi: xtreg  top10_ps RTW i.year if year>=1940, fe cluster(st)
outreg2 using table1_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES)
char year[omit] 1947
xi: xtreg  gini RTW i.year if year>=1940, fe cluster(st)
outreg2 using table1_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW)  addtext(State FE, YES, Year FE, YES)

*The following commands replicate Table 2
char year[omit] 1945
xi: xtreg  top1_ps RTW urban dem_share log_pop manufacturing homeown i.year  if year>=1940, fe cluster(st)
outreg2 using table2_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW urban dem_share log_pop manufacturing homeown)  addtext(State FE, YES, Year FE, YES)
char year[omit] 1945
xi: xtreg  top10_ps RTW urban dem_share log_pop manufacturing homeown i.year if year>=1940, fe cluster(st)
outreg2 using table2_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW urban dem_share log_pop manufacturing homeown)  addtext(State FE, YES, Year FE, YES)
char year[omit] 1945
xi: xtreg  gini RTW urban dem_share log_pop manufacturing homeown i.year if year>=1940, fe cluster(st)
outreg2 using table2_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW urban dem_share log_pop manufacturing homeown)  addtext(State FE, YES, Year FE, YES)

*The following commands replicate Table 3
char year[omit] 1947
xi: xtreg  top1_ps RTW RTW_1970 i.year if year>=1940, fe cluster(st)
outreg2 using table3_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW RTW_1970)  addtext(State FE, YES, Year FE, YES)
char year[omit] 1947
xi: xtreg  top10_ps RTW RTW_1970 i.year if year>=1940, fe cluster(st)
outreg2 using table3_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW RTW_1970)  addtext(State FE, YES, Year FE, YES)
char year[omit] 1947
xi: xtreg  gini RTW RTW_1970 i.year if year>=1940, fe cluster(st)
outreg2 using table3_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW RTW_1970)  addtext(State FE, YES, Year FE, YES)

*The following commands replicate Table A.1
xi: xtreg  top1_ps RTW i.year if year>=1940 & year<1970, fe cluster(st)
outreg2 using tableA1_replication.tex, tex replace ctitle(Top 1% Share, Pre-1970) label keep(RTW)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  top10_ps RTW i.year if year>=1940 & year<1970, fe cluster(st)
outreg2 using tableA1_replication.tex, tex append ctitle(Top 10% Share, Pre-1970) label keep(RTW)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  gini RTW i.year if year>=1940 & year<1970, fe cluster(st)
outreg2 using tableA1_replication.tex, tex append ctitle(Gini Coefficient, Pre-1970) label keep(RTW)  addtext(State FE, YES, Year FE, YES)

*The following commands replicate Table A.2
xi: xtreg  atkin05  RTW i.year if year>=1940, fe cluster(st)
outreg2 using tableA2_replication.tex, tex replace ctitle(Atkinson Index) label keep(RTW)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  rmeandev  RTW i.year if year>=1940, fe cluster(st)
outreg2 using tableA2_replication.tex, tex append ctitle(Relative Mean Deviation) label keep(RTW)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  theil  RTW i.year if year>=1940, fe cluster(st)
outreg2 using tableA2_replication.tex, tex append ctitle(Theil Index) label keep(RTW)  addtext(State FE, YES, Year FE, YES)

*The following commands replicate Table A.3
xi: xtreg  top1_ps RTW i.year new_year if year>=1940, fe cluster(st)
outreg2 using tableA3_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, Linear)
xi: xtreg  top10_ps RTW i.year new_year  if year>=1940, fe cluster(st)
outreg2 using tableA3_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, Linear)
xi: xtreg  gini RTW i.year  new_year if year>=1940, fe cluster(st)
outreg2 using tableA3_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, Linear)

*The following commands replicate Table A.4
xi: xtreg  top1_ps RTW i.year new_year new_year_2 if year>=1940, fe cluster(st)
outreg2 using tableA4_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, Quadratic)
xi: xtreg  top10_ps RTW i.year new_year new_year_2  if year>=1940, fe cluster(st)
outreg2 using tableA4_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, Quadratic)
xi: xtreg  gini RTW i.year new_year new_year_2 if year>=1940, fe cluster(st)
outreg2 using tableA4_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, Quadratic)

*The following commands replicate Table A.5
xi: xtreg  top1_ps RTW i.year i.fips*new_year if year>=1940, fe cluster(st)
outreg2 using tableA5_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, State-Specific)
xi: xtreg  top10_ps RTW i.year i.fips*new_year  if year>=1940, fe cluster(st)
outreg2 using tableA5_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, State-Specific)
xi: xtreg  gini RTW i.year  i.fips*new_year if year>=1940, fe cluster(st)
outreg2 using tableA5_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW)  addtext(State FE, YES, Year FE, YES, Time Trend, State-Specific)

*The following commands replicate Table A.6
xi: xtreg  top1_ps RTW RTW_1980 i.year if year>=1940, fe cluster(st)
outreg2 using tableA6_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW RTW_1980)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  top10_ps RTW RTW_1980 i.year if year>=1940, fe cluster(st)
outreg2 using tableA6_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW RTW_1980)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  gini RTW RTW_1980 i.year if year>=1940, fe cluster(st)
outreg2 using tableA6_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW RTW_1980)  addtext(State FE, YES, Year FE, YES)

*The following commands replicate Table A.7
xi: xtreg  top1_ps RTW RTW_1990 i.year if year>=1940, fe cluster(st)
outreg2 using tableA7_replication.tex, tex replace ctitle(Top 1% Share) label keep(RTW RTW_1990)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  top10_ps RTW RTW_1990 i.year if year>=1940, fe cluster(st)
outreg2 using tableA7_replication.tex, tex append ctitle(Top 10% Share) label keep(RTW RTW_1990)  addtext(State FE, YES, Year FE, YES)
xi: xtreg  gini RTW RTW_1990 i.year if year>=1940, fe cluster(st)
outreg2 using tableA7_replication.tex, tex append ctitle(Gini Coefficient) label keep(RTW RTW_1990)  addtext(State FE, YES, Year FE, YES)






**Thw following commands export the results from the event study analysis

gen RTW_Post1=d.RTW
replace RTW_Post1=0 if RTW_Post1==.
replace RTW_Post1=0 if RTW_Post1==-1

gen RTW_Post2=l1.RTW_Post1
replace RTW_Post2=0 if RTW_Post2==.


gen RTW_Post3=l2.RTW_Post1
replace RTW_Post3=0 if RTW_Post3==.


gen RTW_Post4=l3.RTW_Post1
replace RTW_Post4=0 if RTW_Post4==.


gen RTW_Post5=l4.RTW_Post1
replace RTW_Post5=0 if RTW_Post5==.


gen RTW_Post6=l5.RTW_Post1
replace RTW_Post6=0 if RTW_Post6==.


gen RTW_Post7=l6.RTW_Post1
replace RTW_Post7=0 if RTW_Post7==.


gen RTW_Post8=l7.RTW_Post1
replace RTW_Post8=0 if RTW_Post8==.


gen RTW_Post9=l8.RTW_Post1
replace RTW_Post9=0 if RTW_Post9==.


gen RTW_Post10=l9.RTW_Post1
replace RTW_Post10=0 if RTW_Post10==.


gen RTW_Post11=1 if RTW_Post1==0 & RTW_Post2==0 & RTW_Post3==0 & RTW_Post4==0 & RTW_Post5==0 & RTW_Post6==0 & RTW_Post7==0 & RTW_Post8==0 & RTW_Post9==0 & RTW_Post10==0 & RTW==1
replace RTW_Post11=0 if RTW_Post11==.

set more off
xi: xtreg  top1_ps RTW_Post* i.year i.fips*new_year if year>=1940, fe cluster(st)
estimates store m1
xi: xtreg  top10_ps  RTW_Post* i.year i.fips*new_year  if year>=1940, fe cluster(st)
estimates store m2
xi: xtreg  gini RTW RTW_Post* i.year  i.fips*new_year if year>=1940, fe cluster(st)
estimates store m3

esttab m1 m2 m3 using "event_study_replication.csv", replace plain keep(RTW_Post*) cells(b(nostar fmt(3)) ci(fmt(3)))
