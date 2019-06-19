version 8
clear
set memory 520m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP3B\Y42MATRED\Y42RED\STATA\LABELDEF.do"
label data "  2011 National Reading Grade 4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP3B\Y42MATRED\Y42RED\STATA\R42NT1AT.DCT", clear
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
label values  ACCBID    NOYES
label values  ACCRDS    NOYES
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
label values  Y42ORA    BLKUSE
label values  Y42ORB    BLKUSE
label values  Y42ORC    BLKUSE
label values  Y42ORD    BLKUSE
label values  Y42ORE    BLKUSE
label values  Y42ORF    BLKUSE
label values  Y42ORG    BLKUSE
label values  Y42ORH    BLKUSE
label values  Y42ORI    BLKUSE
label values  Y42ORJ    BLKUSE
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
label values  R846001   R846001Q
label values  R846101   R846001Q
label values  R846201   R846201Q
label values  R846301   R846201Q
label values  R846401   YESNO
label values  R831001   R831001Q
label values  R831101   R831001Q
label values  R846601   R846001Q
label values  R846701   R846001Q
label values  R846801   R846001Q
label values  R846901   R846001Q
label values  R847001   R846001Q
label values  R847101   R846001Q
label values  R831901   R831901Q
label values  R831801   R831901Q
label values  R847201   R846001Q
label values  R847301   R846001Q
label values  R847401   R846001Q
label values  R832801   R832801Q
label values  R836601   R836601Q
label values  R836701   R836701Q
label values  R836801   R836801Q
label values  R057701   MC5C
label values  R057702   MC5D
label values  R057703   MC5A
label values  R057704   RATE2A
label values  RB57704   RATE2A
label values  RC57704   RATE2A
label values  R057705   R057705Q
label values  RB57705   R057705Q
label values  RC57705   R057705Q
label values  R057706   R057705Q
label values  RB57706   R057705Q
label values  RC57706   R057705Q
label values  R057707   RATE4A
label values  RB57707   RATE4A
label values  RC57707   RATE4A
label values  R057708   MC5D
label values  R057709   MC5B
label values  R057710   R057705Q
label values  RB57710   R057705Q
label values  RC57710   R057705Q
label values  R057711   MC5C
label values  R057801   MC5D
label values  R057802   MC5D
label values  R057803   MC5A
label values  R057804   MC5B
label values  R057805   MC5A
label values  R057806   RATE4A
label values  RB57806   RATE4A
label values  RC57806   RATE4A
label values  R057807   RATE2A
label values  RB57807   RATE2A
label values  RC57807   RATE2A
label values  R057808   MC5C
label values  R057809   R057705Q
label values  RB57809   R057705Q
label values  RC57809   R057705Q
label values  R068701   MC5B
label values  R068702   MC5A
label values  R068703   MC5C
label values  R068704   R057705Q
label values  RB68704   R057705Q
label values  RC68704   R057705Q
label values  R068705   MC5B
label values  R068706   MC5C
label values  R068707   RATE4A
label values  RB68707   RATE4A
label values  RC68707   RATE4A
label values  R068708   R057705Q
label values  RB68708   R057705Q
label values  RC68708   R057705Q
label values  R068709   MC5C
label values  R068710   MC5B
label values  R068711   R057705Q
label values  RB68711   R057705Q
label values  RC68711   R057705Q
label values  R058201   MC5C
label values  R058202   MC5D
label values  R058207   R057705Q
label values  RB58207   R057705Q
label values  RC58207   R057705Q
label values  R058203   MC5A
label values  R058204   R057705Q
label values  RB58204   R057705Q
label values  RC58204   R057705Q
label values  R058205   MC5C
label values  R058206   RATE4A
label values  RB58206   RATE4A
label values  RC58206   RATE4A
label values  R058208   MC5C
label values  R058209   RATE2A
label values  RB58209   RATE2A
label values  RC58209   RATE2A
label values  R058210   MC5B
label values  R058501   MC5C
label values  R058502   MC5D
label values  R058503   MC5A
label values  R058504   R057705Q
label values  RB58504   R057705Q
label values  RC58504   R057705Q
label values  R058505   MC5B
label values  R058506   MC5D
label values  R058507   MC5A
label values  R058508   RATE4A
label values  RB58508   RATE4A
label values  RC58508   RATE4A
label values  R058509   RATE2A
label values  RB58509   RATE2A
label values  RC58509   RATE2A
label values  R058510   MC5D
label values  R058601   MC5D
label values  R058602   R057705Q
label values  RB58602   R057705Q
label values  RC58602   R057705Q
label values  R058603   MC5A
label values  R058604   MC5B
label values  R058605   MC5C
label values  R058606   R057705Q
label values  RB58606   R057705Q
label values  RC58606   R057705Q
label values  R058607   MC5B
label values  R058608   RATE4A
label values  RB58608   RATE4A
label values  RC58608   RATE4A
label values  R058609   MC5D
label values  R058610   MC5A
label values  R058801   MC5A
label values  R058802   MC5D
label values  R058803   MC5B
label values  R058804   MC5C
label values  R058805   R057705Q
label values  RB58805   R057705Q
label values  RC58805   R057705Q
label values  R058806   MC5B
label values  R058807   RATE4A
label values  RB58807   RATE4A
label values  RC58807   RATE4A
label values  R058808   MC5B
label values  R058809   MC5A
label values  R058810   R057705Q
label values  RB58810   R057705Q
label values  RC58810   R057705Q
label values  R059101   MC5D
label values  R059102   MC5B
label values  R059103   MC5C
label values  R059104   MC5A
label values  R059109   R057705Q
label values  RB59109   R057705Q
label values  RC59109   R057705Q
label values  R059106   RATE4A
label values  RB59106   RATE4A
label values  RC59106   RATE4A
label values  R059105   MC5A
label values  R059107   MC5D
label values  R059108   R057705Q
label values  RB59108   R057705Q
label values  RC59108   R057705Q
label values  R059110   RATE2A
label values  RB59110   RATE2A
label values  RC59110   RATE2A
label values  R058301   MC5B
label values  R058302   RATE2A
label values  RB58302   RATE2A
label values  RC58302   RATE2A
label values  R058303   MC5B
label values  R058304   R057705Q
label values  RB58304   R057705Q
label values  RC58304   R057705Q
label values  R058311   MC5C
label values  R058306   MC5A
label values  R058307   RATE4A
label values  RB58307   RATE4A
label values  RC58307   RATE4A
label values  R058308   MC5D
label values  R058309   MC5C
label values  R059501   MC5D
label values  R059502   MC5B
label values  R059503   MC5A
label values  R059504   R057705Q
label values  RB59504   R057705Q
label values  RC59504   R057705Q
label values  R059506   MC5A
label values  R059507   RATE4A
label values  RB59507   RATE4A
label values  RC59507   RATE4A
label values  R059505   MC5C
label values  R059509   R057705Q
label values  RB59509   R057705Q
label values  RC59509   R057705Q
label values  R059508   MC5B
label values  R059510   R057705Q
label values  RB59510   R057705Q
label values  RC59510   R057705Q
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
label values  T105501   T105501Q
label values  T092401   T092401Q
label values  T089801   T089801Q
label values  T083401   T083401Q
label values  T105601   FREQ4D
label values  T105602   FREQ4D
label values  T105603   FREQ4D
label values  T105604   FREQ4D
label values  T105605   FREQ4D
label values  T105606   FREQ4D
label values  T105701   R846001Q
label values  T105702   R846001Q
label values  T105703   R846001Q
label values  T105704   R846001Q
label values  T105705   R846001Q
label values  T089901   FREQ4A
label values  T089903   FREQ4A
label values  T089906   FREQ4A
label values  T089907   FREQ4A
label values  T089909   FREQ4A
label values  T105801   FREQ4A
label values  T089913   FREQ4A
label values  T089904   FREQ4A
label values  T089911   FREQ4A
label values  T100101   FREQ4D
label values  T100102   FREQ4D
label values  T100103   FREQ4D
label values  T105901   T105901Q
label values  T106001   R846201Q
label values  T106002   R846201Q
label values  T106003   R846201Q
label values  T106006   R846201Q
label values  T106007   R846201Q
label values  T106101   T106101Q
label values  T106201   FREQ4D
label values  T106202   FREQ4D
label values  T106203   FREQ4D
label values  T106204   FREQ4D
label values  T106205   FREQ4D
label values  T106401   T106401Q
label values  T106402   T106401Q
label values  T106403   T106401Q
label values  T106404   T106401Q
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
// mvdecode R057704 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057710 - RC57710 R057806 - RC57806 /*
//       */ R057807 - RC57807 R057809 - RC57809 R068704 - RC68704 /*
//       */ R068707 - RC68707 R068708 - RC68708 R068711 - RC68711 /*
//       */ R058207 - RC58207 R058204 - RC58204 R058206 - RC58206 /*
//       */ R058209 - RC58209 R058504 - RC58504 R058508 - RC58508 /*
//       */ R058509 - RC58509 R058602 - RC58602 R058606 - RC58606 /*
//       */ R058608 - RC58608 R058805 - RC58805 R058807 - RC58807 /*
//       */ R058810 - RC58810 R059109 - RC59109 R059106 - RC59106 /*
//       */ R059108 - RC59108 R059110 - RC59110 R058302 - RC58302 /*
//       */ R058304 - RC58304 R058307 - RC58307 R059504 - RC59504 /*
//       */ R059507 - RC59507 R059509 - RC59509 R059510 - RC59510,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode R057704 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057710 - RC57710 R057806 - RC57806 /*
//       */ R057807 - RC57807 R057809 - RC57809 R068704 - RC68704 /*
//       */ R068707 - RC68707 R068708 - RC68708 R068711 - RC68711 /*
//       */ R058207 - RC58207 R058204 - RC58204 R058206 - RC58206 /*
//       */ R058209 - RC58209 R058504 - RC58504 R058508 - RC58508 /*
//       */ R058509 - RC58509 R058602 - RC58602 R058606 - RC58606 /*
//       */ R058608 - RC58608 R058805 - RC58805 R058807 - RC58807 /*
//       */ R058810 - RC58810 R059109 - RC59109 R059106 - RC59106 /*
//       */ R059108 - RC59108 R059110 - RC59110 R058302 - RC58302 /*
//       */ R058304 - RC58304 R058307 - RC58307 R059504 - RC59504 /*
//       */ R059507 - RC59507 R059509 - RC59509 R059510 - RC59510,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode B000905 B017201 XS05301 XL04101 - XL04304,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode R057704 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057710 - RC57710 R057806 - RC57806 /*
//       */ R057807 - RC57807 R057809 - RC57809 R068704 - RC68704 /*
//       */ R068707 - RC68707 R068708 - RC68708 R068711 - RC68711 /*
//       */ R058207 - RC58207 R058204 - RC58204 R058206 - RC58206 /*
//       */ R058209 - RC58209 R058504 - RC58504 R058508 - RC58508 /*
//       */ R058509 - RC58509 R058602 - RC58602 R058606 - RC58606 /*
//       */ R058608 - RC58608 R058805 - RC58805 R058807 - RC58807 /*
//       */ R058810 - RC58810 R059109 - RC59109 R059106 - RC59106 /*
//       */ R059108 - RC59108 R059110 - RC59110 R058302 - RC58302 /*
//       */ R058304 - RC58304 R058307 - RC58307 R059504 - RC59504 /*
//       */ R059507 - RC59507 R059509 - RC59509 R059510 - RC59510,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode SRACE10 SD3 PCHARTR PCHRTFL UTOL4 LEP - ELL3 SLUNCH IEP2009  /*
//       */ HISPYES SENROL4 - PCTWHTC BA21101 - RC57704 R057705 - RC57705 /*
//       */ R057706 - RC57706 R057707 - RC57707 R057708 - RC57710 /*
//       */ R057711 - RC57806 R057807 - RC57807 R057808 - RC57809 /*
//       */ R068701 - RC68704 R068705 - RC68707 R068708 - RC68708 /*
//       */ R068709 - RC68711 R058201 - RC58207 R058203 - RC58204 /*
//       */ R058205 - RC58206 R058208 - RC58209 R058210 - RC58504 /*
//       */ R058505 - RC58508 R058509 - RC58509 R058510 - RC58602 /*
//       */ R058603 - RC58606 R058607 - RC58608 R058609 - RC58805 /*
//       */ R058806 - RC58807 R058808 - RC58810 R059101 - RC59109 /*
//       */ R059106 - RC59106 R059105 - RC59108 R059110 - RC59110 /*
//       */ R058301 - RC58302 R058303 - RC58304 R058311 - RC58307 /*
//       */ R058308 - RC59504 R059506 - RC59507 R059505 - RC59509 /*
//       */ R059508 - RC59510 XS04701 - XS05001 XS05101 - XS05104 /*
//       */ XS05201 - XL04001 XL04101 - TE21201 T096401 - T106404,  mv( 7=.q)
// mvdecode UTOL12,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode SRACE10 PCHARTR PCHRTFL R057701 - RC57704 R057705 - RC57705 /*
//       */ R057706 - RC57706 R057707 - RC57707 R057708 - RC57710 /*
//       */ R057711 - RC57806 R057807 - RC57807 R057808 - RC57809 /*
//       */ R068701 - RC68704 R068705 - RC68707 R068708 - RC68708 /*
//       */ R068709 - RC68711 R058201 - RC58207 R058203 - RC58204 /*
//       */ R058205 - RC58206 R058208 - RC58209 R058210 - RC58504 /*
//       */ R058505 - RC58508 R058509 - RC58509 R058510 - RC58602 /*
//       */ R058603 - RC58606 R058607 - RC58608 R058609 - RC58805 /*
//       */ R058806 - RC58807 R058808 - RC58810 R059101 - RC59109 /*
//       */ R059106 - RC59106 R059105 - RC59108 R059110 - RC59110 /*
//       */ R058301 - RC58302 R058303 - RC58304 R058311 - RC58307 /*
//       */ R058308 - RC59504 R059506 - RC59507 R059505 - RC59509 /*
//       */ R059508 - RC59510,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode BA21101 - R057703 R057708 R057709  R057711 - R057805 R057808 /*
//       */ R068701 - R068703 R068705 R068706  R068709 R068710  R058201 R058202  /*
//       */ R058203 R058205 R058208 R058210 - R058503 R058505 - R058507 /*
//       */ R058510 R058601  R058603 - R058605 R058607 R058609 - R058804 /*
//       */ R058806 R058808 R058809  R059101 - R059104 R059105 R059107  R058301 /*
//       */ R058303 R058311 R058306  R058308 - R059503 R059506 R059505 R059508 /*
//       */ XS04701 XS04801  XS05001 XS05101 - XS05104 XS05201 - XL03801 /*
//       */ XL04001 XL04101 - XL04304 T096401 - T097207 T097401 - T106404,  /*
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
// recode R057701 R057711 R057808 R068703 R068706 R068709 R058201 R058205 /*
//     */ R058208 R058501 R058605 R058804 R059103 R058311 R058309 R059505 (1=0) /*
//     */ (2=0) (3=1) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R057702 R057708 R057801 R057802 R058202 R058502 R058506 /*
//     */ R058510 R058601 R058609 R058802 R059101 R059107 R058308 R059501 (1=0) /*
//     */ (2=0) (3=0) (4=1) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R057703 R057805 R068702 R058203 R058503 R058507 R058603 /*
//     */ R058610 R058801 R058809 R059104 R059105 R058306 R059503 R059506 (1=1) /*
//     */ (2=0) (3=0) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R057704 R057807 R058209 R058509 R059110 R058302 (1=0) (2=1) ( 0=.m) /*
//     */ ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R057705 R057706 R057710 R057809 R068704 R068708 R068711 R058207 /*
//     */ R058204 R058504 R058602 R058606 R058805 R058810 R059109 R059108 /*
//     */ R058304 R059504 R059509 R059510 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) /*
//     */ ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R057707 R057806 R068707 R058206 R058508 R058608 R058807 R059106 /*
//     */ R058307 R059507 (1=0) (2=1) (3=2) (4=3) ( 0=.m) ( 9=.n) ( 7=.p) /*
//     */ ( 7=.q) ( 5=.r) (else=.)
// recode R057709 R057804 R068701 R068705 R068710 R058210 R058505 R058604 /*
//     */ R058607 R058803 R058806 R058808 R059102 R058301 R058303 R059502 /*
//     */ R059508 (1=0) (2=1) (3=0) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// label values  R057701   SCORE
// label values  R057702   SCORE
// label values  R057703   SCORE
// label values  R057704   SCORE
// label values  R057705   SCORE
// label values  R057706   SCORE
// label values  R057707   SCORE
// label values  R057708   SCORE
// label values  R057709   SCORE
// label values  R057710   SCORE
// label values  R057711   SCORE
// label values  R057801   SCORE
// label values  R057802   SCORE
// label values  R057804   SCORE
// label values  R057805   SCORE
// label values  R057806   SCORE
// label values  R057807   SCORE
// label values  R057808   SCORE
// label values  R057809   SCORE
// label values  R068701   SCORE
// label values  R068702   SCORE
// label values  R068703   SCORE
// label values  R068704   SCORE
// label values  R068705   SCORE
// label values  R068706   SCORE
// label values  R068707   SCORE
// label values  R068708   SCORE
// label values  R068709   SCORE
// label values  R068710   SCORE
// label values  R068711   SCORE
// label values  R058201   SCORE
// label values  R058202   SCORE
// label values  R058207   SCORE
// label values  R058203   SCORE
// label values  R058204   SCORE
// label values  R058205   SCORE
// label values  R058206   SCORE
// label values  R058208   SCORE
// label values  R058209   SCORE
// label values  R058210   SCORE
// label values  R058501   SCORE
// label values  R058502   SCORE
// label values  R058503   SCORE
// label values  R058504   SCORE
// label values  R058505   SCORE
// label values  R058506   SCORE
// label values  R058507   SCORE
// label values  R058508   SCORE
// label values  R058509   SCORE
// label values  R058510   SCORE
// label values  R058601   SCORE
// label values  R058602   SCORE
// label values  R058603   SCORE
// label values  R058604   SCORE
// label values  R058605   SCORE
// label values  R058606   SCORE
// label values  R058607   SCORE
// label values  R058608   SCORE
// label values  R058609   SCORE
// label values  R058610   SCORE
// label values  R058801   SCORE
// label values  R058802   SCORE
// label values  R058803   SCORE
// label values  R058804   SCORE
// label values  R058805   SCORE
// label values  R058806   SCORE
// label values  R058807   SCORE
// label values  R058808   SCORE
// label values  R058809   SCORE
// label values  R058810   SCORE
// label values  R059101   SCORE
// label values  R059102   SCORE
// label values  R059103   SCORE
// label values  R059104   SCORE
// label values  R059109   SCORE
// label values  R059106   SCORE
// label values  R059105   SCORE
// label values  R059107   SCORE
// label values  R059108   SCORE
// label values  R059110   SCORE
// label values  R058301   SCORE
// label values  R058302   SCORE
// label values  R058303   SCORE
// label values  R058304   SCORE
// label values  R058311   SCORE
// label values  R058306   SCORE
// label values  R058307   SCORE
// label values  R058308   SCORE
// label values  R058309   SCORE
// label values  R059501   SCORE
// label values  R059502   SCORE
// label values  R059503   SCORE
// label values  R059504   SCORE
// label values  R059506   SCORE
// label values  R059507   SCORE
// label values  R059505   SCORE
// label values  R059509   SCORE
// label values  R059508   SCORE
// label values  R059510   SCORE

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2011
gen grade=4
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE10

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2011\naep_read_gr4_2011", replace
