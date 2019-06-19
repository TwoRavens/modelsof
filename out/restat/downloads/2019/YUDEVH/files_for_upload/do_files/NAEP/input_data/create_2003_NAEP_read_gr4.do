version 8
clear
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Reading G4\stata\LABELDEF.do"
label data "  2003 National Reading Assessment: Grade  4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Reading G4\stata\R34NT1AT.DCT", clear
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
label values  ARPTSMP   RPTSAMP
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
label values  SENROL4   SENROL4V
label values  YRSEXP    YRSEXP
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
label values  CHRTRPT   CHRTRPT
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
label values  R830601   LIKEME
label values  R830701   LIKEME
label values  R830801   LIKEME
label values  R830901   LIKEME
label values  R831001   FREQ4E
label values  R831101   FREQ4E
label values  R831201   FREQ4E
label values  R831301   FREQ4E
label values  R831401   FREQ4E
label values  R831501   R831501V
label values  R831601   R831501V
label values  R831701   R831501V
label values  R831801   R831501V
label values  R831901   R831501V
label values  R832001   R831501V
label values  R832101   FREQ5A
label values  R832201   FREQ5A
label values  R832301   FREQ5A
label values  R832401   R831501V
label values  R832501   R831501V
label values  R832601   R831501V
label values  R832701   R831501V
label values  R832801   R832801V
label values  R832901   FREQ4E
label values  R017001   R017001V
label values  RB17001   R017001V
label values  RC17001   R017001V
label values  R017002   MC5B
label values  R017003   R017003V
label values  RB17003   R017003V
label values  RC17003   R017003V
label values  R017004   R017001V
label values  RB17004   R017001V
label values  RC17004   R017001V
label values  R017005   MC5A
label values  R017006   R017001V
label values  RB17006   R017001V
label values  RC17006   R017001V
label values  R017007   RATE4A
label values  RB17007   RATE4A
label values  RC17007   RATE4A
label values  R017008   MC5D
label values  R017009   R017003V
label values  RB17009   R017003V
label values  RC17009   R017003V
label values  R012101   MC5B
label values  R012102   R017001V
label values  RB12102   R017001V
label values  RC12102   R017001V
label values  R012103   MC5C
label values  R012104   R017001V
label values  RB12104   R017001V
label values  RC12104   R017001V
label values  R012105   MC5D
label values  R012106   R017001V
label values  RB12106   R017001V
label values  RC12106   R017001V
label values  R012107   MC5C
label values  R012113   R017003V
label values  RB12113   R017003V
label values  RC12113   R017003V
label values  R012109   R017001V
label values  RB12109   R017001V
label values  RC12109   R017001V
label values  R012110   MC5B
label values  R012111   RATE4A
label values  RB12111   RATE4A
label values  RC12111   RATE4A
label values  R012112   R017001V
label values  RB12112   R017001V
label values  RC12112   R017001V
label values  R012601   R017001V
label values  RB12601   R017001V
label values  RC12601   R017001V
label values  R012602   MC5C
label values  R012603   MC5B
label values  R012604   R017001V
label values  RB12604   R017001V
label values  RC12604   R017001V
label values  R012605   MC5B
label values  R012606   MC5D
label values  R012607   RATE4A
label values  RB12607   RATE4A
label values  RC12607   RATE4A
label values  R012608   MC5C
label values  R012609   MC5D
label values  R012610   MC5A
label values  R012612   R017001V
label values  RB12612   R017001V
label values  RC12612   R017001V
label values  R017301   R017001V
label values  RB17301   R017001V
label values  RC17301   R017001V
label values  R017302   MC5B
label values  R017303   R017003V
label values  RB17303   R017003V
label values  RC17303   R017003V
label values  R017304   MC5A
label values  R017310   R017003V
label values  RB17310   R017003V
label values  RC17310   R017003V
label values  R017306   MC5B
label values  R017307   RATE4A
label values  RB17307   RATE4A
label values  RC17307   RATE4A
label values  R017308   MC5C
label values  R017309   R017003V
label values  RB17309   R017003V
label values  RC17309   R017003V
label values  R012701   MC5B
label values  R012702   R017001V
label values  RB12702   R017001V
label values  RC12702   R017001V
label values  R012703   R017001V
label values  RB12703   R017001V
label values  RC12703   R017001V
label values  R012704   MC5C
label values  R012705   R017001V
label values  RB12705   R017001V
label values  RC12705   R017001V
label values  R012706   R017001V
label values  RB12706   R017001V
label values  RC12706   R017001V
label values  R012707   MC5C
label values  R012714   RATE4A
label values  RB12714   RATE4A
label values  RC12714   RATE4A
label values  R012709   MC5A
label values  R012710   R017001V
label values  RB12710   R017001V
label values  RC12710   R017001V
label values  R017401   R017003V
label values  RB17401   R017003V
label values  RC17401   R017003V
label values  R017501   MC5A
label values  R017601   MC5C
label values  R017701   R017003V
label values  RB17701   R017003V
label values  RC17701   R017003V
label values  R017801   MC5D
label values  R017901   RATE4A
label values  RB17901   RATE4A
label values  RC17901   RATE4A
label values  R018001   MC5C
label values  R018101   MC5B
label values  R018201   R017003V
label values  RB18201   R017003V
label values  RC18201   R017003V
label values  R018301   R017003V
label values  RB18301   R017003V
label values  RC18301   R017003V
label values  R015801   MC5D
label values  R015810   R017003V
label values  RB15810   R017003V
label values  RC15810   R017003V
label values  R015803   R017003V
label values  RB15803   R017003V
label values  RC15803   R017003V
label values  R015804   RATE4A
label values  RB15804   RATE4A
label values  RC15804   RATE4A
label values  R015805   MC5B
label values  R015806   R017003V
label values  RB15806   R017003V
label values  RC15806   R017003V
label values  R015807   R017003V
label values  RB15807   R017003V
label values  RC15807   R017003V
label values  R015808   MC5C
label values  R015809   R017003V
label values  RB15809   R017003V
label values  RC15809   R017003V
label values  R012501   MC5A
label values  R012502   MC5C
label values  R012503   R017001V
label values  RB12503   R017001V
label values  RC12503   R017001V
label values  R012504   R017001V
label values  RB12504   R017001V
label values  RC12504   R017001V
label values  R012505   MC5D
label values  R012506   R017001V
label values  RB12506   R017001V
label values  RC12506   R017001V
label values  R012507   MC5B
label values  R012508   R017001V
label values  RB12508   R017001V
label values  RC12508   R017001V
label values  R012509   MC5C
label values  R012510   MC5B
label values  R012511   R017001V
label values  RB12511   R017001V
label values  RC12511   R017001V
label values  R012512   RATE4A
label values  RB12512   RATE4A
label values  RC12512   RATE4A
label values  R021601   MC5A
label values  R020401   R017003V
label values  RB20401   R017003V
label values  RC20401   R017003V
label values  R020601   MC5C
label values  R021101   MC5A
label values  R020701   R020701V
label values  RB20701   R020701V
label values  RC20701   R020701V
label values  R020501   MC5B
label values  R022101   MC5C
label values  R021701   R017003V
label values  RB21701   R017003V
label values  RC21701   R017003V
label values  R022201   MC5B
label values  R021201   R017003V
label values  RB21201   R017003V
label values  RC21201   R017003V
label values  R023301   MC5D
label values  R022401   MC5B
label values  R023501   R017003V
label values  RB23501   R017003V
label values  RC23501   R017003V
label values  R023601   R017003V
label values  RB23601   R017003V
label values  RC23601   R017003V
label values  R023801   MC5A
label values  R022901   MC5B
label values  R024001   R017003V
label values  RB24001   R017003V
label values  RC24001   R017003V
label values  R023101   MC5C
label values  R024101   MC5B
label values  R023201   R017001V
label values  RB23201   R017001V
label values  RC23201   R017001V
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
label values  T077309   MAJOR
label values  T077310   MAJOR
label values  T077311   MAJOR
label values  T077312   MAJOR
label values  T077405   MAJOR
label values  T077406   MAJOR
label values  T077407   MAJOR
label values  T077409   MAJOR
label values  T077410   MAJOR
label values  T077411   MAJOR
label values  T077412   MAJOR
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
label values  T083201   YESNO
label values  T086301   YESNO
label values  T086401   T086401Q
label values  T086501   T086501Q
label values  T086601   T086601Q
label values  T083401   T083401Q
label values  T083501   T083501Q
label values  T086701   T083501Q
label values  T046101   YESNO
label values  T046201   T046201Q
label values  T068351   T068351Q
label values  T070151   FREQ4F
label values  T070152   FREQ4F
label values  T070153   FREQ4F
label values  T070154   FREQ4F
label values  T070155   FREQ4F
label values  T070156   FREQ4F
label values  T070157   FREQ4F
label values  T057451   FREQ4F
label values  T057452   FREQ4F
label values  T057453   FREQ4F
label values  T057454   FREQ4F
label values  T057651   T057651Q
label values  T044002   YESNO
label values  T057801   T057801Q
label values  T044201   YESNO
label values  T044401   T044401Q
label values  T075351   EMPHAS
label values  T075352   EMPHAS
label values  T075353   EMPHAS
label values  T075354   EMPHAS
label values  T075355   EMPHAS
label values  T045401   YESNO
label values  T044801   YESNO
label values  T045001   YESNO
label values  T044901   YESNO
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
// mvdecode PARED BA21101 - R832901 R017002 R017005 R017008 R012101 R012103 /*
//       */ R012105 R012107 R012110 R012602 R012603  R012605 R012606  /*
//       */ R012608 - R012610 R017302 R017304 R017306 R017308 R012701 R012704 /*
//       */ R012707 R012709 R017501 R017601  R017801 R018001 R018101  R015801 /*
//       */ R015805 R015808 R012501 R012502  R012505 R012507 R012509 R012510  /*
//       */ R021601 R020601 R021101  R020501 R022101  R022201 R023301 R022401  /*
//       */ R023801 R022901  R023101 R024101  X012101 - X013001 /*
//       */ X015501 - X014601 X015901 - TE21201 T077201 - T044901,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode R017001 - RC17001 R017002 - RC17003 R017004 - RC17004 /*
//       */ R017005 - RC17006 R017007 - RC17007 R017008 - RC17009 /*
//       */ R012101 - RC12102 R012103 - RC12104 R012105 - RC12106 /*
//       */ R012107 - RC12113 R012109 - RC12109 R012110 - RC12111 /*
//       */ R012112 - RC12112 R012601 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R017301 - RC17301 /*
//       */ R017302 - RC17303 R017304 - RC17310 R017306 - RC17307 /*
//       */ R017308 - RC17309 R012701 - RC12702 R012703 - RC12703 /*
//       */ R012704 - RC12705 R012706 - RC12706 R012707 - RC12714 /*
//       */ R012709 - RC12710 R017401 - RC17401 R017501 - RC17701 /*
//       */ R017801 - RC17901 R018001 - RC18201 R018301 - RC18301 /*
//       */ R015801 - RC15810 R015803 - RC15803 R015804 - RC15804 /*
//       */ R015805 - RC15806 R015807 - RC15807 R015808 - RC15809 /*
//       */ R012501 - RC12503 R012504 - RC12504 R012505 - RC12506 /*
//       */ R012507 - RC12508 R012509 - RC12511 R012512 - RC12512 /*
//       */ R021601 - RC20401 R020601 - RC20701 R020501 - RC21701 /*
//       */ R022201 - RC21201 R023301 - RC23501 R023601 - RC23601 /*
//       */ R023801 - RC24001 R023101 - RC23201,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 PARED HISPYES - SCHTY02 SENROL4 - PCTINDC BA21101 - RC17001 /*
//       */ R017002 - RC17003 R017004 - RC17004 R017005 - RC17006 /*
//       */ R017007 - RC17007 R017008 - RC17009 R012101 - RC12102 /*
//       */ R012103 - RC12104 R012105 - RC12106 R012107 - RC12113 /*
//       */ R012109 - RC12109 R012110 - RC12111 R012112 - RC12112 /*
//       */ R012601 - RC12601 R012602 - RC12604 R012605 - RC12607 /*
//       */ R012608 - RC12612 R017301 - RC17301 R017302 - RC17303 /*
//       */ R017304 - RC17310 R017306 - RC17307 R017308 - RC17309 /*
//       */ R012701 - RC12702 R012703 - RC12703 R012704 - RC12705 /*
//       */ R012706 - RC12706 R012707 - RC12714 R012709 - RC12710 /*
//       */ R017401 - RC17401 R017501 - RC17701 R017801 - RC17901 /*
//       */ R018001 - RC18201 R018301 - RC18301 R015801 - RC15810 /*
//       */ R015803 - RC15803 R015804 - RC15804 R015805 - RC15806 /*
//       */ R015807 - RC15807 R015808 - RC15809 R012501 - RC12503 /*
//       */ R012504 - RC12504 R012505 - RC12506 R012507 - RC12508 /*
//       */ R012509 - RC12511 R012512 - RC12512 R021601 - RC20401 /*
//       */ R020601 - RC20701 R020501 - RC21701 R022201 - RC21201 /*
//       */ R023301 - RC23501 R023601 - RC23601 R023801 - RC24001 /*
//       */ R023101 - RC23201 X005701 - X005705 X012201 - TE21201 /*
//       */ T077201 - T044901,  mv( 8=.o)
// mvdecode X012101,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B017301  B003501 B003601  /*
//       */ X012301 - X016001 X015601 X014001  X015701 X014401,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode R017001 - RC17001 R017003 - RC17003 R017004 - RC17004 /*
//       */ R017006 - RC17006 R017007 - RC17007 R017009 - RC17009 /*
//       */ R012102 - RC12102 R012104 - RC12104 R012106 - RC12106 /*
//       */ R012113 - RC12113 R012109 - RC12109 R012111 - RC12111 /*
//       */ R012112 - RC12112 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R012702 - RC12702 R012703 - RC12703 /*
//       */ R012705 - RC12705 R012706 - RC12706 R012714 - RC12714 /*
//       */ R012710 - RC12710 R017401 - RC17401 R017701 - RC17701 /*
//       */ R017901 - RC17901 R018201 - RC18201 R018301 - RC18301 /*
//       */ R015810 - RC15810 R015803 - RC15803 R015804 - RC15804 /*
//       */ R015806 - RC15806 R015807 - RC15807 R015809 - RC15809 /*
//       */ R012503 - RC12503 R012504 - RC12504 R012506 - RC12506 /*
//       */ R012508 - RC12508 R012511 - RC12511 R012512 - RC12512 /*
//       */ R020401 - RC20401 R020701 - RC20701 R021701 - RC21701 /*
//       */ R021201 - RC21201 R023501 - RC23501 R023601 - RC23601 /*
//       */ R024001 - RC24001 R023201 - RC23201,  mv( 7=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R017001 - RC17001 R017003 - RC17003 R017004 - RC17004 /*
//       */ R017006 - RC17006 R017007 - RC17007 R017009 - RC17009 /*
//       */ R012102 - RC12102 R012104 - RC12104 R012106 - RC12106 /*
//       */ R012113 - RC12113 R012109 - RC12109 R012111 - RC12111 /*
//       */ R012112 - RC12112 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R012702 - RC12702 R012703 - RC12703 /*
//       */ R012705 - RC12705 R012706 - RC12706 R012714 - RC12714 /*
//       */ R012710 - RC12710 R017401 - RC17401 R017701 - RC17701 /*
//       */ R017901 - RC17901 R018201 - RC18201 R018301 - RC18301 /*
//       */ R015810 - RC15810 R015803 - RC15803 R015804 - RC15804 /*
//       */ R015806 - RC15806 R015807 - RC15807 R015809 - RC15809 /*
//       */ R012503 - RC12503 R012504 - RC12504 R012506 - RC12506 /*
//       */ R012508 - RC12508 R012511 - RC12511 R012512 - RC12512 /*
//       */ R020401 - RC20401 R020701 - RC20701 R021701 - RC21701 /*
//       */ R021201 - RC21201 R023501 - RC23501 R023601 - RC23601 /*
//       */ R024001 - RC24001 R023201 - RC23201,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode R017001 - RC17001 R017003 - RC17003 R017004 - RC17004 /*
//       */ R017006 - RC17006 R017007 - RC17007 R017009 - RC17009 /*
//       */ R012102 - RC12102 R012104 - RC12104 R012106 - RC12106 /*
//       */ R012113 - RC12113 R012109 - RC12109 R012111 - RC12111 /*
//       */ R012112 - RC12112 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R012702 - RC12702 R012703 - RC12703 /*
//       */ R012705 - RC12705 R012706 - RC12706 R012714 - RC12714 /*
//       */ R012710 - RC12710 R017401 - RC17401 R017701 - RC17701 /*
//       */ R017901 - RC17901 R018201 - RC18201 R018301 - RC18301 /*
//       */ R015810 - RC15810 R015803 - RC15803 R015804 - RC15804 /*
//       */ R015806 - RC15806 R015807 - RC15807 R015809 - RC15809 /*
//       */ R012503 - RC12503 R012504 - RC12504 R012506 - RC12506 /*
//       */ R012508 - RC12508 R012511 - RC12511 R012512 - RC12512 /*
//       */ R020401 - RC20401 R020701 - RC20701 R021701 - RC21701 /*
//       */ R021201 - RC21201 R023501 - RC23501 R023601 - RC23601 /*
//       */ R024001 - RC24001 R023201 - RC23201,  mv( 6=.s)
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
// recode R017001 R017004 R017006 R012102 R012104 R012106 R012109 R012112 /*
//     */ R012601 R012604 R012612 R017301 R012702 R012703 R012705 R012706 /*
//     */ R012710 R012503 R012504 R012506 R012508 R012511 R020701 R023201 (1=0) /*
//     */ (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017002 R012101 R012110 R012603 R012605 R017302 R017306 R012701 /*
//     */ R018101 R015805 R012507 R012510 R020501 R022201 R022401 R022901 /*
//     */ R024101 (1=0) (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R017003 R017009 R012113 R017303 R017310 R017309 R017401 R017701 /*
//     */ R018201 R018301 R015810 R015803 R015806 R015807 R015809 R021701 /*
//     */ R021201 R023501 R024001 (1=0) (2=1) (3=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R017005 R012610 R017304 R012709 R017501 R012501 R021601 R021101 /*
//     */ R023801 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R017007 R012607 R017307 R012714 R015804 R012512 (1=0) (2=1) (3=2) /*
//     */ (4=3) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017008 R012105 R012606 R012609 R017801 R015801 R012505 R023301 (1=0) /*
//     */ (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R012103 R012107 R012602 R012608 R017308 R012704 R012707 R017601 /*
//     */ R018001 R015808 R012502 R012509 R020601 R022101 R023101 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R012111 R017901 (1=0) (2=0) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R020401 R023601 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)


*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2003
gen grade=4
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress

save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2003\naep_read_gr4_2003", replace


