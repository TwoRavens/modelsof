version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Math G4\stata\LABELDEF.do"
label data "  2007 National Mathematics Assessment: Grade  4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPAC\NAEP 2007\NAEP 2007 Math G4\stata\M38NT1AT.DCT", clear
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
label values  B018201   B018201V
label values  M814301   M814301V
label values  M814601   YESNO
label values  M814701   YESNO
label values  M815101   M815101V
label values  M815301   M815301V
label values  M820001   M820001V
label values  M820002   M820001V
label values  M820003   M820001V
label values  M820004   M820001V
label values  M820005   M820001V
label values  M815401   M815401V
label values  M815501   M815501V
label values  M815601   M815601V
label values  M145201   MC5C
label values  M145301   MC5A
label values  M145401   MC5D
label values  M145501   MC5C
label values  M145601   MC5B
label values  M145701   MC5D
label values  M145801   MC5D
label values  M145901   RATE3B
label values  M1459R1   M1459R1V
label values  MG45901   MG45901V
label values  MG459R1   M1459R1V
label values  MH45901   RATE3B
label values  MH459R1   M1459R1V
label values  M146001   MC5C
label values  M146101   RATE2D
label values  M1461R1   SCR4D
label values  MG46101   MG46101V
label values  MG461R1   SCR4D
label values  MH46101   RATE2D
label values  MH461R1   SCR4D
label values  M146201   MC5C
label values  M146301   RATE3B
label values  MG46301   MG45901V
label values  MH46301   RATE3B
label values  M146401   RATE3B
label values  MG46401   MG45901V
label values  MH46401   RATE3B
label values  M146501   MC5D
label values  M146601   RATE5A
label values  MG46601   MG46601V
label values  MH46601   RATE5A
label values  M146701   MC5C
label values  M146801   RATE2D
label values  MG46801   MG46101V
label values  MH46801   RATE2D
label values  M146901   RATE3B
label values  MG46901   MG45901V
label values  MH46901   RATE3B
label values  M147001   RATE3B
label values  MG47001   MG45901V
label values  MH47001   RATE3B
label values  M147101   MC5D
label values  M147201   MC5B
label values  M147301   MC5A
label values  M147401   MC5B
label values  M147501   MC5B
label values  M147601   MC5B
label values  M147701   MC5C
label values  M147801   MC5B
label values  M147901   MC5A
label values  M148001   MC5C
label values  M148101   RATE3B
label values  MG48101   MG45901V
label values  MH48101   RATE3B
label values  M085201   MC5C
label values  M085301   MC5C
label values  M085701   RATE3B
label values  MB85701   RATE3B
label values  MC85701   MG45901V
label values  M085901   RATE3B
label values  MB85901   RATE3B
label values  MC85901   RATE3B
label values  M085601   MC5B
label values  M085401   RATE5A
label values  MB85401   RATE5A
label values  MC85401   MG46601V
label values  M019701   MG46101V
label values  MB19701   RATE2D
label values  MC19701   MG46101V
label values  M020001   MG46101V
label values  MB20001   RATE2D
label values  MC20001   MG46101V
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
label values  M135601   MC5C
label values  M135701   MC5A
label values  M135801   MC5B
label values  M135901   MC5A
label values  M136001   MC5B
label values  M136101   MC5D
label values  M136201   MC5A
label values  M136301   MC5C
label values  M136401   MC5D
label values  M136501   M136501V
label values  MG36501   MG46101V
label values  MH36501   RATE2D
label values  M136601   M136601V
label values  MG36601   MG36601V
label values  MH36601   M136601V
label values  M136701   MC5D
label values  M136801   MC5B
label values  M136901   M136901V
label values  MG36901   MG36901V
label values  MH36901   M136901V
label values  M137001   MC5D
label values  M137101   MC5C
label values  M138801   MC5B
label values  M1388A1   YESNO
label values  M138901   MC5A
label values  M1389A1   YESNO
label values  M139001   MC5C
label values  M1390A1   YESNO
label values  M139101   MC5A
label values  M1391A1   YESNO
label values  M139201   MC5A
label values  M1392A1   YESNO
label values  M139301   RATE2D
label values  MG39301   MG46101V
label values  MH39301   RATE2D
label values  M1393A1   YESNO
label values  M139401   MC5A
label values  M1394A1   YESNO
label values  M139501   MC5D
label values  M1395A1   YESNO
label values  M139601   M136601V
label values  MG39601   MG36601V
label values  MH39601   M136601V
label values  M1396A1   YESNO
label values  M139701   MC5B
label values  M1397A1   YESNO
label values  M139801   M136901V
label values  MG39801   M136901V
label values  MH39801   M136901V
label values  M1398A1   YESNO
label values  M139901   MC5D
label values  M1399A1   YESNO
label values  M140001   M136601V
label values  MG40001   MG36601V
label values  MH40001   M136601V
label values  M1400A1   YESNO
label values  M140101   MC5B
label values  M1401A1   YESNO
label values  M140201   MC5C
label values  M1402A1   YESNO
label values  M140301   M140301V
label values  MG40301   M140301V
label values  MH40301   M140301V
label values  M1403A1   YESNO
label values  M010131   MC5A
label values  M0101A1   YESNO
label values  N214331   MC5D
label values  N2143A1   YESNO
label values  M039101   MC5A
label values  M0391A1   YESNO
label values  M086701   MC5A
label values  M0867A1   YESNO
label values  M010631   M010631V
label values  MB10631   MB10631V
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
label values  MC87001   MG45901V
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
label values  MC91201   MG45901V
label values  M0912A1   YESNO
label values  M066001   MC5A
label values  M0660A1   YESNO
label values  M072401   RATE3B
label values  MB72401   RATE3B
label values  MC72401   MG45901V
label values  M0724A1   YESNO
label values  M091301   MC5C
label values  M0913A1   YESNO
label values  M087301   RATE5A
label values  MB87301   RATE5A
label values  MC87301   MG46601V
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
label values  MC86601   MG45901V
label values  M039501   MC5C
label values  M090801   MC5A
label values  M066701   RATE3B
label values  MB66701   RATE3B
label values  MC66701   MC66501V
label values  M043101   MC5B
label values  M066801   RATE3B
label values  MB66801   RATE3B
label values  MC66801   MC66501V
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
label values  M0434CL   M136901V
label values  M043301   SCR3C
label values  MB43301   SCR3C
label values  MC43301   SCR3C
label values  M074401   MC5A
label values  M040221   YESNO
label values  M040201   SCR2B
label values  MB40201   SCR2B
label values  MC40201   SCR2B
label values  M0402CL   RATE3B
label values  M039601   M039601V
label values  M091401   RATE5A
label values  MB91401   RATE5A
label values  MC91401   MG46601V
label values  M137201   MC5A
label values  M137301   MC5B
label values  M137401   MC5D
label values  M137501   M136501V
label values  MG37501   MG46101V
label values  MH37501   RATE2D
label values  M137601   MC5D
label values  M137701   MC5B
label values  M137801   MC5D
label values  M137901   MC5C
label values  M138001   MC5B
label values  M138101   MC5B
label values  M138201   M136501V
label values  MG38201   MG38201V
label values  MH38201   M136501V
label values  M138301   MC5B
label values  M138401   M136901V
label values  MG38401   M136901V
label values  MH38401   M136901V
label values  M138501   MC5A
label values  M138601   MC5A
label values  M138701   M138701V
label values  MG38701   M138701V
label values  MH38701   M138701V
label values  M095701   MC5C
label values  M095801   MC5A
label values  M095901   MC5D
label values  M096001   RATE2D
label values  MB96001   RATE2D
label values  MC96001   MG46101V
label values  M096101   MC5C
label values  M096301   MC5B
label values  M096401   MC5C
label values  M096601   MC5D
label values  M096701   MC5D
label values  M096801   MC5A
label values  M096901   MC5B
label values  M097001   MC5C
label values  M097101   MC5B
label values  M097201   M136601V
label values  MB97201   RATE3C
label values  MC97201   MC97201V
label values  M097301   MC5B
label values  M097401   M136601V
label values  MB97401   RATE3C
label values  MC97401   MC97201V
label values  M097501   MC5D
label values  M097601   MC5D
label values  M148201   MC5C
label values  M148301   MC5C
label values  M148401   MC5C
label values  M148501   RATE3B
label values  M1485R1   SCR4D
label values  MG48501   RATE3B
label values  MG485R1   SCR4D
label values  MH48501   RATE3B
label values  MH485R1   SCR4D
label values  M148601   MC5A
label values  M148701   MC5D
label values  M148801   MC5B
label values  M148901   MC5C
label values  M149001   MC5C
label values  M149101   MC5B
label values  M149201   RATE3B
label values  M1492R1   SCR3C
label values  MG49201   RATE3B
label values  MG492R1   SCR3C
label values  MH49201   RATE3B
label values  MH492R1   SCR3C
label values  M149301   RATE2D
label values  MG49301   RATE2D
label values  MH49301   RATE2D
label values  M149401   MC5B
label values  M149501   MC5C
label values  M149601   MC5C
label values  M149701   RATE5A
label values  MG49701   RATE5A
label values  MH49701   RATE5A
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
label values  T089601   M815301V
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
// mvdecode BA21101 - M145801 M146001 M146201 M146501 M146701 M147101 - M148001 /*
//       */ M085201 M085301  M085601 M046301 - M046501 M047101 /*
//       */ M135601 - M136501 M136601 M136701 - M136901 M137001 - M1392A1 /*
//       */ M1393A1 - M1395A1 M1396A1 - M1397A1 M1398A1 - M1399A1 /*
//       */ M1400A1 - M1402A1 M1403A1 - M0867A1 M0106A1 - M0909A1 /*
//       */ M0870A1 - M0398A1 M0400A1 - M0872A1 M0912A1 - M0660A1 /*
//       */ M0724A1 - M0913A1 M0873A1 - M042601 M071901 M086801  /*
//       */ M039501 M090801  M043101 M067601 M074401 M040221  M039601 /*
//       */ M137201 - M137501 M137601 - MH38201 M138301 - MH38401 /*
//       */ M138501 - MH38701 M095701 - M095901 M096101 - M097101 M097301 /*
//       */ M097501 - M148401 M148601 - M149101 M149401 - M149601 /*
//       */ TA21101 - TE21201 T077201 - T096305 XS02101 XS02201  /*
//       */ XS02401 - XS02601 XS02701 XS02001  X013801 XL01901 /*
//       */ XL02101 - XL02301 XL00601 - XL02404,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode PCHRTFL M145201 - MH459R1 M146001 - MH461R1 M146201 - MH46301 /*
//       */ M146401 - MH46401 M146501 M146701 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M147101 - MH48101 M085201 - MC85701 /*
//       */ M085901 - MC85901 M085601 M019701 - MC19701 M020001 - MC20001 /*
//       */ M046301 - MC66501 M047101 - MC66301 M067901 - MC67901 /*
//       */ M135601 - MH36501 M136601 - MH36601 M136701 - MH36901 /*
//       */ M137001 - MH39301 M1393A1 - MH39601 M1396A1 - MH39801 /*
//       */ M1398A1 - MH40001 M1400A1 - M1402A1 M1403A1 - MC10631 /*
//       */ M0106A1 - MC87001 M0870A1 - MC40001 M0400A1 - MC91201 /*
//       */ M0912A1 - MC72401 M0724A1 - M0913A1 M0873A1 - MC43201 /*
//       */ M071901 - MC86601 M039501 - MC66701 M043101 - MC66801 /*
//       */ M067601 - MC43401 M043402 - MC43402 M043403 - MC43403 /*
//       */ M0434CL - MC43301 M074401 - MC40201 M0402CL M039601  /*
//       */ M137201 - MH37501 M137601 - MH38201 M138301 - MH38401 /*
//       */ M138501 M138601  M095701 - MC96001 M096101 - MC97201 /*
//       */ M097301 - MC97401 M097501 - MH485R1 M148601 - MH492R1 /*
//       */ M149301 - MH49301 M149401 - M149601,  mv( 9=.n)
// mvdecode M146601 - MH46601 M085401 - MC85401 M140301 - MH40301 /*
//       */ M087301 - MC87301 M091401 - MC91401 M138701 - MH38701 /*
//       */ M149701 - MH49701,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode PCHRTFL MODAGE - PCTINDC SDRACEM LEP  BA21101 - MH459R1 /*
//       */ M146001 - MH461R1 M146201 - MH46301 M146401 - MH46401 M146501 /*
//       */ M146701 - MH46801 M146901 - MH46901 M147001 - MH47001 /*
//       */ M147101 - MH48101 M085201 - MC85701 M085901 - MC85901 M085601 /*
//       */ M019701 - MC19701 M020001 - MC20001 M046301 - MC66501 /*
//       */ M047101 - MC66301 M067901 - MC67901 M135601 - MH36501 /*
//       */ M136601 - MH36601 M136701 - MH36901 M137001 - MH39301 /*
//       */ M1393A1 - MH39601 M1396A1 - MH39801 M1398A1 - MH40001 /*
//       */ M1400A1 - M1402A1 M1403A1 - MC10631 M0106A1 - MC87001 /*
//       */ M0870A1 - MC40001 M0400A1 - MC91201 M0912A1 - MC72401 /*
//       */ M0724A1 - M0913A1 M0873A1 - MC43201 M071901 - MC86601 /*
//       */ M039501 - MC66701 M043101 - MC66801 M067601 - MC43401 /*
//       */ M043402 - MC43402 M043403 - MC43403 M0434CL - MC43301 /*
//       */ M074401 - MC40201 M0402CL M039601  M137201 - MH37501 /*
//       */ M137601 - MH38201 M138301 - MH38401 M138501 M138601  /*
//       */ M095701 - MC96001 M096101 - MC97201 M097301 - MC97401 /*
//       */ M097501 - MH485R1 M148601 - MH492R1 M149301 - MH49301 /*
//       */ M149401 - M149601 TA21101 - TE21201 T077201 - T096305 /*
//       */ XS02101 - XS02601 XS00301 - XS00312 XS02701 XS02001  X013801 /*
//       */ XL01901 - XL02301 XL00601 - XL02404,  mv( 8=.o)
// mvdecode M146601 - MH46601 M085401 - MC85401 M140301 - MH40301 /*
//       */ M087301 - MC87301 M091401 - MC91401 M138701 - MH38701 /*
//       */ M149701 - MH49701,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode B017001 B000905  B017201 M136701 M136801  M137001 M137101  /*
//       */ M137201 - M137401 M137601 - M138101 M138301 M138501 M138601  /*
//       */ XS02001 XL00601 - XL02404,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode M145901 - MH459R1 M146101 - MH461R1 M146301 - MH46301 /*
//       */ M146401 - MH46401 M146801 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M148101 - MH48101 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136901 - MH36901 /*
//       */ M139301 - MH39301 M139601 - MH39601 M139801 - MH39801 /*
//       */ M140001 - MH40001 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M043201 - MC43201 M086601 - MC86601 M066701 - MC66701 /*
//       */ M066801 - MC66801 M043401 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M0434CL - MC43301 M040201 - MC40201 /*
//       */ M0402CL M039601  M137501 - MH37501 M138201 - MH38201 /*
//       */ M138401 - MH38401 M096001 - MC96001 M097201 - MC97201 /*
//       */ M097401 - MC97401 M148501 - MH485R1 M149201 - MH492R1 /*
//       */ M149301 - MH49301,  mv( 7=.q)
// mvdecode M146601 - MH46601 M085401 - MC85401 M140301 - MH40301 /*
//       */ M087301 - MC87301 M091401 - MC91401 M138701 - MH38701 /*
//       */ M149701 - MH49701,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M145901 - MH459R1 M146101 - MH461R1 M146301 - MH46301 /*
//       */ M146401 - MH46401 M146801 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M148101 - MH48101 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136901 - MH36901 /*
//       */ M139301 - MH39301 M139601 - MH39601 M139801 - MH39801 /*
//       */ M140001 - MH40001 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M043201 - MC43201 M086601 - MC86601 M066701 - MC66701 /*
//       */ M066801 - MC66801 M043401 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M0434CL - MC43301 M040201 - MC40201 M0402CL /*
//       */ M137501 - MH37501 M138201 - MH38201 M138401 - MH38401 /*
//       */ M096001 - MC96001 M097201 - MC97201 M097401 - MC97401 /*
//       */ M148501 - MH485R1 M149201 - MH492R1 M149301 - MH49301,  mv( 5=.r)
// mvdecode M146601 - MH46601 M085401 - MC85401 M140301 - MH40301 /*
//       */ M087301 - MC87301 M091401 - MC91401 M138701 - MH38701 /*
//       */ M149701 - MH49701,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode M145901 - MH459R1 M146101 - MH461R1 M146301 - MH46301 /*
//       */ M146401 - MH46401 M146801 - MH46801 M146901 - MH46901 /*
//       */ M147001 - MH47001 M148101 - MH48101 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136901 - MH36901 /*
//       */ M139301 - MH39301 M139601 - MH39601 M139801 - MH39801 /*
//       */ M140001 - MH40001 M010631 - MC10631 M087001 - MC87001 /*
//       */ M040001 - MC40001 M091201 - MC91201 M072401 - MC72401 /*
//       */ M043201 - MC43201 M086601 - MC86601 M066701 - MC66701 /*
//       */ M066801 - MC66801 M043401 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M0434CL - MC43301 M040201 - MC40201 M0402CL /*
//       */ M137501 - MH37501 M138201 - MH38201 M138401 - MH38401 /*
//       */ M096001 - MC96001 M097201 - MC97201 M097401 - MC97401 /*
//       */ M148501 - MH485R1 M149201 - MH492R1 M149301 - MH49301,  mv( 6=.s)
// mvdecode M146601 - MH46601 M085401 - MC85401 M140301 - MH40301 /*
//       */ M087301 - MC87301 M091401 - MC91401 M138701 - MH38701 /*
//       */ M149701 - MH49701,  mv(66=.s)
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
// recode M145201 M145501 M146001 M146201 M146701 M147701 M148001 /*
//     */ M085201 M085301 M047101 M135601 M136301 M139001 M140201 M087201 /*
//     */ M091301 M039501 M067601 M095701 M096101 M096401 M097001 /*
//     */ M148201 - M148401 M148901 M149001 M149501 M149601 (1=0) (2=0) (3=1) /*
//     */ (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M145301 M147301 M147901 M046501 M135701 M135901 M136201 M138901 /*
//     */ M139101 M139201 M139401 M010131 M039101 M086701 M072301 M066001 /*
//     */ M090801 M074401 M095801 M096801 M148601 (1=1) (2=0) (3=0) (4=0) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M145401 M145701 M145801 M146501 M147101 M047001 M136101 M136401 /*
//     */ M139501 M139901 N214331 M010831 M042801 M095901 M096601 M096701 /*
//     */ M097501 M097601 M148701 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) (else=.)
// recode M145601 M147201 M147401 - M147601 M147801 M085601 M046301 M135801 /*
//     */ M136001 M138801 M139701 M140101 M010331 M086901 M090901 M039801 /*
//     */ M042601 M071901 M086801 M043101 M096301 M096901 M097101 M097301 /*
//     */ M148801 M149101 M149401 (1=0) (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) (else=.)
// recode M145901 M146301 M146401 M146901 M147001 M148101 M085701 M066501 /*
//     */ M066301 M067901 M139601 M140001 M087001 M091201 M072401 M086601 /*
//     */ M066701 M066801 M097201 M097401 M148501 M149201 (1=0) (2=1) (3=2) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M146101 M146801 M019701 M020001 M139301 M043201 M096001 M149301 (1=0) /*
//     */ (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M146601 M140301 M087301 M091401 M149701 (1=0) (2=1) (3=2) (4=3) (5=4) /*
//     */ (99=.n) (88=.o) (77=.q) (55=.r) (66=.s) (else=.)
// recode M085901 M010631 M040001 M043301 M0402CL (1=0) (2=0) (3=1) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M085401 (1=0) (2=1) (3=2) (4=3) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M136501 M137501 M138201 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M136601 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M136701 M137001 M137401 M137601 M137801 (1=0) (2=0) (3=0) (4=1) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.p) (else=.)
// recode M136801 M137301 M137701 M138001 M138101 M138301 (1=0) (2=1) (3=0) /*
//     */ (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.p) (else=.)
// recode M136901 M138401 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M137101 M137901 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.p) (else=.)
// recode M139801 (1=0) (2=1) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M0434CL (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M039601 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ (else=.)
// recode M137201 M138501 M138601 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.p) (else=.)
// recode M138701 (1=0) (2=1) (3=2) (4=3) (5=4) ( 0=.m) (99=.n) (88=.o) (77=.q) /*
//     */ (55=.r) (66=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2007
gen grade=4
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2007\naep_math_gr4_2007", replace


