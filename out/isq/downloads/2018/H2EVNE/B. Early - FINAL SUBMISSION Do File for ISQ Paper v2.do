*** This is the dofile for generating results in: "Sleeping with Your Friends' Enemies: An Explanation of Sanctions-Busting Trade" in International Studies Quarterly****
*** Author Information: Bryan R. Early, University of Georgia Department of International Affairs / Harvard University's Belfer Center for Science and International Affairs***
*** For questions or comments, contact at: b.early1@gmail.com***
*** Note: This dofile needs Long and Freese's (2006) suite of "S-Post" commands to work properly***

************** Generating Data on Sanctions-Busting Dependent Variable for Footnote #11 **************

tab SBflage SBflagi if  NotInFullModel==0

*********** Command Code for Table 3 in ISQ Paper **************

*** Model 1 (Realist Model w/o Controls)***
logit SBjoint TargDP SendRival  SendDP TargRival nobust _spline1 _spline2 _spline3, robust

*** Model 2 (Realist Model w Controls)***
logit SBjoint majpow3 TargDP SendRival  SendDP TargRival lndist Contig cost orgsender duration  overlap nobust _spline1 _spline2 _spline3, robust

*** Model 3 (Liberal Model w/o Controls)***
logit SBjoint colony  jointDem lnGDP3  lagTrShare3 lagOpen3  lnGDPT nobust _spline1 _spline2 _spline3, robust

*** Model 4 (Liberal Model w Controls)***
logit SBjoint colony  jointDem lnGDP3  lagTrShare3 lagOpen3 lndist majpow3 Contig lnGDPT cost orgsender duration  overlap nobust _spline1 _spline2 _spline3, robust

*** Model 5 (Full Model) ***
logit SBjoint colony  jointDem majpow3 lnGDP3  lagTrShare3 lagOpen3 TargDP SendRival  SendDP TargRival  lndist Contig lnGDPT cost orgsender duration  overlap nobust _spline1 _spline2 _spline3, robust

************** Command Code for Generating Odds Ratios and Summary Data Reported in Paper using the Full Model **************
logit SBjoint colony  jointDem majpow3 lnGDP3  lagOpen3 lagTrShare3 TargDP SendRival  SendDP TargRival  lndist Contig lnGDPT cost orgsender duration  overlap nobust _spline1 _spline2 _spline3, robust

fitstat
estat class

listcoef	colony
listcoef	jointDem
listcoef	majpow3
listcoef	lnGDP3  
listcoef	lagOpen3 
listcoef	lagTrShare3 
listcoef	TargDP 
listcoef	SendRival  
listcoef	SendDP 
listcoef	TargRival 
listcoef	lndist 
listcoef	Contig 
listcoef	lnGDPT 
listcoef	cost 
listcoef	orgsender 
listcoef	duration  
listcoef	overlap
listcoef	nobust

**************Command Code for Generating Predicted Probabilities in Table 4**************

***Retrieving Summary Information for Variable Values***
summ lnGDP3 if  NotInFullModel==0, detail
summ lagOpen3 if  NotInFullModel==0, detail
summ lagTrShare3 if  NotInFullModel==0, detail
summ lndist if  NotInFullModel==0, detail
summ lnGDPT if  NotInFullModel==0, detail 


*** Table 4, Quad I - Lib at 25%, State Interests Present***
prvalue if NotInFullModel==0, x(colony=0 jointDem=0 majpow3=1 lnGDP3=  8.166098 lagOpen3=.1070893 lagTrShare3=3.26e-06 TargDP=1 SendRival=1  SendDP=0 TargRival=0 Contig=0 overlap=1 orgsender=0 cost=2 duration=3 lndist=8.521185 lnGDPT=10.29741 nobust=0 _spline1=0 _spline2=0 _spline3=0)

*** Table 4,Quad II- Lib at 25%, State Interests Opposed***
prvalue if NotInFullModel==0, x(colony=0 jointDem=0 majpow3=1 lnGDP3=  8.166098 lagOpen3=.1070893 lagTrShare3=3.26e-06 TargDP=0 SendRival=0  SendDP=1 TargRival=1 Contig=0 overlap=1 orgsender=0 cost=2 duration=3 lndist=8.521185 lnGDPT=10.29741 nobust=0  _spline1=0 _spline2=0 _spline3=0) 

*** Table 4,Quad III- Lib at 75%, State Interests Opposed***
prvalue if NotInFullModel==0, x(colony=1 jointDem=1 majpow3=1 lnGDP3=   10.913 lagOpen3=.3499706 lagTrShare3=.0028251  TargDP=0 SendRival=0  SendDP=1 TargRival=1 Contig=0 overlap=1 orgsender=0 cost=2 duration=3 lndist=8.521185 lnGDPT=10.29741 nobust=0 _spline1=0 _spline2=0 _spline3=0) 

*** Table 4, Quad IV- Lib at 75%, State Interests Present***
prvalue if NotInFullModel==0, x(colony=1 jointDem=1 majpow3=1 lnGDP3=   10.913 lagOpen3=.3499706 lagTrShare3=.0028251  TargDP=1 SendRival=1  SendDP=0 TargRival=0 Contig=0 overlap=1 orgsender=0 cost=2 duration=3 lndist=8.521185 lnGDPT=10.29741 nobust=0 _spline1=0 _spline2=0 _spline3=0) 

************** Generating Data for Graph 1 **************
logit SBjoint colony  jointDem majpow3 lnGDP3  lnGDP3 lagOpen3 lagTrShare3 TargDP SendRival  SendDP TargRival  lndist Contig lnGDPT cost orgsender duration  overlap nobust _spline1 _spline2 _spline3, robust

predict probsb
gen predSB=.
replace predSB=0 if probsb!=.
replace predSB=1 if probsb>.5 & probsb!=.

sort thirdcode

**Actual Flagged Sanctions-Busting Cases**
by thirdcode: count if SBjoint==1 & NotInFullModel==0

**Predicted Sanctions-Busting Cases**
by thirdcode: count if predSB==1& NotInFullModel==0

 
************** Generating Data for Appendix A **************

sort case
by case: count if NotInFullModel==0
by case: count if SBjoint==1 & NotInFullModel==0
by case: count if predSB==1 & NotInFullModel==0
