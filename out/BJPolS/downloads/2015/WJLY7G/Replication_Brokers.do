
*** Loads data from brokers survey 
*You will need to specify the appropriate directory 
use "/Users/eddiecamp/Documents/Organizational Challenges/Replication Files /Brokers_Survey.dta"


***** Declare survey design 
svyset municipality [pweight=selectprob], strata(province) vce(linearized) singleunit(missing)

*** This provides the average number of broker who work for a councilor in each province
svy: mean q37 if province==1
svy: mean q37 if province==2
svy: mean q37 if q37!=1000 & province==3
svy: mean q37 if province==4

**** This shows that the majority of brokers organize less than 200 voters 
svy: tab q35

*** This provides the frequency of percentages of voters that brokers believe will turn out to support a party in a general election if they went to the parties rally
svy: tab q33b

***Generates Dummy Variables for the primary parties in Argentina
gen pj=0
replace pj=1 if q1_alt=="PJ (no especificado)"|q1_alt=="PJ/FPV"|q1_alt=="Justicialista Compromiso Federal"|q1_alt=="PJ/Union Por Cordoba"|q1_alt=="PUL (San Luis, Rodriguez Saa)"
gen ucr=0
replace ucr=1 if q1_alt=="Radical (UCR)"
gen pro=0
replace pro=1 if q1_alt=="Union-PRO"
gen renovador=0
replace renovador=1 if q1_alt=="Frente Renovador (Misiones)"



**Generates Dummy Variables for all fo the Provinces 
gen BA=1 if province==1
replace BA=0 if province!=1
gen MI=1 if province==2
replace MI=0 if province!=2
gen CO=1 if province==3
replace CO=0 if province!=3
gen SL=1 if province==4
replace SL=0 if province!=4

**Generates Dummy Variables for each version of the Survey
gen ver1=1 if a4==1
replace ver1=0 if a4!=1
gen ver2=1 if a4==2
replace ver2=0 if a4!=2
gen ver3=1 if a4==3
replace ver3=0 if a4!=3
gen ver4=1 if a4==4
replace ver4=0 if a4!=4

**Generates Dummy Variables for all of the Municipalities 
forval i = 1(1)71{
gen var`i'=1 if municipality==`i'
replace var`i'=0 if municipality!=`i'
}

forval i=1(1)84{
gen sur`i'=1 if a2==`i'
replace sur`i'=0 if a2!=`i'
}


*Generates the independent variable Career Reward
gen CareerReward=1 if q11b==1|q11b==2
replace CareerReward=0 if q11b==3 

**** Generates the independent variable No Exit, nonexit2 is the Independent variable for the Robustness Check
gen noexit=q3  
replace noexit=0 if q3==2 & q2>1983
replace noexit=1 if q2<=1983

gen noexit2=q3  
replace noexit2=0 if q3==2 & q2>2002
replace noexit2=1 if q2<=2002

**** Generates the independent variable Core
gen percentsame=q9b/q9a
gen Core=abs(.5-percentsame)


*This provides the results for models 1 and 2 in table 1.  
svy: reg q35 q31_alt 
svy: reg q35 q31_alt ver1 ver2 ver3 q41 q42a q43 q38 q39 pj ucr pro renovador BA CO MI var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22 var23 var24 var25 var26 var27 var28 var29 var30 var31 var32 var33 var34 var35 var36 var37 var38 var39 var40 var41 var42 var43 var44 var45 var46 var47 var48 var49 var50 var51 var52 var53 var54 var55 var56 var57 var58 var59 var60 var61 var62 var63 var64 var65 var66 var67 var68 var69 var70 var71  


*This provides the results for models 3 and 4 in table 1.  
svy: reg q35 CareerReward
svy: reg q35 CareerReward ver1 ver2 ver3 q41 q42a q43 q38 q39 BA CO MI pj ucr pro renovador var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22 var23 var24 var25 var26 var27 var28 var29 var30 var31 var32 var33 var34 var35 var36 var37 var38 var39 var40 var41 var42 var43 var44 var45 var46 var47 var48 var49 var50 var51 var52 var53 var54 var55 var56 var57 var58 var59 var60 var61 var62 var63 var64 var65 var66 var67 var68 var69 var70 var71


*This provides the results for models 3 and 4 in table 1.  
svy: reg q35 q13_alt
svy: reg q35 q13_alt ver1 ver2 ver3 q41 q42a q43 q38 q39 BA CO MI pj ucr pro renovador var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22 var23 var24 var25 var26 var27 var28 var29 var30 var31 var32 var33 var34 var35 var36 var37 var38 var39 var40 var41 var42 var43 var44 var45 var46 var47 var48 var49 var50 var51 var52 var53 var54 var55 var56 var57 var58 var59 var60 var61 var62 var63 var64 var65 var66 var67 var68 var69 var70 var71

****This provides the results for columns 1 and 2 in table 2
svy: reg q35 noexit
svy: reg q35 noexit ver1 ver2 ver3 q41 q42a q43 q38 q39 BA CO MI pj ucr pro renovador var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22 var23 var24 var25 var26 var27 var28 var29 var30 var31 var32 var33 var34 var35 var36 var37 var38 var39 var40 var41 var42 var43 var44 var45 var46 var47 var48 var49 var50 var51 var52 var53 var54 var55 var56 var57 var58 var59 var60 var61 var62 var63 var64 var65 var66 var67 var68 var69 var70 var71

*** This provides the results for the robustness check for No Exit
svy: reg q35 noexit2
svy: reg q35 noexit2 ver1 ver2 ver3 q41 q42a q43 q38 q39 BA CO MI pj ucr pro renovador var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22 var23 var24 var25 var26 var27 var28 var29 var30 var31 var32 var33 var34 var35 var36 var37 var38 var39 var40 var41 var42 var43 var44 var45 var46 var47 var48 var49 var50 var51 var52 var53 var54 var55 var56 var57 var58 var59 var60 var61 var62 var63 var64 var65 var66 var67 var68 var69 var70 var71

****This provides the results for columns 3 and 4 in table 2
svy: reg q35 Core  
svy: reg q35 Core ver1 ver2 ver3 q41 q42a q43 q38 q39 BA CO MI pj ucr pro renovador var1 var2 var3 var4 var5 var6 var7 var8 var9 var10 var11 var12 var13 var14 var15 var16 var17 var18 var19 var20 var21 var22 var23 var24 var25 var26 var27 var28 var29 var30 var31 var32 var33 var34 var35 var36 var37 var38 var39 var40 var41 var42 var43 var44 var45 var46 var47 var48 var49 var50 var51 var52 var53 var54 var55 var56 var57 var58 var59 var60 var61 var62 var63 var64 var65 var66 var67 var68 var69 var70 var71

*** This provides the percentage of brokers who never exited a party 
svy: tab noexit
svy: tab noexit if province==1
svy: tab noexit if province==2
svy: tab noexit if province==3
svy: tab noexit if province==4

**This provides the rate of brokers who say that a broker would abandon a party boss if the boss distributed resources away from the broker
gen abandon=1 if q16b==3|q16b==4|q16b==5
replace abandon=0 if q16b==1|q16b==2
svy: mean abandon

*** Generates Dummy Variables for experimental treatments
	*** Generates a dummy variable that measures the number of voters a broker has Many=1 and Few=0 
gen MvF=0
replace MvF=1 if a4==1 | a4==2

	*** Generates a dummy variable that measures the number of voters a broker has when a broker has all loyal voters Many=1 and Few=0 
gen MAvFA=0 if a4==3
replace MAvFA=1 if a4==1

	*** Generates a dummy variable that measures the number of voters a broker has when a broker has few loyal voters Many=1 and Few=0
gen MVvFV=0 if a4==4
replace MVvFV=1 if a4==2

**** Provides the results for Table 3
ttest q16a, by(MvF) level(90)
ttest q16a, by(MvF) level(95)
ttest q16a, by(MAvFA) level(90)
ttest q16a, by(MAvFA) level(95)
ttest q16a, by(MVvFV) level(90)
ttest q16a, by(MVvFV) level(95)

*** Provides the results for Table 5
svy: mean q14_alt q15_alt 
lincom [q14_alt]-[q15_alt]
lincom [q14_alt]-[q15_alt], level(95)

**** Provides Summary Statistics 
sum q35
sum q31_alt
sum CareerReward
sum q13_alt
sum noexit
sum Core
sum q39
sum q42a_alt
sum q41
sum q38
sum q43_alt
sum pj
sum ucr
sum pro
sum renovador
sum BA
sum MI
sum CO
sum ver1 
sum ver2
sum ver3


*** Data used to calculate the average number of voters from the Nazareno, Brusco, and Stokes (2006) dataset
*** You will need to specicfy the appropriate directory 
use "/Users/eddiecamp/Documents/Organizational Challenges/Replication Files /currentsiete.dta"

*** Calculates the average number of voters
mean votos


