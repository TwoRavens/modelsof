
set more off
use "data/anes_mergedfile_1992to1997f.dta", clear


 *Taxes
 *1992 pre-has a question about which candidate more likely to raise taxes 923450 
 *post has tax question but it's about what will happen under Bush 926150
*health insurance
  *1992 No placements in 1992
  *1994 placements for Clinton, house  candidate, parties
  *1996 has candidates for president but not parties
*women people role
   *
*aid to Blacks
  *no placements in 1982 
   *party placements in 1994 and 1996
   
*Clinton feeling thermometers
tokenize I Clinton 0 101 100 I I "V923306 V940223 V960272" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=((X-`3')/`5') if X<`4'
*Bush feeling thermometers
tokenize I Bush 0 101 100 I I "V923305" "92"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=((X-`3')/`5') if X<`4' 
*Dole feeling thermometers
tokenize I Dole 0 101 100 I I "V940225 V960273" "94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=((X-`3')/`5') if X<`4'
*Liberal feeling thermometers
tokenize I liberal 0 101 100 I I "V925326 V961032" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=((X-`3')/`5') if X<`4' 
*ConserVatiVe feeling thermometers
tokenize I conservative 0 101 100 I I "V925319 V961031" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=((X-`3')/`5') if X<`4' 

*Health insurance
tokenize I health 1 8 6 I I "V923716 V940950 V960479" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 8 = -99) (9 =.),g(`2'_Y)
*Clinton - 
tokenize I c_health 0 9 1 I I " V940951 V960480" " 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Dole
tokenize I b_health 0 9 1 I I "V960481" "96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=X if X<`4'
*Democrat -
tokenize I d_health 0 9 1 I I "V940954" "94"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Republican -
tokenize I r_health 0 9 1 I I "V940955" "94 "
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
tab V940950 V940951
tab V940950 V940954
tab V940950 V940955
tabulate V960479 V960480
tabulate V960479 V960481
*did not ask health insurance placements in 1994 iif people said they had thought about it much
*did asked them in 1996

sum health*
cor health*94 health*96 *health*94 *health*96

*Government services -can't find in 1993
tokenize I gss 1 8 6 I I "V923701 V940940 V960450" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 8 = -99) (9 =.),g(`2'_Y)
for Y in any `9':replace `2'_Y =8 -`2'_Y if `2'_Y>-99
tab1 gss_*
tabulate V923703 V923701, mis
*Clinton - Government services
tokenize I c_gss 0 9 1 I I "V923703 V940941 V960453" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Bush-Dole - Government services -
tokenize I b_gss 0 9 1 I I "V923702 V960455" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Democrat - Government services -can't find in 1996
tokenize I d_gss 0 9 1 I I "V923705 V940944 V960461" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Republican - Government services -can't find in 1996
tokenize I r_gss 0 9 1 I I "V923704 V940945 V960462" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*if people said they hadn't thought about it to the initial question, they did not ask them the candidate placements
*But did ask them the party placements, weird
tab1 V923701 V923702-V923705
tab V923701  	V923702								
tab V923701  	V923703								
tab V923701  	V923704							
tab V923701  	V923705							
sum *gss*

*party identification
tokenize I PID 0 7 6 I I "V923634 V940655 V960420" " 92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':g `2'_Y=((X-`3')/`5') if X<`4' \ sum *`2'_Y
for any `8' \ any `9':g PID_3_Y=X \ recode  PID_3_Y 1 2= 0  3 =1 4 5 6= 2 7 8 =.

*job standard of living -does have 1994 questions for party
tokenize I job 1 8 6 I I "V923718 V940930 V960483" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 8 = -99) (9 =.),g(`2'_Y)
*Clinton - job standard of living
tokenize I c_job  0 9 1 I I "V923720 V940931 V960484" "92 94 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Bush - job standard of living
tokenize I b_job  0 9 1 I I "V923719 V960485" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Democrats - job standard of living
tokenize I d_job  0 9 1 I I "V923722 V940934" "92 94"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Republicans - job standard of living
tokenize I r_job  0 9 1 I I "V923721 V940935" "92 94"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
tab V923718 V923720

*defense spending
tokenize I def 0 8 1 I I "V923707 V940929 V960463" "92 94 96"
for any `8' :tab X, mis \ tab X,
for any `8' \ any `9':recode X (0 8 = -99) (9 =.),g(`2'_Y)
*Clinton defense spending-no 1994
tokenize I c_def  0 9 1 I I "V923709 V960466" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Bush defense spending-no 1994
tokenize I b_def  0 9 1 I I "V923708 V960469" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
tab V923707 V923708

*ideology
tokenize I ide 0 8 1 I I "V923509 V940839 V960365" "92 94 96"
for any `8' :tab X, mis \ tab X, mis 
for any `8' \ any `9':recode X (0 8 = -99) (9 =.),g(`2'_Y)
tabulate V923509 V923515, mis
*Clinton-ideology
tokenize I c_ide  0 9 1 I I "V923515 V960369" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Bush-Dole ideology
tokenize I b_ide  0 9 1 I I "V923514 V960371" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Democrat-ideology
tokenize I d_ide  0 9 1 I I "V923518 V960379" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
*Republican-ideology
tokenize I r_ide  0 9 1 I I "V923517 V960380" "92 96"
for any `8' :tab X, mis \ tab X, mis nol
for any `8' \ any `9':recode X (0 = 8) (9 =.),g(`2'_Y)
sum *_ide*
tab V923509 V923515,mis


*abortion 
 *no question about parties in 1992 pre
for any V923732 V923733 V923734 V960503  V960518       :tab X, mis
  for any V923732 V941014 V960503 \ num 92 94 96:recode X (1 = 7) (2 = 5) (3 = 3) (4 = 1) ( 8 = -99) (0 6 7 9 =.),g(abr_Y)
  tab V923732 V923734 ,mis
  tab  V923734 V960506,mis
  for any V923734 V960506  \ num 92 96:g c_abr_Y =X
  for any V923733 V960509  \ num 92 96:g b_abr_Y =X 
  for any V960517     \ num 96:g d_abr_Y =X
  for any V960518     \ num 96:g r_abr_Y =X 
tab1 abr_* *abr* V923734 V960506

sum abr*
tabulate abr_92 abr_96
recode *_abr_* (0 7 9 =.)
g abr_1_1 = c_abr_92 >b_abr_92 & c_abr_96 >b_abr_96 & c_abr_92!=8 & c_abr_96!=8 & b_abr_92!=8 & b_abr_96!=8 ///
            if c_abr_92<. & c_abr_96<. & b_abr_92<. & b_abr_96<. & r_abr_96<. & r_abr_96<.
 *                              & d_abr_96 >r_abr_96 & d_abr_96!=8 & r_abr_96!=8                             ///
tabulate  abr_1_1  , mis
tabulate  abr_1_1 c_abr_92 , mis
table  c_abr_92 b_abr_92 ,c( mean abr_1_1 freq)
table  c_abr_96 b_abr_96 ,c( mean abr_1_1 freq)

*health insurance                * private health insurance 7
sum *health* 
corr *_health* 
g health9496_1_1 = d_health_94 <r_health_94 & c_health_96 <b_health_96 & d_health_94!=8 & r_health_94!=8 & c_health_96!=8 & b_health_96!=8 if d_health_94<. & r_health_94<. & c_health_96<. & b_health_96<.
tabulate  health9496_1_1 


*government services-knowledge scale

tabulate gss_92 gss_96
recode *_gss_* (0 =.)
sum *_gss*
pwcorr *_gss_92 *_gss_96,obs
g gss_1_1 = c_gss_92 >b_gss_92 & c_gss_96 >b_gss_96 & c_gss_92!=8 & c_gss_96!=8 & b_gss_92!=8 & b_gss_96!=8 if c_gss_92<. & c_gss_96<. & b_gss_92<. & b_gss_96<.
/* g gss_1_1 = c_gss_92 >b_gss_92 & c_gss_96 >b_gss_96 & c_gss_92!=8 & c_gss_96!=8 & b_gss_92!=8 & b_gss_96!=8 & /// 
             d_gss_92 >r_gss_92 & d_gss_96 >r_gss_96 & d_gss_92!=8 & d_gss_96!=8 & d_gss_92!=8 & r_gss_96!=8 ///
             if c_gss_92<. & c_gss_96<. & b_gss_92<. & b_gss_96<. & d_gss_92<. & d_gss_96<. & r_gss_92<. & r_gss_96<.
*/
			
tabulate  gss_1_1  , 
tabulate  gss_1_1  , 
*tabulate  gss_1_1 gss_1_1b  , 
g gss9496_1_1 = d_gss_94 >r_gss_94 & c_gss_96 >b_gss_96 & d_gss_94!=8 & r_gss_94!=8 & c_gss_96!=8 & b_gss_96!=8 if d_gss_94<. & r_gss_94<. & c_gss_96<. & b_gss_96<.
tab gss9496_1_1 

*jobs-knowledge scale
sum *_job_92  *_job_96 ,
tabulate b_job_92 , mis
tabulate c_job_92 , mis
recode *_job_* (0 =.)
*g job_1_1 = c_job_92 <b_job_92 & c_job_96 <b_job_96 & c_job_92!=8 & c_job_96!=8 & b_job_92!=8 & b_job_96!=8 if c_job_92<. & c_job_96<. & b_job_92<. & b_job_96<.
g job_1_1 = c_job_92 <b_job_92 & c_job_96 <b_job_96 & c_job_92!=8 & c_job_96!=8 & b_job_92!=8 & b_job_96!=8  ///
             if c_job_92<. & c_job_96<. & b_job_92<. & b_job_96<. & d_job_92<. &                 r_job_92<. 
*			& d_job_92 <r_job_92 &                      d_job_92!=8 &               r_job_92!=8               ///
tabulate  job_1_1  , mis
tabulate  job_1_1 c_job_92 , mis
*tabulate  job_1_1 job_1_1b  , mis

g job9496_1_1 = d_job_94 <r_job_94 & c_job_96 <b_job_96 & d_job_94!=8 & r_job_94!=8 & c_job_96!=8 & b_job_96!=8 if d_job_94<. & r_job_94<. & c_job_96<. & b_job_96<.
tab job9496_1_1 
*economic scale--knowledge scale
g economic_1_1 =  gss_1_1 + job_1_1 

*ideology-knowledge scale
sum ide_* *_ide_*
tabulate b_ide_96 , mis
tabulate ide_92 ide_96, 
recode c_ide_* b_ide_* (0 =.)
g ide_1_1 = c_ide_92 <b_ide_92 & c_ide_96 <b_ide_96 & c_ide_92!=8 & c_ide_96!=8 & b_ide_92!=8 & b_ide_96!=8 if c_ide_92<. & c_ide_96<. & b_ide_92<. & b_ide_96<.
/*g ide_1_1 = c_ide_92 <b_ide_92 & c_ide_96 <b_ide_96 & c_ide_92!=8 & c_ide_96!=8 & b_ide_92!=8 & b_ide_96!=8 & ///
             d_ide_92 <r_ide_92 & d_ide_96 <b_ide_96 & d_ide_92!=8 & d_ide_96!=8 & b_ide_92!=8 & b_ide_96!=8 ///
             if c_ide_92<. & c_ide_96<. & b_ide_92<. & b_ide_96<. & d_ide_92<. & d_ide_96<. & r_ide_92<. & r_ide_96<.
*/
			 tab ide_1_1 



*Defense-knowledge scale
sum def* *_def*
tab1 c_def* b_def*
tabulate def_92 def_96
recode c_def_*  b_def_* (0 =.)
g def_1_1 = c_def_92 <b_def_92 & c_def_96 <b_def_96 & c_def_92!=8 & c_def_96!=8 & b_def_92!=8 & b_def_96!=8 if c_def_92<. & c_def_96<. & b_def_92<. & b_def_96<.
/*
tabulate  def_1_1  , mis
by  def_1_1, sort:tabulate def_92 def_96

table  c_def_92 b_def_92 ,c( mean def_1_1 freq)
table  c_def_96 b_def_96 ,c( mean def_1_1 freq)


*check whether respondents who said don't know on their own self-placement are set as don't know for candidate placements
for any gss job def ide abr  : tab c_X_92 X_92 ,mis
  *1992 defense did not ask people to place candidates if they didn't place themselves, but 1996 defense they did
for any gss job def ide abr  : tab c_X_96 X_96 ,mis
for any gss job health  : tab c_X_94 X_94 ,mis
for any gss job health  : tab c_X_96 X_96 ,mis
  *1994 health did not asked people to place candidates if they didn't place themselves
  *1994 services and spending did not asked people to place candidates if they didn't place themselves
*/
  
/*
*standardize variables
for var abr_92 def_92 job_92  gss_92 ide_92 liberal_92 conservative_92: egen std_X =std(X)
for var abr_96 def_96 job_96  gss_96 ide_96 liberal_96 conservative_96: egen std_X =std(X)

*general issues
sum abr_92 def_92 job_92  gss_92 ide_92 abr_96 def_96 job_96  gss_96 ide_96 std_*
egen missing_92 =rowmiss(abr_92 def_92 job_92  gss_92 ide_92)
egen missing_96 =rowmiss(abr_96 def_96 job_96  gss_96 ide_96)  
tabulate missing_92
tabulate missing_96

for num 92 96:egen issues_X = rowmean(std_abr_X std_def_X  std_job_X  std_gss_X  std_ide_X)
for num 92 96:egen issuesnu_X = rowmean(abr_X def_X job_X gss_X ide_X)
for num 92 96:egen issues4_X = rowmean(abr_X def_X  job_X  gss_X)

g issues_1_1 = abr_1_1 + gss_1_1 + job_1_1 + ide_1_1 + def_1_1
tabulate issues_1_1

*for var abr_92 def_92 job_92  gss_92 abr_96 def_96 job_96  gss_96 ide_92  ide_96: impute std_X abr_92 def_92 job_92  gss_92  ide_92 abr_96 def_96 job_96  gss_96  ide_96,g(istd_X)
by issues_1_1, sort: corr issues_92 issues_96
*ideology multi-item scale
factor ide_92 liberal_92 conservative_92,pcf
 predict  ideology_3_92
 sum  ide_92 liberal_92 conservative_92 ideology_3_92
factor ide_96 liberal_96 conservative_96,pcf
 predict  ideology_3_96

*economic issues scale
factor std_job_92  std_gss_92 , pcf
 predict  economic_92
factor std_job_96  std_gss_96 , pcf
 predict  economic_96
*/

********General Knowledge Scale***************
g kg_congresspost3=V925919==1 if V925919!=0 & V925919!=.
g kg_generalpost1=V925916==1 if V925916!=0 & V925916!=.
g kg_generalpost2=V925917==1 if V925917!=0 & V925917!=.
g kg_generalpost3=V925920==3 if V925920!=0 & V925920!=.
g kg_generalpost4=V925921==1 if V925921!=0 & V925921!=.
*g kg_generalpost5=V925915==5 if V925915!=0 & V925915!=. //Which party is more conservative
g kg_foreignpost1=V925918==1 if V925918!=0 & V925918!=.
g kgw_congress1=V961192==1 if V961192!=0 & V961192!=.
g kgw_general1=V961189==1 if V961189!=0 & V961189!=.
g kgw_general2=V961190==1 if V961190!=0 & V961190!=.
g kgw_foreign1=V961191==1 if V961191!=0 & V961191!=.
g kgw_ratingpre=5-V960070 if V960070!=9 & V960070!=.
g kgw_ratingpost=5-V960940 if V960940!=9 & V960940!=0 & V960940!=.
*1994
tab1 V941006-V941013
recode V941006 1 = 1 5 8 = 0 9 =.,g(kg_Gore_1994)
recode V941007 1 = 1 5 8 = 0 9 =.,g(kg_Rehnquist_1994)
recode V941008 1 = 1 5 8 = 0 9 =.,g(kg_Yeltsin_1994)
recode V941009 1 = 1 5 8 = 0 9 =.,g(kg_foley_1994)
recode V941010 3 = 1 1 2 8 = 0 9 =.,g(kg_Constitution_1994)
recode V941011 1 = 1 2 3 8 = 0 9 =.,g(kg_Judge_1994)
recode V941012 5 = 1 1 8 = 0 9 =.,g(kg_house_1994)
recode V941013 5 = 1 1 8 = 0 9 =.,g(kg_Senate_1994)
*sum kg_*_1994
*corr kg_*_1994

*sum kg*
*corr kg* 
for var kg*: impute X kg*,g(iX) \ replace X=iX
alpha kg* 

egen kg_total=rowtotal(kg_*)
*replace kg_total =(kg_total+.5816286)/14.0485

*need to reverse code some of the placements
for var  b_gss_* c_gss_* d_gss_* r_gss_* : replace X =  8 - X if X <8
for var  b_abr_* c_abr_* : replace X =8- (( X-1)*6/3+1) if X <8
*tab1 c_gss_* c_job_* c_def_* b_health_*  c_health_*  r_health_* 

*tab1 c_gss_* c_job_* c_def_* b_def_*  c_ide_* c_abr_* abr_* 

*vote 92
tab1 V925609 V923805
g vote_92 =1 if V925609 == 1  // postelection vote
replace vote_92 =0 if V925609 == 2 // postelection vote
replace vote_92 =.5 if V925609 == 3 | V925609 == 7 // postelection vote
replace vote_92 =1 if vote_92 ==. & V923805 == 1 // pre-election vote
replace vote_92 =0 if vote_92 ==. & V923805 == 2 // pre-election vote
replace vote_92 =.5 if vote_92 ==. & (V925609== 3 | V923805 == 3 | V925609== 7 | V923805 == 7) // postelection vote
tabulate vote_92, missing
*vote 96
g vote_96 =1 if V961082 == 2  // postelection vote
replace vote_96 =0 if V961082 == 1 // postelection vote
replace vote_96 =.5 if V961082 == 3 | V961082 == 7 // postelection vote
replace vote_96 =1 if vote_96 ==. & V960548 == 2 // pre-election vote
replace vote_96 =0 if vote_96 ==. & V960548 == 1 // pre-election vote
replace vote_96 =.5 if vote_96 ==. & (V925609== 3 | V923805 == 3 | V925609== 7 | V923805 == 7) // postelection vote
/*  
tab1 V961082 V960548
tabulate vote_96, missing
tabulate vote_96 vote_92,col missing
tabulate vote_96 vote_92,col 


*reliability of knowledge measures 
for any def job gss ide :g X_11 = ((c_X_92 <b_X_92 & c_X_92!=8 & b_X_92!=8) | (c_X_96 <b_X_96  & c_X_96!=8  & b_X_96!=8)) &  X_1_1!= 1  if c_X_92<. & c_X_96<. & b_X_92<. & b_X_96<.
for any def job gss ide :g position_X_92 = c_X_92 <b_X_92 & c_X_92!=8 & b_X_92!=8   if c_X_92<. & c_X_96<. & b_X_92<. & b_X_96<.
for any def job gss ide :g position_X_96 = c_X_96 <b_X_96 & c_X_96!=8  & b_X_96!=8  if c_X_92<. & c_X_96<. & b_X_92<. & b_X_96<.
for any abr:g position_X_92 = c_X_92 >b_X_92 & c_X_92!=8 & b_X_92!=8  if c_X_92<. & c_X_96<. & b_X_92<. & b_X_96<.
for any abr:g position_X_96 = c_X_96 >b_X_96 & c_X_96!=8 & b_X_96!=8  if c_X_92<. & c_X_96<. & b_X_92<. & b_X_96<.
tabulate def_11 def_1_1 
xtile knowledge_5 = kg_total,n(5)
xtile knowledge_7 = kg_total,n(7)
xtile knowledge_10= kg_total,n(10)

for any def job gss ide abr:table knowledge_10,c(mean X_11)
for any def job gss ide abr:alpha position_X_92 position_X_96 if knowledge_5==1
for any def job gss ide abr:alpha position_X_92 position_X_96 if knowledge_5==2
for any def job gss ide abr:alpha position_X_92 position_X_96 if knowledge_5==3
for any def job gss ide abr:alpha position_X_92 position_X_96 if knowledge_5==4
for any def job gss ide abr:alpha position_X_92 position_X_96 if knowledge_5==5
for any def job gss ide abr:alpha position_X_92 position_X_96 if knowledge_7>=5
for any def job gss ide abr:corr position_X_92 position_X_96 if knowledge_7>=5
sum c_* b_* d_* r_*
 */
