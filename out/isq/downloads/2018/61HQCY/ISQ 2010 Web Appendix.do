 *ISQ Tables in Web Appendix   - Murdie and Davis (2010 Submission)
 
 set more off 
 *Components of Physical Integrity
 
oprobit F.kill2   interactdomint    domint  HRnc2gcnc2  normaledlnpop kill2 normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust
oprobit F.tort2   interactdomint    domint  HRnc2gcnc2  normaledlnpop tort2 normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust
oprobit F.polpris2   interactdomint    domint  HRnc2gcnc2  normaledlnpop polpris2 normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust
oprobit F.disap2   interactdomint    domint  HRnc2gcnc2  normaledlnpop disap2 normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust

*change to reflect lagged dvar 

xtgee F.improvementkill2 interactdomint   kill2  domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementtort2 interactdomint    tort2 domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementpolpris2 interactdomint   polpris2 domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementdisap2 interactdomint  disap2  domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)

 
*lags 

newey F2.physint  interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR   if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F3.physint  interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR   if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F4.physint  interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR   if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F5.physint  interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR   if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F6.physint  interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR   if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
	
*Hafner-Burton AI and domint

*gen ailnhrfilled = Media_ai_tot * lnhrfilled 
newey F.physint  ailnhrfilled   Media_ai_tot  lnhrfilled  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
*gen aiindirect = Media_ai_tot  * HROindirect2gcnc2
newey F.physint  aiindirect  Media_ai_tot  HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint   ailnhrfilled aiindirect lnhrfilled  Media_ai_tot  HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
*gen aidomint = domint * Media_ai_tot 
 newey F.physint  aidomint  domint Media_ai_tot normaledlnpop normaledlngdp polity2 WAR if F.physint<8 & physint<8 & L.physint<8  , lag(1) force

*Robustness checks with interaction between indirect targeting and domestic HRO presence 
 
 newey F.physint  IHRconflictlnhrfilled2  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
 xtgee F.improvementphysint indirectHRO   HROindirect2gcnc2 lnhrfilled normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)
 
 
 
*with coverage
newey F.physint    HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR lncoverage  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  IHRconflictlnhrfilled2    lnhrfilled HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR lncoverage if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  INDIRECTDIRECT   HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR lncoverage if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  IHRconflictlnhrfilled2  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  lncoverage if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR  lncoverage if F.physint<8 & physint<8 & L.physint<8  , lag(1) force






xtgee F.improvementphysint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  lncoverage if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint IHRconflictlnhrfilled2  HRnc2gcnc2 lnhrfilled normaledlnpop normaledlngdp polity2 WAR lncoverage if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint INDIRECTDIRECT   HROindirect2gcnc2  HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  lncoverage if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint IHRconflictlnhrfilled2  INDIRECTDIRECT HRnc2gcnc2 HROindirect2gcnc2 lnhrfilled  normaledlnpop normaledlngdp polity2 WAR lncoverage  if F.physint<8 & physint<8 & L.physint<8, force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR lncoverage if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)



*Robustness checks with key ivar and economic vulnerability in same model:

newey F.physint  interactdomint  domint shamingtrade  gletradepergdp HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  interactdomint  domint shamingaid2  aidpercofgni HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  interactdomint  domint shamingFDI  fdiinflowpercgdp  HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  interactdomint  domint shamingcap capdepend   HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force
newey F.physint  interactdomint  domint shamingdemoc democ2  HRnc2gcnc2    normaledlnpop  normaledlngdp WAR if F.physint<8 & physint<8 & L.physint<8  , lag(1) force


xtgee F.improvementphysint interactdomint  domint shamingtrade  gletradepergdp HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint interactdomint  domint shamingaid2 aidpercofgni HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint interactdomint  domint shamingFDI  fdiinflowpercgdp  HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint interactdomint  domint shamingcap capdepend   HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementphysint interactdomint  domint shamingdemoc  democ2 HRnc2gcnc2    normaledlnpop  normaledlngdp WAR if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)



*change to reflect lagged dvar  - Online Appendix Table 1

xtgee F.improvementkill2 interactdomint   kill2  domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementtort2 interactdomint    tort2 domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementpolpris2 interactdomint   polpris2 domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
xtgee F.improvementdisap2 interactdomint  disap2  domint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)


*Table 12

 xtgee F.improvementphysint indirectHRO  physint HROindirect2gcnc2 lnhrfilled normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)
	outtex, label legend detail below
 
 *Table 18-22
 
 xtgee F.improvementphysint HRnc2gcnc2  physint normaledlnpop normaledlngdp polity2 WAR  lncoverage if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
	outtex, label legend detail below
 xtgee F.improvementphysint IHRconflictlnhrfilled2  physint  HRnc2gcnc2 lnhrfilled normaledlnpop normaledlngdp polity2 WAR lncoverage if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)
	outtex, label legend detail below
 xtgee F.improvementphysint INDIRECTDIRECT  physint   HROindirect2gcnc2  HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  lncoverage if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)
	outtex, label legend detail below
 xtgee F.improvementphysint IHRconflictlnhrfilled2 physint   INDIRECTDIRECT HRnc2gcnc2 HROindirect2gcnc2 lnhrfilled  normaledlnpop normaledlngdp polity2 WAR lncoverage  if F.physint<8 & physint<8 & L.physint<8, force family(binomial) link(probit) corr(ar1)
	outtex, label legend detail below
 xtgee F.improvementphysint interactdomint  physint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR lncoverage if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
	outtex, label legend detail below


*Table 24

xtgee F.improvementphysint interactdomint physint  domint shamingtrade  gletradepergdp HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
outtex, label legend detail below
xtgee F.improvementphysint interactdomint physint  domint shamingaid2 aidpercofgni HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
outtex, label legend detail below
xtgee F.improvementphysint interactdomint  physint domint shamingFDI  fdiinflowpercgdp  HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
outtex, label legend detail below
xtgee F.improvementphysint interactdomint physint  domint shamingcap capdepend   HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
outtex, label legend detail below
xtgee F.improvementphysint interactdomint physint  domint shamingdemoc  democ2 HRnc2gcnc2    normaledlnpop  normaledlngdp WAR if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)
outtex, label legend detail below

*lagged dvar tables:


*Model 1:

reg  F.physint   HRnc2gcnc2 physint    normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust
outtex, label legend detail below

reg  F.physint   HRnc2gcnc2 physint    normaledlnpop normaledlngdp polity2 WAR  i.year if F.physint<8 & physint<8 & L.physint<8  , robust
outtex, label legend detail below

xtreg F.physint   HRnc2gcnc2 physint    normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust re
outtex, label legend detail below


xtgee  F.physint   HRnc2gcnc2 physint    normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force corr(ind) vce(robust)
outtex, label legend detail below



*Model 2:  

reg F.physint  IHRconflictlnhrfilled2  physint    lnhrfilled HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust 
outtex, label legend detail below


reg F.physint  IHRconflictlnhrfilled2  physint    lnhrfilled HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  i.year if F.physint<8 & physint<8 & L.physint<8  , robust 
outtex, label legend detail below

xtreg F.physint  IHRconflictlnhrfilled2  physint    lnhrfilled HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust re 
outtex, label legend detail below



xtgee F.physint  IHRconflictlnhrfilled2  physint    lnhrfilled HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force corr(ind) vce(robust)
outtex, label legend detail below



*Model 3:  

reg  F.physint  INDIRECTDIRECT  physint  HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  ,  robust
outtex, label legend detail below


reg  F.physint  INDIRECTDIRECT  physint  HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR i.year if F.physint<8 & physint<8 & L.physint<8  ,  robust
outtex, label legend detail below


xtreg  F.physint  INDIRECTDIRECT  physint  HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  ,  robust re 
outtex, label legend detail below


xtgee  F.physint  INDIRECTDIRECT  physint  HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force corr(ind) vce(robust)
outtex, label legend detail below

*Model 4:  

reg  F.physint  IHRconflictlnhrfilled2 physint  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust 
outtex, label legend detail below


reg  F.physint  IHRconflictlnhrfilled2 physint  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 i.year WAR  if F.physint<8 & physint<8 & L.physint<8  , robust 
outtex, label legend detail below

xtreg  F.physint  IHRconflictlnhrfilled2 physint  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust re 
outtex, label legend detail below

xtgee F.physint  IHRconflictlnhrfilled2 physint  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force corr(ind) vce(robust)
outtex, label legend detail below


*Model 5:

reg F.physint     interactdomint HRnc2gcnc2 domint   physint normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust 
outtex, label legend detail below




reg F.physint     interactdomint HRnc2gcnc2 domint   physint  normaledlnpop normaledlngdp polity2 WAR  i.year if F.physint<8 & physint<8 & L.physint<8  , robust 
outtex, label legend detail below



xtreg F.physint     interactdomint HRnc2gcnc2 domint   physint normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , robust re
outtex, label legend detail below


xtgee F.physint     interactdomint HRnc2gcnc2 domint   physint normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force corr(ind) vce(robust)
outtex, label legend detail below
