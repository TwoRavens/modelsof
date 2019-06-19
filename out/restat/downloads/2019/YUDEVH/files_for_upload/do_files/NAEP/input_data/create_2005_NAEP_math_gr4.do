version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Math G4\stata\LABELDEF.do"
label data "  2005 National Mathematics Assessment: Grade  4 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Math G4\stata\M36NT1AT.DCT", clear
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
label values  OBOOKFL   OBOOKFL
label values  MOB       BMONTH
label values  MOBFLAG   OBOOKFL
label values  YOBFLAG   OBOOKFL
label values  DSEX      SEX
label values  SEXFLAG   OBOOKFL
label values  RACEFLG   OBOOKFL
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
label values  Y36OMC    BLKUSE
label values  Y36OMD    BLKUSE
label values  Y36OME    BLKUSE
label values  Y36OMF    BLKUSE
label values  Y36OMG    BLKUSE
label values  Y36OMH    BLKUSE
label values  Y36OMI    BLKUSE
label values  Y36OMJ    BLKUSE
label values  Y36OMK    BLKUSE
label values  Y36OML    BLKUSE
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
label values  M814301   M814301V
label values  M814401   YESNO
label values  M814501   YESNO
label values  M814601   YESNO
label values  M814701   YESNO
label values  M814801   YESNO
label values  M814901   YESNO
label values  M815001   M815001V
label values  M815101   M815101V
label values  M815201   M815201V
label values  M815301   M815301V
label values  M815401   M815401V
label values  M815501   M815501V
label values  M815601   M815601V
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
label values  N277903   RATE2E
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
label values  MC19901   MC19901V
label values  M066201   MC5B
label values  M047301   M047301V
label values  MB47301   SCR4D
label values  MC47301   SCR4D
label values  M046201   MC5C
label values  M066401   MC5D
label values  M020101   RATE2D
label values  MB20101   RATE2D
label values  MC20101   RATE2D
label values  M043501   M043501V
label values  MB43501   RATE5A
label values  MC43501   MC43501V
label values  M046001   M046001V
label values  MB46001   SCR5E
label values  MC46001   SCR5E
label values  M046101   MC5B
label values  M067701   MC5A
label values  M046701   MC5C
label values  M046901   M046001V
label values  MB46901   SCR5E
label values  MC46901   SCR5E
label values  M047201   MC5B
label values  M046601   M047301V
label values  MB46601   SCR4D
label values  MC46601   SCR4D
label values  M046801   M046001V
label values  MB46801   SCR5E
label values  MC46801   SCR5E
label values  M067801   MC5C
label values  M066601   RATE3B
label values  MB66601   RATE3B
label values  MC66601   MC66601V
label values  M068001   RATE3B
label values  MB68001   RATE3B
label values  MC68001   MC66601V
label values  M068002   RATE3B
label values  MB68002   RATE3B
label values  MC68002   RATE3B
label values  M068003   RATE3B
label values  MB68003   RATE3B
label values  MC68003   MC66601V
label values  M068004   M043501V
label values  MB68004   RATE5A
label values  MC68004   MC68004V
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
label values  M019701   RATE2E
label values  MB19701   RATE2D
label values  MC19701   RATE2D
label values  M020001   RATE2E
label values  MB20001   RATE2D
label values  MC20001   RATE2D
label values  M046301   MC5B
label values  M047001   MC5D
label values  M046501   MC5A
label values  M066501   RATE3B
label values  MB66501   RATE3B
label values  MC66501   MC66601V
label values  M047101   MC5C
label values  M066301   RATE3B
label values  MB66301   RATE3B
label values  MC66301   MC66601V
label values  M067901   RATE3B
label values  MB67901   RATE3B
label values  MC67901   MC66601V
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
label values  MG36501   RATE2D
label values  MH36501   RATE2D
label values  M136601   M136601V
label values  MG36601   M136601V
label values  MH36601   M136601V
label values  M136701   M136701V
label values  M136801   M136801V
label values  M136901   M136901V
label values  MG36901   M136901V
label values  MH36901   M136901V
label values  M137001   M136701V
label values  M137101   M137101V
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
label values  MG39301   RATE2D
label values  MH39301   RATE2D
label values  M1393A1   YESNO
label values  M139401   MC5A
label values  M1394A1   YESNO
label values  M139501   MC5D
label values  M1395A1   YESNO
label values  M139601   M136601V
label values  MG39601   M136601V
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
label values  MG40001   M136601V
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
label values  MC10631   MB10631V
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
label values  MC66701   MC66601V
label values  M043101   MC5B
label values  M066801   RATE3B
label values  MB66801   RATE3B
label values  MC66801   MC66601V
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
label values  MC91401   RATE5A
label values  M137201   M137201V
label values  M137301   M136801V
label values  M137401   M136701V
label values  M137501   M136501V
label values  MG37501   RATE2D
label values  MH37501   RATE2D
label values  M137601   M136701V
label values  M137701   M136801V
label values  M137801   M136701V
label values  M137901   M137101V
label values  M138001   M136801V
label values  M138101   M136801V
label values  M138201   M136501V
label values  MG38201   M136501V
label values  MH38201   M136501V
label values  M138301   M136801V
label values  M138401   M136901V
label values  MG38401   M136901V
label values  MH38401   M136901V
label values  M138501   M137201V
label values  M138601   M137201V
label values  M138701   M138701V
label values  MG38701   M138701V
label values  MH38701   M138701V
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
label values  M097201   M136601V
label values  MB97201   RATE3C
label values  MC97201   RATE3C
label values  M097301   MC5B
label values  M097401   M136601V
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
label values  M101501   RATE3B
label values  MG01501   RATE3C
label values  MH01501   RATE3C
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
label values  T089601   M815301V
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
// mvdecode BA21101 - M074201 M039001 - M039701 M066201 M046201 M066401  /*
//       */ M046101 - M046701 M047201 M067801 M085201 M085301  M085601 /*
//       */ M046301 - M046501 M047101 M135601 - M136501 M136601 /*
//       */ M136701 - M136901 M137001 - M1392A1 M1393A1 - M1395A1 /*
//       */ M1396A1 - M1397A1 M1398A1 - M1399A1 M1400A1 - M1402A1 /*
//       */ M1403A1 - M0867A1 M0106A1 - M0909A1 M0870A1 - M0398A1 /*
//       */ M0400A1 - M0872A1 M0912A1 - M0660A1 M0724A1 - M0913A1 /*
//       */ M0873A1 - M042601 M071901 M086801  M039501 M090801  M043101 M067601 /*
//       */ M074401 M040221  M039601 M137201 - M137501 M137601 - MH38201 /*
//       */ M138301 - MH38401 M138501 - MH38701 M095701 - M095901 /*
//       */ M096101 - M097101 M097301 M097501 - M100101 M100301 M100401  /*
//       */ M100601 - M101201 TA21101 - TE21201 T077201 - T090503 XS00201 /*
//       */ X012201 - XS00701 XS00901 - XS01201 XS01701 X013801 - XL01101 /*
//       */ XL01401,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode M074201 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M039001 - MC75001 /*
//       */ M019901 - MC19901 M066201 - MC47301 M046201 - MC20101 /*
//       */ M046101 - M046701 M047201 - MC46601 M067801 - MC66601 /*
//       */ M068001 - MC68001 M068002 - MC68002 M068003 - MC68003 /*
//       */ M085201 - MC85701 M085901 - MC85901 M085601 M019701 - MC19701 /*
//       */ M020001 - MC20001 M046301 - MC66501 M047101 - MC66301 /*
//       */ M067901 - MC67901 M135601 - MH36501 M136601 - MH36601 /*
//       */ M136701 - MH36901 M137001 - MH39301 M1393A1 - MH39601 /*
//       */ M1396A1 - MH39801 M1398A1 - MH40001 M1400A1 - M1402A1 /*
//       */ M1403A1 - MC10631 M0106A1 - MC87001 M0870A1 - MC40001 /*
//       */ M0400A1 - MC91201 M0912A1 - MC72401 M0724A1 - M0913A1 /*
//       */ M0873A1 - MC43201 M071901 - MC86601 M039501 - MC66701 /*
//       */ M043101 - MC66801 M067601 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M0434CL - MC43301 M074401 - MC40201 /*
//       */ M0402CL M039601  M137201 - MH37501 M137601 - MH38201 /*
//       */ M138301 - MH38401 M138501 M138601  M095701 - MC96001 /*
//       */ M096101 - MC97201 M097301 - MC97401 M097501 - MH00201 /*
//       */ M100301 - MH00501 M100601 - MH01401 M101501 - MH01501,  mv( 9=.n)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M140301 - MH40301 M087301 - MC87301 M091401 - MC91401 /*
//       */ M138701 - MH38701,  mv(99=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 SCHTY02 HISPYES DRACEM  SDRACEM SENROL4 - LEP /*
//       */ BA21101 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M039001 - MC75001 /*
//       */ M019901 - MC19901 M066201 - MC47301 M046201 - MC20101 /*
//       */ M046101 - M046701 M047201 - MC46601 M067801 - MC66601 /*
//       */ M068001 - MC68001 M068002 - MC68002 M068003 - MC68003 /*
//       */ M085201 - MC85701 M085901 - MC85901 M085601 M019701 - MC19701 /*
//       */ M020001 - MC20001 M046301 - MC66501 M047101 - MC66301 /*
//       */ M067901 - MC67901 M135601 - MH36501 M136601 - MH36601 /*
//       */ M136701 - MH36901 M137001 - MH39301 M1393A1 - MH39601 /*
//       */ M1396A1 - MH39801 M1398A1 - MH40001 M1400A1 - M1402A1 /*
//       */ M1403A1 - MC10631 M0106A1 - MC87001 M0870A1 - MC40001 /*
//       */ M0400A1 - MC91201 M0912A1 - MC72401 M0724A1 - M0913A1 /*
//       */ M0873A1 - MC43201 M071901 - MC86601 M039501 - MC66701 /*
//       */ M043101 - MC66801 M067601 - MC43401 M043402 - MC43402 /*
//       */ M043403 - MC43403 M0434CL - MC43301 M074401 - MC40201 /*
//       */ M0402CL M039601  M137201 - MH37501 M137601 - MH38201 /*
//       */ M138301 - MH38401 M138501 M138601  M095701 - MC96001 /*
//       */ M096101 - MC97201 M097301 - MC97401 M097501 - MH00201 /*
//       */ M100301 - MH00501 M100601 - MH01401 M101501 - MH01501 /*
//       */ TA21101 - TE21201 T077201 - T090503 XS00101 - XS01701 /*
//       */ XL00101 - XL01401,  mv( 8=.o)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M140301 - MH40301 M087301 - MC87301 M091401 - MC91401 /*
//       */ M138701 - MH38701,  mv(88=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode B017001 B000905  B017201 M136701 M136801  M137001 M137101  /*
//       */ M137201 - M137401 M137601 - M138101 M138301 M138501 M138601  /*
//       */ XS00501 - XS00701 XS01001 XS01101  XL00201 - XL00601 /*
//       */ XL00801 - XL01101,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode M074301 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M075001 - MC75001 /*
//       */ M019901 - MC19901 M047301 - MC47301 M020101 - MC20101 /*
//       */ M046601 - MC46601 M066601 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085701 - MC85701 /*
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
//       */ M097401 - MC97401 M100201 - MH00201 M100501 - MH00501 /*
//       */ M101401 - MH01401 M101501 - MH01501,  mv( 7=.q)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M140301 - MH40301 M087301 - MC87301 M091401 - MC91401 /*
//       */ M138701 - MH38701,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode M074301 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M075001 - MC75001 /*
//       */ M019901 - MC19901 M047301 - MC47301 M020101 - MC20101 /*
//       */ M046601 - MC46601 M066601 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136701 - MH36901 /*
//       */ M137001 M137101  M139301 - MH39301 M139601 - MH39601 /*
//       */ M139801 - MH39801 M140001 - MH40001 M010631 - MC10631 /*
//       */ M087001 - MC87001 M040001 - MC40001 M091201 - MC91201 /*
//       */ M072401 - MC72401 M043201 - MC43201 M086601 - MC86601 /*
//       */ M066701 - MC66701 M066801 - MC66801 M043401 - MC43401 /*
//       */ M043402 - MC43402 M043403 - MC43403 M0434CL - MC43301 /*
//       */ M040201 - MC40201 M0402CL M039601  M137201 - MH37501 /*
//       */ M137601 - MH38201 M138301 - MH38401 M138501 M138601  /*
//       */ M096001 - MC96001 M097201 - MC97201 M097401 - MC97401 /*
//       */ M100201 - MH00201 M100501 - MH00501 M101401 - MH01401 /*
//       */ M101501 - MH01501,  mv( 5=.r)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M140301 - MH40301 M087301 - MC87301 M091401 - MC91401 /*
//       */ M138701 - MH38701,  mv(55=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode M074301 - MC74301 M074801 - MC74801 M074901 - MC74901 /*
//       */ M074501 - MC74501 N277903 - NC77903 M075001 - MC75001 /*
//       */ M019901 - MC19901 M047301 - MC47301 M020101 - MC20101 /*
//       */ M046601 - MC46601 M066601 - MC66601 M068001 - MC68001 /*
//       */ M068002 - MC68002 M068003 - MC68003 M085701 - MC85701 /*
//       */ M085901 - MC85901 M019701 - MC19701 M020001 - MC20001 /*
//       */ M066501 - MC66501 M066301 - MC66301 M067901 - MC67901 /*
//       */ M136501 - MH36501 M136601 - MH36601 M136701 - MH36901 /*
//       */ M137001 M137101  M139301 - MH39301 M139601 - MH39601 /*
//       */ M139801 - MH39801 M140001 - MH40001 M010631 - MC10631 /*
//       */ M087001 - MC87001 M040001 - MC40001 M091201 - MC91201 /*
//       */ M072401 - MC72401 M043201 - MC43201 M086601 - MC86601 /*
//       */ M066701 - MC66701 M066801 - MC66801 M043401 - MC43401 /*
//       */ M043402 - MC43402 M043403 - MC43403 M0434CL - MC43301 /*
//       */ M040201 - MC40201 M0402CL M039601  M137201 - MH37501 /*
//       */ M137601 - MH38201 M138301 - MH38401 M138501 M138601  /*
//       */ M096001 - MC96001 M097201 - MC97201 M097401 - MC97401 /*
//       */ M100201 - MH00201 M100501 - MH00501 M101401 - MH01401 /*
//       */ M101501 - MH01501,  mv( 6=.s)
// mvdecode M043501 - MC43501 M046001 - MC46001 M046901 - MC46901 /*
//       */ M046801 - MC46801 M068004 - MC68004 M085401 - MC85401 /*
//       */ M140301 - MH40301 M087301 - MC87301 M091401 - MC91401 /*
//       */ M138701 - MH38701,  mv(66=.s)
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
//     */ M135601 M136301 M139001 M140201 M087201 M091301 M039501 M067601 /*
//     */ M095701 M096101 M096401 M097001 M100801 M101001 M101101 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M074301 N277903 M020101 M019701 M020001 M139301 M043201 M096001 /*
//     */ M100201 M100501 M101401 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M074801 M074901 M074501 M075001 M066601 M068002 M068003 M085701 /*
//     */ M066501 M066301 M067901 M139601 M140001 M087001 M091201 M072401 /*
//     */ M086601 M066701 M066801 M097201 M097401 M101501 (1=0) (2=1) (3=2) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M039001 M066401 M047001 M136101 M136401 M139501 M139901 N214331 /*
//     */ M010831 M042801 M095901 M096601 M096701 M097501 M097601 M100401 /*
//     */ M100601 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M047501 M074601 M066201 M046101 M047201 M085601 M046301 M135801 /*
//     */ M136001 M138801 M139701 M140101 M010331 M086901 M090901 M039801 /*
//     */ M042601 M071901 M086801 M043101 M096301 M096901 M097101 M097301 /*
//     */ M099701 M099801 M100001 M100301 M100901 (1=0) (2=1) (3=0) (4=0) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M019901 (1=0) (2=1) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode M047301 M046601 (1=0) (2=0) (3=0) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M043501 (1=0) (2=0) (3=0) (4=1) (5=2) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M046001 M046901 M046801 (1=0) (2=0) (3=0) (4=0) (5=1) (99=.n) (88=.o) /*
//     */ (77=.q) (55=.r) (66=.s) (else=.)
// recode M067701 M046501 M135701 M135901 M136201 M138901 M139101 M139201 /*
//     */ M139401 M010131 M039101 M086701 M072301 M066001 M090801 M074401 /*
//     */ M095801 M096801 M099901 M100101 M100701 M101201 (1=1) (2=0) (3=0) /*
//     */ (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode M068001 M085901 M010631 M040001 M043301 M0402CL (1=0) (2=0) (3=1) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M068004 M140301 M087301 M091401 (1=0) (2=1) (3=2) (4=3) (5=4) (99=.n) /*
//     */ (88=.o) (77=.q) (55=.r) (66=.s) (else=.)
// recode M085401 (1=0) (2=1) (3=2) (4=3) (5=3) (99=.n) (88=.o) (77=.q) (55=.r) /*
//     */ (66=.s) (else=.)
// recode M136501 M137501 M138201 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M136601 (1=0) (2=1) (3=2) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M136701 M137001 M137401 M137601 M137801 (1=0) (2=0) (3=0) (4=1) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.p) ( 5=.r) ( 6=.s) (else=.)
// recode M136801 M137301 M137701 M138001 M138101 M138301 (1=0) (2=1) (3=0) /*
//     */ (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.p) ( 5=.r) ( 6=.s) (else=.)
// recode M136901 M138401 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode M137101 M137901 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.p) ( 5=.r) ( 6=.s) (else=.)
// recode M139801 (1=0) (2=1) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M0434CL (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode M039601 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode M137201 M138501 M138601 (1=1) (2=0) (3=0) (4=0) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.p) ( 5=.r) ( 6=.s) (else=.)
// recode M138701 (1=0) (2=1) (3=2) (4=3) (5=4) ( 0=.m) (99=.n) (88=.o) (77=.q) /*
//     */ (55=.r) (66=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2005
gen grade=4
gen subject=1
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT MTHCM1-MTHCM5 MRPCM1-MRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2005\naep_math_gr4_2005", replace


