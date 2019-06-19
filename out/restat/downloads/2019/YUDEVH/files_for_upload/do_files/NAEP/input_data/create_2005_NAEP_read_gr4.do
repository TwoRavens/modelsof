version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Reading G4\stata\LABELDEF.do"
label data "  2005 National Reading Assessment: Grade  4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Reading G4\stata\R36NT1AT.DCT", clear
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
label values  SENROL4   SENROL4V
label values  YRSEXP    YRSEXP
label values  PCTBLKC   PCTBLKC
label values  PCTHSPC   PCTBLKC
label values  PCTASNC   PCTBLKC
label values  PCTINDC   PCTBLKC
label values  LEP       YESNO
label values  LRGCITY   YESNO
label values  Y36ORC    BLKUSE
label values  Y36ORD    BLKUSE
label values  Y36ORE    BLKUSE
label values  Y36ORF    BLKUSE
label values  Y36ORG    BLKUSE
label values  Y36ORH    BLKUSE
label values  Y36ORI    BLKUSE
label values  Y36ORJ    BLKUSE
label values  Y36ORK    BLKUSE
label values  Y36ORL    BLKUSE
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
label values  B018201   B018201V
label values  R830601   R830601V
label values  R830701   R830601V
label values  R831001   R831001V
label values  R831101   R831001V
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
label values  R017001   RATE2A
label values  RB17001   RATE2A
label values  RC17001   RATE2A
label values  R017002   MC5B
label values  R017003   R017003V
label values  RB17003   RATE3D
label values  RC17003   RATE3D
label values  R017004   RATE2A
label values  RB17004   RATE2A
label values  RC17004   RATE2A
label values  R017005   MC5A
label values  R017006   RATE2A
label values  RB17006   RATE2A
label values  RC17006   RATE2A
label values  R017007   RATE4A
label values  RB17007   RATE4A
label values  RC17007   RATE4A
label values  R017008   MC5D
label values  R017009   R017003V
label values  RB17009   RATE3D
label values  RC17009   RATE3D
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
label values  R017303   R017003V
label values  RB17303   RATE3D
label values  RC17303   RATE3D
label values  R017304   MC5A
label values  R017310   RATE3A
label values  RB17310   RATE3D
label values  RC17310   RATE3D
label values  R017306   MC5B
label values  R017307   RATE4A
label values  RB17307   RATE4A
label values  RC17307   RATE4A
label values  R017308   MC5C
label values  R017309   R017003V
label values  RB17309   RATE3D
label values  RC17309   RATE3D
label values  R012701   MC5B
label values  R012702   RATE2A
label values  RB12702   RATE2A
label values  RC12702   RATE2A
label values  R012703   RATE2A
label values  RB12703   RATE2A
label values  RC12703   RATE2A
label values  R012704   MC5C
label values  R012705   RATE2A
label values  RB12705   RATE2A
label values  RC12705   RATE2A
label values  R012706   RATE2A
label values  RB12706   RATE2A
label values  RC12706   RATE2A
label values  R012707   MC5C
label values  R012714   RATE4A
label values  RB12714   RATE4A
label values  RC12714   RATE4A
label values  R012709   MC5A
label values  R012710   RATE2A
label values  RB12710   RATE2A
label values  RC12710   RATE2A
label values  R017401   R017003V
label values  RB17401   RATE3D
label values  RC17401   RATE3D
label values  R017501   MC5A
label values  R017601   MC5C
label values  R017701   R017003V
label values  RB17701   RATE3D
label values  RC17701   RATE3D
label values  R017801   MC5D
label values  R017901   RATE4A
label values  RB17901   RATE4A
label values  RC17901   RATE4A
label values  R018001   MC5C
label values  R018101   MC5B
label values  R018201   R017003V
label values  RB18201   RATE3D
label values  RC18201   RATE3D
label values  R018301   R017003V
label values  RB18301   RATE3D
label values  RC18301   RATE3D
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
label values  R020401   R017003V
label values  RB20401   RATE3D
label values  RC20401   RATE3D
label values  R020601   MC5C
label values  R021101   MC5A
label values  R020701   R020701V
label values  RB20701   RB20701V
label values  RC20701   RB20701V
label values  R020501   MC5B
label values  R022101   MC5C
label values  R021701   R017003V
label values  RB21701   RATE3D
label values  RC21701   RATE3D
label values  R022201   MC5B
label values  R021201   R017003V
label values  RB21201   RATE3D
label values  RC21201   RATE3D
label values  R023301   MC5D
label values  R022401   MC5B
label values  R023501   R017003V
label values  RB23501   RATE3D
label values  RC23501   RATE3D
label values  R023601   R017003V
label values  RB23601   RATE3D
label values  RC23601   RATE3D
label values  R023801   MC5A
label values  R022901   MC5B
label values  R024001   R017003V
label values  RB24001   RATE3D
label values  RC24001   RATE3D
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
label values  T087302   MAJORA
label values  T087303   MAJORA
label values  T087304   MAJORA
label values  T087305   MAJORA
label values  T087306   MAJORA
label values  T077312   MAJORA
label values  T077409   MAJORA
label values  T077410   MAJORA
label values  T077411   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T087401   MAJORA
label values  T087402   MAJORA
label values  T087403   MAJORA
label values  T087404   MAJORA
label values  T087405   MAJORA
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
label values  T087801   YESNO
label values  T087802   YESNO
label values  T087803   YESNO
label values  T087804   YESNO
label values  T087805   YESNO
label values  T087806   YESNO
label values  T087807   YESNO
label values  T087808   YESNO
label values  T087809   YESNO
label values  T087810   YESNO
label values  T087811   YESNO
label values  T087812   YESNO
label values  T087813   YESNO
label values  T087814   YESNO
label values  T087815   YESNO
label values  T087816   YESNO
label values  T087817   YESNO
label values  T087818   YESNO
label values  T087819   YESNO
label values  T087820   YESNO
label values  T087821   YESNO
label values  T087822   YESNO
label values  T087823   YESNO
label values  T087824   YESNO
label values  T087825   YESNO
label values  T087826   YESNO
label values  T087827   YESNO
label values  T087828   YESNO
label values  T087829   YESNO
label values  T087830   YESNO
label values  T087831   YESNO
label values  T087832   YESNO
label values  T087833   YESNO
label values  T087834   YESNO
label values  T087835   YESNO
label values  T087836   YESNO
label values  T087837   YESNO
label values  T087838   YESNO
label values  T087839   YESNO
label values  T087840   YESNO
label values  T087841   YESNO
label values  T087842   YESNO
label values  T087843   YESNO
label values  T087844   YESNO
label values  T087845   YESNO
label values  T087846   YESNO
label values  T087847   YESNO
label values  T087848   YESNO
label values  T087901   YESNO
label values  T087902   YESNO
label values  T088001   T088001Q
label values  T088101   T088101Q
label values  T088201   YESNO
label values  T088202   YESNO
label values  T088203   YESNO
label values  T088301   T088301Q
label values  T088401   T088401Q
label values  T088501   T088501Q
label values  T088601   T088601Q
label values  T088602   T088601Q
label values  T088603   T088601Q
label values  T088701   T088701Q
label values  T088702   T088701Q
label values  T088703   T088701Q
label values  T088704   T088701Q
label values  T088705   T088701Q
label values  T088706   T088701Q
label values  T088707   T088701Q
label values  T088708   T088701Q
label values  T088709   T088701Q
label values  T088710   T088701Q
label values  T088801   T088701Q
label values  T088802   T088701Q
label values  T088803   T088701Q
label values  T088804   T088701Q
label values  T088805   T088701Q
label values  T088901   YESNO
label values  T089001   YESNO
label values  T089101   YESNO
label values  T089201   T089201Q
label values  T089301   T089301Q
label values  T089401   T089401Q
label values  T089501   T088701Q
label values  T089502   T088701Q
label values  T089503   T088701Q
label values  T089504   T088701Q
label values  T089601   T089601Q
label values  T089701   T088701Q
label values  T089702   T088701Q
label values  T089703   T088701Q
label values  T089704   T088701Q
label values  T092401   T092401Q
label values  T086501   T086501Q
label values  T083401   T083401Q
label values  T089801   T089801Q
label values  T068351   T068351Q
label values  T089901   T088701Q
label values  T089902   T088701Q
label values  T089903   T088701Q
label values  T089904   T088701Q
label values  T089905   T088701Q
label values  T089906   T088701Q
label values  T089907   T088701Q
label values  T089908   T088701Q
label values  T089909   T088701Q
label values  T089910   T088701Q
label values  T089911   T088701Q
label values  T089912   T088701Q
label values  T089913   T088701Q
label values  T089914   T088701Q
label values  T089915   T088701Q
label values  T070151   FREQ4F
label values  T070152   FREQ4F
label values  T070153   FREQ4F
label values  T070154   FREQ4F
label values  T070155   FREQ4F
label values  T070156   FREQ4F
label values  T070157   FREQ4F
label values  T092201   T092401Q
label values  T090001   T090001Q
label values  T092301   T092301Q
label values  T090101   T090101Q
label values  T090201   T088701Q
label values  T090202   T088701Q
label values  T090203   T088701Q
label values  T090204   T088701Q
label values  T090205   T088701Q
label values  T090206   T088701Q
label values  T090207   T088701Q
label values  T090208   T088701Q
label values  T090209   T088701Q
label values  T090301   T088701Q
label values  T090302   T088701Q
label values  T090303   T088701Q
label values  T090401   T090401Q
label values  T090402   T090401Q
label values  T090403   T090401Q
label values  T061201   YESNO
label values  T090501   T088701Q
label values  T090502   T088701Q
label values  T090503   T088701Q
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
// mvdecode BA21101 - R836801 R017002 R017005 R017008 R052901 - R052903 R052905 /*
//       */ R052908 R052910 R012602 R012603  R012605 R012606  R012608 - R012610 /*
//       */ R017302 R017304 R017306 R017308 R012701 R012704 R012707 R012709 /*
//       */ R017501 R017601  R017801 R018001 R018101  R053001 R053002  R053005 /*
//       */ R053007 R053008  R053102 - R053104 R053107 R053109 - R021601 /*
//       */ R020601 R021101  R020501 R022101  R022201 R023301 R022401  /*
//       */ R023801 R022901  R023101 R024101  TA21101 - TE21201 /*
//       */ T077201 - T090503 XS00201 X012201 - XS00701 XS00901 - XS01201 /*
//       */ XS01701 X013801 - XL01101 XL01401,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode R017001 - RC17001 R017002 - RC17003 R017004 - RC17004 /*
//       */ R017005 - RC17006 R017007 - RC17007 R017008 - RC17009 /*
//       */ R052901 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R017301 - RC17301 /*
//       */ R017302 - RC17303 R017304 - RC17310 R017306 - RC17307 /*
//       */ R017308 - RC17309 R012701 - RC12702 R012703 - RC12703 /*
//       */ R012704 - RC12705 R012706 - RC12706 R012707 - RC12714 /*
//       */ R012709 - RC12710 R017401 - RC17401 R017501 - RC17701 /*
//       */ R017801 - RC17901 R018001 - RC18201 R018301 - RC18301 /*
//       */ R053001 - RC53003 R053004 - RC53004 R053005 - RC53006 /*
//       */ R053007 - RC53009 R053010 - RC53010 R053101 - RC53101 /*
//       */ R053102 - RC53105 R053106 - RC53106 R053107 - RC53108 /*
//       */ R053109 - RC20401 R020601 - RC20701 R020501 - RC21701 /*
//       */ R022201 - RC21201 R023301 - RC23501 R023601 - RC23601 /*
//       */ R023801 - RC24001 R023101 - RC23201,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 SCHTY02 HISPYES DRACEM  SDRACEM SENROL4 - LEP /*
//       */ BA21101 - RC17001 R017002 - RC17003 R017004 - RC17004 /*
//       */ R017005 - RC17006 R017007 - RC17007 R017008 - RC17009 /*
//       */ R052901 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R017301 - RC17301 /*
//       */ R017302 - RC17303 R017304 - RC17310 R017306 - RC17307 /*
//       */ R017308 - RC17309 R012701 - RC12702 R012703 - RC12703 /*
//       */ R012704 - RC12705 R012706 - RC12706 R012707 - RC12714 /*
//       */ R012709 - RC12710 R017401 - RC17401 R017501 - RC17701 /*
//       */ R017801 - RC17901 R018001 - RC18201 R018301 - RC18301 /*
//       */ R053001 - RC53003 R053004 - RC53004 R053005 - RC53006 /*
//       */ R053007 - RC53009 R053010 - RC53010 R053101 - RC53101 /*
//       */ R053102 - RC53105 R053106 - RC53106 R053107 - RC53108 /*
//       */ R053109 - RC20401 R020601 - RC20701 R020501 - RC21701 /*
//       */ R022201 - RC21201 R023301 - RC23501 R023601 - RC23601 /*
//       */ R023801 - RC24001 R023101 - RC23201 TA21101 - TE21201 /*
//       */ T077201 - T090503 XS00101 - XS01701 XL00101 - XL01401,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode B017001 B000905  B017201 XS00501 - XS00701 XS01001 XS01101  /*
//       */ XL00201 - XL00601 XL00801 - XL01101,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode R017001 - RC17001 R017003 - RC17003 R017004 - RC17004 /*
//       */ R017006 - RC17006 R017007 - RC17007 R017009 - RC17009 /*
//       */ R052901 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R012702 - RC12702 R012703 - RC12703 /*
//       */ R012705 - RC12705 R012706 - RC12706 R012714 - RC12714 /*
//       */ R012710 - RC12710 R017401 - RC17401 R017701 - RC17701 /*
//       */ R017901 - RC17901 R018201 - RC18201 R018301 - RC18301 /*
//       */ R053001 - RC53003 R053004 - RC53004 R053005 - RC53006 /*
//       */ R053007 - RC53009 R053010 - RC53010 R053101 - RC53101 /*
//       */ R053102 - RC53105 R053106 - RC53106 R053107 - RC53108 /*
//       */ R053109 R053110  R020401 - RC20401 R020701 - RC20701 /*
//       */ R021701 - RC21701 R021201 - RC21201 R023501 - RC23501 /*
//       */ R023601 - RC23601 R024001 - RC24001 R023201 - RC23201,  mv( 7=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R017001 - RC17001 R017003 - RC17003 R017004 - RC17004 /*
//       */ R017006 - RC17006 R017007 - RC17007 R017009 - RC17009 /*
//       */ R052901 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R012702 - RC12702 R012703 - RC12703 /*
//       */ R012705 - RC12705 R012706 - RC12706 R012714 - RC12714 /*
//       */ R012710 - RC12710 R017401 - RC17401 R017701 - RC17701 /*
//       */ R017901 - RC17901 R018201 - RC18201 R018301 - RC18301 /*
//       */ R053001 - RC53003 R053004 - RC53004 R053005 - RC53006 /*
//       */ R053007 - RC53009 R053010 - RC53010 R053101 - RC53101 /*
//       */ R053102 - RC53105 R053106 - RC53106 R053107 - RC53108 /*
//       */ R053109 R053110  R020401 - RC20401 R020701 - RC20701 /*
//       */ R021701 - RC21701 R021201 - RC21201 R023501 - RC23501 /*
//       */ R023601 - RC23601 R024001 - RC24001 R023201 - RC23201,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode R017001 - RC17001 R017003 - RC17003 R017004 - RC17004 /*
//       */ R017006 - RC17006 R017007 - RC17007 R017009 - RC17009 /*
//       */ R052901 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R012702 - RC12702 R012703 - RC12703 /*
//       */ R012705 - RC12705 R012706 - RC12706 R012714 - RC12714 /*
//       */ R012710 - RC12710 R017401 - RC17401 R017701 - RC17701 /*
//       */ R017901 - RC17901 R018201 - RC18201 R018301 - RC18301 /*
//       */ R053001 - RC53003 R053004 - RC53004 R053005 - RC53006 /*
//       */ R053007 - RC53009 R053010 - RC53010 R053101 - RC53101 /*
//       */ R053102 - RC53105 R053106 - RC53106 R053107 - RC53108 /*
//       */ R053109 R053110  R020401 - RC20401 R020701 - RC20701 /*
//       */ R021701 - RC21701 R021201 - RC21201 R023501 - RC23501 /*
//       */ R023601 - RC23601 R024001 - RC24001 R023201 - RC23201,  mv( 6=.s)
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
// recode R017001 R017004 R017006 R052906 R052909 R012601 R012604 R012612 /*
//     */ R017301 R012702 R012703 R012705 R012706 R012710 R053003 R053009 /*
//     */ R053101 R020701 R023201 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R017002 R012603 R012605 R017302 R017306 R012701 R018101 R020501 /*
//     */ R022201 R022401 R022901 R024101 (1=0) (2=1) (3=0) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode R017003 R052904 R017303 R017310 R017401 R017701 R018201 R018301 /*
//     */ R053004 R053105 R053108 R021701 R021201 R023501 R024001 (1=0) (2=1) /*
//     */ (3=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017005 R012610 R017304 R012709 R017501 R021601 R021101 R023801 (1=1) /*
//     */ (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R017007 R052907 R012607 R017307 R012714 R053006 R053106 (1=0) (2=1) /*
//     */ (3=2) (4=3) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017008 R012606 R012609 R017801 R023301 (1=0) (2=0) (3=0) (4=1) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R017009 R017309 R053010 R020401 R023601 (1=0) (2=1) (3=1) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R052901 R052905 R052908 R052910 R053001 R053002 R053103 R053109 (1=0) /*
//     */ (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode R052902 R052903 R053005 R053007 R053008 R053107 R053110 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R012602 R012608 R017308 R012704 R012707 R017601 R018001 R020601 /*
//     */ R022101 R023101 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode R017901 (1=0) (2=0) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R053102 R053104 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2005
gen grade=4
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2005\naep_read_gr4_2005", replace


