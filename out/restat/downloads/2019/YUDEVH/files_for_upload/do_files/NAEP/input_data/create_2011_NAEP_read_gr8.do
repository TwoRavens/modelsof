version 8
clear
set memory 470m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP3B\Y42MATRED\Y42RED\STATA\LABELDEF.do"
label data "  2011 National Reading Grade 8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGP3B\Y42MATRED\Y42RED\STATA\R42NT2AT.DCT", clear
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
label values  MOBFLAG   MOBFLAG
label values  YOBFLAG   MOBFLAG
label values  DSEX      SEX
label values  SEXFLAG   MOBFLAG
label values  NSLPFLG   NSLPFLG
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
label values  PARED     PARED
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  FIPS      FIPS02Q
label values  SAMPTYP   SAMPTYP
label values  ACCOM2    ACCOM2Q
label values  SCHTYP2   TYPCLAS
label values  LRGCITY   YESNO
label values  CHRTRPT   CHRTRPT
label values  SENROL8   SENROL8Q
label values  YRSEXP    YRSEXP
label values  YRSLART   YRSEXP
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
label values  Y42ORK    BLKUSE
label values  Y42ORL    BLKUSE
label values  Y42ORM    BLKUSE
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
label values  B003501   PARED
label values  B003601   PARED
label values  B018201   B018201Q
label values  R833001   AGREE4A
label values  R833101   AGREE4A
label values  R833401   R833401Q
label values  R833501   R833401Q
label values  R835301   R835301Q
label values  R835401   R835301Q
label values  R835701   R835701Q
label values  R835801   R835701Q
label values  R846201   R846201Q
label values  R846301   R846201Q
label values  R847901   YESNO
label values  R832801   R832801Q
label values  R848101   R846201Q
label values  R848102   R846201Q
label values  R848103   R846201Q
label values  R848104   R846201Q
label values  R848105   R846201Q
label values  R848106   R846201Q
label values  R848107   R846201Q
label values  R848108   R846201Q
label values  R848201   R846201Q
label values  R848202   R846201Q
label values  R848203   R846201Q
label values  R848204   R846201Q
label values  R848301   R846201Q
label values  R848302   R846201Q
label values  R848306   R846201Q
label values  R848307   R846201Q
label values  R836601   R836601Q
label values  R836701   R836701Q
label values  R836801   R836801Q
label values  R059601   MC5C
label values  R059602   MC5D
label values  R059603   MC5B
label values  R059604   RATE2A
label values  RB59604   RATE2A
label values  RC59604   RATE2A
label values  R059610   RATE4A
label values  RB59610   RATE4A
label values  RC59610   RATE4A
label values  R059606   R059606Q
label values  RB59606   R059606Q
label values  RC59606   R059606Q
label values  R059605   R059606Q
label values  RB59605   R059606Q
label values  RC59605   R059606Q
label values  R059608   MC5C
label values  R059609   MC5B
label values  R059607   R059606Q
label values  RB59607   R059606Q
label values  RC59607   R059606Q
label values  R059801   MC5C
label values  R059802   MC5A
label values  R059803   RATE4A
label values  RB59803   RATE4A
label values  RC59803   RATE4A
label values  R059804   MC5B
label values  R059805   MC5D
label values  R059806   R059606Q
label values  RB59806   R059606Q
label values  RC59806   R059606Q
label values  R059807   R059606Q
label values  RB59807   R059606Q
label values  RC59807   R059606Q
label values  R059808   MC5C
label values  R059809   RATE2A
label values  RB59809   RATE2A
label values  RC59809   RATE2A
label values  R059810   MC5B
label values  R060101   MC5B
label values  R060102   MC5A
label values  R060103   RATE2A
label values  RB60103   RATE2A
label values  RC60103   RATE2A
label values  R060104   MC5C
label values  R060105   RATE2A
label values  RB60105   RATE2A
label values  RC60105   RATE2A
label values  R060106   MC5D
label values  R060107   MC5B
label values  R060108   RATE4A
label values  RB60108   RATE4A
label values  RC60108   RATE4A
label values  R060109   MC5D
label values  R060110   MC5A
label values  R060301   RATE2A
label values  RB60301   RATE2A
label values  RC60301   RATE2A
label values  R060302   MC5C
label values  R060304   MC5A
label values  R060305   R059606Q
label values  RB60305   R059606Q
label values  RC60305   R059606Q
label values  R060303   MC5B
label values  R060306   RATE4A
label values  RB60306   RATE4A
label values  RC60306   RATE4A
label values  R060307   MC5C
label values  R060308   MC5B
label values  R060309   R059606Q
label values  RB60309   R059606Q
label values  RC60309   R059606Q
label values  R060310   MC5D
label values  R058501   MC5C
label values  R058502   MC5D
label values  R058503   MC5A
label values  R058504   R059606Q
label values  RB58504   R059606Q
label values  RC58504   R059606Q
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
label values  R058602   R059606Q
label values  RB58602   R059606Q
label values  RC58602   R059606Q
label values  R058603   MC5A
label values  R058604   MC5B
label values  R058605   MC5C
label values  R058606   R059606Q
label values  RB58606   R059606Q
label values  RC58606   R059606Q
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
label values  R058805   R059606Q
label values  RB58805   R059606Q
label values  RC58805   R059606Q
label values  R058806   MC5B
label values  R058807   RATE4A
label values  RB58807   RATE4A
label values  RC58807   RATE4A
label values  R058808   MC5B
label values  R058809   MC5A
label values  R058810   R059606Q
label values  RB58810   R059606Q
label values  RC58810   R059606Q
label values  R059101   MC5D
label values  R059102   MC5B
label values  R059103   MC5C
label values  R059104   MC5A
label values  R059109   R059606Q
label values  RB59109   R059606Q
label values  RC59109   R059606Q
label values  R059106   RATE4A
label values  RB59106   RATE4A
label values  RC59106   RATE4A
label values  R059105   MC5A
label values  R059107   MC5D
label values  R059108   R059606Q
label values  RB59108   R059606Q
label values  RC59108   R059606Q
label values  R059110   RATE2A
label values  RB59110   RATE2A
label values  RC59110   RATE2A
label values  R060501   MC5C
label values  R060502   MC5B
label values  R060503   R059606Q
label values  RB60503   R059606Q
label values  RC60503   R059606Q
label values  R060504   MC5D
label values  R060505   RATE4A
label values  RB60505   RATE4A
label values  RC60505   RATE4A
label values  R060507   R059606Q
label values  RB60507   R059606Q
label values  RC60507   R059606Q
label values  R060508   R059606Q
label values  RB60508   R059606Q
label values  RC60508   R059606Q
label values  R060509   R059606Q
label values  RB60509   R059606Q
label values  RC60509   R059606Q
label values  R060510   MC5A
label values  R060511   MC5C
label values  R060601   MC5C
label values  R060602   MC5D
label values  R060607   R059606Q
label values  RB60607   R059606Q
label values  RC60607   R059606Q
label values  R060604   MC5B
label values  R060605   R059606Q
label values  RB60605   R059606Q
label values  RC60605   R059606Q
label values  R060606   RATE4A
label values  RB60606   RATE4A
label values  RC60606   RATE4A
label values  R060610   MC5B
label values  R060608   R059606Q
label values  RB60608   R059606Q
label values  RC60608   R059606Q
label values  R060609   MC5D
label values  R060603   R059606Q
label values  RB60603   R059606Q
label values  RC60603   R059606Q
label values  R060801   MC5A
label values  R060803   R059606Q
label values  RB60803   R059606Q
label values  RC60803   R059606Q
label values  R060804   MC5D
label values  R060805   MC5B
label values  R060806   MC5C
label values  R060807   RATE2A
label values  RB60807   RATE2A
label values  RC60807   RATE2A
label values  R060808   RATE4A
label values  RB60808   RATE4A
label values  RC60808   RATE4A
label values  R060802   MC5B
label values  R060809   MC5A
label values  R060810   R059606Q
label values  RB60810   R059606Q
label values  RC60810   R059606Q
label values  R060811   R059606Q
label values  RB60811   R059606Q
label values  RC60811   R059606Q
label values  R061001   MC5C
label values  R061002   MC5A
label values  R061003   R059606Q
label values  RB61003   R059606Q
label values  RC61003   R059606Q
label values  R061004   RATE2A
label values  RB61004   RATE2A
label values  RC61004   RATE2A
label values  R061005   MC5A
label values  R061006   RATE2A
label values  RB61006   RATE2A
label values  RC61006   RATE2A
label values  R061007   RATE4A
label values  RB61007   RATE4A
label values  RC61007   RATE4A
label values  R061008   MC5B
label values  R061009   MC5D
label values  R061010   R059606Q
label values  RB61010   R059606Q
label values  RC61010   R059606Q
label values  R061301   R059606Q
label values  RB61301   R059606Q
label values  RC61301   R059606Q
label values  R061302   MC5A
label values  R061303   R059606Q
label values  RB61303   R059606Q
label values  RC61303   R059606Q
label values  R061304   RATE2A
label values  RB61304   RATE2A
label values  RC61304   RATE2A
label values  R061305   MC5C
label values  R061306   MC5D
label values  R061307   RATE4A
label values  RB61307   RATE4A
label values  RC61307   RATE4A
label values  R061308   MC5B
label values  R061309   R059606Q
label values  RB61309   R059606Q
label values  RC61309   R059606Q
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
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T086802   MAJORA
label values  T118801   MAJORA
label values  T118802   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T086902   MAJORA
label values  T118901   MAJORA
label values  T118902   MAJORA
label values  T102001   FREQ4D
label values  T102002   FREQ4D
label values  T102003   FREQ4D
label values  T102004   FREQ4D
label values  T102005   FREQ4D
label values  T102006   FREQ4D
label values  T102007   FREQ4D
label values  T083801   YESNO
label values  T083802   YESNO
label values  T083803   YESNO
label values  T083804   YESNO
label values  T083805   YESNO
label values  T083806   YESNO
label values  T083807   YESNO
label values  T083808   YESNO
label values  T083809   YESNO
label values  T083810   YESNO
label values  T083811   YESNO
label values  T083812   YESNO
label values  T097501   T097501Q
label values  T097502   T097501Q
label values  T097503   T097501Q
label values  T097504   T097501Q
label values  T097505   T097501Q
label values  T083201   YESNO
label values  T097701   YESNO
label values  T111501   T111501Q
label values  T092401   T092401Q
label values  T085901   T085901Q
label values  T085801   T085801Q
label values  T111601   FREQ4D
label values  T111602   FREQ4D
label values  T111603   FREQ4D
label values  T111604   FREQ4D
label values  T111605   FREQ4D
label values  T111606   FREQ4D
label values  T105701   T105701Q
label values  T105702   T105701Q
label values  T105703   T105701Q
label values  T105704   T105701Q
label values  T105705   T105701Q
label values  T111701   R846201Q
label values  T111702   R846201Q
label values  T111703   R846201Q
label values  T111704   R846201Q
label values  T111705   R846201Q
label values  T111706   R846201Q
label values  T111707   R846201Q
label values  T100101   FREQ4D
label values  T100102   FREQ4D
label values  T100103   FREQ4D
label values  T111801   T111801Q
label values  T111901   R846201Q
label values  T111902   R846201Q
label values  T111903   R846201Q
label values  T111906   R846201Q
label values  T111907   R846201Q
label values  T112001   T112001Q
label values  T112101   FREQ4D
label values  T112102   FREQ4D
label values  T112103   FREQ4D
label values  T112104   FREQ4D
label values  T112105   FREQ4D
label values  T112301   T112301Q
label values  T112302   T112301Q
label values  T112303   T112301Q
label values  T112304   T112301Q
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
// mvdecode R059604 - RC59604 R059610 - RC59610 R059606 - RC59606 /*
//       */ R059605 - RC59605 R059607 - RC59607 R059803 - RC59803 /*
//       */ R059806 - RC59806 R059807 - RC59807 R059809 - RC59809 /*
//       */ R060103 - RC60103 R060105 - RC60105 R060108 - RC60108 /*
//       */ R060301 - RC60301 R060305 - RC60305 R060306 - RC60306 /*
//       */ R060309 - RC60309 R058504 - RC58504 R058508 - RC58508 /*
//       */ R058509 - RC58509 R058602 - RC58602 R058606 - RC58606 /*
//       */ R058608 - RC58608 R058805 - RC58805 R058807 - RC58807 /*
//       */ R058810 - RC58810 R059109 - RC59109 R059106 - RC59106 /*
//       */ R059108 - RC59108 R059110 - RC59110 R060503 - RC60503 /*
//       */ R060505 - RC60505 R060507 - RC60507 R060508 - RC60508 /*
//       */ R060509 - RC60509 R060607 - RC60607 R060605 - RC60605 /*
//       */ R060606 - RC60606 R060608 - RC60608 R060603 - RC60603 /*
//       */ R060803 - RC60803 R060807 - RC60807 R060808 - RC60808 /*
//       */ R060810 - RC60810 R060811 - RC60811 R061003 - RC61003 /*
//       */ R061004 - RC61004 R061006 - RC61006 R061007 - RC61007 /*
//       */ R061010 - RC61010 R061301 - RC61301 R061303 - RC61303 /*
//       */ R061304 - RC61304 R061307 - RC61307 R061309 - RC61309,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode R059604 - RC59604 R059610 - RC59610 R059606 - RC59606 /*
//       */ R059605 - RC59605 R059607 - RC59607 R059803 - RC59803 /*
//       */ R059806 - RC59806 R059807 - RC59807 R059809 - RC59809 /*
//       */ R060103 - RC60103 R060105 - RC60105 R060108 - RC60108 /*
//       */ R060301 - RC60301 R060305 - RC60305 R060306 - RC60306 /*
//       */ R060309 - RC60309 R058504 - RC58504 R058508 - RC58508 /*
//       */ R058509 - RC58509 R058602 - RC58602 R058606 - RC58606 /*
//       */ R058608 - RC58608 R058805 - RC58805 R058807 - RC58807 /*
//       */ R058810 - RC58810 R059109 - RC59109 R059106 - RC59106 /*
//       */ R059108 - RC59108 R059110 - RC59110 R060503 - RC60503 /*
//       */ R060505 - RC60505 R060507 - RC60507 R060508 - RC60508 /*
//       */ R060509 - RC60509 R060607 - RC60607 R060605 - RC60605 /*
//       */ R060606 - RC60606 R060608 - RC60608 R060603 - RC60603 /*
//       */ R060803 - RC60803 R060807 - RC60807 R060808 - RC60808 /*
//       */ R060810 - RC60810 R060811 - RC60811 R061003 - RC61003 /*
//       */ R061004 - RC61004 R061006 - RC61006 R061007 - RC61007 /*
//       */ R061010 - RC61010 R061301 - RC61301 R061303 - RC61303 /*
//       */ R061304 - RC61304 R061307 - RC61307 R061309 - RC61309,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode PARED B000905 B017201 B003501 B003601  XS05301 XL04101 - XL04304,  /*
//       */ mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode R059604 - RC59604 R059610 - RC59610 R059606 - RC59606 /*
//       */ R059605 - RC59605 R059607 - RC59607 R059803 - RC59803 /*
//       */ R059806 - RC59806 R059807 - RC59807 R059809 - RC59809 /*
//       */ R060103 - RC60103 R060105 - RC60105 R060108 - RC60108 /*
//       */ R060301 - RC60301 R060305 - RC60305 R060306 - RC60306 /*
//       */ R060309 - RC60309 R058504 - RC58504 R058508 - RC58508 /*
//       */ R058509 - RC58509 R058602 - RC58602 R058606 - RC58606 /*
//       */ R058608 - RC58608 R058805 - RC58805 R058807 - RC58807 /*
//       */ R058810 - RC58810 R059109 - RC59109 R059106 - RC59106 /*
//       */ R059108 - RC59108 R059110 - RC59110 R060503 - RC60503 /*
//       */ R060505 - RC60505 R060507 - RC60507 R060508 - RC60508 /*
//       */ R060509 - RC60509 R060607 - RC60607 R060605 - RC60605 /*
//       */ R060606 - RC60606 R060608 - RC60608 R060603 - RC60603 /*
//       */ R060803 - RC60803 R060807 - RC60807 R060808 - RC60808 /*
//       */ R060810 - RC60810 R060811 - RC60811 R061003 - RC61003 /*
//       */ R061004 - RC61004 R061006 - RC61006 R061007 - RC61007 /*
//       */ R061010 - RC61010 R061301 - RC61301 R061303 - RC61303 /*
//       */ R061304 - RC61304 R061307 - RC61307 R061309 - RC61309,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode SRACE10 SD3 PCHARTR PCHRTFL UTOL4 LEP - ELL3 SLUNCH IEP2009  PARED /*
//       */ HISPYES SENROL8 - PCTWHTC BA21101 - RC59604 R059610 - RC59610 /*
//       */ R059606 - RC59606 R059605 - RC59605 R059608 - RC59607 /*
//       */ R059801 - RC59803 R059804 - RC59806 R059807 - RC59807 /*
//       */ R059808 - RC59809 R059810 - RC60103 R060104 - RC60105 /*
//       */ R060106 - RC60108 R060109 - RC60301 R060302 - RC60305 /*
//       */ R060303 - RC60306 R060307 - RC60309 R060310 - RC58504 /*
//       */ R058505 - RC58508 R058509 - RC58509 R058510 - RC58602 /*
//       */ R058603 - RC58606 R058607 - RC58608 R058609 - RC58805 /*
//       */ R058806 - RC58807 R058808 - RC58810 R059101 - RC59109 /*
//       */ R059106 - RC59106 R059105 - RC59108 R059110 - RC59110 /*
//       */ R060501 - RC60503 R060504 - RC60505 R060507 - RC60507 /*
//       */ R060508 - RC60508 R060509 - RC60509 R060510 - RC60607 /*
//       */ R060604 - RC60605 R060606 - RC60606 R060610 - RC60608 /*
//       */ R060609 - RC60603 R060801 - RC60803 R060804 - RC60807 /*
//       */ R060808 - RC60808 R060802 - RC60810 R060811 - RC60811 /*
//       */ R061001 - RC61003 R061004 - RC61004 R061005 - RC61006 /*
//       */ R061007 - RC61007 R061008 - RC61010 R061301 - RC61301 /*
//       */ R061302 - RC61303 R061304 - RC61304 R061305 - RC61307 /*
//       */ R061308 - RC61309 XS04701 - XS05001 XS05101 - XS05104 /*
//       */ XS05201 - XL04001 XL04101 - TE21201 T096401 - T112304,  mv( 7=.q)
// mvdecode UTOL12,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode SRACE10 PCHARTR PCHRTFL R059601 - RC59604 R059610 - RC59610 /*
//       */ R059606 - RC59606 R059605 - RC59605 R059608 - RC59607 /*
//       */ R059801 - RC59803 R059804 - RC59806 R059807 - RC59807 /*
//       */ R059808 - RC59809 R059810 - RC60103 R060104 - RC60105 /*
//       */ R060106 - RC60108 R060109 - RC60301 R060302 - RC60305 /*
//       */ R060303 - RC60306 R060307 - RC60309 R060310 - RC58504 /*
//       */ R058505 - RC58508 R058509 - RC58509 R058510 - RC58602 /*
//       */ R058603 - RC58606 R058607 - RC58608 R058609 - RC58805 /*
//       */ R058806 - RC58807 R058808 - RC58810 R059101 - RC59109 /*
//       */ R059106 - RC59106 R059105 - RC59108 R059110 - RC59110 /*
//       */ R060501 - RC60503 R060504 - RC60505 R060507 - RC60507 /*
//       */ R060508 - RC60508 R060509 - RC60509 R060510 - RC60607 /*
//       */ R060604 - RC60605 R060606 - RC60606 R060610 - RC60608 /*
//       */ R060609 - RC60603 R060801 - RC60803 R060804 - RC60807 /*
//       */ R060808 - RC60808 R060802 - RC60810 R060811 - RC60811 /*
//       */ R061001 - RC61003 R061004 - RC61004 R061005 - RC61006 /*
//       */ R061007 - RC61007 R061008 - RC61010 R061301 - RC61301 /*
//       */ R061302 - RC61303 R061304 - RC61304 R061305 - RC61307 /*
//       */ R061308 - RC61309,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode PARED BA21101 - R059603 R059608 R059609  R059801 R059802  /*
//       */ R059804 R059805  R059808 R059810 - R060102 R060104 R060106 R060107  /*
//       */ R060109 R060110  R060302 R060304  R060303 R060307 R060308  /*
//       */ R060310 - R058503 R058505 - R058507 R058510 R058601  /*
//       */ R058603 - R058605 R058607 R058609 - R058804 R058806 R058808 R058809  /*
//       */ R059101 - R059104 R059105 R059107  R060501 R060502  R060504 /*
//       */ R060510 - R060602 R060604 R060610 R060609 R060801 R060804 - R060806 /*
//       */ R060802 R060809  R061001 R061002  R061005 R061008 R061009  R061302 /*
//       */ R061305 R061306  R061308 XS04701 XS04801  XS05001 XS05101 - XS05104 /*
//       */ XS05201 - XL03801 XL04001 XL04101 - XL04304 T096401 - T112304,  /*
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
// recode R059601 R059608 R059801 R059808 R060104 R060302 R060307 R058501 /*
//     */ R058605 R058804 R059103 R060501 R060511 R060601 R060806 R061001 /*
//     */ R061305 (1=0) (2=0) (3=1) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R059602 R059805 R060106 R060109 R060310 R058502 R058506 /*
//     */ R058510 R058601 R058609 R058802 R059101 R059107 R060504 R060602 /*
//     */ R060609 R060804 R061009 R061306 (1=0) (2=0) (3=0) (4=1) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R059603 R059609 R059804 R059810 R060101 R060107 R060303 R060308 /*
//     */ R058505 R058604 R058607 R058803 R058806 R058808 R059102 R060502 /*
//     */ R060604 R060610 R060805 R060802 R061008 R061308 (1=0) (2=1) (3=0) /*
//     */ (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R059604 R059809 R060103 R060105 R060301 R058509 R059110 R060807 /*
//     */ R061004 R061006 R061304 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode R059610 R059803 R060108 R058508 R058608 R058807 R059106 R060505 /*
//     */ R060606 R060808 R061007 R061307 (1=0) (2=1) (3=2) (4=3) ( 0=.m) /*
//     */ ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R059606 R059605 R059607 R059806 R059807 R060305 R058504 R058602 /*
//     */ R058606 R058810 R059109 R059108 R060503 R060507 R060508 R060509 /*
//     */ R060607 R060605 R060608 R060603 R060803 R060810 R060811 R061003 /*
//     */ R061010 R061301 R061303 R061309 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) /*
//     */ ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R059802 R060102 R060110 R060304 R058503 R058507 R058603 /*
//     */ R058610 R058801 R058809 R059104 R059105 R060510 R060801 R060809 /*
//     */ R061002 R061005 R061302 (1=1) (2=0) (3=0) (4=0) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R060306 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode R060309 (1=0) (2=1) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ (else=.)
// recode R058805 (1=0) (2=0) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ (else=.)
// label values  R059601   SCORE
// label values  R059602   SCORE
// label values  R059603   SCORE
// label values  R059604   SCORE
// label values  R059610   SCORE
// label values  R059606   SCORE
// label values  R059605   SCORE
// label values  R059608   SCORE
// label values  R059609   SCORE
// label values  R059607   SCORE
// label values  R059801   SCORE
// label values  R059802   SCORE
// label values  R059803   SCORE
// label values  R059804   SCORE
// label values  R059805   SCORE
// label values  R059806   SCORE
// label values  R059807   SCORE
// label values  R059808   SCORE
// label values  R059809   SCORE
// label values  R059810   SCORE
// label values  R060101   SCORE
// label values  R060102   SCORE
// label values  R060103   SCORE
// label values  R060104   SCORE
// label values  R060105   SCORE
// label values  R060106   SCORE
// label values  R060107   SCORE
// label values  R060108   SCORE
// label values  R060109   SCORE
// label values  R060110   SCORE
// label values  R060301   SCORE
// label values  R060302   SCORE
// label values  R060304   SCORE
// label values  R060305   SCORE
// label values  R060303   SCORE
// label values  R060306   SCORE
// label values  R060307   SCORE
// label values  R060308   SCORE
// label values  R060309   SCORE
// label values  R060310   SCORE
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
// label values  R060501   SCORE
// label values  R060502   SCORE
// label values  R060503   SCORE
// label values  R060504   SCORE
// label values  R060505   SCORE
// label values  R060507   SCORE
// label values  R060508   SCORE
// label values  R060509   SCORE
// label values  R060510   SCORE
// label values  R060511   SCORE
// label values  R060601   SCORE
// label values  R060602   SCORE
// label values  R060607   SCORE
// label values  R060604   SCORE
// label values  R060605   SCORE
// label values  R060606   SCORE
// label values  R060610   SCORE
// label values  R060608   SCORE
// label values  R060609   SCORE
// label values  R060603   SCORE
// label values  R060801   SCORE
// label values  R060803   SCORE
// label values  R060804   SCORE
// label values  R060805   SCORE
// label values  R060806   SCORE
// label values  R060807   SCORE
// label values  R060808   SCORE
// label values  R060802   SCORE
// label values  R060809   SCORE
// label values  R060810   SCORE
// label values  R060811   SCORE
// label values  R061001   SCORE
// label values  R061002   SCORE
// label values  R061003   SCORE
// label values  R061004   SCORE
// label values  R061005   SCORE
// label values  R061006   SCORE
// label values  R061007   SCORE
// label values  R061008   SCORE
// label values  R061009   SCORE
// label values  R061010   SCORE
// label values  R061301   SCORE
// label values  R061302   SCORE
// label values  R061303   SCORE
// label values  R061304   SCORE
// label values  R061305   SCORE
// label values  R061306   SCORE
// label values  R061307   SCORE
// label values  R061308   SCORE
// label values  R061309   SCORE

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2011
gen grade=8
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE10

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2011\naep_read_gr8_2011", replace

