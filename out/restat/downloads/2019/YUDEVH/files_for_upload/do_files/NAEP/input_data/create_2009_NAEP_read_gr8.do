version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Reading Nat'l and State GR 4&8\STATA\LABELDEF.do"
label data "  2009 National Reading Grade 8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPB0\NAEP 2009\NAEP 2009 Reading Nat'l and State GR 4&8\STATA\R40NT2AT.DCT", clear
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
label values  PARED     PARED
label values  MODAGE    MODAGE
label values  HISPYES   HISPYES
label values  DRACEM    DRACEM
label values  SDRACEM   SDRACEM
label values  SENROL8   SENROL8Q
label values  YRSEXP    YRSEXP
label values  YRSLART   YRSEXP
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
label values  Y40ORK    BLKUSE
label values  Y40ORL    BLKUSE
label values  Y40ORM    BLKUSE
label values  Y40ORN    BLKUSE
label values  Y40ORO    BLKUSE
label values  Y40ORP    BLKUSE
label values  Y40ORQ    BLKUSE
label values  Y40ORR    BLKUSE
label values  Y40ORS    BLKUSE
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
label values  Y40OFN    BLKUSE
label values  Y40OFO    BLKUSE
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
label values  R848001   YESNO
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
label values  R848303   R848303Q
label values  R848304   R848303Q
label values  R848305   R848303Q
label values  R848306   R846201Q
label values  R848307   R846201Q
label values  R848308   R848303Q
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
label values  R060701   MC5A
label values  R060702   MC5C
label values  R060703   R059606Q
label values  RB60703   R059606Q
label values  RC60703   R059606Q
label values  R060704   R059606Q
label values  RB60704   R059606Q
label values  RC60704   R059606Q
label values  R060705   MC5A
label values  R060706   RATE4A
label values  RB60706   RATE4A
label values  RC60706   RATE4A
label values  R060707   R059606Q
label values  RB60707   R059606Q
label values  RC60707   R059606Q
label values  R060708   R059606Q
label values  RB60708   R059606Q
label values  RC60708   R059606Q
label values  R060709   MC5D
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
label values  R060802   MC5D
label values  R060809   MC5A
label values  R060810   R059606Q
label values  RB60810   R059606Q
label values  RC60810   R059606Q
label values  R060811   R059606Q
label values  RB60811   R059606Q
label values  RC60811   R059606Q
label values  R061101   MC5B
label values  R061102   MC5C
label values  R063601   MC5D
label values  R061104   R059606Q
label values  RB61104   R059606Q
label values  RC61104   R059606Q
label values  R061105   MC5A
label values  R061106   RATE4A
label values  RB61106   RATE4A
label values  RC61106   RATE4A
label values  R061107   MC5C
label values  R061108   MC5D
label values  R061109   MC5C
label values  R061110   RATE2A
label values  RB61110   RATE2A
label values  RC61110   RATE2A
label values  R061111   R059606Q
label values  RB61111   R059606Q
label values  RC61111   R059606Q
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
label values  R0V0401   MC5B
label values  R0V0402   MC5C
label values  R0V0403   MC5D
label values  R0V0404   MC5A
label values  R0V0405   MC5D
label values  R0V0406   MC5C
label values  R0V0506   MC5C
label values  R0V0507   MC5B
label values  R0V0508   MC5A
label values  R0V0509   MC5B
label values  R0V0510   MC5D
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
label values  R0V0601   MC5C
label values  R0V0602   MC5D
label values  R0V0603   MC5A
label values  R0V0604   MC5D
label values  R0V0605   MC5B
label values  R0V0708   MC5B
label values  R0V0709   MC5A
label values  R0V0710   MC5C
label values  R0V0711   MC5D
label values  R0V0713   MC5C
label values  R017101   RATE2A
label values  RB17101   RATE2A
label values  RC17101   RATE2A
label values  R017102   R017102Q
label values  RB17102   R017102Q
label values  RC17102   R017102Q
label values  R017103   MC5D
label values  R017104   R017102Q
label values  RB17104   R017102Q
label values  RC17104   R017102Q
label values  R017105   RATE4A
label values  RB17105   RATE4A
label values  RC17105   RATE4A
label values  R017106   MC5A
label values  R017107   R017102Q
label values  RB17107   R017102Q
label values  RC17107   R017102Q
label values  R017108   RATE2A
label values  RB17108   RATE2A
label values  RC17108   RATE2A
label values  R017109   MC5B
label values  R017110   R017102Q
label values  RB17110   R017102Q
label values  RC17110   R017102Q
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
label values  R056101   R056101Q
label values  RB56101   R056101Q
label values  RC56101   R056101Q
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
label values  R034601   R034601Q
label values  RB34601   RB34601Q
label values  RC34601   RB34601Q
label values  R034701   MC5B
label values  R034801   MC5D
label values  R034901   R034601Q
label values  RB34901   RB34601Q
label values  RC34901   RB34601Q
label values  R035001   R034601Q
label values  RB35001   RB34601Q
label values  RC35001   RB34601Q
label values  R035101   MC5C
label values  R035201   R034601Q
label values  RB35201   RB34601Q
label values  RC35201   RB34601Q
label values  R035301   RATE4A
label values  RB35301   RATE4A
label values  RC35301   RATE4A
label values  R035401   MC5B
label values  R053401   R053401Q
label values  RB53401   RB53401Q
label values  RC53401   RB53401Q
label values  R053402   RATE2A
label values  RB53402   RATE2D
label values  RC53402   RATE2D
label values  R053403   R053403Q
label values  R053404   R053404Q
label values  R053405   RATE4A
label values  RB53405   RATE4A
label values  RC53405   RATE4A
label values  R053406   R053406Q
label values  R053407   R053407Q
label values  R053408   R053401Q
label values  RB53408   RB53401Q
label values  RC53408   RB53401Q
label values  R053409   R053404Q
label values  R053410   RATE2A
label values  RB53410   RATE2D
label values  RC53410   RATE2D
label values  R053411   R053406Q
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
label values  R053201   R053403Q
label values  R053202   RB53401Q
label values  RB53202   RB53401Q
label values  RC53202   RB53401Q
label values  R053203   RB53401Q
label values  RB53203   RB53401Q
label values  RC53203   RB53401Q
label values  R053204   R053404Q
label values  R053205   RATE4A
label values  RB53205   RATE4A
label values  RC53205   RATE4A
label values  R053206   R053403Q
label values  R053207   RB53401Q
label values  RB53207   RB53401Q
label values  RC53207   RB53401Q
label values  R053208   R053407Q
label values  R053209   RB53401Q
label values  RB53209   RB53401Q
label values  RC53209   RB53401Q
label values  R053210   R053406Q
label values  R027301   MC5B
label values  R026401   MC5C
label values  R026501   R053401Q
label values  RB26501   R017102Q
label values  RC26501   R017102Q
label values  R027101   MC5A
label values  R026601   MC5B
label values  R028201   MC5B
label values  R026801   RATE4A
label values  RB26801   RATE4A
label values  RC26801   RATE4A
label values  R027201   R053401Q
label values  RB27201   R017102Q
label values  RC27201   R017102Q
label values  R026901   MC5B
label values  R027001   RATE2A
label values  RB27001   RATE2A
label values  RC27001   RATE2A
label values  R028301   MC5A
label values  R028401   R053401Q
label values  RB28401   R017102Q
label values  RC28401   R017102Q
label values  R028501   R053401Q
label values  RB28501   R017102Q
label values  RC28501   R017102Q
label values  R029501   MC5A
label values  R029701   MC5B
label values  R028801   RATE4A
label values  RB28801   RATE4A
label values  RC28801   RATE4A
label values  R029001   MC5B
label values  R029901   MC5C
label values  R029601   R053401Q
label values  RB29601   R017102Q
label values  RC29601   R017102Q
label values  R029801   MC5B
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
label values  T077305   MAJORA
label values  T077306   MAJORA
label values  T077307   MAJORA
label values  T086802   MAJORA
label values  T077405   MAJORA
label values  T077406   MAJORA
label values  T077407   MAJORA
label values  T086902   MAJORA
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
label values  T068301   T068301Q
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
label values  T086001   FREQ4C
label values  T086002   FREQ4C
label values  T086003   FREQ4C
label values  T086004   FREQ4C
label values  T086005   FREQ4C
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
label values  T111904   R848303Q
label values  T111905   R848303Q
label values  T111906   R846201Q
label values  T111907   R846201Q
label values  T111908   R848303Q
label values  T112001   T112001Q
label values  T112101   FREQ4D
label values  T112102   FREQ4D
label values  T112103   FREQ4D
label values  T112104   FREQ4D
label values  T112105   FREQ4D
label values  T112201   T112201Q
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
//       */ R060509 - RC60509 R060703 - RC60703 R060704 - RC60704 /*
//       */ R060706 - RC60706 R060707 - RC60707 R060708 - RC60708 /*
//       */ R060803 - RC60803 R060807 - RC60807 R060808 - RC60808 /*
//       */ R060810 - RC60810 R060811 - RC60811 R061104 - RC61104 /*
//       */ R061106 - RC61106 R061110 - RC61110 R061111 - RC61111 /*
//       */ R061301 - RC61301 R061303 - RC61303 R061304 - RC61304 /*
//       */ R061307 - RC61307 R061309 - RC61309 R017101 - RC17101 /*
//       */ R017102 - RC17102 R017104 - RC17104 R017105 - RC17105 /*
//       */ R017107 - RC17107 R017108 - RC17108 R017110 - RC17110 /*
//       */ R055501 - RC55501 R055801 - RC55801 R056101 - RC56101 /*
//       */ R056301 - RC56301 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R013201 - RC13201 /*
//       */ R013203 - RC13203 R013205 - RC13205 R013207 - RC13207 /*
//       */ R013209 - RC13209 R013211 - RC13211 R013212 - RC13212 /*
//       */ R034601 - RC34601 R034901 - RC34901 R035001 - RC35001 /*
//       */ R035201 - RC35201 R035301 - RC35301 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053405 - RC53405 R053408 - RC53408 /*
//       */ R053410 - RC53410 R056501 - RC56501 R056801 - RC56801 /*
//       */ R057101 - RC57101 R057301 - RC57301 R013402 - RC13402 /*
//       */ R013403 - RC13403 R013405 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013409 - RC13409 R013411 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013003 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013007 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R053202 - RC53202 R053203 - RC53203 /*
//       */ R053205 - RC53205 R053207 - RC53207 R053209 - RC53209 /*
//       */ R026501 - RC26501 R026801 - RC26801 R027201 - RC27201 /*
//       */ R027001 - RC27001 R028401 - RC28401 R028501 - RC28501 /*
//       */ R028801 - RC28801 R029601 - RC29601,  mv( 0=.m)
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
//       */ R060509 - RC60509 R060703 - RC60703 R060704 - RC60704 /*
//       */ R060706 - RC60706 R060707 - RC60707 R060708 - RC60708 /*
//       */ R060803 - RC60803 R060807 - RC60807 R060808 - RC60808 /*
//       */ R060810 - RC60810 R060811 - RC60811 R061104 - RC61104 /*
//       */ R061106 - RC61106 R061110 - RC61110 R061111 - RC61111 /*
//       */ R061301 - RC61301 R061303 - RC61303 R061304 - RC61304 /*
//       */ R061307 - RC61307 R061309 - RC61309 R017101 - RC17101 /*
//       */ R017102 - RC17102 R017104 - RC17104 R017105 - RC17105 /*
//       */ R017107 - RC17107 R017108 - RC17108 R017110 - RC17110 /*
//       */ R055501 - RC55501 R055801 - RC55801 R056101 - RC56101 /*
//       */ R056301 - RC56301 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R013201 - RC13201 /*
//       */ R013203 - RC13203 R013205 - RC13205 R013207 - RC13207 /*
//       */ R013209 - RC13209 R013211 - RC13211 R013212 - RC13212 /*
//       */ R034601 - RC34601 R034901 - RC34901 R035001 - RC35001 /*
//       */ R035201 - RC35201 R035301 - RC35301 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053405 - RC53405 R053408 - RC53408 /*
//       */ R053410 - RC53410 R056501 - RC56501 R056801 - RC56801 /*
//       */ R057101 - RC57101 R057301 - RC57301 R013402 - RC13402 /*
//       */ R013403 - RC13403 R013405 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013409 - RC13409 R013411 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013003 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013007 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R053202 - RC53202 R053203 - RC53203 /*
//       */ R053205 - RC53205 R053207 - RC53207 R053209 - RC53209 /*
//       */ R026501 - RC26501 R026801 - RC26801 R027201 - RC27201 /*
//       */ R027001 - RC27001 R028401 - RC28401 R028501 - RC28501 /*
//       */ R028801 - RC28801 R029601 - RC29601,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode PARED B017001 B000905  B017201 B003501 B003601  XS04601 /*
//       */ XL00601 - XL02404,  mv( 8=.o)
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
//       */ R060509 - RC60509 R060703 - RC60703 R060704 - RC60704 /*
//       */ R060706 - RC60706 R060707 - RC60707 R060708 - RC60708 /*
//       */ R060803 - RC60803 R060807 - RC60807 R060808 - RC60808 /*
//       */ R060810 - RC60810 R060811 - RC60811 R061104 - RC61104 /*
//       */ R061106 - RC61106 R061110 - RC61110 R061111 - RC61111 /*
//       */ R061301 - RC61301 R061303 - RC61303 R061304 - RC61304 /*
//       */ R061307 - RC61307 R061309 - RC61309 R017101 - RC17101 /*
//       */ R017102 - RC17102 R017104 - RC17104 R017105 - RC17105 /*
//       */ R017107 - RC17107 R017108 - RC17108 R017110 - RC17110 /*
//       */ R055501 - RC55501 R055801 - RC55801 R056101 - RC56101 /*
//       */ R056301 - RC56301 R012601 - RC12601 R012604 - RC12604 /*
//       */ R012607 - RC12607 R012612 - RC12612 R013201 - RC13201 /*
//       */ R013203 - RC13203 R013205 - RC13205 R013207 - RC13207 /*
//       */ R013209 - RC13209 R013211 - RC13211 R013212 - RC13212 /*
//       */ R034601 - RC34601 R034901 - RC34901 R035001 - RC35001 /*
//       */ R035201 - RC35201 R035301 - RC35301 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC56501 R056801 - RC56801 /*
//       */ R057101 - RC57101 R057301 - RC57301 R013402 - RC13402 /*
//       */ R013403 - RC13403 R013405 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013409 - RC13409 R013411 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013003 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013007 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R053201 - RC53202 R053203 - RC53203 /*
//       */ R053204 - RC53205 R053206 - RC53207 R053208 - RC53209 R053210 /*
//       */ R026501 - RC26501 R026801 - RC26801 R027201 - RC27201 /*
//       */ R027001 - RC27001 R028401 - RC28401 R028501 - RC28501 /*
//       */ R028801 - RC28801 R029601 - RC29601,  mv( 7=.p)
// /* NON-RATEABLE RESPONSES          */
// mvdecode UTOL4 PARED HISPYES DRACEM  SENROL8 - PCTINDC LEP - SD3 IEP2009 /*
//       */ BA21101 - RC59604 R059610 - RC59610 R059606 - RC59606 /*
//       */ R059605 - RC59605 R059608 - RC59607 R059801 - RC59803 /*
//       */ R059804 - RC59806 R059807 - RC59807 R059808 - RC59809 /*
//       */ R059810 - RC60103 R060104 - RC60105 R060106 - RC60108 /*
//       */ R060109 - RC60301 R060302 - RC60305 R060303 - RC60306 /*
//       */ R060307 - RC60309 R060310 - RC58504 R058505 - RC58508 /*
//       */ R058509 - RC58509 R058510 - RC58602 R058603 - RC58606 /*
//       */ R058607 - RC58608 R058609 - RC58805 R058806 - RC58807 /*
//       */ R058808 - RC58810 R059101 - RC59109 R059106 - RC59106 /*
//       */ R059105 - RC59108 R059110 - RC59110 R060501 - RC60503 /*
//       */ R060504 - RC60505 R060507 - RC60507 R060508 - RC60508 /*
//       */ R060509 - RC60509 R060510 - RC60703 R060704 - RC60704 /*
//       */ R060705 - RC60706 R060707 - RC60707 R060708 - RC60708 /*
//       */ R060709 - RC60803 R060804 - RC60807 R060808 - RC60808 /*
//       */ R060802 - RC60810 R060811 - RC60811 R061101 - RC61104 /*
//       */ R061105 - RC61106 R061107 - RC61110 R061111 - RC61111 /*
//       */ R061301 - RC61301 R061302 - RC61303 R061304 - RC61304 /*
//       */ R061305 - RC61307 R061308 - RC61309 R0V0401 - RC17101 /*
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
//       */ R053210 - RC26501 R027101 - RC26801 R027201 - RC27201 /*
//       */ R026901 - RC27001 R028301 - RC28401 R028501 - RC28501 /*
//       */ R029501 - RC28801 R029001 - RC29601 R029801 XS03901 - XS02328 /*
//       */ XS04301 XS04401  XS00301 - XS00312 XS02701 XS04601  XL02901 X013801  /*
//       */ XL03001 - XL02016 XL03301 XL03401  XL00601 - TE21201 /*
//       */ T096401 - T112304,  mv( 7=.q)
// mvdecode UTOL12,  mv(77=.q)
// /* ILLEGIBLE RESPONSES             */
// mvdecode R059601 - RC59604 R059610 - RC59610 R059606 - RC59606 /*
//       */ R059605 - RC59605 R059608 - RC59607 R059801 - RC59803 /*
//       */ R059804 - RC59806 R059807 - RC59807 R059808 - RC59809 /*
//       */ R059810 - RC60103 R060104 - RC60105 R060106 - RC60108 /*
//       */ R060109 - RC60301 R060302 - RC60305 R060303 - RC60306 /*
//       */ R060307 - RC60309 R060310 - RC58504 R058505 - RC58508 /*
//       */ R058509 - RC58509 R058510 - RC58602 R058603 - RC58606 /*
//       */ R058607 - RC58608 R058609 - RC58805 R058806 - RC58807 /*
//       */ R058808 - RC58810 R059101 - RC59109 R059106 - RC59106 /*
//       */ R059105 - RC59108 R059110 - RC59110 R060501 - RC60503 /*
//       */ R060504 - RC60505 R060507 - RC60507 R060508 - RC60508 /*
//       */ R060509 - RC60509 R060510 - RC60703 R060704 - RC60704 /*
//       */ R060705 - RC60706 R060707 - RC60707 R060708 - RC60708 /*
//       */ R060709 - RC60803 R060804 - RC60807 R060808 - RC60808 /*
//       */ R060802 - RC60810 R060811 - RC60811 R061101 - RC61104 /*
//       */ R061105 - RC61106 R061107 - RC61110 R061111 - RC61111 /*
//       */ R061301 - RC61301 R061302 - RC61303 R061304 - RC61304 /*
//       */ R061305 - RC61307 R061308 - RC61309 R0V0401 - RC17101 /*
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
//       */ R053210 - RC26501 R027101 - RC26801 R027201 - RC27201 /*
//       */ R026901 - RC27001 R028301 - RC28401 R028501 - RC28501 /*
//       */ R029501 - RC28801 R029001 - RC29601 R029801,  mv( 5=.r)
// /* OFF-TASK RESPONSES              */
// mvdecode PARED BA21101 - R059603 R059608 R059609  R059801 R059802  /*
//       */ R059804 R059805  R059808 R059810 - R060102 R060104 R060106 R060107  /*
//       */ R060109 R060110  R060302 R060304  R060303 R060307 R060308  /*
//       */ R060310 - R058503 R058505 - R058507 R058510 R058601  /*
//       */ R058603 - R058605 R058607 R058609 - R058804 R058806 R058808 R058809  /*
//       */ R059101 - R059104 R059105 R059107  R060501 R060502  R060504 /*
//       */ R060510 - R060702 R060705 R060709 R060801  R060804 - R060806 /*
//       */ R060802 R060809  R061101 - R063601 R061105 R061107 - R061109 /*
//       */ R061302 R061305 R061306  R061308 R0V0401 - R0V0713 R017103 R017106 /*
//       */ R017109 R055601 R055701  R055901 R056001  R056201 R012602 R012603  /*
//       */ R012605 R012606  R012608 - R012610 R013202 R013204 R013206 R013208 /*
//       */ R013210 R034501 R034701 R034801  R035101 R035401 R053403 R053404  /*
//       */ R053406 R053407  R053409 R053411 R056601 R056701  R056901 R057001  /*
//       */ R057201 R057401 R013401  R013404 R013408 R013410 R013002 R013006 /*
//       */ R013012 R053201  R053204 R053206 R053208 R053210 - R026401 /*
//       */ R027101 - R028201 R026901 R028301 R029501 R029701  R029001 R029901  /*
//       */ R029801 XS03901 - XS04101 XS04301 XS04401  XS02701 XS04601  /*
//       */ XL02901 X013801  XL03001 XL03101  XL03301 XL03401  /*
//       */ XL00601 - XL02404 T096401 - T112304,  mv( 6=.s)
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
//     */ R058605 R058804 R059103 R060501 R060511 R060702 R060806 R061102 /*
//     */ R061107 R061109 R061305 R055601 R056201 R012602 R012608 R035101 /*
//     */ R056701 R057001 R013404 R013012 R026401 R029901 (1=0) (2=0) (3=1) /*
//     */ (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R059602 R059805 R060106 R060109 R060310 R058502 R058506 /*
//     */ R058510 R058601 R058609 R058802 R059101 R059107 R060504 R060709 /*
//     */ R060804 R063601 R061108 R061306 R017103 R055901 R012606 R012609 /*
//     */ R013208 R013210 R034801 R056901 R057401 R013401 R013002 (1=0) (2=0) /*
//     */ (3=0) (4=1) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R059603 R059609 R059804 R059810 R060101 R060107 R060303 R060308 /*
//     */ R058505 R058604 R058607 R058803 R058806 R058808 R059102 R060502 /*
//     */ R060805 R060802 R061101 R061308 R017109 R055701 R056001 R012603 /*
//     */ R012605 R013204 R034501 R034701 R035401 R056601 R013410 R027301 /*
//     */ R026601 R028201 R026901 R029701 R029001 R029801 (1=0) (2=1) (3=0) /*
//     */ (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R059604 R059809 R060103 R060105 R060301 R058509 R059110 R060807 /*
//     */ R061110 R061304 R017101 R017108 R012601 R012604 R012612 R013203 /*
//     */ R013205 R013207 R013209 R013211 R053402 R053410 R056501 R013402 /*
//     */ R013405 R013407 R013409 R013411 R013413 R013001 R013003 R013005 /*
//     */ R013007 R013008 R013009 R013010 R013011 R027001 (1=0) (2=1) ( 0=.m) /*
//     */ ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R059610 R059803 R060108 R058508 R058608 R058807 R059106 R060505 /*
//     */ R060706 R060808 R061106 R061307 R017105 R056101 R013201 R013212 /*
//     */ R035301 R053405 R053205 R026801 R028801 (1=0) (2=1) (3=2) (4=3) /*
//     */ ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R059606 R059605 R059607 R059806 R059807 R060305 R058504 R058602 /*
//     */ R058606 R058810 R059109 R059108 R060503 R060507 R060508 R060509 /*
//     */ R060703 R060704 R060707 R060708 R060803 R060810 R060811 R061104 /*
//     */ R061111 R061301 R061303 R061309 R017104 R017107 R055501 R055801 /*
//     */ R056301 R034601 R034901 R035001 R035201 R053401 R056801 R057101 /*
//     */ R057301 R053203 R053207 R053209 R027201 R028401 R028501 R029601 (1=0) /*
//     */ (2=1) (3=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R059802 R060102 R060110 R060304 R058503 R058507 R058603 /*
//     */ R058610 R058801 R058809 R059104 R059105 R060510 R060701 R060705 /*
//     */ R060801 R060809 R061105 R061302 R017106 R012610 R013202 R013206 /*
//     */ R057201 R013408 R013006 R027101 R028301 R029501 (1=1) (2=0) (3=0) /*
//     */ (4=0) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R060306 (1=0) (2=1) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode R060309 R017102 R017110 R053408 R053202 (1=0) (2=1) (3=1) ( 0=.m) /*
//     */ ( 9=.n) ( 7=.p) ( 7=.q) ( 5=.r) (else=.)
// recode R058805 R026501 (1=0) (2=0) (3=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode R012607 (1=0) (2=1) (3=2) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
// recode R053403 R053201 R053206 (1=0) (2=1) (3=0) (4=0) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R053404 R053409 R053204 (1=1) (2=0) (3=0) (4=0) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R053406 R053411 R053210 (1=0) (2=0) (3=1) (4=0) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R053407 R053208 (1=0) (2=0) (3=0) (4=1) ( 7=.p) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R013403 R013004 (1=0) (2=0) (3=1) (4=2) ( 0=.m) ( 9=.n) ( 7=.p) /*
//     */ ( 7=.q) ( 5=.r) (else=.)
// recode R013406 (1=0) (2=0) (3=1) (4=1) ( 0=.m) ( 9=.n) ( 7=.p) ( 7=.q) /*
//     */ ( 5=.r) (else=.)
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
// label values  R060701   SCORE
// label values  R060702   SCORE
// label values  R060703   SCORE
// label values  R060704   SCORE
// label values  R060705   SCORE
// label values  R060706   SCORE
// label values  R060707   SCORE
// label values  R060708   SCORE
// label values  R060709   SCORE
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
// label values  R061101   SCORE
// label values  R061102   SCORE
// label values  R063601   SCORE
// label values  R061104   SCORE
// label values  R061105   SCORE
// label values  R061106   SCORE
// label values  R061107   SCORE
// label values  R061108   SCORE
// label values  R061109   SCORE
// label values  R061110   SCORE
// label values  R061111   SCORE
// label values  R061301   SCORE
// label values  R061302   SCORE
// label values  R061303   SCORE
// label values  R061304   SCORE
// label values  R061305   SCORE
// label values  R061306   SCORE
// label values  R061307   SCORE
// label values  R061308   SCORE
// label values  R061309   SCORE
// label values  R017101   SCORE
// label values  R017102   SCORE
// label values  R017103   SCORE
// label values  R017104   SCORE
// label values  R017105   SCORE
// label values  R017106   SCORE
// label values  R017107   SCORE
// label values  R017108   SCORE
// label values  R017109   SCORE
// label values  R017110   SCORE
// label values  R055501   SCORE
// label values  R055601   SCORE
// label values  R055701   SCORE
// label values  R055801   SCORE
// label values  R055901   SCORE
// label values  R056001   SCORE
// label values  R056101   SCORE
// label values  R056201   SCORE
// label values  R056301   SCORE
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
// label values  R013201   SCORE
// label values  R013202   SCORE
// label values  R013203   SCORE
// label values  R013204   SCORE
// label values  R013205   SCORE
// label values  R013206   SCORE
// label values  R013207   SCORE
// label values  R013208   SCORE
// label values  R013209   SCORE
// label values  R013210   SCORE
// label values  R013211   SCORE
// label values  R013212   SCORE
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
// label values  R053401   SCORE
// label values  R053402   SCORE
// label values  R053403   SCORE
// label values  R053404   SCORE
// label values  R053405   SCORE
// label values  R053406   SCORE
// label values  R053407   SCORE
// label values  R053408   SCORE
// label values  R053409   SCORE
// label values  R053410   SCORE
// label values  R053411   SCORE
// label values  R056501   SCORE
// label values  R056601   SCORE
// label values  R056701   SCORE
// label values  R056801   SCORE
// label values  R056901   SCORE
// label values  R057001   SCORE
// label values  R057101   SCORE
// label values  R057201   SCORE
// label values  R057301   SCORE
// label values  R057401   SCORE
// label values  R013401   SCORE
// label values  R013402   SCORE
// label values  R013403   SCORE
// label values  R013404   SCORE
// label values  R013405   SCORE
// label values  R013406   SCORE
// label values  R013407   SCORE
// label values  R013408   SCORE
// label values  R013409   SCORE
// label values  R013410   SCORE
// label values  R013411   SCORE
// label values  R013413   SCORE
// label values  R013001   SCORE
// label values  R013002   SCORE
// label values  R013003   SCORE
// label values  R013004   SCORE
// label values  R013005   SCORE
// label values  R013006   SCORE
// label values  R013007   SCORE
// label values  R013008   SCORE
// label values  R013009   SCORE
// label values  R013010   SCORE
// label values  R013011   SCORE
// label values  R013012   SCORE
// label values  R053201   SCORE
// label values  R053202   SCORE
// label values  R053203   SCORE
// label values  R053204   SCORE
// label values  R053205   SCORE
// label values  R053206   SCORE
// label values  R053207   SCORE
// label values  R053208   SCORE
// label values  R053209   SCORE
// label values  R053210   SCORE
// label values  R027301   SCORE
// label values  R026401   SCORE
// label values  R026501   SCORE
// label values  R027101   SCORE
// label values  R026601   SCORE
// label values  R028201   SCORE
// label values  R026801   SCORE
// label values  R027201   SCORE
// label values  R026901   SCORE
// label values  R027001   SCORE
// label values  R028301   SCORE
// label values  R028401   SCORE
// label values  R028501   SCORE
// label values  R029501   SCORE
// label values  R029701   SCORE
// label values  R028801   SCORE
// label values  R029001   SCORE
// label values  R029901   SCORE
// label values  R029601   SCORE
// label values  R029801   SCORE

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2009
gen grade=8
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2009\naep_read_gr8_2009", replace


