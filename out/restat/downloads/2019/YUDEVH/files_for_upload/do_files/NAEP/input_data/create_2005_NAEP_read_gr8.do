version 8
clear
set memory 670m
set more off
do "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Reading G8\stata\LABELDEF.do"
label data "  2005 National Reading Assessment: Grade  8 Student & Teacher Data"
*NOTE: In infile statement, replace D: with appropriate drive letter.
infile using "C:\Users\Hyman\Desktop\NAEP\raw_data\PGPA6\NAEP 2005\NAEP 2005 Reading G8\stata\R36NT2AT.DCT", clear
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
label values  SENROL8   SENROL8V
label values  YRSEXP    YRSEXP
label values  YRSLART   YRSEXP
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
label values  Y36ORM    BLKUSE
label values  Y36ORN    BLKUSE
label values  Y36ORO    BLKUSE
label values  PARED     PARED
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
label values  B003501   B003501V
label values  B003601   B003501V
label values  B018201   B018201V
label values  R833001   AGREE4A
label values  R833101   AGREE4A
label values  R833401   R833401V
label values  R833501   R833401V
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
label values  RB17102   RATE3D
label values  RC17102   RATE3D
label values  R017103   MC5D
label values  R017104   R017102V
label values  RB17104   RATE3D
label values  RC17104   RATE3D
label values  R017105   RATE4A
label values  RB17105   RATE4A
label values  RC17105   RATE4A
label values  R017106   MC5A
label values  R017107   R017102V
label values  RB17107   RATE3D
label values  RC17107   RATE3D
label values  R017108   RATE2A
label values  RB17108   RATE2A
label values  RC17108   RATE2A
label values  R017109   MC5B
label values  R017110   R017102V
label values  RB17110   RATE3D
label values  RC17110   RATE3D
label values  R018401   R017102V
label values  RB18401   RATE3D
label values  RC18401   RATE3D
label values  R018501   MC5A
label values  R018601   R017102V
label values  RB18601   RATE3D
label values  RC18601   RATE3D
label values  R018701   R017102V
label values  RB18701   RATE3D
label values  RC18701   RATE3D
label values  R018801   R017102V
label values  RB18801   RATE3D
label values  RC18801   RATE3D
label values  R018901   MC5B
label values  R019001   RATE4A
label values  RB19001   RATE4A
label values  RC19001   RATE4A
label values  R019101   R017102V
label values  RB19101   RATE3D
label values  RC19101   RATE3D
label values  R019201   R017102V
label values  RB19201   RATE3D
label values  RC19201   RATE3D
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
label values  R012701   MC5B
label values  R012702   RATE2A
label values  RB12702   RATE2A
label values  RC12702   RATE2A
label values  R012707   MC5C
label values  R012704   MC5C
label values  R012705   RATE2A
label values  RB12705   RATE2A
label values  RC12705   RATE2A
label values  R012706   RATE2A
label values  RB12706   RATE2A
label values  RC12706   RATE2A
label values  R012711   MC5D
label values  R012703   RATE2A
label values  RB12703   RATE2A
label values  RC12703   RATE2A
label values  R012709   MC5A
label values  R012714   RATE4A
label values  RB12714   RATE4A
label values  RC12714   RATE4A
label values  R012710   RATE2A
label values  RB12710   RATE2A
label values  RC12710   RATE2A
label values  R012712   MC5B
label values  R012713   RATE2A
label values  RB12713   RATE2D
label values  RC12713   RATE2D
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
label values  R053301   R017102V
label values  RB53301   R053401V
label values  RC53301   R053401V
label values  R053302   R053407V
label values  R053303   RATE2A
label values  RB53303   RATE2D
label values  RC53303   RATE2D
label values  R053304   R053403V
label values  R053305   R017102V
label values  RB53305   R053401V
label values  RC53305   R053401V
label values  R053306   R053404V
label values  R053307   R053406V
label values  R053308   R053406V
label values  R053309   R017102V
label values  RB53309   R053401V
label values  RC53309   R053401V
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
label values  R016201   R017102V
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
label values  RB26501   RATE3D
label values  RC26501   RATE3D
label values  R027101   MC5A
label values  R026601   MC5B
label values  R028201   MC5B
label values  R026801   RATE4A
label values  RB26801   RATE4A
label values  RC26801   RATE4A
label values  R027201   R017102V
label values  RB27201   RATE3D
label values  RC27201   RATE3D
label values  R026901   MC5B
label values  R027001   RATE2A
label values  RB27001   RATE2A
label values  RC27001   RATE2A
label values  R028301   MC5A
label values  R028401   R017102V
label values  RB28401   RATE3D
label values  RC28401   RATE3D
label values  R028501   R017102V
label values  RB28501   RATE3D
label values  RC28501   RATE3D
label values  R029501   MC5A
label values  R029701   MC5B
label values  R028801   RATE4A
label values  RB28801   RATE4A
label values  RC28801   RATE4A
label values  R029001   MC5B
label values  R029901   MC5C
label values  R029601   R017102V
label values  RB29601   RATE3D
label values  RC29601   RATE3D
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
label values  T087901   YESNO
label values  T087902   YESNO
label values  T085801   T085801Q
label values  T085901   T085901Q
label values  T083601   FREQ6A
label values  T083602   FREQ6A
label values  T083603   FREQ6A
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
// mvdecode PARED BA21101 - R836801 R017103 R017106 R017109 R018501 R018901 /*
//       */ R012602 R012603  R012605 R012606  R012608 - R012610 R013202 R013204 /*
//       */ R013206 R013208 R013210 R012701 R012707 R012704  R012711 R012709 /*
//       */ R012712 R053403 R053404  R053406 R053407  R053409 R053411 R053302 /*
//       */ R053304 R053306 - R053308 R013401 R013404 R013408 R013410 R013002 /*
//       */ R013006 R013012 R053201  R053204 R053206 R053208 R053210 R016203 /*
//       */ R016206 R016208 R016209  R027301 R026401  R027101 - R028201 R026901 /*
//       */ R028301 R029501 R029701  R029001 R029901  R029801 - TE21201 /*
//       */ T077201 - T090716 XS00201 X012201 - XS00701 XS00901 - XS01201 /*
//       */ XS01701 X013801 - XL01101 XL01401,  mv( 0=.m)
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
//       */ R012710 - RC12710 R012712 - RC12713 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC53301 R053302 - RC53303 /*
//       */ R053304 - RC53305 R053306 - RC53309 R013401 - RC13402 /*
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
//       */ R029501 - RC28801 R029001 - RC29601 R029801,  mv( 9=.n)
// /* OMITTED RESPONSES               */
// mvdecode TITLE1 SCHTY02 HISPYES DRACEM  SDRACEM SENROL8 - LEP PARED /*
//       */ BA21101 - RC17101 R017102 - RC17102 R017103 - RC17104 /*
//       */ R017105 - RC17105 R017106 - RC17107 R017108 - RC17108 /*
//       */ R017109 - RC17110 R018401 - RC18401 R018501 - RC18601 /*
//       */ R018701 - RC18701 R018801 - RC18801 R018901 - RC19001 /*
//       */ R019101 - RC19101 R019201 - RC19201 R012601 - RC12601 /*
//       */ R012602 - RC12604 R012605 - RC12607 R012608 - RC12612 /*
//       */ R013201 - RC13201 R013202 - RC13203 R013204 - RC13205 /*
//       */ R013206 - RC13207 R013208 - RC13209 R013210 - RC13211 /*
//       */ R013212 - RC13212 R012701 - RC12702 R012707 - RC12705 /*
//       */ R012706 - RC12706 R012711 - RC12703 R012709 - RC12714 /*
//       */ R012710 - RC12710 R012712 - RC12713 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC53301 R053302 - RC53303 /*
//       */ R053304 - RC53305 R053306 - RC53309 R013401 - RC13402 /*
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
//       */ T077201 - T090716 XS00101 - XS01701 XL00101 - XL01401,  mv( 8=.o)
// /* "I DON'T KNOW" RESPONSES        */
// mvdecode PARED B017001 B000905  B017201 B003501 B003601  XS00501 - XS00701 /*
//       */ XS01001 XS01101  XL00201 - XL00601 XL00801 - XL01101,  mv( 7=.p)
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
//       */ R012710 - RC12710 R012713 - RC12713 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC53301 R053302 - RC53303 /*
//       */ R053304 - RC53305 R053306 - RC53309 R013402 - RC13402 /*
//       */ R013403 - RC13403 R013405 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013409 - RC13409 R013411 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013003 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013007 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R053201 - RC53202 R053203 - RC53203 /*
//       */ R053204 - RC53205 R053206 - RC53207 R053208 - RC53209 /*
//       */ R053210 - RC16201 R016202 - RC16202 R016204 - RC16204 /*
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
//       */ R012710 - RC12710 R012713 - RC12713 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC53301 R053302 - RC53303 /*
//       */ R053304 - RC53305 R053306 - RC53309 R013402 - RC13402 /*
//       */ R013403 - RC13403 R013405 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013409 - RC13409 R013411 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013003 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013007 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R053201 - RC53202 R053203 - RC53203 /*
//       */ R053204 - RC53205 R053206 - RC53207 R053208 - RC53209 /*
//       */ R053210 - RC16201 R016202 - RC16202 R016204 - RC16204 /*
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
//       */ R012710 - RC12710 R012713 - RC12713 R053401 - RC53401 /*
//       */ R053402 - RC53402 R053403 - RC53405 R053406 - RC53408 /*
//       */ R053409 - RC53410 R053411 - RC53301 R053302 - RC53303 /*
//       */ R053304 - RC53305 R053306 - RC53309 R013402 - RC13402 /*
//       */ R013403 - RC13403 R013405 - RC13405 R013406 - RC13406 /*
//       */ R013407 - RC13407 R013409 - RC13409 R013411 - RC13411 /*
//       */ R013413 - RC13413 R013001 - RC13001 R013003 - RC13003 /*
//       */ R013004 - RC13004 R013005 - RC13005 R013007 - RC13007 /*
//       */ R013008 - RC13008 R013009 - RC13009 R013010 - RC13010 /*
//       */ R013011 - RC13011 R053201 - RC53202 R053203 - RC53203 /*
//       */ R053204 - RC53205 R053206 - RC53207 R053208 - RC53209 /*
//       */ R053210 - RC16201 R016202 - RC16202 R016204 - RC16204 /*
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
//     */ R053402 R053410 R053303 R013402 R013405 R013407 R013409 R013411 /*
//     */ R013413 R013001 R013003 R013005 R013007 R013008 R013009 R013010 /*
//     */ R013011 R027001 (1=0) (2=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) /*
//     */ (else=.)
// recode R017102 R017110 R019201 R053408 R053301 R053202 (1=0) (2=1) (3=1) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017103 R012606 R012609 R013208 R013210 R012711 R013401 R013002 /*
//     */ R016209 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R017104 R017107 R018401 R018601 R018801 R019101 R053401 R053305 /*
//     */ R053309 R053203 R053207 R053209 R016201 R016202 R016205 R016207 /*
//     */ R016211 R016212 R027201 R028401 R028501 R029601 (1=0) (2=1) (3=2) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017105 R019001 R013201 R013212 R012714 R053405 R053205 R016204 /*
//     */ R016210 R026801 R028801 (1=0) (2=1) (3=2) (4=3) ( 9=.n) ( 8=.o) /*
//     */ ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R017106 R018501 R012610 R013202 R013206 R012709 R013408 R013006 /*
//     */ R016206 R027101 R028301 R029501 (1=1) (2=0) (3=0) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) (else=.)
// recode R017109 R018901 R012603 R012605 R013204 R012701 R012712 R013410 /*
//     */ R016203 R027301 R026601 R028201 R026901 R029701 R029001 R029801 (1=0) /*
//     */ (2=1) (3=0) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R018701 R016213 R026501 (1=0) (2=0) (3=1) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R012602 R012608 R012707 R012704 R013404 R013012 R016208 R026401 /*
//     */ R029901 (1=0) (2=0) (3=1) (4=0) ( 0=.m) ( 9=.n) ( 8=.o) (else=.)
// recode R012607 (1=0) (2=1) (3=2) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)
// recode R053403 R053304 R053201 R053206 (1=0) (2=1) (3=0) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R053404 R053409 R053306 R053204 (1=1) (2=0) (3=0) (4=0) ( 0=.m) /*
//     */ ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R053406 R053411 R053307 R053308 R053210 (1=0) (2=0) (3=1) (4=0) /*
//     */ ( 0=.m) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R053407 R053302 R053208 (1=0) (2=0) (3=0) (4=1) ( 0=.m) ( 9=.n) /*
//     */ ( 8=.o) ( 7=.q) ( 5=.r) ( 6=.s) (else=.)
// recode R013403 R013004 (1=0) (2=0) (3=1) (4=2) ( 9=.n) ( 8=.o) ( 7=.q) /*
//     */ ( 5=.r) ( 6=.s) (else=.)
// recode R013406 (1=0) (2=0) (3=1) (4=1) ( 9=.n) ( 8=.o) ( 7=.q) ( 5=.r) /*
//     */ ( 6=.s) (else=.)

*KEEP ONLY THOSE NOT EXCLUDED
keep if RPTSAMP==1

*KEEP FOLLOWING VARIABLES: NCES SCHOOL ID, SCHOOL CODE, FULL SCHOOL ID, SCHOOL PUBLIC OR PRIVATE
*FULL TEST VALUES AND THETAS, REPLICATE WEIGHTS AND MAIN WEIGHT
*SEX, FREE LUNCH STATUS, RACE

gen year=2005
gen grade=8
gen subject=2
keep year grade subject FIPS NCESSCH SCHID SCH PUBPRIV ///
ORIGWT RTHCM1-RTHCM5 RRPCM1-RRPCM5 ///
DSEX SLUNCH1 SRACE

compress
save "C:\Users\Hyman\Desktop\NAEP\cleaned_data\2005\naep_read_gr8_2005", replace


