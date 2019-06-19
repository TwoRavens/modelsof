version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Reading Nat'l and State GR 4&8\STATA\LABELDEF.do"
label data "  2009 National Reading Grade 4 Student & Teacher Data"
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Reading Nat'l and State GR 4&8\STATA\R40NT1AT.DCT", clear
label values  FIPS02    FIPS02Q
label values  ORIGSUB   ORIGSUB
label values  PUBPRIV   PUBPRIV
label values  BMONTH    BMONTH
label values  SEX       SEX
label values  SRACE     SRACE
label values  SLNCH05   SLNCH05Q
label values  SLUNCH1   SLUNCH1Q
label values  SD4       SD4Q
label values  ELL3      ELL3Q
label values  NEWENRL   NEWENRL
label values  ACCOMCD   ACCOMCD
label values  ACCBDR    NOYES
label values  ACCBIB    NOYES
label values  ACCBID    NOYES
label values  ACCREA    NOYES
label values  ACCBRL    NOYES
label values  ACCLRG    NOYES
label values  ACCMAG    NOYES
label values  ACCSCR    NOYES
label values  ACCSMG    NOYES
label values  ACCONE    NOYES
label values  ACCSSA    NOYES
label values  ACCEXT    NOYES
label values  ACCBRK    NOYES
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
label values  RACEFLG   MOBFLAG
label values  NSLPFLG   NSLPFLG
label values  ORIGSUP   ORIGSUP
label values  REGION    REGION
label values  REGIONS   REGION
label values  CENSREG   CENSREG
label values  CENSDIV   CENSDIV
label values  ABSSERT   ABSSERT
label values  JKUNIT    JKUNIT
label values  JKNU      PCHRAYP
label values  SCHTYPE   SCHTYPE
label values  RPTSAMP   RPTSAMP
label values  ARPTSMP   ARPTSMP
label values  UTOL12    UTOL12Q
label values  UTOL4     UTOL4Q
label values  DISTCOD   DISTCOD
label values  TUAFLG3   TUAFLG3Q
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SDRACEM   SDRACEM
label values  SENROL4   SENROL4Q
label values  YRSEXP    YRSEXP
label values  PCTBLKC   PCTBLKC
label values  PCTHSPC   PCTBLKC
label values  PCTASNC   PCTBLKC
label values  PCTINDC   PCTBLKC
label values  SCHTYP2   TYPCLAS
label values  LRGCITY   YESNO
label values  CHRTRPT   CHRTRPT
label values  FIPS      FIPS02Q
label values  SAMPTYP   SAMPTYP
label values  LEP       LEP
label values  IEP       IEP
label values  SD3       SD3Q
label values  SDELL     SDELL
label values  SLUNCH    SLUNCH
label values  ACCOM2    ACCOM2Q
label values  Y40ORA    BLKUSE
label values  Y40ORB    BLKUSE
label values  Y40ORC    BLKUSE
label values  Y40ORD    BLKUSE
label values  Y40ORE    BLKUSE
label values  Y40ORF    BLKUSE
label values  Y40ORG    BLKUSE
label values  Y40ORH    BLKUSE
label values  Y40ORI    BLKUSE
label values  Y40ORJ    BLKUSE
label values  Y40ORN    BLKUSE
label values  Y40ORO    BLKUSE
label values  Y40ORP    BLKUSE
label values  Y40ORQ    BLKUSE
label values  Y40OFC    BLKUSE
label values  Y40OFD    BLKUSE
label values  Y40OFE    BLKUSE
label values  Y40OFF    BLKUSE
label values  Y40OFG    BLKUSE
label values  Y40OFH    BLKUSE
label values  Y40OFI    BLKUSE
label values  Y40OFJ    BLKUSE
label values  Y40OFK    BLKUSE
label values  Y40OFL    BLKUSE
label values  IEP2009   YESNO
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
label values  R846501   YESNO
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
label values  R832901   R831001Q
label values  R847201   R846001Q
label values  R847301   R846001Q
label values  R847401   R846001Q
label values  R832801   R832801Q
label values  R847501   YESNO
label values  R847601   YESNO
label values  R847701   YESNO
label values  R847801   YESNO
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
label values  R057803   MC5E
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
label values  R058001   MC5C
label values  R058002   MC5B
label values  R058003   R057705Q
label values  RB58003   R057705Q
label values  RC58003   R057705Q
label values  R058004   R057705Q
label values  RB58004   R057705Q
label values  RC58004   R057705Q
label values  R058005   MC5D
label values  R058006   RATE4A
label values  RB58006   RATE4A
label values  RC58006   RATE4A
label values  R058007   RATE2A
label values  RB58007   RATE2A
label values  RC58007   RATE2A
label values  R058008   R057705Q
label values  RB58008   R057705Q
label values  RC58008   R057705Q
label values  R058009   MC5A
label values  R058010   MC5D
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
label values  R058505   MC5C
label values  R058506   MC5D
label values  R058507   MC5B
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
label values  R059401   MC5A
label values  R059403   R057705Q
label values  RB59403   R057705Q
label values  RC59403   R057705Q
label values  R059404   MC5C
label values  R059405   MC5D
label values  R059406   RATE4A
label values  RB59406   RATE4A
label values  RC59406   RATE4A
label values  R059407   R057705Q
label values  RB59407   R057705Q
label values  RC59407   R057705Q
label values  R059408   MC5B
label values  R059409   RATE2A
label values  RB59409   R057705Q
label values  RC59409   R057705Q
label values  R059410   MC5C
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
label values  R0V0001   MC5A
label values  R0V0002   MC5C
label values  R0V0003   MC5C
label values  R0V0004   MC5A
label values  R0V0005   MC5B
label values  R0V0101   MC5B
label values  R0V0102   MC5A
label values  R0V0103   MC5D
label values  R0V0104   MC5C
label values  R0V0105   MC5B
label values  R0V0206   MC5C
label values  R0V0207   MC5B
label values  R0V0208   MC5B
label values  R0V0209   MC5C
label values  R0V0210   MC5A
label values  R0V0306   MC5C
label values  R0V0307   MC5D
label values  R0V0308   MC5B
label values  R0V0309   MC5A
label values  R0V0310   MC5D
label values  R053601   MC5B
label values  R053701   MC5C
label values  R053801   MC5D
label values  R053901   R053901Q
label values  RB53901   RATE3B
label values  RC53901   RATE3B
label values  R054001   R053901Q
label values  RB54001   RATE3B
label values  RC54001   RATE3B
label values  R054101   MC5C
label values  R054201   RATE4A
label values  RB54201   RB54201Q
label values  RC54201   RB54201Q
label values  R054301   R053901Q
label values  RB54301   RATE3B
label values  RC54301   RATE3B
label values  R054401   MC5A
label values  R054501   MC5B
label values  R052901   R052901Q
label values  R052902   R052902Q
label values  R052903   R052902Q
label values  R052904   R052904Q
label values  RB52904   R052904Q
label values  RC52904   R052904Q
label values  R052905   R052901Q
label values  R052906   RATE2D
label values  RB52906   RATE2D
label values  RC52906   RATE2D
label values  R052907   RATE4A
label values  RB52907   RATE4A
label values  RC52907   RATE4A
label values  R052908   R052901Q
label values  R052909   RATE2D
label values  RB52909   RATE2D
label values  RC52909   RATE2D
label values  R052910   R052901Q
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
label values  R017303   R017303Q
label values  RB17303   R017303Q
label values  RC17303   R017303Q
label values  R017304   MC5A
label values  R017310   R017310Q
label values  RB17310   R017303Q
label values  RC17310   R017303Q
label values  R017306   MC5B
label values  R017307   RATE4A
label values  RB17307   RATE4A
label values  RC17307   RATE4A
label values  R017308   MC5C
label values  R017309   R017303Q
label values  RB17309   R017303Q
label values  RC17309   R017303Q
label values  R034501   MC5B
label values  R034601   R017310Q
label values  RB34601   RB34601Q
label values  RC34601   RB34601Q
label values  R034701   MC5B
label values  R034801   MC5D
label values  R034901   R017310Q
label values  RB34901   RB34601Q
label values  RC34901   RB34601Q
label values  R035001   R017310Q
label values  RB35001   RB34601Q
label values  RC35001   RB34601Q
label values  R035101   MC5C
label values  R035201   R017310Q
label values  RB35201   RB34601Q
label values  RC35201   RB34601Q
label values  R035301   RATE4A
label values  RB35301   RATE4A
label values  RC35301   RATE4A
label values  R035401   MC5B
label values  R054601   MC5B
label values  R054701   MC5C
label values  R054801   RATE3B
label values  RB54801   RATE3B
label values  RC54801   RATE3B
label values  R054901   MC5D
label values  R055001   MC5A
label values  R057501   MC5B
label values  R055101   RB54201Q
label values  RB55101   RB54201Q
label values  RC55101   RB54201Q
label values  R055201   MC5A
label values  R055301   RATE3B
label values  RB55301   RATE3B
label values  RC55301   RATE3B
label values  R055401   RATE3B
label values  RB55401   RATE3B
label values  RC55401   RATE3B
label values  R053001   R052901Q
label values  R053002   R052901Q
label values  R053003   RATE2D
label values  RB53003   RATE2D
label values  RC53003   RATE2D
label values  R053004   R052904Q
label values  RB53004   R052904Q
label values  RC53004   R052904Q
label values  R053005   R052902Q
label values  R053006   RATE4A
label values  RB53006   RATE4A
label values  RC53006   RATE4A
label values  R053007   R052902Q
label values  R053008   R052902Q
label values  R053009   RATE2D
label values  RB53009   RATE2D
label values  RC53009   RATE2D
label values  R053010   R052904Q
label values  RB53010   R052904Q
label values  RC53010   R052904Q
label values  R053101   RATE2A
label values  RB53101   RATE2D
label values  RC53101   RATE2D
label values  R053102   R053102Q
label values  R053103   R052901Q
label values  R053104   R053102Q
label values  R053105   R053901Q
label values  RB53105   R052904Q
label values  RC53105   R052904Q
label values  R053106   RATE4A
label values  RB53106   RATE4A
label values  RC53106   RATE4A
label values  R053107   R052902Q
label values  R053108   R053901Q
label values  RB53108   R052904Q
label values  RC53108   R052904Q
label values  R053109   R052901Q
label values  R053110   R052902Q
label values  R021601   MC5A
label values  R020401   R053901Q
label values  RB20401   R017303Q
label values  RC20401   R017303Q
label values  R020601   MC5C
label values  R021101   MC5A
label values  R020701   RATE2A
label values  RB20701   RB20701Q
label values  RC20701   RB20701Q
label values  R020501   MC5B
label values  R022101   MC5C
label values  R021701   R053901Q
label values  RB21701   R017303Q
label values  RC21701   R017303Q
label values  R022201   MC5B
label values  R021201   R053901Q
label values  RB21201   R017303Q
label values  RC21201   R017303Q
label values  R023301   MC5D
label values  R022401   MC5B
label values  R023501   R053901Q
label values  RB23501   R017303Q
label values  RC23501   R017303Q
label values  R023601   R053901Q
label values  RB23601   R017303Q
label values  RC23601   R017303Q
label values  R023801   MC5A
label values  R022901   MC5B
label values  R024001   R053901Q
label values  RB24001   R017303Q
label values  RC24001   R017303Q
label values  R023101   MC5C
label values  R024101   MC5B
label values  R023201   RATE2A
label values  RB23201   RATE2A
label values  RC23201   RATE2A
label values  XS03901   XS03901Q
label values  XS04001   XS04001Q
label values  XS04101   XS04101Q
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
label values  XS04301   XS04301Q
label values  XS04401   YESNO
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
label values  XS02701   XS02701Q
label values  XS04601   XS04601Q
label values  XL02901   XL02901Q
label values  X013801   X013801Q
label values  XL03001   XS04001Q
label values  XL03101   XL03101Q
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
label values  XL03301   XS04301Q
label values  XL03401   YESNO
label values  XL00601   XL00601Q
label values  XL03601   XS04601Q
label values  XL02401   XL02401Q
label values  XL02402   XL02401Q
label values  XL02403   XL02401Q
label values  XL02404   XL02401Q
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
label values  T087301   MAJORA
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T087302   MAJORA
label values  T087303   MAJORA
label values  T087304   MAJORA
label values  T096801   MAJORA
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
label values  T096901   MAJORA
label values  T087404   MAJORA
label values  T087405   MAJORA
label values  T077412   MAJORA
label values  T097001   T097001Q
label values  T097101   T097001Q
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
label values  T097301   FREQ4D
label values  T097302   FREQ4D
label values  T097303   FREQ4D
label values  T097304   FREQ4D
label values  T097305   FREQ4D
label values  T097306   FREQ4D
label values  T097307   FREQ4D
label values  T097308   FREQ4D
label values  T097309   FREQ4D
label values  T097310   FREQ4D
label values  T097311   FREQ4D
label values  T087801   NOYES
label values  T087802   NOYES
label values  T087803   NOYES
label values  T087804   NOYES
label values  T087805   NOYES
label values  T087806   NOYES
label values  T087807   NOYES
label values  T087808   NOYES
label values  T087809   NOYES
label values  T087810   NOYES
label values  T087811   NOYES
label values  T087812   NOYES
label values  T087813   NOYES
label values  T087814   NOYES
label values  T087815   NOYES
label values  T087816   NOYES
label values  T087817   NOYES
label values  T087818   NOYES
label values  T087819   NOYES
label values  T087820   NOYES
label values  T087821   NOYES
label values  T087822   NOYES
label values  T087823   NOYES
label values  T087824   NOYES
label values  T087825   NOYES
label values  T087826   NOYES
label values  T087827   NOYES
label values  T087828   NOYES
label values  T087829   NOYES
label values  T087830   NOYES
label values  T087831   NOYES
label values  T087832   NOYES
label values  T087833   NOYES
label values  T087834   NOYES
label values  T087835   NOYES
label values  T087836   NOYES
label values  T087837   NOYES
label values  T087838   NOYES
label values  T087839   NOYES
label values  T087840   NOYES
label values  T087841   NOYES
label values  T087842   NOYES
label values  T087843   NOYES
label values  T087844   NOYES
label values  T087845   NOYES
label values  T087846   NOYES
label values  T087847   NOYES
label values  T087848   NOYES
label values  T097401   YESNO
label values  T097501   T097501Q
label values  T097502   T097501Q
label values  T097503   T097501Q
label values  T097504   T097501Q
label values  T097505   T097501Q
label values  T088201   YESNO
label values  T088202   YESNO
label values  T097601   YESNO
label values  T097701   YESNO
label values  T105501   T105501Q
label values  T092401   T092401Q
label values  T089801   T089801Q
label values  T083401   T083401Q
label values  T068301   T068301Q
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
label values  T083701   FREQ4C
label values  T083702   FREQ4C
label values  T083703   FREQ4C
label values  T083704   FREQ4C
label values  T083705   FREQ4C
label values  T089901   FREQ4A
label values  T089903   FREQ4A
label values  T089906   FREQ4A
label values  T089907   FREQ4A
label values  T089909   FREQ4A
label values  T105801   FREQ4A
label values  T089913   FREQ4A
label values  T100101   FREQ4D
label values  T100102   FREQ4D
label values  T100103   FREQ4D
label values  T105901   T105901Q
label values  T106001   R846201Q
label values  T106002   R846201Q
label values  T106003   R846201Q
label values  T106004   T106004Q
label values  T106005   T106004Q
label values  T106006   R846201Q
label values  T106007   R846201Q
label values  T106008   T106004Q
label values  T106101   T106101Q
label values  T106201   FREQ4D
label values  T106202   FREQ4D
label values  T106203   FREQ4D
label values  T106204   FREQ4D
label values  T106205   FREQ4D
label values  T106301   T106301Q
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
//       */ R057807 - RC57807 R057809 - RC57809 R058003 - RC58003 /*
//       */ R058004 - RC58004 R058006 - RC58006 R058007 - RC58007 /*
//       */ R058008 - RC58008 R058207 - RC58207 R058204 - RC58204 /*
//       */ R058206 - RC58206 R058209 - RC58209 R058504 - RC58504 /*
//       */ R058508 - RC58508 R058509 - RC58509 R058602 - RC58602 /*
//       */ R058606 - RC58606 R058608 - RC58608 R058805 - RC58805 /*
//       */ R058807 - RC58807 R058810 - RC58810 R059109 - RC59109 /*
//       */ R059106 - RC59106 R059108 - RC59108 R059110 - RC59110 /*
//       */ R059403 - RC59403 R059406 - RC59406 R059407 - RC59407 /*
//       */ R059409 - RC59409 R059504 - RC59504 R059507 - RC59507 /*
//       */ R059509 - RC59509 R059510 - RC59510 R053901 - RC53901 /*
//       */ R054001 - RC54001 R054201 - RC54201 R054301 - RC54301 /*
//       */ R052904 - RC52904 R052906 - RC52906 R052907 - RC52907 /*
//       */ R052909 - RC52909 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R034601 - RC34601 R034901 - RC34901 /*
//       */ R035001 - RC35001 R035201 - RC35201 R035301 - RC35301 /*
//       */ R054801 - RC54801 R055101 - RC55101 R055301 - RC55301 /*
//       */ R055401 - RC55401 R053003 - RC53003 R053004 - RC53004 /*
//       */ R053006 - RC53006 R053009 - RC53009 R053010 - RC53010 /*
//       */ R053101 - RC53101 R053105 - RC53105 R053106 - RC53106 /*
//       */ R053108 - RC53108 R020401 - RC20401 R020701 - RC20701 /*
//       */ R021701 - RC21701 R021201 - RC21201 R023501 - RC23501 /*
//       */ R023601 - RC23601 R024001 - RC24001 R023201 - RC23201,  mv( 0=.m)
// /* NOT REACHED OR NOT ADMINISTERED */
// mvdecode R057704 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057710 - RC57710 R057806 - RC57806 /*
//       */ R057807 - RC57807 R057809 - RC57809 R058003 - RC58003 /*
//       */ R058004 - RC58004 R058006 - RC58006 R058007 - RC58007 /*
//       */ R058008 - RC58008 R058207 - RC58207 R058204 - RC58204 /*
//       */ R058206 - RC58206 R058209 - RC58209 R058504 - RC58504 /*
//       */ R058508 - RC58508 R058509 - RC58509 R058602 - RC58602 /*
//       */ R058606 - RC58606 R058608 - RC58608 R058805 - RC58805 /*
//       */ R058807 - RC58807 R058810 - RC58810 R059109 - RC59109 /*
//       */ R059106 - RC59106 R059108 - RC59108 R059110 - RC59110 /*
//       */ R059403 - RC59403 R059406 - RC59406 R059407 - RC59407 /*
//       */ R059409 - RC59409 R059504 - RC59504 R059507 - RC59507 /*
//       */ R059509 - RC59509 R059510 - RC59510 R053901 - RC53901 /*
//       */ R054001 - RC54001 R054201 - RC54201 R054301 - RC54301 /*
//       */ R052904 - RC52904 R052906 - RC52906 R052907 - RC52907 /*
//       */ R052909 - RC52909 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R034601 - RC34601 R034901 - RC34901 /*
//       */ R035001 - RC35001 R035201 - RC35201 R035301 - RC35301 /*
//       */ R054801 - RC54801 R055101 - RC55101 R055301 - RC55301 /*
//       */ R055401 - RC55401 R053003 - RC53003 R053004 - RC53004 /*
//       */ R053006 - RC53006 R053009 - RC53009 R053010 - RC53010 /*
//       */ R053101 - RC53101 R053105 - RC53105 R053106 - RC53106 /*
//       */ R053108 - RC53108 R020401 - RC20401 R020701 - RC20701 /*
//       */ R021701 - RC21701 R021201 - RC21201 R023501 - RC23501 /*
//       */ R023601 - RC23601 R024001 - RC24001 R023201 - RC23201,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode B017001 B000905  B017201 XS04601 XL00601 - XL02404,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode R057704 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057710 - RC57710 R057806 - RC57806 /*
//       */ R057807 - RC57807 R057809 - RC57809 R058003 - RC58003 /*
//       */ R058004 - RC58004 R058006 - RC58006 R058007 - RC58007 /*
//       */ R058008 - RC58008 R058207 - RC58207 R058204 - RC58204 /*
//       */ R058206 - RC58206 R058209 - RC58209 R058504 - RC58504 /*
//       */ R058508 - RC58508 R058509 - RC58509 R058602 - RC58602 /*
//       */ R058606 - RC58606 R058608 - RC58608 R058805 - RC58805 /*
//       */ R058807 - RC58807 R058810 - RC58810 R059109 - RC59109 /*
//       */ R059106 - RC59106 R059108 - RC59108 R059110 - RC59110 /*
//       */ R059403 - RC59403 R059406 - RC59406 R059407 - RC59407 /*
//       */ R059409 - RC59409 R059504 - RC59504 R059507 - RC59507 /*
//       */ R059509 - RC59509 R059510 - RC59510 R053901 - RC53901 /*
//       */ R054001 - RC54001 R054201 - RC54201 R054301 - RC54301 /*
//       */ R052901 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R017301 - RC17301 /*
//       */ R017303 - RC17303 R017310 - RC17310 R017307 - RC17307 /*
//       */ R017309 - RC17309 R034601 - RC34601 R034901 - RC34901 /*
//       */ R035001 - RC35001 R035201 - RC35201 R035301 - RC35301 /*
//       */ R054801 - RC54801 R055101 - RC55101 R055301 - RC55301 /*
//       */ R055401 - RC55401 R053001 - RC53003 R053004 - RC53004 /*
//       */ R053005 - RC53006 R053007 - RC53009 R053010 - RC53010 /*
//       */ R053101 - RC53101 R053102 - RC53105 R053106 - RC53106 /*
//       */ R053107 - RC53108 R053109 R053110  R020401 - RC20401 /*
//       */ R020701 - RC20701 R021701 - RC21701 R021201 - RC21201 /*
//       */ R023501 - RC23501 R023601 - RC23601 R024001 - RC24001 /*
//       */ R023201 - RC23201,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode SD4 ELL3  UTOL4 HISPYES DRACEM  SENROL4 - PCTINDC LEP - SD3 IEP2009 /*
//       */ BA21101 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057708 - RC57710 R057711 - RC57806 /*
//       */ R057807 - RC57807 R057808 - RC57809 R058001 - RC58003 /*
//       */ R058004 - RC58004 R058005 - RC58006 R058007 - RC58007 /*
//       */ R058008 - RC58008 R058009 - RC58207 R058203 - RC58204 /*
//       */ R058205 - RC58206 R058208 - RC58209 R058210 - RC58504 /*
//       */ R058505 - RC58508 R058509 - RC58509 R058510 - RC58602 /*
//       */ R058603 - RC58606 R058607 - RC58608 R058609 - RC58805 /*
//       */ R058806 - RC58807 R058808 - RC58810 R059101 - RC59109 /*
//       */ R059106 - RC59106 R059105 - RC59108 R059110 - RC59110 /*
//       */ R059401 - RC59403 R059404 - RC59406 R059407 - RC59407 /*
//       */ R059408 - RC59409 R059410 - RC59504 R059506 - RC59507 /*
//       */ R059505 - RC59509 R059508 - RC59510 R0V0001 - RC53901 /*
//       */ R054001 - RC54001 R054101 - RC54201 R054301 - RC54301 /*
//       */ R054401 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R017301 - RC17301 /*
//       */ R017302 - RC17303 R017304 - RC17310 R017306 - RC17307 /*
//       */ R017308 - RC17309 R034501 - RC34601 R034701 - RC34901 /*
//       */ R035001 - RC35001 R035101 - RC35201 R035301 - RC35301 /*
//       */ R035401 - RC54801 R054901 - RC55101 R055201 - RC55301 /*
//       */ R055401 - RC55401 R053001 - RC53003 R053004 - RC53004 /*
//       */ R053005 - RC53006 R053007 - RC53009 R053010 - RC53010 /*
//       */ R053101 - RC53101 R053102 - RC53105 R053106 - RC53106 /*
//       */ R053107 - RC53108 R053109 - RC20401 R020601 - RC20701 /*
//       */ R020501 - RC21701 R022201 - RC21201 R023301 - RC23501 /*
//       */ R023601 - RC23601 R023801 - RC24001 R023101 - RC23201 /*
//       */ XS03901 - XS02328 XS04301 XS04401  XS00301 - XS00312 /*
//       */ XS02701 XS04601  XL02901 X013801  XL03001 - XL02016 XL03301 XL03401  /*
//       */ XL00601 - TE21201 T096401 - T106404,  mv( 7=.q)
// mvdecode UTOL12,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R057701 - RC57704 R057705 - RC57705 R057706 - RC57706 /*
//       */ R057707 - RC57707 R057708 - RC57710 R057711 - RC57806 /*
//       */ R057807 - RC57807 R057808 - RC57809 R058001 - RC58003 /*
//       */ R058004 - RC58004 R058005 - RC58006 R058007 - RC58007 /*
//       */ R058008 - RC58008 R058009 - RC58207 R058203 - RC58204 /*
//       */ R058205 - RC58206 R058208 - RC58209 R058210 - RC58504 /*
//       */ R058505 - RC58508 R058509 - RC58509 R058510 - RC58602 /*
//       */ R058603 - RC58606 R058607 - RC58608 R058609 - RC58805 /*
//       */ R058806 - RC58807 R058808 - RC58810 R059101 - RC59109 /*
//       */ R059106 - RC59106 R059105 - RC59108 R059110 - RC59110 /*
//       */ R059401 - RC59403 R059404 - RC59406 R059407 - RC59407 /*
//       */ R059408 - RC59409 R059410 - RC59504 R059506 - RC59507 /*
//       */ R059505 - RC59509 R059508 - RC59510 R0V0001 - RC53901 /*
//       */ R054001 - RC54001 R054101 - RC54201 R054301 - RC54301 /*
//       */ R054401 - RC52904 R052905 - RC52906 R052907 - RC52907 /*
//       */ R052908 - RC52909 R052910 - RC12601 R012602 - RC12604 /*
//       */ R012605 - RC12607 R012608 - RC12612 R017301 - RC17301 /*
//       */ R017302 - RC17303 R017304 - RC17310 R017306 - RC17307 /*
//       */ R017308 - RC17309 R034501 - RC34601 R034701 - RC34901 /*
//       */ R035001 - RC35001 R035101 - RC35201 R035301 - RC35301 /*
//       */ R035401 - RC54801 R054901 - RC55101 R055201 - RC55301 /*
//       */ R055401 - RC55401 R053001 - RC53003 R053004 - RC53004 /*
//       */ R053005 - RC53006 R053007 - RC53009 R053010 - RC53010 /*
//       */ R053101 - RC53101 R053102 - RC53105 R053106 - RC53106 /*
//       */ R053107 - RC53108 R053109 - RC20401 R020601 - RC20701 /*
//       */ R020501 - RC21701 R022201 - RC21201 R023301 - RC23501 /*
//       */ R023601 - RC23601 R023801 - RC24001 R023101 - RC23201,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode BA21101 - R057703 R057708 R057709  R057711 - R057805 R057808 /*
//       */ R058001 R058002  R058005 R058009 - R058202 R058203 R058205 R058208 /*
//       */ R058210 - R058503 R058505 - R058507 R058510 R058601  /*
//       */ R058603 - R058605 R058607 R058609 - R058804 R058806 R058808 R058809  /*
//       */ R059101 - R059104 R059105 R059107  R059401 R059404 R059405  R059408 /*
//       */ R059410 - R059503 R059506 R059505 R059508 R0V0001 - R053801 R054101 /*
//       */ R054401 - R052903 R052905 R052908 R052910 R012602 R012603  /*
//       */ R012605 R012606  R012608 - R012610 R017302 R017304 R017306 R017308 /*
//       */ R034501 R034701 R034801  R035101 R035401 - R054701 /*
//       */ R054901 - R057501 R055201 R053001 R053002  R053005 R053007 R053008  /*
//       */ R053102 - R053104 R053107 R053109 - R021601 R020601 R021101  /*
//       */ R020501 R022101  R022201 R023301 R022401  R023801 R022901  /*
//       */ R023101 R024101  XS03901 - XS04101 XS04301 XS04401  XS02701 XS04601  /*
//       */ XL02901 X013801  XL03001 XL03101  XL03301 XL03401  /*
//       */ XL00601 - XL02404 T096401 - T097311 T097401 - T106404,  mv( 6=.s)
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
// recode R057701 R057711 R057808 R058001 R058201 R058205 R058208 R058501 /*
//     */ R058605 R058804 R059103 R059404 R059410 R059505 R053701 R054101 /*
//     */ R012602 R012608 R017308 R035101 R054701 R020601 R022101 R023101 (1=0) /*
//     */ (2=0) (3=1) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R057702 R057708 R057801 R057802 R058005 R058010 R058202 R058502 /*
//     */ R058506 R058510 R058601 R058609 R058802 R059101 R059107 R059405 /*
//     */ R059501 R053801 R012606 R012609 R034801 R054901 R023301 (1=0) (2=0) /*
//     */ (3=0) (4=1) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R057703 R057805 R058009 R058203 R058503 R058507 R058603 /*
//     */ R058610 R058801 R058809 R059104 R059105 R059401 R059503 R059506 /*
//     */ R054401 R012610 R017304 R055001 R055201 R021601 R021101 R023801 (1=1) /*
//     */ (2=0) (3=0) (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R057704 R057807 R058007 R058209 R058509 R059110 R059409 R052906 /*
//     */ R052909 R012601 R012604 R012612 R017301 R053003 R053009 R053101 /*
//     */ R020701 R023201 (1=0) (2=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ (else=.)
// recode R057705 R057706 R057710 R057809 R058003 R058004 R058008 R058207 /*
//     */ R058204 R058504 R058602 R058606 R058805 R058810 R059109 R059108 /*
//     */ R059403 R059407 R059504 R059509 R059510 R053901 R054001 R054301 /*
//     */ R052904 R017303 R017310 R034601 R034901 R035001 R054801 R055301 /*
//     */ R055401 R053004 R053105 R053108 R021701 R021201 R023501 R024001 (1=0) /*
//     */ (2=1) (3=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R057707 R057806 R058006 R058206 R058508 R058608 R058807 R059106 /*
//     */ R059406 R059507 R054201 R052907 R012607 R017307 R035301 R055101 /*
//     */ R053006 R053106 (1=0) (2=1) (3=2) (4=3) ( 0=.m) ( 9=.n) ( 7=.p) /*
//     */ ( 7=.q) ( 5=.r) (else=.)
// recode R057709 R057804 R058002 R058210 R058505 R058604 R058607 R058803 /*
//     */ R058806 R058808 R059102 R059408 R059502 R059508 R053601 R054501 /*
//     */ R012603 R012605 R017302 R017306 R034501 R034701 R035401 R054601 /*
//     */ R057501 R020501 R022201 R022401 R022901 R024101 (1=0) (2=1) (3=0) /*
//     */ (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R052901 R052905 R052908 R052910 R053001 R053002 R053103 R053109 (1=0) /*
//     */ (2=1) (3=0) (4=0) ( 7=.p) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R052902 R052903 R053005 R053007 R053008 R053107 R053110 (1=0) (2=0) /*
//     */ (3=1) (4=0) ( 7=.p) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017309 R053010 R020401 R023601 (1=0) (2=1) (3=1) ( 0=.m) ( 9=.n) /*
//     */ ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R035201 (1=0) (2=0) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ (else=.)
// recode R053102 R053104 (1=1) (2=0) (3=0) (4=0) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
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
// label values  R058001   SCORE
// label values  R058002   SCORE
// label values  R058003   SCORE
// label values  R058004   SCORE
// label values  R058005   SCORE
// label values  R058006   SCORE
// label values  R058007   SCORE
// label values  R058008   SCORE
// label values  R058009   SCORE
// label values  R058010   SCORE
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
// label values  R059401   SCORE
// label values  R059403   SCORE
// label values  R059404   SCORE
// label values  R059405   SCORE
// label values  R059406   SCORE
// label values  R059407   SCORE
// label values  R059408   SCORE
// label values  R059409   SCORE
// label values  R059410   SCORE
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
// label values  R053601   SCORE
// label values  R053701   SCORE
// label values  R053801   SCORE
// label values  R053901   SCORE
// label values  R054001   SCORE
// label values  R054101   SCORE
// label values  R054201   SCORE
// label values  R054301   SCORE
// label values  R054401   SCORE
// label values  R054501   SCORE
// label values  R052901   SCORE
// label values  R052902   SCORE
// label values  R052903   SCORE
// label values  R052904   SCORE
// label values  R052905   SCORE
// label values  R052906   SCORE
// label values  R052907   SCORE
// label values  R052908   SCORE
// label values  R052909   SCORE
// label values  R052910   SCORE
// label values  R012601   SCORE
// label values  R012602   SCORE
// label values  R012603   SCORE
// label values  R012604   SCORE
// label values  R012605   SCORE
// label values  R012606   SCORE
// label values  R012607   SCORE
// label values  R012608   SCORE
// label values  R012609   SCORE
// label values  R012610   SCORE
// label values  R012612   SCORE
// label values  R017301   SCORE
// label values  R017302   SCORE
// label values  R017303   SCORE
// label values  R017304   SCORE
// label values  R017310   SCORE
// label values  R017306   SCORE
// label values  R017307   SCORE
// label values  R017308   SCORE
// label values  R017309   SCORE
// label values  R034501   SCORE
// label values  R034601   SCORE
// label values  R034701   SCORE
// label values  R034801   SCORE
// label values  R034901   SCORE
// label values  R035001   SCORE
// label values  R035101   SCORE
// label values  R035201   SCORE
// label values  R035301   SCORE
// label values  R035401   SCORE
// label values  R054601   SCORE
// label values  R054701   SCORE
// label values  R054801   SCORE
// label values  R054901   SCORE
// label values  R055001   SCORE
// label values  R057501   SCORE
// label values  R055101   SCORE
// label values  R055201   SCORE
// label values  R055301   SCORE
// label values  R055401   SCORE
// label values  R053001   SCORE
// label values  R053002   SCORE
// label values  R053003   SCORE
// label values  R053004   SCORE
// label values  R053005   SCORE
// label values  R053006   SCORE
// label values  R053007   SCORE
// label values  R053008   SCORE
// label values  R053009   SCORE
// label values  R053010   SCORE
// label values  R053101   SCORE
// label values  R053102   SCORE
// label values  R053103   SCORE
// label values  R053104   SCORE
// label values  R053105   SCORE
// label values  R053106   SCORE
// label values  R053107   SCORE
// label values  R053108   SCORE
// label values  R053109   SCORE
// label values  R053110   SCORE
// label values  R021601   SCORE
// label values  R020401   SCORE
// label values  R020601   SCORE
// label values  R021101   SCORE
// label values  R020701   SCORE
// label values  R020501   SCORE
// label values  R022101   SCORE
// label values  R021701   SCORE
// label values  R022201   SCORE
// label values  R021201   SCORE
// label values  R023301   SCORE
// label values  R022401   SCORE
// label values  R023501   SCORE
// label values  R023601   SCORE
// label values  R023801   SCORE
// label values  R022901   SCORE
// label values  R024001   SCORE
// label values  R023101   SCORE
// label values  R024101   SCORE
// label values  R023201   SCORE

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2009
gen grade=4
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2009\naep_read_gr4_2009", replace


