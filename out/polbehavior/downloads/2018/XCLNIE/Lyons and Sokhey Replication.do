
**** Two datasets need to be merged with the 2008-2009 ANES.  The 2010 Panel Recontact dataset and the 
**** Skewness Perceptions dataset need to be merged on 'caseid.'  The 2010 Panel Recontact Study
**** is used for analysis in the SI Document models where we control for personality.  The skewness
**** perception dataset contains our measures of skewness, which is also used for models in the SI Document.  
**** Because Stata does not offer a command to calculate row skewness, we do this in excel, and then merge 
**** these values back into the 2008-2009 ANES.  Once this is done, the following code can be run.



******************************************************
**demographics***************
******************************************************
******************************************************

recode der01 (1=1) (2=0), gen(male)
rename der02 age2
rename der04 nonwhite
replace nonwhite=. if nonwhite <1
recode nonwhite (1=0) (2 3 4=1)
rename der05 educ1to5
replace educ1to5=. if educ1to5 <1
rename der06 income
replace income=. if income <1

*different political interest variables -- same wording and response scales (flipped so that more interest is higher, but conducted in di
*> fferent waves
gen interestw1=6-w1k1
gen interestw9=6-w9h1
replace interestw9=. if interestw9>10
gen interestw19=6-w19h1
replace interestw19=. if interestw19>10

******************************************************
******************************************************
*political network variables**************************
******************************************************

*note: the panel didn't ask about frequency of discussion in the ego-centric network
*this "how many days a week do ou discuss politics with family, friends, etc." is probably our best proxy
rename w10h2 disweek

*respondents were asked to name up to 8 initials; these are restricted, so we only know about the first three
*respondents were given a yes/no before naming initials, so people who said "no" can be considered 0s
*the network battery appears in wave 9

*the first items just ask about closeness with each named discussant 

recode w9zd4_1 (1/5=1), gen(valid1)
recode w9zd4_2 (1/5=1), gen(valid2)
recode w9zd4_3 (1/5=1), gen(valid3)

*this creates recode an indicator for whether the person actually got asked the discussion questions 
recode w9zd1 (1=1) (2=1), gen(discvalid)

gen netsize=.
replace netsize=0 if discvalid==1
replace netsize=1 if valid1==1
replace netsize=2 if valid2==1
replace netsize=3 if valid3==1
label var netsize "size of Rs network"

*this creates a measure of network size, that is valid (as not all people got the discussion questions)

*let's create an average disagreement measure for the network 
**note: this is not based on partisanship, but on "how different the opinions are" from the R

*these flip and rename this difference measure for each discussant 

gen w9zd9_1r=w9zd9_1 if w9zd9_1>0
gen w9zd9_2r=w9zd9_2 if w9zd9_2>0
gen w9zd9_3r=w9zd9_3 if w9zd9_3>0

gen disdisc1=6-w9zd9_1r
gen disdisc2=6-w9zd9_2r
gen disdisc3=6-w9zd9_3r

recode disdisc1 (1=0) (2=.25) (3=.5) (4=.75) (5=1)
recode disdisc2 (1=0) (2=.25) (3=.5) (4=.75) (5=1)
recode disdisc3 (1=0) (2=.25) (3=.5) (4=.75) (5=1)

*now, let's create a network average, with 0's included
gen avgdis=. 
replace avgdis=0 if netsize==0
replace avgdis=disdisc1 if netsize==1
replace avgdis=(disdisc1+disdisc2)/2 if netsize==2
replace avgdis=(disdisc1+disdisc2+disdisc3)/3 if netsize==3
label var avgdis "average level of opinion difference in Rs network"

*now, let's create a network average, with 0's dropped
gen avgdisno0=. 
replace avgdisno0=disdisc1 if netsize==1
replace avgdisno0=(disdisc1+disdisc2)/2 if netsize==2
replace avgdisno0=(disdisc1+disdisc2+disdisc3)/3 if netsize==3
label var avgdisno0 "average level of opinion difference in Rs network"

*creating a measure of the standard deviation of disagreement in the network
egen avgdisstdv=rowsd(disdisc1 disdisc2 disdisc3)

*creating a measure of the standard deviation of disagreement in the network with only those who gave 3 discussants
egen avgdisstdvnamed3=rowsd(disdisc1 disdisc2 disdisc3)
replace avgdisstdvnamed3=. if netsize<3

*this isn't exactly political expertise, but let's create a network level measure of formal education 

*let's start by renaming each of these:
rename w9zd23_1 formed1
rename w9zd23_2 formed2
rename w9zd23_3 formed3

replace formed1=. if formed1<0
replace formed2=. if formed2<0
replace formed3=. if formed3<0

gen formedavg=.
replace formedavg=0 if netsize==0
replace formedavg=formed1 if netsize==1
replace formedavg=(formed1+formed2)/2 if netsize==2
replace formedavg=(formed1+formed2+formed3)/3 if netsize==3
label var formedavg "average level of formal education in Rs network"

gen formedavgno0=formedavg
replace formedavgno0=. if netsize==0


**let's create another disagreement measure that's based on matching partisanship 

*first, we need to code agreement/disagreement between R and alters 
gen pidw9=der08w9
recode pidw9 (0/2=1) (3=2) (4/6=3)
*this makes R dems 1, inds 2, and reps 3

gen pidd1=.
replace pidd1=1 if w9zd12_1==1
replace pidd1=1 if w9zd13_1==2
replace pidd1=1 if w9zd16_1==1

replace pidd1=2 if w9zd12_1==3
replace pidd1=2 if w9zd12_1==4
replace pidd1=2 if w9zd13_1==3
replace pidd1=2 if w9zd13_1==4
replace pidd1=2 if w9zd16_1==3

replace pidd1=3 if w9zd12_1==2
replace pidd1=3 if w9zd13_1==1
replace pidd1=3 if w9zd16_1==2



gen pidd2=.
replace pidd2=1 if w9zd12_2==1
replace pidd2=1 if w9zd13_2==2
replace pidd2=1 if w9zd16_2==1

replace pidd2=2 if w9zd12_2==3
replace pidd2=2 if w9zd12_2==4
replace pidd2=2 if w9zd13_2==3
replace pidd2=2 if w9zd13_2==4
replace pidd2=2 if w9zd16_2==3

replace pidd2=3 if w9zd12_2==2
replace pidd2=3 if w9zd13_2==1
replace pidd2=3 if w9zd16_2==2

gen pidd3=.
replace pidd3=1 if w9zd12_3==1
replace pidd3=1 if w9zd13_3==2
replace pidd3=1 if w9zd16_3==1

replace pidd3=2 if w9zd12_3==3
replace pidd3=2 if w9zd12_3==4
replace pidd3=2 if w9zd13_3==3
replace pidd3=2 if w9zd13_3==4
replace pidd3=2 if w9zd16_3==3

replace pidd3=3 if w9zd12_3==2
replace pidd3=3 if w9zd13_3==1
replace pidd3=3 if w9zd16_3==2

*now, we need to match this to create a disagreement measure; note that the default is disagreement 
*and then I work backwards, as what I can't match I count as disagreement 

gen dispidd1=. 
replace dispidd1=1 if valid1==1 
replace dispidd1=0 if valid1==1 & pidw9==1 & pidd1==1
replace dispidd1=0 if valid1==1 & pidw9==2 & pidd1==2
replace dispidd1=0 if valid1==1 & pidw9==3 & pidd1==3

gen dispidd2=. 
replace dispidd2=1 if valid2==1 
replace dispidd2=0 if valid2==1 & pidw9==1 & pidd2==1
replace dispidd2=0 if valid2==1 & pidw9==2 & pidd2==2
replace dispidd2=0 if valid2==1 & pidw9==3 & pidd2==3

gen dispidd3=. 
replace dispidd3=1 if valid3==1 
replace dispidd3=0 if valid3==1 & pidw9==1 & pidd3==1
replace dispidd3=0 if valid3==1 & pidw9==2 & pidd3==2
replace dispidd3=0 if valid3==1 & pidw9==3 & pidd3==3

*now, let's take the network average, with 0's included

gen avgdispid=. 
replace avgdispid=0 if netsize==0
replace avgdispid=dispidd1 if netsize==1
replace avgdispid=(dispidd1+dispidd2)/2 if netsize==2
replace avgdispid=(dispidd1+dispidd2+dispidd3)/3 if netsize==3

*now, let's take the network average, with 0's dropped

gen avgdispidno0=. 
replace avgdispidno0=dispidd1 if netsize==1
replace avgdispidno0=(dispidd1+dispidd2)/2 if netsize==2
replace avgdispidno0=(dispidd1+dispidd2+dispidd3)/3 if netsize==3

*******Additional Variables.  All from Wave 9*****************

*Interest in information about government and politics recoded low to high
gen interest=w9h1
replace interest =. if interest <1
recode interest (5=0) (4=6) (3=7) (2=8) (1=9)
recode interest (6=1) (7=2) (8=3) (9=4)


*Strength of Partisanship, 0=independents, 3=strong partisans
gen spid=der08w9
replace spid=. if spid <0
recode spid (6 0=10) (5 1=9) (4 2=8) (3=7)
recode spid (7=0) (8=1) (9=2) (10=3)

*Education 1=No Schooling, 14=Professional or doctoral degree
gen ed=w9zw5
replace ed=. if  ed <1


************************************************************************************
************Coding the Polarization Perception Measures*****************************
************************************************************************************

******Actual Responses to the Questions

*Government Paid Medical Care (1=Strongly Favor, 5=Strongly Oppose)
gen govmedical=w13z6
replace govmedical=. if govmedical==-6

*Iraq Troop Withdraw (1=Strongly Favor, 5=Strongly Oppose)
gen iraqtroop=w13z10
replace iraqtroop=. if iraqtroop==-6

*Court Order for wiretapping of suspected terrorists (1=Strongly Favor, 5=Strongly Oppose)
gen wiretapping=w13z14
replace wiretapping=. if wiretapping==-6

*Allowing Illegal Immigrants to Work in the Country for 3 years and then having to go home (1=Strongly Favor, 5=Strongly Oppose)
gen immigration=w13z18
replace immigration=. if immigration==-6

sum govmedical iraqtroop wiretapping immigration
sum govmedical iraqtroop wiretapping immigration if pidw9==1
sum govmedical iraqtroop wiretapping immigration if pidw9==3

****************************************
******Perceptions of Distributions *****
****************************************

*Transforming Government Paid Medical Care for Democrats

gen govmedical_dem1=w13z8_bar1
gen govmedical_dem2=w13z8_bar2
gen govmedical_dem3=w13z8_bar3
gen govmedical_dem4=w13z8_bar4
gen govmedical_dem5=w13z8_bar5

replace govmedical_dem1=. if govmedical_dem1==-6
replace govmedical_dem2=. if govmedical_dem2==-6
replace govmedical_dem3=. if govmedical_dem3==-6
replace govmedical_dem4=. if govmedical_dem4==-6
replace govmedical_dem5=. if govmedical_dem5==-6

egen govmedsd_dem=rowsd(govmedical_dem1 govmedical_dem2 govmedical_dem3 govmedical_dem4 govmedical_dem5)
egen govmedmean_dem=rowmean(govmedical_dem1 govmedical_dem2 govmedical_dem3 govmedical_dem4 govmedical_dem5)
egen govmedtotal_dem=rowtotal(govmedical_dem1 govmedical_dem2 govmedical_dem3 govmedical_dem4 govmedical_dem5)

*Transforming Government Paid Medical Care for Republicans

gen govmedical_rep1=w13z9_bar1
gen govmedical_rep2=w13z9_bar2
gen govmedical_rep3=w13z9_bar3
gen govmedical_rep4=w13z9_bar4
gen govmedical_rep5=w13z9_bar5

replace govmedical_rep1=. if govmedical_rep1==-6
replace govmedical_rep2=. if govmedical_rep2==-6
replace govmedical_rep3=. if govmedical_rep3==-6
replace govmedical_rep4=. if govmedical_rep4==-6
replace govmedical_rep5=. if govmedical_rep5==-6

egen govmedsd_rep=rowsd(govmedical_rep1 govmedical_rep2 govmedical_rep3 govmedical_rep4 govmedical_rep5)
egen govmedmean_rep=rowmean(govmedical_rep1 govmedical_rep2 govmedical_rep3 govmedical_rep4 govmedical_rep5)
egen govmedtotal_rep=rowtotal(govmedical_rep1 govmedical_rep2 govmedical_rep3 govmedical_rep4 govmedical_rep5)

*Transforming Iraq Troop Withdrawl for Democrats

gen iraqtroop_dem1=w13z12_bar1
gen iraqtroop_dem2=w13z12_bar2
gen iraqtroop_dem3=w13z12_bar3
gen iraqtroop_dem4=w13z12_bar4
gen iraqtroop_dem5=w13z12_bar5

replace iraqtroop_dem1=. if iraqtroop_dem1==-6
replace iraqtroop_dem2=. if iraqtroop_dem2==-6
replace iraqtroop_dem3=. if iraqtroop_dem3==-6
replace iraqtroop_dem4=. if iraqtroop_dem4==-6
replace iraqtroop_dem5=. if iraqtroop_dem5==-6

egen iraqtroopsd_dem=rowsd(iraqtroop_dem1 iraqtroop_dem2 iraqtroop_dem3 iraqtroop_dem4 iraqtroop_dem5)
egen iraqtroopmean_dem=rowmean(iraqtroop_dem1 iraqtroop_dem2 iraqtroop_dem3 iraqtroop_dem4 iraqtroop_dem5)
egen iraqtrooptotal_dem=rowtotal(iraqtroop_dem1 iraqtroop_dem2 iraqtroop_dem3 iraqtroop_dem4 iraqtroop_dem5)


*Transforming Iraq Troop Withdrawl for Republicans

gen iraqtroop_rep1=w13z13_bar1
gen iraqtroop_rep2=w13z13_bar2
gen iraqtroop_rep3=w13z13_bar3
gen iraqtroop_rep4=w13z13_bar4
gen iraqtroop_rep5=w13z13_bar5

replace iraqtroop_rep1=. if iraqtroop_rep1==-6
replace iraqtroop_rep2=. if iraqtroop_rep2==-6
replace iraqtroop_rep3=. if iraqtroop_rep3==-6
replace iraqtroop_rep4=. if iraqtroop_rep4==-6
replace iraqtroop_rep5=. if iraqtroop_rep5==-6

egen iraqtroopsd_rep=rowsd(iraqtroop_rep1 iraqtroop_rep2 iraqtroop_rep3 iraqtroop_rep4 iraqtroop_rep5)
egen iraqtroopmean_rep=rowmean(iraqtroop_rep1 iraqtroop_rep2 iraqtroop_rep3 iraqtroop_rep4 iraqtroop_rep5)
egen iraqtrooptotal_rep=rowtotal(iraqtroop_rep1 iraqtroop_rep2 iraqtroop_rep3 iraqtroop_rep4 iraqtroop_rep5)


*Transforming Wiretapping for Democrats

gen wiretapping_dem1=w13z16_bar1
gen wiretapping_dem2=w13z16_bar2
gen wiretapping_dem3=w13z16_bar3
gen wiretapping_dem4=w13z16_bar4
gen wiretapping_dem5=w13z16_bar5

replace wiretapping_dem1=. if wiretapping_dem1==-6
replace wiretapping_dem2=. if wiretapping_dem2==-6
replace wiretapping_dem3=. if wiretapping_dem3==-6
replace wiretapping_dem4=. if wiretapping_dem4==-6
replace wiretapping_dem5=. if wiretapping_dem5==-6

egen wiretappingsd_dem=rowsd(wiretapping_dem1 wiretapping_dem2 wiretapping_dem3 wiretapping_dem4 wiretapping_dem5)
egen wiretappingmean_dem=rowmean(wiretapping_dem1 wiretapping_dem2 wiretapping_dem3 wiretapping_dem4 wiretapping_dem5)
egen wiretappingtotal_dem=rowtotal(wiretapping_dem1 wiretapping_dem2 wiretapping_dem3 wiretapping_dem4 wiretapping_dem5)


*Transforming Wiretapping for Republicans

gen wiretapping_rep1=w13z17_bar1
gen wiretapping_rep2=w13z17_bar2
gen wiretapping_rep3=w13z17_bar3
gen wiretapping_rep4=w13z17_bar4
gen wiretapping_rep5=w13z17_bar5

replace wiretapping_rep1=. if wiretapping_rep1==-6
replace wiretapping_rep2=. if wiretapping_rep2==-6
replace wiretapping_rep3=. if wiretapping_rep3==-6
replace wiretapping_rep4=. if wiretapping_rep4==-6
replace wiretapping_rep5=. if wiretapping_rep5==-6

egen wiretappingsd_rep=rowsd(wiretapping_rep1 wiretapping_rep2 wiretapping_rep3 wiretapping_rep4 wiretapping_rep5)
egen wiretappingmean_rep=rowmean(wiretapping_rep1 wiretapping_rep2 wiretapping_rep3 wiretapping_rep4 wiretapping_rep5)
egen wiretappingtotal_rep=rowtotal(wiretapping_rep1 wiretapping_rep2 wiretapping_rep3 wiretapping_rep4 wiretapping_rep5)


*Transforming Illegal Immigration for Democrats

gen illegalimm_dem1=w13z20_bar1
gen illegalimm_dem2=w13z20_bar2
gen illegalimm_dem3=w13z20_bar3
gen illegalimm_dem4=w13z20_bar4
gen illegalimm_dem5=w13z20_bar5

replace illegalimm_dem1=. if illegalimm_dem1==-6
replace illegalimm_dem2=. if illegalimm_dem2==-6
replace illegalimm_dem3=. if illegalimm_dem3==-6
replace illegalimm_dem4=. if illegalimm_dem4==-6
replace illegalimm_dem5=. if illegalimm_dem5==-6

egen illegalimmsd_dem=rowsd(illegalimm_dem1 illegalimm_dem2 illegalimm_dem3 illegalimm_dem4 illegalimm_dem5)
egen illegalimmmean_dem=rowmean(illegalimm_dem1 illegalimm_dem2 illegalimm_dem3 illegalimm_dem4 illegalimm_dem5)
egen illegalimmtotal_dem=rowtotal(illegalimm_dem1 illegalimm_dem2 illegalimm_dem3 illegalimm_dem4 illegalimm_dem5)



*Transforming Illegal Immigration for Republicans

gen illegalimm_rep1=w13z21_bar1
gen illegalimm_rep2=w13z21_bar2
gen illegalimm_rep3=w13z21_bar3
gen illegalimm_rep4=w13z21_bar4
gen illegalimm_rep5=w13z21_bar5

replace illegalimm_rep1=. if illegalimm_rep1==-6
replace illegalimm_rep2=. if illegalimm_rep2==-6
replace illegalimm_rep3=. if illegalimm_rep3==-6
replace illegalimm_rep4=. if illegalimm_rep4==-6
replace illegalimm_rep5=. if illegalimm_rep5==-6

egen illegalimmsd_rep=rowsd(illegalimm_rep1 illegalimm_rep2 illegalimm_rep3 illegalimm_rep4 illegalimm_rep5)
egen illegalimmmean_rep=rowmean(illegalimm_rep1 illegalimm_rep2 illegalimm_rep3 illegalimm_rep4 illegalimm_rep5)
egen illegalimmtotal_rep=rowtotal(illegalimm_rep1 illegalimm_rep2 illegalimm_rep3 illegalimm_rep4 illegalimm_rep5)


***Now generating in and out party perceptions for means

*Government Healthcare
gen inpartygovmedmean=.
replace inpartygovmedmean=govmedmean_dem if pidw9==1
replace inpartygovmedmean=govmedmean_rep if pidw9==3

gen outpartygovmedmean=.
replace outpartygovmedmean=govmedmean_dem if pidw9==3
replace outpartygovmedmean=govmedmean_rep if pidw9==1

gen govmedmeandiff=abs(inpartygovmedmean-outpartygovmedmean)

*Iraq Troop Withdrawl

gen inpartyiraqtroopmean=.
replace inpartyiraqtroopmean=iraqtroopmean_dem if pidw9==1
replace inpartyiraqtroopmean=iraqtroopmean_rep if pidw9==3

gen outpartyiraqtroopmean=.
replace outpartyiraqtroopmean=iraqtroopmean_dem if pidw9==3
replace outpartyiraqtroopmean=iraqtroopmean_rep if pidw9==1

gen iraqtroopmeandiff=abs(inpartyiraqtroopmean-outpartyiraqtroopmean)

*Wiretapping

gen inpartywiretappingmean=.
replace inpartywiretappingmean=wiretappingmean_dem if pidw9==1
replace inpartywiretappingmean=wiretappingmean_rep if pidw9==3

gen outpartywiretappingmean=.
replace outpartywiretappingmean=wiretappingmean_dem if pidw9==3
replace outpartywiretappingmean=wiretappingmean_rep if pidw9==1

gen wiretappingmeandiff=abs(inpartywiretappingmean-outpartywiretappingmean)

*Illegal Immigration

gen inpartyillegalimmmean=.
replace inpartyillegalimmmean=illegalimmmean_dem if pidw9==1
replace inpartyillegalimmmean=illegalimmmean_rep if pidw9==3

gen outpartyillegalimmmean=.
replace outpartyillegalimmmean=illegalimmmean_dem if pidw9==3
replace outpartyillegalimmmean=illegalimmmean_rep if pidw9==1

gen illegalimmmeandiff=abs(inpartyillegalimmmean-outpartyillegalimmmean)


**Coding skewness measures.  These come from the Perception Skewness.dta file that has been merged.

gen inpartygovmedskew=.
replace inpartygovmedskew=govmedskew_dem if pidw9==1
replace inpartygovmedskew=govmedskew_rep if pidw9==3

gen outpartygovmedskew=.
replace outpartygovmedskew=govmedskew_dem if pidw9==3
replace outpartygovmedskew=govmedskew_rep if pidw9==1

gen inpartyiraqtroopskew=.
replace inpartyiraqtroopskew=iraqtroopskew_dem if pidw9==1
replace inpartyiraqtroopskew=iraqtroopskew_rep if pidw9==3

gen outpartyiraqtroopskew=.
replace outpartyiraqtroopskew=iraqtroopskew_dem if pidw9==3
replace outpartyiraqtroopskew=iraqtroopskew_rep if pidw9==1

gen inpartywiretappingskew=.
replace inpartywiretappingskew=wiretappingskew_dem if pidw9==1
replace inpartywiretappingskew=wiretappingskew_rep if pidw9==3

gen outpartywiretappingskew=.
replace outpartywiretappingskew=wiretappingskew_dem if pidw9==3
replace outpartywiretappingskew=wiretappingskew_rep if pidw9==1

gen inpartyillegalimmskew=.
replace inpartyillegalimmskew=illegalimmskew_dem if pidw9==1
replace inpartyillegalimmskew=illegalimmskew_rep if pidw9==3

gen outpartyillegalimmskew=.
replace outpartyillegalimmskew=illegalimmskew_dem if pidw9==3
replace outpartyillegalimmskew=illegalimmskew_rep if pidw9==1

************************************************************************
****Calculating Distance Between Means DV*******************************
************************************************************************

**Calculating perceived means

gen govmedicalmean_all=((1*(govmedical_all1/govmedtotal_all))+(2*(govmedical_all2/govmedtotal_all))+(3*(govmedical_all3/govmedtotal_all))+(4*(govmedical_all4/govmedtotal_all))+(5*(govmedical_all5/govmedtotal_all)))
gen iraqmean_all=((1*(iraqtroop_all1/iraqtrooptotal_all))+(2*(iraqtroop_all2/iraqtrooptotal_all))+(3*(iraqtroop_all3/iraqtrooptotal_all))+(4*(iraqtroop_all4/iraqtrooptotal_all))+(5*(iraqtroop_all5/iraqtrooptotal_all)))
gen wiretapmean_all=((1*(wiretapping_all1/wiretappingtotal_all))+(2*(wiretapping_all2/wiretappingtotal_all))+(3*(wiretapping_all3/wiretappingtotal_all))+(4*(wiretapping_all4/wiretappingtotal_all))+(5*(wiretapping_all5/wiretappingtotal_all)))
gen illegalimmigrationmean_all=((1*(illegalimm_all1/illegalimmtotal_all))+(2*(illegalimm_all2/illegalimmtotal_all))+(3*(illegalimm_all3/illegalimmtotal_all))+(4*(illegalimm_all4/illegalimmtotal_all))+(5*(illegalimm_all5/illegalimmtotal_all)))

gen govmedicalmean_rep=((1*(govmedical_rep1/govmedtotal_rep))+(2*(govmedical_rep2/govmedtotal_rep))+(3*(govmedical_rep3/govmedtotal_rep))+(4*(govmedical_rep4/govmedtotal_rep))+(5*(govmedical_rep5/govmedtotal_rep)))
gen iraqmean_rep=((1*(iraqtroop_rep1/iraqtrooptotal_rep))+(2*(iraqtroop_rep2/iraqtrooptotal_rep))+(3*(iraqtroop_rep3/iraqtrooptotal_rep))+(4*(iraqtroop_rep4/iraqtrooptotal_rep))+(5*(iraqtroop_rep5/iraqtrooptotal_rep)))
gen wiretapmean_rep=((1*(wiretapping_rep1/wiretappingtotal_rep))+(2*(wiretapping_rep2/wiretappingtotal_rep))+(3*(wiretapping_rep3/wiretappingtotal_rep))+(4*(wiretapping_rep4/wiretappingtotal_rep))+(5*(wiretapping_rep5/wiretappingtotal_rep)))
gen illegalimmigrationmean_rep=((1*(illegalimm_rep1/illegalimmtotal_rep))+(2*(illegalimm_rep2/illegalimmtotal_rep))+(3*(illegalimm_rep3/illegalimmtotal_rep))+(4*(illegalimm_rep4/illegalimmtotal_rep))+(5*(illegalimm_rep5/illegalimmtotal_rep)))

gen governmentmedicalmean_dem=((1*(govmedical_dem1/govmedtotal_dem))+(2*(govmedical_dem2/govmedtotal_dem))+(3*(govmedical_dem3/govmedtotal_dem))+(4*(govmedical_dem4/govmedtotal_dem))+(5*(govmedical_dem5/govmedtotal_dem)))
gen iraqmean_dem=((1*(iraqtroop_dem1/iraqtrooptotal_dem))+(2*(iraqtroop_dem2/iraqtrooptotal_dem))+(3*(iraqtroop_dem3/iraqtrooptotal_dem))+(4*(iraqtroop_dem4/iraqtrooptotal_dem))+(5*(iraqtroop_dem5/iraqtrooptotal_dem)))
gen wiretapmean_dem=((1*(wiretapping_dem1/wiretappingtotal_dem))+(2*(wiretapping_dem2/wiretappingtotal_dem))+(3*(wiretapping_dem3/wiretappingtotal_dem))+(4*(wiretapping_dem4/wiretappingtotal_dem))+(5*(wiretapping_dem5/wiretappingtotal_dem)))
gen illegalimmigrationmean_dem=((1*(illegalimm_dem1/illegalimmtotal_dem))+(2*(illegalimm_dem2/illegalimmtotal_dem))+(3*(illegalimm_dem3/illegalimmtotal_dem))+(4*(illegalimm_dem4/illegalimmtotal_dem))+(5*(illegalimm_dem5/illegalimmtotal_dem)))

**Calculating the amount of distance between these means

gen govmedmeandistance=abs(govmedicalmean_rep-governmentmedicalmean_dem)
gen iraqmeandistance=abs(iraqmean_rep-iraqmean_dem)
gen wiretappingmeandistance=abs(wiretapmean_rep-wiretapmean_dem)
gen illegalimmmeandistance=abs(illegalimmigrationmean_rep-illegalimmigrationmean_dem)


*************************************************************************
****Calculating Standard Deviation Measure*******************************
*************************************************************************

*create versions of the 8 items

gen govmedicalsd_dem_correct=sqrt((((1-governmentmedicalmean_dem)^2)*(govmedical_dem1/govmedtotal_dem))+(((2-governmentmedicalmean_dem)^2)*(govmedical_dem2/govmedtotal_dem))+(((3-governmentmedicalmean_dem)^2)*(govmedical_dem3/govmedtotal_dem))+(((4-governmentmedicalmean_dem)^2)*(govmedical_dem4/govmedtotal_dem))+(((5-governmentmedicalmean_dem)^2)*(govmedical_dem5/govmedtotal_dem)))
gen iraqtroopsd__dem_correct=sqrt((((1-iraqmean_dem)^2)*(iraqtroop_dem1/iraqtrooptotal_dem))+(((2-iraqmean_dem)^2)*(iraqtroop_dem2/iraqtrooptotal_dem))+(((3-iraqmean_dem)^2)*(iraqtroop_dem3/iraqtrooptotal_dem))+(((4-iraqmean_dem)^2)*(iraqtroop_dem4/iraqtrooptotal_dem))+(((5-iraqmean_dem)^2)*(iraqtroop_dem5/iraqtrooptotal_dem)))
gen wiretappingsd_dem_correct=sqrt((((1-wiretapmean_dem)^2)*(wiretapping_dem1/wiretappingtotal_dem))+(((2-wiretapmean_dem)^2)*(wiretapping_dem2/wiretappingtotal_dem))+(((3-wiretapmean_dem)^2)*(wiretapping_dem3/wiretappingtotal_dem))+(((4-wiretapmean_dem)^2)*(wiretapping_dem4/wiretappingtotal_dem))+(((5-wiretapmean_dem)^2)*(wiretapping_dem5/wiretappingtotal_dem)))
gen illegalimmsd_dem_correct=sqrt((((1-illegalimmigrationmean_dem)^2)*(illegalimm_dem1/illegalimmtotal_dem))+(((2-illegalimmigrationmean_dem)^2)*(illegalimm_dem2/illegalimmtotal_dem))+(((3-illegalimmigrationmean_dem)^2)*(illegalimm_dem3/illegalimmtotal_dem))+(((4-illegalimmigrationmean_dem)^2)*(illegalimm_dem4/illegalimmtotal_dem))+(((5-illegalimmigrationmean_dem)^2)*(illegalimm_dem5/illegalimmtotal_dem)))

gen govmedicalsd_rep_correct=sqrt((((1-govmedicalmean_rep)^2)*(govmedical_rep1/govmedtotal_rep))+(((2-govmedicalmean_rep)^2)*(govmedical_rep2/govmedtotal_rep))+(((3-govmedicalmean_rep)^2)*(govmedical_rep3/govmedtotal_rep))+(((4-govmedicalmean_rep)^2)*(govmedical_rep4/govmedtotal_rep))+(((5-govmedicalmean_rep)^2)*(govmedical_rep5/govmedtotal_rep)))
gen iraqtroopsd__rep_correct=sqrt((((1-iraqmean_rep)^2)*(iraqtroop_rep1/iraqtrooptotal_rep))+(((2-iraqmean_rep)^2)*(iraqtroop_rep2/iraqtrooptotal_rep))+(((3-iraqmean_rep)^2)*(iraqtroop_rep3/iraqtrooptotal_rep))+(((4-iraqmean_rep)^2)*(iraqtroop_rep4/iraqtrooptotal_rep))+(((5-iraqmean_rep)^2)*(iraqtroop_rep5/iraqtrooptotal_rep)))
gen wiretappingsd_rep_correct=sqrt((((1-wiretapmean_rep)^2)*(wiretapping_rep1/wiretappingtotal_rep))+(((2-wiretapmean_rep)^2)*(wiretapping_rep2/wiretappingtotal_rep))+(((3-wiretapmean_rep)^2)*(wiretapping_rep3/wiretappingtotal_rep))+(((4-wiretapmean_rep)^2)*(wiretapping_rep4/wiretappingtotal_rep))+(((5-wiretapmean_rep)^2)*(wiretapping_rep5/wiretappingtotal_rep)))
gen illegalimmsd_rep_correct=sqrt((((1-illegalimmigrationmean_rep)^2)*(illegalimm_rep1/illegalimmtotal_rep))+(((2-illegalimmigrationmean_rep)^2)*(illegalimm_rep2/illegalimmtotal_rep))+(((3-illegalimmigrationmean_rep)^2)*(illegalimm_rep3/illegalimmtotal_rep))+(((4-illegalimmigrationmean_rep)^2)*(illegalimm_rep4/illegalimmtotal_rep))+(((5-illegalimmigrationmean_rep)^2)*(illegalimm_rep5/illegalimmtotal_rep)))

gen govmedicalsd_inparty_correct=.
replace govmedicalsd_inparty_correct=govmedicalsd_dem_correct if pidw9==1
replace govmedicalsd_inparty_correct=govmedicalsd_rep_correct if pidw9==3

gen govmedicalsd_outparty_correct=.
replace govmedicalsd_outparty_correct=govmedicalsd_dem_correct if pidw9==3
replace govmedicalsd_outparty_correct=govmedicalsd_rep_correct if pidw9==1

gen iraqtroopsd_inparty_correct=.
replace iraqtroopsd_inparty_correct=iraqtroopsd__dem_correct if pidw9==1
replace iraqtroopsd_inparty_correct=iraqtroopsd__rep_correct if pidw9==3

gen iraqtroopsd_outparty_correct=.
replace iraqtroopsd_outparty_correct=iraqtroopsd__dem_correct if pidw9==3
replace iraqtroopsd_outparty_correct=iraqtroopsd__rep_correct if pidw9==1

gen wiretappingsd_inparty_correct=.
replace wiretappingsd_inparty_correct=wiretappingsd_dem_correct if pidw9==1
replace wiretappingsd_inparty_correct=wiretappingsd_rep_correct if pidw9==3

gen wiretappingsd_outparty_correct=.
replace wiretappingsd_outparty_correct=wiretappingsd_dem_correct if pidw9==3
replace wiretappingsd_outparty_correct=wiretappingsd_rep_correct if pidw9==1

gen illegalimmsd_inparty_correct=.
replace illegalimmsd_inparty_correct=illegalimmsd_dem_correct if pidw9==1
replace illegalimmsd_inparty_correct=illegalimmsd_rep_correct if pidw9==3

gen illegalimmsd_outparty_correct=.
replace illegalimmsd_outparty_correct=illegalimmsd_dem_correct if pidw9==3
replace illegalimmsd_outparty_correct=illegalimmsd_rep_correct if pidw9==1

*generating measure of people who said mean distance was 0, and there was no skewness (so probably no real distribution built)

gen govmednoskew=0
replace govmednoskew=1 if inpartygovmedskew==. & outpartygovmedskew==. & govmedmeandistance==0
tab govmednoskew

gen iraqnoskew=0
replace iraqnoskew=1 if inpartyiraqtroopskew==. & outpartyiraqtroopskew==. & iraqmeandistance==0
tab iraqnoskew

gen wiretappingnoskew=0
replace wiretappingnoskew=1 if inpartywiretappingskew==. & outpartywiretappingskew==. & wiretappingmeandistance==0
tab wiretappingnoskew

gen illegalimmnoskew=0
replace illegalimmnoskew=1 if inpartyillegalimmskew==. & outpartyillegalimmskew==. & illegalimmmeandistance==0
tab illegalimmnoskew
   
*Coding other perceptions for SI models

gen w17mccainlike=w17e15
replace w17mccainlike=. if w17mccainlike<1
recode w17mccainlike (2=4)(1=5)
recode w17mccainlike (3=0)(4=1)(5=2)

gen w17obamalike=w17e39
replace w17obamalike=. if w17obamalike<1
recode w17obamalike (2=4)(1=5)
recode w17obamalike (3=0)(4=1)(5=2)

gen w17mccaindislike=w17e16
replace w17mccaindislike=. if w17mccaindislike<1
recode w17mccaindislike (2=4)(1=5)
recode w17mccaindislike (3=0)(4=1)(5=2)

gen w17obamadislike=w17e40
replace w17obamadislike=. if w17obamadislike<1
recode w17obamadislike (2=4)(1=5)
recode w17obamadislike (3=0)(4=1)(5=2)

gen w19like_dislike_dem=w19e2
replace w19like_dislike_dem=. if w19like_dislike_dem<1
recode w19like_dislike_dem (2=0)(1=2)(3=1)

gen w19like_dislike_rep=w19e5
replace w19like_dislike_rep=. if w19like_dislike_rep<1
recode w19like_dislike_rep (2=0)(1=2)(3=1)

*Generating measures of overlap for alternative testing in SI Tables 13 

gen govmeddemrepabs1=abs(govmedical_rep1-govmedical_dem1)
gen govmeddemrepabs2=abs(govmedical_rep2-govmedical_dem2)
gen govmeddemrepabs3=abs(govmedical_rep3-govmedical_dem3)
gen govmeddemrepabs4=abs(govmedical_rep4-govmedical_dem4)
gen govmeddemrepabs5=abs(govmedical_rep5-govmedical_dem5)
gen govmedoverall=govmedtotal_rep+govmedtotal_dem
gen govmedicaloverlap=(govmeddemrepabs1+govmeddemrepabs2+govmeddemrepabs3+govmeddemrepabs4+govmeddemrepabs1)/govmedoverall
replace govmedicaloverlap=. if govmedicaloverlap>1

gen iraqdemrepabs1=abs(iraqtroop_rep1-iraqtroop_dem1)
gen iraqdemrepabs2=abs(iraqtroop_rep2-iraqtroop_dem2)
gen iraqdemrepabs3=abs(iraqtroop_rep3-iraqtroop_dem3)
gen iraqdemrepabs4=abs(iraqtroop_rep4-iraqtroop_dem4)
gen iraqdemrepabs5=abs(iraqtroop_rep5-iraqtroop_dem5)
gen iraqtroopoverall=iraqtrooptotal_rep+iraqtrooptotal_dem
gen iraqtroopoverlap=(iraqdemrepabs1+iraqdemrepabs2+iraqdemrepabs3+iraqdemrepabs4+iraqdemrepabs5)/iraqtroopoverall

gen wiretapdemrepabs1=abs(wiretapping_rep1-wiretapping_dem1)
gen wiretapdemrepabs2=abs(wiretapping_rep2-wiretapping_dem2)
gen wiretapdemrepabs3=abs(wiretapping_rep3-wiretapping_dem3)
gen wiretapdemrepabs4=abs(wiretapping_rep4-wiretapping_dem4)
gen wiretapdemrepabs5=abs(wiretapping_rep5-wiretapping_dem5)
gen wiretappingoverall=wiretappingtotal_rep+wiretappingtotal_dem
gen wiretappingoverlap=(wiretapdemrepabs1+wiretapdemrepabs2+wiretapdemrepabs3+wiretapdemrepabs4+wiretapdemrepabs5)/wiretappingoverall

gen illegalimmdemrepabs1=abs(illegalimm_rep1-illegalimm_dem1)
gen illegalimmdemrepabs2=abs(illegalimm_rep2-illegalimm_dem2)
gen illegalimmdemrepabs3=abs(illegalimm_rep3-illegalimm_dem3)
gen illegalimmdemrepabs4=abs(illegalimm_rep4-illegalimm_dem4)
gen illegalimmdemrepabs5=abs(illegalimm_rep5-illegalimm_dem5)
gen illegalimmoverall=illegalimmtotal_rep+illegalimmtotal_dem
gen illegalimmoverlap=(illegalimmdemrepabs1+illegalimmdemrepabs2+illegalimmdemrepabs3+illegalimmdemrepabs4+illegalimmdemrepabs5)/illegalimmoverall

*Coding Index DVs for SI Table 14

gen meandiffindex=(govmedmeandistance+iraqmeandistance+wiretappingmeandistance+illegalimmmeandistance)/4
gen inpartystddevindex=(govmedicalsd_inparty_correct+iraqtroopsd_inparty_correct+wiretappingsd_inparty_correct+illegalimmsd_inparty_correct)/4
gen outpartystddevindex=(govmedicalsd_outparty_correct+iraqtroopsd_outparty_correct+wiretappingsd_outparty_correct+illegalimmsd_outparty_correct)/4

*Coding of personality items that are taken from the 2010 Panel Recontact Study

*Extraversion
gen extra=f1j2
replace extra=. if extra <1
recode extra (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode extra (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen reserved=f1j7
replace reserved=. if reserved <1
recode reserved (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen extraverted=extra+reserved

*Conscientiousness
gen consc=f1j4
replace consc=. if consc <1
recode consc (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode consc (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen disorg=f1j9
replace disorg=. if disorg <1
recode disorg (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen conscientiousness=consc+disorg

*Agreeableness
gen agree=f1j8
replace agree=. if agree <1
recode agree (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode agree (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen critical=f1j3
replace critical=. if critical <1
recode critical (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen agreeableness=agree+critical

*Emotional Stability
gen stable=f1j10
replace stable=. if stable <1
recode stable (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode stable (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen upset=f1j5
replace upset=. if upset <1
recode upset (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen emostable=stable+upset

*Openness to experience
gen open=f1j6
replace open=. if open <1
recode open (7=8) (6=9) (5=10) (4=11) (3=12) (2=13) (1=14)
recode open (8=0) (9=1) (10=2) (11=3) (12=4) (13=5) (14=6)

gen conv=f1j11
replace conv=. if conv <1
recode conv (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6)

gen openness=open+conv


**************************************************************************
**************************************************************************
*************MODELS*******************************************************
**************************************************************************
**************************************************************************


*****************************
***Main Document*************
*****************************

*Table 1

sum govmedmeandistance
sum iraqmeandistance
sum wiretappingmeandistance
sum illegalimmmeandistance
sum govmedicalsd_inparty_correct
sum govmedicalsd_outparty_correct
sum iraqtroopsd_inparty_correct
sum iraqtroopsd_outparty_correct
sum wiretappingsd_inparty_correct
sum wiretappingsd_outparty_correct
sum illegalimmsd_inparty_correct
sum illegalimmsd_outparty_correct

*Table 2

reg govmedmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*Table 3

reg govmedicalsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg govmedicalsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*******************************
***SI Document*****************
*******************************

*SI Table 1
reg govmedmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg iraqmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg wiretappingmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg illegalimmmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]

*SI Table 2
reg govmedicalsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg govmedicalsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg iraqtroopsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg iraqtroopsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg wiretappingsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg wiretappingsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg illegalimmsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]
reg illegalimmsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid [pweight=wgtc13]

*SI Table 3

reg govmedmeandistance c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid 
reg iraqmeandistance c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid
reg wiretappingmeandistance c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid
reg illegalimmmeandistance c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid 

reg govmedicalsd_inparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid
reg govmedicalsd_outparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid
reg iraqtroopsd_inparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid 
reg iraqtroopsd_outparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid 
reg wiretappingsd_inparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid
reg wiretappingsd_outparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid
reg illegalimmsd_inparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid 
reg illegalimmsd_outparty_correct c.avgdis c.formedavg c.avgdis#c.formedavg c.male c.nonwhite c.educ1to5 c.age2 c.interestw9 c.netsize c.spid

*SI Figure 2

reg govmedmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
estat hettest 
rvpplot avgdis

reg iraqmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
estat hettest 
rvpplot avgdis

reg wiretappingmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
estat hettest 
rvpplot avgdis

reg illegalimmmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
estat hettest 
rvpplot avgdis

*SI Figure 3

reg govmedicalsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
estat hettest  
rvpplot avgdis

reg govmedicalsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
estat hettest  
rvpplot avgdis

reg iraqtroopsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
estat hettest 
rvpplot avgdis

reg iraqtroopsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
estat hettest 
rvpplot avgdis 

reg wiretappingsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
estat hettest 
rvpplot avgdis 

reg wiretappingsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
estat hettest 
rvpplot avgdis 

reg illegalimmsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
estat hettest 
rvpplot avgdis

reg illegalimmsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
estat hettest 
rvpplot avgdis

*SI Table 4

reg govmedmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg iraqmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg wiretappingmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust 
reg illegalimmmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust

*SI Table 5

reg govmedicalsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg govmedicalsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg iraqtroopsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg iraqtroopsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg wiretappingsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg wiretappingsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust
reg illegalimmsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust 
reg illegalimmsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid, robust

*SI Table 6

reg govmedmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid govmednoskew
reg iraqmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid iraqnoskew
reg wiretappingmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid wiretappingnoskew
reg illegalimmmeandistance avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid illegalimmnoskew

*SI Table 7

reg govmedicalsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid govmednoskew
reg govmedicalsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid govmednoskew
reg iraqtroopsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid iraqnoskew
reg iraqtroopsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid iraqnoskew
reg wiretappingsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid wiretappingnoskew
reg wiretappingsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid wiretappingnoskew
reg illegalimmsd_inparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid illegalimmnoskew
reg illegalimmsd_outparty_correct avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid illegalimmnoskew

*SI Table 8

ologit w19like_dislike_dem avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid if pidw9==1
ologit w19like_dislike_dem avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid if pidw9==3

ologit w19like_dislike_rep avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid if pidw9==1
ologit w19like_dislike_rep avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid if pidw9==3

*SI Table 9

reg govmedmeandistance avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqmeandistance avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingmeandistance avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmmeandistance avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*SI Table 10

reg govmedicalsd_inparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg govmedicalsd_outparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopsd_inparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopsd_outparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingsd_inparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingsd_outparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmsd_inparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmsd_outparty_correct avgdispid formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*SI Table 11

reg govmedicaloverlap avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopoverlap avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingoverlap avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmoverlap avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*SI Table 12

reg meandiffindex avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg inpartystddevindex avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg outpartystddevindex avgdis formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*SI Table 13

reg interestw19 govmedmeandistance spid male nonwhite educ1to5 age2 netsize avgdis interestw9 
reg interestw19 iraqmeandistance spid male nonwhite educ1to5 age2 netsize avgdis interestw9
reg interestw19 wiretappingmeandistance spid male nonwhite educ1to5 age2 netsize avgdis interestw9
reg interestw19 illegalimmmeandistance spid male nonwhite educ1to5 age2 netsize avgdis interestw9

*SI Table 14

reg interestw19 govmedicalsd_inparty_correct govmedicalsd_outparty_correct spid male nonwhite educ1to5 age2 netsize avgdis interestw9
reg interestw19  iraqtroopsd_inparty_correct  iraqtroopsd_outparty_correct spid male nonwhite educ1to5 age2 netsize avgdis interestw9
reg interestw19 wiretappingsd_inparty_correct wiretappingsd_outparty_correct spid male nonwhite educ1to5 age2 netsize avgdis interestw9
reg interestw19  illegalimmsd_inparty_correct  illegalimmsd_outparty_correct spid male nonwhite educ1to5 age2 netsize avgdis interestw9


*SI Table 15
reg govmedmeandistance avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqmeandistance avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingmeandistance avgdis agreeableness extraverted conscientiousness openness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmmeandistance avgdis agreeableness extraverted conscientiousness openness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 

*SI Table 16

reg govmedicalsd_inparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg govmedicalsd_outparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopsd_inparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg iraqtroopsd_outparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingsd_inparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg wiretappingsd_outparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmsd_inparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid 
reg illegalimmsd_outparty_correct avgdis openness agreeableness extraverted conscientiousness emostable formedavg male nonwhite educ1to5 age2 interestw9 netsize spid
