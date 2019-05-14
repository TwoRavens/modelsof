************************************************************************************************************
*																										   *
*					DO FILE FOR FINAL SUBMISSION TO APSR, MI REGRESSIONS -- OCTOBER 2018				   *
*																										   *																										   
************************************************************************************************************


capture clear
capture log close
clear matrix
clear mata
set maxvar 25000

use "final_dataset_MI.dta"

mi tsset ccode year 

sort ccode year

gen ginet10a = 31.31563  
gen ginet90a =  51.25771

generate y1960 = 0 
replace y1960 = 1 if year == 1960
generate y1961 = 0 
replace y1961 = 1 if year == 1961
generate y1962 = 0 
replace y1962 = 1 if year == 1962
generate y1963 = 0 
replace y1963 = 1 if year == 1963
generate y1964 = 0 
replace y1964 = 1 if year == 1964
generate y1965 = 0 
replace y1965 = 1 if year == 1965
generate y1966 = 0 
replace y1966 = 1 if year == 1966
generate y1967 = 0 
replace y1967 = 1 if year == 1967
generate y1968 = 0 
replace y1968 = 1 if year == 1968
generate y1969 = 0 
replace y1969 = 1 if year == 1969
generate y1970 = 0 
replace y1970 = 1 if year == 1970
generate y1971 = 0 
replace y1971 = 1 if year == 1971
generate y1972 = 0 
replace y1972 = 1 if year == 1972
generate y1973 = 0 
replace y1973 = 1 if year == 1973
generate y1974 = 0 
replace y1974 = 1 if year == 1974
generate y1975 = 0 
replace y1975 = 1 if year == 1975
generate y1976 = 0 
replace y1976 = 1 if year == 1976
generate y1977 = 0 
replace y1977 = 1 if year == 1977
generate y1978 = 0 
replace y1978 = 1 if year == 1978
generate y1979 = 0 
replace y1979 = 1 if year == 1979
generate y1980 = 0 
replace y1980 = 1 if year == 1980
generate y1981 = 0 
replace y1981 = 1 if year == 1981
generate y1982 = 0 
replace y1982 = 1 if year == 1982
generate y1983 = 0 
replace y1983 = 1 if year == 1983
generate y1984 = 0 
replace y1984 = 1 if year == 1984
generate y1985 = 0 
replace y1985 = 1 if year == 1985
generate y1986 = 0 
replace y1986 = 1 if year == 1986
generate y1987 = 0 
replace y1987 = 1 if year == 1987
generate y1988 = 0 
replace y1988 = 1 if year == 1988
generate y1989 = 0 
replace y1989 = 1 if year == 1989
generate y1990 = 0 
replace y1990 = 1 if year == 1990
generate y1991 = 0 
replace y1991 = 1 if year == 1991
generate y1992 = 0 
replace y1992 = 1 if year == 1992
generate y1993 = 0 
replace y1993 = 1 if year == 1993
generate y1994 = 0 
replace y1994 = 1 if year == 1994
generate y1995 = 0 
replace y1995 = 1 if year == 1995
generate y1996 = 0 
replace y1996 = 1 if year == 1996
generate y1997 = 0 
replace y1997 = 1 if year == 1997
generate y1998 = 0 
replace y1998 = 1 if year == 1998
generate y1999 = 0 
replace y1999 = 1 if year == 1999
generate y2000 = 0 
replace y2000 = 1 if year == 2000
generate y2001 = 0 
replace y2001 = 1 if year == 2001
generate y2002 = 0 
replace y2002 = 1 if year == 2002
generate y2003 = 0 
replace y2003 = 1 if year == 2003
generate y2004 = 0 
replace y2004 = 1 if year == 2004
generate y2005 = 0 
replace y2005 = 1 if year == 2005
generate y2006 = 0 
replace y2006 = 1 if year == 2006
generate y2007 = 0 
replace y2007 = 1 if year == 2007
generate y2008 = 0 
replace y2008 = 1 if year == 2008
generate y2009 = 0 
replace y2009 = 1 if year == 2009
generate y2010 = 0 
replace y2010 = 1 if year == 2010
generate y2011 = 0 
replace y2011 = 1 if year == 2011
generate y2012 = 0 
replace y2012 = 1 if year == 2012
generate y2013 = 0 
replace y2013 = 1 if year == 2013
generate y2014 = 0 
replace y2014 = 1 if year == 2014
generate y2015 = 0 
replace y2015 = 1 if year == 2015
generate y2016 = 0 
replace y2016 = 1 if year == 2016



*******************************
***							***
***	   	TABLE 3, (1 - 4)   	***
***							***
*******************************

* column 1
eststo T31: mi estimate, post: xtreg solt_ginet L.solt_ginet  L.acemoglu_demo  L.log_gdp i.year if L.acemoglu_pre_demo_ineg_best !=., fe cluster(ccode) 

* column 2
eststo T32: mi estimate, post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year, fe cluster(ccode)
mi test L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( 0.9754214 -.0255769  *ginet10a)/(1-.9045491  )
display ( 0.9754214 -.0255769  *ginet90a)/(1-.9045491  )

* column 3
eststo T33: mi estimate, post: xtreg solt_ginet L.solt_ginet  L.acemoglu_demo  L.log_gdp i.year if L.acemoglu_pre_demo_ineg_best !=. & L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode) 

* column 4
eststo T34: mi estimate, post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if  L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode)
mi test L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( 1.036301  -.0266811 *ginet10a)/(1-.9054829 )
display ( 1.036301  -.0266811 *ginet90a)/(1-.9054829 )

estout  T31 T32 T33 T34,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE 4    		***
***						***
***************************

* column 1
eststo T41: mi estimate, post: xtreg solt_ginet   L.solt_ginet   L5.acemoglu_demo L.log_gdp  i.year if L5.acemoglu_pre_demo_ineg_best!=., fe cluster(ccode)

* column 2
eststo T42: mi estimate, post: xtreg solt_ginet   L.solt_ginet   L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L.log_gdp  i.year , fe cluster(ccode)
mi test L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display (0.9027782  -.0236183   *ginet10a)/(1-.8939634 )
display (0.9027782  -.0236183   *ginet90a)/(1-.8939634 )

* column 3
eststo T43: mi estimate, post: xtreg solt_ginet   L.solt_ginet   L10.acemoglu_demo L.log_gdp  i.year if L10.acemoglu_pre_demo_ineg_best!=., fe cluster(ccode)

* column 4
eststo T44: mi estimate, post: xtreg solt_ginet   L.solt_ginet   L10.acemoglu_demo L10.acemoglu_pre_demo_ineg_best L.log_gdp  i.year , fe cluster(ccode)
mi test L10.acemoglu_demo L10.acemoglu_pre_demo_ineg_best
display (0.7562531  -.0195117    *ginet10a)/(1-.8803084  )
display (0.7562531  -.0195117    *ginet90a)/(1-.8803084  )

* column 5
eststo T45: mi estimate, post: xtreg solt_ginet   L5.solt_ginet   L5.acemoglu_demo L5.log_gdp  i.year if fiveyear==1 &  L5.acemoglu_pre_demo_ineg_best!=., fe cluster(ccode)

* column 6
eststo T46: mi estimate, post: xtreg solt_ginet   L5.solt_ginet   L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp  i.year if fiveyear==1, fe cluster(ccode)
mi test L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display (4.121853  -.1102103    *ginet10a)/(1-.5613764 )
display (4.121853  -.1102103    *ginet90a)/(1-.5613764 )

* column 7
eststo T47: mi estimate, post: xtreg solt_ginet   L10.solt_ginet   L10.acemoglu_demo L10.log_gdp  i.year if tenyears==1 &  L10.acemoglu_pre_demo_ineg_best!=., fe cluster(ccode)

* column 8
eststo T48: mi estimate, post: xtreg solt_ginet   L10.solt_ginet   L10.acemoglu_demo L10.acemoglu_pre_demo_ineg_best L10.log_gdp  i.year if tenyears==1 , fe cluster(ccode)
mi test L10.acemoglu_demo L10.acemoglu_pre_demo_ineg_best
display ( 5.805143   -.1584145   *ginet10a)/(1-.2633905 )
display ( 5.805143   -.1584145   *ginet90a)/(1-.2633905 )

estout  T41 T42 T43 T44 T45 T46 T47 T48,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



*******************************
***							***
***	   	TABLE 5, Panel A  	***
***							***
*******************************


* column 1a * Excluding USSR & Warsaw pact
eststo T51a: mi estimate, post: xtreg solt_ginet   L.solt_ginet   L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if warsaw!=1 & ussr != 1 & L.neighbour_demo !=. & L6.neighbour_demo !=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( .9969133 -.0257593   *ginet10a)/(1-  .909515  )
display ( .9969133 -.0257593   *ginet90a)/(1-  .909515  )

* column 2a * Excluding North Africa and Middle East
eststo T52a: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if ht_region != 3 & L.neighbour_demo !=. & L6.neighbour_demo !=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (1.07639 -.0279136 *ginet10a)/(1-0.9065778 )
display (1.07639 -.0279136 *ginet90a)/(1-0.9065778 )

* column 3a * Excluding Sub-Saharan Africa
eststo T53a: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if ht_region != 4 & L.neighbour_demo !=. & L6.neighbour_demo !=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (0.892367  -.0217732 *ginet10a)/(1-0.9054944  )
display (0.892367  -.0217732 *ginet90a)/(1-0.9054944  )

* column 4a * Excluding Latin America and Carribean
eststo T54a: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if ht_region != 2 & ht_region != 10 & L.neighbour_demo !=. & L6.neighbour_demo !=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (0.9009701-.0243925  *ginet10a)/(1-0.9027764)
display (0.9009701-.0243925  *ginet90a)/(1-0.9027764)

* column 5a * Excluding Asia and Pacific
eststo T55a: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if ht_region != 6 & ht_region!=9 & ht_region != 8 & ht_region != 7 & L.neighbour_demo !=. & L6.neighbour_demo !=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (1.157005  -.0302754  *ginet10a)/(1-0.9031336  )
display (1.157005  -.0302754  *ginet90a)/(1-0.9031336  )

estout  T51a T52a T53a T54a T55a,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



*******************************
***							***
***	   	TABLE 6, (1 - 3)   	***
***							***
******************************* 

* column 1
eststo T61: mi estimate, dots post: xtreg solt_ginet   L.solt_ginet  L.demo L.demo_pre_demo_ineg    L.log_gdp i.year if L.p_neighbour_demo!=. &  L.neighbour_demo_pre_ineg4!=. &   L6.p_neighbour_demo!=.,  fe cluster(ccode)
testparm L.demo L.demo_pre_demo_ineg
display (1.074505   -.0273238 *ginet10a)/(1-.9105925)
display (1.074505   -.0273238 *ginet90a)/(1-.9105925)

* column 2
eststo T62: mi estimate, cmdok post: xtreg solt_ginet  L.p_polity2 L.ginet_polity2 L.solt_ginet    L.log_gdp i.year if L.p_neighbour_demo!=. &  L.neighbour_demo_pre_ineg4!=. &   L6.p_neighbour_demo!=., fe cluster(ccode)
testparm L.p_polity2 L.ginet_polity2
display  6.824669*( ( .0657682     -.0017157    *ginet10a)/(1- 0.902864  ))
display  6.824669*( ( .0657682     -.0017157    *ginet90a)/(1- 0.902864  ))

* column 3
eststo T63: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet L.boix_demo L.boix_demo_pre_demo_ineg    L.log_gdp i.year if L.neighbour_demo_boix !=. & L.neighbour_demo_pre_ineg5!=. &   L6.neighbour_demo_boix!=., fe cluster(ccode)
testparm L.boix_demo L.boix_demo_pre_demo_ineg
display (0.8255755  - 0.0200401  *ginet10a)/(1-.9060735)
display (0.8401462 - 0.0203392 *ginet90a)/(1-.9058717)

estout  T61 T62 T63,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE 7    		***
***						***
***************************

* column 1
eststo T71: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet L.plac_lead10  L.log_gdp i.year, fe cluster(ccode) 

* column 2
eststo T72: mi estimate, cmdok post: xtreg solt_ginet   L.solt_ginet L.plac_lead10 L.pre_lead10_ineg_best    L.log_gdp i.year , fe cluster(ccode)
testparm L.plac_lead10 L.pre_lead10_ineg_best

* column 3
eststo T73: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet   L.plac_lead15  L.log_gdp i.year, fe cluster(ccode) 

* column 4
eststo T74: mi estimate, cmdok post: xtreg solt_ginet   L.solt_ginet L.plac_lead15 L.pre_lead15_ineg_best    L.log_gdp i.year , fe cluster(ccode)
testparm L.plac_lead15 L.pre_lead15_ineg_best

* column 5
eststo T75: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet L.acemoglu_auto  L.log_gdp i.year, fe cluster(ccode) 

* column 6 
eststo T76: mi estimate, cmdok post: xtreg solt_ginet   L.solt_ginet L.acemoglu_auto L.acemoglu_pre_auto_ineg_best    L.log_gdp i.year , fe cluster(ccode)
testparm L.acemoglu_auto L.acemoglu_pre_auto_ineg_best 

* column 7
eststo T77: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet L.civil_war3   L.log_gdp i.year, fe cluster(ccode) 

* column 8
eststo T78: mi estimate, cmdok post: xtreg solt_ginet   L.solt_ginet L.civil_war3 L.pre_civil3_ineg_best   L.log_gdp i.year , fe cluster(ccode)
testparm L.civil_war3 L.pre_civil3_ineg_best

estout  T71 T72 T73 T74 T75 T76 T77 T78,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE 8    		***
***						***
***************************

sort ccode year

mi passive: gen solt_fiscal = 100*((solt_ginmar - solt_ginet)/solt_ginmar)

* column 1
eststo T81: mi estimate,  post : xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year, fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( 0.9745887 -.025553  *ginet10a)/(1-.9047001  )
display ( 0.9745887 -.025553  *ginet90a)/(1-.9047001  )

* column 2
eststo T82: mi estimate,   post: xtreg solt_ginmar   L.solt_ginmar L.acemoglu_demo L.acemoglu_pre_ineg_bestMar  L.log_gdp  i.year, fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_ineg_bestMar
display (.8715058  -.0213842*ginmar10a)/(1-.9112323 )
display (.8715058  -.0213842*ginmar90a)/(1-.9112323 )

* column 3
eststo T83: mi estimate,  post : xtreg solt_fiscal L.solt_fiscal L.acemoglu_demo1 L.log_gdp i.year if pre_demo_ineg_best_PE<=38.5 & pre_demo_ineg_best_PE!=., fe cluster(ccode) 

* column 4
eststo T84: mi estimate,  post : xtreg solt_fiscal L.solt_fiscal L.acemoglu_demo1 L.log_gdp i.year if pre_demo_ineg_best_PE>38.5 & pre_demo_ineg_best_PE!=., fe cluster(ccode)

estout  T81 T82 T83 T84,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend




******************************************************
*													 *
*				APPENDIX TABLES 					 *
*													 *
******************************************************


*******************************
***							***
***	   	TABLE A3, (1 - 4)  	***
***							***
******************************* 

* column 1
eststo TA31: mi estimate, post: xtreg solt_ginet L.solt_ginet L2.solt_ginet L3.solt_ginet L4.solt_ginet  L.acemoglu_demo  L.log_gdp i.year if L.acemoglu_pre_demo_ineg_best !=., fe cluster(ccode) 

* column 2
eststo TA32: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L2.solt_ginet L3.solt_ginet L4.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year, fe cluster(ccode)
mi test L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( 0.9710521 -.0257761  *ginet10a)/(1-.908467 - 0.0051931 - 0.0062368 + 0.026111 )
display ( 0.9710521 -.0257761  *ginet90a)/(1-.908467 - 0.0051931 - 0.0062368 + 0.026111 )

* column 3
eststo TA33: mi estimate, post: xtreg solt_ginet L.solt_ginet  L2.solt_ginet L3.solt_ginet L4.solt_ginet L.acemoglu_demo  L.log_gdp i.year if L.acemoglu_pre_demo_ineg_best !=. & L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode) 

* column 4
eststo TA34:  mi estimate, post: xtreg solt_ginet   L.solt_ginet  L2.solt_ginet L3.solt_ginet L4.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if  L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode)
mi test L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( 1.045211  -.0271942 *ginet10a)/(1-.9046662 - 0.0061195 - 0.006616 + 0.0223814 )
display ( 1.045211  -.0271942 *ginet90a)/(1-.9046662 - 0.0061195 - 0.006616 + 0.0223814 )

estout  TA31 TA32 TA33 TA34,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A10  		***
***						***
***************************

* column 1
eststo TA101: mi estimate, post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year, fe cluster(ccode)
mi test L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display ( 0.9754214 -.0255769  *ginet10a)/(1-.9045491  )
display ( 0.9754214 -.0255769  *ginet90a)/(1-.9045491  )

* column 2
eststo TA102: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_pre_demo_ineg_best    L.log_gdp i.year if transparency > -.6076591 & L.neighbour_demo!=. & L2.neighbour_demo!=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (.9196244  -.0227657   *ginet10a)/(1-.9023496 )
display (.9196244  -.0227657   *ginet90a)/(1-.9023496 )

* column 3
eststo TA103: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.log_gdp i.year if transparency >.4620216  & L.neighbour_demo!=. & L2.neighbour_demo!=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (0.861515  -.0216449   *ginet10a)/(1-.9021578)
display (0.861515  -.0216449   *ginet90a)/(1-.9021578)

* cloumn 4
eststo TA104: mi estimate, dots cmdok post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best    L.log_gdp i.year if transparent > 2.125, fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (1.010846   -.0262187  *ginet10a)/(1-.9042436 )
display (1.010846   -.0262187  *ginet90a)/(1-.9042436 )

* column 5
eststo TA105: mi estimate, dots cmdok post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best    L.log_gdp i.year if transparent > 3.875 , fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (1.049513   -.0281639   *ginet10a)/(1-.9074439)
display (1.049513   -.0281639   *ginet90a)/(1-.9074439)

estout  TA101 TA102 TA103 TA104 TA105,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A13  		***
***						***
***************************

* column 1
eststo TA131: mi estimate, post: xtreg solt_ginet   L.solt_ginet  L.demo2 L.demo2_pre_demo2_ineg    L.log_gdp i.year ,  fe cluster(ccode)
testparm L.demo2 L.demo2_pre_demo2_ineg
display (0.7213374    -.0185633*ginet10a)/(1-.9067691 )
display (0.7213374    -.0185633*ginet90a)/(1-.9067691 )

* column 2
eststo TA132: mi estimate, cmdok post: xtreg solt_ginet  L.chga_demo L.chga_pre_chga_ineg L.solt_ginet    L.log_gdp i.year, fe cluster(ccode)
testparm  L.chga_demo L.chga_pre_chga_ineg
display ( .9653836    -.0251956   *ginet10a)/(1- 0.8995947)
display ( .9653836    -.0251956   *ginet90a)/(1- 0.8995947)

* column 3
eststo TA133: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet   L.demo_machine L.demo_machine_pre_ineg_b_m    L.log_gdp i.year, fe cluster(ccode)
testparm  L.demo_machine L.demo_machine_pre_ineg_b_m
display (0.8340069   -.0196327 *ginet10a)/(1-.8861695)
display (0.8340069   -.0196327 *ginet90a)/(1-.8861695)

* column 4
eststo TA134: mi estimate, cmdok post: xtreg solt_ginet L.solt_ginet L.svmdi L.svmdi_L5ginet    L.log_gdp i.year, fe cluster(ccode)
testparm L.svmdi L.svmdi_L5ginet
display  .3697287 *(1.391338  -.0321471*ginet10a)/(1-.8826397)
display  .3697287 *(1.391338  -.0321471*ginet90a)/(1-.8826397)

estout  TA131 TA132 TA133 TA134,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A14  		***
***						***
***************************

* column 1
eststo TA141: mi estimate, dots cmdok post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_demo_military L.acemoglu_demo_monarchy L.acemoglu_demo_party L.log_gdp  i.year if L.acemoglu_pre_demo_ineg_best!=. & L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode)

* column 2
eststo TA142: mi estimate, dots cmdok post: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_pre_demo_ineg_best L.acemoglu_demo_military L.acemoglu_demo_monarchy L.acemoglu_demo_party L.log_gdp  i.year if L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_best
display (1.035775   - .0266552 *ginet10a)/(1-.9054523 )
display (1.035775   - .0266552 *ginet90a)/(1-.9054523 )

estout  TA141 TA142,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A15  		***
***						***
***************************

* column 1
eststo TA151: mi estimate, dots  post : xtreg solt_ginet   L.solt_ginet   L.acemoglu_demo L.acemoglu_pre_demo_ineg_0 L.log_gdp i.year if L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_pre_demo_ineg_0
display (0.8566135   -.022154  *ginet10a)/(1 - .9122527    )
display (0.8566135   -.022154  *ginet900a)/(1 - .9122527   )

* column 2
eststo TA152: mi estimate, dots post : xtreg solt_ginet   L.solt_ginet    L.acemoglu_demo L.acemoglu_demo_Lginet   L.log_gdp i.year if L.neighbour_demo!=. & L6.neighbour_demo!=., fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_Lginet
display (.808461      -.0212128   *ginet10a)/(1 - .908462 )
display (.808461      -.0212128   *ginet90a)/(1 - .908462 )

estout  TA151 TA152,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A18  		***
***						***
***************************

* column 1 * Excluding USSR & Warsaw pact
eststo TA181: mi estimate, post: xtreg solt_ginet   L.solt_ginet   L5.solt_ginet    L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp i.year if fiveyear==1 & warsaw!=1 & ussr != 1, fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display (4.407931  -.1156542   *ginet10a)/(1-  .5793742   )
display (4.407931  -.1156542   *ginet90a)/(1-  .5793742   )

* column 2 * Excluding North Africa and the Middle East
eststo TA182: mi estimate, post: xtreg solt_ginet   L5.solt_ginet    L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp i.year if fiveyear==1 & ht_region != 3  , fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display ( 3.659223   -.0961727   *ginet10a)/(1-0.5738025   )
display ( 3.659223   -.0961727   *ginet90a)/(1-0.5738025   )

* column 3 * Excluding Sub-Saharan Africa
eststo TA183: mi estimate, post: xtreg solt_ginet   L5.solt_ginet    L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp i.year if fiveyear==1 &   ht_region != 4 , fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display ( 4.286491    -.1143201    *ginet10a)/(1-0.5663731  )
display ( 4.286491    -.1143201    *ginet90a)/(1-0.5663731  )

* column 4 * Excluding Latin America and Carribean
eststo TA184: mi estimate, post: xtreg solt_ginet   L5.solt_ginet    L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp i.year if fiveyear==1 & ht_region != 2 & ht_region != 10 , fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display ( 3.226983-.0898429 *ginet10a)/(1-0.56344)
display ( 3.226983-.0898429 *ginet90a)/(1-0.56344)

* column 5 * Excluding Asia and Pacific
eststo TA185: mi estimate, post: xtreg solt_ginet   L5.solt_ginet    L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp i.year if fiveyear==1 & ht_region != 6 & ht_region!=9 & ht_region != 8 & ht_region != 7 , fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display (4.703567  -.1222196  *ginet10a)/(1-0.533244   )
display (4.703567  -.1222196  *ginet90a)/(1-0.533244   )

estout  TA181 TA182 TA183 TA184 TA185,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A19  		***
***						***
***************************

* column 1
eststo TA191: mi estimate, post: xtreg solt_ginet   L5.solt_ginet  L5.demo L5.demo_pre_demo_ineg    L5.log_gdp i.year if fiveyear==1,  fe cluster(ccode)
testparm L5.demo L5.demo_pre_demo_ineg
display (4.714476   -.1188026 *ginet10a)/(1-.5848663 )
display (4.714476   -.1188026 *ginet90a)/(1-.5848663 )

* column 2
eststo TA192: mi estimate, cmdok post: xtreg solt_ginet  L5.p_polity2 L5.polity_L5ginet L5.solt_ginet    L5.log_gdp i.year if fiveyear==1 , fe cluster(ccode)
testparm L5.p_polity2 L5.polity_L5ginet
display  6.824669*( ( .2939034     -.0076097  *ginet10a)/(1- 0.5215374))
display  6.824669*( ( .2939034     -.0076097  *ginet90a)/(1- 0.5215374))

* column 3
eststo TA193: mi estimate, cmdok post: xtreg solt_ginet  L5.chga_demo L5.chga_pre_chga_ineg L5.solt_ginet    L5.log_gdp i.year if fiveyear==1, fe cluster(ccode)
testparm  L5.chga_demo L5.chga_pre_chga_ineg
display ( 4.332064    -.1096259    *ginet10a)/(1- 0.5704237)
display ( 4.332064    -.1096259    *ginet90a)/(1- 0.5704237)

* column 4
eststo TA194: mi estimate, cmdok post: xtreg solt_ginet L5.solt_ginet L5.boix_demo L5.boix_demo_pre_demo_ineg    L5.log_gdp i.year if fiveyear==1, fe cluster(ccode)
testparm L5.boix_demo L5.boix_demo_pre_demo_ineg
display ( 2.926691  - 0.0712878 *ginet10a)/(1-.5627627 )
display ( 2.926691  - 0.0712878 *ginet90a)/(1-.5627627 )

estout  TA191 TA192 TA193 TA194,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A20  		***
***						***
***************************

* column 1
eststo TA201: mi estimate,  post : xtreg solt_ginet   L5.solt_ginet L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best L5.log_gdp i.year if fiveyear==1, fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_demo_ineg_best
display (  4.104023 -.1085164   *ginet10a)/(1-.5632616  )
display (  4.104023 -.1085164   *ginet90a)/(1-.5632616  )

* column 2
eststo TA202: mi estimate,   post: xtreg solt_ginmar   L5.solt_ginmar L5.acemoglu_demo L5.acemoglu_pre_ineg_bestMar  L5.log_gdp  i.year if fiveyear==1, fe cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_pre_ineg_bestMar
display (3.172809  -.0786998 *ginmar10a)/(1-.5951603  )
display (3.172809  -.0786998 *ginmar90a)/(1-.5951603  )

* column 3
eststo TA203: mi estimate,  post : xtreg solt_fiscal L5.solt_fiscal L5.acemoglu_demo1 L5.log_gdp i.year if pre_demo_ineg_best_PE<=38.5 & pre_demo_ineg_best_PE!=. & fiveyear==1, fe cluster(ccode) 

* column 4
eststo TA204: mi estimate,  post : xtreg solt_fiscal L5.solt_fiscal L5.acemoglu_demo1 L5.log_gdp i.year if pre_demo_ineg_best_PE>38.5 & pre_demo_ineg_best_PE!=. & fiveyear==1, fe cluster(ccode)

estout  TA201 TA202 TA203 TA204,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend
