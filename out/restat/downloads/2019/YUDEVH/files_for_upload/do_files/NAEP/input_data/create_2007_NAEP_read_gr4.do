version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Reading G4\stata\LABELDEF.do"
label data "  2007 National Reading Assessment: Grade  4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Reading G4\stata\R38NT1AT.DCT", clear
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
label values  DSEX      SEX
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
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SENROL4   SENROL4V
label values  YRSEXP    YRSEXP
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
label values  Y38ORC    BLKUSE
label values  Y38ORD    BLKUSE
label values  Y38ORE    BLKUSE
label values  Y38ORF    BLKUSE
label values  Y38ORG    BLKUSE
label values  Y38ORH    BLKUSE
label values  Y38ORI    BLKUSE
label values  Y38ORJ    BLKUSE
label values  Y38ORK    BLKUSE
label values  Y38ORL    BLKUSE
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
label values  B018201   B018201V
label values  R830601   R830601V
label values  R830701   R830601V
label values  R830801   R830601V
label values  R830901   R830601V
label values  R831001   R831001V
label values  R831101   R831001V
label values  R831401   R831001V
label values  R831501   R831501V
label values  R831601   R831501V
label values  R831701   R831501V
label values  R831801   R831501V
label values  R831901   R831501V
label values  R832001   R831501V
label values  R832101   R832101V
label values  R832201   R832101V
label values  R832301   R832101V
label values  R832801   R832801V
label values  R832901   R831001V
label values  R832401   R831501V
label values  R832501   R831501V
label values  R832601   R831501V
label values  R832701   R831501V
label values  R836601   R836601V
label values  R836701   R836701V
label values  R836801   R836801V
label values  R053601   MC5B
label values  R053701   MC5C
label values  R053801   MC5D
label values  R053901   RATE3B
label values  RB53901   RATE3B
label values  RC53901   RATE3B
label values  R054001   RATE3B
label values  RB54001   RATE3B
label values  RC54001   RATE3B
label values  R054101   MC5C
label values  R054201   R054201V
label values  RB54201   R054201V
label values  RC54201   R054201V
label values  R054301   RATE3B
label values  RB54301   RATE3B
label values  RC54301   RATE3B
label values  R054401   MC5A
label values  R054501   MC5B
label values  R052901   R052901V
label values  R052902   R052902V
label values  R052903   R052903V
label values  R052904   R052904V
label values  RB52904   R052904V
label values  RC52904   R052904V
label values  R052905   R052901V
label values  R052906   RATE2D
label values  RB52906   RATE2D
label values  RC52906   RATE2D
label values  R052907   RATE4A
label values  RB52907   RATE4A
label values  RC52907   RATE4A
label values  R052908   R052901V
label values  R052909   RATE2D
label values  RB52909   RATE2D
label values  RC52909   RATE2D
label values  R052910   R052901V
label values  R012601   RATE2A
label values  RB12601   RATE2A
label values  RC12601   RATE2A
label values  R012602   MC5C
label values  R012603   MC5B
label values  R012604   RATE2A
label values  RB12604   RATE2A
label values  RC12604   RATE2A
label values  R012605   MC5B
label values  R012606   MC5D
label values  R012607   RATE4A
label values  RB12607   RATE4A
label values  RC12607   RATE4A
label values  R012608   MC5C
label values  R012609   MC5D
label values  R012610   MC5A
label values  R012612   RATE2A
label values  RB12612   RATE2A
label values  RC12612   RATE2A
label values  R017301   RATE2A
label values  RB17301   RATE2A
label values  RC17301   RATE2A
label values  R017302   MC5B
label values  R017303   R017303V
label values  RB17303   R017303V
label values  RC17303   R017303V
label values  R017304   MC5A
label values  R017310   R017303V
label values  RB17310   R017303V
label values  RC17310   R017303V
label values  R017306   MC5B
label values  R017307   RATE4A
label values  RB17307   RATE4A
label values  RC17307   RATE4A
label values  R017308   MC5C
label values  R017309   R017303V
label values  RB17309   R017303V
label values  RC17309   R017303V
label values  R034501   MC5B
label values  R034601   R034601V
label values  RB34601   R034601V
label values  RC34601   R017303V
label values  R034701   MC5B
label values  R034801   MC5D
label values  R034901   R034601V
label values  RB34901   R034601V
label values  RC34901   R017303V
label values  R035001   R034601V
label values  RB35001   R034601V
label values  RC35001   R017303V
label values  R035101   MC5C
label values  R035201   R034601V
label values  RB35201   R034601V
label values  RC35201   R017303V
label values  R035301   RATE4A
label values  RB35301   RATE4A
label values  RC35301   RATE4A
label values  R035401   MC5B
label values  R054601   MC5B
label values  R054701   MC5C
label values  R054801   RATE3B
label values  RB54801   RATE3B
label values  RC54801   RATE3B
label values  R054901   MC5D
label values  R055001   MC5A
label values  R057501   MC5B
label values  R055101   R054201V
label values  RB55101   R054201V
label values  RC55101   R054201V
label values  R055201   MC5A
label values  R055301   RATE3B
label values  RB55301   RATE3B
label values  RC55301   RATE3B
label values  R055401   RATE3B
label values  RB55401   RATE3B
label values  RC55401   RATE3B
label values  R053001   R052901V
label values  R053002   R053002V
label values  R053003   RATE2D
label values  RB53003   RATE2D
label values  RC53003   RATE2D
label values  R053004   R052904V
label values  RB53004   R052904V
label values  RC53004   R052904V
label values  R053005   R052903V
label values  R053006   RATE4A
label values  RB53006   RATE4A
label values  RC53006   RATE4A
label values  R053007   R052902V
label values  R053008   R052902V
label values  R053009   RATE2D
label values  RB53009   RATE2D
label values  RC53009   RATE2D
label values  R053010   R052904V
label values  RB53010   R052904V
label values  RC53010   R052904V
label values  R053101   RATE2D
label values  RB53101   RATE2D
label values  RC53101   RATE2D
label values  R053102   R053102V
label values  R053103   R052901V
label values  R053104   R053102V
label values  R053105   R052904V
label values  RB53105   R052904V
label values  RC53105   R052904V
label values  R053106   RATE4A
label values  RB53106   RATE4A
label values  RC53106   RATE4A
label values  R053107   R052902V
label values  R053108   R052904V
label values  RB53108   R052904V
label values  RC53108   R052904V
label values  R053109   R052901V
label values  R053110   R053110V
label values  R021601   MC5A
label values  R020401   R017303V
label values  RB20401   R034601V
label values  RC20401   R017303V
label values  R020601   MC5C
label values  R021101   MC5A
label values  R020701   R020701V
label values  RB20701   R020701V
label values  RC20701   R020701V
label values  R020501   MC5B
label values  R022101   MC5C
label values  R021701   R017303V
label values  RB21701   R034601V
label values  RC21701   R017303V
label values  R022201   MC5B
label values  R021201   R017303V
label values  RB21201   R034601V
label values  RC21201   R017303V
label values  R023301   MC5D
label values  R022401   MC5B
label values  R023501   R017303V
label values  RB23501   R034601V
label values  RC23501   R017303V
label values  R023601   R017303V
label values  RB23601   R034601V
label values  RC23601   R017303V
label values  R023801   MC5A
label values  R022901   MC5B
label values  R024001   R017303V
label values  RB24001   R034601V
label values  RC24001   R017303V
label values  R023101   MC5C
label values  R024101   MC5B
label values  R023201   RATE2A
label values  RB23201   RATE2A
label values  RC23201   RATE2A
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
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T077312   MAJORA
label values  T077409   MAJORA
label values  T077410   MAJORA
label values  T077411   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T077412   MAJORA
label values  T087501   T087501Q
label values  T087601   T087501Q
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
label values  TA86201   YESNO
label values  TB86201   YESNO
label values  TC86201   YESNO
label values  TA86202   YESNO
label values  TB86202   YESNO
label values  TC86202   YESNO
label values  TA86203   YESNO
label values  TB86203   YESNO
label values  TC86203   YESNO
label values  TA86204   YESNO
label values  TB86204   YESNO
label values  TC86204   YESNO
label values  TA86205   YESNO
label values  TB86205   YESNO
label values  TC86205   YESNO
label values  TA86206   YESNO
label values  TB86206   YESNO
label values  TC86206   YESNO
label values  TA86207   YESNO
label values  TB86207   YESNO
label values  TC86207   YESNO
label values  TA86208   YESNO
label values  TB86208   YESNO
label values  TC86208   YESNO
label values  TA86209   YESNO
label values  TB86209   YESNO
label values  TC86209   YESNO
label values  TA86210   YESNO
label values  TB86210   YESNO
label values  TC86210   YESNO
label values  TA86211   YESNO
label values  TB86211   YESNO
label values  TC86211   YESNO
label values  TA86212   YESNO
label values  TB86212   YESNO
label values  TC86212   YESNO
label values  T088201   YESNO
label values  T088202   YESNO
label values  T094601   YESNO
label values  T094602   YESNO
label values  T092401   T092401Q
label values  T086501   T086501Q
label values  T083401   T083401Q
label values  T089801   T089801Q
label values  T068351   T068351Q
label values  T089901   T089901Q
label values  T089902   T089901Q
label values  T089903   T089901Q
label values  T089904   T089901Q
label values  T089905   T089901Q
label values  T089906   T089901Q
label values  T089907   T089901Q
label values  T089908   T089901Q
label values  T089909   T089901Q
label values  T089910   T089901Q
label values  T089911   T089901Q
label values  T089912   T089901Q
label values  T089913   T089901Q
label values  T089914   T089901Q
label values  T089915   T089901Q
label values  T083701   FREQ4C
label values  T083702   FREQ4C
label values  T083703   FREQ4C
label values  T083704   FREQ4C
label values  T083705   FREQ4C
label values  T088001   T088001Q
label values  T088101   T088101Q
label values  T088301   T088301Q
label values  T044002   YESNO
label values  T057801   T057801Q
label values  T044201   YESNO
label values  T057451   FREQ4F
label values  T057452   FREQ4F
label values  T057453   FREQ4F
label values  T057454   FREQ4F
label values  T044401   T044401Q
label values  T089201   T089201Q
label values  T089601   T089601Q
label values  T075351   T075351Q
label values  T075352   T075351Q
label values  T075353   T075351Q
label values  T075354   T075351Q
label values  T075355   T075351Q
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
// mvdecode BA21101 - R053801 R054101 R054401 - R052903 R052905 R052908 R052910 /*
//       */ R012602 R012603  R012605 R012606  R012608 - R012610 R017302 R017304 /*
//       */ R017306 R017308 R034501 R034701 R034801  R035101 R035401 - R054701 /*
//       */ R054901 - R057501 R055201 R053001 R053002  R053005 R053007 R053008  /*
//       */ R053102 - R053104 R053107 R053109 - R021601 R020601 R021101  /*
//       */ R020501 R022101  R022201 R023301 R022401  R023801 R022901  /*
//       */ R023101 R024101  TA21101 - TE21201 T077201 - T096305 /*
//       */ XS02101 XS02201  XS02401 - XS02601 XS02701 XS02001  X013801 XL01901 /*
//       */ XL02101 - XL02301 XL00601 - XL02404,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode PCHRTFL R053601 - RC53901 R054001 - RC54001 R054101 - RC54201 /*
//       */ R054301 - RC54301 R054401 - RC52904 R052905 - RC52906 /*
//       */ R052907 - RC52907 R052908 - RC52909 R052910 - RC12601 /*
//       */ R012602 - RC12604 R012605 - RC12607 R012608 - RC12612 /*
//       */ R017301 - RC17301 R017302 - RC17303 R017304 - RC17310 /*
//       */ R017306 - RC17307 R017308 - RC17309 R034501 - RC34601 /*
//       */ R034701 - RC34901 R035001 - RC35001 R035101 - RC35201 /*
//       */ R035301 - RC35301 R035401 - RC54801 R054901 - RC55101 /*
//       */ R055201 - RC55301 R055401 - RC55401 R053001 - RC53003 /*
//       */ R053004 - RC53004 R053005 - RC53006 R053007 - RC53009 /*
//       */ R053010 - RC53010 R053101 - RC53101 R053102 - RC53105 /*
//       */ R053106 - RC53106 R053107 - RC53108 R053109 - RC20401 /*
//       */ R020601 - RC20701 R020501 - RC21701 R022201 - RC21201 /*
//       */ R023301 - RC23501 R023601 - RC23601 R023801 - RC24001 /*
//       */ R023101 - RC23201,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode PCHRTFL MODAGE - PCTINDC SDRACEM LEP  BA21101 - RC53901 /*
//       */ R054001 - RC54001 R054101 - RC54201 R054301 - RC54301 /*
//       */ R054401 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R017301 - RC17301 /*
//       */ R017302 - RC17303 R017304 - RC17310 R017306 - RC17307 /*
//       */ R017308 - RC17309 R034501 - RC34601 R034701 - RC34901 /*
//       */ R035001 - RC35001 R035101 - RC35201 R035301 - RC35301 /*
//       */ R035401 - RC54801 R054901 - RC55101 R055201 - RC55301 /*
//       */ R055401 - RC55401 R053001 - RC53003 R053004 - RC53004 /*
//       */ R053005 - RC53006 R053007 - RC53009 R053010 - RC53010 /*
//       */ R053101 - RC53101 R053102 - RC53105 R053106 - RC53106 /*
//       */ R053107 - RC53108 R053109 - RC20401 R020601 - RC20701 /*
//       */ R020501 - RC21701 R022201 - RC21201 R023301 - RC23501 /*
//       */ R023601 - RC23601 R023801 - RC24001 R023101 - RC23201 /*
//       */ TA21101 - TE21201 T077201 - T096305 XS02101 - XS02601 /*
//       */ XS00301 - XS00312 XS02701 XS02001  X013801 XL01901 - XL02301 /*
//       */ XL00601 - XL02404,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode B017001 B000905  B017201 XS02001 XL00601 - XL02404,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode R053901 - RC53901 R054001 - RC54001 R054201 - RC54201 /*
//       */ R054301 - RC54301 R052901 - RC52904 R052905 - RC52906 /*
//       */ R052907 - RC52907 R052908 - RC52909 R052910 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R017301 - RC17301 R017303 - RC17303 R017310 - RC17310 /*
//       */ R017307 - RC17307 R017309 - RC17309 R034601 - RC34601 /*
//       */ R034901 - RC34901 R035001 - RC35001 R035201 - RC35201 /*
//       */ R035301 - RC35301 R054801 - RC54801 R055101 - RC55101 /*
//       */ R055301 - RC55301 R055401 - RC55401 R053001 - RC53003 /*
//       */ R053004 - RC53004 R053005 - RC53006 R053007 - RC53009 /*
//       */ R053010 - RC53010 R053101 - RC53101 R053102 - RC53105 /*
//       */ R053106 - RC53106 R053107 - RC53108 R053109 R053110  /*
//       */ R020401 - RC20401 R020701 - RC20701 R021701 - RC21701 /*
//       */ R021201 - RC21201 R023501 - RC23501 R023601 - RC23601 /*
//       */ R024001 - RC24001 R023201 - RC23201,  mv( 7=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R053901 - RC53901 R054001 - RC54001 R054201 - RC54201 /*
//       */ R054301 - RC54301 R052904 - RC52904 R052906 - RC52906 /*
//       */ R052907 - RC52907 R052909 - RC52909 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R017301 - RC17301 R017303 - RC17303 R017310 - RC17310 /*
//       */ R017307 - RC17307 R017309 - RC17309 R034601 - RC34601 /*
//       */ R034901 - RC34901 R035001 - RC35001 R035201 - RC35201 /*
//       */ R035301 - RC35301 R054801 - RC54801 R055101 - RC55101 /*
//       */ R055301 - RC55301 R055401 - RC55401 R053003 - RC53003 /*
//       */ R053004 - RC53004 R053006 - RC53006 R053009 - RC53009 /*
//       */ R053010 - RC53010 R053101 - RC53101 R053105 - RC53105 /*
//       */ R053106 - RC53106 R053108 - RC53108 R020401 - RC20401 /*
//       */ R020701 - RC20701 R021701 - RC21701 R021201 - RC21201 /*
//       */ R023501 - RC23501 R023601 - RC23601 R024001 - RC24001 /*
//       */ R023201 - RC23201,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode R053901 - RC53901 R054001 - RC54001 R054201 - RC54201 /*
//       */ R054301 - RC54301 R052904 - RC52904 R052906 - RC52906 /*
//       */ R052907 - RC52907 R052909 - RC52909 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R017301 - RC17301 R017303 - RC17303 R017310 - RC17310 /*
//       */ R017307 - RC17307 R017309 - RC17309 R034601 - RC34601 /*
//       */ R034901 - RC34901 R035001 - RC35001 R035201 - RC35201 /*
//       */ R035301 - RC35301 R054801 - RC54801 R055101 - RC55101 /*
//       */ R055301 - RC55301 R055401 - RC55401 R053003 - RC53003 /*
//       */ R053004 - RC53004 R053006 - RC53006 R053009 - RC53009 /*
//       */ R053010 - RC53010 R053101 - RC53101 R053105 - RC53105 /*
//       */ R053106 - RC53106 R053108 - RC53108 R020401 - RC20401 /*
//       */ R020701 - RC20701 R021701 - RC21701 R021201 - RC21201 /*
//       */ R023501 - RC23501 R023601 - RC23601 R024001 - RC24001 /*
//       */ R023201 - RC23201,  mv( 6=.s)
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
// recode R053601 R054501 R012603 R012605 R017302 R017306 R034501 R034701 /*
//     */ R035401 R054601 R057501 R020501 R022201 R022401 R022901 R024101 (1=0) /*
//     */ (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R053701 R054101 R012602 R012608 R017308 R035101 R054701 R020601 /*
//     */ R022101 R023101 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode R053801 R012606 R012609 R034801 R054901 R023301 (1=0) (2=0) (3=0) /*
//     */ (4=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R053901 R054001 R054301 R052904 R017303 R017310 R034601 R034901 /*
//     */ R035001 R054801 R055301 R055401 R053004 R053105 R053108 R021701 /*
//     */ R021201 R023501 R024001 (1=0) (2=1) (3=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R054201 R052907 R012607 R017307 R035301 R055101 R053006 R053106 (1=0) /*
//     */ (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R054401 R012610 R017304 R055001 R055201 R021601 R021101 R023801 (1=1) /*
//     */ (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R052901 R052905 R052908 R052910 R053001 R053002 R053103 R053109 (1=0) /*
//     */ (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) (else=.)
// recode R052902 R052903 R053005 R053007 R053008 R053107 R053110 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) (else=.)
// recode R052906 R052909 R012601 R012604 R012612 R017301 R053003 R053009 /*
//     */ R053101 R020701 R023201 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R017309 R053010 R020401 R023601 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R035201 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode R053102 R053104 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2007
gen grade=4
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2007\naep_read_gr4_2007", replace


