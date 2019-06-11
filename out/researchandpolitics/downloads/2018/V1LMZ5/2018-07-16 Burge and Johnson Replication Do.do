/** DATE:		Monday, July 16th**/ 
/** PROJECT:	Replication file for Burge and Johnson - Race, Crime, and Emotions **/

*cleaning the dataset - removing the test cases*
drop if V8< tc(01mar2013 12:00)
sort V8
//sort by time to assign a caseid
gen caseid = _n


//////////////CONTROLS////////////////////
/*Education*/
tab Q12
gen education=.
replace education=1 if Q12==1
replace education=2 if Q12==2
replace education=3 if Q12==3
replace education=4 if Q12==4
replace education=5 if Q12==5
replace education=6 if Q12==6
replace education=7 if Q12==7
tab education
tab Q12
gen edu=(education-1)/6
tab edu

/*Income*/ 
gen income1=income
replace income1=1 if income==1
replace income1=2 if income==2
replace income1=3 if income==3
replace income1=4 if income==4
replace income1=5 if income==5
replace income1=6 if income==6
replace income1=7 if income==7
replace income1=8 if income==8
replace income1=9 if income==9
tab income1
gen inc=(income1-1)/8
tab inc 

/*Gender*/
gen fem=.
replace fem=1 if female==2
replace fem=0 if female==1
tab fem 
tab female

gen male=. 
replace male=1 if female==1
replace male=0 if female==2
tab male

/*Age*/
tab age
destring age, force replace
sum age 
gen age1=(age-18)/65
tab age1
sum age1
gen age2=(age-18)/60

/*Region*/
tab region
tab south
tab west
tab northcent
tab northeast

/*Ideology*/ 
tab ideology
sum ideology
recode ideology (8=4)
gen ideo=(ideology-1)/6
tab ideo

gen ideo2=. 
replace ideo2=7 if ideology==1
replace ideo2=6 if ideology==2
replace ideo2=5 if ideology==3
replace ideo2=4 if ideology==4
replace ideo2=3 if ideology==5
replace ideo2=2 if ideology==6
replace ideo2=1 if ideology==7
tab ideo2

gen liberal=(ideo2-1)/6
tab liberal


/*Party ID*/
gen partyid=.
replace partyid=1 if Q9==1
replace partyid=2 if Q9==2
replace partyid=3 if Q11==1
replace partyid=4 if Q11==3
replace partyid=5 if Q11==2
replace partyid=6 if Q10==2
replace partyid=7 if Q10==1
tab partyid 
gen pid=(partyid-1)/6
tab pid 

gen partyid2=. 
replace partyid2=7 if Q9==1 
replace partyid2=6 if Q9==2
replace partyid2=5 if Q11==1
replace partyid2=4 if Q11==3
replace partyid2=3 if Q11==2
replace partyid2=2 if Q10==2
replace partyid2=1 if Q10==1
tab partyid2 

gen dempid=(partyid2-1)/6
tab dempid

summarize edu inc fem age2 region liberal dempid



//////////////////////////////////////////////////////////////////////// KEY DEPENDENDENT VARIABLES ///////////////////////////////////


///////////////////////EMOTIONS/////////////////////////////

/*Angry*/
tab Q20
sum Q20
gen angry=Q20 
recode angry (1=0)(2=.25)(3=.50)(4=.75)(5=1)
sum angry
tab angry

/*Ashamed*/ 
tab Q43
sum Q43
gen ashamed=Q43
recode ashamed (1=0)(2=.25)(3=.50)(4=.75)(5=1)
tab ashamed
tab Q43

//CRIME OPINION
tab Q28
sum Q28
gen incprison=Q28
recode incprison (1=1)(2=.75)(3=.50)(4=.25)(5=0)
tab incprison 
tab Q28




//////////////CREATING VARIABLE TO INDICATE TREATMENT GROUPS///////////////////
gen tgroup=.
replace tgroup=1 if control==1
replace tgroup=2 if wob==1
replace tgroup=3 if wow==1
replace tgroup=4 if bow==1
replace tgroup=5 if bob==1
tab tgroup 

gen tgroup2=.
replace tgroup2=1 if control==1
replace tgroup2=2 if wob==1
replace tgroup2=3 if wow==1
replace tgroup2=4 if bow==1
replace tgroup2=5 if bob==1
tab tgroup2

lab def tgroup2 1"Control" 2"WoB" 3"WoW" 4"BoW" 5"BoB"
lab val tgroup2 tgroup2
tab tgroup2

 

//////////////////////CHECKING FOR BALANCE IN COVARIATES //////////////////////////////
table tgroup, c(mean fem)
ttest fem if tgroup==1|tgroup==2, by(tgroup)
ttest fem if tgroup==1|tgroup==3, by(tgroup)
ttest fem if tgroup==1|tgroup==4, by(tgroup)
ttest fem if tgroup==1|tgroup==5, by(tgroup)
ttest fem if tgroup==2|tgroup==5, by(tgroup)
ttest fem if tgroup==3|tgroup==4, by(tgroup)
ttest fem if tgroup==2|tgroup==3, by(tgroup)

table tgroup, c(mean age1)
ttest age if tgroup==1|tgroup==2, by(tgroup)
ttest age if tgroup==1|tgroup==3, by(tgroup)
ttest age if tgroup==1|tgroup==4, by(tgroup)
ttest age if tgroup==1|tgroup==5, by(tgroup)
ttest age if tgroup==2|tgroup==5, by(tgroup)
ttest age if tgroup==3|tgroup==4, by(tgroup)
ttest age if tgroup==2|tgroup==3, by(tgroup)

table tgroup, c(mean ideo)
ttest ideo if tgroup==1|tgroup==2, by(tgroup)
ttest ideo if tgroup==1|tgroup==3, by(tgroup)
ttest ideo if tgroup==1|tgroup==4, by(tgroup)
ttest ideo if tgroup==1|tgroup==5, by(tgroup)
ttest ideo if tgroup==2|tgroup==5, by(tgroup)
ttest ideo if tgroup==3|tgroup==4, by(tgroup)
ttest ideo if tgroup==2|tgroup==3, by(tgroup)

hotelling age1 edu fem south liberal dempid inc if tgroup==1|tgroup==2, by(tgroup)
hotelling age1 edu fem south liberal dempid inc if tgroup==2|tgroup==5, by(tgroup)
hotelling age1 edu fem south liberal dempid inc if tgroup==2|tgroup==3, by(tgroup)

//////////////////////////////////////STATISTICAL ANALYSES ///////////////////////////////
//STATISTICAL ANALYSIS I: DESCRIPTIVE STATS//
sum edu inc fem age2 south west northeast northcent liberal dempid
tab1 south west northeast northcent


//STATISTICAL ANALYSIS II: DIFFERENCE IN MEANS //

ttest angry if tgroup2==1|tgroup2==2, by(tgroup2) 
ttest angry if tgroup2==1|tgroup2==3, by(tgroup2) 
ttest angry if tgroup2==1|tgroup2==4, by(tgroup2)
ttest angry if tgroup2==1|tgroup2==5, by(tgroup2) 
ttest angry if tgroup2==2|tgroup2==5, by(tgroup2)
ttest angry if tgroup2==3|tgroup2==4, by(tgroup2)
ttest angry if tgroup2==2|tgroup2==3, by(tgroup2)
ttest angry if tgroup2==2|tgroup2==4, by(tgroup2) 


ttest ashamed if tgroup2==1|tgroup2==2, by(tgroup2) 
ttest ashamed if tgroup2==1|tgroup2==3, by(tgroup2)
ttest ashamed if tgroup2==1|tgroup2==4, by(tgroup2) 
ttest ashamed if tgroup2==1|tgroup2==5, by(tgroup2) 
ttest ashamed if tgroup2==2|tgroup2==5, by(tgroup2) 
ttest ashamed if tgroup2==3|tgroup2==4, by(tgroup2) 
ttest ashamed if tgroup2==2|tgroup2==3, by(tgroup2)
ttest ashamed if tgroup2==2|tgroup2==4, by(tgroup2) 

ttest incprison if tgroup2==1|tgroup2==2, by(tgroup2)
ttest incprison if tgroup2==1|tgroup2==3, by(tgroup2)
ttest incprison if tgroup2==1|tgroup2==4, by(tgroup2) 
ttest incprison if tgroup2==1|tgroup2==5, by(tgroup2)
ttest incprison if tgroup2==2|tgroup2==5, by(tgroup2)
ttest incprison if tgroup2==3|tgroup2==4, by(tgroup2)
ttest incprison if tgroup2==2|tgroup2==3, by(tgroup2) 
ttest incprison if tgroup2==2|tgroup2==4, by(tgroup2)


//// STATISTICAL ANALYSES III: Looking @ MarginsPlots //// 
reg angry i.tgroup2
margins i.tgroup2 
marginsplot, level (84)

reg ashamed i.tgroup2
margins i.tgroup2 
marginsplot, level (84)

reg incprison i.tgroup2
margins i.tgroup2 
marginsplot, level (84)


/// APPENDIX ANALYSES  /////

// Balance in Covariates //
hotelling age1 edu fem south liberal dempid inc if tgroup==1|tgroup==2, by(tgroup)
hotelling age1 edu fem south liberal dempid inc if tgroup==2|tgroup==5, by(tgroup)
hotelling age1 edu fem south liberal dempid inc if tgroup==2|tgroup==3, by(tgroup)

// WoB when compared to the Control 
gen wobcontrol=. 
replace wobcontrol=1 if tgroup==2
replace wobcontrol=0 if tgroup==1
tab wobcontrol

reg angry wobcontrol fem age2 edu inc dempid liberal south northcent west 
reg ashamed wobcontrol fem age2 edu inc dempid liberal south northcent west 
reg incprison wobcontrol fem age2 edu inc dempid liberal south northcent west 

//WoB when compared to BoB..race of the perp that matters/
gen wobbob=. 
replace wobbob=1 if tgroup==2
replace wobbob=0 if tgroup==5
tab wobbob 

reg angry wobbob fem age2 edu inc dempid liberal south northcent west 
reg ashamed wobbob fem age2 edu inc dempid liberal south northcent west 
reg incprison wobbob fem age2 edu inc dempid liberal south northcent west 

reg incprison wobbob##c.angry  // Figure 4 in Manuscript
margins wobbob, at(angry=(0(.2)1))
marginsplot

//WoB when compared to WoW...Race of the victim that matters/ 
gen wobwow=. 
replace wobwow=1 if tgroup==2
replace wobwow=0 if tgroup==3
tab wobwow 

reg angry wobwow fem age2 edu inc dempid liberal south northcent west 
reg ashamed wobwow fem age2 edu inc dempid liberal south northcent west 
reg incprison wobwow fem age2 edu inc dempid liberal south northcent west 

//Linked Fate
tab Q24
sum Q24
gen linkedfate=Q24
recode linkedfate (1=1)(2=.66)(3=.33)(4=0)
tab linkedfate
tab Q24 

pwcorr linkedfate ashamed angry

ttest linkedfate if tgroup2==1|tgroup2==2, by(tgroup2) 
ttest linkedfate if tgroup2==1|tgroup2==3, by(tgroup2)
ttest linkedfate if tgroup2==1|tgroup2==4, by(tgroup2) 
ttest linkedfate if tgroup2==1|tgroup2==5, by(tgroup2) 
ttest linkedfate if tgroup2==2|tgroup2==5, by(tgroup2) 
ttest linkedfate if tgroup2==3|tgroup2==4, by(tgroup2) 
ttest linkedfate if tgroup2==2|tgroup2==3, by(tgroup2)
ttest linkedfate if tgroup2==2|tgroup2==4, by(tgroup2) 

reg linkedfate i.tgroup2
margins i.tgroup2 
marginsplot, level (84)

