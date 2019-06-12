*******************************************************************************
******************************Danish replication files*************************
*******************************************************************************
******Article "It's a group thing: How voters go to the polls together"********
*************Yosef Bhatti, Edward Fieldhouse and Kasper M. Hansen**************
*********************accepted in Political Behavior 2018***********************
*******************************************************************************
*****************************used Stata version 14.2***************************
*******************************************************************************

***********************************Municipal elections*************************
*******************************************************************************
******Add English labels for key variables*****
*cd [add your own directory]

use "replication file_DK1.dta", clear

label var Spm19 "Voting mode"
label var Spm03 "Voting"
label var wgt_np "Weight"
label var Spm20a "Voted with family member on the same adr"
label var Spm20b "Voted with family member on other adr"
label var Spm20c "Voted with someone else on the same adr"
label var Spm20d "Voted with friend on other adr"
label var Spm20e "Voted with neighbour"
label var Spm20f "Voted with colleague"
label var Spm20g "Voted with non-eligible individual (e.g. child)"
label var Spm20h "Voted with someone else not mentioned in the other categories"
label var Spm56 "Civic status"
label var Spm47 "Age in years"
label var Spm46 "Gender"
label var Spm51a "Individuals in HH under 6 years"
label var Spm51b "Individuals in HH 6-15 years"
label var Spm51c "Individuals in HH 16-19 years"
label var Spm50 "No. of individuals in HH"
label var Spm57 "Education"
label var Spm58 "Household income in DKK"

label define Spm03 1 "Yes" 2 "No" 3 "Not eligible" 4 "Does not want to answer", modify
label define Spm19 1 "Visited the polling place on my own" 2 "Visited the polling place with someone who did not vote" 3 "Visited the polling place with someone who voted" 4 "Does not want to answer", modify
label define Spm56 1 "Not married" 2 "Married" 3 "Lives with partner" 4 "Divorced etc." 5 "Widow/widower", modify

*Calculate voting together (table 2, DK2013)*
replace Spm19=0 if Spm03==2 // Non-voters get separate category
recode Spm19 (0=0 "non-voter") (1=1 "Votes alone") (2/3=2 "votes together") (4/99=.), gen(voteog) lab(voteog) // 0=non-voter, 1=votes alone, 2=votes together
*tab voteog [aw=wgt_np] // Everyone
tab voteog [aw=wgt_np] if voteog!=0 // Only voters

**Recodes of other variables for table A4**
recode Spm56 (2=1) (.=.) (else=0), gen(married) // Married 
gen age=Spm47 // age in years
recode Spm46 (2=1) (1=0), gen(female) // Gender dummy
gen hhchildren=Spm51a+Spm51b+Spm51c // Children here calculated as individuals in household aged 6-, 6-15, 16-19 
replace hhchildren=hhchildren-1 if (age==18 | age==19) & (hhchildren>0) // We cannot identify no. of individuals 18-19, but we subtract 1 if the person herself is 18-19
replace hhchildren=0 if Spm50==1 // HH hize 1 individuals were in general not asked the question (as the answer would be self-evident)
gen hhsize=Spm50-hhchildren // We calculate HH size of adults by taking the total HH size and subtract children
recode hhsize (-10/1=1) (2=2) (3=3) (4/100=4) // 6 individuals provided non-sensical answers (hhsize-children<1). These are recoded as 1.
recode Spm57 (1=1 "School") (2/3=2 "High school") (4/5=5 "Other (vocational/short higher)") (6/7=3 "BA or equiv.") (8/9=4 "Postgrad") (10=.), gen(educ)  // Note the question is latest education, not highest.
recode Spm58 (1=0.5) (2=1.5) (3=2.5) (4=3.5) (5=4.5) (6=5.5) (7=6.5) (8=7.5) (9=8.5) (10=9.5) (11=11.125) (12=13.75) (13=16.25) (14=18.750) (15=25.0) (16=.), gen(hhincome)  // Midpoint for 2+ million is set to 2.5 million

*Mlogit (appendix, table A4, DK2013)*
eststo clear
eststo m1: mlogit voteog i.hhsize i.married i.female c.age##c.age##c.age i.educ hhincome hhchildren if hhsize>1 [pw=wgt_np], baseoutcome(1)
estimates store m1

*Calculate the share of voting together that voted with household members (for remark in the text)
gen q20_HH=.
replace q20_HH=1 if Spm20a==1 | Spm20c==1
gen q20_nonHH=.
replace q20_nonHH=1 if Spm20d==1 | Spm20b==1 | Spm20e==1 | Spm20f==1 | Spm20h==1 // A non-eligible individual is not included in any of the categories

gen q20=.
replace q20=1 if q20_HH==1
replace q20=2 if q20_nonHH==1
replace q20=3 if q20_HH==1 & q20_nonHH==1
replace q20=99 if q20_HH==. & q20_nonHH==. & voteog==2
tab q20 
label define q20 1 "Only with HH members" 2 "Only with non-HH members" 3 "Both with HH and non-HH members" 99 "No answer/other answer"
label values q20 q20
tab q20 [aw=wgt_np]

*******************************************************************************
***********************************Parliament election*************************
*******************************************************************************
********Takes full dataset and selects the variables needed********************
******Add English labels for key variables*****
use "replication file_DK2.dta", clear

label var q17_1 "Voting mode"
label var weight_1 "Weight"
label var q15 "Party choice/Turnout" // 13 is non-voters
label var q18_1 "Voting partner type I"
label var q18_2 "Voting partner type II"
label var q18_3 "Voting partner type III"
label var q18_4 "Voting partner type IV"
label var q4 "Civic status/HH type"
label var q2 "Year of birth"
label var q1 "Gender"
label var q3 "No of children in HH"
label var q106 "Education"
label var q104 "School education"
label var q87 "HH income in DKK"

label define q17 1 "Visited the polling place alone" 2 "Visited the polling place with one or more non-voters" 3 "Visited the polling place with one or more voters" 8 "Does not know" 9 "Does not want to answer", modify
label define q4 1 "Lives with someone married to" 2 "Lives with a partner (not married)" 3 "Does not live with a partner" 9 "Does want to answer", modify
label define q18 1 "One or more family members living at my adr" 2 "One or more family members living at other adr" 3 "Someone else living at my adr" 4 "A friend not living at my adr" 5 "A neighbour" ///
6 "A colleague/friend from studies" 7 "One or more non-eligible individuals (e.g. a child)" 8 "Someone else not mentioned above", modify

*Calculate voting together (table 2, DK2015)*
replace q17_1=0 if q15==13 // Non-voters get separate category
recode q17_1 (0=0 "Non-voter") (1=1 "Voters alone") (3=2 "Voters together") (8/9=.), gen(voteog) lab (voteog) // 0=non-voter, 1=votes alone, 2=votes together
*tab voteog  [aw=weight_1] // everyone
tab voteog if voteog!=0 [aw=weight_1] // only voters

**Recodes of other variables for table A4**
recode q4 (1=1) (9 .=.) (else=0), gen(married) // Married 
recode q2 (99=.)
gen age=2015-q2 // Age estimated from birth year
recode q1 (2=1) (1=0), gen(female) // Gender dummy
recode q3 (99=.), gen(hhchildren) // Children i HH. No information about adults.
 
recode q106 (1/7 11=5 "Other (vocational/short higher)") (8/9=3 "BA or equiv.") (10=4 "Postgrad") (88/99=.), gen(educ) // q106 gives us education for those who have at least vocational education 
replace educ=1 if educ==. & q104<=4 // For those who do not have further education, we note if they had school as their highest education ("realeksamen" is counted as school, not high school)
replace educ=2 if educ==. & q104>=5 & q104<=8 // High school or equiv.
replace educ=1 if educ==. & q104==9 // Ongoing school education is coded as school
replace educ=5 if educ==. & q104==10 // Other is coded as "other"
label define educ 1 "School" 2 "High school", modify
recode q87 (1=0.5) (2=1.25) (3=1.75) (4=2.25) (5=2.75) (6=3.25) (7=3.75) (8=4.25) (9=4.75) (10=5.5) (11=6.5) (12=7.5) (13=8.5) (14=9.5) (15=1.05) (16=1.15) (17=1.25) (18=1.35) (19=1.45) (20=1.75) (88/99=.), gen(hhincome)  // Midpoint for 1.5+ million is set to 1.75 million

**Mlogit (appendix, table A4, DK2015)*
eststo m2: mlogit voteog i.married i.female c.age##c.age##c.age i.educ hhincome hhchildren [pw=weight_1], baseoutcome(1) // No question about immgigrant status or HH size
estimates store m2

esttab m1 m2 using danish.rtf, replace unstack c(b(star fmt(%12.2f)) se(par fmt(%12.3f))) s(N r2_p ll chi2) nogaps


*Calculate the share of voting together that voted with household members (for remark in the text)
gen q18_HH=.
replace q18_HH=1 if inlist(q18_1, 1, 3)==1 | inlist(q18_2, 1, 3)==1 | inlist(q18_3, 1, 3)==1 | inlist(q18_4, 1, 3)==1
gen q18_nonHH=.
replace q18_nonHH=1 if inlist(q18_1, 2, 4, 5, 6, 8)==1 | inlist(q18_2, 2, 4, 5, 6, 8)==1 | inlist(q18_3, 2, 4, 5, 6, 8)==1 | inlist(q18_4, 2, 4, 5, 6, 8)==1 // A non-eligible individual is not included in any of the categories

gen q18=.
replace q18=1 if q18_HH==1
replace q18=2 if q18_nonHH==1
replace q18=3 if q18_HH==1 & q18_nonHH==1
replace q18=99 if q18_HH==. & q18_nonHH==. & voteog==2
tab q18 
label define label_q18 1 "Only with HH members" 2 "Only with non-HH members" 3 "Both with HH and non-HH members" 99 "No answer"
label values q18 label_q18
tab q18 [aw=weight_1]
