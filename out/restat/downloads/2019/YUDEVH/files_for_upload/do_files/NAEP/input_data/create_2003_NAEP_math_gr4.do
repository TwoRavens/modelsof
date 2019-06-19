version 8
clear
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Math G4\stata\LABELDEF.do"
label data "  2003 National Mathematics Assessment: Grade  4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Math G4\stata\M34NT1AT.DCT", clear
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
label values  Y34M3     BLKUSE
label values  Y34M4     BLKUSE
label values  Y34M5     BLKUSE
label values  Y34M6     BLKUSE
label values  Y34M7     BLKUSE
label values  Y34M8     BLKUSE
label values  Y34M9     BLKUSE
label values  Y34M10    BLKUSE
label values  Y34M11    BLKUSE
label values  Y34M12    BLKUSE
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
label values  M814001   FREQ4E
label values  M814002   FREQ4E
label values  M814003   FREQ4E
label values  M814004   FREQ4E
label values  M814005   FREQ4E
label values  M814006   FREQ4E
label values  M811201   YESNO
label values  M814101   FREQ4E
label values  M814102   FREQ4E
label values  M814103   FREQ4E
label values  M813901   M813901V
label values  M811401   YESNO
label values  M814201   LIKEME
label values  M814202   LIKEME
label values  M814203   LIKEME
label values  M814254   AGREE3A
label values  M814255   AGREE3A
label values  M814256   AGREE3A
label values  M814257   AGREE3A
label values  M074201   MC5C
label values  M074301   RATE2D
label values  MB74301   RATE2D
label values  MC74301   RATE2D
label values  M074801   RATE3B
label values  MB74801   RATE3B
label values  MC74801   RATE3B
label values  M074901   RATE3B
label values  MB74901   RATE3B
label values  MC74901   RATE3B
label values  M074501   RATE3B
label values  MB74501   RATE3B
label values  MC74501   RATE3B
label values  N277903   RATE2C
label values  NB77903   RATE2D
label values  NC77903   RATE2D
label values  M039001   MC5D
label values  M047501   MC5B
label values  M074601   MC5B
label values  M039701   MC5C
label values  M075001   RATE3B
label values  MB75001   RATE3B
label values  MC75001   RATE3B
label values  M019901   M019901V
label values  MB19901   MB19901V
label values  MC19901   MB19901V
label values  M066201   MC5B
label values  M047301   SCR4D
label values  MB47301   SCR4D
label values  MC47301   SCR4D
label values  M046201   MC5C
label values  M066401   MC5D
label values  M020101   RATE2C
label values  MB20101   RATE2D
label values  MC20101   RATE2D
label values  M043501   RATE5A
label values  MB43501   MB43501V
label values  MC43501   MB43501V
label values  M046001   SCR5E
label values  MB46001   SCR5E
label values  MC46001   SCR5E
label values  M046101   MC5B
label values  M067701   MC5A
label values  M046701   MC5C
label values  M046901   SCR5E
label values  MB46901   SCR5E
label values  MC46901   SCR5E
label values  M047201   MC5B
label values  M046601   SCR4D
label values  MB46601   SCR4D
label values  MC46601   SCR4D
label values  M046801   SCR5E
label values  MB46801   SCR5E
label values  MC46801   SCR5E
label values  M067801   MC5C
label values  M066601   RATE3B
label values  MB66601   RATE3B
label values  MC66601   RATE3B
label values  M068001   RATE3B
label values  MB68001   RATE3B
label values  MC68001   RATE3B
label values  M068002   RATE3B
label values  MB68002   RATE3B
label values  MC68002   RATE3B
label values  M068003   RATE3B
label values  MB68003   RATE3B
label values  MC68003   RATE3B
label values  M068004   RATE5A
label values  MB68004   RATE5A
label values  MC68004   RATE5A
label values  M085201   MC5C
label values  M085301   MC5C
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   RATE3B
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085401   RATE5A
label values  MB85401   RATE5A
label values  MC85401   RATE5A
label values  M019701   RATE2C
label values  MB19701   RATE2D
label values  MC19701   RATE2D
label values  M020001   RATE2C
label values  MB20001   RATE2D
label values  MC20001   RATE2D
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
label values  M017401   MC5C
label values  N202831   MC5C
label values  M017801   MC5B
label values  M017501   MC5A
label values  M017601   MC5D
label values  M020201   RATE2C
label values  MB20201   RATE2D
label values  MC20201   RATE2D
label values  M046401   MC5D
label values  M020401   RATE2C
label values  MB20401   RATE2D
label values  MC20401   RATE2D
label values  M017701   MC5D
label values  M018101   MC5C
label values  M018401   MC5B
label values  M017901   MC5A
label values  M018301   MC5B
label values  M018001   MC5B
label values  M018201   MC5A
label values  M020501   RATE2C
label values  MB20501   RATE2D
label values  MC20501   RATE2D
label values  M018501   MC5C
label values  M020301   M020301V
label values  MB20301   MB20301V
label values  MC20301   MB20301V
label values  M018601   MC5D
label values  M018701   MC5B
label values  M019801   M019801V
label values  MB19801   MB19801V
label values  MC19801   MB19801V
label values  M010231   MC5C
label values  M0102A1   YESNO
label values  M072101   MC5B
label values  M0721A1   YESNO
label values  M086501   MC5B
label values  M0865A1   YESNO
label values  M043001   MC5A
label values  M0430A1   YESNO
label values  M072201   RATE3B
label values  MB72201   RATE3B
label values  MC72201   RATE3B
label values  M0722A1   YESNO
label values  M072202   RATE3B
label values  MB72202   RATE3B
label values  MC72202   RATE3B
label values  M0722A2   YESNO
label values  M039401   MC5B
label values  M0394A1   YESNO
label values  M010431   MC5D
label values  M0104A1   YESNO
label values  M072001   MC5C
label values  M0720A1   YESNO
label values  M040101   MC5A
label values  M0401A1   YESNO
label values  N240031   MC5C
label values  N2400A1   YESNO
label values  M011131   MC5B
label values  M0111A1   YESNO
label values  M010731   MC5C
label values  M0107A1   YESNO
label values  M087101   MC5A
label values  M0871A1   YESNO
label values  M072501   RATE3B
label values  MB72501   RATE3B
label values  MC72501   RATE3B
label values  M0725A1   YESNO
label values  M010531   MC5D
label values  M0105A1   YESNO
label values  M010931   MC5C
label values  M0109A1   YESNO
label values  M072601   RATE3B
label values  MB72601   RATE3B
label values  MC72601   RATE3B
label values  M0726A1   YESNO
label values  M020701   M020701V
label values  MB20701   M020701V
label values  MC20701   M020701V
label values  M0207A1   YESNO
label values  M072701   M072701V
label values  MB72701   M072701V
label values  MC72701   M072701V
label values  M0727A1   YESNO
label values  M010131   MC5A
label values  M0101A1   YESNO
label values  N214331   MC5D
label values  N2143A1   YESNO
label values  M039101   MC5A
label values  M0391A1   YESNO
label values  M086701   MC5A
label values  M0867A1   YESNO
label values  M010631   M010631V
label values  MB10631   M010631V
label values  MC10631   M010631V
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
label values  M040001   SCR3C
label values  MB40001   SCR3C
label values  MC40001   SCR3C
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
label values  M087301   RATE5A
label values  MB87301   RATE5A
label values  MC87301   RATE5A
label values  M0873A1   YESNO
label values  M042801   MC5D
label values  M042601   MC5B
label values  M043201   SCR2B
label values  MB43201   SCR2B
label values  MC43201   SCR2B
label values  M071901   MC5B
label values  M086801   MC5B
label values  M086601   RATE3B
label values  MB86601   RATE3B
label values  MC86601   RATE3B
label values  M039501   MC5C
label values  M090801   MC5A
label values  M066701   RATE3B
label values  MB66701   RATE3B
label values  MC66701   RATE3B
label values  M043101   MC5B
label values  M066801   RATE3B
label values  MB66801   RATE3B
label values  MC66801   RATE3B
label values  M067601   MC5C
label values  M043401   SCR4D
label values  MB43401   SCR4D
label values  MC43401   SCR4D
label values  M043402   SCR4D
label values  MB43402   SCR4D
label values  MC43402   SCR4D
label values  M043403   SCR3C
label values  MB43403   SCR3C
label values  MC43403   SCR3C
label values  M0434CL   M0434CL
label values  M043301   SCR3C
label values  MB43301   SCR3C
label values  MC43301   SCR3C
label values  M074401   MC5A
label values  M040221   YESNO
label values  M040201   SCR2B
label values  MB40201   SCR2B
label values  MC40201   SCR2B
label values  M0402CL   RATE3B
label values  M039601   MC5C
label values  M091401   RATE5A
label values  MB91401   RATE5A
label values  MC91401   RATE5A
label values  M090501   MC5C
label values  M047401   MC5A
label values  M090601   MC5B
label values  M042701   MC5C
label values  M074701   RATE3B
label values  MB74701   RATE3B
label values  MC74701   RATE3B
label values  M066101   MC5C
label values  M090701   MC5A
label values  M091001   MC5C
label values  M039201   SCR2B
label values  MB39201   SCR2B
label values  MC39201   SCR2B
label values  M091101   RATE3B
label values  MB91101   RATE3B
label values  MC91101   RATE3B
label values  M042901   MC5A
label values  M086401   MC5B
label values  M039301   SCR3C
label values  MB39301   SCR3C
label values  MC39301   SCR3C
label values  M011231   MC5C
label values  M039901   MC5D
label values  N250231   MC5A
label values  M066901   RATE5A
label values  MB66901   RATE5A
label values  MC66901   RATE5A
label values  M075101   RATE5A
label values  MB75101   RATE5A
label values  MC75101   RATE5A
label values  M095701   MC5C
label values  M095801   MC5A
label values  M095901   MC5D
label values  M096001   RATE2D
label values  MB96001   RATE2D
label values  MC96001   RATE2D
label values  M096101   MC5C
label values  M096301   MC5B
label values  M096401   MC5C
label values  M096601   MC5D
label values  M096701   MC5D
label values  M096801   MC5A
label values  M096901   MC5B
label values  M097001   MC5C
label values  M097101   MC5B
label values  M097201   RATE3C
label values  MB97201   RATE3C
label values  MC97201   RATE3C
label values  M097301   MC5B
label values  M097401   RATE3C
label values  MB97401   RATE3C
label values  MC97401   RATE3C
label values  M097501   MC5D
label values  M097601   MC5D
label values  M099701   MC5B
label values  M099801   MC5B
label values  M099901   MC5A
label values  M100001   MC5B
label values  M100101   MC5A
label values  M100201   RATE2D
label values  MG00201   RATE2D
label values  MH00201   RATE2D
label values  M100301   MC5B
label values  M100401   MC5D
label values  M100501   RATE2D
label values  MG00501   RATE2D
label values  MH00501   RATE2D
label values  M100601   MC5D
label values  M100701   MC5A
label values  M100801   MC5C
label values  M100901   MC5B
label values  M101001   MC5C
label values  M101101   MC5C
label values  M101201   MC5A
label values  M101401   RATE2D
label values  MG01401   RATE2D
label values  MH01401   RATE2D
label values  M101501   RATE3C
label values  MG01501   RATE3C
label values  MH01501   RATE3C
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
label values  T044401   M813901V
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
// mvdecode PARED BA21101 - M074201 M039001 - M039701 M066201 M046201 M066401  /*
//       */ M046101 - M046701 M047201 M067801 M085201 M085301  M085601 /*
//       */ M046301 - M046501 M047101 M017401 - M017601 M046401 /*
//       */ M017701 - M018201 M018501 M018601 M018701  M010231 - M0430A1 /*
//       */ M0722A1 M0722A2 - M0871A1 M0725A1 - M0109A1 M0726A1 M0207A1 /*
//       */ M0727A1 - M0867A1 M0106A1 - M0909A1 M0870A1 - M0398A1 /*
//       */ M0400A1 - M0872A1 M0912A1 - M0660A1 M0724A1 - M0913A1 /*
//       */ M0873A1 - M042601 M071901 M086801  M039501 M090801  M043101 M067601 /*
//       */ M074401 M040221  M039601 M090501 - M042701 M066101 - M091001 /*
//       */ M042901 M086401  M011231 - N250231 M095701 - M095901 /*
//       */ M096101 - M097101 M097301 M097501 - M100101 M100301 M100401  /*
//       */ M100601 - M101201 X012101 - X013001 X015501 - X014601 /*
//       */ X015901 X014901  T077201 - T044901,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M074201 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M039001 - MC75001 /*
//       */ M019901 - MC19901 M066201 - MC47301 M046201 - MC20101 /*
//       */ M046101 - M046701 M047201 - MC46601 M067801 - MC66601 /*
//       */ M068001 - MC68001 M068002 - MC68002 M068003 - MC68003 /*
//       */ M085201 - MC85701 M085901 - MC85901 M085601 M019701 - MC19701 /*
//       */ M020001 - MC20001 M046301 - MC66501 M047101 - MC66301 /*
//       */ M067901 - MC67901 M017401 - MC20201 M046401 - MC20401 /*
//       */ M017701 - MC20501 M018501 - MC20301 M018601 - MC19801 /*
//       */ M010231 - MC72201 M0722A1 - MC72202 M0722A2 - MC72501 /*
//       */ M0725A1 - MC72601 M0726A1 - MC20701 M0207A1 M0727A1 - MC10631 /*
//       */ M0106A1 - MC87001 M0870A1 - MC40001 M0400A1 - MC72401 /*
//       */ M0724A1 - M0913A1 M0873A1 - MC43201 M071901 - MC86601 /*
//       */ M039501 - MC66701 M043101 - MC66801 M067601 - MC43401 /*
//       */ M043402 - MC43402 M043403 - MC43403 M0434CL - MC43301 /*
//       */ M074401 - MC40201 M0402CL M039601  M090501 - MC74701 /*
//       */ M066101 - MC39201 M091101 - MC91101 M042901 - MC39301 /*
//       */ M011231 - N250231 M095701 - MC96001 M096101 - MC97201 /*
//       */ M097301 - MC97401 M097501 - MH00201 M100301 - MH00501 /*
//       */ M100601 - MH01401 M101501 - MH01501,  mv( 9=.n)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M072701 - MC72701 M087301 - MC87301 M091401 - MC91401 /*
//       */ M066901 - MC66901 M075101 - MC75101,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 PARED HISPYES - SCHTY02 SENROL4 - PCTINDC BA21101 - MC74301 /*
//       */ M074801 - MC74801 M074901 - MC74901 M074501 - MC74501 /*
//       */ N277903 - NC77903 M039001 - MC75001 M019901 - MC19901 /*
//       */ M066201 - MC47301 M046201 - MC20101 M046101 - M046701 /*
//       */ M047201 - MC46601 M067801 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085201 - MC85701 /*
//       */ M085901 - MC85901 M085601 M019701 - MC19701 M020001 - MC20001 /*
//       */ M046301 - MC66501 M047101 - MC66301 M067901 - MC67901 /*
//       */ M017401 - MC20201 M046401 - MC20401 M017701 - MC20501 /*
//       */ M018501 - MC20301 M018601 - MC19801 M010231 - MC72201 /*
//       */ M0722A1 - MC72202 M0722A2 - MC72501 M0725A1 - MC72601 /*
//       */ M0726A1 - MC20701 M0207A1 M0727A1 - MC10631 M0106A1 - MC87001 /*
//       */ M0870A1 - MC40001 M0400A1 - MC72401 M0724A1 - M0913A1 /*
//       */ M0873A1 - MC43201 M071901 - MC86601 M039501 - MC66701 /*
//       */ M043101 - MC66801 M067601 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M0434CL - MC43301 M074401 - MC40201 /*
//       */ M0402CL M039601  M090501 - MC74701 M066101 - MC39201 /*
//       */ M091101 - MC91101 M042901 - MC39301 M011231 - N250231 /*
//       */ M095701 - MC96001 M096101 - MC97201 M097301 - MC97401 /*
//       */ M097501 - MH00201 M100301 - MH00501 M100601 - MH01401 /*
//       */ M101501 - MH01501 X005701 - X005705 X012201 - X014901 /*
//       */ T077201 - T044901,  mv( 8=.o)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M072701 - MC72701 M087301 - MC87301 M091401 - MC91401 /*
//       */ M066901 - MC66901 M075101 - MC75101 X012101,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B017301  B003501 B003601  /*
//       */ X012301 - X016001 X015601 X014001  X015701 X014401,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode M074301 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M075001 - MC75001 /*
//       */ M019901 - MC19901 M047301 - MC47301 M020101 - MC20101 /*
//       */ M046601 - MC46601 M066601 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M020201 - MC20201 M020401 - MC20401 M020501 - MC20501 /*
//       */ M020301 - MC20301 M019801 - MC19801 M072201 - MC72201 /*
//       */ M072202 - MC72202 M072501 - MC72501 M072601 - MC72601 /*
//       */ M020701 - MC20701 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M043201 - MC43201 M086601 - MC86601 M066701 - MC66701 /*
//       */ M066801 - MC66801 M043401 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M043301 - MC43301 M040201 - MC40201 /*
//       */ M074701 - MC74701 M039201 - MC39201 M091101 - MC91101 /*
//       */ M039301 - MC39301 M096001 - MC96001 M097201 - MC97201 /*
//       */ M097401 - MC97401 M100201 - MH00201 M100501 - MH00501 /*
//       */ M101401 - MH01401 M101501 - MH01501,  mv( 7=.q)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M072701 - MC72701 M087301 - MC87301 M091401 - MC91401 /*
//       */ M066901 - MC66901 M075101 - MC75101,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M074301 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M075001 - MC75001 /*
//       */ M019901 - MC19901 M047301 - MC47301 M020101 - MC20101 /*
//       */ M046601 - MC46601 M066601 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M020201 - MC20201 M020401 - MC20401 M020501 - MC20501 /*
//       */ M020301 - MC20301 M019801 - MC19801 M072201 - MC72201 /*
//       */ M072202 - MC72202 M072501 - MC72501 M072601 - MC72601 /*
//       */ M020701 - MC20701 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M043201 - MC43201 M086601 - MC86601 M066701 - MC66701 /*
//       */ M066801 - MC66801 M043401 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M043301 - MC43301 M040201 - MC40201 /*
//       */ M074701 - MC74701 M039201 - MC39201 M091101 - MC91101 /*
//       */ M039301 - MC39301 M096001 - MC96001 M097201 - MC97201 /*
//       */ M097401 - MC97401 M100201 - MH00201 M100501 - MH00501 /*
//       */ M101401 - MH01401 M101501 - MH01501,  mv( 5=.r)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M072701 - MC72701 M087301 - MC87301 M091401 - MC91401 /*
//       */ M066901 - MC66901 M075101 - MC75101,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode M074301 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M075001 - MC75001 /*
//       */ M019901 - MC19901 M047301 - MC47301 M020101 - MC20101 /*
//       */ M046601 - MC46601 M066601 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M020201 - MC20201 M020401 - MC20401 M020501 - MC20501 /*
//       */ M020301 - MC20301 M019801 - MC19801 M072201 - MC72201 /*
//       */ M072202 - MC72202 M072501 - MC72501 M072601 - MC72601 /*
//       */ M020701 - MC20701 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M043201 - MC43201 M086601 - MC86601 M066701 - MC66701 /*
//       */ M066801 - MC66801 M043401 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M043301 - MC43301 M040201 - MC40201 /*
//       */ M074701 - MC74701 M039201 - MC39201 M091101 - MC91101 /*
//       */ M039301 - MC39301 M096001 - MC96001 M097201 - MC97201 /*
//       */ M097401 - MC97401 M100201 - MH00201 M100501 - MH00501 /*
//       */ M101401 - MH01401 M101501 - MH01501,  mv( 6=.s)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M072701 - MC72701 M087301 - MC87301 M091401 - MC91401 /*
//       */ M066901 - MC66901 M075101 - MC75101,  mv(66=.s)
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
// recode M074201 M039701 M046201 M046701 M067801 M085201 M085301 M047101 /*
//     */ M017401 N202831 M018101 M018501 M010231 M072001 N240031 M010731 /*
//     */ M010931 M087201 M091301 M039501 M067601 M039601 M090501 M042701 /*
//     */ M066101 M091001 M011231 M095701 M096101 M096401 M097001 M100801 /*
//     */ M101001 M101101 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M074301 N277903 M020101 M019701 M020001 M020201 M020401 M020501 /*
//     */ M043201 M039201 M096001 M100201 M100501 M101401 (1=0) (2=1) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M074801 M074901 M074501 M075001 M066601 M068002 M068003 M085701 /*
//     */ M066501 M066301 M067901 M072201 M072202 M072501 M072601 M087001 /*
//     */ M091201 M072401 M086601 M066701 M066801 M091101 M097201 M097401 /*
//     */ M101501 (1=0) (2=1) (3=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode M039001 M066401 M047001 M017601 M046401 M017701 M018601 M010431 /*
//     */ M010531 N214331 M010831 M042801 M039901 M095901 M096601 M096701 /*
//     */ M097501 M097601 M100401 M100601 (1=0) (2=0) (3=0) (4=1) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M047501 M074601 M066201 M046101 M047201 M085601 M046301 M017801 /*
//     */ M018401 M018301 M018001 M018701 M072101 M086501 M039401 M011131 /*
//     */ M010331 M086901 M090901 M039801 M042601 M071901 M086801 M043101 /*
//     */ M090601 M086401 M096301 M096901 M097101 M097301 M099701 M099801 /*
//     */ M100001 M100301 M100901 (1=0) (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) (else=.)
// recode M019901 M019801 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M047301 M046601 M020301 M020701 (1=0) (2=0) (3=0) (4=1) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M043501 M068004 M085401 M087301 M091401 M066901 M075101 (1=0) (2=1) /*
//     */ (3=2) (4=3) (5=4) (99=.n) (88=.o) (77=.q) (55=.r) (66=.s) (else=.)
// recode M046001 M046901 M046801 (1=0) (2=0) (3=0) (4=0) (5=1) (99=.n) (88=.o) /*
//     */ (77=.q) (55=.r) (66=.s) (else=.)
// recode M067701 M046501 M017501 M017901 M018201 M043001 M040101 M087101 /*
//     */ M010131 M039101 M086701 M072301 M066001 M090801 M074401 M047401 /*
//     */ M090701 M042901 N250231 M095801 M096801 M099901 M100101 M100701 /*
//     */ M101201 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M068001 M085901 M010631 M040001 M043301 M074701 M039301 (1=0) (2=0) /*
//     */ (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M072701 (1=0) (2=1) (3=2) (4=3) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M0434CL (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) (else=.)
// recode M0402CL (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2003
gen grade=4
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2003\naep_math_gr4_2003", replace
