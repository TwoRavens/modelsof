version 8
clear
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Reading G8\stata\LABELDEF.do"
label data "  2003 National Reading Assessment: Grade  8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Reading G8\stata\R34NT2AT.DCT", clear
label values  FIPS02    FIPS02V
label values  ORIGSUB   ORIGSUB
label values  PUBPRIV   PUBPRIV
label values  BMONTH    BMONTH
label values  SEX       SEX
label values  RACE      RACE
label values  IEPORIG   YESNO
label values  LEPORIG   YESNO
label values  TITLE1    YESNO
label values  IEP       YESNO
label values  LEP       YESNO
label values  SLUNCH    SLUNCH
label values  SLUNCH1   SLUNCH1V
label values  NEWENRL   NEWENRL
label values  COHORT    COHORT
label values  NATFLAG   NATFLAG
label values  TUALEA    TUALEA
label values  CHARTER   CHARTER
label values  CHRTSCH   CHARTER
label values  MOB       BMONTH
label values  MOBCHG    MOBCHG
label values  YOBCHG    MOBCHG
label values  DSEX      SEX
label values  SEXCHG    MOBCHG
label values  SDCHG     SDCHG
label values  LEPCHG    LEPCHG
label values  SRACE     SRACE
label values  SRACCHG   SRACCHG
label values  SLUNCHW   SLUNCHW
label values  TITLE1W   TITLE1W
label values  ORGSUPP   ORGSUPP
label values  REGION    REGION
label values  REGIONS   REGION
label values  CENSREG   CENSREG
label values  CENSDIV   CENSDIV
label values  MSAFLG    MSAFLG
label values  TOL9      TOL9V
label values  ABSSERT   ABSSERT
label values  IDFLAG    MOBCHG
label values  OBKFLG    MOBCHG
label values  NSLPFLG   NSLPFLG
label values  TTL1FLG   NSLPFLG
label values  SCHTYPE   SCHTYPE
label values  RPTSAMP   RPTSAMP
label values  ARPTSMP   ARPTSMP
label values  ACCOM2    ACCOM2V
label values  ACCOMTY   ACCOMTY
label values  TOL7      TOL7V
label values  TOL5      TOL5V
label values  TOL3      TOL3V
label values  TUAFLG2   TUAFLG2V
label values  PARED     PARED
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SDRACEM   SDRACEM
label values  SCHTY02   SCHTY02V
label values  SAMPTYP   SAMPTYP
label values  FIPS      FIPS
label values  SENROL8   SENROL8V
label values  YRSEXP    YRSEXP
label values  YRSLART   YRSEXP
label values  PCTBLKC   PCTRACE
label values  PCTHSPC   PCTRACE
label values  PCTASNC   PCTRACE
label values  PCTINDC   PCTRACE
label values  R3SAMP    R3SAMP
label values  P3SAMPN   R3SAMP
label values  P3SAMPS   R3SAMP
label values  DISTCOD   DISTCOD
label values  Y34R3     BLKUSE
label values  Y34R4     BLKUSE
label values  Y34R5     BLKUSE
label values  Y34R6     BLKUSE
label values  Y34R7     BLKUSE
label values  Y34R8     BLKUSE
label values  Y34R9     BLKUSE
label values  Y34R10    BLKUSE
label values  Y34R11    BLKUSE
label values  Y34R12    BLKUSE
label values  Y34R13    BLKUSE
label values  Y34R14    BLKUSE
label values  Y34R15    BLKUSE
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
label values  B017301   YESNO
label values  B001151   B001151V
label values  B017451   B017451V
label values  B017501   B017501V
label values  B018101   B018101V
label values  B003501   B003501V
label values  B003601   B003501V
label values  B018201   B018201V
label values  R833001   AGREE4A
label values  R833101   AGREE4A
label values  R833201   AGREE4A
label values  R833301   AGREE4A
label values  R833401   AGREE4A
label values  R833501   FREQ4E
label values  R833601   FREQ4E
label values  R833701   FREQ4E
label values  R833801   FREQ4E
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
label values  R835601   FREQ5A
label values  R835701   FREQ5A
label values  R835801   FREQ5A
label values  R835901   R835901V
label values  R836001   R835901V
label values  R836101   R835901V
label values  R836201   R835901V
label values  R832801   R832801V
label values  R836401   FREQ4E
label values  R836501   FREQ4E
label values  R017101   R017101V
label values  RB17101   R017101V
label values  RC17101   R017101V
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
label values  R017108   R017101V
label values  RB17108   R017101V
label values  RC17108   R017101V
label values  R017109   MC5B
label values  R017110   R017102V
label values  RB17110   R017102V
label values  RC17110   R017102V
label values  R018401   R017102V
label values  RB18401   R017102V
label values  RC18401   R017102V
label values  R018501   MC5A
label values  R018601   R017102V
label values  RB18601   R017102V
label values  RC18601   R017102V
label values  R018701   R017102V
label values  RB18701   R017102V
label values  RC18701   R017102V
label values  R018801   R017102V
label values  RB18801   R017102V
label values  RC18801   R017102V
label values  R018901   MC5B
label values  R019001   RATE4A
label values  RB19001   RATE4A
label values  RC19001   RATE4A
label values  R019101   R017102V
label values  RB19101   R017102V
label values  RC19101   R017102V
label values  R019201   R017102V
label values  RB19201   R017102V
label values  RC19201   R017102V
label values  R012601   R017101V
label values  RB12601   R017101V
label values  RC12601   R017101V
label values  R012602   MC5C
label values  R012603   MC5B
label values  R012604   R017101V
label values  RB12604   R017101V
label values  RC12604   R017101V
label values  R012605   MC5B
label values  R012606   MC5D
label values  R012607   RATE4A
label values  RB12607   RATE4A
label values  RC12607   RATE4A
label values  R012608   MC5C
label values  R012609   MC5D
label values  R012610   MC5A
label values  R012612   R017101V
label values  RB12612   R017101V
label values  RC12612   R017101V
label values  R013201   RATE4A
label values  RB13201   RATE4A
label values  RC13201   RATE4A
label values  R013202   MC5A
label values  R013203   R017101V
label values  RB13203   R017101V
label values  RC13203   R017101V
label values  R013204   MC5B
label values  R013205   R017101V
label values  RB13205   R017101V
label values  RC13205   R017101V
label values  R013206   MC5A
label values  R013207   R017101V
label values  RB13207   R017101V
label values  RC13207   R017101V
label values  R013208   MC5D
label values  R013209   R017101V
label values  RB13209   R017101V
label values  RC13209   R017101V
label values  R013210   MC5D
label values  R013211   R017101V
label values  RB13211   R017101V
label values  RC13211   R017101V
label values  R013212   RATE4A
label values  RB13212   RATE4A
label values  RC13212   RATE4A
label values  R012701   MC5B
label values  R012702   R017101V
label values  RB12702   R017101V
label values  RC12702   R017101V
label values  R012707   MC5C
label values  R012704   MC5C
label values  R012705   R017101V
label values  RB12705   R017101V
label values  RC12705   R017101V
label values  R012706   R017101V
label values  RB12706   R017101V
label values  RC12706   R017101V
label values  R012711   MC5D
label values  R012703   R017101V
label values  RB12703   R017101V
label values  RC12703   R017101V
label values  R012709   MC5A
label values  R012714   RATE4A
label values  RB12714   RATE4A
label values  RC12714   RATE4A
label values  R012710   R017101V
label values  RB12710   R017101V
label values  RC12710   R017101V
label values  R012712   MC5B
label values  R012713   R017101V
label values  RB12713   RATE2D
label values  RC12713   RATE2D
label values  R017201   MC5B
label values  R017202   R017102V
label values  RB17202   R017102V
label values  RC17202   R017102V
label values  R017203   MC5C
label values  R017204   R017102V
label values  RB17204   R017102V
label values  RC17204   R017102V
label values  R017205   RATE4A
label values  RB17205   RATE4A
label values  RC17205   RATE4A
label values  R017206   MC5B
label values  R017207   R017102V
label values  RB17207   R017102V
label values  RC17207   R017102V
label values  R017208   R017102V
label values  RB17208   R017102V
label values  RC17208   R017102V
label values  R017209   MC5A
label values  R017210   R017101V
label values  RB17210   R017101V
label values  RC17210   R017101V
label values  R016101   R017102V
label values  RB16101   R017102V
label values  RC16101   R017102V
label values  R016102   MC5C
label values  R016103   MC5B
label values  R016104   R017102V
label values  RB16104   R017102V
label values  RC16104   R017102V
label values  R016105   MC5A
label values  R016106   MC5D
label values  R016107   R017102V
label values  RB16107   R017102V
label values  RC16107   R017102V
label values  R016108   R017102V
label values  RB16108   R017102V
label values  RC16108   R017102V
label values  R016109   R017102V
label values  RB16109   R017102V
label values  RC16109   R017102V
label values  R013401   MC5D
label values  R013402   R017101V
label values  RB13402   R017101V
label values  RC13402   R017101V
label values  R013403   RATE4A
label values  RB13403   RATE4A
label values  RC13403   RATE4A
label values  R013404   MC5C
label values  R013405   R017101V
label values  RB13405   R017101V
label values  RC13405   R017101V
label values  R013406   RATE4A
label values  RB13406   RATE4A
label values  RC13406   RATE4A
label values  R013407   R017101V
label values  RB13407   R017101V
label values  RC13407   R017101V
label values  R013408   MC5A
label values  R013409   R017101V
label values  RB13409   R017101V
label values  RC13409   R017101V
label values  R013410   MC5B
label values  R013411   R017101V
label values  RB13411   R017101V
label values  RC13411   R017101V
label values  R013413   R017101V
label values  RB13413   R017101V
label values  RC13413   R017101V
label values  R013001   R017101V
label values  RB13001   R017101V
label values  RC13001   R017101V
label values  R013002   MC5D
label values  R013003   R017101V
label values  RB13003   R017101V
label values  RC13003   R017101V
label values  R013004   RATE4A
label values  RB13004   RATE4A
label values  RC13004   RATE4A
label values  R013005   R017101V
label values  RB13005   R017101V
label values  RC13005   R017101V
label values  R013006   MC5A
label values  R013007   R017101V
label values  RB13007   R017101V
label values  RC13007   R017101V
label values  R013008   R017101V
label values  RB13008   R017101V
label values  RC13008   R017101V
label values  R013009   R017101V
label values  RB13009   R017101V
label values  RC13009   R017101V
label values  R013010   R017101V
label values  RB13010   R017101V
label values  RC13010   R017101V
label values  R013011   R017101V
label values  RB13011   R017101V
label values  RC13011   R017101V
label values  R013012   MC5C
label values  R024301   MC5A
label values  R024401   R017102V
label values  RB24401   R017102V
label values  RC24401   R017102V
label values  R024501   R017102V
label values  RB24501   R017102V
label values  RC24501   R017102V
label values  R024601   MC5C
label values  R025901   MC5B
label values  R025001   R017102V
label values  RB25001   R017102V
label values  RC25001   R017102V
label values  R024801   RATE4A
label values  RB24801   RATE4A
label values  RC24801   RATE4A
label values  R026001   MC5A
label values  R026101   R017101V
label values  RB26101   R017101V
label values  RC26101   R017101V
label values  R025601   R017102V
label values  RB25601   R017102V
label values  RC25601   R017102V
label values  R016201   RATE3C
label values  RB16201   RATE3C
label values  RC16201   RATE3C
label values  R016202   RATE3C
label values  RB16202   RATE3C
label values  RC16202   RATE3C
label values  R016203   MC5E
label values  R016204   RATE4A
label values  RB16204   RATE4A
label values  RC16204   RATE4A
label values  R016205   RATE3C
label values  RB16205   RATE3C
label values  RC16205   RATE3C
label values  R016206   MC5E
label values  R016207   RATE3C
label values  RB16207   RATE3C
label values  RC16207   RATE3C
label values  R016208   MC5E
label values  R016209   MC5E
label values  R016210   RATE4A
label values  RB16210   RATE4A
label values  RC16210   RATE4A
label values  R016211   RATE3C
label values  RB16211   RATE3C
label values  RC16211   RATE3C
label values  R016212   RATE3C
label values  RB16212   RATE3C
label values  RC16212   RATE3C
label values  R016213   RATE3C
label values  RB16213   RATE3C
label values  RC16213   RATE3C
label values  R027301   MC5B
label values  R026401   MC5C
label values  R026501   R017102V
label values  RB26501   R017102V
label values  RC26501   R017102V
label values  R027101   MC5A
label values  R026601   MC5B
label values  R028201   MC5B
label values  R026801   RATE4A
label values  RB26801   RATE4A
label values  RC26801   RATE4A
label values  R027201   R017102V
label values  RB27201   R017102V
label values  RC27201   R017102V
label values  R026901   MC5B
label values  R027001   R017101V
label values  RB27001   R017101V
label values  RC27001   R017101V
label values  R028301   MC5A
label values  R028401   R017102V
label values  RB28401   R017102V
label values  RC28401   R017102V
label values  R028501   R017102V
label values  RB28501   R017102V
label values  RC28501   R017102V
label values  R029501   MC5A
label values  R029701   MC5B
label values  R028801   RATE4A
label values  RB28801   RATE4A
label values  RC28801   RATE4A
label values  R029001   MC5B
label values  R029901   MC5C
label values  R029601   R017102V
label values  RB29601   R017102V
label values  RC29601   R017102V
label values  R029801   MC5B
label values  X005701   YESNO
label values  X005702   YESNO
label values  X005703   YESNO
label values  X005704   YESNO
label values  X005705   YESNO
label values  X012101   X012101Q
label values  X012201   X012201Q
label values  X012301   YESNO
label values  X015101   X015101Q
label values  X015201   X015201Q
label values  X012601   X012601Q
label values  X016001   X015201Q
label values  X013001   X013001Q
label values  X013101   YESNO
label values  X013102   YESNO
label values  X013103   YESNO
label values  X013104   YESNO
label values  X013105   YESNO
label values  X013106   YESNO
label values  X013107   YESNO
label values  X013108   YESNO
label values  X013109   YESNO
label values  X013201   YESNO
label values  X013202   YESNO
label values  X013203   YESNO
label values  X013204   YESNO
label values  X013205   YESNO
label values  X013206   YESNO
label values  X013207   YESNO
label values  X013208   YESNO
label values  X013209   YESNO
label values  X013210   YESNO
label values  X013211   YESNO
label values  X013301   YESNO
label values  X013302   YESNO
label values  X013303   YESNO
label values  X013401   YESNO
label values  X013402   YESNO
label values  X013403   YESNO
label values  X013404   YESNO
label values  X015501   X015501Q
label values  X013601   X015501Q
label values  X013801   X013801Q
label values  X015601   X015601Q
label values  X014001   X015601Q
label values  X014201   X014201Q
label values  X015701   X015701Q
label values  X014401   X015701Q
label values  X014601   X013001Q
label values  X014701   YESNO
label values  X014702   YESNO
label values  X014703   YESNO
label values  X014704   YESNO
label values  X014705   YESNO
label values  X014706   YESNO
label values  X014707   YESNO
label values  X014708   YESNO
label values  X014709   YESNO
label values  X015901   X015901Q
label values  X014901   X015901Q
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
label values  T083151   T083151Q
label values  T077305   MAJOR
label values  T077306   MAJOR
label values  T077307   MAJOR
label values  T086801   MAJOR
label values  T077405   MAJOR
label values  T077406   MAJOR
label values  T077407   MAJOR
label values  T086901   MAJOR
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
label values  T085801   T085801Q
label values  T085901   T085901Q
label values  T083601   FREQ6A
label values  T083602   FREQ6A
label values  T083603   FREQ6A
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
// mvdecode PARED BA21101 - R836501 R017103 R017106 R017109 R018501 R018901 /*
//       */ R012602 R012603  R012605 R012606  R012608 - R012610 R013202 R013204 /*
//       */ R013206 R013208 R013210 R012701 R012707 R012704  R012711 R012709 /*
//       */ R012712 R017201 R017203 R017206 R017209 R016102 R016103  /*
//       */ R016105 R016106  R013401 R013404 R013408 R013410 R013002 R013006 /*
//       */ R013012 R024301  R024601 R025901  R026001 R016203 R016206 /*
//       */ R016208 R016209  R027301 R026401  R027101 - R028201 R026901 R028301 /*
//       */ R029501 R029701  R029001 R029901  R029801 X012101 - X013001 /*
//       */ X015501 - X014601 X015901 - TE21201 T077201 - T083603,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017103 - RC17104 /*
//       */ R017105 - RC17105 R017106 - RC17107 R017108 - RC17108 /*
//       */ R017109 - RC17110 R018401 - RC18401 R018501 - RC18601 /*
//       */ R018701 - RC18701 R018801 - RC18801 R018901 - RC19001 /*
//       */ R019101 - RC19101 R019201 - RC19201 R012601 - RC12601 /*
//       */ R012602 - RC12604 R012605 - RC12607 R012608 - RC12612 /*
//       */ R013201 - RC13201 R013202 - RC13203 R013204 - RC13205 /*
//       */ R013206 - RC13207 R013208 - RC13209 R013210 - RC13211 /*
//       */ R013212 - RC13212 R012701 - RC12702 R012707 - RC12705 /*
//       */ R012706 - RC12706 R012711 - RC12703 R012709 - RC12714 /*
//       */ R012710 - RC12710 R012712 - RC12713 R017201 - RC17202 /*
//       */ R017203 - RC17204 R017205 - RC17205 R017206 - RC17207 /*
//       */ R017208 - RC17208 R017209 - RC17210 R016101 - RC16101 /*
//       */ R016102 - RC16104 R016105 - RC16107 R016108 - RC16108 /*
//       */ R016109 - RC16109 R013401 - RC13402 R013403 - RC13403 /*
//       */ R013404 - RC13405 R013406 - RC13406 R013407 - RC13407 /*
//       */ R013408 - RC13409 R013410 - RC13411 R013413 - RC13413 /*
//       */ R013001 - RC13001 R013002 - RC13003 R013004 - RC13004 /*
//       */ R013005 - RC13005 R013006 - RC13007 R013008 - RC13008 /*
//       */ R013009 - RC13009 R013010 - RC13010 R013011 - RC13011 /*
//       */ R013012 - RC24401 R024501 - RC24501 R024601 - RC25001 /*
//       */ R024801 - RC24801 R026001 - RC26101 R025601 - RC25601 /*
//       */ R016201 - RC16201 R016202 - RC16202 R016203 - RC16204 /*
//       */ R016205 - RC16205 R016206 - RC16207 R016208 - RC16210 /*
//       */ R016211 - RC16211 R016212 - RC16212 R016213 - RC16213 /*
//       */ R027301 - RC26501 R027101 - RC26801 R027201 - RC27201 /*
//       */ R026901 - RC27001 R028301 - RC28401 R028501 - RC28501 /*
//       */ R029501 - RC28801 R029001 - RC29601 R029801,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 PARED HISPYES - SCHTY02 SENROL8 - PCTINDC BA21101 - RC17101 /*
//       */ R017102 - RC17102 R017103 - RC17104 R017105 - RC17105 /*
//       */ R017106 - RC17107 R017108 - RC17108 R017109 - RC17110 /*
//       */ R018401 - RC18401 R018501 - RC18601 R018701 - RC18701 /*
//       */ R018801 - RC18801 R018901 - RC19001 R019101 - RC19101 /*
//       */ R019201 - RC19201 R012601 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R013201 - RC13201 /*
//       */ R013202 - RC13203 R013204 - RC13205 R013206 - RC13207 /*
//       */ R013208 - RC13209 R013210 - RC13211 R013212 - RC13212 /*
//       */ R012701 - RC12702 R012707 - RC12705 R012706 - RC12706 /*
//       */ R012711 - RC12703 R012709 - RC12714 R012710 - RC12710 /*
//       */ R012712 - RC12713 R017201 - RC17202 R017203 - RC17204 /*
//       */ R017205 - RC17205 R017206 - RC17207 R017208 - RC17208 /*
//       */ R017209 - RC17210 R016101 - RC16101 R016102 - RC16104 /*
//       */ R016105 - RC16107 R016108 - RC16108 R016109 - RC16109 /*
//       */ R013401 - RC13402 R013403 - RC13403 R013404 - RC13405 /*
//       */ R013406 - RC13406 R013407 - RC13407 R013408 - RC13409 /*
//       */ R013410 - RC13411 R013413 - RC13413 R013001 - RC13001 /*
//       */ R013002 - RC13003 R013004 - RC13004 R013005 - RC13005 /*
//       */ R013006 - RC13007 R013008 - RC13008 R013009 - RC13009 /*
//       */ R013010 - RC13010 R013011 - RC13011 R013012 - RC24401 /*
//       */ R024501 - RC24501 R024601 - RC25001 R024801 - RC24801 /*
//       */ R026001 - RC26101 R025601 - RC25601 R016201 - RC16201 /*
//       */ R016202 - RC16202 R016203 - RC16204 R016205 - RC16205 /*
//       */ R016206 - RC16207 R016208 - RC16210 R016211 - RC16211 /*
//       */ R016212 - RC16212 R016213 - RC16213 R027301 - RC26501 /*
//       */ R027101 - RC26801 R027201 - RC27201 R026901 - RC27001 /*
//       */ R028301 - RC28401 R028501 - RC28501 R029501 - RC28801 /*
//       */ R029001 - RC29601 R029801 - X005705 X012201 - TE21201 /*
//       */ T077201 - T083603,  mv( 8=.o)
// mvdecode X012101,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B017301  B003501 B003601  /*
//       */ X012301 - X016001 X015601 X014001  X015701 X014401,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017104 - RC17104 /*
//       */ R017105 - RC17105 R017107 - RC17107 R017108 - RC17108 /*
//       */ R017110 - RC17110 R018401 - RC18401 R018601 - RC18601 /*
//       */ R018701 - RC18701 R018801 - RC18801 R019001 - RC19001 /*
//       */ R019101 - RC19101 R019201 - RC19201 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R013201 - RC13201 R013203 - RC13203 R013205 - RC13205 /*
//       */ R013207 - RC13207 R013209 - RC13209 R013211 - RC13211 /*
//       */ R013212 - RC13212 R012702 - RC12702 R012705 - RC12705 /*
//       */ R012706 - RC12706 R012703 - RC12703 R012714 - RC12714 /*
//       */ R012710 - RC12710 R012713 - RC12713 R017202 - RC17202 /*
//       */ R017204 - RC17204 R017205 - RC17205 R017207 - RC17207 /*
//       */ R017208 - RC17208 R017210 - RC17210 R016101 - RC16101 /*
//       */ R016104 - RC16104 R016107 - RC16107 R016108 - RC16108 /*
//       */ R016109 - RC16109 R013402 - RC13402 R013403 - RC13403 /*
//       */ R013405 - RC13405 R013406 - RC13406 R013407 - RC13407 /*
//       */ R013409 - RC13409 R013411 - RC13411 R013413 - RC13413 /*
//       */ R013001 - RC13001 R013003 - RC13003 R013004 - RC13004 /*
//       */ R013005 - RC13005 R013007 - RC13007 R013008 - RC13008 /*
//       */ R013009 - RC13009 R013010 - RC13010 R013011 - RC13011 /*
//       */ R024401 - RC24401 R024501 - RC24501 R025001 - RC25001 /*
//       */ R024801 - RC24801 R026101 - RC26101 R025601 - RC25601 /*
//       */ R016201 - RC16201 R016202 - RC16202 R016204 - RC16204 /*
//       */ R016205 - RC16205 R016207 - RC16207 R016210 - RC16210 /*
//       */ R016211 - RC16211 R016212 - RC16212 R016213 - RC16213 /*
//       */ R026501 - RC26501 R026801 - RC26801 R027201 - RC27201 /*
//       */ R027001 - RC27001 R028401 - RC28401 R028501 - RC28501 /*
//       */ R028801 - RC28801 R029601 - RC29601,  mv( 7=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017104 - RC17104 /*
//       */ R017105 - RC17105 R017107 - RC17107 R017108 - RC17108 /*
//       */ R017110 - RC17110 R018401 - RC18401 R018601 - RC18601 /*
//       */ R018701 - RC18701 R018801 - RC18801 R019001 - RC19001 /*
//       */ R019101 - RC19101 R019201 - RC19201 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R013201 - RC13201 R013203 - RC13203 R013205 - RC13205 /*
//       */ R013207 - RC13207 R013209 - RC13209 R013211 - RC13211 /*
//       */ R013212 - RC13212 R012702 - RC12702 R012705 - RC12705 /*
//       */ R012706 - RC12706 R012703 - RC12703 R012714 - RC12714 /*
//       */ R012710 - RC12710 R012713 - RC12713 R017202 - RC17202 /*
//       */ R017204 - RC17204 R017205 - RC17205 R017207 - RC17207 /*
//       */ R017208 - RC17208 R017210 - RC17210 R016101 - RC16101 /*
//       */ R016104 - RC16104 R016107 - RC16107 R016108 - RC16108 /*
//       */ R016109 - RC16109 R013402 - RC13402 R013403 - RC13403 /*
//       */ R013405 - RC13405 R013406 - RC13406 R013407 - RC13407 /*
//       */ R013409 - RC13409 R013411 - RC13411 R013413 - RC13413 /*
//       */ R013001 - RC13001 R013003 - RC13003 R013004 - RC13004 /*
//       */ R013005 - RC13005 R013007 - RC13007 R013008 - RC13008 /*
//       */ R013009 - RC13009 R013010 - RC13010 R013011 - RC13011 /*
//       */ R024401 - RC24401 R024501 - RC24501 R025001 - RC25001 /*
//       */ R024801 - RC24801 R026101 - RC26101 R025601 - RC25601 /*
//       */ R016201 - RC16201 R016202 - RC16202 R016204 - RC16204 /*
//       */ R016205 - RC16205 R016207 - RC16207 R016210 - RC16210 /*
//       */ R016211 - RC16211 R016212 - RC16212 R016213 - RC16213 /*
//       */ R026501 - RC26501 R026801 - RC26801 R027201 - RC27201 /*
//       */ R027001 - RC27001 R028401 - RC28401 R028501 - RC28501 /*
//       */ R028801 - RC28801 R029601 - RC29601,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode R017101 - RC17101 R017102 - RC17102 R017104 - RC17104 /*
//       */ R017105 - RC17105 R017107 - RC17107 R017108 - RC17108 /*
//       */ R017110 - RC17110 R018401 - RC18401 R018601 - RC18601 /*
//       */ R018701 - RC18701 R018801 - RC18801 R019001 - RC19001 /*
//       */ R019101 - RC19101 R019201 - RC19201 R012601 - RC12601 /*
//       */ R012604 - RC12604 R012607 - RC12607 R012612 - RC12612 /*
//       */ R013201 - RC13201 R013203 - RC13203 R013205 - RC13205 /*
//       */ R013207 - RC13207 R013209 - RC13209 R013211 - RC13211 /*
//       */ R013212 - RC13212 R012702 - RC12702 R012705 - RC12705 /*
//       */ R012706 - RC12706 R012703 - RC12703 R012714 - RC12714 /*
//       */ R012710 - RC12710 R012713 - RC12713 R017202 - RC17202 /*
//       */ R017204 - RC17204 R017205 - RC17205 R017207 - RC17207 /*
//       */ R017208 - RC17208 R017210 - RC17210 R016101 - RC16101 /*
//       */ R016104 - RC16104 R016107 - RC16107 R016108 - RC16108 /*
//       */ R016109 - RC16109 R013402 - RC13402 R013403 - RC13403 /*
//       */ R013405 - RC13405 R013406 - RC13406 R013407 - RC13407 /*
//       */ R013409 - RC13409 R013411 - RC13411 R013413 - RC13413 /*
//       */ R013001 - RC13001 R013003 - RC13003 R013004 - RC13004 /*
//       */ R013005 - RC13005 R013007 - RC13007 R013008 - RC13008 /*
//       */ R013009 - RC13009 R013010 - RC13010 R013011 - RC13011 /*
//       */ R024401 - RC24401 R024501 - RC24501 R025001 - RC25001 /*
//       */ R024801 - RC24801 R026101 - RC26101 R025601 - RC25601 /*
//       */ R016201 - RC16201 R016202 - RC16202 R016204 - RC16204 /*
//       */ R016205 - RC16205 R016207 - RC16207 R016210 - RC16210 /*
//       */ R016211 - RC16211 R016212 - RC16212 R016213 - RC16213 /*
//       */ R026501 - RC26501 R026801 - RC26801 R027201 - RC27201 /*
//       */ R027001 - RC27001 R028401 - RC28401 R028501 - RC28501 /*
//       */ R028801 - RC28801 R029601 - RC29601,  mv( 6=.s)
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
//     */ R013209 R013211 R012702 R012705 R012706 R012703 R012710 R012713 /*
//     */ R017210 R013402 R013405 R013407 R013409 R013411 R013413 R013001 /*
//     */ R013003 R013005 R013007 R013008 R013009 R013010 R013011 R026101 /*
//     */ R027001 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017102 R017104 R017107 R018401 R018601 R018801 R019101 R017202 /*
//     */ R017204 R017208 R016101 R016107 R016108 R016109 R024401 R024501 /*
//     */ R025601 R016201 R016202 R016205 R016207 R016211 R016212 R027201 /*
//     */ R028401 R028501 R029601 (1=0) (2=1) (3=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R017103 R012606 R012609 R013208 R013210 R012711 R016106 R013401 /*
//     */ R013002 R016209 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode R017105 R019001 R013201 R013212 R012714 R017205 R016204 R016210 /*
//     */ R026801 R028801 (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R017106 R018501 R012610 R013202 R013206 R012709 R017209 R016105 /*
//     */ R013408 R013006 R024301 R026001 R016206 R027101 R028301 R029501 (1=1) /*
//     */ (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R017109 R018901 R012603 R012605 R013204 R012701 R012712 R017201 /*
//     */ R017206 R016103 R013410 R025901 R016203 R027301 R026601 R028201 /*
//     */ R026901 R029701 R029001 R029801 (1=0) (2=1) (3=0) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode R017110 R019201 R017207 R016104 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R018701 R016213 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R012602 R012608 R012707 R012704 R017203 R016102 R013404 R013012 /*
//     */ R024601 R016208 R026401 R029901 (1=0) (2=0) (3=1) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode R012607 (1=0) (2=1) (3=2) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R013403 R013004 (1=0) (2=0) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R013406 (1=0) (2=0) (3=1) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R025001 R026501 (1=@) (2=@) (3=@) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R024801 (1=@) (2=@) (3=@) (4=@) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)


*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2003
gen grade=8
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2003\naep_read_gr8_2003", replace
