/* 
THIS IS A SAMPLE COUNTRY DO FILE FOR CREATING ETHNIC VOTING AND ETHNIC PARTIES SCORES
THIS EXAMPLE IS FROM AFROBAROMETER ROUND 3 FOR BENIN.

THE DO FILE CREATES FOUR DIFFERENT DEFINITIONS OF GROUP:  FEARON, RELIGION, ETHNICITY2, AND LANGUAGE2.  
IT THEN RUNS A DO FILE CALLED "voting_measures.do" FOR EACH DEFINITION OF GROUP.  

NOTE ONE NEEDS TO OBTAIN THE SURVEY DATA FROM AFROBAROMETER TO RUN THIS FILE.  THE DATA FILE "round3use.dta"
THAT IS LOADED BELOW IS JUST THE AFROBAROMETER'S ROUND 3 DATA FILE, BUT WITH ALL UNNECESSARY VARIABLES DELETED

*/




clear
clear matrix

set mem 1000m

/* ###  LOAD SURVEY DATA  */

use round3use, clear


*  ### This local is used for creating data file names below
local svy benin

* ### Keep relevant survey here
keep if country==1
tab country
tab dateintr //To find year of survey


/* ### Check the weight variable -- is one included?  If so, expand the data set
with the weight (choosing a manageable integer so the data set does not get too large)

*/


sum withinwt  //  none used

* Commenting out expansion by weight since none use
*gen temp=withinwt*100
*gen weight=int(temp)
*expand weight



/*****************
  GROUP CHOICE: There are three variables to create, plus fearon
  
  
              storage  display     value
variable name   type   format      label      variable label
--------------------------------------------------------------------------------------------------------------------------------------------------
  language q3              float  %9.0g       q3         q3. language of respondent
ethnicit q79             float  %9.0g       q79        q79. tribe or ethnic group
religion q91             float  %9.0g       q91        q91. religion of respondent


### List Fearon  groups here:
use fearon, clear

country	group	gpro
BENIN	Fon	0.555
BENIN	Bargu	0.225
BENIN	Yoruba-Nagot	0.136
BENIN	Peul (Fulani)	0.024


### tab each of the 4 variables above and create code this in comment

tab q3, sort
tab q3, nolab sort
tab q79, sort
tab q79, nolab sort
tab q91, sort 
tab q91, nolab sort


. tab q3

q3. language of respondent |      Freq.     Percent        Cum.
---------------------------+-----------------------------------
                       fon |        510       42.57       42.57
                      adja |        181       15.11       57.68
                    bariba |        125       10.43       68.11
                     dendi |         38        3.17       71.29
                    yoruba |        146       12.19       83.47
                  ditamari |         83        6.93       90.40
                     peulh |         57        4.76       95.16
                       yom |         53        4.42       99.58
                   haoussa |          3        0.25       99.83
                       ide |          1        0.08       99.92
                     lamba |          1        0.08      100.00
---------------------------+-----------------------------------
                     Total |      1,198      100.00

. tab q3, nolab

        q3. |
language of |
 respondent |      Freq.     Percent        Cum.
------------+-----------------------------------
        120 |        510       42.57       42.57
        121 |        181       15.11       57.68
        122 |        125       10.43       68.11
        123 |         38        3.17       71.29
        124 |        146       12.19       83.47
        125 |         83        6.93       90.40
        126 |         57        4.76       95.16
        127 |         53        4.42       99.58
        128 |          3        0.25       99.83
        129 |          1        0.08       99.92
        130 |          1        0.08      100.00
------------+-----------------------------------
      Total |      1,198      100.00

gen language2=q3
recode language2 128/130=. 120=1 121=2 122=3 123=4 124=5 125=6 126=7 127=8
// 1=fon 2=adja 3=bariba 4=dendi 5=yoruba 6=ditamari 7= peulh 8=yom


. tab q79

      q79. tribe or ethnic group |      Freq.     Percent        Cum.
---------------------------------+-----------------------------------
                             fon |        500       41.74       41.74
                            adja |        188       15.69       57.43
                          bariba |        125       10.43       67.86
                           dendi |         39        3.26       71.12
                          yoruba |        147       12.27       83.39
                        ditamari |         86        7.18       90.57
                           peulh |         54        4.51       95.08
                             yoa |         54        4.51       99.58
                         haoussa |          3        0.25       99.83
                             ide |          1        0.08       99.92
                           lamba |          1        0.08      100.00
---------------------------------+-----------------------------------
                           Total |      1,198      100.00

. tab q79, nolab

 q79. tribe |
  or ethnic |
      group |      Freq.     Percent        Cum.
------------+-----------------------------------
        120 |        500       41.74       41.74
        121 |        188       15.69       57.43
        122 |        125       10.43       67.86
        123 |         39        3.26       71.12
        124 |        147       12.27       83.39
        125 |         86        7.18       90.57
        126 |         54        4.51       95.08
        127 |         54        4.51       99.58
        128 |          3        0.25       99.83
        129 |          1        0.08       99.92
        130 |          1        0.08      100.00
------------+-----------------------------------
      Total |      1,198      100.00



gen ethnicity2=q3
recode ethnicity2 128/130=. 120=1 121=2 122=3 123=4 124=5 125=6 126=7 127=8
// 1=fon 2=adja 3=bariba 4=dendi 5=yoruba 6=ditamari 7= peulh 8=yoa

gen fearon=q79
recode fearon 120=1 121=. 122 =2 123=. 124=3 125=. 126=4 127/130=.
//1=Fon, 2=Bargu (Bariba) 3=Yoruba 4= Peulh
//Note all Fearon groups included

. tab q91

            q91. religion of respondent |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                                missing |          1        0.08        0.08
                                   none |         74        6.18        6.26
                               catholic |        428       35.73       41.99
                protestant (mainstream) |         45        3.76       45.74
   protestant (evangelical/pentecostal) |         81        6.76       52.50
             african independent church |         11        0.92       53.42
                   traditional religion |        191       15.94       69.37
                                  hindu |          1        0.08       69.45
      atheist (do not believe in a god) |          4        0.33       69.78
              christian (general/other) |         84        7.01       76.79
                          muslim, sunni |        262       21.87       98.66
                         muslim, shiite |         11        0.92       99.58
                      jehovah's witness |          1        0.08       99.67
                             don't know |          4        0.33      100.00
----------------------------------------+-----------------------------------
                                  Total |      1,198      100.00

. tab q91, nolab

       q91. |
religion of |
 respondent |      Freq.     Percent        Cum.
------------+-----------------------------------
         -1 |          1        0.08        0.08
          0 |         74        6.18        6.26
          2 |        428       35.73       41.99
          3 |         45        3.76       45.74
          4 |         81        6.76       52.50
          5 |         11        0.92       53.42
          6 |        191       15.94       69.37
          7 |          1        0.08       69.45
          9 |          4        0.33       69.78
         10 |         84        7.01       76.79
         11 |        262       21.87       98.66
         12 |         11        0.92       99.58
         13 |          1        0.08       99.67
        999 |          4        0.33      100.00
------------+-----------------------------------
      Total |      1,198      100.00

gen religion2=q91
recode religion2 -1=.  2=1 3=2 4=3 5=. 6=4 7=. 9=. 10=5 11=6 0=7 12/999=.

/// 1=catholic 2=protestant (mainstream) 3=protestant (evangelical) 4=traditional religion
5=christian (general/other) 6=muslim, sunni 7=none





  
*******************/


/* #### Create codes that will be used  */

gen language2=q3
recode language2 128/130=. 120=1 121=2 122=3 123=4 124=5 125=6 126=7 127=8
// 1=fon 2=adja 3=bariba 4=dendi 5=yoruba 6=ditamari 7= peulh 8=yom

gen ethnicity2=q3
recode ethnicity2 128/130=. 120=1 121=2 122=3 123=4 124=5 125=6 126=7 127=8
// 1=fon 2=adja 3=bariba 4=dendi 5=yoruba 6=ditamari 7= peulh 8=yoa

gen fearon=q79
recode fearon 120=1 121=. 122 =2 123=. 124=3 125=. 126=4 127/130=.
//1=Fon, 2=Bargu (Bariba) 3=Yoruba 4= Peulh

gen religion2=q91
recode religion2 -1=.  2=1 3=2 4=3 5=. 6=4 7=. 9=. 10=5 11=6 0=7 12/999=.

  

*  #####  create vote variables -- in this case we can use party of lower house vote, which exists
tab q99, miss
tab q99, miss nola
recode q99 (995 997/999=.) // treating large number of refusers and don't knows as missing

gen vote=q99
gen voters=q99~=.
save `svy'_vote, replace


/* We need to caculate the measures of each group variable that was created above.  For each
group there will be a new line of data in its own data set that contains the various group-based voting variables
that we create.  


*/



local asdf group
*********############ RUN FOR ETHNICITY2


use `svy'_vote, clear

*### SET GROUPTYPE
gen group=ethnicity2


do voting_measures

/* Create common variable names */



* ### label groups if this variable is used
// 1=fon 2=adja 3=bariba 4=dendi 5=yoruba 6=ditamari 7= peulh 8=yoa



gen `asdf'_1="fon"
gen `asdf'_2="adja"
gen `asdf'_3="bariba"
gen `asdf'_4="dendi"
gen `asdf'_5="yoruba"
gen `asdf'_6="ditamari"
gen `asdf'_7="peulh"
gen `asdf'_8="yoa"
keep if _n==1	
gen grouptype="ethnicity2"
sort country
save `svy'_ethnicity2, replace








**********############# RUN FOR LANGUAGE2

use `svy'_vote, clear
*### SET GROUPTYPE
gen group=language2

do voting_measures


/* Create common variable names */




gen `asdf'_1="fon"
gen `asdf'_2="adja"
gen `asdf'_3="bariba"
gen `asdf'_4="dendi"
gen `asdf'_5="yoruba"
gen `asdf'_6="ditamari"
gen `asdf'_7="peulh"
gen `asdf'_8="yoa"

keep if _n==1	
sort country
gen grouptype="language2"
save `svy'_language2, replace
	









****############ RUN FOR RELIGION2

use `svy'_vote, clear

*### SET GROUPTYPE
gen group=religion2


do voting_measures

/* Create common variable names */



* ### label groups if this variable is used
/* 1= orthodox */
/* 2= muslim */


/* 1=catholic 2=protestant (mainstream) 3=protestant (evangelical) 4=traditional religion
5=christian (general/other) 6=muslim, sunni 7=none */


gen `asdf'_1="catholic"
gen `asdf'_2="protestant (mainstream)"
gen `asdf'_3="protestant (evangelical)"
gen `asdf'_4="traditional religion"
gen `asdf'_5="christian (general/other)"
gen `asdf'_6="muslim, sunni"
gen `asdf'_7="none"

keep if _n==1	
sort country
gen grouptype="religion2"
save `svy'_religion2, replace








***############## RUN FOR FEARON

use `svy'_vote, clear

*### SET GROUPTYPE
gen group=fearon


do voting_measures


//1=Fon, 2=Bargu (Bariba) 3=Yoruba 4= Peulh

* ### label groups if this variable is used
gen `asdf'_1="Fon"
gen `asdf'_2="Bargu (Bariba)"
gen `asdf'_3="Yoruba"
gen `asdf'_4="Peulh"

keep if _n==1	
sort country
gen grouptype="fearon"
save `svy'_fearon, replace






*####### Merging -- bracket out those not used

use `svy'_language2, clear

append using `svy'_ethnicity2

sort country

append using `svy'_religion2

sort country

append using `svy'_fearon

sort country



**##########  country-specific info

drop country
gen  country="Benin"
gen year=2005  //from dateintr
gen ccode= 204
gen survey="Afrobar"

order country year ccode 
save benin05_voting, replace


***#############  erase uneeded files

cap erase "`svy'_ethnicity2.dta"
cap erase "`svy'_religion2.dta"
cap erase "`svy'_fearon.dta"
cap erase "`svy'_vote.dta"
cap erase "`svy'_language2.dta"

	
	
	
	


	
	
	
	

	
	
	
