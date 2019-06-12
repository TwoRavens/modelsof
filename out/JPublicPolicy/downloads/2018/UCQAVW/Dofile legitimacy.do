
gen id=_n

replace q18_2_mp12=0 if q18_2_mp12==2
 
**********Some variables are available in t2 (Dec 2012) only if they are nonexistent in t1 (May 2012). They are then assigned the December value*****

replace q3_1_steg1=q3_1_steg2 if q3_1_steg1==.
replace q3_2_steg1=q3_2_steg2 if q3_2_steg1==.
replace q3_3_steg1=q3_3_steg2 if q3_3_steg1==.
replace q3_4_steg1=q3_4_steg2 if q3_4_steg1==.
replace q3_5_steg1=q3_5_steg2 if q3_5_steg1==.
replace q3_6_steg1=q3_6_steg2 if q3_6_steg1==.
replace q3_7_steg1=q3_7_steg2 if q3_7_steg1==.
replace q3_8_steg1=q3_8_steg2 if q3_8_steg1==.

replace q27_1_steg1=q27_1_steg2 if q27_1_steg1==.
replace q27_2_steg1=q27_2_steg2 if q27_2_steg1==.
replace q27_3_steg1=q27_3_steg2 if q27_3_steg1==.
replace q27_4_steg1=q27_4_steg2 if q27_4_steg1==.
replace q27_5_steg1=q27_5_steg2 if q27_5_steg1==.
replace q27_6_steg1=q27_6_steg2 if q27_6_steg1==.
replace q27_7_steg1=q27_7_steg2 if q27_7_steg1==.
replace q27_8_steg1=q27_8_steg2 if q27_8_steg1==.
replace q27_9_steg1=q27_9_steg2 if q27_9_steg1==.
replace q27_10_steg1=q27_10_steg2 if q27_10_steg1==.
replace q27_11_steg1=q27_11_steg2 if q27_11_steg1==.
replace q27_12_steg1=q27_12_steg2 if q27_12_steg1==.
replace q27_13_steg1=q27_13_steg2 if q27_13_steg1==.

replace q12_2_steg1=q12_2_steg2 if q12_2_steg1==.


*********************Differece between t1 and t3*********************************

gen diff_q3_1=q3_1_steg3-q3_1_steg1
gen diff_q3_2=q3_2_steg3-q3_2_steg1
gen disap3_2=diff_q3_2 if diff_q3_2>0
replace disap3_2=0 if diff_q3_2<0|diff_q3_2==0
gen diff_q3_3=q3_3_steg3-q3_3_steg1
gen diff_q3_4=q3_4_steg3-q3_4_steg1
gen diff_q3_5=q3_5_steg3-q3_5_steg1
gen diff_q3_6=q3_6_steg3-q3_6_steg1
gen diff_q3_7=q3_7_steg3-q3_7_steg1
gen diff_q3_8=q3_8_steg3-q3_8_steg1

gen diff_q4_1=q4_1_steg3-q4_1_steg1
gen diff_q4_2=q4_2_steg3-q4_2_steg1
gen diff_q4_3=q4_3_steg3-q4_3_steg1

gen diff_q5_1=q5_1_steg3-q5_1_steg1
gen diff2_q5_1=q5_1_mp11-q5_1_steg3
gen diff3_q5_1=q5_1_mp12-q5_1_steg3
gen diff_q5_2=q5_2_steg3-q5_2_steg1
gen diff_q5_3=q5_3_steg3-q5_3_steg1
gen diff_q5_4=q5_4_steg3-q5_4_steg1

gen diff_q7_1=q7_1_steg3-q7_1_steg1
gen diff_q7_2=q7_2_steg3-q7_2_steg1
gen diff_q7_3=q7_3_steg3-q7_3_steg1
gen diff_q7_4=q7_4_steg3-q7_4_steg1

gen diff_q8_1=q8_1_steg3-q8_1_steg1
gen diff_q8_2=q8_2_steg3-q8_2_steg1
gen diff_q8_3=q8_3_steg3-q8_3_steg1
gen diff_q8_4=q8_4_steg3-q8_4_steg1
gen diff_q8_5=q8_5_steg3-q8_5_steg1
gen diff_q8_6=q8_6_steg3-q8_6_steg1
gen diff_q8_7=q8_7_steg3-q8_7_steg1
gen diff2_q8_7=q8_7_mp11-q8_7_steg1


gen diff_q23_1=q23_1_steg3-q23_1_steg1
gen diff_q23_2=q23_2_steg3-q23_2_steg1
gen diff_q23_3=q23_3_steg3-q23_3_steg1
gen diff_q23_4=q23_4_steg3-q23_4_steg1
gen worse_3=1 if diff_q23_4>0
replace worse_3=0 if (diff_q23_4==0 |diff_q23_4<0)
gen diffworse=diff_q23_4*worse_3

gen diff_q23_4_2=q23_4_mp12-q23_4_steg3
gen worse_5=1 if diff_q23_4_2>0
replace worse_5=0 if (diff_q23_4_2==0 |diff_q23_4_2<0)
gen diffworse5=diff_q23_4_2*worse_5


gen diff_q23_6=q23_6_steg3-q23_6_steg1
gen diff_q23_7=q23_7_steg3-q23_7_steg1
gen diff_q23_8=q23_8_steg3-q23_8_steg1
gen diff_q23_9=q23_9_steg3-q23_9_steg1

gen q51worse=diff_q5_1*worse_3

gen q51worse5=diff2_q5_1*worse_5

gen diff_q9_1=q9_1_steg3-q9_1_steg1
gen diff2_q9_1=q9_1_mp11-q9_1_steg1
gen diff_q9_2=q9_2_steg3-q9_2_steg1
gen diff_q9_3=q9_3_steg3-q9_3_steg1
gen diff_q9_4=q9_4_steg3-q9_4_steg1
gen diff_q9_5=q9_5_steg3-q9_5_steg1
gen diff_q9_6=q9_6_steg3-q9_6_steg1
gen diff_q9_7=q9_7_steg3-q9_7_steg1
gen diff_q9_8=q9_8_steg3-q9_8_steg1

gen diff_q10_1=q10_1_steg3-q10_1_steg1
gen diff2_q10_1=q10_1_mp11-q10_1_steg3
gen diff21_q10_1=q10_1_mp11-q10_1_steg1

gen diff_q10_2=q10_2_steg3-q10_2_steg1
gen diff_q10_3=q10_3_steg3-q10_3_steg1
gen diff_q10_4=q10_4_steg3-q10_4_steg1
gen diff_q10_5=q10_5_steg3-q10_5_steg1
gen diff_q10_6=q10_6_steg3-q10_6_steg1
gen diff_q10_7=q10_7_steg3-q10_7_steg1

gen diff_q1_1=q1_1_steg3-q1_1_steg1

gen diff2_q1_1=q1_1_mp11-q1_1_steg3
gen diff3_q1_1=q1_1_mp12-q1_1_steg3

gen diff_q1_2=q1_2_steg3-q1_2_steg1
gen diff_q1_5=q1_5_steg3-q1_5_steg1
gen diff_q1_6=q1_6_steg3-q1_6_steg1
gen diff_q1_7=q1_7_steg3-q1_7_steg1

gen diff_q28_1=q28_1_steg3-q28_1_steg1
gen diff_q28_2=q28_2_steg3-q28_2_steg1
gen diff_q28_3=q28_3_steg3-q28_3_steg1

gen diff_q11=q11_steg3-q11_steg1

gen diff_q30_1=q30_1_steg3-q30_1_steg1
gen diff_q30_2=q30_2_steg3-q30_2_steg1
gen diff_q30_3=q30_3_steg3-q30_3_steg1
gen diff_q30_4=q30_4_steg3-q30_4_steg1

gen diff_q12_2=q12_2_steg3-q12_2_steg1

gen diff_q31_1=q31_1_steg3-q31_1_steg1

gen diff2_q10_3=q10_3_mp11-q10_3_steg3
gen diff2_q8_5=q8_5_mp11-q8_5_steg3
gen diff2_q9_2=q9_2_mp11-q9_2_steg3

replace q30_1_steg1=0 if q30_1_steg1==.i&(q30_2_steg1!=.i|q30_3_steg1!=.i|q30_4_steg1!=.i)

gen against1=q1_1_steg1 if q1_1_steg1<4
replace against1=0 if q1_1_steg1>3

gen supworse=diff_q1_1*against1

gen against3=q1_1_steg3 if q1_1_steg3<4
replace against3=0 if q1_1_steg3>3



gen diff12_q1_1=q1_1_steg2-q1_1_steg1
gen supworse2=diff_q1_1*against3

gen party=partypref_steg1
replace party=partypref_steg2 if partypref_steg1==.|partypref_steg1==.i

gen m=1 if party==5
replace m=0 if party!=5

gen vm=1 if party==1|party==7
replace vm=0 if party!=1&party!=7

gen sd=1 if party==8
replace sd=0 if party!=8


gen for_steg1=1 if q1_2_steg1==1
replace for_steg1=0 if q1_2_steg1==2


gen for_steg2=1 if q1_2_steg2==1
replace for_steg2=0 if q1_2_steg2==2

gen for_steg3=1 if q1_2_steg3==1
replace for_steg3=0 if q1_2_steg3==2

gen for_mp8=1 if q1_2_mp8==1
replace for_mp8=0 if q1_2_mp8==2

gen for_mp10=1 if q1_2_mp10==1
replace for_mp10=0 if q1_2_mp10==2

gen for_mp11=1 if q1_2_mp11==1
replace for_mp11=0 if q1_2_mp11==2



************** Time invariant variables *********************

**sex**
gen female=1 if sex_steg1==1|sex_steg2==1|sex_mp8==1|sex_h14==1
replace female=0 if sex_steg1==0|sex_steg2==0|sex_mp8==0|sex_h14==2


**year of birth**
gen byear=birthyear_steg1
replace byear=birthyear_steg2 if birthyear_steg2!=.
replace byear=birthyear_mp8 if birthyear_mp8!=.
replace byear=byear_h14 if byear_h14!=.

gen age=2013-byear

**municipality**


gen gote=1 if muni_steg1==1480|muni_steg2==1480|muni_mp8==1480|muni_h14==1480
replace gote=0 if (muni_steg1!=1480&muni_steg1!=.)|(muni_steg2!=1480&muni_steg2!=.)|(muni_mp8!=1480&muni_mp8!=.)|(muni_h14!=1480&muni_h14!=.)

gen krans=1 if (muni_steg1==1384|muni_steg1==1401|muni_steg1==1402|muni_steg1==1407|muni_steg1==1415|muni_steg1==1419|muni_steg1==1481|muni_steg1==1482|muni_steg1==1440|muni_steg1==1441|muni_steg1==1462|muni_steg1==1489)|(muni_steg2==1384|muni_steg2==1401|muni_steg2==1402|muni_steg2==1407|muni_steg2==1415|muni_steg2==1419|muni_steg2==1481|muni_steg2==1482|muni_steg2==1440|muni_steg2==1441|muni_steg2==1462|muni_steg2==1489)|(muni_mp8==1384|muni_mp8==1401|muni_mp8==1402|muni_mp8==1407|muni_mp8==1415|muni_mp8==1419|muni_mp8==1481|muni_mp8==1482|muni_mp8==1440|muni_mp8==1441|muni_mp8==1462|muni_mp8==1489)|(muni_h14==1384|muni_h14==1401|muni_h14==1402|muni_h14==1407|muni_h14==1415|muni_h14==1419|muni_h14==1481|muni_h14==1482|muni_h14==1440|muni_h14==1441|muni_h14==1462|muni_h14==1489)
replace krans=0 if gote==1|(gote==0&krans!=1)

gen storgote=1 if gote==1|kran==1
replace storgote=0 if gote==0&krans==0

gen munithree=0 if storgote==0
replace munithree=1 if krans==1
replace munithree=2 if gote==1

gen kransbil_steg1=krans*q30_1_steg1
gen kransbil_steg3=krans*q30_1_steg3

gen nocar=1 if q30_1_steg1==0
replace nocar=0 if q30_1_steg1>0&q30_1_steg1!=.

gen nocar_3=1 if q30_1_steg3==0
replace nocar_3=0 if q30_1_steg3>0&q30_1_steg3!=.

gen polint=polint_steg1
replace polint=polint_steg2 if polint_steg1==.

**Highest education**

***** Different categories in the different waves****
**3=gymnasiestudier, 4=Eftergymnasial, ej högskola, 5= studier vid högskola eller kortare än 3 år, 6=examen eller mer än 3 år högskola***

replace edu_steg1=edu_steg2 if edu_steg2!=.

gen edu=1 if edu_steg1==1|edu_ny_mp8==1|edu9_h14==1
replace edu=2 if edu_steg1==2|edu_ny_mp8==2|edu9_h14==2
replace edu=3 if edu_steg1==3|edu_ny_mp8==3|edu9_h14==3|edu_steg1==4|edu_ny_mp8==4|edu9_h14==4
replace edu=4 if edu_steg1==5|edu_ny_mp8==5|edu9_h14==5|edu_ny_mp8==6|edu9_h14==6
replace edu=5 if edu_steg1==6|edu_ny_mp8==7|edu9_h14==7
replace edu=6 if edu_steg1==7|edu_ny_mp8==8|edu9_h14==8
replace edu=7 if edu_steg1==8|edu_ny_mp8==9|edu9_h14==9

*********************** Table 1 *********************************

*****  Model 1 *****
reg q5_1_steg1 q23_4_steg1 female age edu gote polint
predict dem1

*****  Model 2 *****
reg q1_1_steg1 dem1 female age edu gote income_1_steg1 q10_1_steg1 q8_7_steg1 q9_1_steg1 q10_3_steg1

*****  Model 3 *****
reg diff_q23_4 q1_1_steg1 for_steg1 female age edu gote 

*****  Model 4 *****
reg diff_q5_1 diff_q23_4 diffworse female age edu gote polint

*****  Model 5 *****
reg diff_q1_1 diff_q5_1 q51worse female age edu gote diff_q10_1 diff_q8_7 diff_q9_1 diff_q10_3 income_1_steg1

*****  Model 6 *****
reg diff_q23_4_2 diff_q1_1 supworse female age edu gote

*****  Model 7 *****
reg diff2_q5_1 diff_q23_4_2 diffworse5 female age edu gote polint

*****  Model 8 *****
reg diff2_q1_1 diff2_q5_1 q51worse5 female age edu gote diff2_q8_7 diff2_q9_1 diff2_q10_1 diff2_q10_3 income_1_steg1


*********************** Table 2 *********************************

**** Smaller sample who have replied in all waves ****
gen samp=1 if q5_1_steg1!=.& q5_1_steg3!=.& q5_1_mp11!=.&q1_1_steg1!=.&q1_1_steg3!=.&q1_1_mp11!=. &diff_q9_1!=.&diff2_q9_1!=.& q5_1_steg1!=.i& q5_1_steg3!=.i& q5_1_mp11!=.i&q1_1_steg1!=.i&q1_1_steg3!=.i&q1_1_mp11!=.i &income_1_steg1!=.i&diff_q9_1!=.i&diff2_q9_1!=.i&diff2_q8_7!=.&diff2_q8_7!=.i&q23_4_steg1!=.&q23_4_steg3!=.&q23_4_mp12!=.&q23_4_steg1!=.i&q23_4_steg3!=.i&q23_4_mp12!=.i&polint!=.&for_steg1!=.
replace samp=0 if samp==.



*****  Model 1a *****
reg q1_1_steg1 dem1 female age edu gote income_1_steg1 if samp==1

*****  Model 1b *****
reg q1_1_steg1 dem1 female age edu gote income_1_steg1 q10_1_steg1 q9_1_steg1 q10_3_steg1 if samp==1

*****  Model 2a *****
reg q1_1_steg3 dem1 diff_q5_1 female age edu gote income_1_steg1 if samp==1

*****  Model 2b *****
reg q1_1_steg3 dem1 diff_q5_1 female age edu gote income_1_steg1 q10_1_steg3 q9_1_steg3 q10_3_steg3  if samp==1

*****  Model 2c *****
reg q1_1_steg3 dem1 diff_q5_1 female age edu gote income_1_steg1 q10_1_steg3 q9_1_steg3 q10_3_steg3 q1_1_steg1 if samp==1

*****  Model 3a *****
reg q1_1_mp11 dem1 diff_q5_1 diff2_q5_1 female age edu gote income_1_steg1 if samp==1

*****  Model 3b *****
reg q1_1_mp11 dem1 diff_q5_1 diff2_q5_1 female age edu gote income_1_steg1 q10_1_mp11 q9_1_mp11 q10_3_mp11  if samp==1

*****  Model 3c *****
reg q1_1_mp11 dem1 diff_q5_1 diff2_q5_1 female age edu gote income_1_steg1 q10_1_mp11 q9_1_mp11 q10_3_mp11  q1_1_steg1 if samp==1

