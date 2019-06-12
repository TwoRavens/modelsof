use  Data/1997-2001BESPanel.dta, clear
 *Looks like they have the four economic issues in every wave
 sum conjbp* 
 sum contxs*
 sum conprn* conpr01
 sum conieq*
for any coneci caneci conwh2 coneqo conbas conwht: sum X*

*feeling about parties
tab1  confe* labfel* ,nol
recode confe* labfel*  (-8 8/9 =.)
sum confe* labfel* 
for var confe* labfel* : replace X = 1- (X-1)/4
for any 97 98 99 00 01: g l_c_X = (confelX -labfelX+ 1)/2
for any 97 98 99 00 01: g therm_X = l_c_X
sum l_c_* therm_*
corr l_c_*

*respondent view
rename *prfw* *prn*  //  inconsistent name
rename *txspd* *txs*  //  inconsistent name
for any jbp txs  ieq eci prn : sum rX*
for X in any jbprc txs ecind prn : tab rX97 \ tab rX97, nol
for X in any jbprc txs ecind  prn: tab rX01 \ tab rX01, nol
for X in any jbprc txs prn ieq ecind: for Y in any 97 01: recode rXY ( -8/-1 =.) (12 = 1) (13 =11) (97 98 99 = -99), gen(s_X_Y)  
for X in any jbprc ecind \ Y in any jbp eci: rename s_X_97 s_Y_97
for X in any jbprc ecind \ Y in any jbp eci: rename s_X_01 s_Y_01

*recode s_* (-99 =.)
corr s_*_97
corr s_*_01
for X in any jbp txs prn eci:  corr s_X_*
for X in any jbp txs prn eci:  sum s_X_* 


* PARTY PLACEMENTS
*ieq not asked in 1994 ieq 
*for any jbp txs prn ieq  : tab1 labX*,nol
rename conpr01 conprn01
rename labpr01 labprn01
/*
for any jbp txs prn eci: tab1 labX*,nol
for any txs prn eci: tab labX97 rX97,
for any txs prn eci: tab conX97 rX97,

for any jbp txs prn eci: tab1 labX*
for any jbp txs prn ieq eci : tab1 labX97 \ tab1 labX97,nol

for any jbp txs prn ieq eci : tab1 labX* \ tab1 labX*,nol
*for X in any jbp txs prn ieq : for Y in any 97 01: recode conXY labXY ( -8/-1 =.) (12 = 1) (13 =11) (97 98 99 = -99),
*for X in any eci: for Y in any 97 98 99 00 01: recode conXY labXY ( -8/-1 =.) (12 = 1) (13 =11) (97 98 99 = -99), 
*/
*Correct placements
*relative positions
for X in any jbp txs prn ieq : for Y in any 97 01: g k_X_Y = labXY<conXY & labXY!=-99 & conXY!= -99 if labXY<. & conXY<. 
for X in any eci : for Y in any  97 98 99 00 01:   g k_X_Y = labXY<conXY & labXY!=-99 & conXY!= -99 if labXY<. & conXY<. 
sum k_*
for any jbp txs prn ieq eci : sum k_X_97  s_X_97  k_X_01  s_X_01 
for any jbp txs prn ieq eci : tabulate labX97 conX97 if k_X_97 == 1 \ tabulate labX97 conX97 if k_X_97 == 0
corr k_*
for X in any jbp txs prn eci ieq: g k_X= k_X_97==1 & k_X_01==1 if k_X_97!=.&k_X_01!=.
sum k_*
corr k_*
for any jbp txs prn ieq eci: sum k_X_*

*vote
tab  vote97
tab  vote01 ,
recode  vote97 vote01  (1 =1) (2 =0) (else =.)
sum votelc*  
corr votelc*  
for any 97 01: g vote_X = voteX
sum vote_* 
corr vote_*

tab1 ptythn*
tab1 ptythn*
tab1 ptycls*,nol
recode ptythn97  1 = 1 2 = 0 .=.  else = .5,gen(PID_97)
  replace PID_97 = 1 if ptycls97 == 1
  replace PID_97 = 0 if ptycls97 == 2
recode ptythn01  1 = 1 2 = 0 .=.  else = .5,gen(PID_01)
  replace PID_01 = 1 if ptycls01 == 1
  replace PID_01 = 0 if ptycls01 == 2
tabulate PID_97 PID_01,mis

sum  s_*_* PID_*
pwcorr   s_*_97 PID_97, obs

g weight =wtallgb

*General knowledge scale construction and reliability calculations
/*
*they have a 1997 scale  that seems crappy
*I looked pretty hard for any other knowledge battery in 98-01, but couldn't find anything
*/
tab1 thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  

tab1 thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  ,nol
recode thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97 (1 = 1) (2 8 = 0) (9 =.)
sum thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_eci_*
pwcorr thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_*_*

alpha thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_eci_* , item


egen knowledge_not_missing =rownonmiss( thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_eci_* )
tabulate knowledge_not_missing 
drop if knowledge_not_missing <7 
sum  thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_eci_* 
for var  thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_eci_* : impute X   thatch97 mp100_97 ge4yr britpr97 whopcm97 ecgbel97 depost97  k_eci_* ,gen(i_X)

alpha i_*,item
alpha i_*,

*corr i_*,
sum i_*,
*drop *_eci_*
egen general_knowledge = rowtotal(i_*)
pwcorr general_knowledge polq k_*
*kdensity general_knowledge								

/*
tab hhinc497 
tab hhinc497 ,nol
recode hhinc497 -1  95/99 =. 4 = 1 1/3 =0,g(top_quartile)
recode hhinc497 -1  95/99 =. ,
egen total_knowledge = rowtotal(k_jbp- k_ieq)
corr hhinc497 total_knowledge general_knowledge
kdensity general_knowledge
norm total_knowledge
tw lpoly total_knowledge hhinc497 ||  lpoly general_knowledge hhinc497
tab total_knowledge,sum(top_quartile)
tab total_knowledge,sum(top_quartile)
tab hhinc497,sum(total_knowledge)
tab hhinc497,sum(total_knowledge)
tab hhinc497,sum(general_knowledge)
for any k_jbp k_txs k_prn k_eci k_ieq:tab hhinc497,sum(X)
regress total_knowledge top_quartile 
*/
