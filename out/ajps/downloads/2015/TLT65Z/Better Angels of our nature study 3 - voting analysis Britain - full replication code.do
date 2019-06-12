*****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 3: Voting Behaviour (British voters) Conducted using the British Comparative Campaign Analysis Project data****
***Final analysis replication do file***
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 1 bccap final.dta", which is in the "Better Angels of Our Nature" folder at dataverse****

*******Regression models of impact of MCP on voting behaviour, with full interactions tests and robustness checks***

****Please refer to demographics do file for details of setting up variables
****Regressions run on wave 2 and wave 3 data from the B-CCAP dataset. 

****Final set of models, limited vote choice (Lab, Con, LD, UKIP, BNP), Labour reference group, run on all of GB 

****Model 1: mcp only

gen votew3lim = votew3
recode votew3lim (9=.) (10=.) 
gen mcp01 = mcp/4

mlogit votew2lim mcp01 if nonwhite==0, base(1) 

mlogit votew3lim mcp01 if nonwhite==0, base(1) 

***Model 2: mcp and control for immigration attitudes

mlogit votew2lim mcp01 immscale01 if nonwhite==0, base(1) 

mlogit votew3lim mcp01 immscale01 if nonwhite==0, base(1) 

****Model 3: Add full demographics 

***Full demographic model

#delimit ;
nestreg: mlogit votew2lim (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (ageunder30 age30s age40s age50s) (gcse alevel degree othqual edumiss)
(male) (unionmember) (unskilman skilman petbou rnonm) (incpens incbens) (ownhouse mortgage rentla) 
if nonwhite==0, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (ageunder30 age30s age40s age50s) (gcse alevel degree othqual edumiss)
(male) (unionmember) (unskilman skilman petbou rnonm) (incpens incbens) (ownhouse mortgage rentla) 
if nonwhite==0, base(1); 


***Model 4: Reduced demographics

#delimit ;
nestreg: mlogit votew2lim (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0, base(1); 


***Model 5: Leader assessments

mlogit votew2lim immscale01 mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0, base(1) 

mlogit votew3lim immscale01 mcp01 gbcompw3 dccompw3 nccompw3 if nonwhite==0, base(1) 

****Model 6: Issues and govt performance on them (no imm most important issue) 

nestreg: mlogit votew2lim (immscale01 mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) if nonwhite==0, base(1) 

nestreg: mlogit votew3lim (immscale01 mcp01 crimeupw3 nhsworsew3) (govperfcrimw3 govperfnhsw3) (govperfterw3 govperfasyw3)  if nonwhite==0, base(1) 


***Model 7: MCP and PID (NB - 

***Wave 1 measure

gen conIDw1 = 0
replace conIDw1 = 1 if w1_p770q1==2

gen labIDw1 = 0
replace labIDw1 = 1 if w1_p770q1==1

gen ldIDw1 = 0
replace ldIDw1 = 1 if w1_p770q1==3

****Wave 2 measure

gen conIDw2 = 0
replace conIDw2 = 1 if w2_p770q1==2

gen labIDw2 = 0
replace labIDw2 = 1 if w2_p770q1==1

gen ldIDw2 = 0
replace ldIDw2 = 1 if w2_p770q1==3

xi: mlogit votew2lim mcp01 conIDw1 labIDw1 ldIDw1 if nonwhite==0 , base(1) 

xi: mlogit votew3lim mcp01 conIDw2 labIDw2 ldIDw2 if nonwhite==0 , base(1) 

***Model 8: MCP, imm and PID

xi: mlogit votew2lim mcp01 immscale01 conIDw1 labIDw1 ldIDw1 if nonwhite==0 , base(1) 

xi: mlogit votew3lim mcp01 immscale01 conIDw2 labIDw2 ldIDw2 if nonwhite==0 , base(1) 

****Model xx: LR self placement and placement of parties

xi: mlogit votew2lim mcp01 immscale01 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 if nonwhite==0 , base(1) 

xi: mlogit votew3lim mcp01 immscale01  lrselfplacew3 lrlabplacew3 lrldplacew3 lrconplacew3 if nonwhite==0 , base(1) 

***Model yy: Economic evaluations

xi: mlogit votew2lim mcp01 immscale01 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 if nonwhite==0 , base(1) 

xi: mlogit votew3lim mcp01 immscale01 natecoretw3 natecoprospw3 perecoretw3 perecoprospw3 if nonwhite==0 , base(1) 

***Model 9: MCP, imm, political interest, satisfaction with Dem

xi: mlogit votew2lim mcp01 immscale01 polintw2 satdemw2 if nonwhite==0 , base(1) 

xi: mlogit votew3lim mcp01 immscale01 polintw3 satdemw3 if nonwhite==0 , base(1) 


***Model 10: Combined model excluding issues 

#delimit ;
nestreg: mlogit votew2lim (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 
polintw2 satdemw2 conIDw1 labIDw1 ldIDw1) if nonwhite==0, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 lrselfplacew3 lrlabplacew3 lrldplacew3 lrconplacew3 natecoretw3 natecoprospw3 perecoretw3 perecoprospw3 
polintw3 satdemw3 conIDw2 labIDw2 ldIDw2) if nonwhite==0, base(1); 


****Model 11: #10 + issues

#delimit ;
nestreg: mlogit votew2lim (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2) 
(conIDw1 labIDw1 ldIDw1) if nonwhite==0, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3
lrselfplacew3 lrlabplacew3 lrldplacew3 lrconplacew3 natecoretw3 natecoprospw3 perecoretw3 perecoprospw3 polintw3 satdemw3)
(conIDw2 labIDw2 ldIDw2) if nonwhite==0, base(1); 


*******AMP MODELS************


***Model 2: mcp and control for immigration attitudes

mlogit votew2lim AMPdiff mcp01 if nonwhite==0 & valid==1, base(1) 

mlogit votew3lim AMPdiff mcp01 if nonwhite==0 & valid==1, base(1) 

****Model 3: Add full demographics 

***Full demographic model

gen votew2lim = votew2
recode votew2lim (9=.) (10=.)

#delimit ;
nestreg: mlogit votew2lim (mcp01 AMPdiff north mids scot wales ageunder30 age30s age40s age50s gcse alevel degree edumiss 
male unionmember unskilman skilman rnonm incpens incbens ownhouse mortgage rentla) if nonwhite==0 & valid==1, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 AMPdiff north mids scot wales ageunder30 age30s age40s age50s gcse alevel degree edumiss 
male unionmember unskilman skilman rnonm incpens incbens ownhouse mortgage rentla) if nonwhite==0 & valid==1, base(1); 


***Model 5: Leader assessments

mlogit votew2lim AMPdiff mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0 & valid==1, base(1) 

mlogit votew3lim AMPdiff mcp01 gbcompw3 dccompw3 nccompw3 if nonwhite==0 & valid==1, base(1) 

****Model 6: Issues and govt performance on them

nestreg: mlogit votew2lim (AMPdiff mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2) if nonwhite==0 & valid==1, base(1) 

nestreg: mlogit votew3lim (AMPdiff mcp01 crimeupw3 nhsworsew3) (govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3) (immiiw3)  if nonwhite==0 & valid==1, base(1) 

***Model 8: MCP, imm and PID

xi: mlogit votew2lim mcp01 AMPdiff conIDw1 labIDw1 ldIDw1 if nonwhite==0 & valid==1, base(1) 

xi: mlogit votew3lim mcp01 AMPdiff conIDw2 labIDw2 ldIDw2 if nonwhite==0 & valid==1, base(1) 

****Model xx: MCP, AMP and LR placements

xi: mlogit votew2lim mcp01 AMPdiff lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 if nonwhite==0 & valid==1, base(1) 

xi: mlogit votew3lim mcp01 AMPdiff lrselfplacew3 lrlabplacew3 lrldplacew3 lrconplacew3 if nonwhite==0 & valid==1, base(1) 

***Model yy: MCP, AMP and economic assessments

xi: mlogit votew2lim mcp01 AMPdiff natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 if nonwhite==0 & valid==1, base(1) 

xi: mlogit votew3lim mcp01 AMPdiff natecoretw3 natecoprospw3 perecoretw3 perecoprospw3 if nonwhite==0 & valid==1 , base(1) 

***Model 9: MCP, imm, political interest, satisfaction with Dem

xi: mlogit votew2lim mcp01 AMPdiff polintw2 satdemw2 if nonwhite==0 & valid==1, base(1) 

xi: mlogit votew3lim mcp01 AMPdiff polintw3 satdemw3 if nonwhite==0 & valid==1, base(1) 

***Model 10 : Combined, excluding issues

#delimit ;
nestreg: mlogit votew2lim (mcp01 AMPdiff gbcompw2 dccompw2 nccompw2 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 
polintw2 satdemw2) if nonwhite==0 & valid==1, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 AMPdiff gbcompw3 dccompw3 nccompw3 lrselfplacew3 lrlabplacew3 lrldplacew3 lrconplacew3 natecoretw3 natecoprospw3 perecoretw3 perecoprospw3 
polintw3 satdemw3) if nonwhite==0 & valid==1, base(1); 

***Model 11: Combined, adding in issues

#delimit ;
nestreg: mlogit votew2lim (mcp01 AMPdiff gbcompw2 dccompw2 nccompw2 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 
polintw2 satdemw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2) if nonwhite==0 & valid==1, base(1); 

#delimit ;
nestreg: mlogit votew3lim (mcp01 AMPdiff gbcompw3 dccompw3 nccompw3 lrselfplacew3 lrlabplacew3 lrldplacew3 lrconplacew3 natecoretw3 natecoprospw3 perecoretw3 perecoprospw3 
polintw3 satdemw3 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2) if nonwhite==0 & valid==1, base(1); 


*****Ever support fringe right vs all others

gen radrtever = 0
replace radrtever = . if  w1_p10q1==.
replace radrtever = 1 if  w1_p807q1==8
replace radrtever = 1 if  w1_p814q1==8
replace radrtever = 1 if  w2_p807q1==8
replace radrtever = 1 if  w2_p814q1==8
replace radrtever = 1 if  w3_p807q1==8
replace radrtever = 1 if  w3_p814q1==8
replace radrtever = 1 if  w4_p807q1==8
replace radrtever = 1 if  w4_p814q1==8
replace radrtever = 1 if  w5_p807q1==8
replace radrtever = 1 if  w5_p814q1==8
replace radrtever = 1 if w6_p10050q4==8

replace radrtever = 1 if  w1_p807q1==7
replace radrtever = 1 if  w1_p814q1==7
replace radrtever = 1 if  w2_p807q1==7
replace radrtever = 1 if  w2_p814q1==7
replace radrtever = 1 if  w3_p807q1==7
replace radrtever = 1 if  w3_p814q1==7
replace radrtever = 1 if  w4_p807q1==7
replace radrtever = 1 if  w4_p814q1==7
replace radrtever = 1 if  w5_p807q1==7
replace radrtever = 1 if  w5_p814q1==7
replace radrtever = 1 if w6_p10050q4==7

****Ever support BNP vs all others 

gen bnpever = 0

replace bnpever = 1 if  w1_p807q1==7
replace bnpever = 1 if  w1_p814q1==7
replace bnpever = 1 if  w2_p807q1==7
replace bnpever = 1 if  w2_p814q1==7
replace bnpever = 1 if  w3_p807q1==7
replace bnpever = 1 if  w3_p814q1==7
replace bnpever = 1 if  w4_p807q1==7
replace bnpever = 1 if  w4_p814q1==7
replace bnpever = 1 if  w5_p807q1==7
replace bnpever = 1 if  w5_p814q1==7

replace bnpever = 1 if w6_p10050q4==7

replace bnpever = . if  w1_p10q1==.


****Model 1: mcp only

logit bnpever mcp01 if nonwhite==0

logit radrtever mcp01 if nonwhite==0

***Model 2: mcp and control for immigration attitudes

logit bnpever mcp01 immscale01 if nonwhite==0

logit radrtever mcp01 immscale01 if nonwhite==0

****Model 3: Demographics 

#delimit ;
nestreg: logit bnpever (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0;

#delimit ;
nestreg: logit radrtever (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0;

***Model 5: Leader assessments

logit bnpever immscale01 mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0 

logit radrtever immscale01 mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0 

****Model 6: Issues and govt performance on them

nestreg: logit bnpever (immscale01 mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) if nonwhite==0 

nestreg: logit radrtever (immscale01 mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) if nonwhite==0 

***Model 8: MCP, imm and PID

logit bnpever mcp01 immscale01 conIDw1 labIDw1 ldIDw1 if nonwhite==0

logit radrtever mcp01 immscale01 conIDw1 labIDw1 ldIDw1 if nonwhite==0

****Model xx: MCP, imm and left-right self placement

logit bnpever mcp01 immscale01 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 if nonwhite==0

logit radrtever mcp01 immscale01 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 if nonwhite==0

***Model yy: MCP, AMP and economic assessments

logit bnpever mcp01 immscale01 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 if nonwhite==0 

logit radrtever mcp01 immscale01 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 if nonwhite==0 


***Model 9: MCP, imm, political interest, satisfaction with Dem

logit bnpever mcp01 immscale01 polintw2 satdemw2 if nonwhite==0  

logit radrtever mcp01 immscale01 polintw2 satdemw2 if nonwhite==0 


***Model 10: Combined model excluding issues 

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2) (natecoretw2 natecoprospw2 perecoretw2 perecoprospw2) 
(polintw2 satdemw2) (conIDw1 labIDw1 ldIDw1) if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 
polintw2 satdemw2 conIDw2 labIDw2 ldIDw2) if nonwhite==0; 


****Model 11: #10 + issues

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2) 
(conIDw1 labIDw1 ldIDw1) if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 
lrselfplacew2 lrlabplacew2 lrldplacew2 lrconplacew2 natecoretw2 natecoprospw2 perecoretw2 perecoprospw2 polintw2 satdemw2) 
(conIDw1 labIDw1 ldIDw1) if nonwhite==0; 


****IMPLICIT MODELS : EVER SUPPORTED FRINGE RIGHT

***Model 2: mcp and control for immigration attitudes

logit radrtever mcp01 AMPdiff if nonwhite==0

****Model 3: Add full demographics 

***Full demographic model

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff) (neast nwest yhum emids wmids eastern seast swest) (ageunder30 age30s age40s age50s) (gcse alevel degree othqual edumiss)
(male) (unionmember) (unskilman skilman petbou rnonm) (incpens incbens) (mailexp sunstar mirror telegraph guardian nopaper) (ownhouse mortgage rentla) 
if nonwhite==0; 

***Model 4: Reduced demographics

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0;

***Model 5: Leader assessments

logit radrtever AMPdiff mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0 

****Model 6: Issues and govt performance on them

nestreg: logit radrtever (AMPdiff mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) (immiiw2) if nonwhite==0 

nestreg: logit radrtever (AMPdiff mcp01 crimeupw3 nhsworsew3) (govperfcrimw3 govperfnhsw3) (govperfterw3 govperfasyw3) (immiiw3)  if nonwhite==0 

****Model 6a: Issues and govt performance on them - no crime, asy, immii

nestreg: logit radrtever (AMPdiff mcp01 nhsworsew2) (govperfnhsw2) (govperfterw2) if nonwhite==0 

nestreg: logit radrtever (AMPdiff mcp01 nhsworsew3) (govperfnhsw3) (govperfterw3) if nonwhite==0 

***Model 8: MCP, imm and PID

logit radrtever mcp01 AMPdiff conIDw1 labIDw1 ldIDw1 if nonwhite==0 

logit radrtever mcp01 AMPdiff conIDw2 labIDw2 ldIDw2 if nonwhite==0 


***Model 9: MCP, imm, political interest, satisfaction with Dem

logit radrtever mcp01 AMPdiff polintw2 satdemw2 if nonwhite==0  

logit radrtever mcp01 AMPdiff polintw3 satdemw3 if nonwhite==0 


***Model 10: #4 + #5 + #6

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2) if nonwhite==0;  

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw3 dccompw3 nccompw3) (crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3) if nonwhite==0; 


***Model 11: #10 without crime, perf asylum and imm most imp issue

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (nhsworsew2 govperfnhsw2 govperfterw2) if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw3 dccompw3 nccompw3) (nhsworsew3 govperfnhsw3 govperfterw3) if nonwhite==0; 


****Model 12: #10 + #8

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2) (conIDw1 labIDw1 ldIDw1)
if nonwhite==0; 


#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3) (conIDw2 labIDw2 ldIDw2)
if nonwhite==0; 


****Model 13: #11 + #8

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 nhsworsew2 govperfnhsw2 govperfterw2) (conIDw1 labIDw1 ldIDw1)
if nonwhite==0; 


#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 nhsworsew3 govperfnhsw3 govperfterw3) (conIDw2 labIDw2 ldIDw2)
if nonwhite==0; 

****Model 14: #12 + #9

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2 conIDw1 labIDw1 ldIDw1) (polintw2 satdemw2)  if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3 conIDw2 labIDw2 ldIDw2) (polintw3 satdemw3)  if nonwhite==0; 

***Model 15: #13 + # 9

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 nhsworsew2 govperfnhsw2 govperfterw2) (conIDw1 labIDw1 ldIDw1 polintw2 satdemw2)
if nonwhite==0; 


#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 nhsworsew3 govperfnhsw3 govperfterw3) (conIDw2 labIDw2 ldIDw2 polintw3 satdemw3)
if nonwhite==0; 

*****EXPLICT MODELS - EVER SUPPORT BNP

****Model 1: mcp only

logit bnpever mcp01 if nonwhite==0

***Model 2: mcp and control for immigration attitudes

logit bnpever mcp01 immscale01 if nonwhite==0

****Model 3: Add full demographics 

***Full demographic model

#delimit ;
nestreg: logit bnpever (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (ageunder30 age30s age40s age50s) (gcse alevel degree othqual edumiss)
(male) (unionmember) (unskilman skilman petbou rnonm) (incpens incbens) (mailexp sunstar mirror telegraph guardian nopaper) (ownhouse mortgage rentla) 
if nonwhite==0; 

***Model 4: Reduced demographics

#delimit ;
nestreg: logit bnpever (mcp01 immscale01) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0;

***Model 5: Leader assessments

logit bnpever immscale01 mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0 

****Model 6: Issues and govt performance on them

nestreg: logit bnpever (immscale01 mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) (immiiw2) if nonwhite==0 

nestreg: logit bnpever (immscale01 mcp01 crimeupw3 nhsworsew3) (govperfcrimw3 govperfnhsw3) (govperfterw3 govperfasyw3) (immiiw3)  if nonwhite==0 

****Model 6a: Without immii

nestreg: logit bnpever (immscale01 mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) if nonwhite==0 


***Model 7: MCP and PID (NB - 

logit bnpever mcp01 conIDw1 labIDw1 ldIDw1 if nonwhite==0 

logit bnpever mcp01 conIDw2 labIDw2 ldIDw2 if nonwhite==0 

***Model 8: MCP, imm and PID

logit bnpever mcp01 immscale01 conIDw1 labIDw1 ldIDw1 if nonwhite==0 

logit bnpever mcp01 immscale01 conIDw2 labIDw2 ldIDw2 if nonwhite==0 


***Model 9: MCP, imm, political interest, satisfaction with Dem

logit bnpever mcp01 immscale01 polintw2 satdemw2 if nonwhite==0  

logit bnpever mcp01 immscale01 polintw3 satdemw3 if nonwhite==0 


***Model 10: #4 + #5 + #6

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2) if nonwhite==0;  

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw3 dccompw3 nccompw3) (crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3) if nonwhite==0; 


***Model 11: #10 without  imm most imp issue

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2) if nonwhite==0;  

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw3 dccompw3 nccompw3) (crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3) if nonwhite==0; 


****Model 12: #10 + #8

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2) (conIDw1 labIDw1 ldIDw1)
if nonwhite==0; 


#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3) (conIDw2 labIDw2 ldIDw2)
if nonwhite==0; 


****Model 13: #11 + #8

#delimit ;
nestreg: logit radrtever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 nhsworsew2 govperfnhsw2 govperfterw2) (conIDw1 labIDw1 ldIDw1)
if nonwhite==0; 


#delimit ;
nestreg: mlogit votew3lim (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 nhsworsew3 govperfnhsw3 govperfterw3) (conIDw2 labIDw2 ldIDw2)
if nonwhite==0, base(1); 

****Model 14: #12 + #9

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2) (conIDw1 labIDw1 ldIDw1) 
(polintw2 satdemw2)  if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 conIDw2 labIDw2 ldIDw2) 
(polintw3 satdemw3)  if nonwhite==0; 

***Model 15: #13 + #9 

#delimit ;
nestreg: logit bnpever (mcp01 immscale01 neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 conIDw1 labIDw1 ldIDw1) (polintw2 satdemw2)  if nonwhite==0; 

****IMPLICIT MODELS : EVER SUPPORTED BNP

***Model 2: mcp and control for immigration attitudes

logit bnpever mcp01 AMPdiff if nonwhite==0

****Model 3: Add full demographics 

***Full demographic model

#delimit ;
nestreg: logit bnpever (mcp01 AMPdiff) (neast nwest yhum emids wmids eastern seast swest) (ageunder30 age30s age40s age50s) (gcse alevel degree othqual edumiss)
(male) (unionmember) (unskilman skilman petbou rnonm) (incpens incbens) (mailexp sunstar mirror telegraph guardian nopaper) (ownhouse mortgage rentla) 
if nonwhite==0; 

***Model 4: Reduced demographics

#delimit ;
nestreg: logit bnpever (mcp01 AMPdiff) (neast nwest yhum emids wmids eastern seast swest) (gcse alevel degree othqual edumiss) (ageunder30 age30s age40s age50s)
(male) (unionmember) (working) (incbens) if nonwhite==0;

***Model 5: Leader assessments

logit radrtever AMPdiff mcp01 gbcompw2 dccompw2 nccompw2 if nonwhite==0 

****Model 6: Issues and govt performance on them

nestreg: logit radrtever (AMPdiff mcp01 crimeupw2 nhsworsew2) (govperfcrimw2 govperfnhsw2) (govperfterw2 govperfasyw2) (immiiw2) if nonwhite==0 

nestreg: logit radrtever (AMPdiff mcp01 crimeupw3 nhsworsew3) (govperfcrimw3 govperfnhsw3) (govperfterw3 govperfasyw3) (immiiw3)  if nonwhite==0 

****Model 6a: Issues and govt performance on them - no crime, asy, immii

nestreg: logit radrtever (AMPdiff mcp01 nhsworsew2) (govperfnhsw2) (govperfterw2) if nonwhite==0 

nestreg: logit radrtever (AMPdiff mcp01 nhsworsew3) (govperfnhsw3) (govperfterw3) if nonwhite==0 

***Model 8: MCP, imm and PID

logit radrtever mcp01 AMPdiff conIDw1 labIDw1 ldIDw1 if nonwhite==0 

logit radrtever mcp01 AMPdiff conIDw2 labIDw2 ldIDw2 if nonwhite==0 


***Model 9: MCP, imm, political interest, satisfaction with Dem

logit radrtever mcp01 AMPdiff polintw2 satdemw2 if nonwhite==0  

logit radrtever mcp01 AMPdiff polintw3 satdemw3 if nonwhite==0 


***Model 10: #4 + #5 + #6

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2) if nonwhite==0;  

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw3 dccompw3 nccompw3) (crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3) if nonwhite==0; 


***Model 11: #10 without crime, perf asylum and imm most imp issue

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw2 dccompw2 nccompw2) (nhsworsew2 govperfnhsw2 govperfterw2) if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens) (gbcompw3 dccompw3 nccompw3) (nhsworsew3 govperfnhsw3 govperfterw3) if nonwhite==0; 


****Model 12: #10 + #8

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2) (conIDw1 labIDw1 ldIDw1)
if nonwhite==0; 


#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3) (conIDw2 labIDw2 ldIDw2)
if nonwhite==0; 


****Model 13: #11 + #8

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 nhsworsew2 govperfnhsw2 govperfterw2) (conIDw1 labIDw1 ldIDw1)
if nonwhite==0; 


#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 nhsworsew3 govperfnhsw3 govperfterw3) (conIDw2 labIDw2 ldIDw2)
if nonwhite==0; 

****Model 14: #12 + #9

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 crimeupw2 nhsworsew2 govperfcrimw2 govperfnhsw2 govperfterw2 govperfasyw2 immiiw2 conIDw1 labIDw1 ldIDw1) (polintw2 satdemw2)  if nonwhite==0; 

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 crimeupw3 nhsworsew3 govperfcrimw3 govperfnhsw3 govperfterw3 govperfasyw3 immiiw3 conIDw2 labIDw2 ldIDw2) (polintw3 satdemw3)  if nonwhite==0; 

***Model 15: #13 + # 9

#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw2 dccompw2 nccompw2 nhsworsew2 govperfnhsw2 govperfterw2) (conIDw1 labIDw1 ldIDw1 polintw2 satdemw2)
if nonwhite==0; 


#delimit ;
nestreg: logit radrtever (mcp01 AMPdiff neast nwest yhum emids wmids eastern seast swest scot wales gcse alevel degree othqual edumiss ageunder30 age30s age40s age50s
male unionmember working incbens gbcompw3 dccompw3 nccompw3 nhsworsew3 govperfnhsw3 govperfterw3) (conIDw2 labIDw2 ldIDw2 polintw3 satdemw3)
if nonwhite==0; 


