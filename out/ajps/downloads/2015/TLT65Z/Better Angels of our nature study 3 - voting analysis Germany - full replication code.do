*******Regression models of impact of MCP on voting behaviour, GCCAP data, with full irobustness checks***
***R.Ford, 01/12/2011

*****"Better Angels of Our Nature" (American Journal of Political Science) replication code**** 
 *****Study 3: Voting Behaviour (German voters) Conducted using the British Comparative Campaign Analysis Project data****
***Final analysis replication do file***
***Code compiled by Robert Ford (rob.ford@manchester.ac.uk)
***This version: 29th January 2013
****Run using "better angels study 1 bccap final.dta", which is in the "Better Angels of Our Nature" folder at dataverse****


****Please refer to demographics file for details of setting up variables
****Regressions run on data from the G-CCAP dataset "gccap.immsmall.votemerged.dta"



****Final set of models, full vote choice, SPD reference group 

****MODEL SET 1: IMMIGRATION ATTITUDES*****

****Model 1: IMCP only


mlogit votecandw1 IMCP01 if islam==0, base(1) 

mlogit voteptyw1 IMCP01 if islam==0, base(1) 

mlogit votecandw2 IMCP01 if islam==0, base(1) 

mlogit voteptyw2 IMCP01 if islam==0, base(1) 


***Model 2: IMCP and control for explicit immigration attitudes

mlogit votecandw1 IMCP01 immscale01 if islam==0, base(1) 

mlogit voteptyw1 IMCP01 immscale01 if islam==0, base(1) 

mlogit votecandw2 IMCP01 immscale01 if islam==0, base(1) 

mlogit voteptyw2 IMCP01 immscale01 if islam==0, base(1) 


****Model 3: Add full demographics 
**Meisterbrief and unskiloth excluded as they perfectly predict not supporting radical right***

***Full demographic model

#delimit ;
nestreg: mlogit votecandw1 (IMCP01 immscale01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman) (unionhh hhincpens ownhouse sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit voteptyw1 (IMCP01 immscale01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman) if islam==0, base(1); 

#delimit ;
nestreg: mlogit votecandw2 (IMCP01 immscale01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit voteptyw2 (IMCP01 immscale01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

****Model 4: Demographics, no immigration attitudes

#delimit ;
nestreg: mlogit votecandw1 (IMCP01 ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit voteptyw1 (IMCP01 ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit votecandw2 (IMCP01 ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit voteptyw2 (IMCP01 ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 


***Model 5: Leader assessments - Oskar Lafontaine and Seehofer dropped because they don't predict anything

# delimit ;
mlogit votecandw1 IMCP01 immscale01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1);


****Model 6: Issues and govt performance on them

# delimit ;
mlogit votecandw1 IMCP01 immscale01   crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01   crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01  crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1);

***Model 7: MCP and PID  


# delimit ;
mlogit votecandw1 IMCP01  SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01  SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01  SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1);

***Model 8: MCP, imm and PID

# delimit ;
mlogit votecandw1 IMCP01 immscale01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1);

***Model 9: MCP, imm, left-right self placement

# delimit ;
mlogit votecandw1 IMCP01 immscale01 LRselfplacew1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01 LRselfplacew1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01 LRselfplacew1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01 LRselfplacew1 if islam==0, base(1);

***Model 10: MCP, imm, LR self place and placement of others

# delimit ;
mlogit votecandw1 IMCP01 immscale01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1);


****Model 11: MCP, imm and economic assessments. 

# delimit ;
mlogit votecandw1 IMCP01 immscale01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1);

****Model xx: MCP, imm and satisfaction with democracy


# delimit ;
mlogit votecandw1 IMCP01 immscale01  polintw1 satdemw2 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 immscale01  polintw1 satdemw2 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 immscale01 polintw1 satdemw2  if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01  polintw1 satdemw2 if islam==0, base(1);

**** Model xxx: Combined, no issues

# delimit ;
mlogit votecandw1 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw1 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit votecandw2 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 



****Model 13: Combined, issues added

# delimit ;
mlogit votecandw1 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw1 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit votecandw2 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

****IMPLICIT ATTITUDES MODELS***

replace TurkMaleRate =. if TotalRate==0|TotalRate==1
replace TurkFemaleRate =. if TotalRate==0|TotalRate==1
replace GermanMaleRate =. if TotalRate==0|TotalRate==1
replace GermanFemaleRate =. if TotalRate==0|TotalRate==1

gen AMPclickthru = 0
replace AMPclickthru=1 if amp_TurkMaleRate==1 & amp_TurkFemaleRate==1 & amp_GermanMaleRate==1 & amp_GermanFemaleRate==1 & amp_CorporateRate==1 & amp_HeadscarfRate==1
replace AMPclickthru=1 if amp_TurkMaleRate==0 & amp_TurkFemaleRate==0 & amp_GermanMaleRate==0 & amp_GermanFemaleRate==0 & amp_CorporateRate==0 & amp_HeadscarfRate==0


gen AMPmalediff =  amp_TurkMaleRate - amp_GermanMaleRate
gen AMPfemalediff =  amp_TurkFemaleRate - amp_GermanFemaleRate
gen AMPhscarfdiff =  amp_HeadscarfRate - amp_GermanFemaleRate
gen AMPhscarfdiff2 = amp_HeadscarfRate - amp_TurkFemaleRate

foreach x in AMPmalediff AMPfemalediff AMPhscarfdiff AMPhscarfdiff2 {
recode `x' (else=.) if AMPclickthru==1
}
gen AMPmalediff01 = (AMPmalediff + 1)/2



***Model 2: IMCP and control for implicit immigration attitudes

mlogit votecandw1 IMCP01 AMPmalediff0101 if islam==0, base(1) 

mlogit voteptyw1 IMCP01 AMPmalediff01 if islam==0, base(1) 

mlogit votecandw2 IMCP01 AMPmalediff01 if islam==0, base(1) 

mlogit voteptyw2 IMCP01 AMPmalediff01 if islam==0, base(1) 


****Model 3: Add full demographics 
**Meisterbrief and unskiloth excluded as they perfectly predict not supporting radical right***

***Full demographic model

#delimit ;
nestreg: mlogit votecandw1 (IMCP01 AMPmalediff01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman) (unionhh hhincpens ownhouse sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit voteptyw1 (IMCP01 AMPmalediff01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman) if islam==0, base(1); 

#delimit ;
nestreg: mlogit votecandw2 (IMCP01 AMPmalediff01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

#delimit ;
nestreg: mlogit voteptyw2 (IMCP01 AMPmalediff01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman unemp incomescale) (unionhh hhincpens ownhouse mortgage sochouse) if islam==0, base(1); 

***Model 5: Leader assessments - Oskar Lafontaine and Seehofer dropped because they don't predict anything

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 AMPmalediff01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0, base(1);


****Model 6: Issues and govt performance on them

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01   crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 AMPmalediff01   crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01  crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0, base(1);


***Model 8: MCP, imm and PID

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 AMPmalediff01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01 SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1);

***Model 10: MCP, imm, LR self place and placement of others

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 AMPmalediff01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0, base(1);


****Model 11: MCP, imm and economic assessments. 

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1); 

# delimit ; 
mlogit voteptyw1 IMCP01 AMPmalediff01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0, base(1);

****Model xx: MCP, imm and satisfaction with democracy

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01  polintw1 satdemw2 if islam==0, base(1); 

mlogit votecandw1 IMCP01 amptotdiff  polintw1 satdemw2 if islam==0, base(1) 


# delimit ; 
mlogit voteptyw1 IMCP01 AMPmalediff01  polintw1 satdemw2 if islam==0, base(1);

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01 polintw1 satdemw2  if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01  polintw1 satdemw2 if islam==0, base(1);

**** Model xxx: Combined, no issues

# delimit ;
mlogit votecandw1 IMCP01 AMPmalediff01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw1 IMCP01 AMPmalediff01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit votecandw2 IMCP01 AMPmalediff01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 




****Model 13: Combined, issues added

# delimit ;
mlogit votecandw1 IMCP01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw1 IMCP01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit votecandw2 IMCP01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

# delimit ;
mlogit voteptyw2 IMCP01 AMPmalediff01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0, base(1); 

*****MODELS: EVER SHOW SUPPORT RADICAL RIGHT****

****Model 1: IMCP only

logit radrtever IMCP01 if islam==0 

***Model 2: IMCP and control for explicit immigration attitudes


logit radrtever IMCP01 immscale01 if islam==0 


****Model 3: Add full demographics 
**Meisterbrief and unskiloth excluded as they perfectly predict not supporting radical right***

***Full demographic model

#delimit ;
nestreg: logit radrtever (IMCP01 immscale01) (ageunder30 age30s age40s age50s) (jobtrain polytechnique degree doctorate educoth) 
(male selfemp profman technical skilman) (unionhh hhincpens ownhouse sochouse) if islam==0; 

***Model 5: Leader assessments - Oskar Lafontaine and Seehofer dropped because they don't predict anything

# delimit ;
logit radrtever IMCP01 immscale01  ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 
rategysiw1 if islam==0; 

****Model 6: Issues and govt performance on them

# delimit ;
logit radrtever IMCP01 immscale01 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 if islam==0; 

***Model 7: MCP and PID  - green ID dropped because perfectly predicts no support for rad rt

# delimit ;
logit radrtever IMCP01 immscale01 SPDidw1 CDUidw1 FDPidw1 linkeidw1 if islam==0; 

***Model 8: MCP, imm and PID

# delimit ;
logit radrtever IMCP01 immscale01 SPDidw1 FDPidw1 if islam==0; 

***Model 9: MCP, imm, LR self place and placement of others

logit radrtever IMCP01 immscale01 LRselfplacew1  LRCDUw1 LRSPDw1 LRgrnw1 LRlinkew1 if islam==0

****Model 11: MCP, imm and economic assessments. 

logit radrtever IMCP01 immscale01  natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 if islam==0 

***Model 12: pol int and satisfaction with democracy

logit radrtever IMCP01 immscale01  polintw1 satdemw2 if islam==0

**** Model xxx: Combined, no issues


# delimit ;
logit radrtever IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1  
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0; 



****Model 13: Combined, issues added

# delimit ;
logit radrtever IMCP01 immscale01 natecoretw1 natecoprospw1 perecoretw1 perecoprospw1 crimeratew1 crimeperfw1 healthqualw1 healthpolw1 
ratemerkw1 ratesteinw1 ratemuntw1 rateguidow1 raterenatew1 ratetrittinw1 rateguttenw1 rategysiw1 ageunder30 age30s age40s age50s 
jobtrain polytechnique degree doctorate educoth male selfemp profman technical skilman unemp incomescale unionhh hhincpens ownhouse mortgage sochouse
SPDidw1 CDUidw1 FDPidw1 grnidw1 linkeidw1 if islam==0; 

