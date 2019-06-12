/////////VARIABLE DEFINITIONS.
//////Generate interest in politics scale:
gen int1=(5-v045001)/4 if v041001==1
gen int2=(4-v045095)/3 if v041001==1
egen rint=rmean(int1 int2)
//////Generate participation scale:
recode v045018x (1=1) (2=0) (3=0) (4=0), generate(rvote)
recode v045010 (1=1) (5=0), generate(rpar1)
recode v045011 (1=1) (5=0), generate(rpar2)
recode v045012 (1=1) (5=0), generate(rpar3)
recode v045013 (1=1) (5=0), generate(rpar4)
recode v045014 (1=1) (5=0), generate(rpar5)
recode v045015 (1=1) (5=0), generate(rpar6)
recode v045016 (1=1) (5=0), generate(rpar7)
recode v045167 (1=1) (5=0), generate(rpar8)
recode v045170 (1=1) (5=0), generate(rpar9)
recode v045169 (1=1) (5=0), generate(rpar10)
egen rpart=rmean(rvote rpar1 rpar2 rpar3 rpar4 rpar5 rpar6 rpar7 rpar8 rpar9 rpar10)
//////Generate age:
gen age=v043250
//////Generate income:
generate income=v043293x
//////Generate gender:
recode v043411 (1=1) (2=0), generate(gender)
//////Generate race:
gen white=1 if v043299==50
replace white=0 if v043299~=50
//////Generate education:
recode v043254 (0=0) (1=0) (2=0) (3=1) (4=2) (5=2) (6=3) (7=4), generate(educ)
//////Ideological cross-pressure
///Generate conomic issues scale:
gen serv=(7-v043136)/6
gen nathel=(v043150-1)/6
gen jobs=(v043152-1)/6
egen econsc=rmean(serv nathel jobs)
///Generate social issues scale:
gen women=(v043196-1)/6
gen gaydis=(v045156a-1)/4
gen gaymar=0 if v043210==1
replace gaymar=.5 if v043210>4
replace gaymar=1 if v043210==3
gen abort=(4-v045132)/3 if v045132<7
gen immig=(v045115-1)/4
gen rwomdis2=(5-v045206)/4
egen socsc=rmean(women gaydis gaymar abort immig rwomdis2)
///Generate cross-pressure scale:
gen crossp=abs(econsc-socsc)
///Center cross-pressure scale:
gen ccrossp=crossp-.2452366
//////Generate authoritarianism scale:
gen aut1=0 if v045208~=5
replace aut1=1 if v045208==5
gen aut2=0 if v045209~=5
replace aut2=1 if v045209==5
gen aut3=0 if v045210~=1
replace aut3=1 if v045210==1
gen aut4=0 if v045211~=5
replace aut4=1 if v045211==5
egen rauth=rmean(aut1-aut4)
///Center authoritarianism:
gen cauth=rauth-.4529703 
//////Generate ideology:
gen ideo1=(v043085-1) if v043085<8
replace ideo1=2 if v043085a==1
replace ideo1=3 if v043085a==5
replace ideo1=4 if v043085a==3  
gen rideo1=ideo1/6
///Center ideology scale.
gen crideo1=rideo1-.5460263 

/////////ANALYSES.
//////Interest in politics (Table 1 and Figure 1)
///estimate model:
reg rint age income gender white educ c.ccrossp c.cauth c.crideo1 c.crideo1#c.crideo1 c.cauth#c.crideo1, hc3
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology:
margins, dydx(cauth) at(crideo1=(-.2411646 .2411646))
///Graph:
quietly margins, dydx(cauth) at(crideo1=(-.2411646 (.02) .2411646))
marginsplot, recast(line) recastci(rarea) plotop(lcolor(black)) ciopt(color(gs10)) ylabel(-.3 (.1) .3) ///
	ytitle("Conditional effect of authoritarianism") title ("Dependent Variable: Interest in Politics") saving (anes1, replace)

//////Participation (Table 1 and Figure 1)
///estimate model:
reg rpart age income gender white educ c.ccrossp c.cauth c.crideo1 c.crideo1#c.crideo1 c.cauth#c.crideo1, hc3
///estimate conditional effects of authoritarianism at 1 SD above and below mean of ideology:
margins, dydx(cauth) at(crideo1=(-.2411646 .2411646))
///Graph:
quietly margins, dydx(cauth) at(crideo1=(-.2411646 (.02) .2411646))
marginsplot, recast(line) recastci(rarea) plotop(lcolor(black)) ciopt(color(gs10)) ylabel(-.3 (.1) .3) ///
	ytitle("Conditional effect of authoritarianism") title ("Dependent Variable: Participation") saving (anes2, replace)
///Combine graphs into Figure 1 (additional manual modification done to get appearance in paper):
graph combine anes1.gph anes2.gph, cols(1) altshrink  saving(authnes, replace)

//////Replication with media use (Footnote 3)
///Generate media-use variable.
gen rmed1=(5-v045003a)/4
replace rmed1=0 if v045003==0
gen rmed2=(5-v045006)/4
gen med3=(5-v045004a)
replace med3=0 if v045004==5
gen rmed3=med3/4
recode v045005a (1=3) (3=2) (5=1), generate(med4)
replace med4=0 if v045005==5
gen rmed4=med4/3
recode v045002a (1=3) (3=2) (5=1), generate(med5)
replace med5=0 if v045002==5
gen rmed5=med5/3
egen rmedia=rmean(rmed1 rmed2 rmed3 rmed4 rmed5)
///Analysis:
reg rmedia age income gender white educ c.ccrossp c.cauth c.crideo1 c.crideo1#c.crideo1 c.cauth#c.crideo1, hc3

//////Robustness check with age and education interactions added (Footnote 8 / Appendix)
///Center age and education:
summ age
gen cage=age-r(mean)
summ educ
gen ceduc=educ-r(mean)
///Analysis: 
reg rint c.cage income gender white c.ceduc c.ccrossp c.cauth c.crideo1 c.crideo1#c.crideo1 c.cauth#c.crideo1 c.cauth#c.cage c.cauth#c.ceduc, hc3
reg rpart c.cage income gender white c.ceduc c.ccrossp c.cauth c.crideo1 c.crideo1#c.crideo1 c.cauth#c.crideo1 c.cauth#c.cage c.cauth#c.ceduc, hc3
