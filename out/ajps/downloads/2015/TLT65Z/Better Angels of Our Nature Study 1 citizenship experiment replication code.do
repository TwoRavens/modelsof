 *****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 1: The Citizenship Experiment Conducted using the British Comparative Campaign Analysis Project data****
***Final analysis replication do file***
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 1 bccap final.dta", which is in the "Better Angels of Our Nature" folder at dataverse****

****Code for the "motivation to control prejudice" measure (MCP) 

****Reversing the coding on the following item: "according to my personal values, using stereotypes about immigrants is ok"

capture drop w2_oxf_q20re
gen w2_oxf_q20re = 6-w2_oxf_q20
label drop rev
label define rev  1 "strongly disagree" 2 "tend to disagree" 3 "neither agree nor disagree" 4 "tend to agree" 5 "strongly agree"
label values w2_oxf_q20re rev
label variable w2_oxf_q20re "according to my personal values, using stereotypes about immigrants is not ok"

****Generating mcp indicators with missing data coded "."

capture drop mcp1 mcp2 mcp3 mcp4 mcp5 mcp6
recode w2_oxf_q19 (6=.),into(mcp1)
recode w2_oxf_q20re (0=.),into(mcp2)
recode w2_oxf_q21 (6=.),into(mcp3)
recode w2_oxf_q22 (6=.),into(mcp4)
recode w2_oxf_q23 (6=.),into(mcp5)
recode w2_oxf_q24 (6=.),into(mcp6)

****Generating mcp measure which is coded in the right direction (higher scores = greater motivation to control prejudice

egen mcpprelim = rowmean (mcp*)
gen mcp = 5-mcpprelim
drop mcpprelim

gen mcp01 = mcp/4

*****Generating median split measure for testing interactions with experimental conditions

gen mcpmediansplit = mcp
centile mcp if mcp~=.
replace mcpmediansplit = 0 if mcp<2.285714
replace mcpmediansplit = 1 if mcp>2.285714
replace mcpmediansplit = . if mcp==.

****Code to generate the "Affect Misattribution Procedure" measure of prejudice - not used in the main text owing to problems in implementation resulting in high missingness
****But results robust to controlling for it 

***eliminates people who clicked through on one value
replace TurkMaleRate =. if TotalRate==0|TotalRate==1
replace TurkFemaleRate =. if TotalRate==0|TotalRate==1
replace GermanMaleRate =. if TotalRate==0|TotalRate==1
replace GermanFemaleRate =. if TotalRate==0|TotalRate==1

gen AMPdiff = GermanMaleRate-TurkMaleRate

********Recodes to set up the experiment analysis******

*STUDY DESIGN: randomized within groups 1-9 AND within citizenship conditions*
****The groups were as follows: 1 control 2 news story about asylum seekers 3 Pakistani asylum seeker picture 4. As 3 but name added in story
***5. Russian asylum seeker picture 6. As 5, but name added 7. News story, plus data about number of asylum seekers 8. Unrelated story about minorities
***9. Respondents asked to estimate number of asylum seekers
****Note these 9 groups were for a second experiment looking at target group effects. The citizenship experiment is embedded within this, and the randomisation cross-cuts it.
***We control for any effects from the target groups in the analysis - they have no significant effect on our findings

*****************dummy variables for each condition******
gen control=0
replace control=1 if w3_oxf_group==1

gen newsonly = 0
replace newsonly=1 if w3_oxf_group==2

gen pakvis = 0
replace pakvis=1 if w3_oxf_group==3

gen pakvisname = 0
replace pakvisname=1 if w3_oxf_group==4

gen pakasy = pakvis + pakvisname

gen rusvis = 0
replace rusvis=1 if w3_oxf_group==5

gen rusvisname = 0
replace rusvisname=1 if w3_oxf_group==6

gen rusasy = rusvis + rusvisname

gen newscorrect = 0
replace newscorrect = 1 if w3_oxf_group==7

gen supmin = 0
replace supmin=1 if w3_oxf_group==8

gen estasy = 0
replace estasy = 1 if w3_oxf_group==9

*********Dummy variables for the citizenship manipulation***

gen asycitizen = w3_oxf_q12exp
recode asycitizen 1=0 2=1

gen asy_noncitz = w3_oxf_q12exp
recode asy_noncitz 1=1 2=0

***Binary interactions dummy variables - using the median split on the motivation to control prejudice (MCP) measure***
gen mcpXasycit = mcpmediansplit*asycit
gen AMPdiffXmcp = AMPdiff*mcpmediansplit

****generating the grant benefits variables - this is the key measure of whether respondents treat the claimants equally  
gen grant = 6-w3_oxf_q12

****Generating anti-immigrant measures - these were asked on a different wave (wave 2) of the multi-wave study
***2 item scale - not ideal but all that was available

gen immbadeco = w2_q121m
gen redimm = 6-w2_q123m

pwcorr immbadeco redimm
alpha redimm immbadeco, item gen(immscale)
gen immscale01 = (immscale-1)/4

****Code for dummies to exclude ethnic minorities and/or non-British born
****"nonwhite" was constructed for us by the administrators of the B-CCAP
gen bornUK = 1
replace bornUK = 0 if w6_UK==2

***1. Initial test of H2: Citizenship manipulation only. Tested using OLS, ANOVA and ologit. Results robust***
reg grant asycit
anova grant asycit
ologit grant asycit

reg grant asycit if nonwhite==0
anova grant asycit if nonwhite==0
ologit grant asycit if nonwhite==0

reg grant asycit if bornUK==1
anova grant asycit if bornUK==1
ologit grant asycit if bornUK==1


***2. H1 test: Impact of mcp, and H2 test: impact of citizenship
***With controls for different message conditions in first experimental manipulation, plus immigration attitudes
***Consistent evidence of effects***

xi: nestreg: reg grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01)
xi: nestreg: oprobit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01)
xi: nestreg: ologit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01)

xi: nestreg: reg grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0
xi: nestreg: oprobit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0
xi: nestreg: ologit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if nonwhite==0

xi: nestreg: reg grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if bornUK==1
xi: nestreg: oprobit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if bornUK==1
xi: nestreg: ologit grant (asycit mcp01) (newsonly pakasy rusasy newscorrect supmin estasy) (immscale01) if bornUK==1

****Main effects plots code - an adjusted version of this is presented in Figure 1 (adjustments are aesthetic only) 

#delimit cr 
parmest, saving(bccapests1, replace)
use bccapests1,clear
encode parm, gen(variable)
drop if parm=="_cons"
gen variable2 = .
replace variable2=1 if variable==3
replace variable2=2 if variable==1
replace variable2=3 if variable==4
label define variable2 1 "Citizenship" 2 "MCP" 3 "Immigration attitudes"
label values variable2 variable2 
eclplot estimate min95 max95 variable2

***H3 test: 1. interaction between mcp and citizenship condition alone

xi: nestreg: reg grant (asycit mcpmediansplit mcpXasy) (immscale01)
xi: nestreg: ologit grant (asycit mcpmediansplit mcpXasy) (immscale01)

xi: nestreg: reg grant (asycit mcpmediansplit mcpXasy) (immscale01) if bornUK==1
xi: nestreg: ologit grant (asycit mcpmediansplit mcpXasy) (immscale01) if bornUK==1

xi: nestreg: reg grant (asycit mcpmediansplit mcpXasy) (immscale01) if nonwhite==0
xi: nestreg: ologit grant (asycit mcpmediansplit mcpXasy) (immscale01) if nonwhite==0


