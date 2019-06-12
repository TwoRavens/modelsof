*cd "/Users/shadturney/Dropbox/shared folders/Issue Voting/BES 1992-1996"
use data/bes9297.dta, clear

*feeling about parties
recode confe* labfel*  (min/0 =.) (8/9 =.)
tab1 confe* labfel* 
for var confe* labfel* : replace X = (X-1)/4
for num 92 94/97: g l_c_X = (confelX -labfelX+ 1)/2
for num 92 94/97: g therm_X = ((1 - l_c_X))
sum l_c_* therm_*
corr l_c_*


sum lab*92 lab*94 lab*95 lab*96 lab*97 
*they only ask about defense and government responsibility for standard of living in 1992
* PARTY PLACEMENTS
*ieq not asked in 1994 ieq 
for any jbp txs prn ieq eci : sum labX*
for any jbp txs prn ieq eci : tab labX92 \ tab1 labX92,nol
for any jbp txs prn ieq eci : tab labX97 \ tab1 labX97,nol
*for any jbp txs prn ieq  : tab1 labX*,nol
for any jbp txs prn eci: tab1 labX*,nol
*Correct placements
*relative positions
for X in any jbp txs prn eci: for Y in num 92 94/97: g k_X_Y = labXY<conXY & labXY!=98 & conXY!= 98 if labXY<99 & conXY< 99 & labXY>0 & conXY>0 
for X in any ieq: for Y in num 92 95 96 97: g k_X_Y = labXY<conXY & labXY!=98 & conXY!= 98 if labXY<99 & conXY< 99 & labXY>0 & conXY>0 
for X in any jbp txs prn  ieq eci: for Y in num 92 95/97: tab k_X_Y
*relative positions or party one prefers
*for X in any jbp txs prn eci: for Y in num 92 94/97: g k_X_Y = labXY<conXY & labXY!=98 & conXY!= 98 | (labXY<6&l_c_Y>.5&l_c_Y<.) | (conXY>6&l_c_Y<.5&conXY!= 98)  if labXY<99 & conXY< 99 & labXY>0 & conXY>0 
*for X in any ieq: for Y in num 92 95 96 97: g k_X_Y = labXY<conXY & labXY!=98 & conXY!= 98  | (labXY<6&l_c_Y>.5&l_c_Y<.) | (conXY>6&l_c_Y<.5&conXY!= 98) if labXY<99 & conXY< 99 & labXY>0 & conXY>0 
sum k_*
tab conprn95 k_prn_95,mis nol


for X in any jbprc txs prn ecind: tab rX94 \ tab rX94, nol
for X in any jbprc txs prn ecind: tab rX95 \ tab rX95, nol

for X in any jbprc txs prn ecind: tab rX97 \ tab rX97, nol
for X in any jbprc txs prn ecind: for Y in num 94/96: recode rXY (-3 -2=.) (97 98 99 = -99), gen(s_X_Y)  
for X in any  jbprc txs prn ieq ecind : for Y in num 92 97: recode rXY (-2=.) (97 98 99 = -99), gen(s_X_Y)
for X in any   ieq  : for Y in num 95 96: g s_X_Y = rXY if rXY<12 & rXY>0
for X in any jbprc txs prn ecind:  corr s_X_* 
for X in any jbprc txs prn ecind:  sum s_X_* 
corr s_*_* 
for X in any jbprc ecind \ Y in any jbp eci: rename s_X_92 s_Y_92
for X in any jbprc ecind \ Y in any jbp eci: rename s_X_94 s_Y_94
for X in any  jbprc ecind \ Y in any jbp eci: rename s_X_95 s_Y_95
for X in any jbprc ecind \ Y in any jbp eci: rename s_X_96 s_Y_96
for X in any jbprc ecind \ Y in any jbp eci: rename s_X_97 s_Y_97


/*  do placements calculated in years different from the years in which respondents on opinions assessed still matter?

*economic issues scale *I included the tax cut question but it doesn't correlate with the other items, has a factor loading of only 0.3176
for any jbp txs prn ieq : egen stde_X_92 =std(s_X_92)
*for any jbp txs prn: egen stde_X_94 =std(s_X_94)
for any jbp txs prn ieq  : egen stde_X_97=std(s_X_97)
for num 92 94:g kt_economic_X = k_jbp_X + k_txs_X + k_prn_X
sum stde_*_92
corr stde_*_92
corr stde_*_97
corr stde_*
factor stde_*_92 , pcf
 predict  economic_92
factor  stde_*_97 , pcf
 predict  economic_97
*sum k_jbp-k_ieq
* for any jbp txs prn: g k_X =k_X_92==1 & k_X_94==1 if k_X_92!=. & k_X_94!=.
for X in any jbp txs prn eci ieq: tab  k_X_97 k_X_92, 

    *Decreases the effect by about 0.1
sum k_jbp_* k_txs_* k_prn_* k_ieq_* 
corr k_jbp_* k_txs_* k_prn_* k_ieq_* 
drop k_*_92 k_*_97 
egen economic_placement =rowmean(k_jbp_* k_txs_* k_prn_* k_ieq_* )
xtile economic_placement_5 = economic_placement,n(5)
tabulate economic_placement economic_placement_5
bys economic_placement_5:corr  economic_92 economic_97
corr  economic_92 economic_97 if economic_placement<.3
corr  economic_92 economic_97 if economic_placement==1
*total correct number of responses
*/
for X in any jbp txs prn eci: g kt_X = k_X_92+k_X_94+k_X_95+k_X_96+k_X_97



*learning progression
for X in any jbp txs prn eci: g kt00111_X=k_X_92==0&k_X_94==0&k_X_95==1&k_X_96==1&k_X_97==1 if kt_X!=.
for X in any jbp txs prn eci: g kt00011_X=k_X_92==0&k_X_94==0&k_X_95==0&k_X_96==1&k_X_97==1 if kt_X!=.
for X in any jbp txs prn eci: g kt0011_X=k_X_92==0&k_X_94==0&k_X_95==0&k_X_96==1 if kt_X!=.
*for X in any jbp txs prn eci: g k_X = k_X_92==1 & k_X_94==1 if k_X_92!=.&k_X_94!=.
for X in any jbp txs prn eci ieq: g k_X_9297 = k_X_92==1 & k_X_97==1 if k_X_92!=.&k_X_97!=.
for X in any jbp txs prn eci ieq: g k_X_9295 = k_X_92==1 & k_X_95==1 if k_X_92!=.&k_X_95!=.
for X in any jbp txs prn eci ieq: g k_X_9296 = k_X_92==1 & k_X_96==1 if k_X_92!=.&k_X_96!=.
*drop people who get it right one wave and wrong the next 
*for X in any jbp txs prn eci ieq: for Y in num 95/97: replace  k_X_92Y =. if  (k_X_92+ k_X_Y)==1

*vote votelc*
tab  vote92 , nolab
tab  vote97
tab  vote2n97 if vote97 == -1
tab  vote2n97
 g voteall92 = vote92
sum vote9* vote2n*
recode  vote9* votlky* vote2n*  (1 =0) (2 = 1) (else =.)
sum votelc*  
corr votelc*  
for num 92 97: g vote_X = voteX
for num 94/96: g vote_X = votlkyX
for num 92 94/96 97: g vote2_X = vote_X
for num 92 94/96 97: replace vote2_X = vote2nX if vote_X ==.
sum vote_* vote2_*
corr vote_*

tab1 ptytha*
sum ptytha*
corr ptytha*
for num 92 94/97: g Tory_X=ptythaX==1 \ g labor_X=ptythaX==2
 tab ptycla92 ,nol mis
 tab ptytha92 ,nol mis
recode ptytha92  1 = 1 2 = 0 .=.  else = .5,gen(PID_92)
  replace PID_92 = 1 if ptycla92 == 1
  replace PID_92 = 0 if ptycla92 == 2
recode ptytha94  1 = 1 2 = 0 .=.  else = .5,gen(PID_94)
  replace PID_94 = 1 if ptycla94 == 1
  replace PID_94 = 0 if ptycla94 == 2
recode ptytha95  1 = 1 2 = 0 .=.  else = .5,gen(PID_95)
  replace PID_95 = 1 if ptycla95 == 1
  replace PID_95 = 0 if ptycla95 == 2
recode ptytha96  1 = 1 2 = 0 .=.  else = .5,gen(PID_96)
  replace PID_96 = 1 if ptycla96 == 1
  replace PID_96 = 0 if ptycla96 == 2
tabulate PID_92
tab ptyid97
tab ptyid97 ptythn97,mis
tab ptyid97 ptytha97,mis

recode ptyid97  1 = 1 2 = 0 .=.  else = .5,gen(PID_97)
tab2 PID_*
sum  s_*_92 s_*_97 PID_*
pwcorr  s_*_92 s_*_97 PID_*, obs

g weight =wtfactor
sum outcom* strttm*

*General knowledge scale construction and reliability calculations
/*
*reliability of political quiz measure of general knowledge
tab1 kinock92 mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,
tab2 kinock92 mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,
tab2 kinock92          ,
sum polq kinock92 mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92
corr kinock92 mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92
factor kinock92 mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,pcf
alpha kinock92 mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,item
alpha  mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,item

alpha k_eci_92 k_eci_95 k_eci_96 k_eci_97   mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,item
alpha k_eci_92 k_eci_95 k_eci_96 k_eci_97   mp100_92 ge4yr92 britpr92 whopcm92  ecgbel92 holnwm92  depost92 mossos92,item
*BES dropped the first question about Kinnock being leader of the Labor Party. I can see why. Detracts from reliability
alpha k_jbp_9296 k_txs_9296 k_prn_9296 k_ieq_9296, item
corr k_jbp_9296, 
*/
recode kinock92 whopcm92 elecrl92 ecgbel92 pmquen92 depost92 mossos92(1=1) (2 8=0) (9=.)
recode mp100_92 ge4yr92 britpr92 holnwm92  (2=1) (1 8=0) (9=.)
egen knowledge_not_missing =rownonmiss(mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92)
tabulate knowledge_not_missing
drop if knowledge_not_missing <10
sum k_eci_92 k_eci_95 k_eci_96 k_eci_97   mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92
for var  k_eci_92 k_eci_95 k_eci_96 k_eci_97    mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92: impute X   mp100_92 ge4yr92 britpr92 whopcm92 elecrl92 ecgbel92 holnwm92 pmquen92 depost92 mossos92,gen(i_X)

*alpha i_*,item
alpha i_*,
*corr i_*,
sum i_*,
*drop *_eci_*
alpha k_*_9295, item
alpha k_*_9296, item
alpha k_*_9297, item
*alpha k_*_97, iteme
egen general_knowledge = rowtotal(i_*)
alpha i_*, item

pwcorr general_knowledge polq k_*_9297,obs
*kdensity general_knowledge								
