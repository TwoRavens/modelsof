version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Reading G8\stata\LABELDEF.do"
label data "  2007 National Reading Assessment: Grade  8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Reading G8\stata\R38NT2AT.DCT", clear
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
label values  PARED     PARED
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SENROL8   SENROL8V
label values  YRSEXP    YRSEXP
label values  YRSLART   YRSEXP
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
label values  Y38ORM    BLKUSE
label values  Y38ORN    BLKUSE
label values  Y38ORO    BLKUSE
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
label values  R833001   AGREE4A
label values  R833101   AGREE4A
label values  R833201   AGREE4A
label values  R833301   AGREE4A
label values  R833401   R833401V
label values  R833501   R833401V
label values  R833801   R833401V
label values  R833901   R833901V
label values  R834001   R833901V
label values  R834101   R833901V
label values  R834201   R833901V
label values  R834301   R833901V
label values  R834401   R833901V
label values  R834501   R833901V
label values  R834601   R833901V
label values  R834701   R833901V
label values  R834901   R833901V
label values  R835001   R833901V
label values  R835101   R833901V
label values  R835201   R833901V
label values  R835301   R833901V
label values  R835401   R833901V
label values  R835501   R833901V
label values  R835601   R835601V
label values  R835701   R835601V
label values  R835801   R835601V
label values  R835901   R835901V
label values  R836001   R835901V
label values  R836101   R835901V
label values  R836201   R835901V
label values  R832801   R832801V
label values  R836401   R833401V
label values  R836501   R833401V
label values  R836601   R836601V
label values  R836701   R836701V
label values  R836801   R836801V
label values  R017101   RATE2A
label values  RB17101   RATE2A
label values  RC17101   RATE2A
label values  R017102   R017102V
label values  RB17102   R017102V
label values  RC17102   R017102V
label values  R017103   MC5D
label values  R017104   R017102V
label values  RB17104   R017102V
label values  RC17104   R017102V
label values  R017105   RATE4A
label values  RB17105   RATE4A
label values  RC17105   RATE4A
label values  R017106   MC5A
label values  R017107   R017102V
label values  RB17107   R017102V
label values  RC17107   R017102V
label values  R017108   RATE2A
label values  RB17108   RATE2A
label values  RC17108   RATE2A
label values  R017109   MC5B
label values  R017110   R017102V
label values  RB17110   R017102V
label values  RC17110   R017102V
label values  R055501   RATE3B
label values  RB55501   RATE3B
label values  RC55501   RATE3B
label values  R055601   MC5C
label values  R055701   MC5B
label values  R055801   RATE3B
label values  RB55801   RATE3B
label values  RC55801   RATE3B
label values  R055901   MC5D
label values  R056001   MC5B
label values  R056101   R056101V
label values  RB56101   R056101V
label values  RC56101   R056101V
label values  R056201   MC5C
label values  R056301   RATE3B
label values  RB56301   RATE3B
label values  RC56301   RATE3B
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
label values  R013201   RATE4A
label values  RB13201   RATE4A
label values  RC13201   RATE4A
label values  R013202   MC5A
label values  R013203   RATE2A
label values  RB13203   RATE2A
label values  RC13203   RATE2A
label values  R013204   MC5B
label values  R013205   RATE2A
label values  RB13205   RATE2A
label values  RC13205   RATE2A
label values  R013206   MC5A
label values  R013207   RATE2A
label values  RB13207   RATE2A
label values  RC13207   RATE2A
label values  R013208   MC5D
label values  R013209   RATE2A
label values  RB13209   RATE2A
label values  RC13209   RATE2A
label values  R013210   MC5D
label values  R013211   RATE2A
label values  RB13211   RATE2A
label values  RC13211   RATE2A
label values  R013212   RATE4A
label values  RB13212   RATE4A
label values  RC13212   RATE4A
label values  R034501   MC5B
label values  R034601   R034601V
label values  RB34601   R034601V
label values  RC34601   R017102V
label values  R034701   MC5B
label values  R034801   MC5D
label values  R034901   R034601V
label values  RB34901   R034601V
label values  RC34901   R017102V
label values  R035001   R034601V
label values  RB35001   R034601V
label values  RC35001   R017102V
label values  R035101   MC5C
label values  R035201   R034601V
label values  RB35201   R034601V
label values  RC35201   R017102V
label values  R035301   RATE4A
label values  RB35301   RATE4A
label values  RC35301   RATE4A
label values  R035401   MC5B
label values  R053401   R053401V
label values  RB53401   R053401V
label values  RC53401   R053401V
label values  R053402   RATE2D
label values  RB53402   RATE2D
label values  RC53402   RATE2D
label values  R053403   R053403V
label values  R053404   R053404V
label values  R053405   RATE4A
label values  RB53405   RATE4A
label values  RC53405   RATE4A
label values  R053406   R053406V
label values  R053407   R053407V
label values  R053408   R053401V
label values  RB53408   R053401V
label values  RC53408   R053401V
label values  R053409   R053404V
label values  R053410   RATE2D
label values  RB53410   RATE2D
label values  RC53410   RATE2D
label values  R053411   R053406V
label values  R056501   RATE2D
label values  RB56501   RATE2D
label values  RC56501   RATE2D
label values  R056601   MC5B
label values  R056701   MC5C
label values  R056801   RATE3B
label values  RB56801   RATE3B
label values  RC56801   RATE3B
label values  R056901   MC5D
label values  R057001   MC5C
label values  R057101   RATE3B
label values  RB57101   RATE3B
label values  RC57101   RATE3B
label values  R057201   MC5A
label values  R057301   RATE3B
label values  RB57301   RATE3B
label values  RC57301   RATE3B
label values  R057401   MC5D
label values  R013401   MC5D
label values  R013402   RATE2A
label values  RB13402   RATE2A
label values  RC13402   RATE2A
label values  R013403   RATE4A
label values  RB13403   RATE4A
label values  RC13403   RATE4A
label values  R013404   MC5C
label values  R013405   RATE2A
label values  RB13405   RATE2A
label values  RC13405   RATE2A
label values  R013406   RATE4A
label values  RB13406   RATE4A
label values  RC13406   RATE4A
label values  R013407   RATE2A
label values  RB13407   RATE2A
label values  RC13407   RATE2A
label values  R013408   MC5A
label values  R013409   RATE2A
label values  RB13409   RATE2A
label values  RC13409   RATE2A
label values  R013410   MC5B
label values  R013411   RATE2A
label values  RB13411   RATE2A
label values  RC13411   RATE2A
label values  R013413   RATE2A
label values  RB13413   RATE2A
label values  RC13413   RATE2A
label values  R013001   RATE2A
label values  RB13001   RATE2A
label values  RC13001   RATE2A
label values  R013002   MC5D
label values  R013003   RATE2A
label values  RB13003   RATE2A
label values  RC13003   RATE2A
label values  R013004   RATE4A
label values  RB13004   RATE4A
label values  RC13004   RATE4A
label values  R013005   RATE2A
label values  RB13005   RATE2A
label values  RC13005   RATE2A
label values  R013006   MC5A
label values  R013007   RATE2A
label values  RB13007   RATE2A
label values  RC13007   RATE2A
label values  R013008   RATE2A
label values  RB13008   RATE2A
label values  RC13008   RATE2A
label values  R013009   RATE2A
label values  RB13009   RATE2A
label values  RC13009   RATE2A
label values  R013010   RATE2A
label values  RB13010   RATE2A
label values  RC13010   RATE2A
label values  R013011   RATE2A
label values  RB13011   RATE2A
label values  RC13011   RATE2A
label values  R013012   MC5C
label values  R053201   R053403V
label values  R053202   R053401V
label values  RB53202   R053401V
label values  RC53202   R053401V
label values  R053203   R053401V
label values  RB53203   R053401V
label values  RC53203   R053401V
label values  R053204   R053404V
label values  R053205   RATE4A
label values  RB53205   RATE4A
label values  RC53205   RATE4A
label values  R053206   R053403V
label values  R053207   R053401V
label values  RB53207   R053401V
label values  RC53207   R053401V
label values  R053208   R053407V
label values  R053209   R053401V
label values  RB53209   R053401V
label values  RC53209   R053401V
label values  R053210   R053406V
label values  R016201   R016201V
label values  RB16201   RATE3C
label values  RC16201   RATE3C
label values  R016202   R017102V
label values  RB16202   RATE3C
label values  RC16202   RATE3C
label values  R016203   MC5B
label values  R016204   RATE4A
label values  RB16204   RATE4A
label values  RC16204   RATE4A
label values  R016205   R017102V
label values  RB16205   RATE3C
label values  RC16205   RATE3C
label values  R016206   MC5A
label values  R016207   R017102V
label values  RB16207   RATE3C
label values  RC16207   RATE3C
label values  R016208   MC5C
label values  R016209   MC5D
label values  R016210   RATE4A
label values  RB16210   RATE4A
label values  RC16210   RATE4A
label values  R016211   R017102V
label values  RB16211   RATE3C
label values  RC16211   RATE3C
label values  R016212   R017102V
label values  RB16212   RATE3C
label values  RC16212   RATE3C
label values  R016213   R017102V
label values  RB16213   RATE3C
label values  RC16213   RATE3C
label values  R027301   MC5B
label values  R026401   MC5C
label values  R026501   R017102V
label values  RB26501   R034601V
label values  RC26501   R017102V
label values  R027101   MC5A
label values  R026601   MC5B
label values  R028201   MC5B
label values  R026801   RATE4A
label values  RB26801   RATE4A
label values  RC26801   RATE4A
label values  R027201   R017102V
label values  RB27201   R034601V
label values  RC27201   R017102V
label values  R026901   MC5B
label values  R027001   RATE2A
label values  RB27001   RATE2A
label values  RC27001   RATE2A
label values  R028301   MC5A
label values  R028401   R017102V
label values  RB28401   R034601V
label values  RC28401   R017102V
label values  R028501   R017102V
label values  RB28501   R034601V
label values  RC28501   R017102V
label values  R029501   MC5A
label values  R029701   MC5B
label values  R028801   RATE4A
label values  RB28801   RATE4A
label values  RC28801   RATE4A
label values  R029001   MC5B
label values  R029901   MC5C
label values  R029601   R017102V
label values  RB29601   R034601V
label values  RC29601   R017102V
label values  R029801   MC5B
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
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T086802   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T086902   MAJORA
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
label values  T083201   YESNO
label values  T094601   YESNO
label values  T094602   YESNO
label values  T085801   T085801Q
label values  T085901   T085901Q
label values  T083601   FREQ6A
label values  T083602   FREQ6A
label values  T083603   FREQ6A
label values  T086001   FREQ4C
label values  T086002   FREQ4C
label values  T086003   FREQ4C
label values  T086004   FREQ4C
label values  T086005   FREQ4C
label values  T090601   T090601Q
label values  T090602   T090601Q
label values  T090603   T090601Q
label values  T090604   T090601Q
label values  T090605   T090601Q
label values  T090606   T090601Q
label values  T090607   T090601Q
label values  T090608   T090601Q
label values  T090609   T090601Q
label values  T090610   T090601Q
label values  T090611   T090601Q
label values  T090612   T090601Q
label values  T090613   T090601Q
label values  T090614   T090601Q
label values  T090615   T090601Q
label values  T090616   T090601Q
label values  T090617   YESNO
label values  T090701   T090601Q
label values  T090702   T090601Q
label values  T090703   T090601Q
label values  T090704   T090601Q
label values  T090705   T090601Q
label values  T090706   T090601Q
label values  T090707   T090601Q
label values  T090708   T090601Q
label values  T090709   T090601Q
label values  T090710   T090601Q
label values  T090711   T090601Q
label values  T090712   T090601Q
label values  T090713   T090601Q
label values  T090714   T090601Q
label values  T090715   T090601Q
label values  T090716   T090601Q
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
// mvdecode PARED BA21101 - R836801 R017103 R017106 R017109 R055601 R055701  /*
//       */ R055901 R056001  R056201 R012602 R012603  R012605 R012606  /*
//       */ R012608 - R012610 R013202 R013204 R013206 R013208 R013210 R034501 /*
//       */ R034701 R034801  R035101 R035401 R053403 R053404  R053406 R053407  /*
//       */ R053409 R053411 R056601 R056701  R056901 R057001  R057201 /*
//       */ R057401 R013401  R013404 R013408 R013410 R013002 R013006 /*
//       */ R013012 R053201  R053204 R053206 R053208 R053210 R016203 R016206 /*
//       */ R016208 R016209  R027301 R026401  R027101 - R028201 R026901 R028301 /*
//       */ R029501 R029701  R029001 R029901  R029801 - TE21201 /*
//       */ T077201 - T090716 XS02101 XS02201  XS02401 - XS02601 /*
//       */ XS02701 XS02001  X013801 XL01901 XL02101 - XL02301 /*
//       */ XL00601 - XL02404,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode PCHRTFL R017101 - RC17101 R017102 - RC17102 R017103 - RC17104 /*
//       */ R017105 - RC17105 R017106 - RC17107 R017108 - RC17108 /*
//       */ R017109 - RC17110 R055501 - RC55501 R055601 - RC55801 /*
//       */ R055901 - RC56101 R056201 - RC56301 R012601 - RC12601 /*
//       */ R012602 - RC12604 R012605 - RC12607 R012608 - RC12612 /*
//       */ R013201 - RC13201 R013202 - RC13203 R013204 - RC13205 /*
//       */ R013206 - RC13207 R013208 - RC13209 R013210 - RC13211 /*
//       */ R013212 - RC13212 R034501 - RC34601 R034701 - RC34901 /*
//       */ R035001 - RC35001 R035101 - RC35201 R035301 - RC35301 /*
//       */ R035401 - RC53401 R053402 - RC53402 R053403 - RC53405 /*
//       */ R053406 - RC53408 R053409 - RC53410 R053411 - RC56501 /*
//       */ R056601 - RC56801 R056901 - RC57101 R057201 - RC57301 /*
//       */ R057401 - RC13402 R013403 - RC13403 R013404 - RC13405 /*
//       */ R013406 - RC13406 R013407 - RC13407 R013408 - RC13409 /*
//       */ R013410 - RC13411 R013413 - RC13413 R013001 - RC13001 /*
//       */ R013002 - RC13003 R013004 - RC13004 R013005 - RC13005 /*
//       */ R013006 - RC13007 R013008 - RC13008 R013009 - RC13009 /*
//       */ R013010 - RC13010 R013011 - RC13011 R013012 - RC53202 /*
//       */ R053203 - RC53203 R053204 - RC53205 R053206 - RC53207 /*
//       */ R053208 - RC53209 R053210 - RC16201 R016202 - RC16202 /*
//       */ R016203 - RC16204 R016205 - RC16205 R016206 - RC16207 /*
//       */ R016208 - RC16210 R016211 - RC16211 R016212 - RC16212 /*
//       */ R016213 - RC16213 R027301 - RC26501 R027101 - RC26801 /*
//       */ R027201 - RC27201 R026901 - RC27001 R028301 - RC28401 /*
//       */ R028501 - RC28501 R029501 - RC28801 R029001 - RC29601 R029801,  /*
//       */ mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode PCHRTFL PARED - PCTINDC SDRACEM LEP  BA21101 - RC17101 /*
//       */ R017102 - RC17102 R017103 - RC17104 R017105 - RC17105 /*
//       */ R017106 - RC17107 R017108 - RC17108 R017109 - RC17110 /*
//       */ R055501 - RC55501 R055601 - RC55801 R055901 - RC56101 /*
//       */ R056201 - RC56301 R012601 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R013201 - RC13201 /*
//       */ R013202 - RC13203 R013204 - RC13205 R013206 - RC13207 /*
//       */ R013208 - RC13209 R013210 - RC13211 R013212 - RC13212 /*
//       */ R034501 - RC34601 R034701 - RC34901 R035001 - RC35001 /*
//       */ R035101 - RC35201 R035301 - RC35301 R035401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC56501 R056601 - RC56801 /*
//       */ R056901 - RC57101 R057201 - RC57301 R057401 - RC13402 /*
//       */ R013403 - RC13403 R013404 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013408 - RC13409 R013410 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013002 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013006 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R013012 - RC53202 R053203 - RC53203 /*
//       */ R053204 - RC53205 R053206 - RC53207 R053208 - RC53209 /*
//       */ R053210 - RC16201 R016202 - RC16202 R016203 - RC16204 /*
//       */ R016205 - RC16205 R016206 - RC16207 R016208 - RC16210 /*
//       */ R016211 - RC16211 R016212 - RC16212 R016213 - RC16213 /*
//       */ R027301 - RC26501 R027101 - RC26801 R027201 - RC27201 /*
//       */ R026901 - RC27001 R028301 - RC28401 R028501 - RC28501 /*
//       */ R029501 - RC28801 R029001 - RC29601 R029801 - TE21201 /*
//       */ T077201 - T090716 XS02101 - XS02601 XS00301 - XS00312 /*
//       */ XS02701 XS02001  X013801 XL01901 - XL02301 XL00601 - XL02404,  /*
//       */ mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B003501 B003601  XS02001 /*
//       */ XL00601 - XL02404,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017104 - RC17104 /*
//       */ R017105 - RC17105 R017107 - RC17107 R017108 - RC17108 /*
//       */ R017110 - RC17110 R055501 - RC55501 R055801 - RC55801 /*
//       */ R056101 - RC56101 R056301 - RC56301 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R013201 - RC13201 R013203 - RC13203 R013205 - RC13205 /*
//       */ R013207 - RC13207 R013209 - RC13209 R013211 - RC13211 /*
//       */ R013212 - RC13212 R034601 - RC34601 R034901 - RC34901 /*
//       */ R035001 - RC35001 R035201 - RC35201 R035301 - RC35301 /*
//       */ R053401 - RC53401 R053402 - RC53402 R053403 - RC53405 /*
//       */ R053406 - RC53408 R053409 - RC53410 R053411 - RC56501 /*
//       */ R056801 - RC56801 R057101 - RC57101 R057301 - RC57301 /*
//       */ R013402 - RC13402 R013403 - RC13403 R013405 - RC13405 /*
//       */ R013406 - RC13406 R013407 - RC13407 R013409 - RC13409 /*
//       */ R013411 - RC13411 R013413 - RC13413 R013001 - RC13001 /*
//       */ R013003 - RC13003 R013004 - RC13004 R013005 - RC13005 /*
//       */ R013007 - RC13007 R013008 - RC13008 R013009 - RC13009 /*
//       */ R013010 - RC13010 R013011 - RC13011 R053201 - RC53202 /*
//       */ R053203 - RC53203 R053204 - RC53205 R053206 - RC53207 /*
//       */ R053208 - RC53209 R053210 - RC16201 R016202 - RC16202 /*
//       */ R016204 - RC16204 R016205 - RC16205 R016207 - RC16207 /*
//       */ R016210 - RC16210 R016211 - RC16211 R016212 - RC16212 /*
//       */ R016213 - RC16213 R026501 - RC26501 R026801 - RC26801 /*
//       */ R027201 - RC27201 R027001 - RC27001 R028401 - RC28401 /*
//       */ R028501 - RC28501 R028801 - RC28801 R029601 - RC29601,  mv( 7=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017104 - RC17104 /*
//       */ R017105 - RC17105 R017107 - RC17107 R017108 - RC17108 /*
//       */ R017110 - RC17110 R055501 - RC55501 R055801 - RC55801 /*
//       */ R056101 - RC56101 R056301 - RC56301 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R013201 - RC13201 R013203 - RC13203 R013205 - RC13205 /*
//       */ R013207 - RC13207 R013209 - RC13209 R013211 - RC13211 /*
//       */ R013212 - RC13212 R034601 - RC34601 R034901 - RC34901 /*
//       */ R035001 - RC35001 R035201 - RC35201 R035301 - RC35301 /*
//       */ R053401 - RC53401 R053402 - RC53402 R053405 - RC53405 /*
//       */ R053408 - RC53408 R053410 - RC53410 R056501 - RC56501 /*
//       */ R056801 - RC56801 R057101 - RC57101 R057301 - RC57301 /*
//       */ R013402 - RC13402 R013403 - RC13403 R013405 - RC13405 /*
//       */ R013406 - RC13406 R013407 - RC13407 R013409 - RC13409 /*
//       */ R013411 - RC13411 R013413 - RC13413 R013001 - RC13001 /*
//       */ R013003 - RC13003 R013004 - RC13004 R013005 - RC13005 /*
//       */ R013007 - RC13007 R013008 - RC13008 R013009 - RC13009 /*
//       */ R013010 - RC13010 R013011 - RC13011 R053202 - RC53202 /*
//       */ R053203 - RC53203 R053205 - RC53205 R053207 - RC53207 /*
//       */ R053209 - RC53209 R016201 - RC16201 R016202 - RC16202 /*
//       */ R016204 - RC16204 R016205 - RC16205 R016207 - RC16207 /*
//       */ R016210 - RC16210 R016211 - RC16211 R016212 - RC16212 /*
//       */ R016213 - RC16213 R026501 - RC26501 R026801 - RC26801 /*
//       */ R027201 - RC27201 R027001 - RC27001 R028401 - RC28401 /*
//       */ R028501 - RC28501 R028801 - RC28801 R029601 - RC29601,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017104 - RC17104 /*
//       */ R017105 - RC17105 R017107 - RC17107 R017108 - RC17108 /*
//       */ R017110 - RC17110 R055501 - RC55501 R055801 - RC55801 /*
//       */ R056101 - RC56101 R056301 - RC56301 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R013201 - RC13201 R013203 - RC13203 R013205 - RC13205 /*
//       */ R013207 - RC13207 R013209 - RC13209 R013211 - RC13211 /*
//       */ R013212 - RC13212 R034601 - RC34601 R034901 - RC34901 /*
//       */ R035001 - RC35001 R035201 - RC35201 R035301 - RC35301 /*
//       */ R053401 - RC53401 R053402 - RC53402 R053405 - RC53405 /*
//       */ R053408 - RC53408 R053410 - RC53410 R056501 - RC56501 /*
//       */ R056801 - RC56801 R057101 - RC57101 R057301 - RC57301 /*
//       */ R013402 - RC13402 R013403 - RC13403 R013405 - RC13405 /*
//       */ R013406 - RC13406 R013407 - RC13407 R013409 - RC13409 /*
//       */ R013411 - RC13411 R013413 - RC13413 R013001 - RC13001 /*
//       */ R013003 - RC13003 R013004 - RC13004 R013005 - RC13005 /*
//       */ R013007 - RC13007 R013008 - RC13008 R013009 - RC13009 /*
//       */ R013010 - RC13010 R013011 - RC13011 R053202 - RC53202 /*
//       */ R053203 - RC53203 R053205 - RC53205 R053207 - RC53207 /*
//       */ R053209 - RC53209 R016201 - RC16201 R016202 - RC16202 /*
//       */ R016204 - RC16204 R016205 - RC16205 R016207 - RC16207 /*
//       */ R016210 - RC16210 R016211 - RC16211 R016212 - RC16212 /*
//       */ R016213 - RC16213 R026501 - RC26501 R026801 - RC26801 /*
//       */ R027201 - RC27201 R027001 - RC27001 R028401 - RC28401 /*
//       */ R028501 - RC28501 R028801 - RC28801 R029601 - RC29601,  mv( 6=.s)
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
// recode R017101 R017108 R012601 R012604 R012612 R013203 R013205 R013207 /*
//     */ R013209 R013211 R053402 R053410 R056501 R013402 R013405 R013407 /*
//     */ R013409 R013411 R013413 R013001 R013003 R013005 R013007 R013008 /*
//     */ R013009 R013010 R013011 R027001 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R017102 R017110 R053408 R053202 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017103 R055901 R012606 R012609 R013208 R013210 R034801 R056901 /*
//     */ R057401 R013401 R013002 R016209 (1=0) (2=0) (3=0) (4=1) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode R017104 R017107 R055501 R055801 R056301 R034601 R034901 R035001 /*
//     */ R035201 R053401 R056801 R057101 R057301 R053203 R053207 R053209 /*
//     */ R016202 R016205 R016207 R016211 R016212 R027201 R028401 R028501 /*
//     */ R029601 (1=0) (2=1) (3=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode R017105 R056101 R013201 R013212 R035301 R053405 R053205 R016204 /*
//     */ R016210 R026801 R028801 (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017106 R012610 R013202 R013206 R057201 R013408 R013006 R016206 /*
//     */ R027101 R028301 R029501 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) (else=.)
// recode R017109 R055701 R056001 R012603 R012605 R013204 R034501 R034701 /*
//     */ R035401 R056601 R013410 R016203 R027301 R026601 R028201 R026901 /*
//     */ R029701 R029001 R029801 (1=0) (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) (else=.)
// recode R055601 R056201 R012602 R012608 R035101 R056701 R057001 R013404 /*
//     */ R013012 R016208 R026401 R029901 (1=0) (2=0) (3=1) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode R012607 (1=0) (2=1) (3=2) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R053403 R053201 R053206 (1=0) (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) (else=.)
// recode R053404 R053409 R053204 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) (else=.)
// recode R053406 R053411 R053210 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) (else=.)
// recode R053407 R053208 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) (else=.)
// recode R013403 R013004 (1=0) (2=0) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R013406 (1=0) (2=0) (3=1) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R016201 R016213 R026501 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2007
gen grade=8
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2007\naep_read_gr8_2007", replace


