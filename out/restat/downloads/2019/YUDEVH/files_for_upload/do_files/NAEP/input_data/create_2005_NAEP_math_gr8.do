version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Math G8\stata\LABELDEF.do"
label data "  2005 National Mathematics Assessment: Grade  8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Math G8\stata\M36NT2AT.DCT", clear
label values  ORIGSUB   ORIGSUB
label values  PUBPRIV   PUBPRIV
label values  BMONTH    BMONTH
label values  SEX       SEX
label values  SRACE     SRACE
label values  TITLE1    YESNO
label values  IEP       YESNO
label values  ELL3      ELL3V
label values  SLNCH05   SLNCH05V
label values  SLUNCH1   SLUNCH1V
label values  NEWENRL   NEWENRL
label values  TCHMTCH   TCHMTCH
label values  COHORT    COHORT
label values  DISTCOD   DISTCOD
label values  DCPLS50   DCPLS50V
label values  PUBPRV3   PUBPRV3V
label values  OBOOKFL   OBOOKFL
label values  MOB       BMONTH
label values  MOBFLAG   OBOOKFL
label values  YOBFLAG   OBOOKFL
label values  DSEX      SEX
label values  SEXFLAG   OBOOKFL
label values  RACEFLG   OBOOKFL
label values  ORIGSUP   ORIGSUP
label values  REGION    REGION
label values  REGIONS   REGION
label values  CENSREG   CENSREG
label values  CENSDIV   CENSDIV
label values  MSAFLAG   MSAFLAG
label values  TOL9      TOL9V
label values  ABSSERT   ABSSERT
label values  JKUNIT    JKUNIT
label values  JKNU      JKUNIT
label values  SCHTY02   SCHTY02V
label values  SCHTYPE   SCHTYPE
label values  RPTSAMP   RPTSAMP
label values  ACCOM2    ACCOM2V
label values  ACCMTYP   ACCMTYP
label values  TOL7      TOL7V
label values  TOL5      TOL5V
label values  TOL3      TOL3V
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  FIPS      FIPS
label values  SAMPTYP   SAMPTYP
label values  CHRTRPT   CHRTRPT
label values  SDRACEM   SDRACEM
label values  SLUNCH    SLUNCH
label values  FIPSAI    FIPSAI
label values  SENROL8   SENROL8V
label values  YRSEXP    YRSEXP
label values  YRSMATH   YRSEXP
label values  PCTBLKC   PCTBLKC
label values  PCTHSPC   PCTBLKC
label values  PCTASNC   PCTBLKC
label values  PCTINDC   PCTBLKC
label values  LEP       YESNO
label values  LRGCITY   YESNO
label values  Y36OMC    BLKUSE
label values  Y36OMD    BLKUSE
label values  Y36OME    BLKUSE
label values  Y36OMF    BLKUSE
label values  Y36OMG    BLKUSE
label values  Y36OMH    BLKUSE
label values  Y36OMI    BLKUSE
label values  Y36OMJ    BLKUSE
label values  Y36OMK    BLKUSE
label values  Y36OML    BLKUSE
label values  PARED     PARED
label values  REGION5   REGION5V
label values  NIESFLG   NIESFLG
label values  SCHTYP2   PUBPRV3V
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
label values  B013801   B013801V
label values  B017101   YESNO
label values  B017201   YESNO
label values  B001151   B001151V
label values  B017451   B017451V
label values  B018101   B018101V
label values  B003501   B003501V
label values  B003601   B003501V
label values  B018201   B018201V
label values  M815701   M815701V
label values  M815801   M815801V
label values  M814301   M814301V
label values  M815901   M815901V
label values  M816001   M814301V
label values  M816101   M814301V
label values  M816201   M814301V
label values  M816301   M814301V
label values  M816401   M814301V
label values  M816501   M814301V
label values  M816601   M814301V
label values  M816701   M814301V
label values  M816801   M814301V
label values  M816901   M814301V
label values  M817001   M814301V
label values  M817101   M814301V
label values  M817201   M814301V
label values  M817301   M814301V
label values  M817401   M817401V
label values  M817501   M817401V
label values  M817601   M817401V
label values  M817701   M817701V
label values  M817801   M814301V
label values  M817901   M814301V
label values  M818001   M814301V
label values  M815301   M815301V
label values  M818101   YESNO
label values  M815401   M815401V
label values  M815501   M815501V
label values  M815601   M815601V
label values  M075201   MC5C
label values  M075401   RATE3B
label values  MB75401   RATE3B
label values  MC75401   RATE3B
label values  M075601   RATE3B
label values  MB75601   RATE3B
label values  MC75601   RATE3B
label values  M019901   M019901V
label values  MB19901   MB19901V
label values  MC19901   MC19901V
label values  M066201   MC5B
label values  M047301   M047301V
label values  MB47301   SCR4D
label values  MC47301   SCR4D
label values  M046201   MC5C
label values  M066401   MC5D
label values  M020101   RATE2D
label values  MB20101   RATE2D
label values  MC20101   RATE2D
label values  M067401   MC5A
label values  M086101   MC5C
label values  M047701   MC5B
label values  M067301   MC5D
label values  M048001   MC5E
label values  M093701   MC5E
label values  M086001   MC5B
label values  M051901   MC5D
label values  M076001   M076001V
label values  MB76001   RATE5A
label values  MC76001   RATE5A
label values  M046001   M046001V
label values  MB46001   SCR5E
label values  MC46001   SCR5E
label values  M046101   MC5B
label values  M067701   MC5A
label values  M046701   MC5C
label values  M046901   M046001V
label values  MB46901   SCR5E
label values  MC46901   SCR5E
label values  M047201   MC5B
label values  M046601   M047301V
label values  MB46601   SCR4D
label values  MC46601   SCR4D
label values  M046801   M046001V
label values  MB46801   SCR5E
label values  MC46801   SCR5E
label values  M067801   MC5C
label values  M066601   RATE3B
label values  MB66601   RATE3B
label values  MC66601   MC66601V
label values  M067202   MC5B
label values  M067201   RATE3B
label values  MB67201   RATE3B
label values  MC67201   MC66601V
label values  M068003   RATE3B
label values  MB68003   RATE3B
label values  MC68003   MC66601V
label values  M068005   RATE3B
label values  MB68005   RATE3B
label values  MC68005   MC66601V
label values  M068008   RATE3B
label values  MB68008   RATE3B
label values  MC68008   RATE3B
label values  M068007   MC5E
label values  M068006   RATE3B
label values  MB68006   RATE3B
label values  MC68006   RATE3B
label values  M093601   RATE3B
label values  MB93601   RATE3B
label values  MC93601   RATE3B
label values  M053001   RATE2D
label values  MB53001   MB53001V
label values  MC53001   MC19901V
label values  M047801   MC5D
label values  M086301   M076001V
label values  MB86301   RATE5A
label values  MC86301   RATE5A
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   RATE3B
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085501   MC5A
label values  M085801   MC5A
label values  M019701   RATE2E
label values  MB19701   RATE2D
label values  MC19701   RATE2D
label values  M020001   RATE2E
label values  MB20001   RATE2D
label values  MC20001   RATE2D
label values  M046301   MC5B
label values  M047001   MC5D
label values  M046501   MC5A
label values  M066501   RATE3B
label values  MB66501   RATE3B
label values  MC66501   MC66601V
label values  M047101   MC5C
label values  M066301   RATE3B
label values  MB66301   RATE3B
label values  MC66301   MC66601V
label values  M067901   RATE3B
label values  MB67901   RATE3B
label values  MC67901   MC66601V
label values  M019601   MC5C
label values  M051501   MC5A
label values  M047901   SCR3C
label values  MB47901   MB47901V
label values  MC47901   MC47901V
label values  M053101   M076001V
label values  MB53101   MB53101V
label values  MC53101   MC53101V
label values  M140401   MC5A
label values  M140501   MC5D
label values  M140601   MC5A
label values  M140701   MC5C
label values  M140801   MC5C
label values  M140901   MC5D
label values  M141001   MC5B
label values  M141101   MC5B
label values  M141201   MC5D
label values  M141301   M141301V
label values  MG41301   M141301V
label values  MH41301   M141301V
label values  M141401   MC5B
label values  M141501   MC5C
label values  M141601   RATE2D
label values  MG41601   RATE2D
label values  MH41601   RATE2D
label values  M141701   MC5E
label values  M141801   MC5B
label values  M141901   RATE5A
label values  MG41901   RATE5A
label values  MH41901   RATE5A
label values  M143601   MC5D
label values  M1436A1   YESNO
label values  M143701   MC5C
label values  M1437A1   YESNO
label values  M143801   MC5B
label values  M1438A1   YESNO
label values  M143901   MC5A
label values  M1439A1   YESNO
label values  M144001   MC5B
label values  M1440A1   YESNO
label values  M144101   MC5E
label values  M1441A1   YESNO
label values  M144201   RATE2D
label values  MG44201   RATE2D
label values  MH44201   RATE2D
label values  M1442A1   YESNO
label values  M144301   MC5E
label values  M1443A1   YESNO
label values  M144401   MC5D
label values  M1444A1   YESNO
label values  M144501   MC5C
label values  M1445A1   YESNO
label values  M144601   M144601V
label values  MG44601   M144601V
label values  MH44601   M144601V
label values  M1446A1   YESNO
label values  M144701   MC5C
label values  M1447A1   YESNO
label values  M144801   MC5A
label values  M1448A1   YESNO
label values  M144901   M141301V
label values  MG44901   M141301V
label values  MH44901   M141301V
label values  M1449A1   YESNO
label values  M145001   MC5B
label values  M1450A1   YESNO
label values  M145101   M141301V
label values  MG45101   M141301V
label values  MH45101   M141301V
label values  M1451A1   YESNO
label values  M012231   MC5D
label values  M0122A1   YESNO
label values  M013331   MC5E
label values  M0133A1   YESNO
label values  M073001   MC5E
label values  M0730A1   YESNO
label values  M073201   MC5B
label values  M073202   MC5A
label values  M073203   MC5B
label values  M073204   MC5A
label values  M0732CL   M0732CL
label values  M0732A1   YESNO
label values  M073101   MC5A
label values  M0731A1   YESNO
label values  M073301   MC5C
label values  M0733A1   YESNO
label values  M021001   RATE2E
label values  MB21001   RATE2D
label values  MC21001   RATE2D
label values  M0210A1   YESNO
label values  M092201   MC5B
label values  M0922A1   YESNO
label values  M020901   RATE2E
label values  MB20901   RATE2D
label values  MC20901   RATE2D
label values  M0209A1   YESNO
label values  M052501   MC5B
label values  M0525A1   YESNO
label values  M092401   RATE3B
label values  MB92401   RATE3B
label values  MC92401   RATE3B
label values  M0924A1   YESNO
label values  M019201   MC5C
label values  M0192A1   YESNO
label values  M092601   RATE3B
label values  MB92601   RATE3B
label values  MC92601   RATE3B
label values  M0926A1   YESNO
label values  M012431   MC5A
label values  M0124A1   YESNO
label values  M091901   MC5C
label values  M0919A1   YESNO
label values  M067001   MC5C
label values  M0670A1   YESNO
label values  M051701   MC5D
label values  M0517A1   YESNO
label values  M052801   MC5A
label values  M0528A1   YESNO
label values  M073602   MC5B
label values  M073601   M073601V
label values  MB73601   M073601V
label values  MC73601   M073601V
label values  M0736A1   YESNO
label values  M013431   MC5C
label values  M0134A1   YESNO
label values  M075701   MC5A
label values  M075702   MC5A
label values  M075703   MC5B
label values  M0757A1   YESNO
label values  M0757CL   M0757CL
label values  M013131   RATE2E
label values  MB13131   RATE2D
label values  MC13131   RATE2D
label values  M0131A1   YESNO
label values  M091701   MC5A
label values  M0917A1   YESNO
label values  M072801   MC5B
label values  M0728A1   YESNO
label values  M091501   MC5D
label values  M0915A1   YESNO
label values  M091601   MC5D
label values  M0916A1   YESNO
label values  M073501   RATE3B
label values  MB73501   RATE3B
label values  MC73501   RATE3B
label values  M0735A1   YESNO
label values  MA52421   MA52421V
label values  M052401   RATE2D
label values  MB52401   RATE2D
label values  MC52401   RATE2D
label values  M0524A1   YESNO
label values  M075301   RATE3B
label values  MB75301   RATE3B
label values  MC75301   RATE3B
label values  M0753A1   YESNO
label values  M072901   RATE3B
label values  MB72901   RATE3B
label values  MC72901   RATE3B
label values  M0729A1   YESNO
label values  M013631   MC5A
label values  M0136A1   YESNO
label values  M075801   RATE3B
label values  MB75801   RATE3B
label values  MC75801   RATE3B
label values  M0758A1   YESNO
label values  M013731   MC5D
label values  M0137A1   YESNO
label values  M013531   MC5E
label values  M0135A1   YESNO
label values  M051801   MC5B
label values  M0518A1   YESNO
label values  M093401   MC5A
label values  M0934A1   YESNO
label values  M093801   RATE5A
label values  MB93801   RATE5A
label values  MC93801   RATE5A
label values  M0938A1   YESNO
label values  M142001   MC5E
label values  M142101   MC5A
label values  M142201   MC5C
label values  M142301   MC5E
label values  M142401   MC5B
label values  M142501   MC5C
label values  M142601   MC5D
label values  M142701   MC5E
label values  M142801   RATE2D
label values  MG42801   RATE2D
label values  MH42801   RATE2D
label values  M142901   MC5B
label values  M143001   MC5C
label values  M143101   MC5D
label values  M143201   RATE2D
label values  MG43201   RATE2D
label values  MH43201   RATE2D
label values  M143301   MC5D
label values  M143401   MC5A
label values  M143501   M143501V
label values  MG43501   M143501V
label values  MH43501   M143501V
label values  M105601   MC5D
label values  M105801   MC5D
label values  M105901   MC5B
label values  M106001   MC5B
label values  M106101   MC5D
label values  M106201   MC5C
label values  M106301   RATE2D
label values  MG06301   RATE2D
label values  MH06301   RATE2D
label values  M106401   MC5A
label values  M106501   MC5B
label values  M106601   MC5C
label values  M106701   MC5A
label values  M106801   MC5A
label values  M106901   RATE2D
label values  MG06901   RATE2D
label values  MH06901   RATE2D
label values  M107001   MC5A
label values  M107101   MC5D
label values  M107201   MC5C
label values  M107401   MC5C
label values  M107501   RATE2D
label values  MG07501   RATE2D
label values  MH07501   RATE2D
label values  M107601   MC5E
label values  M109801   MC5B
label values  M110001   MC5C
label values  M110101   MC5D
label values  M110201   RATE2D
label values  MG10201   RATE2D
label values  MH10201   RATE2D
label values  M110301   MC5C
label values  M110401   MC5B
label values  M110501   RATE3B
label values  MG10501   RATE3C
label values  MH10501   RATE3C
label values  M110601   MC5B
label values  M110701   MC5C
label values  M110801   MC5A
label values  M110901   MC5D
label values  M111001   MC5C
label values  M111201   MC5C
label values  M111301   MC5B
label values  M111401   MC5C
label values  M111501   MC5E
label values  M111601   MC5C
label values  M111801   RATE3B
label values  MG11801   RATE3B
label values  MH11801   RATE3B
label values  TA21101   YESNO
label values  TB21101   YESNO
label values  TC21101   YESNO
label values  TD21101   YESNO
label values  TE21101   YESNO
label values  TA21201   YESNO
label values  TB21201   YESNO
label values  TC21201   YESNO
label values  TD21201   YESNO
label values  TE21201   YESNO
label values  T077201   T077201Q
label values  T087201   YESNO
label values  T056301   T056301Q
label values  T077309   MAJORA
label values  T077310   MAJORA
label values  T087301   MAJORA
label values  T086801   MAJORA
label values  T077409   MAJORA
label values  T077410   MAJORA
label values  T077411   MAJORA
label values  T086901   MAJORA
label values  T087501   T087501Q
label values  T087601   T087501Q
label values  T087101   YESNO
label values  T087102   YESNO
label values  T087103   YESNO
label values  T087104   YESNO
label values  T087105   YESNO
label values  T087106   YESNO
label values  T087107   YESNO
label values  T087108   YESNO
label values  T087109   YESNO
label values  T087110   YESNO
label values  T087111   YESNO
label values  T087112   YESNO
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
label values  T090801   YESNO
label values  T090802   YESNO
label values  T090803   YESNO
label values  T090804   YESNO
label values  T090805   YESNO
label values  T090806   YESNO
label values  T086301   YESNO
label values  T087901   YESNO
label values  T087902   YESNO
label values  T088001   T088001Q
label values  T088301   T088301Q
label values  T088401   T088401Q
label values  T088501   T088501Q
label values  T088601   T088601Q
label values  T088602   T088601Q
label values  T088603   T088601Q
label values  T090901   T090901Q
label values  T090902   T090901Q
label values  T090903   T090901Q
label values  T090904   T090901Q
label values  T090905   T090901Q
label values  T090906   T090901Q
label values  T090907   T090901Q
label values  T090908   T090901Q
label values  T090909   T090901Q
label values  T090910   T090901Q
label values  T090911   T090901Q
label values  T091001   T090901Q
label values  T091002   T090901Q
label values  T091003   T090901Q
label values  T091004   T090901Q
label values  T091005   T090901Q
label values  T091006   T090901Q
label values  T091007   T090901Q
label values  T091008   T090901Q
label values  T091009   T090901Q
label values  T091010   T090901Q
label values  T091011   T090901Q
label values  T088801   T090901Q
label values  T088802   T090901Q
label values  T088803   T090901Q
label values  T088804   T090901Q
label values  T088805   T090901Q
label values  T088901   YESNO
label values  T089001   YESNO
label values  T089101   YESNO
label values  T091101   T091101Q
label values  T091102   T091102Q
label values  T089401   T089401Q
label values  T091201   T090901Q
label values  T091202   T090901Q
label values  T091203   T090901Q
label values  T091204   T090901Q
label values  T091301   T090901Q
label values  T091302   T090901Q
label values  T091303   T090901Q
label values  T091304   T090901Q
label values  T091401   M815301V
label values  T091402   T091402Q
label values  T091501   T090901Q
label values  T091502   T090901Q
label values  T091503   T090901Q
label values  T091504   T090901Q
label values  XS00101   NOYES
label values  XS00102   NOYES
label values  XS00103   NOYES
label values  XS00104   NOYES
label values  XS00105   NOYES
label values  XS00106   NOYES
label values  XS00201   XS00201V
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
label values  X012201   X012201Q
label values  XS00501   YESNO
label values  XS00601   YESNO
label values  XS00701   XS00701V
label values  XS00801   NOYES
label values  XS00802   NOYES
label values  XS00803   NOYES
label values  XS00804   NOYES
label values  XS00805   NOYES
label values  XS00806   NOYES
label values  XS00807   NOYES
label values  XS00808   NOYES
label values  XS00809   NOYES
label values  XS00810   NOYES
label values  XS00811   NOYES
label values  XS00812   NOYES
label values  XS00901   XS00901V
label values  XS01001   XS01001V
label values  XS01101   XS01101V
label values  XS01201   XS01201V
label values  XS01301   NOYES
label values  XS01302   NOYES
label values  XS01303   NOYES
label values  XS01304   NOYES
label values  XS01305   NOYES
label values  XS01306   NOYES
label values  XS01307   NOYES
label values  XS01308   NOYES
label values  XS01309   NOYES
label values  XS01310   NOYES
label values  XS01311   NOYES
label values  XS01401   NOYES
label values  XS01402   NOYES
label values  XS01403   NOYES
label values  XS01404   NOYES
label values  XS01405   NOYES
label values  XS01406   NOYES
label values  XS01407   NOYES
label values  XS01408   NOYES
label values  XS01409   NOYES
label values  XS01410   NOYES
label values  XS01411   NOYES
label values  XS01412   NOYES
label values  XS01413   NOYES
label values  XS01501   NOYES
label values  XS01502   NOYES
label values  XS01503   NOYES
label values  XS01504   NOYES
label values  XS01505   NOYES
label values  XS01506   NOYES
label values  XS01507   NOYES
label values  XS01508   NOYES
label values  XS01601   NOYES
label values  XS01602   NOYES
label values  XS01603   NOYES
label values  XS01604   NOYES
label values  XS01605   NOYES
label values  XS01701   XS01701V
label values  XL00101   NOYES
label values  XL00102   NOYES
label values  XL00103   NOYES
label values  XL00104   NOYES
label values  XL00105   NOYES
label values  XL00106   NOYES
label values  X013801   X013801Q
label values  XL00201   XL00201V
label values  XL00301   XL00201V
label values  XL00401   XL00201V
label values  XL00501   XL00201V
label values  XL00601   XL00601V
label values  XL00701   XS00901V
label values  XL00801   XS01001V
label values  XL00901   XL00901V
label values  XL01001   XL01001V
label values  XL01101   XL01101V
label values  XL01201   NOYES
label values  XL01202   NOYES
label values  XL01203   NOYES
label values  XL01204   NOYES
label values  XL01205   NOYES
label values  XL01206   NOYES
label values  XL01207   NOYES
label values  XL01208   NOYES
label values  XL01209   NOYES
label values  XL01210   NOYES
label values  XL01211   NOYES
label values  XL01301   NOYES
label values  XL01302   NOYES
label values  XL01303   NOYES
label values  XL01304   NOYES
label values  XL01305   NOYES
label values  XL01306   NOYES
label values  XL01401   XL01401V
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
// mvdecode PARED BA21101 - M075201 M066201 M046201 M066401  M067401 - M051901 /*
//       */ M046101 - M046701 M047201 M067801 M067202 M068007 M047801 /*
//       */ M085601 - M085801 M046301 - M046501 M047101 M019601 M051501  /*
//       */ M140401 - M141201 M141401 M141501  M141701 M141801  /*
//       */ M143601 - M1441A1 M1442A1 - M1445A1 M1446A1 - M1448A1 /*
//       */ M1449A1 - M1450A1 M1451A1 - M073204 M0732A1 - M0733A1 /*
//       */ M0210A1 - M0922A1 M0209A1 - M0525A1 M0924A1 - M0192A1 /*
//       */ M0926A1 - M073602 M0736A1 - M0757A1 M0131A1 - M0916A1 /*
//       */ M0735A1 MA52421  M0524A1 M0753A1 M0729A1 - M0136A1 /*
//       */ M0758A1 - M0934A1 M0938A1 - M142701 M142901 - M143101 /*
//       */ M143301 M143401  M105601 - M106201 M106401 - M106801 /*
//       */ M107001 - M107401 M107601 - M110101 M110301 M110401  /*
//       */ M110601 - M111601 TA21101 - TE21201 T077201 - T091504 XS00201 /*
//       */ X012201 - XS00701 XS00901 - XS01201 XS01701 X013801 - XL01101 /*
//       */ XL01401,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M075201 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M066201 - MC47301 M046201 - MC20101 M067401 - M051901 /*
//       */ M046101 - M046701 M047201 - MC46601 M067801 - MC66601 /*
//       */ M067202 - MC67201 M068003 - MC68003 M068005 - MC68005 /*
//       */ M068008 - MC68008 M068007 - MC68006 M093601 - MC93601 /*
//       */ M053001 - MC53001 M047801 M085701 - MC85701 M085901 - MC85901 /*
//       */ M085601 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M019601 - MC47901 /*
//       */ M140401 - MH41301 M141401 - MH41601 M141701 M141801  /*
//       */ M143601 - MH44201 M1442A1 - MH44601 M1446A1 - MH44901 /*
//       */ M1449A1 - MH45101 M1451A1 - MC21001 M0210A1 - MC20901 /*
//       */ M0209A1 - MC92401 M0924A1 - MC92601 M0926A1 - M073602 /*
//       */ M0736A1 - MC13131 M0131A1 - MC73501 M0735A1 - MC52401 /*
//       */ M0524A1 - MC75301 M0753A1 - MC72901 M0729A1 - MC75801 /*
//       */ M0758A1 - M0934A1 M0938A1 - MH42801 M142901 - MH43201 /*
//       */ M143301 M143401  M105601 - MH06301 M106401 - MH06901 /*
//       */ M107001 - MH07501 M107601 - MH10201 M110301 - MH10501 /*
//       */ M110601 - MH11801,  mv( 9=.n)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M141901 - MH41901 M073601 - MC73601 M093801 - MC93801 /*
//       */ M143501 - MH43501,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 SCHTY02 HISPYES DRACEM  SDRACEM SENROL8 - LEP PARED /*
//       */ BA21101 - B018201 M814301 - MC75401 M075601 - MC75601 /*
//       */ M019901 - MC19901 M066201 - MC47301 M046201 - MC20101 /*
//       */ M067401 - M051901 M046101 - M046701 M047201 - MC46601 /*
//       */ M067801 - MC66601 M067202 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068007 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M047801 M085701 - MC85701 /*
//       */ M085901 - MC85901 M085601 - MC19701 M020001 - MC20001 /*
//       */ M046301 - MC66501 M047101 - MC66301 M067901 - MC67901 /*
//       */ M019601 - MC47901 M140401 - MH41301 M141401 - MH41601 /*
//       */ M141701 M141801  M143601 - MH44201 M1442A1 - MH44601 /*
//       */ M1446A1 - MH44901 M1449A1 - MH45101 M1451A1 - MC21001 /*
//       */ M0210A1 - MC20901 M0209A1 - MC92401 M0924A1 - MC92601 /*
//       */ M0926A1 - M073602 M0736A1 - MC13131 M0131A1 - MC73501 /*
//       */ M0735A1 - MC52401 M0524A1 - MC75301 M0753A1 - MC72901 /*
//       */ M0729A1 - MC75801 M0758A1 - M0934A1 M0938A1 - MH42801 /*
//       */ M142901 - MH43201 M143301 M143401  M105601 - MH06301 /*
//       */ M106401 - MH06901 M107001 - MH07501 M107601 - MH10201 /*
//       */ M110301 - MH10501 M110601 - MH11801 TA21101 - TE21201 /*
//       */ T077201 - T091504 XS00101 - XS01701 XL00101 - XL01401,  mv( 8=.o)
// mvdecode M815701 M815801  M076001 - MC76001 M046001 - MC46001 /*
//       */ M046901 - MC46901 M046801 - MC46801 M086301 - MC86301 /*
//       */ M053101 - MC53101 M141901 - MH41901 M073601 - MC73601 /*
//       */ M093801 - MC93801 M143501 - MH43501,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B003501 B003601  XS00501 - XS00701 /*
//       */ XS01001 XS01101  XL00201 - XL00601 XL00801 - XL01101,  mv( 7=.p)
// mvdecode M815801,  mv(77=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode M075401 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M047301 - MC47301 M020101 - MC20101 M046601 - MC46601 /*
//       */ M066601 - MC66601 M067201 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068006 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M047901 - MC47901 M141301 - MH41301 M141601 - MH41601 /*
//       */ M144201 - MH44201 M144601 - MH44601 M144901 - MH44901 /*
//       */ M145101 - MH45101 M021001 - MC21001 M020901 - MC20901 /*
//       */ M092401 - MC92401 M092601 - MC92601 M013131 - MC13131 /*
//       */ M073501 - MC73501 M052401 - MC52401 M075301 - MC75301 /*
//       */ M072901 - MC72901 M075801 - MC75801 M142801 - MH42801 /*
//       */ M143201 - MH43201 M106301 - MH06301 M106901 - MH06901 /*
//       */ M107501 - MH07501 M110201 - MH10201 M110501 - MH10501 /*
//       */ M111801 - MH11801,  mv( 7=.q)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M141901 - MH41901 M073601 - MC73601 M093801 - MC93801 /*
//       */ M143501 - MH43501,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M075401 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M047301 - MC47301 M020101 - MC20101 M046601 - MC46601 /*
//       */ M066601 - MC66601 M067201 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068006 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M047901 - MC47901 M141301 - MH41301 M141601 - MH41601 /*
//       */ M144201 - MH44201 M144601 - MH44601 M144901 - MH44901 /*
//       */ M145101 - MH45101 M021001 - MC21001 M020901 - MC20901 /*
//       */ M092401 - MC92401 M092601 - MC92601 M013131 - MC13131 /*
//       */ M073501 - MC73501 M052401 - MC52401 M075301 - MC75301 /*
//       */ M072901 - MC72901 M075801 - MC75801 M142801 - MH42801 /*
//       */ M143201 - MH43201 M106301 - MH06301 M106901 - MH06901 /*
//       */ M107501 - MH07501 M110201 - MH10201 M110501 - MH10501 /*
//       */ M111801 - MH11801,  mv( 5=.r)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M141901 - MH41901 M073601 - MC73601 M093801 - MC93801 /*
//       */ M143501 - MH43501,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode M075401 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M047301 - MC47301 M020101 - MC20101 M046601 - MC46601 /*
//       */ M066601 - MC66601 M067201 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068006 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M047901 - MC47901 M141301 - MH41301 M141601 - MH41601 /*
//       */ M144201 - MH44201 M144601 - MH44601 M144901 - MH44901 /*
//       */ M145101 - MH45101 M021001 - MC21001 M020901 - MC20901 /*
//       */ M092401 - MC92401 M092601 - MC92601 M013131 - MC13131 /*
//       */ M073501 - MC73501 M052401 - MC52401 M075301 - MC75301 /*
//       */ M072901 - MC72901 M075801 - MC75801 M142801 - MH42801 /*
//       */ M143201 - MH43201 M106301 - MH06301 M106901 - MH06901 /*
//       */ M107501 - MH07501 M110201 - MH10201 M110501 - MH10501 /*
//       */ M111801 - MH11801,  mv( 6=.s)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M141901 - MH41901 M073601 - MC73601 M093801 - MC93801 /*
//       */ M143501 - MH43501,  mv(66=.s)
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
// recode M075201 M086101 M019601 M140701 M140801 M141501 M143701 M144501 /*
//     */ M144701 M073301 M019201 M091901 M067001 M013431 M142201 M142501 /*
//     */ M143001 M106201 M106601 M107201 M107401 M110001 M110301 M110701 /*
//     */ M111001 M111201 M111401 M111601 (1=0) (2=0) (3=1) (4=0) (5=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M075401 M075601 M066601 M067201 M068003 M068005 M068008 M068006 /*
//     */ M093601 M085901 M066501 M066301 M067901 M144601 M092401 M092601 /*
//     */ M075301 M072901 M075801 M110501 M111801 (1=0) (2=1) (3=2) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M019901 M073501 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M066201 M046101 M047201 M085601 M046301 (1=0) (2=1) (3=0) (4=0) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M047301 M046601 (1=0) (2=0) (3=0) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M046201 M046701 M067801 M047101 (1=0) (2=0) (3=1) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M066401 M047001 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M020101 M053001 M019701 M020001 M141601 M144201 M021001 M020901 /*
//     */ M013131 M052401 M142801 M143201 M106301 M106901 M107501 M110201 (1=0) /*
//     */ (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M067401 M085801 M051501 M140401 M140601 M143901 M144801 M073101 /*
//     */ M012431 M091701 M013631 M093401 M142101 M143401 M106401 /*
//     */ M106701 M106801 M107001 M110801 (1=1) (2=0) (3=0) (4=0) (5=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M047701 M086001 M141001 M141101 M141401 M141801 M143801 M144001 /*
//     */ M145001 M092201 M052501 M072801 M051801 M142401 M142901 /*
//     */ M105901 M106001 M106501 M109801 M110401 M110601 M111301 (1=0) (2=1) /*
//     */ (3=0) (4=0) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M067301 M051901 M047801 M140501 M140901 M141201 M143601 M144401 /*
//     */ M012231 M051701 M091501 M091601 M013731 M142601 M143101 M143301 /*
//     */ M105601 M105801 M106101 M107101 M110101 M110901 (1=0) (2=0) (3=0) /*
//     */ (4=1) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M048001 M093701 M068007 M141701 M144101 M144301 M013331 M073001 /*
//     */ M013531 M142001 M142301 M142701 M107601 M111501 (1=0) (2=0) (3=0) /*
//     */ (4=0) (5=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M076001 M141901 M073601 M143501 (1=0) (2=1) (3=2) (4=3) (5=4) (99=.n) /*
//     */ (88=.o) (77=.q) (55=.r) (66=.s) (else=.)
// recode M046001 M046901 M046801 (1=0) (2=0) (3=0) (4=0) (5=1) (99=.n) (88=.o) /*
//     */ (77=.q) (55=.r) (66=.s) (else=.)
// recode M067701 M085501 M046501 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) (else=.)
// recode M086301 (1=0) (2=1) (3=2) (4=2) (5=2) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M085701 M047901 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M053101 (1=0) (2=1) (3=2) (4=2) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M141301 M144901 (1=0) (2=1) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M145101 (1=0) (2=1) (3=1) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M0732CL (1=0) (2=1) (3=2) (4=3) (5=4) ( 9=.n) ( 8=.o) (else=.)
// recode M0757CL (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) (else=.)
// recode M093801 (1=0) (2=1) (3=2) (4=3) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2005
gen grade=8
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2005\naep_math_gr8_2005", replace


