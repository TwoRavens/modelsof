***** Stata Commands for Burnett, Parry, and Barth

*2014 Data Analysis

use "Arkansas 2014 Data.dta"

*Recoding

gen party_id=.
replace party_id=-1 if Q34==2
replace party_id=0 if Q34==3
replace party_id=1 if Q34==1

gen democrat=.
replace democrat=1 if party_id==-1
replace democrat=0 if party_id==1
replace democrat=0 if party_id==0

gen republican=.
replace republican=1 if party_id==1
replace republican=0 if party_id==-1
replace republican=0 if party_id==0

gen ideology=.
replace ideology=-1 if Q35==1
replace ideology=0 if Q35==2
replace ideology=1 if Q35==3

gen liberal=.
replace liberal=1 if ideology==-1
replace liberal=0 if ideology==0
replace liberal=0 if ideology==1

gen conservative=.
replace conservative=1 if ideology==1
replace conservative=0 if ideology==-1
replace conservative=0 if ideology==0

gen white=.
replace white=1 if Q21==1
replace white=0 if Q21<=7 & Q21>=2

gen attention_politics=.
replace attention_politics=4 if Q81==1
replace attention_politics=3 if Q81==2
replace attention_politics=2 if Q81==3
replace attention_politics=1 if Q81==4
replace attention_politics=0 if Q81==5

gen know_speaker=.
replace know_speaker=1 if Q78==3
replace know_speaker=0 if Q78!=3

gen senate_term=.
replace senate_term=1 if Q79==3
replace senate_term=0 if Q79!=3

gen judge_noms=.
replace judge_noms=1 if Q80==1
replace judge_noms=0 if Q80!=1

gen political_knowledge=((know_speaker + senate_term + judge_noms)/3)

gen age=(2014-Q48)

*We collapse education into 5 categories to increase the number of respondents in the cells at the extreme ends

gen education_5cats=.
replace education_5cats=1 if Q20==1
replace education_5cats=1 if Q20==2
replace education_5cats=2 if Q20==3
replace education_5cats=3 if Q20==4
replace education_5cats=4 if Q20==5
replace education_5cats=5 if Q20==6
replace education_5cats=5 if Q20==7

gen attention_education=attention_politics*education_5cats

*Calculation of Correctly Identifying Measures
gen measure_id_1=.
replace measure_id_1=0 if Q63_1==7
replace measure_id_1=0 if Q63_1==6
replace measure_id_1=1 if Q63_1>=1 & Q63_1<=5

gen measure_id_2=.
replace measure_id_2=0 if measure_id_1!=.
replace measure_id_2=1 if Q63_2>=1 & Q63_2<=5

gen measure_id_3=.
replace measure_id_3=0 if measure_id_1!=.
replace measure_id_3=1 if Q63_3>=1 & Q63_3<=5

gen measure_id_4=.
replace measure_id_4=0 if measure_id_1!=.
replace measure_id_4=1 if Q63_4>=1 & Q63_4<=5

gen measure_id_5=.
replace measure_id_5=0 if measure_id_1!=.
replace measure_id_5=1 if Q63_5>=1 & Q63_5<=5

gen total_identified_measures= measure_id_1 + measure_id_2 + measure_id_3 + measure_id_4 + measure_id_5

gen ballot_measure_aware=0
replace ballot_measure_aware=-1 if total_identified_measures==0
replace ballot_measure_aware=1 if total_identified_measures>=1 & total_identified_measures<=5


gen identify_alcohol=0
replace identify_alcohol=1 if Q63_1==4
replace identify_alcohol=1 if Q63_2==4
replace identify_alcohol=1 if Q63_3==4
replace identify_alcohol=1 if Q63_4==4
replace identify_alcohol=1 if Q63_5==4

gen identify_termlimits=0
replace identify_termlimits=1 if Q63_1==3
replace identify_termlimits=1 if Q63_2==3
replace identify_termlimits=1 if Q63_3==3
replace identify_termlimits=1 if Q63_4==3
replace identify_termlimits=1 if Q63_5==3

gen identify_minwage=0
replace identify_minwage=1 if Q63_1==5
replace identify_minwage=1 if Q63_2==5
replace identify_minwage=1 if Q63_3==5
replace identify_minwage=1 if Q63_4==5
replace identify_minwage=1 if Q63_5==5

gen identify_nonexistent=0
replace identify_nonexistent=1 if Q63_1==6
replace identify_nonexistent=1 if Q63_2==6
replace identify_nonexistent=1 if Q63_3==6
replace identify_nonexistent=1 if Q63_4==6
replace identify_nonexistent=1 if Q63_5==6
replace identify_nonexistent=1 if Q63_6==6

gen identify_adminreview=0
replace identify_adminreview=1 if Q63_1==1
replace identify_adminreview=1 if Q63_2==1
replace identify_adminreview=1 if Q63_3==1
replace identify_adminreview=1 if Q63_4==1
replace identify_adminreview=1 if Q63_5==1
replace identify_adminreview=1 if Q63_6==1

gen identify_directdem=0
replace identify_directdem=1 if Q63_1==2
replace identify_directdem=1 if Q63_2==2
replace identify_directdem=1 if Q63_3==2
replace identify_directdem=1 if Q63_4==2
replace identify_directdem=1 if Q63_5==2


*Table 1

*Did not expect ballot measures
tab Q62
*404 out of 747 respondents did not expect a ballot measure

*Remaining rows:
tab total_identified_measures

*Table 2
tab identify_alcohol
tab identify_termlimits
tab identify_minwage
tab identify_nonexistent
tab identify_adminreview
tab identify_directdem

*Table 5 Regression Model

mlogit ballot_measure_aware attention_politics political_know conservative liberal republican democrat education_5cats age white attention_education, base(0)

*If the computer does not have SPOST installed, use the command "findit spost" and select the appropriate version to install

*Data for Figures 1-3

prtab education_5cats

prtab political_knowledge

prtab attention_politics

*2016 Data Analysis

clear

use "Arkansas 2016 Data.dta"

*Recoding Variables

*Calculation of Correctly Identifying Measures
gen measure_id_1=.
replace measure_id_1=0 if Q102_1==9
replace measure_id_1=0 if Q102_1==10
replace measure_id_1=0 if Q102_1==88
replace measure_id_1=0 if Q102_1==99
replace measure_id_1=1 if Q102_1>=1 & Q102_1<=8

gen measure_id_2=.
replace measure_id_2=0 if measure_id_1!=.
replace measure_id_2=1 if Q102_2>=1 & Q102_2<=8

gen measure_id_3=.
replace measure_id_3=0 if measure_id_1!=.
replace measure_id_3=1 if Q102_3>=1 & Q102_3<=8

gen measure_id_4=.
replace measure_id_4=0 if measure_id_1!=.
replace measure_id_4=1 if Q102_4>=1 & Q102_4<=8

gen measure_id_5=.
replace measure_id_5=0 if measure_id_1!=.
replace measure_id_5=1 if Q102_5>=1 & Q102_5<=8

gen measure_id_6=.
replace measure_id_6=0 if measure_id_1!=.
replace measure_id_6=1 if Q102_6>=1 & Q102_6<=8

gen measure_id_7=.
replace measure_id_7=0 if measure_id_1!=.
replace measure_id_7=1 if Q102_7>=1 & Q102_7<=8

gen measure_id_8=.
replace measure_id_8=0 if measure_id_1!=.
replace measure_id_8=1 if Q102_8>=1 & Q102_8<=8

gen total_identified_measures= measure_id_1 + measure_id_2 + measure_id_3 + measure_id_4 + measure_id_5  + measure_id_6  + measure_id_7  + measure_id_8

gen identify_4yrterms=0
replace identify_4yrterms=. if Q101B==.
replace identify_4yrterms=1 if Q102_1==1
replace identify_4yrterms=1 if Q102_2==1
replace identify_4yrterms=1 if Q102_3==1
replace identify_4yrterms=1 if Q102_4==1
replace identify_4yrterms=1 if Q102_5==1
replace identify_4yrterms=1 if Q102_6==1
replace identify_4yrterms=1 if Q102_7==1
replace identify_4yrterms=1 if Q102_8==1

gen identify_govpower=0
replace identify_govpower=. if Q101B==.
replace identify_govpower=1 if Q102_1==2
replace identify_govpower=1 if Q102_2==2
replace identify_govpower=1 if Q102_3==2
replace identify_govpower=1 if Q102_4==2
replace identify_govpower=1 if Q102_5==2
replace identify_govpower=1 if Q102_6==2
replace identify_govpower=1 if Q102_7==2
replace identify_govpower=1 if Q102_8==2

gen identify_econdev=0
replace identify_econdev=. if Q101B==.
replace identify_econdev=1 if Q102_1==3
replace identify_econdev=1 if Q102_2==3
replace identify_econdev=1 if Q102_3==3
replace identify_econdev=1 if Q102_4==3
replace identify_econdev=1 if Q102_5==3
replace identify_econdev=1 if Q102_6==3
replace identify_econdev=1 if Q102_7==3
replace identify_econdev=1 if Q102_8==3

gen identify_tort=0
replace identify_tort=. if Q101B==.
replace identify_tort=1 if Q102_1==8
replace identify_tort=1 if Q102_2==8
replace identify_tort=1 if Q102_3==8
replace identify_tort=1 if Q102_4==8
replace identify_tort=1 if Q102_5==8
replace identify_tort=1 if Q102_6==8
replace identify_tort=1 if Q102_7==8
replace identify_tort=1 if Q102_8==8

gen identify_gambling=0
replace identify_gambling=. if Q101B==.
replace identify_gambling=1 if Q102_1==7
replace identify_gambling=1 if Q102_2==7
replace identify_gambling=1 if Q102_3==7
replace identify_gambling=1 if Q102_4==7
replace identify_gambling=1 if Q102_5==7
replace identify_gambling=1 if Q102_6==7
replace identify_gambling=1 if Q102_7==7
replace identify_gambling=1 if Q102_8==7

gen identify_issue6=0
replace identify_issue6=. if Q101B==.
replace identify_issue6=1 if Q102_1==4
replace identify_issue6=1 if Q102_2==4
replace identify_issue6=1 if Q102_3==4
replace identify_issue6=1 if Q102_4==4
replace identify_issue6=1 if Q102_5==4
replace identify_issue6=1 if Q102_6==4
replace identify_issue6=1 if Q102_7==4
replace identify_issue6=1 if Q102_8==4

gen identify_issue7=0
replace identify_issue7=. if Q101B==.
replace identify_issue7=1 if Q102_1==5
replace identify_issue7=1 if Q102_2==5
replace identify_issue7=1 if Q102_3==5
replace identify_issue7=1 if Q102_4==5
replace identify_issue7=1 if Q102_5==5
replace identify_issue7=1 if Q102_6==5
replace identify_issue7=1 if Q102_7==5
replace identify_issue7=1 if Q102_8==5

gen identify_marijuana_generally=0
replace identify_marijuana_generally=. if Q101B==.
replace identify_marijuana_generally=1 if Q102_1==6
replace identify_marijuana_generally=1 if Q102_2==6
replace identify_marijuana_generally=1 if Q102_3==6
replace identify_marijuana_generally=1 if Q102_4==6
replace identify_marijuana_generally=1 if Q102_5==6
replace identify_marijuana_generally=1 if Q102_6==6
replace identify_marijuana_generally=1 if Q102_7==6
replace identify_marijuana_generally=1 if Q102_8==6

gen identify_nonexistent=0
replace identify_nonexistent=. if Q101B==.
replace identify_nonexistent=1 if Q102_1==9
replace identify_nonexistent=1 if Q102_2==9
replace identify_nonexistent=1 if Q102_3==9
replace identify_nonexistent=1 if Q102_4==9
replace identify_nonexistent=1 if Q102_5==9
replace identify_nonexistent=1 if Q102_6==9
replace identify_nonexistent=1 if Q102_7==9
replace identify_nonexistent=1 if Q102_8==9

*Table 3

*Did not expect ballot measures
tab Q101B
*211 out of 400 (52.8%) respondents did not expect a ballot measure

*Remaining rows:
tab total_identified_measures

*Table 4
tab identify_marijuana_generally
*To the total number of 107, add this number to Issue 6 and Issue 7, which are 24 and 31 respectively (52+24+31 = 107)

tab total_identified_measures
*This shows that 96 people could not identify a measure
tab identify_issue7
tab identify_gambling
tab identify_issue6
tab identify_nonexistent
tab identify_4yrterms
tab identify_econdev
tab identify_govpower
tab identify_tort

