*****NES

*User set directory

use "ANEScomplete.dta"

gen poll=2


keep VCF0004 VCF0140a VCF0901a VCF0101 VCF0106 VCF0104 VCF0834 VCF0834 VCF0225 VCF0837 VCF0838 VCF9006

save "NES_women.dta", replace


/*
VCF0834
Recently there has been a lot of talk about women's rights. Some people feel that women should have an equal role with men in running business, industry and government. (2004: (Suppose these people are
at one en of a scale, at point 1)) Others feel that a women's place is in the home. (2004: (Suppose these people are at the other end; at point 7.) And of course, some people have opinions somewhere in between, at points 2,3,4,5, or 6.)
1. Women and men should have an equal role
2.
3.
4.
5.
6.
7. Women's place is in the home
9. DK; haven't thought much about it
*/


gen rights=.
replace rights=1 if VCF0834==1
replace rights=1 if VCF0834==2
replace rights=1 if VCF0834==3
replace rights=0 if VCF0834==4
replace rights=0 if VCF0834==5
replace rights=0 if VCF0834==6
replace rights=0 if VCF0834==7
replace rights=0 if VCF0834==9



/*
VCF0834
Now I'd like to read some of the kinds of things people tell me when I
interview them, and ask you whether you agree or disagree with them.
I'll read them one at a time, and you just tell me whether you agree or
disagree with them, and whether you agree or disagree a little or quite
a bit.
1972 INTRO:
Do you agree or disagree with each of these two statements:
ALL YEARS:
'Women should stay out of politics'
1. Agree (1952: incl. "agree quite a bit" and "agree a
little")
2. Disagree (1952: incl. "disagree quite a bit" and
"disagree a little")
9. DK
*/


gen politics=.
replace politics=1 if VCF0836==2
replace politics=0 if VCF0836==1
replace politics=0 if VCF0836==9



/*
VCF0225
We'd also like to get your feelings about some groups in American
society. When I read the name of a group, we'd like you to rate it with
what we call a feeling thermometer. Ratings between 50 degrees-100
degrees mean that you feel favorably and warm toward the group; ratings
between 0 and 50 degrees mean that you don't feel favorably towards the
group and that you don't care too much for that group. If you don't
feel particularly warm or cold toward a group you would rate them at 50
degrees. If we come to a group you don't know much about, just tell me
and we'll move on to the next one.
*/


gen therm=.
replace therm=1 if VCF0225>50 & VCF0225<=97
replace therm=0 if VCF0225<=50 
replace therm=0 if VCF0225==98




/*
VCF0837 - "There has been some discussion about abortion during recent years.
Which one of the opinions on this page (1972: card) best agrees with
your view? You can just tell me the number of the opinion you choose.

VALID_CODES:
------------
1. Abortion should never be permitted.
2. Abortion should be permitted only if the life and
health of the woman is in danger.
3. Abortion should be permitted if, due to personal
reasons, the woman would have difficulty in caring
for the child.
4. Abortion should never be forbidden, since one should
not require a woman to have a child she doesn't
want.
9. DK; other"
*/

gen abortion=.
replace abortion=1 if VCF0837==4
replace abortion=1 if VCF0837==3
replace abortion=0 if VCF0837==1
replace abortion=0 if VCF0837==2
replace abortion=0 if VCF0837==9





/*
VCF0838 - "There has been some discussion about abortion during recent years.
(RESPONDENT BOOKLET) Which one of the opinions on this page best agrees
with your view? You can just tell me the number of the opinion you
choose.  1. By law, abortion should never be permitted.
2. The law should permit abortion only in case of rape,
incest, or when the woman's life is in danger.
3. The law should permit abortion for reasons other than
rape, incest, or danger to the woman's life, but only
after the need for the abortion has been clearly
established.
4. By law, a woman should always be able to obtain an
abortion as a matter of personal choice.
9. DK; other"
*/


gen abortion2=.
replace abortion2=1 if VCF0838==4
replace abortion2=0 if VCF0838==1
replace abortion2=0 if VCF0838==2
replace abortion2=0 if VCF0838==3
replace abortion2=0 if VCF0838==9




/*
VCF9006	Thermometer: women
*/

gen thermw=.
replace thermw=1 if VCF9006>50 & VCF9006<=97
replace thermw=0 if VCF9006<=50 
replace thermw=0 if VCF9006==98



gen sex=VCF0104
label var sex "Sex"

gen female=.
replace female=1 if sex==2
replace female=0 if sex==1 
label var female "Female"
label define femalelbl 0 "0 Male" 1 "1 Female"
label values female femalelbl 


gen race=VCF0106
label var race "Race"

label var race "Race"
label define racelbl 1 "1 White" 2 "2 Black" 3 "3 Other" 
label values race racelbl 


gen age=VCF0101
label var age "Age"

gen age_cat=.
replace age_cat=1 if age>=18 & age<=29
replace age_cat=2 if age>=30 & age<=44
replace age_cat=3 if age>=45 & age<=64
replace age_cat=4 if age>=65
label var age_cat "Age Categories"
label define agelbl 1 "1 18-29" 2 "2 30-44" 3 "3 45-64" 4 "4 65 plus"
label values age_cat agelbl



gen education=VCF0140a
label var education "Education" 

gen edu_cat=.
replace edu_cat=1 if education==1
replace edu_cat=1 if education==2
replace edu_cat=2 if education==3
replace edu_cat=2 if education==4
replace edu_cat=3 if education==5
replace edu_cat=4 if education>=6 & education<=7

label var edu_cat "Education Categories"
label define educlbl 1 "1 LT HS" 2 "2 HS Grad" 3 "3 Some Coll" 4 "4 Coll Grad"
label values edu_cat educlbl 


gen statefip=VCF0901a
gen state_initnum=. 

replace state_initnum=1 if statefip==2
replace state_initnum=2 if statefip==1
replace state_initnum=3 if statefip==5
replace state_initnum=4 if statefip==4
replace state_initnum=5 if statefip==6
replace state_initnum=6 if statefip==8
replace state_initnum=7 if statefip==9
replace state_initnum=8 if statefip==11
replace state_initnum=9 if statefip==10
replace state_initnum=10 if statefip==12
replace state_initnum=11 if statefip==13
replace state_initnum=12 if statefip==15
replace state_initnum=13 if statefip==19
replace state_initnum=14 if statefip==16
replace state_initnum=15 if statefip==17
replace state_initnum=16 if statefip==18
replace state_initnum=17 if statefip==20
replace state_initnum=18 if statefip==21
replace state_initnum=19 if statefip==22
replace state_initnum=20 if statefip==25
replace state_initnum=21 if statefip==24
replace state_initnum=22 if statefip==23
replace state_initnum=23 if statefip==26
replace state_initnum=24 if statefip==27
replace state_initnum=25 if statefip==29
replace state_initnum=26 if statefip==28
replace state_initnum=27 if statefip==30
replace state_initnum=28 if statefip==37
replace state_initnum=29 if statefip==38
replace state_initnum=30 if statefip==31
replace state_initnum=31 if statefip==33
replace state_initnum=32 if statefip==34
replace state_initnum=33 if statefip==35
replace state_initnum=34 if statefip==32
replace state_initnum=35 if statefip==36
replace state_initnum=36 if statefip==39
replace state_initnum=37 if statefip==40
replace state_initnum=38 if statefip==41
replace state_initnum=39 if statefip==42
replace state_initnum=40 if statefip==44
replace state_initnum=41 if statefip==45
replace state_initnum=42 if statefip==46
replace state_initnum=43 if statefip==47
replace state_initnum=44 if statefip==48
replace state_initnum=45 if statefip==49
replace state_initnum=46 if statefip==51
replace state_initnum=47 if statefip==50
replace state_initnum=48 if statefip==53
replace state_initnum=49 if statefip==55
replace state_initnum=50 if statefip==54
replace state_initnum=51 if statefip==56

label variable state_initnum "State ID"
label define statelbl 1 "1 AK" 2 "2 AL" 3 "3 AR" 4 "4 AZ" 5 "5 CA" 6 "6 CO" 7 "7 CT" 8 "8 DC" 9 "9 DE" 10 "10 FL" 11 "11 GA" 12 "12 HI" 13 "13 IA" 14 "14 ID" 15 "15 IL" 16 "16 IN" 17 "17 KS" 18 "18 KY" 19 "19 LA" 20 "20 MA" 21 "21 MD" 22 "22 ME" 23 "23 MI" 24 "24 MN" 25 "25 MO" 26 "26 MS" 27 "27 MT" 28 "28 NC" 29 "29 ND" 30 "30 NE" 31 "31 NH" 32 "32 NJ" 33 "33 NM" 34 "34 NV" 35 "35 NY" 36 "36 OH" 37 "37 OK" 38 "38 OR" 39 "39 PA" 40 "40 RI" 41 "41 SC" 42 "42 SD" 43 "43 TN" 44 "44 TX" 45 "45 UT" 46 "46 VA" 47 "47 VT" 48 "48 WA" 49 "49 WI" 50 "50 WV" 51 "51 WY"
label values state_initnum statelbl

gen year=VCF0004



*DIVIDE FILES BY YEAR


use "NES_women.dta"

keep if year==1972

save "1972/NES_1972.dta", replace


clear

use "NES_women.dta"

keep if year==1974

save "1974/NES_1974.dta", replace

clear



use "NES_women.dta"

keep if year==1976

save "1976/NES_1976.dta", replace 


clear


use "NES_women.dta"

keep if year==1978

save "1978/NES_1978.dta", replace

clear

use "NES_women.dta"

keep if year==1980

save "1980/NES_1980.dta", replace 

clear

use "NES_women.dta"

keep if year==1982

save "1982/NES_1982.dta", replace 

clear



use "NES_women.dta"

keep if year==1984

save "1984/NES_1984.dta", replace 

clear



use "NES_women.dta"

keep if year==1986

save "1986/NES_1986.dta" 

clear



use "NES_women.dta"

keep if year==1988

save "1988/NES_1988.dta" 

clear



use "NES_women.dta"

keep if year==1990

save "1990/NES_1990.dta" 

clear


use "NES_women.dta"

keep if year==1992

save "1992/NES_1992.dta" 

clear




use "NES_women.dta"

keep if year==1994

save "1994/NES_1994.dta" 

clear

use "NES_women.dta"

keep if year==1996

save "1996/NES_1996.dta" 

clear

use "NES_women.dta"

keep if year==1998

save "1998/NES_1998.dta" 


clear

use "NES_women.dta"

keep if year==2000

save "2000/NES_2000.dta" 

clear

use "NES_women.dta"

keep if year==2002

save "2002/NES_2002.dta" 

clear

use "NES_women.dta"

keep if year==2004

save "2004/NES_2004.dta" 

clear

use "NES_women.dta"

keep if year==2006

save "2006/NES_2006.dta" 

clear

use "NES_women.dta"

keep if year==2008

save "2008/NES_2008.dta"

