* REPLICATION CODE
* Selim Erdem Aytac and Ali Carkoglu
* Presidents Shaping Public Opinion in Parliamentary Democracies: A Survey Experiment in Turkey
* Political Behavior 
* April 2017

set more off

***Table 1

tabstat female, by(groups) stat(n mean)
tabstat age, by(groups) stat(n mean)
tabstat education, by(groups) stat(n mean)
tabstat kurdish, by(groups) stat(n mean)
tabstat urban, by(groups) stat(n mean)
tabstat partisan_akp, by(groups) stat(n mean)
tabstat partisan_chp, by(groups) stat(n mean)

mlogit groups female age education kurdish urban partisan_akp partisan_chp


***Table 2

*Model 1
oprobit outcome_foreign president opp_leader incumbent_akp if partisan_akp==1, robust

*Model 2
oprobit outcome_foreign president opp_leader incumbent_akp if partisan_chp==1, robust

*Model 3
oprobit outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if partisan_akp==1, robust

*Model 4
oprobit outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if partisan_chp==1, robust


***Table 3

*Model 1
oprobit outcome_domestic president opp_leader incumbent_akp if partisan_akp==1, robust

*Model 2
oprobit outcome_domestic president opp_leader incumbent_akp if partisan_chp==1, robust

*Model 3
oprobit outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if partisan_akp==1, robust

*Model 4
oprobit outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if partisan_chp==1, robust


***Table 4

*Model 1
oprobit outcome_foreign president opp_leader incumbent_akp if nonpartisan==1, robust

*Model 2
oprobit outcome_domestic president opp_leader incumbent_akp if nonpartisan==1, robust

*Model 3
oprobit outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if nonpartisan==1, robust

*Model 4
oprobit outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if nonpartisan==1, robust


*****Supplementary Information Appendix

***Table A1

*Model 1
reg outcome_foreign president opp_leader incumbent_akp if partisan_akp==1, robust

*Model 2
reg outcome_foreign president opp_leader incumbent_akp if partisan_chp==1, robust

*Model 3
reg outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if partisan_akp==1, robust

*Model 4
reg outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if partisan_chp==1, robust


***Table A2

*Model 1
reg outcome_domestic president opp_leader incumbent_akp if partisan_akp==1, robust

*Model 2
reg outcome_domestic president opp_leader incumbent_akp if partisan_chp==1, robust

*Model 3
reg outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if partisan_akp==1, robust

*Model 4
reg outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if partisan_chp==1, robust


***Table A3

*Model 1
reg outcome_foreign president opp_leader incumbent_akp if nonpartisan==1, robust

*Model 2
reg outcome_domestic president opp_leader incumbent_akp if nonpartisan==1, robust

*Model 3
reg outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if nonpartisan==1, robust

*Model 4
reg outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if nonpartisan==1, robust


***Table A4

*Model 1
oprobit outcome_foreign president opp_leader incumbent_akp if partisan_mhp==1, robust

*Model 2
oprobit outcome_foreign president opp_leader incumbent_akp if partisan_bdp==1, robust

*Model 3
oprobit outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if partisan_mhp==1, robust

*Model 4
oprobit outcome_foreign president opp_leader incumbent_akp female age education kurdish urban if partisan_bdp==1, robust


***Table A5

*Model 1
oprobit outcome_domestic president opp_leader incumbent_akp if partisan_mhp==1, robust

*Model 2
oprobit outcome_domestic president opp_leader incumbent_akp if partisan_bdp==1, robust

*Model 3
oprobit outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if partisan_mhp==1, robust

*Model 4
oprobit outcome_domestic president opp_leader incumbent_akp female age education kurdish urban if partisan_bdp==1, robust
