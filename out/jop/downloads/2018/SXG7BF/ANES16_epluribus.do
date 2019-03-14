******************************************************************************************************************
******************************************************************************************************************
*****This do.file produces the results based on the 2016 ANES reported in table 2, table OA.4, and table OA.5*****
******************************************************************************************************************
******************************************************************************************************************

set more off

*** recoding demographics

** race dummies 

recode V161310x (1=1)(else = 0), gen(white)
recode V161310x (5=1)(else = 0), gen(lat)

** age 

recode V161267 (-9 = .)(-8 = .), gen(age)
gen age1 = (age - 18)/72

tab age1

** education 

recode V161270 (-9 90 95 = .), gen(educ)
gen educ1 = (educ - 1)/15

tab educ1

** employed dummy variable

recode V161277 (1=1)(2/8 = 0)(else =.), gen(employed)

** own home

recode V161334 (2 3 =1)(1 4 = 0)(else = .), gen(own_home)

** female dummy variable

recode V161342 (2=1)(1=0)(else =.), gen (female) 

** married dummy variable

recode V161268 (1 2 = 1)(3 4 5 6 = 0)(else = .), gen(married)

/*create generational status variables, second and third, where second = second generation, and third = third generation*/

*** foreign born dummy variable

tab V161316

recode V161316 (4 =1)(1 2 3 7 = 0)(else =.), gen(fborn)

** parents born categorical variable
/*1=both parents born in us, 2 = one parent born in us; 3 = both parents born in another country*/

recode V161315 (-8 -9 = .), gen(parborn)

** second generation 

gen second = 0
replace second = 1 if fborn == 0 & parborn == 3
replace second = 0 if fborn == 1 | parborn != 3

** third generation 

gen third = 0 
replace third = 1 if fborn == 0 & parborn == 2
replace third = 1 if fborn == 0 & parborn == 1

** party 

tab V161158x
recode V161158x (-9 -8 = .), gen(pid)
gen pid7 = (pid - 1)/6


recode V161158x (1 2 3 = -1)(4=0)(5 6 7 = 1)(else = .), gen(pid3cat)


** ideo 

tab V161126
recode V161126 (-8 -9 = .)(99 = 4), gen(ideo)
gen ideo_7 = (ideo -1)/6 

recode ideo (1 2 3 = -1)(4=0)(5 6 7 = 1), gen(ideo_3)

*** recoding dependent variables

** flag 

tab V162125x 
recode V162125x (-9 -7 -6 = .), gen(flag)
gen flag_1 = (flag*-1+7)/6

** hisp. elected 

tab V162221 
recode V162221 (-9/ -6 = .), gen(pro_lat)
gen pro_lat1 = (pro_lat*-1+5)/4

** minorities blend

tab V162266 
recode V162266 (-9/-6= .), gen(blend)
gen blend1 = (blend*-1+5)/4

***correlations between dependent variables

pwcorr blend1 pro_lat1 flag_1 if white == 1 [aw =V160102], sig
pwcorr blend1 pro_lat1 flag_1 if lat == 1 [aw =V160102], sig

*** main independent variables 

tab V162332 
recode V162332 (-9/-5= .), gen(amid)
gen amid1 = (amid*-1+5)/4

tab V162327 
recode V162327 (-9/-1= .), gen(whid)
gen whid1 = (whid*-1+5)/4

tab V162326
recode V162326(-9/-1= .), gen(latid)
gen latid1 = (latid*-1+5)/4


**** demographics of sample 

** foreign born
svy: mean fborn if white == 1
svy: mean fborn if lat == 1

** 2 us parents
svy: tab parborn if white == 1
svy: tab parborn if lat == 1

** party
svy: tab pid3 if white == 1
svy: tab pid3 if lat == 1

** female 
svy: mean female if white == 1
svy: mean female if lat == 1

** education 
sum educ if white == 1 [aweight = V160102] , detail /* some college */ 
sum educ if lat == 1 [aweight = V160102] , detail /* high school */

** age 
sum age if white == 1 [aweight = V160102] , detail 
sum age if lat == 1 [aweight = V160102] , detail 

**** correlations between identities

** two identites among whites
pwcorr amid1 whid1 if white == 1 [aw =V160102], sig

** two identities among latinos
pwcorr amid1 latid1 if lat == 1 [aw =V160102], sig

**** correlations between outcomes

** among whites

pwcorr blend1 pro_lat1 flag_1 if white == 1 [aw =V160102], sig

** among latinos

pwcorr blend1 pro_lat1 flag_1 if lat == 1 [aw =V160102], sig

*** analyses

*** among whites 

reg blend1 whid1 amid1 pid7 ideo_7 age1 educ1 employed own_home female married if white == 1 [aweight = V160102]
est store blend_wh_demos
reg pro_lat1 whid1 amid1 pid7 ideo_7 age1 educ1 employed own_home female married if white == 1 [aweight = V160102]
est store prolat_wh_demos
reg flag_1 whid1 amid1 pid7 ideo_7 age1 educ1 employed own_home female married if white == 1 [aweight = V160102]
est store flag_wh_demos 

*** among latinos

reg blend1 latid1 amid1 pid7 ideo_7 age1 educ1 employed own_home female married second third if lat == 1 [aweight = V160102]
est store blend_lat_demos
reg pro_lat1 latid1 amid1 pid7 ideo_7 age1 educ1 employed own_home female married second third if lat == 1 [aweight = V160102]
est store prolat_lat_demos
reg flag_1 latid1 amid1 pid7 ideo_7 age1 educ1 employed own_home female married second third if lat == 1 [aweight = V160102]
est store flag_lat_demos 

est table  blend_lat_demos blend_wh_demos prolat_lat_demos prolat_wh_demos flag_lat_demos flag_wh_demos , b(%9.2g) se(%9.2g) stats(N) eq(1)
