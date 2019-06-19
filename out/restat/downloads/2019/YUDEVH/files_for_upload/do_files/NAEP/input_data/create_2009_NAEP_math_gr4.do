version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Math Nat'l and State GR 4&8\STATA\LABELDEF.do"
label data "  2009 National Mathematics Grade 4 Student & Teacher Data"
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Math Nat'l and State GR 4&8\STATA\M40NT1AT.DCT", clear
label values  FIPS02    FIPS02Q
label values  ORIGSUB   ORIGSUB
label values  PUBPRIV   PUBPRIV
label values  BMONTH    BMONTH
label values  SEX       SEX
label values  SRACE     SRACE
label values  SLNCH05   SLNCH05Q
label values  SLUNCH1   SLUNCH1Q
label values  SD4       SD4Q
label values  ELL3      ELL3Q
label values  NEWENRL   NEWENRL
label values  ACCOMCD   ACCOMCD
label values  ACCBDR    NOYES
label values  ACCBIB    NOYES
label values  ACCBID    NOYES
label values  ACCREA    NOYES
label values  ACCBRL    NOYES
label values  ACCLRG    NOYES
label values  ACCMAG    NOYES
label values  ACCSCR    NOYES
label values  ACCSMG    NOYES
label values  ACCONE    NOYES
label values  ACCSSA    NOYES
label values  ACCEXT    NOYES
label values  ACCBRK    NOYES
label values  ACCOTH    NOYES
label values  TCHMTCH   TCHMTCH
label values  COHORT    COHORT
label values  PCHARTR   PCHARTR
label values  PCHRAYP   PCHRAYP
label values  PCHRTFL   PCHARTR
label values  TYPCLAS   TYPCLAS
label values  CHARTER   CHARTER
label values  ACCOMST   ACCOMST
label values  MOB       BMONTH
label values  DSEX      SEX
label values  ORIGSUP   ORIGSUP
label values  REGION    REGION
label values  REGIONS   REGION
label values  CENSREG   CENSREG
label values  CENSDIV   CENSDIV
label values  ABSSERT   ABSSERT
label values  JKUNIT    JKUNIT
label values  JKNU      PCHRAYP
label values  SCHTYPE   SCHTYPE
label values  RPTSAMP   RPTSAMP
label values  UTOL12    UTOL12Q
label values  UTOL4     UTOL4Q
label values  DISTCOD   DISTCOD
label values  TUAFLG3   TUAFLG3Q
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SDRACEM   SDRACEM
label values  SENROL4   SENROL4Q
label values  YRSEXP    YRSEXP
label values  PCTBLKC   PCTBLKC
label values  PCTHSPC   PCTBLKC
label values  PCTASNC   PCTBLKC
label values  PCTINDC   PCTBLKC
label values  SCHTYP2   TYPCLAS
label values  LRGCITY   YESNO
label values  CHRTRPT   CHRTRPT
label values  FIPS      FIPS02Q
label values  SAMPTYP   SAMPTYP
label values  LEP       LEP
label values  IEP       IEP
label values  SD3       SD3Q
label values  SDELL     SDELL
label values  SLUNCH    SLUNCH
label values  ACCOM2    ACCOM2Q
label values  Y40OMC    BLKUSE
label values  Y40OMD    BLKUSE
label values  Y40OME    BLKUSE
label values  Y40OMF    BLKUSE
label values  Y40OMG    BLKUSE
label values  Y40OMH    BLKUSE
label values  Y40OMI    BLKUSE
label values  Y40OMJ    BLKUSE
label values  Y40OMK    BLKUSE
label values  Y40OML    BLKUSE
label values  IEP2009   YESNO
label values  BA21101   YESNO
label values  BB21101   YESNO
label values  BC21101   YESNO
label values  BD21101   YESNO
label values  BE21101   YESNO
label values  BA21201   YESNO
label values  BB21201   YESNO
label values  BC21201   YESNO
label values  BD21201   YESNO
label values  BE21201   YESNO
label values  B017001   YESNO
label values  B000905   YESNO
label values  B013801   B013801Q
label values  B017101   YESNO
label values  B017201   YESNO
label values  B001151   B001151Q
label values  B017451   B017451Q
label values  B018101   B018101Q
label values  B018201   B018201Q
label values  M814301   M814301Q
label values  M823901   YESNO
label values  M820401   YESNO
label values  M814601   YESNO
label values  M814701   YESNO
label values  M814501   YESNO
label values  M814901   YESNO
label values  M824001   M824001Q
label values  M824101   M824001Q
label values  M815001   M815001Q
label values  M815101   M815101Q
label values  M815201   M815201Q
label values  M815301   M815301Q
label values  M821401   YESNO
label values  M824201   M824201Q
label values  M824301   M824201Q
label values  M824401   M824201Q
label values  M824501   M824201Q
label values  M824601   M824201Q
label values  M824701   M824201Q
label values  M824801   M824201Q
label values  M815401   M815401Q
label values  M815501   M815501Q
label values  M815601   M815601Q
label values  M145201   MC5C
label values  M145301   MC5A
label values  M145401   MC5D
label values  M145501   MC5C
label values  M145601   MC5B
label values  M145701   MC5D
label values  M145801   MC5D
label values  M145901   RATE3B
label values  M1459R1   MC5E
label values  MG45901   RATE3B
label values  MG459R1   MC5E
label values  MH45901   RATE3B
label values  MH459R1   MC5E
label values  M146001   MC5C
label values  M146101   RATE2D
label values  M1461R1   MC5D
label values  MG46101   RATE2D
label values  MG461R1   MC5D
label values  MH46101   RATE2D
label values  MH461R1   MC5D
label values  M146201   MC5C
label values  M146301   RATE3B
label values  M1463R1   MC5C
label values  MG46301   RATE3B
label values  MG463R1   MC5C
label values  MH46301   RATE3B
label values  MH463R1   MC5C
label values  M146401   RATE3B
label values  MG46401   RATE3B
label values  MH46401   RATE3B
label values  M146501   MC5D
label values  M146601   M146601Q
label values  MG46601   M146601Q
label values  MH46601   M146601Q
label values  M146701   MC5C
label values  M146801   RATE2D
label values  MG46801   RATE2D
label values  MH46801   RATE2D
label values  M146901   RATE3B
label values  MG46901   RATE3B
label values  MH46901   RATE3B
label values  M147001   RATE3B
label values  MG47001   RATE3B
label values  MH47001   RATE3B
label values  M147101   MC5D
label values  M147201   MC5B
label values  M147301   MC5A
label values  M147401   MC5B
label values  M147501   MC5B
label values  M147601   MC5B
label values  M147701   MC5C
label values  M147801   MC5B
label values  M147901   MC5A
label values  M148001   MC5C
label values  M148101   RATE3B
label values  MG48101   RATE3B
label values  MH48101   RATE3B
label values  M085201   MC5C
label values  M085301   MC5C
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   RATE3B
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085401   M146601Q
label values  MB85401   M146601Q
label values  MC85401   M146601Q
label values  M019701   M019701Q
label values  MB19701   M019701Q
label values  MC19701   M019701Q
label values  M020001   M019701Q
label values  MB20001   M019701Q
label values  MC20001   M019701Q
label values  M046301   MC5B
label values  M047001   MC5D
label values  M046501   MC5A
label values  M066501   RATE3B
label values  MB66501   RATE3B
label values  MC66501   RATE3B
label values  M047101   MC5C
label values  M066301   RATE3B
label values  MB66301   RATE3B
label values  MC66301   RATE3B
label values  M067901   RATE3B
label values  MB67901   RATE3B
label values  MC67901   RATE3B
label values  M135601   MC5C
label values  M135701   MC5A
label values  M135801   MC5B
label values  M135901   MC5A
label values  M136001   MC5B
label values  M136101   MC5D
label values  M136201   MC5A
label values  M136301   MC5C
label values  M136401   MC5D
label values  M136501   M136501Q
label values  MG36501   RATE2D
label values  MH36501   RATE2D
label values  M136601   M136601Q
label values  MG36601   M136601Q
label values  MH36601   M136601Q
label values  M136701   MC5D
label values  M136801   MC5B
label values  M136901   M136901Q
label values  M1369R1   MC5C
label values  MG36901   M136901Q
label values  MG369R1   MC5C
label values  MH36901   M136901Q
label values  MH369R1   MC5C
label values  M137001   MC5D
label values  M137101   MC5C
label values  M154501   MC5C
label values  M1545A1   YESNO
label values  M170001   MC5D
label values  M1700A1   YESNO
label values  M156701   RATE2D
label values  MG56701   RATE2D
label values  MH56701   RATE2D
label values  M1567A1   YESNO
label values  M157101   MC5C
label values  M1571A1   YESNO
label values  M160201   MC5D
label values  M1602A1   YESNO
label values  M158601   MC5B
label values  M1586A1   YESNO
label values  M157301   RATE2D
label values  MG57301   RATE2D
label values  MH57301   RATE2D
label values  M1573A1   YESNO
label values  M157001   RATE3B
label values  M1570R1   MC5C
label values  MG57001   RATE3B
label values  MG570R1   MC5C
label values  MH57001   RATE3B
label values  MH570R1   MC5C
label values  M1570A1   YESNO
label values  M157201   MC5A
label values  M1572A1   YESNO
label values  M156801   MC5D
label values  M1568A1   YESNO
label values  M160701   RATE3B
label values  M1607R1   MC5E
label values  MG60701   RATE3B
label values  MG607R1   MC5E
label values  MH60701   RATE3B
label values  MH607R1   MC5E
label values  M1607A1   YESNO
label values  M160001   MC5A
label values  M1600A1   YESNO
label values  M162402   YESNO
label values  M162401   RATE3B
label values  M1624R1   MC5D
label values  MG62401   RATE3B
label values  MG624R1   MC5D
label values  MH62401   RATE3B
label values  MH624R1   MC5D
label values  M1624A1   YESNO
label values  M157701   MC5D
label values  M1577A1   YESNO
label values  M159401   M136901Q
label values  M1594R1   MC5C
label values  MG59401   M136901Q
label values  MG594R1   MC5C
label values  MH59401   M136901Q
label values  MH594R1   MC5C
label values  M1594A1   YESNO
label values  M010131   MC5A
label values  M0101A1   YESNO
label values  N214331   MC5D
label values  N2143A1   YESNO
label values  M039101   MC5A
label values  M0391A1   YESNO
label values  M086701   MC5A
label values  M0867A1   YESNO
label values  M010631   M010631Q
label values  MB10631   M010631Q
label values  MC10631   M010631Q
label values  M0106A1   YESNO
label values  M072301   MC5A
label values  M0723A1   YESNO
label values  M010831   MC5D
label values  M0108A1   YESNO
label values  M010331   MC5B
label values  M0103A1   YESNO
label values  M086901   MC5B
label values  M0869A1   YESNO
label values  M090901   MC5B
label values  M0909A1   YESNO
label values  M087001   RATE3B
label values  MB87001   RATE3B
label values  MC87001   RATE3B
label values  M0870A1   YESNO
label values  M039801   MC5B
label values  M0398A1   YESNO
label values  M040001   SCR3C
label values  MB40001   SCR3C
label values  MC40001   SCR3C
label values  M0400A1   YESNO
label values  M087201   MC5C
label values  M0872A1   YESNO
label values  M091201   RATE3B
label values  MB91201   RATE3B
label values  MC91201   RATE3B
label values  M0912A1   YESNO
label values  M066001   MC5A
label values  M0660A1   YESNO
label values  M072401   RATE3B
label values  MB72401   RATE3B
label values  MC72401   RATE3B
label values  M0724A1   YESNO
label values  M091301   MC5C
label values  M0913A1   YESNO
label values  M087301   M146601Q
label values  MB87301   M146601Q
label values  MC87301   M146601Q
label values  M0873A1   YESNO
label values  M157901   MC5D
label values  M159501   MC5C
label values  M161701   MC5D
label values  M161201   RATE3B
label values  MG61201   RATE3B
label values  MH61201   RATE3B
label values  M154401   MC5B
label values  M155401   MC5C
label values  M158701   MC5C
label values  M155501   MC5B
label values  M162001   RATE3B
label values  M1620R1   MC5C
label values  MG62001   RATE3B
label values  MG620R1   MC5C
label values  MH62001   RATE3B
label values  MH620R1   MC5C
label values  M155301   MC5A
label values  M160301   MC5C
label values  M157602   YESNO
label values  M157601   RATE3B
label values  M1576R1   MC5D
label values  MG57601   RATE3B
label values  MG576R1   MC5D
label values  MH57601   RATE3B
label values  MH576R1   MC5D
label values  M154701   MC5A
label values  M159301   MC5D
label values  M160902   MC5A
label values  M160901   RATE3B
label values  M1609R1   MC5D
label values  MG60901   RATE3B
label values  MG609R1   MC5D
label values  MH60901   RATE3B
label values  MH609R1   MC5D
label values  M155102   YESNO
label values  M155103   YESNO
label values  M155104   YESNO
label values  M155101   M155101Q
label values  MG55101   M155101Q
label values  MH55101   M155101Q
label values  M137201   MC5A
label values  M137301   MC5B
label values  M137401   MC5D
label values  M137501   M136501Q
label values  MG37501   RATE2D
label values  MH37501   RATE2D
label values  M137601   MC5D
label values  M137701   MC5B
label values  M137801   MC5D
label values  M137901   MC5C
label values  M138001   MC5B
label values  M138101   MC5B
label values  M138201   M136501Q
label values  MG38201   M136501Q
label values  MH38201   M136501Q
label values  M138301   MC5B
label values  M138401   M136901Q
label values  M1384R1   MC5C
label values  MG38401   M136901Q
label values  MG384R1   MC5C
label values  MH38401   M136901Q
label values  MH384R1   MC5C
label values  M138501   MC5A
label values  M138601   MC5A
label values  M138701   M138701Q
label values  MG38701   MG38701Q
label values  MH38701   MG38701Q
label values  M158001   MC5B
label values  M156301   MC5D
label values  M161101   MC5B
label values  M156101   RATE3B
label values  M1561R1   MC5D
label values  MG56101   RATE3B
label values  MG561R1   MC5D
label values  MH56101   RATE3B
label values  MH561R1   MC5D
label values  M156601   MC5C
label values  M161602   MC5C
label values  M161601   RATE3B
label values  M1616R1   MC5C
label values  MG61601   RATE3B
label values  MG616R1   MC5C
label values  MH61601   RATE3B
label values  MH616R1   MC5C
label values  M158301   MC5B
label values  M159701   MC5C
label values  M156201   MC5B
label values  M155201   MC5A
label values  M161901   RATE3B
label values  M1619R1   MC5D
label values  MG61901   RATE3B
label values  MG619R1   MC5D
label values  MH61901   RATE3B
label values  MH619R1   MC5D
label values  M154901   MC5D
label values  M157501   RATE3B
label values  MG57501   RATE3B
label values  MH57501   RATE3B
label values  M162301   MC5B
label values  M162202   YESNO
label values  M162201   RATE3B
label values  M1622R1   MC5D
label values  MG62201   RATE3B
label values  MG622R1   MC5D
label values  MH62201   RATE3B
label values  MH622R1   MC5D
label values  M161001   RATE2D
label values  MG61001   RATE2D
label values  MH61001   RATE2D
label values  M161002   RATE3B
label values  M1610R2   MC5C
label values  MG61002   RATE3B
label values  MG610R2   MC5C
label values  MH61002   RATE3B
label values  MH610R2   MC5C
label values  M1610CL   M155101Q
label values  M148201   MC5C
label values  M148301   MC5C
label values  M148401   MC5C
label values  M148501   RATE3B
label values  M1485R1   MC5D
label values  MG48501   RATE3B
label values  MG485R1   MC5D
label values  MH48501   RATE3B
label values  MH485R1   MC5D
label values  M148601   MC5A
label values  M148701   MC5D
label values  M148801   MC5B
label values  M148901   MC5C
label values  M149001   MC5C
label values  M149101   MC5B
label values  M149201   RATE3B
label values  M1492R1   MC5C
label values  MG49201   RATE3B
label values  MG492R1   MC5C
label values  MH49201   RATE3B
label values  MH492R1   MC5C
label values  M149301   RATE2D
label values  MG49301   RATE2D
label values  MH49301   RATE2D
label values  M149401   MC5B
label values  M149501   MC5C
label values  M149601   MC5C
label values  M149701   M146601Q
label values  MG49701   M146601Q
label values  MH49701   M146601Q
label values  XS03901   XS03901Q
label values  XS04001   XS04001Q
label values  XS04101   XS04101Q
label values  XS02301   NOYES
label values  XS02302   NOYES
label values  XS02303   NOYES
label values  XS02304   NOYES
label values  XS02305   NOYES
label values  XS02306   NOYES
label values  XS02307   NOYES
label values  XS02308   NOYES
label values  XS02309   NOYES
label values  XS02310   NOYES
label values  XS02311   NOYES
label values  XS02312   NOYES
label values  XS02313   NOYES
label values  XS02314   NOYES
label values  XS02315   NOYES
label values  XS02316   NOYES
label values  XS02317   NOYES
label values  XS02318   NOYES
label values  XS02319   NOYES
label values  XS02320   NOYES
label values  XS02321   NOYES
label values  XS02322   NOYES
label values  XS02323   NOYES
label values  XS02324   NOYES
label values  XS02325   NOYES
label values  XS02326   NOYES
label values  XS02327   NOYES
label values  XS02328   NOYES
label values  XS04301   XS04301Q
label values  XS04401   YESNO
label values  XS00301   NOYES
label values  XS00302   NOYES
label values  XS00303   NOYES
label values  XS00304   NOYES
label values  XS00305   NOYES
label values  XS00306   NOYES
label values  XS00307   NOYES
label values  XS00308   NOYES
label values  XS00309   NOYES
label values  XS00310   NOYES
label values  XS00311   NOYES
label values  XS00312   NOYES
label values  XS02701   XS02701Q
label values  XS04601   XS04601Q
label values  XL02901   XL02901Q
label values  X013801   X013801Q
label values  XL03001   XS04001Q
label values  XL03101   XL03101Q
label values  XL02001   NOYES
label values  XL02002   NOYES
label values  XL02003   NOYES
label values  XL02004   NOYES
label values  XL02005   NOYES
label values  XL02006   NOYES
label values  XL02007   NOYES
label values  XL02008   NOYES
label values  XL02009   NOYES
label values  XL02010   NOYES
label values  XL02011   NOYES
label values  XL02012   NOYES
label values  XL02013   NOYES
label values  XL02014   NOYES
label values  XL02015   NOYES
label values  XL02016   NOYES
label values  XL03301   XS04301Q
label values  XL03401   YESNO
label values  XL00601   XL00601Q
label values  XL03601   XS04601Q
label values  XL02401   XL02401Q
label values  XL02402   XL02401Q
label values  XL02403   XL02401Q
label values  XL02404   XL02401Q
label values  TA21101   NOYES
label values  TB21101   NOYES
label values  TC21101   NOYES
label values  TD21101   NOYES
label values  TE21101   NOYES
label values  TA21201   NOYES
label values  TB21201   NOYES
label values  TC21201   NOYES
label values  TD21201   NOYES
label values  TE21201   NOYES
label values  T096401   YESNO
label values  T096501   T096501Q
label values  T087201   YESNO
label values  T096601   T096601Q
label values  T096701   T096701Q
label values  T056301   T056301Q
label values  T077309   MAJORA
label values  T077310   MAJORA
label values  T087301   MAJORA
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T087302   MAJORA
label values  T087303   MAJORA
label values  T087304   MAJORA
label values  T096801   MAJORA
label values  T087305   MAJORA
label values  T087306   MAJORA
label values  T077312   MAJORA
label values  T077409   MAJORA
label values  T077410   MAJORA
label values  T077411   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T087401   MAJORA
label values  T087402   MAJORA
label values  T087403   MAJORA
label values  T096901   MAJORA
label values  T087404   MAJORA
label values  T087405   MAJORA
label values  T077412   MAJORA
label values  T097001   T097001Q
label values  T097101   T097001Q
label values  T087701   FREQ4D
label values  T087702   FREQ4D
label values  T087703   FREQ4D
label values  T087704   FREQ4D
label values  T087705   FREQ4D
label values  T087706   FREQ4D
label values  T087707   FREQ4D
label values  T087708   FREQ4D
label values  T087709   FREQ4D
label values  T087710   FREQ4D
label values  T087711   FREQ4D
label values  T087712   FREQ4D
label values  T097201   FREQ4D
label values  T097202   FREQ4D
label values  T097203   FREQ4D
label values  T097204   FREQ4D
label values  T097205   FREQ4D
label values  T097206   FREQ4D
label values  T097207   FREQ4D
label values  T097301   FREQ4D
label values  T097302   FREQ4D
label values  T097303   FREQ4D
label values  T097304   FREQ4D
label values  T097305   FREQ4D
label values  T097306   FREQ4D
label values  T097307   FREQ4D
label values  T097308   FREQ4D
label values  T097309   FREQ4D
label values  T097310   FREQ4D
label values  T097311   FREQ4D
label values  T087801   NOYES
label values  T087802   NOYES
label values  T087803   NOYES
label values  T087804   NOYES
label values  T087805   NOYES
label values  T087806   NOYES
label values  T087807   NOYES
label values  T087808   NOYES
label values  T087809   NOYES
label values  T087810   NOYES
label values  T087811   NOYES
label values  T087812   NOYES
label values  T087813   NOYES
label values  T087814   NOYES
label values  T087815   NOYES
label values  T087816   NOYES
label values  T087817   NOYES
label values  T087818   NOYES
label values  T087819   NOYES
label values  T087820   NOYES
label values  T087821   NOYES
label values  T087822   NOYES
label values  T087823   NOYES
label values  T087824   NOYES
label values  T087825   NOYES
label values  T087826   NOYES
label values  T087827   NOYES
label values  T087828   NOYES
label values  T087829   NOYES
label values  T087830   NOYES
label values  T087831   NOYES
label values  T087832   NOYES
label values  T087833   NOYES
label values  T087834   NOYES
label values  T087835   NOYES
label values  T087836   NOYES
label values  T087837   NOYES
label values  T087838   NOYES
label values  T087839   NOYES
label values  T087840   NOYES
label values  T087841   NOYES
label values  T087842   NOYES
label values  T087843   NOYES
label values  T087844   NOYES
label values  T087845   NOYES
label values  T087846   NOYES
label values  T087847   NOYES
label values  T087848   NOYES
label values  T097401   YESNO
label values  T097501   T097501Q
label values  T097502   T097501Q
label values  T097503   T097501Q
label values  T097504   T097501Q
label values  T097505   T097501Q
label values  T088201   YESNO
label values  T088202   YESNO
label values  T097601   YESNO
label values  T097701   YESNO
label values  T100601   T100601Q
label values  T117001   T117001Q
label values  T088001   T088001Q
label values  T044002   YESNO
label values  T044201   YESNO
label values  T057401   FREQ4F
label values  T057402   FREQ4F
label values  T057403   FREQ4F
label values  T057404   FREQ4F
label values  T044401   T044401Q
label values  T089201   T089201Q
label values  T089301   T089301Q
label values  T089601   M815301Q
label values  T106501   T106501Q
label values  T106502   T106501Q
label values  T106503   T106501Q
label values  T106504   T106501Q
label values  T075351   EMPHASA
label values  T075352   EMPHASA
label values  T075353   EMPHASA
label values  T075354   EMPHASA
label values  T075355   EMPHASA
label values  T088301   T088301Q
label values  T106601   T106501Q
label values  T106602   T106501Q
label values  T106603   T106501Q
label values  T106604   T106604Q
label values  T106605   T106604Q
label values  T106606   T106501Q
label values  T106607   T106604Q
label values  T106608   T106604Q
label values  T106609   T106501Q
label values  T106610   T106501Q
label values  T106611   T106604Q
label values  T106612   T106604Q
label values  T106613   T106604Q
label values  T106701   T106701Q
label values  T106801   FREQ4D
label values  T106802   FREQ4D
label values  T106803   FREQ4D
label values  T106804   FREQ4D
label values  T106805   FREQ4D
label values  T106901   T106901Q
label values  T107001   T107001Q
label values  T107002   T107001Q
label values  T107003   T107001Q
label values  T107004   T107001Q
/*---------------------------------------------------------------------*/
/*                        MISSING VALUES                               */
/*---------------------------------------------------------------------*/
/*   The following set of "mvdecode" statements are provides to allow  */
/*   the designation of all non-standard response data codes as        */
/*   missing values for the purpose of analysis.  The assignment of    */
/*   missing value codes to these response conditions are as follows:  */
/*      .m = Multiple responses to multiple choice questions           */
/*      .n = Questions at the end of timed sections that are not       */
/*           reached by the student                                    */
/*      .o = Questions that are omitted or otherwise left unresponded  */
/*      .p = "I don't know" responses where the option was provided    */
/*      .q = Open-ended responses that were not rateable for reasons   */
/*           other than specified below                                */
/*      .r = Open-ended responses that were illegible                  */
/*      .s = Open-ended responses that were off task                   */
/*   The double slashes at the beginning of each record within each    */
/*   "mvdecode" statement block suppresses the assignments by default. */
/*   The user may delete the double slashes from any or all blocks to  */
/*   activate these assignments.                                       */
/*---------------------------------------------------------------------*/
// /* MULTIPLE RESPONSES              */
// mvdecode M145901 MG45901 MH45901 M146101 MG46101 MH46101 M146301 MG46301 /*
//       */ MH46301 M146401 - MH46401 M146601 - MH46601 M146801 - MH46801 /*
//       */ M146901 - MH46901 M147001 - MH47001 M148101 - MH48101 /*
//       */ M085701 - MC85701 M085901 - MC85901 M085401 - MC85401 /*
//       */ M019701 - MC19701 M020001 - MC20001 M066501 - MC66501 /*
//       */ M066301 - MC66301 M067901 - MC67901 M136501 - MH36501 /*
//       */ M136601 - MH36601 M136901 MG36901 MH36901 M156701 - MH56701 /*
//       */ M157301 - MH57301 M157001 MG57001 MH57001 M160701 MG60701 MH60701 /*
//       */ M162401 MG62401 MH62401 M159401 MG59401 MH59401 M010631 - MC10631 /*
//       */ M087001 - MC87001 M040001 - MC40001 M091201 - MC91201 /*
//       */ M072401 - MC72401 M087301 - MC87301 M161201 - MH61201 M162001 /*
//       */ MG62001 MH62001 M157601 MG57601 MH57601 M160901 MG60901 MH60901 /*
//       */ M155101 - MH55101 M137501 - MH37501 M138201 - MH38201 M138401 /*
//       */ MG38401 MH38401 M138701 - MH38701 M156101 MG56101 MH56101 M161601 /*
//       */ MG61601 MH61601 M161901 MG61901 MH61901 M157501 - MH57501 M162201 /*
//       */ MG62201 MH62201 M161001 - MH61001 M161002 MG61002 MH61002 M1610CL /*
//       */ M148501 MG48501 MH48501 M149201 MG49201 MH49201 M149301 - MH49301 /*
//       */ M149701 - MH49701,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M145901 MG45901 MH45901 M146101 MG46101 MH46101 M146301 MG46301 /*
//       */ MH46301 M146401 - MH46401 M146801 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M148101 - MH48101 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136901 MG36901 MH36901 /*
//       */ M156701 - MH56701 M157301 - MH57301 M157001 MG57001 MH57001 M160701 /*
//       */ MG60701 MH60701 M162401 MG62401 MH62401 M159401 MG59401 MH59401 /*
//       */ M010631 - MC10631 M087001 - MC87001 M040001 - MC40001 /*
//       */ M091201 - MC91201 M072401 - MC72401 M161201 - MH61201 M162001 /*
//       */ MG62001 MH62001 M157601 MG57601 MH57601 M160901 MG60901 MH60901 /*
//       */ M137501 - MH37501 M138201 - MH38201 M138401 MG38401 MH38401 M156101 /*
//       */ MG56101 MH56101 M161601 MG61601 MH61601 M161901 MG61901 MH61901 /*
//       */ M157501 - MH57501 M162201 MG62201 MH62201 M161001 - MH61001 M161002 /*
//       */ MG61002 MH61002 M148501 MG48501 MH48501 M149201 MG49201 MH49201 /*
//       */ M149301 - MH49301,  mv( 9=.n)
// mvdecode M146601 - MH46601 M085401 - MC85401 M087301 - MC87301 /*
//       */ M155101 - MH55101 M138701 - MH38701 M1610CL M149701 - MH49701,  /*
//       */ mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode B017001 B000905  B017201 XS04601 XL00601 - XL02404,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode M145901 MG45901 MH45901 M146101 MG46101 MH46101 M146301 MG46301 /*
//       */ MH46301 M146401 - MH46401 M146801 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M148101 - MH48101 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136901 MG36901 MH36901 /*
//       */ M156701 - MH56701 M157301 - MH57301 M157001 MG57001 MH57001 M160701 /*
//       */ MG60701 MH60701 M162401 MG62401 MH62401 M159401 MG59401 MH59401 /*
//       */ M010631 - MC10631 M087001 - MC87001 M040001 - MC40001 /*
//       */ M091201 - MC91201 M072401 - MC72401 M161201 - MH61201 M162001 /*
//       */ MG62001 MH62001 M157601 MG57601 MH57601 M160901 MG60901 MH60901 /*
//       */ M137501 - MH37501 M138201 - MH38201 M138401 MG38401 MH38401 M156101 /*
//       */ MG56101 MH56101 M161601 MG61601 MH61601 M161901 MG61901 MH61901 /*
//       */ M157501 - MH57501 M162201 MG62201 MH62201 M161001 - MH61001 M161002 /*
//       */ MG61002 MH61002 M148501 MG48501 MH48501 M149201 MG49201 MH49201 /*
//       */ M149301 - MH49301,  mv( 7=.p)
// mvdecode M146601 - MH46601 M085401 - MC85401 M087301 - MC87301 /*
//       */ M155101 - MH55101 M138701 - MH38701 M1610CL M149701 - MH49701,  /*
//       */ mv(77=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode SD4 ELL3  UTOL4 HISPYES DRACEM  SENROL4 - PCTINDC LEP - SD3 IEP2009 /*
//       */ BA21101 - M145901 MG45901 MH45901 M146001 M146101  MG46101 MH46101 /*
//       */ M146201 M146301  MG46301 MH46301 M146401 - MH46401 M146501 /*
//       */ M146701 - MH46801 M146901 - MH46901 M147001 - MH47001 /*
//       */ M147101 - MH48101 M085201 - MC85701 M085901 - MC85901 M085601 /*
//       */ M019701 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M135601 - MH36501 /*
//       */ M136601 - MH36601 M136701 - M136901 MG36901 MH36901 /*
//       */ M137001 - MH56701 M1567A1 - MH57301 M1573A1 M157001  MG57001 /*
//       */ MH57001 M1570A1 - M160701 MG60701 MH60701 M1607A1 - M162401 MG62401 /*
//       */ MH62401 M1624A1 - M159401 MG59401 MH59401 M1594A1 - MC10631 /*
//       */ M0106A1 - MC87001 M0870A1 - MC40001 M0400A1 - MC91201 /*
//       */ M0912A1 - MC72401 M0724A1 - M0913A1 M0873A1 - MH61201 /*
//       */ M154401 - M162001 MG62001 MH62001 M155301 - M157601 MG57601 MH57601 /*
//       */ M154701 - M160901 MG60901 MH60901 M155102 - M155104 /*
//       */ M137201 - MH37501 M137601 - MH38201 M138301 M138401  MG38401 /*
//       */ MH38401 M138501 M138601  M158001 - M156101 MG56101 MH56101 /*
//       */ M156601 - M161601 MG61601 MH61601 M158301 - M161901 MG61901 MH61901 /*
//       */ M154901 - MH57501 M162301 - M162201 MG62201 MH62201 /*
//       */ M161001 - MH61001 M161002 MG61002 MH61002 M148201 - M148501 MG48501 /*
//       */ MH48501 M148601 - M149201 MG49201 MH49201 M149301 - MH49301 /*
//       */ M149401 - M149601 XS03901 - XS02328 XS04301 XS04401  /*
//       */ XS00301 - XS00312 XS02701 XS04601  XL02901 X013801  /*
//       */ XL03001 - XL02016 XL03301 XL03401  XL00601 - TE21201 /*
//       */ T096401 - T107004,  mv( 7=.q)
// mvdecode UTOL12 M146601 - MH46601 M085401 - MC85401 M087301 - MC87301 /*
//       */ M155101 - MH55101 M138701 - MH38701 M1610CL M149701 - MH49701,  /*
//       */ mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M145201 - M145901 MG45901 MH45901 M146001 M146101  MG46101 MH46101 /*
//       */ M146201 M146301  MG46301 MH46301 M146401 - MH46401 M146501 /*
//       */ M146701 - MH46801 M146901 - MH46901 M147001 - MH47001 /*
//       */ M147101 - MH48101 M085201 - MC85701 M085901 - MC85901 M085601 /*
//       */ M019701 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M135601 - MH36501 /*
//       */ M136601 - MH36601 M136701 - M136901 MG36901 MH36901 /*
//       */ M137001 - MH56701 M1567A1 - MH57301 M1573A1 M157001  MG57001 /*
//       */ MH57001 M1570A1 - M160701 MG60701 MH60701 M1607A1 - M162401 MG62401 /*
//       */ MH62401 M1624A1 - M159401 MG59401 MH59401 M1594A1 - MC10631 /*
//       */ M0106A1 - MC87001 M0870A1 - MC40001 M0400A1 - MC91201 /*
//       */ M0912A1 - MC72401 M0724A1 - M0913A1 M0873A1 - MH61201 /*
//       */ M154401 - M162001 MG62001 MH62001 M155301 - M157601 MG57601 MH57601 /*
//       */ M154701 - M160901 MG60901 MH60901 M155102 - M155104 /*
//       */ M137201 - MH37501 M137601 - MH38201 M138301 M138401  MG38401 /*
//       */ MH38401 M138501 M138601  M158001 - M156101 MG56101 MH56101 /*
//       */ M156601 - M161601 MG61601 MH61601 M158301 - M161901 MG61901 MH61901 /*
//       */ M154901 - MH57501 M162301 - M162201 MG62201 MH62201 /*
//       */ M161001 - MH61001 M161002 MG61002 MH61002 M148201 - M148501 MG48501 /*
//       */ MH48501 M148601 - M149201 MG49201 MH49201 M149301 - MH49301 /*
//       */ M149401 - M149601,  mv( 5=.r)
// mvdecode M146601 - MH46601 M085401 - MC85401 M087301 - MC87301 /*
//       */ M155101 - MH55101 M138701 - MH38701 M1610CL M149701 - MH49701,  /*
//       */ mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode BA21101 - M145801 M146001 M146201 M146501 M146701 M147101 - M148001 /*
//       */ M085201 M085301  M085601 M046301 - M046501 M047101 /*
//       */ M135601 - M136501 M136601 M136701 - M136901 M137001 - M1700A1 /*
//       */ M1567A1 - M1586A1 M1573A1 M1570A1 - M1568A1 M1607A1 - M162402 /*
//       */ M1624A1 - M1577A1 M1594A1 - M0867A1 M0106A1 - M0909A1 /*
//       */ M0870A1 - M0398A1 M0400A1 - M0872A1 M0912A1 - M0660A1 /*
//       */ M0724A1 - M0913A1 M0873A1 - M161701 M154401 - M155501 /*
//       */ M155301 - M157602 M154701 - M160902 M155102 - M155104 /*
//       */ M137201 - M137501 M137601 - MH38201 M138301 M138401  MG38401 /*
//       */ MH38401 M138501 M138601  M158001 - M161101 M156601 M161602  /*
//       */ M158301 - M155201 M154901 M162301 M162202  M148201 - M148401 /*
//       */ M148601 - M149101 M149401 - M149601 XS03901 - XS04101 /*
//       */ XS04301 XS04401  XS02701 XS04601  XL02901 X013801  XL03001 XL03101  /*
//       */ XL03301 XL03401  XL00601 - XL02404 T096401 - T097311 /*
//       */ T097401 - T107004,  mv( 6=.s)
// mvdecode M138701 - MH38701,  mv(66=.s)
/*---------------------------------------------------------------------*/
/*                    SCORING THE ITEMS                                */
/*---------------------------------------------------------------------*/
/*   The following "recode" statements are provided to permit the      */
/*   replacement of all scorable item responses with their scored      */
/*   values.  The scoring rubric is consistent with the IRT item       */
/*   parameter estimation procedure used to generate the ability       */
/*   estimates.  All valid responses are recoded to their appropriate  */
/*   score values; all other codes are converted to the system missing */
/*   values as described above.                                        */
/*   The double slashes at the beginning of each record within each    */
/*   "recode" statement block suppresses the scoring by default.  The  */
/*   user may delete the double slashes from any or all blocks to      */
/*   activate these assignments.                                       */
/*---------------------------------------------------------------------*/
// recode M145201 M145501 M146001 M146201 M146701 M147701 M148001 /*
//     */ M085201 M085301 M047101 M135601 M136301 M137101 M154501 M157101 /*
//     */ M087201 M091301 M159501 M155401 M158701 M160301 M137901 M156601 /*
//     */ M159701 M148201 - M148401 M148901 M149001 M149501 M149601 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145301 M147301 M147901 M046501 M135701 M135901 M136201 M157201 /*
//     */ M160001 M010131 M039101 M086701 M072301 M066001 M155301 M154701 /*
//     */ M137201 M138501 M138601 M155201 M148601 (1=1) (2=0) (3=0) (4=0) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145401 M145701 M145801 M146501 M147101 M047001 M136101 M136401 /*
//     */ M136701 M137001 M170001 M160201 M156801 M157701 N214331 M010831 /*
//     */ M157901 M161701 M159301 M137401 M137601 M137801 M156301 M154901 /*
//     */ M148701 (1=0) (2=0) (3=0) (4=1) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145601 M147201 M147401 - M147601 M147801 M085601 M046301 M135801 /*
//     */ M136001 M136801 M158601 M010331 M086901 M090901 M039801 M154401 /*
//     */ M155501 M137301 M137701 M138001 M138101 M138301 M158001 M161101 /*
//     */ M158301 M156201 M162301 M148801 M149101 M149401 (1=0) (2=1) (3=0) /*
//     */ (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145901 M146301 M146401 M146901 M147001 M148101 M085701 M066501 /*
//     */ M066301 M067901 M157001 M160701 M162401 M087001 M091201 M072401 /*
//     */ M161201 M162001 M157601 M160901 M156101 M161601 M161901 M157501 /*
//     */ M162201 M148501 M149201 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) ( 7=.p) /*
//     */ ( 7=.q) ( 5=.r) (else=.)
// recode M146101 M146801 M019701 M020001 M156701 M157301 M149301 (1=0) (2=1) /*
//     */ ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode M146601 M087301 M155101 M1610CL M149701 (1=0) (2=1) (3=2) (4=3) (5=4) /*
//     */ ( 0=.m) (99=.n) (77=.p) (77=.q) (55=.r) (else=.)
// recode M085901 M010631 M040001 (1=0) (2=0) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) /*
//     */ ( 7=.q) ( 5=.r) (else=.)
// recode M085401 (1=0) (2=1) (3=2) (4=3) (5=3) ( 0=.m) (99=.n) (77=.p) (77=.q) /*
//     */ (55=.r) (else=.)
// recode M136501 M137501 M138201 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M136601 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M136901 M138401 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M159401 (1=0) (2=1) (3=2) (4=3) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode M138701 (1=0) (2=1) (3=2) (4=3) (5=4) ( 0=.m) (99=.n) (77=.p) (77=.q) /*
//     */ (55=.r) (66=.s) (else=.)
// label values  M145201   SCORE
// label values  M145301   SCORE
// label values  M145401   SCORE
// label values  M145501   SCORE
// label values  M145601   SCORE
// label values  M145701   SCORE
// label values  M145801   SCORE
// label values  M145901   SCORE
// label values  M146001   SCORE
// label values  M146101   SCORE
// label values  M146201   SCORE
// label values  M146301   SCORE
// label values  M146401   SCORE
// label values  M146501   SCORE
// label values  M146601   SCORE
// label values  M146701   SCORE
// label values  M146801   SCORE
// label values  M146901   SCORE
// label values  M147001   SCORE
// label values  M147101   SCORE
// label values  M147201   SCORE
// label values  M147301   SCORE
// label values  M147401   SCORE
// label values  M147501   SCORE
// label values  M147601   SCORE
// label values  M147701   SCORE
// label values  M147801   SCORE
// label values  M147901   SCORE
// label values  M148001   SCORE
// label values  M148101   SCORE
// label values  M085201   SCORE
// label values  M085301   SCORE
// label values  M085701   SCORE
// label values  M085901   SCORE
// label values  M085601   SCORE
// label values  M085401   SCORE
// label values  M019701   SCORE
// label values  M020001   SCORE
// label values  M046301   SCORE
// label values  M047001   SCORE
// label values  M046501   SCORE
// label values  M066501   SCORE
// label values  M047101   SCORE
// label values  M066301   SCORE
// label values  M067901   SCORE
// label values  M135601   SCORE
// label values  M135701   SCORE
// label values  M135801   SCORE
// label values  M135901   SCORE
// label values  M136001   SCORE
// label values  M136101   SCORE
// label values  M136201   SCORE
// label values  M136301   SCORE
// label values  M136401   SCORE
// label values  M136501   SCORE
// label values  M136601   SCORE
// label values  M136701   SCORE
// label values  M136801   SCORE
// label values  M136901   SCORE
// label values  M137001   SCORE
// label values  M137101   SCORE
// label values  M154501   SCORE
// label values  M170001   SCORE
// label values  M156701   SCORE
// label values  M157101   SCORE
// label values  M160201   SCORE
// label values  M158601   SCORE
// label values  M157301   SCORE
// label values  M157001   SCORE
// label values  M157201   SCORE
// label values  M156801   SCORE
// label values  M160701   SCORE
// label values  M160001   SCORE
// label values  M162401   SCORE
// label values  M157701   SCORE
// label values  M159401   SCORE
// label values  M010131   SCORE
// label values  N214331   SCORE
// label values  M039101   SCORE
// label values  M086701   SCORE
// label values  M010631   SCORE
// label values  M072301   SCORE
// label values  M010831   SCORE
// label values  M010331   SCORE
// label values  M086901   SCORE
// label values  M090901   SCORE
// label values  M087001   SCORE
// label values  M039801   SCORE
// label values  M040001   SCORE
// label values  M087201   SCORE
// label values  M091201   SCORE
// label values  M066001   SCORE
// label values  M072401   SCORE
// label values  M091301   SCORE
// label values  M087301   SCORE
// label values  M157901   SCORE
// label values  M159501   SCORE
// label values  M161701   SCORE
// label values  M161201   SCORE
// label values  M154401   SCORE
// label values  M155401   SCORE
// label values  M158701   SCORE
// label values  M155501   SCORE
// label values  M162001   SCORE
// label values  M155301   SCORE
// label values  M160301   SCORE
// label values  M157601   SCORE
// label values  M154701   SCORE
// label values  M159301   SCORE
// label values  M160901   SCORE
// label values  M155101   SCORE
// label values  M137201   SCORE
// label values  M137301   SCORE
// label values  M137401   SCORE
// label values  M137501   SCORE
// label values  M137601   SCORE
// label values  M137701   SCORE
// label values  M137801   SCORE
// label values  M137901   SCORE
// label values  M138001   SCORE
// label values  M138101   SCORE
// label values  M138201   SCORE
// label values  M138301   SCORE
// label values  M138401   SCORE
// label values  M138501   SCORE
// label values  M138601   SCORE
// label values  M138701   SCORE
// label values  M158001   SCORE
// label values  M156301   SCORE
// label values  M161101   SCORE
// label values  M156101   SCORE
// label values  M156601   SCORE
// label values  M161601   SCORE
// label values  M158301   SCORE
// label values  M159701   SCORE
// label values  M156201   SCORE
// label values  M155201   SCORE
// label values  M161901   SCORE
// label values  M154901   SCORE
// label values  M157501   SCORE
// label values  M162301   SCORE
// label values  M162201   SCORE
// label values  M1610CL   SCORE
// label values  M148201   SCORE
// label values  M148301   SCORE
// label values  M148401   SCORE
// label values  M148501   SCORE
// label values  M148601   SCORE
// label values  M148701   SCORE
// label values  M148801   SCORE
// label values  M148901   SCORE
// label values  M149001   SCORE
// label values  M149101   SCORE
// label values  M149201   SCORE
// label values  M149301   SCORE
// label values  M149401   SCORE
// label values  M149501   SCORE
// label values  M149601   SCORE
// label values  M149701   SCORE

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2009
gen grade=4
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2009\naep_math_gr4_2009", replace


