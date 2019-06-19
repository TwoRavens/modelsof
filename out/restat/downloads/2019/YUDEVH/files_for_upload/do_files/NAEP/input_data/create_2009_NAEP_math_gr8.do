version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Math Nat'l and State GR 4&8\STATA\LABELDEF.do"
label data "  2009 National Mathematics Grade 8 Student & Teacher Data"
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Math Nat'l and State GR 4&8\STATA\M40NT2AT.DCT", clear
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
label values  PARED     PARED
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SDRACEM   SDRACEM
label values  SENROL8   SENROL8Q
label values  YRSEXP    YRSEXP
label values  YRSMATH   YRSEXP
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
label values  B003501   PARED
label values  B003601   PARED
label values  B018201   B018201Q
label values  M815701   M815701Q
label values  M815801   M815801Q
label values  M821401   YESNO
label values  M824901   M824901Q
label values  M824902   M824901Q
label values  M824903   M824901Q
label values  M824904   M824904Q
label values  M824905   M824904Q
label values  M820901   AGREE4A
label values  M820904   AGREE4A
label values  M820905   AGREE4A
label values  M817401   M817401Q
label values  M817501   M817401Q
label values  M817601   M817401Q
label values  M815301   M815301Q
label values  M817801   M817801Q
label values  M817901   M817801Q
label values  M818001   M817801Q
label values  M817701   M817701Q
label values  M814301   M817801Q
label values  M823901   YESNO
label values  M815901   M815901Q
label values  M816001   M817801Q
label values  M816101   M817801Q
label values  M816201   M817801Q
label values  M816301   M817801Q
label values  M816401   M817801Q
label values  M816501   M817801Q
label values  M816601   M817801Q
label values  M816701   M817801Q
label values  M825001   M825001Q
label values  M820401   YESNO
label values  M821301   M817801Q
label values  M820603   M817801Q
label values  M815401   M815401Q
label values  M815501   M815501Q
label values  M815601   M815601Q
label values  M149801   MC5D
label values  M149901   RATE3B
label values  M1499R1   MC5C
label values  MG49901   RATE3B
label values  MG499R1   MC5C
label values  MH49901   RATE3B
label values  MH499R1   MC5C
label values  M150001   MC5E
label values  M150101   MC5B
label values  M150201   MC5D
label values  M150301   MC5A
label values  M150401   MC5B
label values  M150501   MC5C
label values  M150601   MC5A
label values  M150701   MC5B
label values  M150801   RATE3B
label values  M1508R1   MC5C
label values  MG50801   RATE3B
label values  MG508R1   MC5C
label values  MH50801   RATE3B
label values  MH508R1   MC5C
label values  M150901   RATE2D
label values  MG50901   RATE2D
label values  MH50901   RATE2D
label values  M151001   MC5D
label values  M151101   MC5E
label values  M151201   RATE2D
label values  MG51201   RATE2D
label values  MH51201   RATE2D
label values  M151301   MC5E
label values  M151401   MC5D
label values  M151501   RATE3B
label values  M1515R1   MC5C
label values  MG51501   RATE3B
label values  MG515R1   MC5C
label values  MH51501   RATE3B
label values  MH515R1   MC5C
label values  M151601   RATE3B
label values  M1516R1   MC5D
label values  MG51601   RATE3B
label values  MG516R1   MC5D
label values  MH51601   RATE3B
label values  MH516R1   MC5D
label values  M151701   MC5C
label values  M151801   MC5C
label values  M151901   MC5D
label values  M152001   MC5E
label values  M152101   MC5C
label values  M152201   MC5A
label values  M152301   MC5C
label values  M152401   MC5D
label values  M152501   MC5A
label values  M152602   M152602Q
label values  MG52602   M152602Q
label values  MH52602   M152602Q
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   RATE3B
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085501   MC5A
label values  M085801   MC5A
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
label values  M019601   MC5C
label values  M051501   MC5A
label values  M047901   SCR3C
label values  MB47901   SCR3C
label values  MC47901   SCR3C
label values  M053101   M053101Q
label values  MB53101   SCR5E
label values  MC53101   SCR5E
label values  M140401   MC5A
label values  M140501   MC5D
label values  M140601   MC5A
label values  M140701   MC5C
label values  M140801   MC5C
label values  M140901   MC5D
label values  M141001   MC5B
label values  M141101   MC5B
label values  M141201   MC5D
label values  M141301   M141301Q
label values  M1413R1   MC5C
label values  MG41301   M141301Q
label values  MG413R1   MC5C
label values  MH41301   M141301Q
label values  MH413R1   MC5C
label values  M141401   MC5B
label values  M141501   MC5C
label values  M141601   RATE2D
label values  MG41601   RATE2D
label values  MH41601   RATE2D
label values  M141701   MC5E
label values  M141801   MC5B
label values  M141901   M141901Q
label values  MG41901   M141901Q
label values  MH41901   M141901Q
label values  M163801   MC5A
label values  M120701   MC5C
label values  M166001   MC5A
label values  M170101   M170101Q
label values  M1701R1   MC5C
label values  MG70101   RATE3B
label values  MG701R1   MC5C
label values  MH70101   RATE3B
label values  MH701R1   MC5C
label values  M164401   MC5B
label values  M169401   MC5E
label values  M168201   MC5E
label values  M166101   MC5E
label values  M168701   RATE3B
label values  M1687R1   MC5D
label values  MG68701   RATE3B
label values  MG687R1   MC5D
label values  MH68701   RATE3B
label values  MH687R1   MC5D
label values  M164201   MC5A
label values  M170201   MC5B
label values  M165301   RATE3B
label values  M1653R1   MC5D
label values  MG65301   RATE3B
label values  MG653R1   MC5D
label values  MH65301   RATE3B
label values  MH653R1   MC5D
label values  M164801   MC5B
label values  M167001   RATE2D
label values  MG67001   RATE2D
label values  MH67001   RATE2D
label values  M168401   MC5D
label values  M168501   RATE2D
label values  MG68501   RATE2D
label values  MH68501   RATE2D
label values  M168502   RATE2D
label values  MG68502   RATE2D
label values  MH68502   RATE2D
label values  M168503   RATE3B
label values  MG68503   RATE3B
label values  MH68503   RATE3B
label values  M1685CL   M152602Q
label values  MR685CL   MC5C
label values  M170301   MC5D
label values  M167801   MC5D
label values  M163301   MC5B
label values  M170401   MC5A
label values  M164501   MC5A
label values  M164601   RATE3B
label values  MB64601   RATE3B
label values  MC64601   RATE3B
label values  M165101   MC5C
label values  M122501   MC5C
label values  M166302   YESNO
label values  M166301   RATE3B
label values  M1663R1   MC5C
label values  MG66301   RATE3B
label values  MG663R1   MC5C
label values  MH66301   RATE3B
label values  MH663R1   MC5C
label values  M120901   MC5E
label values  M170501   M170101Q
label values  MG70501   M170101Q
label values  MH70501   M170101Q
label values  M166601   MC5B
label values  M164901   MC5E
label values  M166901   MC5E
label values  M169901   RATE2D
label values  MG69901   RATE2D
label values  MH69901   RATE2D
label values  M169902   RATE2D
label values  MG69902   RATE2D
label values  MH69902   RATE2D
label values  M169903   RATE3B
label values  M1699R3   MC5D
label values  MG69903   RATE3B
label values  MG699R3   MC5D
label values  MH69903   RATE3B
label values  MH699R3   MC5D
label values  M169904   RATE2D
label values  MG69904   RATE2D
label values  MH69904   RATE2D
label values  M1699CL   M152602Q
label values  M119301   MC5C
label values  M166401   MC5C
label values  M170601   MC5D
label values  M119101   MC5D
label values  M168901   RATE2D
label values  MG68901   RATE2D
label values  MH68901   RATE2D
label values  M125301   MC5B
label values  M166701   MC5D
label values  M165501   RATE3B
label values  M1655R1   MC5D
label values  MG65501   RATE3B
label values  MG655R1   MC5D
label values  MH65501   RATE3B
label values  MH655R1   MC5D
label values  M166801   MC5D
label values  M170701   MC5A
label values  M165001   RATE2D
label values  MG65001   RATE2D
label values  MH65001   RATE2D
label values  M124901   MC5D
label values  M170801   RATE3B
label values  MG70801   RATE3B
label values  MH70801   RATE3B
label values  M124001   MC5E
label values  M165701   RATE3B
label values  M1657R1   MC5D
label values  MG65701   RATE3B
label values  MG657R1   MC5D
label values  MH65701   RATE3B
label values  MH657R1   MC5D
label values  M165702   RATE3B
label values  M1657R2   MC5D
label values  MG65702   RATE3B
label values  MG657R2   MC5D
label values  MH65702   RATE3B
label values  MH657R2   MC5D
label values  M1657CL   M152602Q
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
label values  M143501   M143501Q
label values  MG43501   M143501Q
label values  MH43501   M143501Q
label values  M163101   RATE3B
label values  M1631R1   MC5D
label values  MG63101   RATE3B
label values  MG631R1   MC5D
label values  MH63101   RATE3B
label values  MH631R1   MC5D
label values  M170901   MC5B
label values  M122701   MC5C
label values  M119601   MC5C
label values  M121801   MC5E
label values  M171001   MC5A
label values  M169201   MC5E
label values  M171101   MC5B
label values  M168301   RATE3B
label values  M1683R1   MC5D
label values  MG68301   RATE3B
label values  MG683R1   MC5D
label values  MH68301   RATE3B
label values  MH683R1   MC5D
label values  M169101   MC5C
label values  M162901   RATE3B
label values  M1629R1   MC5C
label values  MG62901   RATE3B
label values  MG629R1   MC5C
label values  MH62901   RATE3B
label values  MH629R1   MC5C
label values  M164701   MC5C
label values  M167301   MC5B
label values  M165201   MC5D
label values  M167902   MC5B
label values  M167901   RATE3B
label values  M1679R1   MC5D
label values  MG67901   RATE3B
label values  MG679R1   MC5D
label values  MH67901   RATE3B
label values  MH679R1   MC5D
label values  M171201   MC5A
label values  M104901   M104901Q
label values  M1049R1   MC5D
label values  MG04901   M104901Q
label values  MG049R1   MC5D
label values  MH04901   M104901Q
label values  MH049R1   MC5D
label values  M152701   MC5D
label values  M152801   MC5C
label values  M152901   MC5A
label values  M153001   MC5A
label values  M153101   MC5C
label values  M1532A1   M1532A1Q
label values  M153201   RATE3B
label values  M1532R1   MC5C
label values  MG53201   RATE3B
label values  MG532R1   MC5C
label values  MH53201   RATE3B
label values  MH532R1   MC5C
label values  M153301   MC5E
label values  M153401   MC5B
label values  M153501   MC5E
label values  M153601   RATE2D
label values  MG53601   RATE2D
label values  MH53601   RATE2D
label values  M153701   MC5E
label values  M153801   MC5B
label values  M153901   RATE3B
label values  MG53901   RATE3B
label values  MH53901   RATE3B
label values  M154001   MC5E
label values  M154101   MC5D
label values  M154201   MC5D
label values  M154301   MC5B
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
label values  T086801   MAJORA
label values  T077409   MAJORA
label values  T077410   MAJORA
label values  T077411   MAJORA
label values  T086901   MAJORA
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
label values  T086301   YESNO
label values  T097701   YESNO
label values  T090801   YESNO
label values  T090802   YESNO
label values  T090803   YESNO
label values  T090804   YESNO
label values  T090805   YESNO
label values  T090806   YESNO
label values  T100601   T100601Q
label values  T117001   T117001Q
label values  T088001   T088001Q
label values  T044002   YESNO
label values  T044201   YESNO
label values  T057401   FREQ4F
label values  T057402   FREQ4F
label values  T057403   FREQ4F
label values  T057404   FREQ4F
label values  T112401   T112401Q
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
label values  T112501   EMPHASA
label values  T112502   EMPHASA
label values  T088301   T088301Q
label values  T112601   T106501Q
label values  T112602   T106501Q
label values  T112603   T106501Q
label values  T112604   T112604Q
label values  T112605   T112604Q
label values  T112606   T106501Q
label values  T112607   T106501Q
label values  T112608   T106501Q
label values  T112609   T106501Q
label values  T112610   T106501Q
label values  T112611   T106501Q
label values  T112612   T106501Q
label values  T112613   T112604Q
label values  T106701   T106701Q
label values  T112701   FREQ4D
label values  T112702   FREQ4D
label values  T112703   FREQ4D
label values  T112704   FREQ4D
label values  T112705   FREQ4D
label values  T106901   T106901Q
label values  T107001   T107001Q
label values  T107002   T107001Q
label values  T107003   T107001Q
label values  T107004   T107001Q
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
// mvdecode M149901 MG49901 MH49901 M150801 MG50801 MH50801 M150901 - MH50901 /*
//       */ M151201 - MH51201 M151501 MG51501 MH51501 M151601 MG51601 MH51601 /*
//       */ M152602 - MH52602 M085701 - MC85701 M085901 - MC85901 /*
//       */ M019701 - MC19701 M020001 - MC20001 M066501 - MC66501 /*
//       */ M066301 - MC66301 M067901 - MC67901 M047901 - MC47901 /*
//       */ M053101 - MC53101 M141301 MG41301 MH41301 M141601 - MH41601 /*
//       */ M141901 - MH41901 M170101 MG70101 MH70101 M168701 MG68701 MH68701 /*
//       */ M165301 MG65301 MH65301 M167001 - MH67001 M168501 - MH68501 /*
//       */ M168502 - MH68502 M168503 - MH68503 M1685CL M164601 - MC64601 /*
//       */ M166301 MG66301 MH66301 M170501 - MH70501 M169901 - MH69901 /*
//       */ M169902 - MH69902 M169903 MG69903 MH69903 M169904 - MH69904 M1699CL /*
//       */ M168901 - MH68901 M165501 MG65501 MH65501 M165001 - MH65001 /*
//       */ M170801 - MH70801 M165701 MG65701 MH65701 M165702 MG65702 MH65702 /*
//       */ M1657CL M142801 - MH42801 M143201 - MH43201 M143501 - MH43501 /*
//       */ M163101 MG63101 MH63101 M168301 MG68301 MH68301 M162901 MG62901 /*
//       */ MH62901 M167901 MG67901 MH67901 M104901 MG04901 MH04901 M153201 /*
//       */ MG53201 MH53201 M153601 - MH53601 M153901 - MH53901,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M149901 MG49901 MH49901 M150801 MG50801 MH50801 M150901 - MH50901 /*
//       */ M151201 - MH51201 M151501 MG51501 MH51501 M151601 MG51601 MH51601 /*
//       */ M085701 - MC85701 M085901 - MC85901 M019701 - MC19701 /*
//       */ M020001 - MC20001 M066501 - MC66501 M066301 - MC66301 /*
//       */ M067901 - MC67901 M047901 - MC47901 M141301 MG41301 MH41301 /*
//       */ M141601 - MH41601 M170101 MG70101 MH70101 M168701 MG68701 MH68701 /*
//       */ M165301 MG65301 MH65301 M167001 - MH67001 M168501 - MH68501 /*
//       */ M168502 - MH68502 M168503 - MH68503 M164601 - MC64601 M166301 /*
//       */ MG66301 MH66301 M170501 - MH70501 M169901 - MH69901 /*
//       */ M169902 - MH69902 M169903 MG69903 MH69903 M169904 - MH69904 /*
//       */ M168901 - MH68901 M165501 MG65501 MH65501 M165001 - MH65001 /*
//       */ M170801 - MH70801 M165701 MG65701 MH65701 M165702 MG65702 MH65702 /*
//       */ M142801 - MH42801 M143201 - MH43201 M163101 MG63101 MH63101 M168301 /*
//       */ MG68301 MH68301 M162901 MG62901 MH62901 M167901 MG67901 MH67901 /*
//       */ M104901 MG04901 MH04901 M153201 MG53201 MH53201 M153601 - MH53601 /*
//       */ M153901 - MH53901,  mv( 9=.n)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 M1685CL /*
//       */ M1699CL M1657CL M143501 - MH43501,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode PARED B017001 B000905  B017201 B003501 B003601  XS04601 /*
//       */ XL00601 - XL02404,  mv( 8=.o)
// mvdecode M815801,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode M149901 MG49901 MH49901 M150801 MG50801 MH50801 M150901 - MH50901 /*
//       */ M151201 - MH51201 M151501 MG51501 MH51501 M151601 MG51601 MH51601 /*
//       */ M085701 - MC85701 M085901 - MC85901 M019701 - MC19701 /*
//       */ M020001 - MC20001 M066501 - MC66501 M066301 - MC66301 /*
//       */ M067901 - MC67901 M047901 - MC47901 M141301 MG41301 MH41301 /*
//       */ M141601 - MH41601 M170101 MG70101 MH70101 M168701 MG68701 MH68701 /*
//       */ M165301 MG65301 MH65301 M167001 - MH67001 M168501 - MH68501 /*
//       */ M168502 - MH68502 M168503 - MH68503 M164601 - MC64601 M166301 /*
//       */ MG66301 MH66301 M170501 - MH70501 M169901 - MH69901 /*
//       */ M169902 - MH69902 M169903 MG69903 MH69903 M169904 - MH69904 /*
//       */ M168901 - MH68901 M165501 MG65501 MH65501 M165001 - MH65001 /*
//       */ M170801 - MH70801 M165701 MG65701 MH65701 M165702 MG65702 MH65702 /*
//       */ M142801 - MH42801 M143201 - MH43201 M163101 MG63101 MH63101 M168301 /*
//       */ MG68301 MH68301 M162901 MG62901 MH62901 M167901 MG67901 MH67901 /*
//       */ M104901 MG04901 MH04901 M153201 MG53201 MH53201 M153601 - MH53601 /*
//       */ M153901 - MH53901,  mv( 7=.p)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 M1685CL /*
//       */ M1699CL M1657CL M143501 - MH43501,  mv(77=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode UTOL4 PARED HISPYES DRACEM  SENROL8 - PCTINDC LEP - SD3 IEP2009 /*
//       */ BA21101 - B018201 M821401 - M149901 MG49901 MH49901 /*
//       */ M150001 - M150801 MG50801 MH50801 M150901 - MH50901 /*
//       */ M151001 - MH51201 M151301 - M151501 MG51501 MH51501 M151601 MG51601 /*
//       */ MH51601 M151701 - M152501 M085701 - MC85701 M085901 - MC85901 /*
//       */ M085601 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M019601 - MC47901 /*
//       */ M140401 - M141301 MG41301 MH41301 M141401 - MH41601 M141701 M141801  /*
//       */ M163801 - M170101 MG70101 MH70101 M164401 - M168701 MG68701 MH68701 /*
//       */ M164201 - M165301 MG65301 MH65301 M164801 - MH67001 /*
//       */ M168401 - MH68501 M168502 - MH68502 M168503 - MH68503 /*
//       */ M170301 - MC64601 M165101 - M166301 MG66301 MH66301 /*
//       */ M120901 - MH70501 M166601 - MH69901 M169902 - MH69902 M169903 /*
//       */ MG69903 MH69903 M169904 - MH69904 M119301 - MH68901 /*
//       */ M125301 - M165501 MG65501 MH65501 M166801 - MH65001 /*
//       */ M124901 - MH70801 M124001 M165701  MG65701 MH65701 M165702 MG65702 /*
//       */ MH65702 M142001 - MH42801 M142901 - MH43201 M143301 M143401  /*
//       */ M163101 MG63101 MH63101 M170901 - M168301 MG68301 MH68301 /*
//       */ M169101 M162901  MG62901 MH62901 M164701 - M167901 MG67901 MH67901 /*
//       */ M171201 M104901  MG04901 MH04901 M152701 - M153201 MG53201 MH53201 /*
//       */ M153301 - MH53601 M153701 - MH53901 M154001 - TE21201 /*
//       */ T096401 - T107004 XS03901 - XS02328 XS04301 XS04401  /*
//       */ XS00301 - XS00312 XS02701 XS04601  XL02901 X013801  /*
//       */ XL03001 - XL02016 XL03301 XL03401  XL00601 - XL02404,  mv( 7=.q)
// mvdecode UTOL12 M815701 M815801  M152602 - MH52602 M053101 - MC53101 /*
//       */ M141901 - MH41901 M1685CL M1699CL M1657CL M143501 - MH43501,  /*
//       */ mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M149801 M149901  MG49901 MH49901 M150001 - M150801 MG50801 MH50801 /*
//       */ M150901 - MH50901 M151001 - MH51201 M151301 - M151501 MG51501 /*
//       */ MH51501 M151601 MG51601 MH51601 M151701 - M152501 M085701 - MC85701 /*
//       */ M085901 - MC85901 M085601 - MC19701 M020001 - MC20001 /*
//       */ M046301 - MC66501 M047101 - MC66301 M067901 - MC67901 /*
//       */ M019601 - MC47901 M140401 - M141301 MG41301 MH41301 /*
//       */ M141401 - MH41601 M141701 M141801  M163801 - M170101 MG70101 /*
//       */ MH70101 M164401 - M168701 MG68701 MH68701 M164201 - M165301 MG65301 /*
//       */ MH65301 M164801 - MH67001 M168401 - MH68501 M168502 - MH68502 /*
//       */ M168503 - MH68503 M170301 - MC64601 M165101 - M166301 MG66301 /*
//       */ MH66301 M120901 - MH70501 M166601 - MH69901 M169902 - MH69902 /*
//       */ M169903 MG69903 MH69903 M169904 - MH69904 M119301 - MH68901 /*
//       */ M125301 - M165501 MG65501 MH65501 M166801 - MH65001 /*
//       */ M124901 - MH70801 M124001 M165701  MG65701 MH65701 M165702 MG65702 /*
//       */ MH65702 M142001 - MH42801 M142901 - MH43201 M143301 M143401  /*
//       */ M163101 MG63101 MH63101 M170901 - M168301 MG68301 MH68301 /*
//       */ M169101 M162901  MG62901 MH62901 M164701 - M167901 MG67901 MH67901 /*
//       */ M171201 M104901  MG04901 MH04901 M152701 - M153201 MG53201 MH53201 /*
//       */ M153301 - MH53601 M153701 - MH53901 M154001 - M154301,  mv( 5=.r)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 M1685CL /*
//       */ M1699CL M1657CL M143501 - MH43501,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode PARED BA21101 - B018201 M821401 - M149801 M150001 - M150701 /*
//       */ M151001 M151101  M151301 M151401  M151701 - M152501 /*
//       */ M085601 - M085801 M046301 - M046501 M047101 M019601 M051501  /*
//       */ M140401 - M141201 M141401 M141501  M141701 M141801  /*
//       */ M163801 - M166001 M164401 - M166101 M164201 M170201  M164801 /*
//       */ M168401 M170301 - M164501 M165101 - M166302 M120901 /*
//       */ M166601 - M166901 M119301 - M119101 M125301 M166701  /*
//       */ M166801 M170701  M124901 M124001 M142001 - M142701 /*
//       */ M142901 - M143101 M143301 M143401  M170901 - M171101 M169101 /*
//       */ M164701 - M167902 M171201 M152701 - M1532A1 M153301 - M153501 /*
//       */ M153701 M153801  M154001 - M154301 T096401 - T107004 /*
//       */ XS03901 - XS04101 XS04301 XS04401  XS02701 XS04601  XL02901 X013801  /*
//       */ XL03001 XL03101  XL03301 XL03401  XL00601 - XL02404,  mv( 6=.s)
// mvdecode M815701 M815801,  mv(66=.s)
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
// recode M149801 M150201 M151001 M151401 M151901 M152401 M140501 M140901 /*
//     */ M141201 M168401 M170301 M167801 M170601 M119101 M166701 M166801 /*
//     */ M124901 M142601 M143101 M143301 M165201 M152701 M154101 M154201 (1=0) /*
//     */ (2=0) (3=0) (4=1) (5=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M149901 M150801 M151501 M151601 M085901 M066501 M066301 M067901 /*
//     */ M170101 M168701 M165301 M164601 M166301 M170501 M165501 M170801 /*
//     */ M163101 M168301 M162901 M167901 M104901 M153201 M153901 (1=0) (2=1) /*
//     */ (3=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode M150001 M151101 M151301 M152001 M141701 M169401 - M166101 M120901 /*
//     */ M164901 M166901 M124001 M142001 M142301 M142701 M121801 M169201 /*
//     */ M153301 M153501 M153701 M154001 (1=0) (2=0) (3=0) (4=0) (5=1) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M150101 M150401 M150701 M141001 M141101 M141401 M141801 M164401 /*
//     */ M170201 M164801 M163301 M166601 M125301 M142401 M142901 M170901 /*
//     */ M171101 M167301 M153401 M153801 M154301 (1=0) (2=1) (3=0) (4=0) (5=0) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M150301 M150601 M152201 M152501 M085801 M051501 M140401 M140601 /*
//     */ M163801 M166001 M164201 M170401 M164501 M170701 M142101 M143401 /*
//     */ M171001 M171201 M152901 M153001 (1=1) (2=0) (3=0) (4=0) (5=0) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M150501 M151701 M151801 M152101 M152301 M019601 M140701 M140801 /*
//     */ M141501 M120701 M165101 M122501 M119301 M166401 M142201 M142501 /*
//     */ M143001 M122701 M119601 M169101 M164701 M152801 M153101 (1=0) (2=0) /*
//     */ (3=1) (4=0) (5=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M150901 M151201 M019701 M020001 M141601 M167001 M168901 M165001 /*
//     */ M142801 M143201 M153601 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode M152602 (1=0) (2=1) (3=1) (4=2) (5=3) ( 0=.m) (99=.n) (77=.p) (77=.q) /*
//     */ (55=.r) (else=.)
// recode M085701 M047901 (1=0) (2=0) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode M085601 M046301 (1=0) (2=1) (3=0) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode M085501 M046501 (1=1) (2=0) (3=0) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode M047001 (1=0) (2=0) (3=0) (4=1) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M047101 (1=0) (2=0) (3=1) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M053101 (1=0) (2=1) (3=2) (4=2) (5=3) ( 0=.m) (99=.n) (77=.p) (77=.q) /*
//     */ (55=.r) (else=.)
// recode M141301 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode M141901 M1685CL M1699CL M1657CL M143501 (1=0) (2=1) (3=2) (4=3) (5=4) /*
//     */ ( 0=.m) (99=.n) (77=.p) (77=.q) (55=.r) (else=.)
// label values  M149801   SCORE
// label values  M149901   SCORE
// label values  M150001   SCORE
// label values  M150101   SCORE
// label values  M150201   SCORE
// label values  M150301   SCORE
// label values  M150401   SCORE
// label values  M150501   SCORE
// label values  M150601   SCORE
// label values  M150701   SCORE
// label values  M150801   SCORE
// label values  M150901   SCORE
// label values  M151001   SCORE
// label values  M151101   SCORE
// label values  M151201   SCORE
// label values  M151301   SCORE
// label values  M151401   SCORE
// label values  M151501   SCORE
// label values  M151601   SCORE
// label values  M151701   SCORE
// label values  M151801   SCORE
// label values  M151901   SCORE
// label values  M152001   SCORE
// label values  M152101   SCORE
// label values  M152201   SCORE
// label values  M152301   SCORE
// label values  M152401   SCORE
// label values  M152501   SCORE
// label values  M152602   SCORE
// label values  M085701   SCORE
// label values  M085901   SCORE
// label values  M085601   SCORE
// label values  M085501   SCORE
// label values  M085801   SCORE
// label values  M019701   SCORE
// label values  M020001   SCORE
// label values  M046301   SCORE
// label values  M047001   SCORE
// label values  M046501   SCORE
// label values  M066501   SCORE
// label values  M047101   SCORE
// label values  M066301   SCORE
// label values  M067901   SCORE
// label values  M019601   SCORE
// label values  M051501   SCORE
// label values  M047901   SCORE
// label values  M053101   SCORE
// label values  M140401   SCORE
// label values  M140501   SCORE
// label values  M140601   SCORE
// label values  M140701   SCORE
// label values  M140801   SCORE
// label values  M140901   SCORE
// label values  M141001   SCORE
// label values  M141101   SCORE
// label values  M141201   SCORE
// label values  M141301   SCORE
// label values  M141401   SCORE
// label values  M141501   SCORE
// label values  M141601   SCORE
// label values  M141701   SCORE
// label values  M141801   SCORE
// label values  M141901   SCORE
// label values  M163801   SCORE
// label values  M120701   SCORE
// label values  M166001   SCORE
// label values  M170101   SCORE
// label values  M164401   SCORE
// label values  M169401   SCORE
// label values  M168201   SCORE
// label values  M166101   SCORE
// label values  M168701   SCORE
// label values  M164201   SCORE
// label values  M170201   SCORE
// label values  M165301   SCORE
// label values  M164801   SCORE
// label values  M167001   SCORE
// label values  M168401   SCORE
// label values  M1685CL   SCORE
// label values  M170301   SCORE
// label values  M167801   SCORE
// label values  M163301   SCORE
// label values  M170401   SCORE
// label values  M164501   SCORE
// label values  M164601   SCORE
// label values  M165101   SCORE
// label values  M122501   SCORE
// label values  M166301   SCORE
// label values  M120901   SCORE
// label values  M170501   SCORE
// label values  M166601   SCORE
// label values  M164901   SCORE
// label values  M166901   SCORE
// label values  M1699CL   SCORE
// label values  M119301   SCORE
// label values  M166401   SCORE
// label values  M170601   SCORE
// label values  M119101   SCORE
// label values  M168901   SCORE
// label values  M125301   SCORE
// label values  M166701   SCORE
// label values  M165501   SCORE
// label values  M166801   SCORE
// label values  M170701   SCORE
// label values  M165001   SCORE
// label values  M124901   SCORE
// label values  M170801   SCORE
// label values  M124001   SCORE
// label values  M1657CL   SCORE
// label values  M142001   SCORE
// label values  M142101   SCORE
// label values  M142201   SCORE
// label values  M142301   SCORE
// label values  M142401   SCORE
// label values  M142501   SCORE
// label values  M142601   SCORE
// label values  M142701   SCORE
// label values  M142801   SCORE
// label values  M142901   SCORE
// label values  M143001   SCORE
// label values  M143101   SCORE
// label values  M143201   SCORE
// label values  M143301   SCORE
// label values  M143401   SCORE
// label values  M143501   SCORE
// label values  M163101   SCORE
// label values  M170901   SCORE
// label values  M122701   SCORE
// label values  M119601   SCORE
// label values  M121801   SCORE
// label values  M171001   SCORE
// label values  M169201   SCORE
// label values  M171101   SCORE
// label values  M168301   SCORE
// label values  M169101   SCORE
// label values  M162901   SCORE
// label values  M164701   SCORE
// label values  M167301   SCORE
// label values  M165201   SCORE
// label values  M167901   SCORE
// label values  M171201   SCORE
// label values  M104901   SCORE
// label values  M152701   SCORE
// label values  M152801   SCORE
// label values  M152901   SCORE
// label values  M153001   SCORE
// label values  M153101   SCORE
// label values  M153201   SCORE
// label values  M153301   SCORE
// label values  M153401   SCORE
// label values  M153501   SCORE
// label values  M153601   SCORE
// label values  M153701   SCORE
// label values  M153801   SCORE
// label values  M153901   SCORE
// label values  M154001   SCORE
// label values  M154101   SCORE
// label values  M154201   SCORE
// label values  M154301   SCORE

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2009
gen grade=8
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2009\naep_math_gr8_2009", replace


