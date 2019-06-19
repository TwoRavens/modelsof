version 8
clear
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Math G8\stata\LABELDEF.do"
label data "  2003 National Mathematics Assessment: Grade  8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA3\NAEP 2003\NAEP 2003 Math G8\stata\M34NT2AT.DCT", clear
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
label values  YRSMATH   YRSEXP
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
label values  M812751   FREQ4E
label values  M812753   FREQ4E
label values  M812762   FREQ4E
label values  M812755   FREQ4E
label values  M813251   FREQ4E
label values  M812760   FREQ4E
label values  M812761   FREQ4E
label values  M812301   YESNO
label values  M812401   YESNO
label values  M812901   YESNO
label values  M812051   FREQ4E
label values  M812052   FREQ4E
label values  M813451   M813451V
label values  M813701   M813701V
label values  M813601   M813601V
label values  M813901   M813901V
label values  M810751   AGREE5A
label values  M810753   AGREE5A
label values  M810757   AGREE5A
label values  M810759   AGREE5A
label values  M810758   AGREE5A
label values  M810755   AGREE5A
label values  M813551   AGREE5A
label values  M075201   MC5C
label values  M075401   RATE3B
label values  MB75401   RATE3B
label values  MC75401   RATE3B
label values  M075601   RATE3B
label values  MB75601   RATE3B
label values  MC75601   RATE3B
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
label values  M067401   MC5A
label values  M086101   MC5C
label values  M047701   MC5B
label values  M067301   MC5D
label values  M048001   MC5E
label values  M093701   MC5E
label values  M086001   MC5B
label values  M051901   MC5D
label values  M076001   RATE5A
label values  MB76001   RATE5A
label values  MC76001   RATE5A
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
label values  M067202   MC5B
label values  M067201   RATE3B
label values  MB67201   RATE3B
label values  MC67201   RATE3B
label values  M068003   RATE3B
label values  MB68003   RATE3B
label values  MC68003   RATE3B
label values  M068005   RATE3B
label values  MB68005   RATE3B
label values  MC68005   RATE3B
label values  M068008   RATE3B
label values  MB68008   RATE3B
label values  MC68008   RATE3B
label values  M068007   MC5E
label values  M068006   RATE3B
label values  MB68006   RATE3B
label values  MC68006   RATE3B
label values  M093601   RATE3B
label values  MB93601   RATE3B
label values  MC93601   RATE3B
label values  M053001   SCR2B
label values  MB53001   SCR2B
label values  MC53001   SCR2B
label values  M047801   MC5D
label values  M086301   RATE5A
label values  MB86301   RATE5A
label values  MC86301   RATE5A
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   RATE3B
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085501   MC5A
label values  M085801   MC5A
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
label values  M019601   MC5C
label values  M051501   MC5A
label values  M047901   SCR3C
label values  MB47901   SCR3C
label values  MC47901   SCR3C
label values  M053101   SCR5E
label values  MB53101   SCR5E
label values  MC53101   SCR5E
label values  M017401   MC5C
label values  N202831   MC5C
label values  M017801   MC5B
label values  M017501   MC5A
label values  M017601   MC5D
label values  M020201   RATE2C
label values  MB20201   RATE2D
label values  MC20201   RATE2D
label values  M018201   MC5A
label values  M020401   RATE2C
label values  MB20401   RATE2D
label values  MC20401   RATE2D
label values  M017701   MC5D
label values  M018101   MC5C
label values  M018401   MC5B
label values  M017901   MC5A
label values  M018301   MC5B
label values  M018001   MC5B
label values  M046401   MC5D
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
label values  M019101   MC5B
label values  M012731   MC5D
label values  M021201   M021201V
label values  MB21201   MB21201V
label values  MC21201   MB21201V
label values  M020801   M020801V
label values  MB20801   M020801V
label values  MC20801   M020801V
label values  M018801   MC5D
label values  M019301   MC5D
label values  M018901   MC5B
label values  M052201   SCR5E
label values  MB52201   SCR5E
label values  MC52201   SCR5E
label values  M012331   MC5C
label values  M0123A1   YESNO
label values  M011131   MC5B
label values  M0111A1   YESNO
label values  M012831   MC5B
label values  M0128A1   YESNO
label values  M051301   SCR2B
label values  MB51301   SCR2B
label values  MC51301   SCR2B
label values  M0513A1   YESNO
label values  M052301   MC5A
label values  M0523A1   YESNO
label values  M073402   MC5A
label values  M073401   RATE3B
label values  MB73401   RATE3B
label values  MC73401   RATE3B
label values  M0734A1   YESNO
label values  M0734CL   M0734CL
label values  M052601   MC5D
label values  M0526A1   YESNO
label values  M052701   MC5D
label values  M0527A1   YESNO
label values  M012531   MC5C
label values  M0125A1   YESNO
label values  M019001   MC5E
label values  M0190A1   YESNO
label values  M012931   MC5C
label values  M0129A1   YESNO
label values  M013231   MC5D
label values  M0132A1   YESNO
label values  M013031   M013031V
label values  MB13031   MB13031V
label values  MC13031   MB13031V
label values  M0130A1   YESNO
label values  M012631   MC5B
label values  M0126A1   YESNO
label values  M021101   M021101V
label values  MB21101   MB21101V
label values  MC21101   MB21101V
label values  M0211A1   YESNO
label values  M075901   MC5B
label values  M0759A1   YESNO
label values  M075501   MC5E
label values  M0755A1   YESNO
label values  M047601   MC5E
label values  M0476A1   YESNO
label values  M092001   RATE5A
label values  MB92001   RATE5A
label values  MC92001   RATE5A
label values  M0920A1   YESNO
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
label values  M021001   RATE2C
label values  MB21001   RATE2D
label values  MC21001   RATE2D
label values  M0210A1   YESNO
label values  M092201   MC5B
label values  M0922A1   YESNO
label values  M020901   RATE2C
label values  MB20901   RATE2D
label values  MC20901   RATE2D
label values  M0209A1   YESNO
label values  M052501   MC5B
label values  M0525A1   YESNO
label values  M092401   RATE3B
label values  MB92401   RATE3B
label values  MC92401   RATE3B
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
label values  M0757CL   M0732CL
label values  M013131   RATE2C
label values  MB13131   RATE2D
label values  MC13131   RATE2D
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
label values  MC73501   RATE3B
label values  M0735A1   YESNO
label values  MA52421   MA52421V
label values  M052401   RATE2D
label values  MB52401   RATE2D
label values  MC52401   RATE2D
label values  M0524A1   YESNO
label values  M075301   RATE3B
label values  MB75301   RATE3B
label values  MC75301   RATE3B
label values  M0753A1   YESNO
label values  M072901   RATE3B
label values  MB72901   RATE3B
label values  MC72901   RATE3B
label values  M0729A1   YESNO
label values  M013631   MC5A
label values  M0136A1   YESNO
label values  M075801   RATE3B
label values  MB75801   RATE3B
label values  MC75801   RATE3B
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
label values  MC93801   RATE5A
label values  M0938A1   YESNO
label values  M051201   SCR2B
label values  MB51201   SCR2B
label values  MC51201   SCR2B
label values  M051601   SCR2B
label values  MB51601   SCR2B
label values  MC51601   SCR2B
label values  M068101   MC5E
label values  M051401   MC5C
label values  M052921   MA52421V
label values  M052901   SCR2B
label values  MB52901   MB52901V
label values  MC52901   MB52901V
label values  M021301   RATE2C
label values  MB21301   RATE2D
label values  MC21301   RATE2D
label values  M021302   RATE2C
label values  MB21302   RATE2D
label values  MC21302   RATE2D
label values  M0213CL   RATE3B
label values  M067101   MC5D
label values  M052001   MC5C
label values  M093101   MC5B
label values  M091801   MC5A
label values  M093001   MC5C
label values  M093501   RATE3B
label values  MB93501   RATE3B
label values  MC93501   RATE3B
label values  M093201   MC5B
label values  M052101   M052101V
label values  MB52101   M052101V
label values  MC52101   M052101V
label values  M068201   RATE5A
label values  MB68201   RATE5A
label values  MC68201   RATE5A
label values  M086201   MC5D
label values  M093301   MC5D
label values  M067501   RATE5A
label values  MB67501   RATE5A
label values  MC67501   RATE5A
label values  M105601   MC5D
label values  M105801   MC5D
label values  M105901   MC5B
label values  M106001   MC5B
label values  M106101   MC5D
label values  M106201   MC5C
label values  M106301   RATE2D
label values  MG06301   RATE2D
label values  MH06301   RATE2D
label values  M106401   MC5A
label values  M106501   MC5B
label values  M106601   MC5C
label values  M106701   MC5A
label values  M106801   MC5A
label values  M106901   RATE2D
label values  MG06901   RATE2D
label values  MH06901   RATE2D
label values  M107001   MC5A
label values  M107101   MC5D
label values  M107201   MC5C
label values  M107401   MC5C
label values  M107501   RATE2D
label values  MG07501   RATE2D
label values  MH07501   RATE2D
label values  M107601   MC5E
label values  M109801   MC5B
label values  M110001   MC5C
label values  M110101   MC5D
label values  M110201   RATE2D
label values  MG10201   RATE2D
label values  MH10201   RATE2D
label values  M110301   MC5C
label values  M110401   MC5B
label values  M110501   RATE3C
label values  MG10501   RATE3C
label values  MH10501   RATE3C
label values  M110601   MC5B
label values  M110701   MC5C
label values  M110801   MC5A
label values  M110901   MC5D
label values  M111001   MC5C
label values  M111201   MC5C
label values  M111301   MC5B
label values  M111401   MC5C
label values  M111501   MC5E
label values  M111601   MC5C
label values  M111801   RATE3B
label values  MG11801   RATE3B
label values  MH11801   RATE3B
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
label values  T077309   MAJOR
label values  T077310   MAJOR
label values  T077311   MAJOR
label values  T086801   MAJOR
label values  T077409   MAJOR
label values  T077410   MAJOR
label values  T077411   MAJOR
label values  T086901   MAJOR
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
label values  T044301   T044301Q
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
// mvdecode PARED BA21101 - M075201 M066201 M046201 M066401  M067401 - M051901 /*
//       */ M046101 - M046701 M047201 M067801 M067202 M068007 M047801 /*
//       */ M085601 - M085801 M046301 - M046501 M047101 M019601 M051501  /*
//       */ M017401 - M017601 M018201 M017701 - M046401 M018501 M018601 M018701  /*
//       */ M019101 M012731  M018801 - M018901 M012331 - M0128A1 /*
//       */ M0513A1 - M073402 M0734A1 M052601 - M0132A1 M0130A1 - M0126A1 /*
//       */ M0211A1 - M0476A1 M0920A1 - M073204 M0732A1 - M0733A1 /*
//       */ M0210A1 - M0922A1 M0209A1 - M0525A1 M0924A1 - M0192A1 /*
//       */ M0926A1 - M073602 M0736A1 - M0757A1 M0131A1 - M0916A1 /*
//       */ M0735A1 MA52421  M0524A1 M0753A1 M0729A1 - M0136A1 /*
//       */ M0758A1 - M0934A1 M0938A1 M068101 - M052921 M067101 - M093001 /*
//       */ M093201 M086201 M093301  M105601 - M106201 M106401 - M106801 /*
//       */ M107001 - M107401 M107601 - M110101 M110301 M110401  /*
//       */ M110601 - M111601 X012101 - X013001 X015501 - X014601 /*
//       */ X015901 X014901  T077201 - T044301,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M075201 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M066201 - MC47301 M046201 - MC20101 M067401 - M051901 /*
//       */ M046101 - M046701 M047201 - MC46601 M067801 - MC66601 /*
//       */ M067202 - MC67201 M068003 - MC68003 M068005 - MC68005 /*
//       */ M068008 - MC68008 M068007 - MC68006 M093601 - MC93601 /*
//       */ M053001 - MC53001 M047801 M085701 - MC85701 M085901 - MC85901 /*
//       */ M085601 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M019601 - MC47901 /*
//       */ M017401 - MC20201 M018201 - MC20401 M017701 - MC20501 /*
//       */ M018501 - MC20301 M018601 - MC19801 M019101 - MC21201 /*
//       */ M018801 - M018901 M012331 - MC51301 M0513A1 - MC73401 /*
//       */ M0734A1 - MC13031 M0130A1 - MC21101 M0211A1 - M0476A1 /*
//       */ M0920A1 - MC21001 M0210A1 - MC20901 M0209A1 - MC92401 /*
//       */ M0924A1 - MC92601 M0926A1 - M073602 M0736A1 - MC13131 /*
//       */ M0131A1 - MC73501 M0735A1 - MC52401 M0524A1 - MC75301 /*
//       */ M0753A1 - MC72901 M0729A1 - MC75801 M0758A1 - M0934A1 /*
//       */ M0938A1 - MC51201 M051601 - MC51601 M068101 - MC52901 /*
//       */ M021301 - MC21301 M021302 - MC21302 M0213CL - MC93501 /*
//       */ M093201 - MC52101 M086201 M093301  M105601 - MH06301 /*
//       */ M106401 - MH06901 M107001 - MH07501 M107601 - MH10201 /*
//       */ M110301 - MH10501 M110601 - MH11801,  mv( 9=.n)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M020801 - MC20801 M052201 - MC52201 M092001 - MC92001 /*
//       */ M073601 - MC73601 M093801 - MC93801 M068201 - MC68201 /*
//       */ M067501 - MC67501,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 PARED HISPYES - SCHTY02 SENROL8 - PCTINDC BA21101 - M813701 /*
//       */ M813901 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M066201 - MC47301 M046201 - MC20101 M067401 - M051901 /*
//       */ M046101 - M046701 M047201 - MC46601 M067801 - MC66601 /*
//       */ M067202 - MC67201 M068003 - MC68003 M068005 - MC68005 /*
//       */ M068008 - MC68008 M068007 - MC68006 M093601 - MC93601 /*
//       */ M053001 - MC53001 M047801 M085701 - MC85701 M085901 - MC85901 /*
//       */ M085601 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M019601 - MC47901 /*
//       */ M017401 - MC20201 M018201 - MC20401 M017701 - MC20501 /*
//       */ M018501 - MC20301 M018601 - MC19801 M019101 - MC21201 /*
//       */ M018801 - M018901 M012331 - MC51301 M0513A1 - MC73401 /*
//       */ M0734A1 - MC13031 M0130A1 - MC21101 M0211A1 - M0476A1 /*
//       */ M0920A1 - MC21001 M0210A1 - MC20901 M0209A1 - MC92401 /*
//       */ M0924A1 - MC92601 M0926A1 - M073602 M0736A1 - MC13131 /*
//       */ M0131A1 - MC73501 M0735A1 - MC52401 M0524A1 - MC75301 /*
//       */ M0753A1 - MC72901 M0729A1 - MC75801 M0758A1 - M0934A1 /*
//       */ M0938A1 - MC51201 M051601 - MC51601 M068101 - MC52901 /*
//       */ M021301 - MC21301 M021302 - MC21302 M0213CL - MC93501 /*
//       */ M093201 - MC52101 M086201 M093301  M105601 - MH06301 /*
//       */ M106401 - MH06901 M107001 - MH07501 M107601 - MH10201 /*
//       */ M110301 - MH10501 M110601 - MH11801 X005701 - X005705 /*
//       */ X012201 - X014901 T077201 - T044301,  mv( 8=.o)
// mvdecode M813601 M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M020801 - MC20801 M052201 - MC52201 M092001 - MC92001 /*
//       */ M073601 - MC73601 M093801 - MC93801 M068201 - MC68201 /*
//       */ M067501 - MC67501 X012101,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B017301  B003501 B003601  /*
//       */ X012301 - X016001 X015601 X014001  X015701 X014401,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode M075401 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M047301 - MC47301 M020101 - MC20101 M046601 - MC46601 /*
//       */ M066601 - MC66601 M067201 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068006 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M047901 - MC47901 M020201 - MC20201 M020401 - MC20401 /*
//       */ M020501 - MC20501 M020301 - MC20301 M019801 - MC19801 /*
//       */ M021201 - MC21201 M051301 - MC51301 M073401 - MC73401 /*
//       */ M013031 - MC13031 M021101 - MC21101 M021001 - MC21001 /*
//       */ M020901 - MC20901 M092401 - MC92401 M092601 - MC92601 /*
//       */ M013131 - MC13131 M073501 - MC73501 M052401 - MC52401 /*
//       */ M075301 - MC75301 M072901 - MC72901 M075801 - MC75801 /*
//       */ M051201 - MC51201 M051601 - MC51601 M052901 - MC52901 /*
//       */ M021301 - MC21301 M021302 - MC21302 M093501 - MC93501 /*
//       */ M052101 - MC52101 M106301 - MH06301 M106901 - MH06901 /*
//       */ M107501 - MH07501 M110201 - MH10201 M110501 - MH10501 /*
//       */ M111801 - MH11801,  mv( 7=.q)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M020801 - MC20801 M052201 - MC52201 M092001 - MC92001 /*
//       */ M073601 - MC73601 M093801 - MC93801 M068201 - MC68201 /*
//       */ M067501 - MC67501,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M075401 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M047301 - MC47301 M020101 - MC20101 M046601 - MC46601 /*
//       */ M066601 - MC66601 M067201 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068006 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M047901 - MC47901 M020201 - MC20201 M020401 - MC20401 /*
//       */ M020501 - MC20501 M020301 - MC20301 M019801 - MC19801 /*
//       */ M021201 - MC21201 M051301 - MC51301 M073401 - MC73401 /*
//       */ M013031 - MC13031 M021101 - MC21101 M021001 - MC21001 /*
//       */ M020901 - MC20901 M092401 - MC92401 M092601 - MC92601 /*
//       */ M013131 - MC13131 M073501 - MC73501 M052401 - MC52401 /*
//       */ M075301 - MC75301 M072901 - MC72901 M075801 - MC75801 /*
//       */ M051201 - MC51201 M051601 - MC51601 M052901 - MC52901 /*
//       */ M021301 - MC21301 M021302 - MC21302 M093501 - MC93501 /*
//       */ M052101 - MC52101 M106301 - MH06301 M106901 - MH06901 /*
//       */ M107501 - MH07501 M110201 - MH10201 M110501 - MH10501 /*
//       */ M111801 - MH11801,  mv( 5=.r)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M020801 - MC20801 M052201 - MC52201 M092001 - MC92001 /*
//       */ M073601 - MC73601 M093801 - MC93801 M068201 - MC68201 /*
//       */ M067501 - MC67501,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode M075401 - MC75401 M075601 - MC75601 M019901 - MC19901 /*
//       */ M047301 - MC47301 M020101 - MC20101 M046601 - MC46601 /*
//       */ M066601 - MC66601 M067201 - MC67201 M068003 - MC68003 /*
//       */ M068005 - MC68005 M068008 - MC68008 M068006 - MC68006 /*
//       */ M093601 - MC93601 M053001 - MC53001 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M047901 - MC47901 M020201 - MC20201 M020401 - MC20401 /*
//       */ M020501 - MC20501 M020301 - MC20301 M019801 - MC19801 /*
//       */ M021201 - MC21201 M051301 - MC51301 M073401 - MC73401 /*
//       */ M013031 - MC13031 M021101 - MC21101 M021001 - MC21001 /*
//       */ M020901 - MC20901 M092401 - MC92401 M092601 - MC92601 /*
//       */ M013131 - MC13131 M073501 - MC73501 M052401 - MC52401 /*
//       */ M075301 - MC75301 M072901 - MC72901 M075801 - MC75801 /*
//       */ M051201 - MC51201 M051601 - MC51601 M052901 - MC52901 /*
//       */ M021301 - MC21301 M021302 - MC21302 M093501 - MC93501 /*
//       */ M052101 - MC52101 M106301 - MH06301 M106901 - MH06901 /*
//       */ M107501 - MH07501 M110201 - MH10201 M110501 - MH10501 /*
//       */ M111801 - MH11801,  mv( 6=.s)
// mvdecode M076001 - MC76001 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M086301 - MC86301 M053101 - MC53101 /*
//       */ M020801 - MC20801 M052201 - MC52201 M092001 - MC92001 /*
//       */ M073601 - MC73601 M093801 - MC93801 M068201 - MC68201 /*
//       */ M067501 - MC67501,  mv(66=.s)
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
// recode M075201 M086101 M019601 M012331 M012531 M012931 M073301 M019201 /*
//     */ M091901 M067001 M013431 M051401 M052001 M093001 M106201 M106601 /*
//     */ M107201 M107401 M110001 M110301 M110701 M111001 M111201 M111401 /*
//     */ M111601 (1=0) (2=0) (3=1) (4=0) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ (else=.)
// recode M075401 M075601 M066601 M067201 M068003 M068005 M068008 M068006 /*
//     */ M093601 M085901 M066501 M066301 M067901 M092401 M092601 M075301 /*
//     */ M072901 M075801 M093501 M110501 M111801 (1=0) (2=1) (3=2) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M019901 M085701 M019801 M073501 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M066201 M046101 M047201 M085601 M046301 M017801 M018401 /*
//     */ M018301 M018001 M018701 M011131 (1=0) (2=1) (3=0) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M047301 M046601 M020301 M013031 (1=0) (2=0) (3=0) (4=1) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M046201 M046701 M067801 M047101 M017401 N202831 M018101 M018501 (1=0) /*
//     */ (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M066401 M047001 M017601 M017701 M046401 M018601 (1=0) (2=0) (3=0) /*
//     */ (4=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M020101 M053001 M019701 M020001 M020201 M020401 M020501 M051301 /*
//     */ M021001 M020901 M013131 M052401 M051201 M051601 M052901 M106301 /*
//     */ M106901 M107501 M110201 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M067401 M085801 M051501 M052301 M073101 M012431 M091701 M013631 /*
//     */ M093401 M091801 M106401 M106701 M106801 M107001 M110801 (1=1) (2=0) /*
//     */ (3=0) (4=0) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M047701 M086001 M019101 M018901 M012831 M012631 M075901 M092201 /*
//     */ M052501 M072801 M051801 M093101 M093201 M105901 M106001 M106501 /*
//     */ M109801 M110401 M110601 M111301 (1=0) (2=1) (3=0) (4=0) (5=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M067301 M051901 M047801 M012731 M018801 M019301 M052601 M052701 /*
//     */ M013231 M012231 M051701 M091501 M091601 M013731 M067101 /*
//     */ M086201 M093301 M105601 M105801 M106101 M107101 M110101 M110901 (1=0) /*
//     */ (2=0) (3=0) (4=1) (5=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M048001 M093701 M068007 M019001 M075501 M047601 M013331 M073001 /*
//     */ M013531 M068101 M107601 M111501 (1=0) (2=0) (3=0) (4=0) (5=1) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode M076001 M086301 M052201 M092001 M073601 (1=0) (2=1) (3=2) (4=3) (5=4) /*
//     */ (99=.n) (88=.o) (77=.q) (55=.r) (66=.s) (else=.)
// recode M046001 M046901 M046801 (1=0) (2=0) (3=0) (4=0) (5=1) (99=.n) (88=.o) /*
//     */ (77=.q) (55=.r) (66=.s) (else=.)
// recode M067701 M085501 M046501 M017501 M018201 M017901 (1=1) (2=0) (3=0) /*
//     */ (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M047901 M021201 M021101 M052101 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M053101 (1=0) (2=1) (3=2) (4=2) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M020801 (1=0) (2=0) (3=0) (4=0) (5=0) (6=1) (99=.n) (88=.o) (77=.q) /*
//     */ (55=.r) (66=.s) (else=.)
// recode M0734CL (1=0) (2=1) (3=2) (4=2) ( 9=.n) ( 8=.o) (else=.)
// recode M0732CL (1=0) (2=1) (3=2) (4=3) (5=4) ( 9=.n) ( 8=.o) (else=.)
// recode M0757CL (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) (else=.)
// recode M093801 (1=0) (2=1) (3=2) (4=3) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M0213CL (1=0) (2=1) (3=2) ( 9=.n) ( 8=.o) (else=.)
// recode M068201 (1=0) (2=1) (3=1) (4=1) (5=1) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M067501 (1=0) (2=1) (3=2) (4=2) (5=2) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: STATE FIPS, NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2003
gen grade=8
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2003\naep_math_gr8_2003", replace
