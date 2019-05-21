****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 2: The Islamic Schools experiment. Conducted using British Election Study Continuous Monitoring Survey data****
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 2 cmsfinal.dta", which is in the "Better Angels of Our Nature" folder at dataverse****

******Generating dummy variables for the individual treatment conditions

***Control condition

capture drop controldum 
gen controldum = 0
recode controldum (0=1) if q416~=.

****Message only condition

capture drop poloppose
gen poloppose = 0
recode poloppose (0=1) if q417~=.
rename poloppose polopposedum

****Message plus counterargument

capture drop poloppothfav
gen poloppothfav = 0
recode poloppothfav (0=1) if q418~=.

***Conservative endorsed messaeg
capture drop conoppdum
gen conoppdum = 0
recode conoppdum (0=1) if q419~=.

***UKIP endorsed message
capture drop ukipoppdum 
gen ukipoppdum = 0
recode ukipoppdum (0=1) if q420~=.

***BNP endorsed message
capture drop bnpoppdum
gen bnpoppdum = 0
recode bnpoppdum (0=1) if q421~=.

***Conservative endorsed message plus counter-argument
capture drop conoppothfav
gen conoppothfav = 0
recode conoppothfav (0=1) if q422~=.

****Dummy for all conditions with message alone (for comparison with control, without counter-message conditions)
capture drop messeffect
gen messeffect = 0
recode messeffect (0=1) if poloppose ==1
recode messeffect (0=1) if conoppdum ==1
recode messeffect (0=1) if ukipoppdum ==1
recode messeffect (0=1) if bnpoppdum ==1
recode messeffect (0=.) if poloppothfav ==1
recode messeffect (0=.) if conoppothfav ==1

****Dummy for message effect with BNP cases removed 

capture drop messeffectnobnp
gen messeffectnobnp = messeffect
recode messeffectnobnp (else=0) if bnpoppdum==1

****Dummy for legit message with all cases included

gen legitmess = messeffectnobnp
recode legitmess (.=0)

****Summary treatment condition variable
gen treatsum = 0
replace treatsum = 1 if controldum==1
replace treatsum = 2 if poloppose==1
replace treatsum = 3 if conoppdum==1
replace treatsum = 4 if ukipoppdum==1
replace treatsum = 5 if bnpoppdum==1
replace treatsum = 6 if poloppothfav==1
replace treatsum = 7 if conoppothfav==1

label define treatsum 1 "control" 2 "message only" 3 "con message" 4 "UKIP message" 5 "BNP message" 6 "message and counter" 7 "con message + counter" 
label values treatsum treatsum 

****Summary of attitudes to Muslims schools - combination of all the individual treatment conditions. DK'd coded to missing
capture drop musschlsum
gen musschlsum = .
replace musschlsum = q416 if q416~=.
replace musschlsum = q417 if q417~=.
replace musschlsum = q418 if q418~=.
replace musschlsum = q419 if q419~=.
replace musschlsum = q420 if q420~=.
replace musschlsum = q421 if q421~=.
replace musschlsum = q422 if q422~=.

recode musschlsum(6=.)
gen musschlsum01 = (musschlsum-1)/4

****Measures of Motivation to Control Prejudice (MCP) Don't knows set at missing***

gen mcppersimp = q425
recode mcppersimp (1=5) (2=4) (4=2) (5=1) (6=.)  

gen mcppersbel = q426
recode mcppersbel (1=5) (2=4) (4=2) (5=1) (6=.)

gen mcpoththinkn = q427
recode mcpoththink (1=5) (2=4) (4=2) (5=1) (6=.)

gen mcpimmthink = q428
recode mcpimmthink (1=5) (2=4) (4=2) (5=1) (6=.)

****Factor analysis of the items - all load strongly on one factor

factor mcppersimp mcppersbel mcpoththink mcpimmthink, pcf

***Generating MCP scale dk's at midpoint
capture drop mcpscale
egen mcpscale = rmean (mcppersimp mcppersbel mcpoththink mcpimmthink)

hist mcpscale

***Recode as a 0-1 scale
capture drop mcpscale01
gen mcpscale01 = (mcpscale-1)/4

****Measure of hostility to Muslims- discomfort about relative marrying Muslim (social distance measure)

gen marrymus = q423
recode marrymus (.=5)
gen marrymus01 = (marrymus-1)/10

gen idlose = q424
recode idlose (6=3)


****Hypothesis testing

****Hypothesis 1: The motivation hypothesis
****Expectations: MCP should reduce opposition to Muslim schools
***Finding: In a bivariate relationship, this is correct in both OLS and oprobit model

xi: regress musschlsum01 mcpscale01
xi: regress musschlsum01 mcpscale01 if nonwhite==0

****Hypothesis 2: The normative context hypothesis 
****Expectations: Respondents should be more willing to endorse anti-Muslim policy when it is 
***endorsed by mainstream parties should have influence, justification by extreme party should not. 
****Findings : in baseline model with no controls less willing to endorse anti-Muslim policy defended by extremist party

***All conditions, base model
***UKIP, Con and message only significant with full sample; Con only with white sample

xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav
xi: regress musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav if nonwhite==0

xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav
xi: ologit musschlsum01 polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav if nonwhite==0

****Condensing the treatment conditions to "legitimate message (Con, UKIP, "politicians"); "illegitimate message" (BNP), counterargument conditions excluded
****"legitimate message" is significant, "bnp message" is not
xi: regress musschlsum01 messeffectnobnp bnpoppdum 
xi: regress musschlsum01 messeffectnobnp bnpoppdum if nonwhite==0

xi: ologit musschlsum01 messeffectnobnp bnpoppdum
xi: ologit musschlsum01 messeffectnobnp bnpoppdum if nonwhite==0

***HYPOTHESIS 3: THOSE WITH HIGH MCP SHOULD BE MORE SENSITIVE TO MESSAGES

***MCPMedian split variable

gen mcpmedsplit = 0
replace mcpmedsplit = 1 if mcpscale01>=0.6875

****INTERACTION MODELS - reduced effects model (legit message; bnp message; counter message ref: control) 

gen legimesmcp = legitmess*mcpmedsplit
gen bnpmesmcp = bnpoppdum*mcpmedsplit


****Interaction model with focus on party effects 
***There is a very neat symmetry here: The Conservatives s(and to a lesser extent UKIP) how a significant main effect, but no interaction;
***The BNP show an insignificant main effect and a large, significant negative interaction
***This suggests Conservatives (and UKIP) mobilise respondents, regardless of MCP, but BNP strongly repels those with high MCP
***This is in accordance with the hypothesis  - it is those with high MCP who notice, and react to, BNP's negative reputation, but not to the other parties 


nestreg: regress musschlsum01 (polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav) (mcpmedsplit) (bnpmesmcp) (marrymus01) if nonwhite==0
nestreg: ologit musschlsum01 (polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav) (mcpmedsplit) (bnpmesmcp) (marrymus01) if nonwhite==0

nestreg: regress musschlsum01 (polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav) (mcpmedsplit) (bnpmesmcp) (marrymus01)
nestreg: ologit musschlsum01 (polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav) (mcpmedsplit) (bnpmesmcp) (marrymus01)

****Model used for Figure 3

estsimp regress musschlsum01 (polopposedum conoppdum ukipoppdum bnpoppdum poloppothfav conoppothfav) (mcpmedsplit) (bnpmesmcp) (marrymus01) if nonwhite==0

****Simulated values manually copied across***
setx polopposedum 0 conoppdum 1 ukipoppdum 0 bnpoppdum 0 mcpmedsplit 0 bnpmesmcp 0 idlose mean
simqi
setx mcpmedsplit 1
simqi
setx conoppdum 0 bnpoppdum 1 mcpmedsplit 0
simqi
setx mcpmedsplit 1 bnpmesmcp 1

use messinteraction1, clear
label define condition 1 "Control MCP low" 2 "Control MCP high" 3 "Con message MCP low" 4 "Con message MCP high" 5 "BNP message MCP low" 6 "BNP message MCP high"
label values condition condition
eclplot estimate2 min952 max952 condition 
