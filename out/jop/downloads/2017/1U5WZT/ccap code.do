/////////VARIABLE DEFINITIONS.
//////Generate interest in politics scale:
gen int1=(3-SCAP813)/2 if SCAP813<4
gen int2=(4-SCAP802a)/3 if SCAP802a<5
egen rint=rmean(int1 int2)
//////Generate participation scale:
recode PCAP600 (1=1) (2=1) (3=1) (4=0), generate(rvote)
recode SCAP400_3 (1=1) (2=0), generate(rpar1)
recode SCAP400_5 (1=1) (2=0), generate(rpar2)
recode SCAP400_6 (1=1) (2=0), generate(rpar3)
recode OCAP400_3 (1=1) (2=0), generate(rpar4)
recode OCAP400_5 (1=1) (2=0), generate(rpar5)
recode OCAP400_6 (1=1) (2=0), generate(rpar6)
egen rpart=rmean(rvote rpar1-rpar6)
//////Generate state indicator:
gen state=PROFILE66
//////Generate age:
gen age2008=2008-PROFILE51
//////Generate income:
gen rinc=PROFILE59 if PROFILE59<15
//////Generate gender:
recode PROFILE54 (1=1) (2=0), generate(gender)
//////Generate race:
gen white=0 if PROFILE55~=1
replace white=1 if PROFILE55==1
//////Generate education:
recode PROFILE57 (1=0) (2=1) (3=2) (4=2) (5=3) (6=4), generate(reduc)
///recode education 0-1:
recode01 reduc
//////Ideological cross-pressure
///Generate conomic issues scale:
gen rhc4=(SCAP20-1)/2 if SCAP20<4
gen rtax4=(SCAP24-1)/3 if SCAP24<5
gen rjobs5=(OCAP1104-1)/6
egen recon45=rmean(rtax4 rhc4 rjobs5)
///Generate social issues scale:
recode SCAP16 (1=1) (3=0.5) (2=0), generate(immig4)
gen women4=(4-SCAP785)/3
gen death4=(4-OCAP1032)/3
recode OCAP1030 (2=1) (1=0), generate(gay4)
egen rsoc4=rmean(immig4 women4 death4 gay4)
///Generate cross-pressure scale:
gen crossp=abs(recon45-rsoc4)
///Center cross-pressure scale:
gen ccrossp=crossp-.2420984
//////Generate authoritarianism scale:
egen aut14=anycount(SCAP725 SCAP723), values(1)
egen aut24=anycount(SCAP719 SCAP721 SCAP722), values(5)
gen rauth4=(aut14+aut24)/5
///Center authoritarianism:
gen cauth4=rauth4-.40461 
//////Generate ideology.
gen rideo4=(SCAP700S-1)/4 if SCAP700S<6
///Center ideology.
gen crideo4=rideo4-.5511604

/////////ANALYSES.
//////Interest in politics (Table A2)
///estimate model:
reg rint i.state age2008 rinc gender white reduc01 c.ccrossp c.cauth4 c.crideo4 c.crideo4#c.crideo4 c.crideo4#c.cauth4, vce(cluster state)
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology:
margins, dydx(cauth4) at(crideo4=(-.2997243 .2997243))

//////Participation (Table A2)	
///estimate model:
reg rpart i.state age2008 rinc gender white reduc01 c.ccrossp c.cauth4 c.crideo4 c.crideo4#c.crideo4 c.crideo4#c.cauth4, vce(cluster state)
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology:
margins, dydx(cauth4) at(crideo4=(-.2997243 .2997243)) 

//////Robustness check with age and education interactions added (Footnote 8 / Appendix)
///Center age and education.
summ age2008
gen cage=age2008-r(mean)
summ reduc01
gen ceduc01=reduc01-r(mean)
///Analysis:
reg rint i.state cage rinc gender white ceduc01 c.ccrossp c.cauth4 c.crideo4 c.crideo4#c.crideo4 c.crideo4#c.cauth4 c.cage#c.cauth4 c.ceduc01#c.cauth4, vce(cluster state)
reg rpart i.state cage rinc gender white ceduc01 c.ccrossp c.cauth4 c.crideo4 c.crideo4#c.crideo4 c.crideo4#c.cauth4 c.cage#c.cauth4 c.ceduc01#c.cauth4, vce(cluster state)

