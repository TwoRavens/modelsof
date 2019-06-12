***File: use study1replication.dta

*****TABLE 1
*Table 1, column 1 (DV: mention cloture; n=56 senators who responded to both constituents)
tab cloture2_agree if respond_agree==1 & respond_disagree==1
tab cloture2_disagree if respond_agree==1 & respond_disagree==1
mcc  cloture2_agree cloture2_disagree

*create new variables for 2nd and 3rd columns of table 1 where no response now coded 0 instead of .
gen cloture2_agree_noresponse0=cloture2_agree
recode cloture2_agree_noresponse0 (.=0)
gen cloture2_disagree_noresponse0=cloture2_disagree
recode cloture2_disagree_noresponse0 (.=0)
gen noresponsetoboth=1 if cloture2_agree==.&cloture2_disagree==.
recode noresponsetoboth (.=0)

*Table 1, column 2 (DV: mention cloture; n=86 senators who responded to both constituents)
tab cloture2_agree_noresponse0 if noresponsetoboth==0
tab cloture2_disagree_noresponse0 if noresponsetoboth==0
mcc  cloture2_agree_noresponse0 cloture2_disagree_noresponse0 if noresponsetoboth==0

*Table 1, column 3 (DV: mention cloture; n=97 senators in initial sample)
tab cloture2_agree_noresponse0
tab cloture2_disagree_noresponse0
mcc  cloture2_agree_noresponse0 cloture2_disagree_noresponse0 



*****TABLE 2
*Table 2, column 1 (DV: anti mentions)
tab companti_pro if respond_agree==1 & respond_disagree==1
tab companti_anti if respond_agree==1 & respond_disagree==1
mcc companti_pro companti_anti

*Table 2, column 2 (DV: pro mentions):
tab comppro_pro if respond_agree==1 & respond_disagree==1
tab comppro_anti if respond_agree==1 & respond_disagree==1
mcc comppro_pro comppro_anti

*TABLE 2, column 3 (diff-in-diff) 
summ pro_balance if respond_agree==1 & respond_disagree==1
summ anti_balance if respond_agree==1 & respond_disagree==1
signtest pro_balance=anti_balance




*****Appendix 2
*Online Appendix 2a
gen zresp_two = respond_pro==1&respond_anti==1 
gen zresp_pro = respond_pro==1&respond_anti==0
gen zresp_anti = respond_pro==0&respond_anti==1
gen zresp_one = zresp_pro==1|zresp_anti==1 
gen zresp_zero = respond_pro==0&respond_anti==0
gen number_responded = .
recode number_responded (.=0) if zresp_zero==1
recode number_responded (.=1) if zresp_one==1
recode number_responded (.=2) if zresp_two==1
gen cycle_08 = electioncycle==1
gen cycle_10 = electioncycle==2
gen cycle_12 =  electioncycle==3
gen medianincome_x = medianincome/(10^3)
gen population_x = population/(10^6)
gen retired_left2 = retired_left
recode retired_left2 (.=1)

mprobit number_responded cycle_08 cycle_10 firstterm party retired_left2 years college kerry04 foreignborn medianincome_x population_x


*Online Appendix 2b

oprobit number_responded cycle_08 cycle_10 firstterm party retired_left2 years college kerry04 foreignborn medianincome_x population_x
probit zresp_two  cycle_08 cycle_10 firstterm party retired_left2 years college kerry04 foreignborn medianincome_x population_x
probit zresp_two  cycle_08 cycle_10 firstterm party retired_left2 years college kerry04 foreignborn medianincome_x population_x if number_responded==2|number_responded==1
probit zresp_two  cycle_08 cycle_10 firstterm party retired_left2 years college kerry04 foreignborn medianincome_x population_x if number_responded==2|number_responded==0

*Create new variables to estimate Appendix 2c, replacing . with 0 (n=86)
gen companti_pro_noresponse0 = companti_pro
recode companti_pro_noresponse0 (.=0)
gen companti_anti_noresponse0 = companti_anti
recode companti_anti_noresponse0 (.=0)
gen comppro_pro_noresponse0 = comppro_pro
recode comppro_pro_noresponse0 (.=0)
gen comppro_anti_noresponse0 =comppro_anti
recode comppro_anti_noresponse0 (.=0)

*Appendix 2c, column 1 (DV: anti mentions)
tab companti_pro_noresponse0 if noresponsetoboth==0
tab companti_anti_noresponse0 if noresponsetoboth==0
mcc companti_pro_noresponse0 companti_anti_noresponse0 if noresponsetoboth==0

*Appendix 2c, column 2 (pro mentions):
tab comppro_pro_noresponse0 if noresponsetoboth==0
tab comppro_anti_noresponse0 if noresponsetoboth==0
mcc comppro_pro_noresponse0 comppro_anti_noresponse0 if noresponsetoboth==0

*Appendix 2c, column 3 (diff in diff):
recode pro_balance (.=0)
recode anti_balance (.=0)
summ pro_balance if noresponsetoboth==0
summ anti_balance if noresponsetoboth==0
signtest pro_balance=anti_balance if noresponsetoboth==0




*****Appendix 3
*Appendix 3, Table 3.1, first row
*Full Sample (n=56)
tab cloture2_agree if respond_agree==1 & respond_disagree==1
tab cloture2_disagree if respond_agree==1 & respond_disagree==1
mcc cloture2_agree cloture2_disagree

*Appendix 3, Table 3.1, second row
*excluding senators with letters mentioning pre-June 28, 2007 votes (5 senators sent 1 letter prior to final cloture vote; and a 2nd letter after final cloture vote; and mentioned different cloture votes in each letter. These five senators excluded: Stevens (AK), Coleman (MN), Nelson (NE), Burr (NC), Brown(OH)).
tab cloture2_agree if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"
tab cloture2_disagree if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"
mcc cloture2_agree cloture2_disagree if senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"

*Appendix 3, Table 3.1, third row
*excluding senator with inconsistent cloture votes mentioned in 2 letters (Ben Nelson excluded; only senator w/ 2 letters taking inconsistent positions on different cloture votes across letters)
tab cloture2_agree if respond_agree==1 & respond_disagree==1 & senator!="Nelson"
tab cloture2_disagree if respond_agree==1 & respond_disagree==1 & senator!="Nelson"
mcc cloture2_agree cloture2_disagree if senator!="Nelson"

*Appendix 3, Table 3.1, fourth row
*using 2006 vote instead of June 28, 2007 vote to identify agreement
tab cloture2006_agree if respond_agree==1&respond_disagree==1
tab cloture2006_disagree if respond_agree==1&respond_disagree==1
mcc cloture2006_agree cloture2006_disagree if respond_agree==1|respond_disagree==1

*Appendix 3, Table 3.1, fifth row
*using to the right/left of immigration ideal point median to identify agreement
tab mention_cloturevote_agreeoc if respond_agree==1&respond_disagree==1
tab mention_cloturevote_disagreeoc if respond_agree==1&respond_disagree==1
mcc mention_cloturevote_agreeoc mention_cloturevote_disagreeoc if respond_agree==1|respond_disagree==1

*Appendix 3, Table 3.2, first row, top of table: outcome var: mention of anti-immigration actions
tab companti_pro if respond_agree==1 & respond_disagree==1
tab companti_anti if respond_agree==1 & respond_disagree==1
mcc companti_pro companti_anti

*Appendix 3, Table 3.2, second row, top of table: outcome var: mention of anti-immigration actions
tab companti_pro if respond_agree==1 & respond_disagree==1 & cloture2006!=.
tab companti_anti if respond_agree==1 & respond_disagree==1 &cloture2006!=.
mcc companti_pro companti_anti if respond_agree==1 & respond_disagree==1 & cloture2006!=.

*Appendix 3, Table 3.2, third row, top of table: outcome var: mention of anti-immigration actions
tab companti_pro if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"
tab companti_anti if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"
mcc companti_pro companti_anti if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"

*Appendix 3, Table 3.2, fourth row, top of table: outcome var: mention of anti-immigration actions
tab companti_pro if respond_agree==1 & respond_disagree==1 & senator!="Nelson" 
tab companti_anti if respond_agree==1 & respond_disagree==1 & senator!="Nelson"
mcc companti_pro companti_anti if respond_agree==1 & respond_disagree==1 & senator!="Nelson" 

*Appendix 3, Table 3.2, fifth row, bottom of table: outcome var: mention of pro-immigration actions
tab comppro_pro if respond_agree==1 & respond_disagree==1
tab comppro_anti if respond_agree==1 & respond_disagree==1
mcc comppro_pro comppro_anti

*Appendix 3, Table 3.2, sixth row, bottom of table: outcome var: mention of pro-immigration actions
tab comppro_pro if respond_agree==1 & respond_disagree==1 & cloture2006!=.
tab comppro_anti if respond_agree==1 & respond_disagree==1 &cloture2006!=.
mcc comppro_pro comppro_anti if respond_agree==1 & respond_disagree==1 & cloture2006!=.

*Appendix 3, Table 3.2, seventh row, bottom of table: outcome var: mention of pro-immigration actions
tab comppro_pro if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"
tab comppro_anti if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"
mcc comppro_pro comppro_anti if respond_agree==1 & respond_disagree==1 & senator!="Stevens" & senator!="Coleman"& senator!="Nelson" & senator!="Burr" & senator!="Brown"

*Appendix 3, Table 3.2, eighth row, bottom of table: outcome var: mention of pro-immigration actions
tab comppro_pro if respond_agree==1 & respond_disagree==1 & senator!="Nelson" 
tab comppro_anti if respond_agree==1 & respond_disagree==1 & senator!="Nelson"
mcc comppro_pro comppro_anti if respond_agree==1 & respond_disagree==1 & senator!="Nelson" 




*****Appendix 4
*** outcome var – mentioned cloture vote
tab cloture2_agree if respond_agree==1 & respond_disagree==1
tab cloture2_disagree if respond_agree==1 & respond_disagree==1

*mention cloture - electioncycle coding: 1=2008; 2=2010; 3=2012
tab cloture2_agree if electioncycle==1 & respond_agree==1 & respond_disagree==1
tab cloture2_agree if electioncycle==2 & respond_agree==1 & respond_disagree==1
tab cloture2_agree if electioncycle==3 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if electioncycle==1 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if electioncycle==2 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if electioncycle==3 & respond_agree==1 & respond_disagree==1

*mention cloture - party coded 1 if R, 0 if D.
tab cloture2_agree if party==0 & respond_agree==1 & respond_disagree==1
tab cloture2_agree if party==1 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if party==0 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if party==1 & respond_agree==1 & respond_disagree==1

*mention cloture - retired_left=1 if retired from politics; or took another position (e.g. exec. appt.)
tab cloture2_agree if retired_left==1 & respond_agree==1 & respond_disagree==1
tab cloture2_agree if retired_left==0 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if retired_left==1 & respond_agree==1 & respond_disagree==1
tab cloture2_disagree if retired_left==0 & respond_agree==1 & respond_disagree==1



*****Appendix 5 – top mentioned anti-imm actions
*** outcome var – mentioned anti-imm actions
tab companti_pro if respond_agree==1 & respond_disagree==1
tab companti_anti if respond_agree==1 & respond_disagree==1

*mention anti-imm actions - electioncycle coding: 1=2008; 2=2010; 3=2012
tab companti_pro if electioncycle==1 & respond_agree==1 & respond_disagree==1
tab companti_pro if electioncycle==2 & respond_agree==1 & respond_disagree==1
tab companti_pro if electioncycle==3 & respond_agree==1 & respond_disagree==1
tab companti_anti if electioncycle==1 & respond_agree==1 & respond_disagree==1
tab companti_anti if electioncycle==2 & respond_agree==1 & respond_disagree==1
tab companti_anti if electioncycle==3 & respond_agree==1 & respond_disagree==1

*mention anti-imm actions - party coded 1 if R, 0 if D.
tab companti_pro if party==0 & respond_agree==1 & respond_disagree==1
tab companti_pro if party==1 & respond_agree==1 & respond_disagree==1
tab companti_anti if party==0 & respond_agree==1 & respond_disagree==1
tab companti_anti if party==1 & respond_agree==1 & respond_disagree==1

*mention anti-imm actions - retired_left=1 if retired from politics; or took another position (e.g. exec. appt.)
tab companti_pro if retired_left==1 & respond_agree==1 & respond_disagree==1
tab companti_pro if retired_left==0 & respond_agree==1 & respond_disagree==1
tab companti_anti if retired_left==1 & respond_agree==1 & respond_disagree==1
tab companti_anti if retired_left==0 & respond_agree==1 & respond_disagree==1




*****Online Appendix 5 – bottom – mentioned pro-immigration actions
*** outcome var – mentioned pro-imm actions
tab comppro_pro if respond_agree==1 & respond_disagree==1
tab comppro_anti if respond_agree==1 & respond_disagree==1

*mention pro-imm actions - electioncycle coding: 1=2008; 2=2010; 3=2012
tab comppro_pro if electioncycle==1 & respond_agree==1 & respond_disagree==1
tab comppro_pro if electioncycle==2 & respond_agree==1 & respond_disagree==1
tab comppro_pro if electioncycle==3 & respond_agree==1 & respond_disagree==1
tab comppro_anti if electioncycle==1 & respond_agree==1 & respond_disagree==1
tab comppro_anti if electioncycle==2 & respond_agree==1 & respond_disagree==1
tab comppro_anti if electioncycle==3 & respond_agree==1 & respond_disagree==1

*mention pro-imm actions - party coded 1 if R, 0 if D.
tab comppro_pro if party==0 & respond_agree==1 & respond_disagree==1
tab comppro_pro if party==1 & respond_agree==1 & respond_disagree==1
tab comppro_anti if party==0 & respond_agree==1 & respond_disagree==1
tab comppro_anti if party==1 & respond_agree==1 & respond_disagree==1

*mention pro-imm actions - retired_left=1 if retired from politics; or took another position (e.g. exec. appt.)
tab comppro_pro if retired_left==1 & respond_agree==1 & respond_disagree==1
tab comppro_pro if retired_left==0 & respond_agree==1 & respond_disagree==1
tab comppro_anti if retired_left==1 & respond_agree==1 & respond_disagree==1
tab comppro_anti if retired_left==0 & respond_agree==1 & respond_disagree==1
