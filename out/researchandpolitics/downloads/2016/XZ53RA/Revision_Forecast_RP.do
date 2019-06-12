use "C:\Users\mmak\Desktop\Forecasting 2016 RP v1.dta", clear
 
log using Forecast_PR, name(Forecast_PR) 

***Using Out Party
*Models for Table 1
probit vote eucdist114 lackqual dist_qual strongp outparty, robust
estat clas
estat ic

probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu, robust
estat clas
estat ic

*Models in Table 1 (using Bailey for Appendix)
probit vote eucdistb lackqual dist_qualb strongp outparty, robust
estat clas 
estat ic
display (511-(75+284))/511

probit vote eucdistb lackqual dist_qualb strongp partyunity devpu outparty out_partyunity out_devpu, robust
estat clas
estat ic
display (509-(77+173))/509

probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu if nomyear > 1950 & nomyear < 2013, robust
estat clas
estat ic
display (509-(62+170))/509

probit vote eucdist114 lackqual dist_qual strongp outparty if nomyear > 1950 & nomyear < 2013, robust
estat clas
estat ic
display (510-(294+67))/510

*Table 2 (Selected Senator's Ideological Positions, Party Loyalty Levels and Predicted Votes) 
set more off
probit vote eucdist114 lackqual dist_qual strongp partyunity devpu sameparty same_partyunity same_devpu, robust

*Obama as Ideal Point
replace lackqual = 1 - 0.970 if counter==44
replace eucdist114 = (cs114 - (-0.366))^2 if counter==44
replace dist_qual = eucdist114*lackqual if counter==44

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu sameparty same_partyunity same_devpu  if counter != 44, robust
estat clas
quietly predict oos_45, pr
quietly gen pred_oos_45 = 0
quietly replace pred_oos_45 = 1 if oos_45 >= .5
sort counter cs114 name
list name cs114 levelpartyu oos_45 if counter==44

*Kennedy's Ideology as Ideal Point
replace lackqual = 1 - 0.970 if counter==44
replace eucdist114 = (cs114 - (.1061864))^2 if counter==44
replace dist_qual = eucdist114*lackqual if counter==44

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu sameparty same_partyunity same_devpu  if counter != 44, robust
estat clas
quietly predict oos_46, pr
quietly gen pred_oos_46 = 0
quietly replace pred_oos_46 = 1 if oos_46 >= .5
sort counter cs114 name
list name cs114 levelpartyu oos_45 oos_46 if counter==44

*Kirk as median
replace lackqual = 1 - 0.970 if counter==44
replace eucdist114 = (cs114 - (.275))^2 if counter==44
replace dist_qual = eucdist114*lackqual if counter==44

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu sameparty same_partyunity same_devpu  if counter != 44, robust
estat clas
quietly predict oos_47, pr
quietly gen pred_oos_47 = 0
quietly replace pred_oos_47 = 1 if oos_46 >= .5
sort counter cs114 name
list name cs114 levelpartyu oos_45 oos_46 oos_47 if counter==44

**Figure Two (Republican Senators' Predicted Probabilities of Voting for Hypothetical Nominees)
***Making Adjustments to Ideology and Qualifications
***Sotomayor's Values
replace lackqual = 1 - 0.710 if counter==44
replace nomid = 0.780 if counter==44
replace nomineeid = .4345696 - .8996801*nomid if counter==44
replace eucdist114 = (cs114 - nomineeid)^2 if counter==44
replace dist_qual = eucdist114*lackqual if counter==44

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu   if counter != 44, robust
estat clas
quietly predict oos_Sotomayor, pr
quietly predict oos_Sotomayor_xb, xb
quietly predict oos_Sotomayor_se, stdp
quietly generate lb_Sotomayor = oos_Sotomayor_xb - invnormal(0.975)*oos_Sotomayor_se
quietly generate ub_Sotomayor = oos_Sotomayor_xb + invnormal(0.975)*oos_Sotomayor_se
quietly generate plb_Sotomayor = normal(lb_Sotomayor)
quietly generate pub_Sotomayor = normal(ub_Sotomayor)
quietly gen pred_oos_Sotomayor = 0
quietly replace pred_oos_Sotomayor = 1 if oos_Sotomayor >= .5
tab pred_oos_Sotomayor if counter==44

***Ginsburg's Values
replace lackqual = 1 - 1.000 if counter==44
replace nomid = 0.680 if counter==44
replace nomineeid = .4345696 - .8996801*nomid if counter==44
replace eucdist114 = (cs114 - nomineeid)^2 if counter==44
replace dist_qual = eucdist114*lackqual if counter==44

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu   if counter != 44, robust
estat clas
quietly predict oos_Ginsburg, pr
quietly predict oos_Ginsburg_xb, xb
quietly predict oos_Ginsburg_se, stdp
quietly generate lb_Ginsburg = oos_Ginsburg_xb - invnormal(0.975)*oos_Ginsburg_se
quietly generate ub_Ginsburg = oos_Ginsburg_xb + invnormal(0.975)*oos_Ginsburg_se
quietly generate plb_Ginsburg = normal(lb_Ginsburg)
quietly generate pub_Ginsburg = normal(ub_Ginsburg)
quietly gen pred_oos_Ginsburg = 0
quietly replace pred_oos_Ginsburg = 1 if oos_Ginsburg >= .5
tab pred_oos_Ginsburg if counter==44

save "C:\Users\mmak\Desktop\Forecasting 2016 RP v2.dta"

sort counter cs114 name
list name cs114 levelpartyu oos_Sotomayor plb_Sotomayor pub_Sotomayor if counter==44

sort counter cs114 name
list name cs114 levelpartyu oos_Ginsburg plb_Ginsburg pub_Ginsburg if counter==44

use "C:\Users\mmak\Desktop\Forecasting 2016 RP v1.dta", clear

***Figure 1 (Out of Sample Forecasts)
***Basinger and Mak Models
***Out-of-Sample Forecasts
quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 1, robust
estat clas
quietly predict oos_1, pr
quietly gen pred_oos_1 = 0
quietly replace pred_oos_1 = 1 if oos_1 >= .5
tab vote pred_oos_1
tab vote pred_oos_1 if counter==1

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 2, robust
estat clas
quietly predict oos_2, pr
quietly gen pred_oos_2 = 0
quietly replace pred_oos_2 = 1 if oos_2 >= .5
tab vote pred_oos_2
tab vote pred_oos_2 if counter==2

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 3, robust
estat clas
quietly predict oos_3, pr
quietly gen pred_oos_3 = 0
quietly replace pred_oos_3 = 1 if oos_3 >= .5
tab vote pred_oos_3
tab vote pred_oos_3 if counter==3

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 4, robust
estat clas
quietly predict oos_4, pr
quietly gen pred_oos_4 = 0
quietly replace pred_oos_4 = 1 if oos_4 >= .5
tab vote pred_oos_4
tab vote pred_oos_4 if counter==4

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 5, robust
estat clas
quietly predict oos_5, pr
quietly gen pred_oos_5 = 0
quietly replace pred_oos_5 = 1 if oos_5 >= .5
tab vote pred_oos_5
tab vote pred_oos_5 if counter==5

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 6, robust
estat clas
quietly predict oos_6, pr
quietly gen pred_oos_6 = 0
quietly replace pred_oos_6 = 1 if oos_6 >= .5
tab vote pred_oos_6
tab vote pred_oos_6 if counter==6

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 7, robust
estat clas
quietly predict oos_7, pr
quietly gen pred_oos_7 = 0
quietly replace pred_oos_7 = 1 if oos_7 >= .5
tab vote pred_oos_7
tab vote pred_oos_7 if counter==7

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 8, robust
estat clas
quietly predict oos_8, pr
quietly gen pred_oos_8 = 0
quietly replace pred_oos_8 = 1 if oos_8 >= .5
tab vote pred_oos_8
tab vote pred_oos_8 if counter==8

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 9, robust
estat clas
quietly predict oos_9, pr
quietly gen pred_oos_9 = 0
quietly replace pred_oos_9 = 1 if oos_9 >= .5
tab vote pred_oos_9
tab vote pred_oos_9 if counter==9

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 10, robust
estat clas
quietly predict oos_10, pr
quietly gen pred_oos_10 = 0
quietly replace pred_oos_10 = 1 if oos_10 >= .5
tab vote pred_oos_10
tab vote pred_oos_10 if counter==10

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 11, robust
estat clas
quietly predict oos_11, pr
quietly gen pred_oos_11 = 0
quietly replace pred_oos_11 = 1 if oos_11 >= .5
tab vote pred_oos_11
tab vote pred_oos_11 if counter==11

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 12, robust
estat clas
quietly predict oos_12, pr
quietly gen pred_oos_12 = 0
quietly replace pred_oos_12 = 1 if oos_12 >= .5
tab vote pred_oos_12
tab vote pred_oos_12 if counter==12

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 13, robust
estat clas
quietly predict oos_13, pr
quietly gen pred_oos_13 = 0
quietly replace pred_oos_13 = 1 if oos_13 >= .5
tab vote pred_oos_13
tab vote pred_oos_13 if counter==13

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 14, robust
estat clas
quietly predict oos_14, pr
quietly gen pred_oos_14 = 0
quietly replace pred_oos_14 = 1 if oos_14 >= .5
tab vote pred_oos_14
tab vote pred_oos_14 if counter==14

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 15, robust
estat clas
quietly predict oos_15, pr
quietly gen pred_oos_15 = 0
quietly replace pred_oos_15 = 1 if oos_15 >= .5
tab vote pred_oos_15
tab vote pred_oos_15 if counter==15

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 16, robust
estat clas
quietly predict oos_16, pr
quietly gen pred_oos_16 = 0
quietly replace pred_oos_16 = 1 if oos_16 >= .5
tab vote pred_oos_16
tab vote pred_oos_16 if counter==16

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 17, robust
estat clas
quietly predict oos_17, pr
quietly gen pred_oos_17 = 0
quietly replace pred_oos_17 = 1 if oos_17 >= .5
tab vote pred_oos_17
tab vote pred_oos_17 if counter==17

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 18, robust
estat clas
quietly predict oos_18, pr
quietly gen pred_oos_18 = 0
quietly replace pred_oos_18 = 1 if oos_18 >= .5
tab vote pred_oos_18
tab vote pred_oos_18 if counter==18

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 19, robust
estat clas
quietly predict oos_19, pr
quietly gen pred_oos_19 = 0
quietly replace pred_oos_19 = 1 if oos_19 >= .5
tab vote pred_oos_19
tab vote pred_oos_19 if counter==19

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 20, robust
estat clas
quietly predict oos_20, pr
quietly gen pred_oos_20 = 0
quietly replace pred_oos_20 = 1 if oos_20 >= .5
tab vote pred_oos_20
tab vote pred_oos_20 if counter==20

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 21, robust
estat clas
quietly predict oos_21, pr
quietly gen pred_oos_21 = 0
quietly replace pred_oos_21 = 1 if oos_21 >= .5
tab vote pred_oos_21
tab vote pred_oos_21 if counter==21

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 22, robust
estat clas
quietly predict oos_22, pr
quietly gen pred_oos_22 = 0
quietly replace pred_oos_22 = 1 if oos_22 >= .5
tab vote pred_oos_22
tab vote pred_oos_22 if counter==22

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 23, robust
estat clas
quietly predict oos_23, pr
quietly gen pred_oos_23 = 0
quietly replace pred_oos_23 = 1 if oos_23 >= .5
tab vote pred_oos_23
tab vote pred_oos_23 if counter==23

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 24, robust
estat clas
quietly predict oos_24, pr
quietly gen pred_oos_24 = 0
quietly replace pred_oos_24 = 1 if oos_24 >= .5
tab vote pred_oos_24
tab vote pred_oos_24 if counter==24

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 25, robust
estat clas
quietly predict oos_25, pr
quietly gen pred_oos_25 = 0
quietly replace pred_oos_25 = 1 if oos_25 >= .5
tab vote pred_oos_25
tab vote pred_oos_25 if counter==25

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 26, robust
estat clas
quietly predict oos_26, pr
quietly gen pred_oos_26 = 0
quietly replace pred_oos_26 = 1 if oos_26 >= .5
tab vote pred_oos_26
tab vote pred_oos_26 if counter==26

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 27, robust
estat clas
quietly predict oos_27, pr
quietly gen pred_oos_27 = 0
quietly replace pred_oos_27 = 1 if oos_27 >= .5
tab vote pred_oos_27
tab vote pred_oos_27 if counter==27

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 28, robust
estat clas
quietly predict oos_28, pr
quietly gen pred_oos_28 = 0
quietly replace pred_oos_28 = 1 if oos_28 >= .5
tab vote pred_oos_28
tab vote pred_oos_28 if counter==28

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 29, robust
estat clas
quietly predict oos_29, pr
quietly gen pred_oos_29 = 0
quietly replace pred_oos_29 = 1 if oos_29 >= .5
tab vote pred_oos_29
tab vote pred_oos_29 if counter==29

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 30, robust
estat clas
quietly predict oos_30, pr
quietly gen pred_oos_30 = 0
quietly replace pred_oos_30 = 1 if oos_30 >= .5
tab vote pred_oos_30
tab vote pred_oos_30 if counter==30

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 31, robust
estat clas
quietly predict oos_31, pr
quietly gen pred_oos_31 = 0
quietly replace pred_oos_31 = 1 if oos_31 >= .5
tab vote pred_oos_31
tab vote pred_oos_31 if counter==31

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 32, robust
estat clas
quietly predict oos_32, pr
quietly gen pred_oos_32 = 0
quietly replace pred_oos_32 = 1 if oos_32 >= .5
tab vote pred_oos_32
tab vote pred_oos_32 if counter==32

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 33, robust
estat clas
quietly predict oos_33, pr
quietly gen pred_oos_33 = 0
quietly replace pred_oos_33 = 1 if oos_33 >= .5
tab vote pred_oos_33
tab vote pred_oos_33 if counter==33

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 34, robust
estat clas
quietly predict oos_34, pr
quietly gen pred_oos_34 = 0
quietly replace pred_oos_34 = 1 if oos_34 >= .5
tab vote pred_oos_34
tab vote pred_oos_34 if counter==34

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 35, robust
estat clas
quietly predict oos_35, pr
quietly gen pred_oos_35 = 0
quietly replace pred_oos_35 = 1 if oos_35 >= .5
tab vote pred_oos_35
tab vote pred_oos_35 if counter==35

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 36, robust
estat clas
quietly predict oos_36, pr
quietly gen pred_oos_36 = 0
quietly replace pred_oos_36 = 1 if oos_36 >= .5
tab vote pred_oos_36
tab vote pred_oos_36 if counter==36

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 37, robust
estat clas
quietly predict oos_37, pr
quietly gen pred_oos_37 = 0
quietly replace pred_oos_37 = 1 if oos_37 >= .5
tab vote pred_oos_37
tab vote pred_oos_37 if counter==37

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 38, robust
estat clas
quietly predict oos_38, pr
quietly gen pred_oos_38 = 0
quietly replace pred_oos_38 = 1 if oos_38 >= .5
tab vote pred_oos_38
tab vote pred_oos_38 if counter==38

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 39, robust
estat clas
quietly predict oos_39, pr
quietly gen pred_oos_39 = 0
quietly replace pred_oos_39 = 1 if oos_39 >= .5
tab vote pred_oos_39
tab vote pred_oos_39 if counter==39

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 40, robust
estat clas
quietly predict oos_40, pr
quietly gen pred_oos_40 = 0
quietly replace pred_oos_40 = 1 if oos_40 >= .5
tab vote pred_oos_40
tab vote pred_oos_40 if counter==40

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 41, robust
estat clas
quietly predict oos_41, pr
quietly gen pred_oos_41 = 0
quietly replace pred_oos_41 = 1 if oos_41 >= .5
tab vote pred_oos_41
tab vote pred_oos_41 if counter==41

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 42, robust
estat clas
quietly predict oos_42, pr
quietly gen pred_oos_42 = 0
quietly replace pred_oos_42 = 1 if oos_42 >= .5
tab vote pred_oos_42
tab vote pred_oos_42 if counter==42

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 43, robust
estat clas
quietly predict oos_43, pr
quietly gen pred_oos_43 = 0
quietly replace pred_oos_43 = 1 if oos_43 >= .5
tab vote pred_oos_43
tab vote pred_oos_43 if counter==43

quietly probit vote eucdist114 lackqual dist_qual strongp partyunity devpu outparty out_partyunity out_devpu  if counter != 44, robust
estat clas
quietly predict oos_44, pr
quietly gen pred_oos_44 = 0
quietly replace pred_oos_44 = 1 if oos_44 >= .5
tab vote pred_oos_44
tab vote pred_oos_44 if counter==44

quietly gen pred_oos_all = .
quietly replace pred_oos_all = 	pred_oos_1	if counter==1
quietly replace pred_oos_all = 	pred_oos_2	if counter==2
quietly replace pred_oos_all = 	pred_oos_3	if counter==3
quietly replace pred_oos_all = 	pred_oos_4	if counter==4
quietly replace pred_oos_all = 	pred_oos_5	if counter==5
quietly replace pred_oos_all = 	pred_oos_6	if counter==6
quietly replace pred_oos_all = 	pred_oos_7	if counter==7
quietly replace pred_oos_all = 	pred_oos_8	if counter==8
quietly replace pred_oos_all = 	pred_oos_9	if counter==9
quietly replace pred_oos_all = 	pred_oos_10	if counter==10
quietly replace pred_oos_all = 	pred_oos_11	if counter==11
quietly replace pred_oos_all = 	pred_oos_12	if counter==12
quietly replace pred_oos_all = 	pred_oos_13	if counter==13
quietly replace pred_oos_all = 	pred_oos_14	if counter==14
quietly replace pred_oos_all = 	pred_oos_15	if counter==15
quietly replace pred_oos_all = 	pred_oos_16	if counter==16
quietly replace pred_oos_all = 	pred_oos_17	if counter==17
quietly replace pred_oos_all = 	pred_oos_18	if counter==18
quietly replace pred_oos_all = 	pred_oos_19	if counter==19
quietly replace pred_oos_all = 	pred_oos_20	if counter==20
quietly replace pred_oos_all = 	pred_oos_21	if counter==21
quietly replace pred_oos_all = 	pred_oos_22	if counter==22
quietly replace pred_oos_all = 	pred_oos_23	if counter==23
quietly replace pred_oos_all = 	pred_oos_24	if counter==24
quietly replace pred_oos_all = 	pred_oos_25	if counter==25
quietly replace pred_oos_all = 	pred_oos_26	if counter==26
quietly replace pred_oos_all = 	pred_oos_27	if counter==27
quietly replace pred_oos_all = 	pred_oos_28	if counter==28
quietly replace pred_oos_all = 	pred_oos_29	if counter==29
quietly replace pred_oos_all = 	pred_oos_30	if counter==30
quietly replace pred_oos_all = 	pred_oos_31	if counter==31
quietly replace pred_oos_all = 	pred_oos_32	if counter==32
quietly replace pred_oos_all = 	pred_oos_33	if counter==33
quietly replace pred_oos_all = 	pred_oos_34	if counter==34
quietly replace pred_oos_all = 	pred_oos_35	if counter==35
quietly replace pred_oos_all = 	pred_oos_36	if counter==36
quietly replace pred_oos_all = 	pred_oos_37	if counter==37
quietly replace pred_oos_all = 	pred_oos_38	if counter==38
quietly replace pred_oos_all = 	pred_oos_39	if counter==39
quietly replace pred_oos_all = 	pred_oos_40	if counter==40
quietly replace pred_oos_all = 	pred_oos_41	if counter==41
quietly replace pred_oos_all = 	pred_oos_42	if counter==42
quietly replace pred_oos_all = 	pred_oos_43	if counter==43
quietly replace pred_oos_all = 	pred_oos_44	if counter==44
lab var pred_oos_all "Out-of-Sample Forecasts"

save "C:\Users\mmak\Desktop\Forecasting 2016 RP v2 BM Forecasts.dta"

use "C:\Users\mmak\Desktop\Forecasting 2016 RP v1.dta", clear

***Segal Models
***Out-of-Sample Forecasts
quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 1, robust
estat clas
quietly predict oos_1, pr
quietly gen pred_oos_1 = 0
quietly replace pred_oos_1 = 1 if oos_1 >= .5
tab vote pred_oos_1
tab vote pred_oos_1 if counter==1

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 2, robust
estat clas
quietly predict oos_2, pr
quietly gen pred_oos_2 = 0
quietly replace pred_oos_2 = 1 if oos_2 >= .5
tab vote pred_oos_2
tab vote pred_oos_2 if counter==2

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 3, robust
estat clas
quietly predict oos_3, pr
quietly gen pred_oos_3 = 0
quietly replace pred_oos_3 = 1 if oos_3 >= .5
tab vote pred_oos_3
tab vote pred_oos_3 if counter==3

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 4, robust
estat clas
quietly predict oos_4, pr
quietly gen pred_oos_4 = 0
quietly replace pred_oos_4 = 1 if oos_4 >= .5
tab vote pred_oos_4
tab vote pred_oos_4 if counter==4

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 5, robust
estat clas
quietly predict oos_5, pr
quietly gen pred_oos_5 = 0
quietly replace pred_oos_5 = 1 if oos_5 >= .5
tab vote pred_oos_5
tab vote pred_oos_5 if counter==5

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 6, robust
estat clas
quietly predict oos_6, pr
quietly gen pred_oos_6 = 0
quietly replace pred_oos_6 = 1 if oos_6 >= .5
tab vote pred_oos_6
tab vote pred_oos_6 if counter==6

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 7, robust
estat clas
quietly predict oos_7, pr
quietly gen pred_oos_7 = 0
quietly replace pred_oos_7 = 1 if oos_7 >= .5
tab vote pred_oos_7
tab vote pred_oos_7 if counter==7

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 8, robust
estat clas
quietly predict oos_8, pr
quietly gen pred_oos_8 = 0
quietly replace pred_oos_8 = 1 if oos_8 >= .5
tab vote pred_oos_8
tab vote pred_oos_8 if counter==8

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 9, robust
estat clas
quietly predict oos_9, pr
quietly gen pred_oos_9 = 0
quietly replace pred_oos_9 = 1 if oos_9 >= .5
tab vote pred_oos_9
tab vote pred_oos_9 if counter==9

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 10, robust
estat clas
quietly predict oos_10, pr
quietly gen pred_oos_10 = 0
quietly replace pred_oos_10 = 1 if oos_10 >= .5
tab vote pred_oos_10
tab vote pred_oos_10 if counter==10

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 11, robust
estat clas
quietly predict oos_11, pr
quietly gen pred_oos_11 = 0
quietly replace pred_oos_11 = 1 if oos_11 >= .5
tab vote pred_oos_11
tab vote pred_oos_11 if counter==11

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 12, robust
estat clas
quietly predict oos_12, pr
quietly gen pred_oos_12 = 0
quietly replace pred_oos_12 = 1 if oos_12 >= .5
tab vote pred_oos_12
tab vote pred_oos_12 if counter==12

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 13, robust
estat clas
quietly predict oos_13, pr
quietly gen pred_oos_13 = 0
quietly replace pred_oos_13 = 1 if oos_13 >= .5
tab vote pred_oos_13
tab vote pred_oos_13 if counter==13

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 14, robust
estat clas
quietly predict oos_14, pr
quietly gen pred_oos_14 = 0
quietly replace pred_oos_14 = 1 if oos_14 >= .5
tab vote pred_oos_14
tab vote pred_oos_14 if counter==14

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 15, robust
estat clas
quietly predict oos_15, pr
quietly gen pred_oos_15 = 0
quietly replace pred_oos_15 = 1 if oos_15 >= .5
tab vote pred_oos_15
tab vote pred_oos_15 if counter==15

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 16, robust
estat clas
quietly predict oos_16, pr
quietly gen pred_oos_16 = 0
quietly replace pred_oos_16 = 1 if oos_16 >= .5
tab vote pred_oos_16
tab vote pred_oos_16 if counter==16

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 17, robust
estat clas
quietly predict oos_17, pr
quietly gen pred_oos_17 = 0
quietly replace pred_oos_17 = 1 if oos_17 >= .5
tab vote pred_oos_17
tab vote pred_oos_17 if counter==17

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 18, robust
estat clas
quietly predict oos_18, pr
quietly gen pred_oos_18 = 0
quietly replace pred_oos_18 = 1 if oos_18 >= .5
tab vote pred_oos_18
tab vote pred_oos_18 if counter==18

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 19, robust
estat clas
quietly predict oos_19, pr
quietly gen pred_oos_19 = 0
quietly replace pred_oos_19 = 1 if oos_19 >= .5
tab vote pred_oos_19
tab vote pred_oos_19 if counter==19

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 20, robust
estat clas
quietly predict oos_20, pr
quietly gen pred_oos_20 = 0
quietly replace pred_oos_20 = 1 if oos_20 >= .5
tab vote pred_oos_20
tab vote pred_oos_20 if counter==20

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 21, robust
estat clas
quietly predict oos_21, pr
quietly gen pred_oos_21 = 0
quietly replace pred_oos_21 = 1 if oos_21 >= .5
tab vote pred_oos_21
tab vote pred_oos_21 if counter==21

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 22, robust
estat clas
quietly predict oos_22, pr
quietly gen pred_oos_22 = 0
quietly replace pred_oos_22 = 1 if oos_22 >= .5
tab vote pred_oos_22
tab vote pred_oos_22 if counter==22

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 23, robust
estat clas
quietly predict oos_23, pr
quietly gen pred_oos_23 = 0
quietly replace pred_oos_23 = 1 if oos_23 >= .5
tab vote pred_oos_23
tab vote pred_oos_23 if counter==23

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 24, robust
estat clas
quietly predict oos_24, pr
quietly gen pred_oos_24 = 0
quietly replace pred_oos_24 = 1 if oos_24 >= .5
tab vote pred_oos_24
tab vote pred_oos_24 if counter==24

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 25, robust
estat clas
quietly predict oos_25, pr
quietly gen pred_oos_25 = 0
quietly replace pred_oos_25 = 1 if oos_25 >= .5
tab vote pred_oos_25
tab vote pred_oos_25 if counter==25

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 26, robust
estat clas
quietly predict oos_26, pr
quietly gen pred_oos_26 = 0
quietly replace pred_oos_26 = 1 if oos_26 >= .5
tab vote pred_oos_26
tab vote pred_oos_26 if counter==26

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 27, robust
estat clas
quietly predict oos_27, pr
quietly gen pred_oos_27 = 0
quietly replace pred_oos_27 = 1 if oos_27 >= .5
tab vote pred_oos_27
tab vote pred_oos_27 if counter==27

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 28, robust
estat clas
quietly predict oos_28, pr
quietly gen pred_oos_28 = 0
quietly replace pred_oos_28 = 1 if oos_28 >= .5
tab vote pred_oos_28
tab vote pred_oos_28 if counter==28

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 29, robust
estat clas
quietly predict oos_29, pr
quietly gen pred_oos_29 = 0
quietly replace pred_oos_29 = 1 if oos_29 >= .5
tab vote pred_oos_29
tab vote pred_oos_29 if counter==29

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 30, robust
estat clas
quietly predict oos_30, pr
quietly gen pred_oos_30 = 0
quietly replace pred_oos_30 = 1 if oos_30 >= .5
tab vote pred_oos_30
tab vote pred_oos_30 if counter==30

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 31, robust
estat clas
quietly predict oos_31, pr
quietly gen pred_oos_31 = 0
quietly replace pred_oos_31 = 1 if oos_31 >= .5
tab vote pred_oos_31
tab vote pred_oos_31 if counter==31

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 32, robust
estat clas
quietly predict oos_32, pr
quietly gen pred_oos_32 = 0
quietly replace pred_oos_32 = 1 if oos_32 >= .5
tab vote pred_oos_32
tab vote pred_oos_32 if counter==32

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 33, robust
estat clas
quietly predict oos_33, pr
quietly gen pred_oos_33 = 0
quietly replace pred_oos_33 = 1 if oos_33 >= .5
tab vote pred_oos_33
tab vote pred_oos_33 if counter==33

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 34, robust
estat clas
quietly predict oos_34, pr
quietly gen pred_oos_34 = 0
quietly replace pred_oos_34 = 1 if oos_34 >= .5
tab vote pred_oos_34
tab vote pred_oos_34 if counter==34

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 35, robust
estat clas
quietly predict oos_35, pr
quietly gen pred_oos_35 = 0
quietly replace pred_oos_35 = 1 if oos_35 >= .5
tab vote pred_oos_35
tab vote pred_oos_35 if counter==35

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 36, robust
estat clas
quietly predict oos_36, pr
quietly gen pred_oos_36 = 0
quietly replace pred_oos_36 = 1 if oos_36 >= .5
tab vote pred_oos_36
tab vote pred_oos_36 if counter==36

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 37, robust
estat clas
quietly predict oos_37, pr
quietly gen pred_oos_37 = 0
quietly replace pred_oos_37 = 1 if oos_37 >= .5
tab vote pred_oos_37
tab vote pred_oos_37 if counter==37

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 38, robust
estat clas
quietly predict oos_38, pr
quietly gen pred_oos_38 = 0
quietly replace pred_oos_38 = 1 if oos_38 >= .5
tab vote pred_oos_38
tab vote pred_oos_38 if counter==38

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 39, robust
estat clas
quietly predict oos_39, pr
quietly gen pred_oos_39 = 0
quietly replace pred_oos_39 = 1 if oos_39 >= .5
tab vote pred_oos_39
tab vote pred_oos_39 if counter==39

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 40, robust
estat clas
quietly predict oos_40, pr
quietly gen pred_oos_40 = 0
quietly replace pred_oos_40 = 1 if oos_40 >= .5
tab vote pred_oos_40
tab vote pred_oos_40 if counter==40

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 41, robust
estat clas
quietly predict oos_41, pr
quietly gen pred_oos_41 = 0
quietly replace pred_oos_41 = 1 if oos_41 >= .5
tab vote pred_oos_41
tab vote pred_oos_41 if counter==41

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 42, robust
estat clas
quietly predict oos_42, pr
quietly gen pred_oos_42 = 0
quietly replace pred_oos_42 = 1 if oos_42 >= .5
tab vote pred_oos_42
tab vote pred_oos_42 if counter==42

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 43, robust
estat clas
quietly predict oos_43, pr
quietly gen pred_oos_43 = 0
quietly replace pred_oos_43 = 1 if oos_43 >= .5
tab vote pred_oos_43
tab vote pred_oos_43 if counter==43

quietly probit vote eucdist114 lackqual dist_qual strongp outparty  if counter != 44, robust
estat clas
quietly predict oos_44, pr
quietly gen pred_oos_44 = 0
quietly replace pred_oos_44 = 1 if oos_44 >= .5
tab vote pred_oos_44
tab vote pred_oos_44 if counter==44

quietly gen pred_oos_all = .
quietly replace pred_oos_all = 	pred_oos_1	if counter==1
quietly replace pred_oos_all = 	pred_oos_2	if counter==2
quietly replace pred_oos_all = 	pred_oos_3	if counter==3
quietly replace pred_oos_all = 	pred_oos_4	if counter==4
quietly replace pred_oos_all = 	pred_oos_5	if counter==5
quietly replace pred_oos_all = 	pred_oos_6	if counter==6
quietly replace pred_oos_all = 	pred_oos_7	if counter==7
quietly replace pred_oos_all = 	pred_oos_8	if counter==8
quietly replace pred_oos_all = 	pred_oos_9	if counter==9
quietly replace pred_oos_all = 	pred_oos_10	if counter==10
quietly replace pred_oos_all = 	pred_oos_11	if counter==11
quietly replace pred_oos_all = 	pred_oos_12	if counter==12
quietly replace pred_oos_all = 	pred_oos_13	if counter==13
quietly replace pred_oos_all = 	pred_oos_14	if counter==14
quietly replace pred_oos_all = 	pred_oos_15	if counter==15
quietly replace pred_oos_all = 	pred_oos_16	if counter==16
quietly replace pred_oos_all = 	pred_oos_17	if counter==17
quietly replace pred_oos_all = 	pred_oos_18	if counter==18
quietly replace pred_oos_all = 	pred_oos_19	if counter==19
quietly replace pred_oos_all = 	pred_oos_20	if counter==20
quietly replace pred_oos_all = 	pred_oos_21	if counter==21
quietly replace pred_oos_all = 	pred_oos_22	if counter==22
quietly replace pred_oos_all = 	pred_oos_23	if counter==23
quietly replace pred_oos_all = 	pred_oos_24	if counter==24
quietly replace pred_oos_all = 	pred_oos_25	if counter==25
quietly replace pred_oos_all = 	pred_oos_26	if counter==26
quietly replace pred_oos_all = 	pred_oos_27	if counter==27
quietly replace pred_oos_all = 	pred_oos_28	if counter==28
quietly replace pred_oos_all = 	pred_oos_29	if counter==29
quietly replace pred_oos_all = 	pred_oos_30	if counter==30
quietly replace pred_oos_all = 	pred_oos_31	if counter==31
quietly replace pred_oos_all = 	pred_oos_32	if counter==32
quietly replace pred_oos_all = 	pred_oos_33	if counter==33
quietly replace pred_oos_all = 	pred_oos_34	if counter==34
quietly replace pred_oos_all = 	pred_oos_35	if counter==35
quietly replace pred_oos_all = 	pred_oos_36	if counter==36
quietly replace pred_oos_all = 	pred_oos_37	if counter==37
quietly replace pred_oos_all = 	pred_oos_38	if counter==38
quietly replace pred_oos_all = 	pred_oos_39	if counter==39
quietly replace pred_oos_all = 	pred_oos_40	if counter==40
quietly replace pred_oos_all = 	pred_oos_41	if counter==41
quietly replace pred_oos_all = 	pred_oos_42	if counter==42
quietly replace pred_oos_all = 	pred_oos_43	if counter==43
quietly replace pred_oos_all = 	pred_oos_44	if counter==44
lab var pred_oos_all "Out-of-Sample Forecasts"

save "C:\Users\mmak\Desktop\Forecasting 2016 RP v2 Segal Forecasts.dta"

log close _all
