*Ansolabehere and Hersh
*CCES-Catalist Validation comparison to NES Validation
*Replication for publication in Political Analysis 


use VCF0004 VCF9150 VCF9151 VCF9155 VCF9153 VCF9152 VCF0703 ///
VCF0140a VCF0114 VCF0106a VCF0147 VCF0130 VCF0101 VCF0803 VCF0104 VCF0313 VCF0303 VCF0301 VCF0010a VCF9001 ///
 if VCF0004 == 1980 | VCF0004 == 1984 | VCF0004 == 1988 using  NES_CUMULATIVE_062410.dta, clear

gen year = VCF0004


*VALIDATION VARIABLES

gen val_reg = VCF9150 
recode val_reg 1 2 =1 3= 0 0=.

gen rep_vote = VCF9151
recode rep_vote 0 9=. 1=1 5 8=0 

gen val_vote = VCF9155
recode val_vote 1=1 3 5=0 nonmis =.  	

replace val_vote =. if VCF9153 == 3 | VCF9153 == 5

replace val_vote = 0 if VCF9152 == 2
*Validation not possible for these records

gen rep_reg = VCF0703
recode rep_reg 2 3 =1 1 =0 nonmis =. 


************
***TABLE 1****
bysort year: tab rep_vote val_vote, row col 
************

*Demographic controls 
gen edu = VCF0140a
recode edu 8 9 =.
recode edu 1 2 =0 3=1 4 5= 2 6=3 7=4
gen income = VCF0114
recode income 0=. 5=4
gen race = VCF0106a
recode race 0=.
gen white = race == 1 
replace white =. if race ==.
gen black = race == 2 
replace black =. if race == .
gen other_nonwhite =1 if race == 3 | race == 4 | race == 5 | race == 7
replace other = 0 if race == 1 | race ==2
gen married = VCF0147
recode married 1=1 2 3 4 5 7 8 = 0 9 =.
gen attend = 	VCF0130
recode attend 8 9 =.  5 7 0 = 0 4=1 3 2=2 1=3
gen age = VCF0101
recode age 0=.
gen ideo_strength = VCF0803
recode ideo_s 0=. 9 4 = 0 2 3 5 6 =1 1 7 =2
gen female = VCF0104 - 1
gen polinter = VCF0313
recode polinter 9 1  =0 0 =. 2=1 3=2 4=3
gen dem = VCF0303 ==1
gen rep = VCF0303 ==3
recode dem rep (0=.) if VCF0303 == 0
gen partisan_strength = 0 if VCF0301 == 0 | VCF0301 == 4
replace partisan_strength = 1 if VCF0301 == 3 | VCF0301 == 5
replace partisan_strength = 2 if VCF0301 == 2 | VCF0301 == 6
replace partisan_strength = 3 if VCF0301 == 1  | VCF0301 == 7
gen recentmover = VCF9001
recode recentmover 0 1 =1 99 = . nonmis =0
gen weight08 = VCF0010a
gen yr84 = 1 if year == 1984
replace yr84 = 0 if year == 1980 | year == 1988
gen yr88 = 1 if year == 1988
replace yr88 = 0 if year == 1984 | year == 1980
gen agecoh1 =1 if age > 17 & age <=24
recode agecoh1 .=0 if age !=.
gen agecoh2 =1 if age >= 25 & age <=34
recode agecoh2 .=0 if age !=.
gen agecoh3 =1 if age >= 35 & age <=44
recode agecoh3 .=0 if age !=.
gen agecoh4 =1 if age >= 45 & age <=54
recode agecoh4 .=0 if age !=.
gen agecoh5 =1 if age >= 55 & age !=.
recode agecoh5 .=0 if age !=.



***********
*TABLE 2***
reg rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent yr84 yr88 if val_vote == 0

*For appendix table 8
logit rep_vote edu income black other_non married attend agecoh2 agecoh3 agecoh4 agecoh5 ideo_str female polinter partisan_strength recent yr84 yr88 if val_vote == 0
***********

*APPENDIX
*Summary statistics 
sum rep_vote val_vote edu income white black other_non married attend agecoh1-agecoh5 ideo_str female polinter partisan_s recent
