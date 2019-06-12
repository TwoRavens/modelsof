*ISQ Tables in Document  - Murdie and Davis (2010 Submission)

*TABLE 1:

*Model 1:

newey F.physint      HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force

*Model 2:  

newey F.physint  IHRconflictlnhrfilled2    lnhrfilled HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force

*Model 3:  

newey F.physint  INDIRECTDIRECT   HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force

*Model 4:  

newey F.physint  IHRconflictlnhrfilled2  INDIRECTDIRECT   lnhrfilled HRnc2gcnc2 HROindirect2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force

*Model 5:

newey F.physint     interactdomint HRnc2gcnc2 domint   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force


*TABLE 2:

*Model 1:  

xtgee F.improvementphysint physint HRnc2gcnc2  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)


*Model 2:  
xtgee F.improvementphysint physint IHRconflictlnhrfilled2  HRnc2gcnc2 lnhrfilled normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)


*Model 3:

xtgee F.improvementphysint physint INDIRECTDIRECT   HROindirect2gcnc2  HRnc2gcnc2 normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8 ,  force family(binomial) link(probit) corr(ar1)


*Model 4:

xtgee F.improvementphysint physint IHRconflictlnhrfilled2  INDIRECTDIRECT HRnc2gcnc2 HROindirect2gcnc2 lnhrfilled  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8, force family(binomial) link(probit) corr(ar1)


*Model 5:

xtgee F.improvementphysint physint interactdomint  domint HRnc2gcnc2   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)


*TABLE 3:

*Model R1:  

newey F.physint shamingtrade HRnc2gcnc2 gletradepergdp  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force


*Model R2:

newey F.physint shamingaid2 HRnc2gcnc2 aidpercofgni  normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , lag(1) force


*Model R3:

newey F.physint shamingFDI  HRnc2gcnc2 fdiinflowpercgdp normaledlnpop normaledlngdp polity2 WAR if F.physint!=8 & physint!=8 & L.physint!=8, lag(1) force


*Model R4:

newey F.physint shamingcap  HRnc2gcnc2 capdepend   normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8, lag(1) force
  
*Model R5:

newey F.physint  shamingdemoc democ2  HRnc2gcnc2    normaledlnpop  normaledlngdp WAR if F.physint<8 & physint<8 & L.physint<8  , lag(1) force


*TABLE 4:

*Model R1:  

xtgee F.improvementphysint physint  shamingtrade HRnc2gcnc2 gletradepergdp normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  , force family(binomial) link(probit) corr(ar1)
			
*Model R2:
xtgee F.improvementphysint physint  shamingaid2 HRnc2gcnc2 aidpercofgni normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8  ,   force family(binomial) link(probit) corr(ar1)


*Model R3:  

xtgee F.improvementphysint  physint shamingFDI  HRnc2gcnc2 fdiinflowpercgdp normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8,  force family(binomial) link(probit) corr(ar1)


*Model R4:
xtgee F.improvementphysint  physint shamingcap HRnc2gcnc2 capdepend normaledlnpop normaledlngdp polity2 WAR  if F.physint<8 & physint<8 & L.physint<8, force family(binomial) link(probit) corr(ar1)


*Model R5:

xtgee F.improvementphysint physint  shamingdemoc  democ2 HRnc2gcnc2    normaledlnpop  normaledlngdp WAR if F.physint<8 & physint<8 & L.physint<8 , force family(binomial) link(probit) corr(ar1)

			
