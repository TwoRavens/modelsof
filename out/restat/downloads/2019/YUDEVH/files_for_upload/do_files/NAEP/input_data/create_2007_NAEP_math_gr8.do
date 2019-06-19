version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Math G8\stata\LABELDEF.do"
label data "  2007 National Mathematics Assessment: Grade  8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Math G8\stata\M38NT2AT.DCT", clear
label values  ORIGSUB   ORIGSUB
label values  PUBPRIV   PUBPRIV
label values  BMONTH    BMONTH
label values  SEX       SEX
label values  SRACE     SRACE
label values  IEP       YESNO
label values  ELL3      ELL3V
label values  SLNCH05   SLNCH05V
label values  SLUNCH1   SLUNCH1V
label values  NEWENRL   YESNO
label values  TCHMTCH   TCHMTCH
label values  COHORT    COHORT
label values  PCHARTR   PCHARTR
label values  PCHRTFL   PCHRTFL
label values  TYPCLAS   TYPCLAS
label values  MOB       BMONTH
label values  MOBFLAG   MOBFLAG
label values  YOBFLAG   MOBFLAG
label values  DSEX      SEX
label values  SEXFLAG   MOBFLAG
label values  RACEFLG   RACEFLG
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
label values  SCHTYPE   SCHTYPE
label values  RPTSAMP   RPTSAMP
label values  ACCOM2    ACCOM2V
label values  ACCMTYP   ACCMTYP
label values  TOL7      TOL7V
label values  TOL5      TOL5V
label values  TOL3      TOL3V
label values  FIPS      FIPS
label values  SAMPTYP   SAMPTYP
label values  DISTCOD   DISTCOD
label values  SLUNCH    SLUNCH
label values  PARED     PARED
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SENROL8   SENROL8V
label values  YRSEXP    YRSEXP
label values  YRSMATH   YRSEXP
label values  PCTBLKC   PCTBLKC
label values  PCTHSPC   PCTBLKC
label values  PCTASNC   PCTBLKC
label values  PCTINDC   PCTBLKC
label values  NATFLAG   NATFLAG
label values  UTOL4     UTOL4V
label values  UTOL12    UTOL12V
label values  SDRACEM   SDRACEM
label values  LEP       YESNO
label values  FIPSAI    FIPSAI
label values  SCHTYP2   TYPCLAS
label values  LRGCITY   YESNO
label values  CHRTRPT   CHRTRPT
label values  Y38OMC    BLKUSE
label values  Y38OMD    BLKUSE
label values  Y38OME    BLKUSE
label values  Y38OMF    BLKUSE
label values  Y38OMG    BLKUSE
label values  Y38OMH    BLKUSE
label values  Y38OMI    BLKUSE
label values  Y38OMJ    BLKUSE
label values  Y38OMK    BLKUSE
label values  Y38OML    BLKUSE
label values  SDELL     SDELL
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
label values  M820101   FREQ4E
label values  M820102   FREQ4E
label values  M820103   FREQ4E
label values  M820104   FREQ4E
label values  M820105   FREQ4E
label values  M820106   FREQ4E
label values  M820107   FREQ4E
label values  M820108   FREQ4E
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
label values  M817401   M817401V
label values  M817501   M817401V
label values  M817601   M817401V
label values  M815301   M815301V
label values  M815401   M815401V
label values  M815501   M815501V
label values  M815601   M815601V
label values  M149801   MC5D
label values  M149901   RATE3B
label values  M1499R1   SCR3C
label values  MG49901   RATE3B
label values  MG499R1   SCR3C
label values  MH49901   RATE3B
label values  MH499R1   SCR3C
label values  M150001   MC5E
label values  M150101   MC5B
label values  M150201   MC5D
label values  M150301   MC5A
label values  M150401   MC5B
label values  M150501   MC5C
label values  M150601   MC5A
label values  M150701   MC5B
label values  M150801   RATE3B
label values  M1508R1   SCR3C
label values  MG50801   RATE3B
label values  MG508R1   SCR3C
label values  MH50801   RATE3B
label values  MH508R1   SCR3C
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
label values  M1515R1   SCR3C
label values  MG51501   RATE3B
label values  MG515R1   SCR3C
label values  MH51501   RATE3B
label values  MH515R1   SCR3C
label values  M151601   RATE3B
label values  M1516R1   SCR4D
label values  MG51601   RATE3B
label values  MG516R1   SCR4D
label values  MH51601   RATE3B
label values  MH516R1   SCR4D
label values  M151701   MC5C
label values  M151801   MC5C
label values  M151901   MC5D
label values  M152001   MC5E
label values  M152101   MC5C
label values  M152201   MC5A
label values  M152301   MC5C
label values  M152401   MC5D
label values  M152501   MC5A
label values  M152602   M152602V
label values  MG52602   M152602V
label values  MH52602   M152602V
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   MC85701V
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085501   MC5A
label values  M085801   MC5A
label values  M019701   M019701V
label values  MB19701   RATE2D
label values  MC19701   M019701V
label values  M020001   M019701V
label values  MB20001   RATE2D
label values  MC20001   M019701V
label values  M046301   MC5B
label values  M047001   MC5D
label values  M046501   MC5A
label values  M066501   RATE3B
label values  MB66501   RATE3B
label values  MC66501   MC66501V
label values  M047101   MC5C
label values  M066301   RATE3B
label values  MB66301   RATE3B
label values  MC66301   MC66501V
label values  M067901   RATE3B
label values  MB67901   RATE3B
label values  MC67901   MC66501V
label values  M019601   MC5C
label values  M051501   MC5A
label values  M047901   SCR3C
label values  MB47901   MC85701V
label values  MC47901   MC47901V
label values  M053101   M053101V
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
label values  MG41301   MG41301V
label values  MH41301   M141301V
label values  M141401   MC5B
label values  M141501   MC5C
label values  M141601   RATE2D
label values  MG41601   M019701V
label values  MH41601   RATE2D
label values  M141701   MC5E
label values  M141801   MC5B
label values  M141901   RATE5A
label values  MG41901   MG41901V
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
label values  MG44201   M019701V
label values  MH44201   RATE2D
label values  M1442A1   YESNO
label values  M144301   MC5E
label values  M1443A1   YESNO
label values  M144401   MC5D
label values  M1444A1   YESNO
label values  M144501   MC5C
label values  M1445A1   YESNO
label values  M144601   M144601V
label values  MG44601   MG44601V
label values  MH44601   M144601V
label values  M1446A1   YESNO
label values  M144701   MC5C
label values  M1447A1   YESNO
label values  M144801   MC5A
label values  M1448A1   YESNO
label values  M144901   M141301V
label values  MG44901   MG41301V
label values  MH44901   M141301V
label values  M1449A1   YESNO
label values  M145001   MC5B
label values  M1450A1   YESNO
label values  M145101   M141301V
label values  MG45101   MG41301V
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
label values  M021001   M019701V
label values  MB21001   RATE2D
label values  MC21001   M019701V
label values  M0210A1   YESNO
label values  M092201   MC5B
label values  M0922A1   YESNO
label values  M020901   M019701V
label values  MB20901   RATE2D
label values  MC20901   M019701V
label values  M0209A1   YESNO
label values  M052501   MC5B
label values  M0525A1   YESNO
label values  M092401   RATE3B
label values  MB92401   RATE3B
label values  MC92401   MC85701V
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
label values  MC13131   M019701V
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
label values  MC73501   MC85701V
label values  M0735A1   YESNO
label values  MA52421   MA52421V
label values  M052401   RATE2D
label values  MB52401   RATE2D
label values  MC52401   M019701V
label values  M0524A1   YESNO
label values  M075301   RATE3B
label values  MB75301   RATE3B
label values  MC75301   MC85701V
label values  M0753A1   YESNO
label values  M072901   RATE3B
label values  MB72901   RATE3B
label values  MC72901   MC85701V
label values  M0729A1   YESNO
label values  M013631   MC5A
label values  M0136A1   YESNO
label values  M075801   RATE3B
label values  MB75801   RATE3B
label values  MC75801   MC85701V
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
label values  MC93801   MG41901V
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
label values  MG42801   M019701V
label values  MH42801   RATE2D
label values  M142901   MC5B
label values  M143001   MC5C
label values  M143101   MC5D
label values  M143201   RATE2D
label values  MG43201   M019701V
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
label values  MG06301   M019701V
label values  MH06301   RATE2D
label values  M106401   MC5A
label values  M106501   MC5B
label values  M106601   MC5C
label values  M106701   MC5A
label values  M106801   MC5A
label values  M106901   RATE2D
label values  MG06901   M019701V
label values  MH06901   RATE2D
label values  M107001   MC5A
label values  M107101   MC5D
label values  M107201   MC5C
label values  M107401   MC5C
label values  M107501   RATE2D
label values  MG07501   M019701V
label values  MH07501   RATE2D
label values  M107601   MC5E
label values  M152701   MC5D
label values  M152801   MC5C
label values  M152901   MC5A
label values  M153001   MC5A
label values  M153101   MC5C
label values  M1532A1   M1532A1V
label values  M153201   RATE3B
label values  M1532R1   SCR3C
label values  MG53201   RATE3B
label values  MG532R1   SCR3C
label values  MH53201   RATE3B
label values  MH532R1   SCR3C
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
label values  T094601   YESNO
label values  T094602   YESNO
label values  T088001   T088001Q
label values  T088301   T088301Q
label values  T091101   T091101Q
label values  T091102   T091102Q
label values  T091401   M815301V
label values  T091402   T091402Q
label values  T096201   YESNO
label values  T096202   YESNO
label values  T096203   YESNO
label values  T096204   YESNO
label values  T096205   YESNO
label values  T096301   YESNO
label values  T096302   YESNO
label values  T096303   YESNO
label values  T096304   YESNO
label values  T096305   YESNO
label values  XS02101   XS02101V
label values  XS02201   XS02201V
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
label values  XS02401   YESNO
label values  XS02501   YESNO
label values  XS02601   YESNO
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
label values  XS02701   XS02701V
label values  XS02001   XS02001V
label values  X013801   X013801Q
label values  XL01901   XL01901V
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
label values  XL02101   YESNO
label values  XL02201   YESNO
label values  XL02301   YESNO
label values  XL00601   XL00601V
label values  XL01701   XS02001V
label values  XL02401   XL02401V
label values  XL02402   XL02401V
label values  XL02403   XL02401V
label values  XL02404   XL02401V
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
// mvdecode PARED BA21101 - M149801 M150001 - M150701 M151001 M151101  /*
//       */ M151301 M151401  M151701 - M152501 M085601 - M085801 /*
//       */ M046301 - M046501 M047101 M019601 M051501  M140401 - M141201 /*
//       */ M141401 M141501  M141701 M141801  M143601 - M1441A1 /*
//       */ M1442A1 - M1445A1 M1446A1 - M1448A1 M1449A1 - M1450A1 /*
//       */ M1451A1 - M073204 M0732A1 - M0733A1 M0210A1 - M0922A1 /*
//       */ M0209A1 - M0525A1 M0924A1 - M0192A1 M0926A1 - M073602 /*
//       */ M0736A1 - M0757A1 M0131A1 - M0916A1 M0735A1 MA52421  M0524A1 /*
//       */ M0753A1 M0729A1 - M0136A1 M0758A1 - M0934A1 M0938A1 - M142701 /*
//       */ M142901 - M143101 M143301 M143401  M105601 - M106201 /*
//       */ M106401 - M106801 M107001 - M107401 M107601 - M1532A1 /*
//       */ M153301 - M153501 M153701 M153801  M154001 - TE21201 /*
//       */ T077201 - T096305 XS02101 XS02201  XS02401 - XS02601 /*
//       */ XS02701 XS02001  X013801 XL01901 XL02101 - XL02301 /*
//       */ XL00601 - XL02404,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode PCHRTFL M149801 - MH499R1 M150001 - MH508R1 M150901 - MH50901 /*
//       */ M151001 - MH51201 M151301 - MH515R1 M151601 - MH516R1 /*
//       */ M151701 - M152501 M085701 - MC85701 M085901 - MC85901 /*
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
//       */ M107001 - MH07501 M107601 - MH532R1 M153301 - MH53601 /*
//       */ M153701 - MH53901 M154001 - M154301,  mv( 9=.n)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 /*
//       */ M073601 - MC73601 M093801 - MC93801 M143501 - MH43501,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode PCHRTFL PARED - PCTINDC SDRACEM LEP  BA21101 - B018201 /*
//       */ M820101 - MH499R1 M150001 - MH508R1 M150901 - MH50901 /*
//       */ M151001 - MH51201 M151301 - MH515R1 M151601 - MH516R1 /*
//       */ M151701 - M152501 M085701 - MC85701 M085901 - MC85901 /*
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
//       */ M107001 - MH07501 M107601 - MH532R1 M153301 - MH53601 /*
//       */ M153701 - MH53901 M154001 - TE21201 T077201 - T096305 /*
//       */ XS02101 - XS02601 XS00301 - XS00312 XS02701 XS02001  X013801 /*
//       */ XL01901 - XL02301 XL00601 - XL02404,  mv( 8=.o)
// mvdecode M815701 M815801  M152602 - MH52602 M053101 - MC53101 /*
//       */ M141901 - MH41901 M073601 - MC73601 M093801 - MC93801 /*
//       */ M143501 - MH43501,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B003501 B003601  XS02001 /*
//       */ XL00601 - XL02404,  mv( 7=.p)
// mvdecode M815801,  mv(77=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode M149901 - MH499R1 M150801 - MH508R1 M150901 - MH50901 /*
//       */ M151201 - MH51201 M151501 - MH515R1 M151601 - MH516R1 /*
//       */ M085701 - MC85701 M085901 - MC85901 M019701 - MC19701 /*
//       */ M020001 - MC20001 M066501 - MC66501 M066301 - MC66301 /*
//       */ M067901 - MC67901 M047901 - MC47901 M141301 - MH41301 /*
//       */ M141601 - MH41601 M144201 - MH44201 M144601 - MH44601 /*
//       */ M144901 - MH44901 M145101 - MH45101 M021001 - MC21001 /*
//       */ M020901 - MC20901 M092401 - MC92401 M092601 - MC92601 /*
//       */ M013131 - MC13131 M073501 - MC73501 M052401 - MC52401 /*
//       */ M075301 - MC75301 M072901 - MC72901 M075801 - MC75801 /*
//       */ M142801 - MH42801 M143201 - MH43201 M106301 - MH06301 /*
//       */ M106901 - MH06901 M107501 - MH07501 M1532A1 - MH532R1 /*
//       */ M153601 - MH53601 M153901 - MH53901,  mv( 7=.q)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 /*
//       */ M073601 - MC73601 M093801 - MC93801 M143501 - MH43501,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M149901 - MH499R1 M150801 - MH508R1 M150901 - MH50901 /*
//       */ M151201 - MH51201 M151501 - MH515R1 M151601 - MH516R1 /*
//       */ M085701 - MC85701 M085901 - MC85901 M019701 - MC19701 /*
//       */ M020001 - MC20001 M066501 - MC66501 M066301 - MC66301 /*
//       */ M067901 - MC67901 M047901 - MC47901 M141301 - MH41301 /*
//       */ M141601 - MH41601 M144201 - MH44201 M144601 - MH44601 /*
//       */ M144901 - MH44901 M145101 - MH45101 M021001 - MC21001 /*
//       */ M020901 - MC20901 M092401 - MC92401 M092601 - MC92601 /*
//       */ M013131 - MC13131 M073501 - MC73501 M052401 - MC52401 /*
//       */ M075301 - MC75301 M072901 - MC72901 M075801 - MC75801 /*
//       */ M142801 - MH42801 M143201 - MH43201 M106301 - MH06301 /*
//       */ M106901 - MH06901 M107501 - MH07501 M1532A1 - MH532R1 /*
//       */ M153601 - MH53601 M153901 - MH53901,  mv( 5=.r)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 /*
//       */ M073601 - MC73601 M093801 - MC93801 M143501 - MH43501,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode M149901 - MH499R1 M150801 - MH508R1 M150901 - MH50901 /*
//       */ M151201 - MH51201 M151501 - MH515R1 M151601 - MH516R1 /*
//       */ M085701 - MC85701 M085901 - MC85901 M019701 - MC19701 /*
//       */ M020001 - MC20001 M066501 - MC66501 M066301 - MC66301 /*
//       */ M067901 - MC67901 M047901 - MC47901 M141301 - MH41301 /*
//       */ M141601 - MH41601 M144201 - MH44201 M144601 - MH44601 /*
//       */ M144901 - MH44901 M145101 - MH45101 M021001 - MC21001 /*
//       */ M020901 - MC20901 M092401 - MC92401 M092601 - MC92601 /*
//       */ M013131 - MC13131 M073501 - MC73501 M052401 - MC52401 /*
//       */ M075301 - MC75301 M072901 - MC72901 M075801 - MC75801 /*
//       */ M142801 - MH42801 M143201 - MH43201 M106301 - MH06301 /*
//       */ M106901 - MH06901 M107501 - MH07501 M1532A1 - MH532R1 /*
//       */ M153601 - MH53601 M153901 - MH53901,  mv( 6=.s)
// mvdecode M152602 - MH52602 M053101 - MC53101 M141901 - MH41901 /*
//       */ M073601 - MC73601 M093801 - MC93801 M143501 - MH43501,  mv(66=.s)
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
//     */ M141201 M143601 M144401 M012231 M051701 M091501 M091601 M013731 /*
//     */ M142601 M143101 M143301 M105601 M105801 M106101 M107101 M152701 /*
//     */ M154101 M154201 (1=0) (2=0) (3=0) (4=1) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M149901 M150801 M151501 M151601 M085901 M066501 M066301 M067901 /*
//     */ M144601 M092401 M092601 M075301 M072901 M075801 M153201 M153901 (1=0) /*
//     */ (2=1) (3=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M150001 M151101 M151301 M152001 M141701 M144101 M144301 M013331 /*
//     */ M073001 M013531 M142001 M142301 M142701 M107601 M153301 M153501 /*
//     */ M153701 M154001 (1=0) (2=0) (3=0) (4=0) (5=1) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M150101 M150401 M150701 M141001 M141101 M141401 M141801 M143801 /*
//     */ M144001 M145001 M092201 M052501 M072801 M051801 M142401 M142901 /*
//     */ M105901 M106001 M106501 M153401 M153801 M154301 (1=0) (2=1) (3=0) /*
//     */ (4=0) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M150301 M150601 M152201 M152501 M085801 M051501 M140401 M140601 /*
//     */ M143901 M144801 M073101 M012431 M091701 M013631 M093401 M142101 /*
//     */ M143401 M106401 M106701 M106801 M107001 M152901 M153001 (1=1) (2=0) /*
//     */ (3=0) (4=0) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M150501 M151701 M151801 M152101 M152301 M019601 M140701 M140801 /*
//     */ M141501 M143701 M144501 M144701 M073301 M019201 M091901 M067001 /*
//     */ M013431 M142201 M142501 M143001 M106201 M106601 M107201 M107401 /*
//     */ M152801 M153101 (1=0) (2=0) (3=1) (4=0) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M150901 M151201 M019701 M020001 M141601 M144201 M021001 M020901 /*
//     */ M013131 M052401 M142801 M143201 M106301 M106901 M107501 M153601 (1=0) /*
//     */ (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M152602 (1=0) (2=1) (3=1) (4=2) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M085701 M047901 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M085601 M046301 (1=0) (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M085501 M046501 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M047001 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M047101 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M053101 (1=0) (2=1) (3=2) (4=2) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M141301 M144901 (1=0) (2=1) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M141901 M073601 M143501 (1=0) (2=1) (3=2) (4=3) (5=4) (99=.n) (88=.o) /*
//     */ (77=.q) (55=.r) (66=.s) (else=.)
// recode M145101 (1=0) (2=1) (3=1) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M0732CL (1=0) (2=1) (3=2) (4=3) (5=4) ( 9=.n) ( 8=.o) (else=.)
// recode M0757CL (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) (else=.)
// recode M073501 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode M093801 (1=0) (2=1) (3=2) (4=3) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2007
gen grade=8
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2007\naep_math_gr8_2007", replace


