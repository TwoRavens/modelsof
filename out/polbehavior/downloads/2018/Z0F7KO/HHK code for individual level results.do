*Code for individual level results in Herrnson, Hanmer, and Koh, Political Behavior.
*"Mobilization Around New Convenience Voting Methods: A Field Experiment to Encourage Voting by Mail with a Downloadable Ballot and Early Voting".

*Data: HHK PB individual data.dta.

*0. First check the randomization.
*Run the mlogit for each stratum (note that some of the age vars in the voter file are miscoded).
*Run with and without these cases.

bysort strata: mlogit treatment age female i.partyid
bysort strata: mlogit treatment age female i.partyid if age>=18
*for both, the smallest p value on chi sq is .55.

*1. Turnout, combines treatments 3 & 7.

***For Fig 1.

reg turnout10 treat1_2 treat4_6 treat3_7 i.strata
probit turnout10 treat1_2 treat4_6 treat3_7 i.strata

**For Appendix Table A1.

reg turnout10 treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata
probit turnout10 treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata


*2. Early Voting usage, combines treatments 1-2 (absentee only), includes nonvoters.

**For Fig 2. and Appendix Table A2.

reg early_all  treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata
probit early_all  treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata


*3. EABDS usage, combines treatments 4-6 (early voting only), includes nonvoters.

**For EABDS portion of Fig 3. and Appendix Table A3a.

reg eabds_all treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata
probit eabds_all treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata


*4. Regular Mail Absentee usage, combines treatments 4-6 (early voting only), includes nonvoters.

**For Regular Mail portion of Fig 3. and Appendix Table A3b.

reg mail_all treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata
probit mail_all treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata


*5. mlogit with nonvoting as the base category.

**For Appendix Table A4.

mlogit vmethodmlogit treat1int treat2int treat3int treat7int treat4int treat5int treat6int i.strata, base(5)


