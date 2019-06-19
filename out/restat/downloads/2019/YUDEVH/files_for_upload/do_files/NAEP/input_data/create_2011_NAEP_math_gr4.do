version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP3B\Y42MATRED\Y42MAT\STATA\LABELDEF.do"
label data "  2011 National Mathematics Grade 4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP3B\Y42MATRED\Y42MAT\STATA\M42NT1AT.DCT", clear
label values  FIPS02    FIPS02Q
label values  ORIGSUB   ORIGSUB
label values  PUBPRIV   PUBPRIV
label values  BMONTH    BMONTH
label values  SEX       SEX
label values  SRACE10   SRACE10Q
label values  SLNCH05   SLNCH05Q
label values  SLUNCH1   SLUNCH1Q
label values  SD3       SD3Q
label values  ELL       ELL
label values  NEWENRL   NEWENRL
label values  ACCOMCD   ACCOMCD
label values  ACCEXT    NOYES
label values  ACCSMG    NOYES
label values  ACCONE    NOYES
label values  ACCRDE    NOYES
label values  ACCROE    NOYES
label values  ACCRAE    NOYES
label values  ACCBRK    NOYES
label values  ACCSSA    NOYES
label values  ACCSCR    NOYES
label values  ACCLRG    NOYES
label values  ACCMAG    NOYES
label values  ACCCAL    NOYES
label values  ACCSPE    NOYES
label values  ACCCUE    NOYES
label values  ACCBRL    NOYES
label values  ACCSNG    NOYES
label values  ACCINC    NOYES
label values  ACCBID    NOYES
label values  ACCRDS    NOYES
label values  ACCROS    NOYES
label values  ACCRAS    NOYES
label values  ACCBIB    NOYES
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
label values  SCHTYPE   SCHTYPE
label values  RPTSAMP   RPTSAMP
label values  UTOL12    UTOL12Q
label values  UTOL4     UTOL4Q
label values  DISTCOD   DISTCOD
label values  SDRACEM   SDRACEM
label values  DRACE10   SRACE10Q
label values  LEP       LEP
label values  IEP       IEP
label values  ELL3      ELL3Q
label values  SDELL     SDELL
label values  SLUNCH    SLUNCH
label values  IEP2009   YESNO
label values  TUAFLG3   TUAFLG3Q
label values  JKUNIT    JKUNIT
label values  JKNU      PCHRAYP
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  FIPS      FIPS02Q
label values  SAMPTYP   SAMPTYP
label values  ACCOM2    ACCOM2Q
label values  SCHTYP2   TYPCLAS
label values  LRGCITY   YESNO
label values  CHRTRPT   CHRTRPT
label values  SENROL4   SENROL4Q
label values  YRSEXP    YRSEXP
label values  PCTBLKC   PCTBLKC
label values  PCTHSPC   PCTBLKC
label values  PCTASNC   PCTBLKC
label values  PCTINDC   PCTBLKC
label values  PCTWHTC   PCTBLKC
label values  Y42OMC    BLKUSE
label values  Y42OMD    BLKUSE
label values  Y42OME    BLKUSE
label values  Y42OMF    BLKUSE
label values  Y42OMG    BLKUSE
label values  Y42OMH    BLKUSE
label values  Y42OMI    BLKUSE
label values  Y42OMJ    BLKUSE
label values  Y42OMK    BLKUSE
label values  Y42OML    BLKUSE
label values  CALC65    CALC65Q
label values  INCL65    INCL65Q
label values  SCHTY02   SCHTY02Q
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
label values  M815001   M815001Q
label values  M815101   M815101Q
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
label values  M1459E1   M1459E1Q
label values  MG45901   RATE3B
label values  MG459R1   MC5E
label values  MH45901   RATE3B
label values  MH459R1   MC5E
label values  M146001   MC5C
label values  M146101   RATE2D
label values  M1461R1   MC5D
label values  M1461E1   M1461E1Q
label values  MG46101   RATE2D
label values  MG461R1   MC5D
label values  MH46101   RATE2D
label values  MH461R1   MC5D
label values  M146201   MC5C
label values  M146301   RATE3B
label values  M1463R1   MC5C
label values  M1463E1   M1463E1Q
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
label values  M218501   MC5C
label values  M218502   RATE2D
label values  ML18502   RATE2D
label values  MM18502   RATE2D
label values  M218503   MC5B
label values  M218504   RATE2D
label values  ML18504   RATE2D
label values  MM18504   RATE2D
label values  M218505   RATE3B
label values  M2185R5   MC5C
label values  M2185E5   M2185E5Q
label values  ML18505   RATE3B
label values  ML185R5   MC5C
label values  MM18505   RATE3B
label values  MM185R5   MC5C
label values  M2185CL   M2185CL
label values  M218601   MC5A
label values  M218701   MC5B
label values  M218801   RATE2D
label values  ML18801   RATE2D
label values  MM18801   RATE2D
label values  M218901   RATE2D
label values  ML18901   RATE2D
label values  MM18901   RATE2D
label values  M219001   MC5B
label values  M219101   MC5C
label values  M219201   MC5C
label values  M219301   MC5C
label values  M219401   MC5D
label values  M219501   RATE3B
label values  M2195R1   MC5D
label values  M2195E1   M2195E1Q
label values  ML19501   RATE3B
label values  ML195R1   MC5D
label values  MM19501   RATE3B
label values  MM195R1   MC5D
label values  M219601   MC5C
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
label values  M136951   M136951Q
label values  M1369R1   MC5C
label values  M136901   M136901Q
label values  MG36951   RATE3B
label values  MG369R1   MC5C
label values  MH36951   RATE3B
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
label values  M1570E1   M1463E1Q
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
label values  M1607E1   M1607E1Q
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
label values  M1624E1   M2195E1Q
label values  MG62401   RATE3B
label values  MG624R1   MC5D
label values  MH62401   RATE3B
label values  MH624R1   MC5D
label values  M1624A1   YESNO
label values  M157701   MC5D
label values  M1577A1   YESNO
label values  M159401   M136901Q
label values  M1594R1   MC5C
label values  M1594E1   M1594E1Q
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
label values  M040001   RATE3B
label values  MB40001   RATE3B
label values  MC40001   RATE3B
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
label values  M1620E1   M1463E1Q
label values  MG62001   RATE3B
label values  MG620R1   MC5C
label values  MH62001   RATE3B
label values  MH620R1   MC5C
label values  M155301   MC5A
label values  M160301   MC5C
label values  M157602   YESNO
label values  M157601   RATE3B
label values  M1576R1   MC5D
label values  M1576E1   M2195E1Q
label values  MG57601   RATE3B
label values  MG576R1   MC5D
label values  MH57601   RATE3B
label values  MH576R1   MC5D
label values  M154701   MC5A
label values  M159301   MC5D
label values  M160902   MC5A
label values  M160901   RATE3B
label values  M1609R1   MC5D
label values  M1609E1   M2195E1Q
label values  MG60901   RATE3B
label values  MG609R1   MC5D
label values  MH60901   RATE3B
label values  MH609R1   MC5D
label values  M155102   YESNO
label values  M155103   YESNO
label values  M155104   YESNO
label values  M155101   M2185CL
label values  MG55101   MG55101Q
label values  MH55101   MG55101Q
label values  M219701   MC5A
label values  M219801   MC5D
label values  M219901   MC5B
label values  M220001   RATE3B
label values  ML20001   RATE3B
label values  MM20001   RATE3B
label values  M220101   MC5A
label values  M220201   MC5B
label values  M220301   MC5C
label values  M220402   MC5C
label values  M220401   RATE3B
label values  M2204R1   MC5C
label values  M2204E1   M2204E1Q
label values  ML20401   RATE3B
label values  ML204R1   MC5C
label values  MM20401   RATE3B
label values  MM204R1   MC5C
label values  M220501   MC5B
label values  M220601   MC5B
label values  M2207A1   M2207A1Q
label values  M220701   RATE3B
label values  M2207R1   MC5C
label values  M2207E1   M2207E1Q
label values  ML20701   RATE3B
label values  ML207R1   MC5C
label values  MM20701   RATE3B
label values  MM207R1   MC5C
label values  M220801   MC5D
label values  M220901   MC5B
label values  M221001   MC5B
label values  M221101   RATE3B
label values  M2211R1   MC5E
label values  M2211E1   M2211E1Q
label values  ML21101   RATE3B
label values  ML211R1   MC5E
label values  MM21101   RATE3B
label values  MM211R1   MC5E
label values  M158001   MC5B
label values  M156301   MC5D
label values  M161101   MC5B
label values  M156101   RATE3B
label values  M1561R1   MC5D
label values  M1561E1   M1561E1Q
label values  MG56101   RATE3B
label values  MG561R1   MC5D
label values  MH56101   RATE3B
label values  MH561R1   MC5D
label values  M156601   MC5C
label values  M161602   MC5C
label values  M161601   RATE3B
label values  M1616R1   MC5C
label values  M1616E1   M2185E5Q
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
label values  M1619E1   M1619E1Q
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
label values  M1622E1   M2195E1Q
label values  MG62201   RATE3B
label values  MG622R1   MC5D
label values  MH62201   RATE3B
label values  MH622R1   MC5D
label values  M161001   RATE2D
label values  MG61001   RATE2D
label values  MH61001   RATE2D
label values  M161002   RATE3B
label values  M1610R2   MC5C
label values  M1610E2   M1463E1Q
label values  MG61002   RATE3B
label values  MG610R2   MC5C
label values  MH61002   RATE3B
label values  MH610R2   MC5C
label values  M1610CL   MG55101Q
label values  M148201   MC5C
label values  M148301   MC5C
label values  M148401   MC5C
label values  M148501   RATE3B
label values  M1485R1   MC5D
label values  M1485E1   M1619E1Q
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
label values  M1492E1   M1463E1Q
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
label values  XS04701   XS04701Q
label values  XS04801   XS04801Q
label values  XS04901   NOYES
label values  XS04902   NOYES
label values  XS04907   NOYES
label values  XS04905   NOYES
label values  XS04908   NOYES
label values  XS04909   NOYES
label values  XS04910   NOYES
label values  XS04911   NOYES
label values  XS04912   NOYES
label values  XS04913   NOYES
label values  XS04914   NOYES
label values  XS04915   NOYES
label values  XS04916   NOYES
label values  XS04917   NOYES
label values  XS05001   XS05001Q
label values  XS05101   YESNO
label values  XS05102   YESNO
label values  XS05103   YESNO
label values  XS05105   YESNO
label values  XS05106   YESNO
label values  XS05107   YESNO
label values  XS05108   YESNO
label values  XS05109   YESNO
label values  XS05110   YESNO
label values  XS05111   YESNO
label values  XS05104   YESNO
label values  XS05201   XS05201Q
label values  XS05301   XS05301Q
label values  XL04501   XL04501Q
label values  XL03801   XL03801Q
label values  XL03901   NOYES
label values  XL03902   NOYES
label values  XL03908   NOYES
label values  XL03905   NOYES
label values  XL03909   NOYES
label values  XL03910   NOYES
label values  XL03906   NOYES
label values  XL03911   NOYES
label values  XL03912   NOYES
label values  XL03913   NOYES
label values  XL03914   NOYES
label values  XL04001   XS05001Q
label values  XL04101   XL04101Q
label values  XL04201   XS05301Q
label values  XL04301   XL04301Q
label values  XL04302   XL04301Q
label values  XL04303   XL04301Q
label values  XL04304   XL04301Q
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
label values  T096801   MAJORA
label values  T087301   MAJORA
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T077312   MAJORA
label values  T118801   MAJORA
label values  T118802   MAJORA
label values  T077409   MAJORA
label values  T077410   MAJORA
label values  T096901   MAJORA
label values  T077411   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T077412   MAJORA
label values  T118901   MAJORA
label values  T118902   MAJORA
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
label values  T122101   NOYES
label values  T122102   NOYES
label values  T122103   NOYES
label values  T122104   NOYES
label values  T122105   NOYES
label values  T122106   NOYES
label values  T122107   NOYES
label values  T122108   NOYES
label values  T122109   NOYES
label values  T122110   NOYES
label values  T122111   NOYES
label values  T122112   NOYES
label values  T122113   NOYES
label values  T122114   NOYES
label values  T122115   NOYES
label values  T122116   NOYES
label values  T122117   NOYES
label values  T122118   NOYES
label values  T122119   NOYES
label values  T122120   NOYES
label values  T122121   NOYES
label values  T122122   NOYES
label values  T122123   NOYES
label values  T122124   NOYES
label values  T122125   NOYES
label values  T122126   NOYES
label values  T122127   NOYES
label values  T122128   NOYES
label values  T122129   NOYES
label values  T122130   NOYES
label values  T122131   NOYES
label values  T122132   NOYES
label values  T122133   NOYES
label values  T122134   NOYES
label values  T122135   NOYES
label values  T122136   NOYES
label values  T097401   YESNO
label values  T097501   T097501Q
label values  T097502   T097501Q
label values  T097503   T097501Q
label values  T097504   T097501Q
label values  T097505   T097501Q
label values  T088201   YESNO
label values  T088202   YESNO
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
label values  T075351   EMPHASA
label values  T075352   EMPHASA
label values  T075353   EMPHASA
label values  T075354   EMPHASA
label values  T075355   EMPHASA
label values  T088301   T088301Q
label values  T106601   T106501Q
label values  T106602   T106501Q
label values  T106603   T106501Q
label values  T106606   T106501Q
label values  T106609   T106501Q
label values  T106610   T106501Q
label values  T106701   T106701Q
label values  T106801   FREQ4D
label values  T106802   FREQ4D
label values  T106803   FREQ4D
label values  T106804   FREQ4D
label values  T106805   FREQ4D
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
// mvdecode M145901 M1459E1 MG45901  MH45901 M146101 M1461E1 MG46101  MH46101 /*
//       */ M146301 M1463E1 MG46301  MH46301 M146401 - MH46401 /*
//       */ M146601 - MH46601 M146801 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M148101 - MH48101 M218502 - MM18502 /*
//       */ M218504 - MM18504 M218505 M2185E5 ML18505  MM18505 M2185CL /*
//       */ M218801 - MM18801 M218901 - MM18901 M219501 M2195E1 ML19501  /*
//       */ MM19501 M136501 - MH36501 M136601 - MH36601 M136951 M136901 MG36951  /*
//       */ MH36951 M156701 - MH56701 M157301 - MH57301 M157001 M1570E1 MG57001  /*
//       */ MH57001 M160701 M1607E1 MG60701  MH60701 M162401 M1624E1 MG62401  /*
//       */ MH62401 M159401 M1594E1 MG59401  MH59401 M010631 - MC10631 /*
//       */ M087001 - MC87001 M040001 - MC40001 M091201 - MC91201 /*
//       */ M072401 - MC72401 M087301 - MC87301 M161201 - MH61201 M162001 /*
//       */ M1620E1 MG62001  MH62001 M157601 M1576E1 MG57601  MH57601 M160901 /*
//       */ M1609E1 MG60901  MH60901 M155101 - MH55101 M220001 - MM20001 /*
//       */ M220401 M2204E1 ML20401  MM20401 M2207A1 M220701  M2207E1 ML20701  /*
//       */ MM20701 M221101 M2211E1 ML21101  MM21101 M156101 M1561E1 MG56101  /*
//       */ MH56101 M161601 M1616E1 MG61601  MH61601 M161901 M1619E1 MG61901  /*
//       */ MH61901 M157501 - MH57501 M162201 M1622E1 MG62201  MH62201 /*
//       */ M161001 - MH61001 M161002 M1610E2 MG61002  MH61002 M1610CL M148501 /*
//       */ M1485E1 MG48501  MH48501 M149201 M1492E1 MG49201  MH49201 /*
//       */ M149301 - MH49301 M149701 - MH49701,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M145901 MG45901 MH45901 M146101 MG46101 MH46101 M146301 /*
//       */ M1463E1 MG46301  MH46301 M146401 - MH46401 M146801 - MH46801 /*
//       */ M146901 - MH46901 M147001 - MH47001 M148101 - MH48101 /*
//       */ M218502 - MM18502 M218504 - MM18504 M218505 ML18505 MM18505 /*
//       */ M218801 - MM18801 M218901 - MM18901 M219501 ML19501 MM19501 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136951 M136901 MG36951  /*
//       */ MH36951 M156701 - MH56701 M157301 - MH57301 M157001 M1570E1 MG57001  /*
//       */ MH57001 M160701 MG60701 MH60701 M162401 MG62401 MH62401 M159401 /*
//       */ MG59401 MH59401 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M161201 - MH61201 M162001 M1620E1 MG62001  MH62001 M157601 MG57601 /*
//       */ MH57601 M160901 MG60901 MH60901 M220001 - MM20001 M220401 /*
//       */ M2204E1 ML20401  MM20401 M2207A1 M220701  ML20701 MM20701 M221101 /*
//       */ ML21101 MM21101 M156101 MG56101 MH56101 M161601 MG61601 MH61601 /*
//       */ M161901 MG61901 MH61901 M157501 - MH57501 M162201 MG62201 MH62201 /*
//       */ M161001 - MH61001 M161002 M1610E2 MG61002  MH61002 M148501 MG48501 /*
//       */ MH48501 M149201 M1492E1 MG49201  MH49201 M149301 - MH49301,  /*
//       */ mv( 9=.n)
// mvdecode M1459E1 M1461E1 M146601 - MH46601 M2185E5 M2185CL M2195E1 M1607E1 /*
//       */ M1624E1 M1594E1 M087301 - MC87301 M1576E1 M1609E1 M155101 - MH55101 /*
//       */ M2207E1 M2211E1 M1561E1 M1616E1 M1619E1 M1622E1 M1610CL M1485E1 /*
//       */ M149701 - MH49701,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode B000905 B017201 M2207A1 XS05301 XL04101 - XL04304,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode M145901 MG45901 MH45901 M146101 MG46101 MH46101 M146301 /*
//       */ M1463E1 MG46301  MH46301 M146401 - MH46401 M146801 - MH46801 /*
//       */ M146901 - MH46901 M147001 - MH47001 M148101 - MH48101 /*
//       */ M218502 - MM18502 M218504 - MM18504 M218505 ML18505 MM18505 /*
//       */ M218801 - MM18801 M218901 - MM18901 M219501 ML19501 MM19501 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136951 M136901 MG36951  /*
//       */ MH36951 M156701 - MH56701 M157301 - MH57301 M157001 M1570E1 MG57001  /*
//       */ MH57001 M160701 MG60701 MH60701 M162401 MG62401 MH62401 M159401 /*
//       */ MG59401 MH59401 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M161201 - MH61201 M162001 M1620E1 MG62001  MH62001 M157601 MG57601 /*
//       */ MH57601 M160901 MG60901 MH60901 M220001 - MM20001 M220401 /*
//       */ M2204E1 ML20401  MM20401 M220701 ML20701 MM20701 M221101 ML21101 /*
//       */ MM21101 M156101 MG56101 MH56101 M161601 MG61601 MH61601 M161901 /*
//       */ MG61901 MH61901 M157501 - MH57501 M162201 MG62201 MH62201 /*
//       */ M161001 - MH61001 M161002 M1610E2 MG61002  MH61002 M148501 MG48501 /*
//       */ MH48501 M149201 M1492E1 MG49201  MH49201 M149301 - MH49301,  /*
//       */ mv( 7=.p)
// mvdecode M1459E1 M1461E1 M146601 - MH46601 M2185E5 M2185CL M2195E1 M1607E1 /*
//       */ M1624E1 M1594E1 M087301 - MC87301 M1576E1 M1609E1 M155101 - MH55101 /*
//       */ M2207E1 M2211E1 M1561E1 M1616E1 M1619E1 M1622E1 M1610CL M1485E1 /*
//       */ M149701 - MH49701,  mv(77=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode SRACE10 SD3 PCHARTR PCHRTFL UTOL4 LEP - ELL3 SLUNCH IEP2009  /*
//       */ HISPYES SENROL4 - PCTWHTC BA21101 - M145901 MG45901 MH45901 /*
//       */ M146001 M146101  MG46101 MH46101 M146201 M146301  M1463E1 MG46301  /*
//       */ MH46301 M146401 - MH46401 M146501 M146701 - MH46801 /*
//       */ M146901 - MH46901 M147001 - MH47001 M147101 - MH48101 /*
//       */ M218501 - MM18502 M218503 - MM18504 M218505 M2185R5  /*
//       */ ML18505 - MM185R5 M218601 - MM18801 M218901 - MM18901 /*
//       */ M219001 - M219501 ML19501 MM19501 M219601 - MH36501 /*
//       */ M136601 - MH36601 M136701 - M136951 M136901 MG36951  MH36951 /*
//       */ M137001 - MH56701 M1567A1 - MH57301 M1573A1 M157001  /*
//       */ M1570E1 MG57001  MH57001 M1570A1 - M160701 MG60701 MH60701 /*
//       */ M1607A1 - M162401 MG62401 MH62401 M1624A1 - M159401 MG59401 MH59401 /*
//       */ M1594A1 - MC10631 M0106A1 - MC87001 M0870A1 - MC40001 /*
//       */ M0400A1 - MC91201 M0912A1 - MC72401 M0724A1 - M0913A1 /*
//       */ M0873A1 - MH61201 M154401 - M162001 M1620E1 MG62001  MH62001 /*
//       */ M155301 - M157601 MG57601 MH57601 M154701 - M160901 MG60901 MH60901 /*
//       */ M155102 - M155104 M219701 - MM20001 M220101 - M220401 /*
//       */ M2204E1 ML20401  MM20401 M220501 - M220701 ML20701 MM20701 /*
//       */ M220801 - M221101 ML21101 MM21101 M158001 - M156101 MG56101 MH56101 /*
//       */ M156601 - M161601 MG61601 MH61601 M158301 - M161901 MG61901 MH61901 /*
//       */ M154901 - MH57501 M162301 - M162201 MG62201 MH62201 /*
//       */ M161001 - MH61001 M161002 M1610E2 MG61002  MH61002 MH610R2  /*
//       */ M148201 - M148501 MG48501 MH48501 M148601 - M149201 M1492E1 MG49201  /*
//       */ MH49201 M149301 - MH49301 M149401 - M149601 XS04701 - XS05001 /*
//       */ XS05101 - XS05104 XS05201 - XL04001 XL04101 - TE21201 /*
//       */ T096401 - T107004,  mv( 7=.q)
// mvdecode UTOL12 M1459E1 M1461E1 M146601 - MH46601 M2185E5 M2185CL M2195E1 /*
//       */ M1607E1 M1624E1 M1594E1 M087301 - MC87301 M1576E1 M1609E1 /*
//       */ M155101 - MH55101 M2207E1 M2211E1 M1561E1 M1616E1 M1619E1 M1622E1 /*
//       */ M1610CL M1485E1 M149701 - MH49701,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode SRACE10 PCHARTR PCHRTFL M145201 - M145901 MG45901 MH45901 /*
//       */ M146001 M146101  MG46101 MH46101 M146201 M146301  M1463E1 MG46301  /*
//       */ MH46301 M146401 - MH46401 M146501 M146701 - MH46801 /*
//       */ M146901 - MH46901 M147001 - MH47001 M147101 - MH48101 /*
//       */ M218501 - MM18502 M218503 - MM18504 M218505 M2185R5  /*
//       */ ML18505 - MM185R5 M218601 - MM18801 M218901 - MM18901 /*
//       */ M219001 - M219501 ML19501 MM19501 M219601 - MH36501 /*
//       */ M136601 - MH36601 M136701 - M136951 M136901 MG36951  MH36951 /*
//       */ M137001 - MH56701 M1567A1 - MH57301 M1573A1 M157001  /*
//       */ M1570E1 MG57001  MH57001 M1570A1 - M160701 MG60701 MH60701 /*
//       */ M1607A1 - M162401 MG62401 MH62401 M1624A1 - M159401 MG59401 MH59401 /*
//       */ M1594A1 - MC10631 M0106A1 - MC87001 M0870A1 - MC40001 /*
//       */ M0400A1 - MC91201 M0912A1 - MC72401 M0724A1 - M0913A1 /*
//       */ M0873A1 - MH61201 M154401 - M162001 M1620E1 MG62001  MH62001 /*
//       */ M155301 - M157601 MG57601 MH57601 M154701 - M160901 MG60901 MH60901 /*
//       */ M155102 - M155104 M219701 - MM20001 M220101 - M220401 /*
//       */ M2204E1 ML20401  MM20401 M220501 - M220701 ML20701 MM20701 /*
//       */ M220801 - M221101 ML21101 MM21101 M158001 - M156101 MG56101 MH56101 /*
//       */ M156601 - M161601 MG61601 MH61601 M158301 - M161901 MG61901 MH61901 /*
//       */ M154901 - MH57501 M162301 - M162201 MG62201 MH62201 /*
//       */ M161001 - MH61001 M161002 M1610E2 MG61002  MH61002 MH610R2  /*
//       */ M148201 - M148501 MG48501 MH48501 M148601 - M149201 M1492E1 MG49201  /*
//       */ MH49201 M149301 - MH49301 M149401 - M149601,  mv( 5=.r)
// mvdecode M1459E1 M1461E1 M146601 - MH46601 M2185E5 M2185CL M2195E1 M1607E1 /*
//       */ M1624E1 M1594E1 M087301 - MC87301 M1576E1 M1609E1 M155101 - MH55101 /*
//       */ M2207E1 M2211E1 M1561E1 M1616E1 M1619E1 M1622E1 M1610CL M1485E1 /*
//       */ M149701 - MH49701,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode BA21101 - M145801 M146001 M146201 M146501 M146701 M147101 - M148001 /*
//       */ M218501 M218503 M2185R5 ML185R5 MM185R5 M218601 M218701  /*
//       */ M219001 - M219401 M219601 - M136501 M136601 M136701 - M136951 /*
//       */ M137001 - M1700A1 M1567A1 - M1586A1 M1573A1 M1570A1 - M1568A1 /*
//       */ M1607A1 - M162402 M1624A1 - M1577A1 M1594A1 - M0867A1 /*
//       */ M0106A1 - M0909A1 M0870A1 - M0398A1 M0400A1 - M0872A1 /*
//       */ M0912A1 - M0660A1 M0724A1 - M0913A1 M0873A1 - M161701 /*
//       */ M154401 - M155501 M155301 - M157602 M154701 - M160902 /*
//       */ M155102 - M155104 M219701 - M219901 M220101 - M220402 /*
//       */ M220501 - M2207A1 M220801 - M221001 M158001 - M161101 /*
//       */ M156601 M161602  M158301 - M155201 M154901 M162301 M162202  MH610R2 /*
//       */ M148201 - M148401 M148601 - M149101 M149401 - M149601 /*
//       */ XS04701 XS04801  XS05001 XS05101 - XS05104 XS05201 - XL03801 /*
//       */ XL04001 XL04101 - XL04304 T096401 - T097207 T097401 - T107004,  /*
//       */ mv( 6=.s)
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
// recode M145201 M145501 M146001 M146201 M146701 M147701 M148001 M218501 /*
//     */ M219101 - M219301 M219601 M135601 M136301 M137101 M154501 M157101 /*
//     */ M087201 M091301 M159501 M155401 M158701 M160301 M220301 M156601 /*
//     */ M159701 M148201 - M148401 M148901 M149001 M149501 M149601 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145301 M147301 M147901 M218601 M135701 M135901 M136201 M157201 /*
//     */ M160001 M010131 M039101 M086701 M072301 M066001 M155301 M154701 /*
//     */ M219701 M220101 M155201 M148601 (1=1) (2=0) (3=0) (4=0) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M145401 M145701 M145801 M146501 M147101 M219401 M136101 M136401 /*
//     */ M136701 M137001 M170001 M160201 M156801 M157701 N214331 M010831 /*
//     */ M157901 M161701 M159301 M219801 M220801 M156301 M154901 M148701 (1=0) /*
//     */ (2=0) (3=0) (4=1) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145601 M147201 M147401 - M147601 M147801 M218503 M218701 M219001 /*
//     */ M135801 M136001 M136801 M158601 M010331 M086901 M090901 M039801 /*
//     */ M154401 M155501 M219901 M220201 M220501 M220601 M220901 M221001 /*
//     */ M158001 M161101 M158301 M156201 M162301 M148801 M149101 M149401 (1=0) /*
//     */ (2=1) (3=0) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M145901 M146301 M146401 M146901 M147001 M148101 M219501 M157001 /*
//     */ M160701 M162401 M087001 M091201 M072401 M161201 M162001 M157601 /*
//     */ M160901 M220001 M220401 M220701 M221101 M156101 M161601 M161901 /*
//     */ M157501 M162201 M148501 M149201 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) /*
//     */ ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode M146101 M146801 M218502 M218801 M218901 M156701 M157301 M149301 (1=0) /*
//     */ (2=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode M146601 M087301 M155101 M1610CL M149701 (1=0) (2=1) (3=2) (4=3) (5=4) /*
//     */ ( 0=.m) (99=.n) (77=.p) (77=.q) (55=.r) (else=.)
// recode M2185CL (1=0) (2=1) (3=1) (4=2) (5=3) ( 0=.m) (99=.n) (77=.p) (77=.q) /*
//     */ (55=.r) (else=.)
// recode M136501 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode M136601 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M136901 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode M159401 (1=0) (2=1) (3=2) (4=3) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode M010631 M040001 (1=0) (2=0) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
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
// label values  M218501   SCORE
// label values  M218502   SCORE
// label values  M218503   SCORE
// label values  M2185CL   SCORE
// label values  M218601   SCORE
// label values  M218701   SCORE
// label values  M218801   SCORE
// label values  M218901   SCORE
// label values  M219001   SCORE
// label values  M219101   SCORE
// label values  M219201   SCORE
// label values  M219301   SCORE
// label values  M219401   SCORE
// label values  M219501   SCORE
// label values  M219601   SCORE
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
// label values  M219701   SCORE
// label values  M219801   SCORE
// label values  M219901   SCORE
// label values  M220001   SCORE
// label values  M220101   SCORE
// label values  M220201   SCORE
// label values  M220301   SCORE
// label values  M220401   SCORE
// label values  M220501   SCORE
// label values  M220601   SCORE
// label values  M220701   SCORE
// label values  M220801   SCORE
// label values  M220901   SCORE
// label values  M221001   SCORE
// label values  M221101   SCORE
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

gen year=2011
gen grade=4
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE10

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2011\naep_math_gr4_2011", replace


