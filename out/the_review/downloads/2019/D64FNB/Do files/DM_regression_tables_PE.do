************************************************************************************************************
*																										   *
*			DO FILE FOR FINAL SUBMISSION TO APSR,  POINT ESTIMATES -- OCTOBER 2018						   *
*																										   *
************************************************************************************************************


capture clear
clear matrix
clear mata
capture log close
set maxvar 15000

use "final_dataset_PE.dta"

*gen ginet10a = 31.31563  
*gen ginet90a =  51.25771



***************************
***						***
***	   	TABLE 1    		***
***						***
***************************

xi: xtreg solt_ginet  L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year, fe cluster(ccode)
generate summarystat = e(sample)

summarize pwt_rgdpch if acemoglu_demo==0  & summarystat ==1, detail

summarize solt_ginet if acemoglu_demo==0  & summarystat ==1 & pwt_rgdpch<=1090.416, detail
summarize solt_ginet if acemoglu_demo==0  & summarystat ==1 & pwt_rgdpch<=2171.612  & pwt_rgdpch>1090.416, detail
summarize solt_ginet if acemoglu_demo==0  & summarystat ==1 & pwt_rgdpch<= 5668.183& pwt_rgdpch>2171.612 , detail
summarize solt_ginet if acemoglu_demo==0  & summarystat ==1 &  pwt_rgdpch>5668.183 & pwt_rgdpch!=., detail

summarize pwt_rgdpch if acemoglu_demo==1  & summarystat ==1, detail

summarize solt_ginet if acemoglu_demo==1  & summarystat ==1 & pwt_rgdpch<=3859.862, detail
summarize solt_ginet if acemoglu_demo==1  & summarystat ==1 &  pwt_rgdpch<=9201.723   & pwt_rgdpch>3859.862, detail
summarize solt_ginet if acemoglu_demo==1  & summarystat ==1 &  pwt_rgdpch<= 21945.5 & pwt_rgdpch>9201.723  , detail
summarize solt_ginet if acemoglu_demo==1  & summarystat ==1 & pwt_rgdpch>21945.5 & pwt_rgdpch!=., detail



***************************
***						***
***	   	TABLE 2    		***
***						***
***************************

summarize solt_ginet solt_ginmar  pwt_rgdpch neighbour_demo Ineq_IV if acemoglu_demo != 1 & summarystat==1
summarize solt_ginet solt_ginmar  pwt_rgdpch neighbour_demo Ineq_IV if acemoglu_demo == 1 & summarystat==1



***************************
***						***
***	   	FIGURE 1    	***
***						***
***************************

twoway (scatter L.change10_ineq pre_demo_ineg_best if acemoglu_demo==1 & L.acemoglu_demo==0 & summarystat==1, mlabel(ccodealp)) (lfit L.change10_ineq pre_demo_ineg_best if acemoglu_demo==1 & L.acemoglu_demo==0), yline(0, lpattern(dash) lwidth(thin) lcolor(black)) ytitle(Change in Net Inequality Level -- 10 Years) xtitle(Pre-Democracy Inequality Level -- Net Gini Coefficient) legend(off) scheme(s1mono) graphregion(fcolor(white)) xscale(range(20 65)) xlabel(20(10)60) ylabel(-10(5)10) 
reg  L.change10_ineq pre_demo_ineg_best if acemoglu_demo==1 & L.acemoglu_demo==0 & summarystat==1

twoway (scatter L.change10_ineqMar pre_demo_ineg_bestMar if acemoglu_demo==1 & L.acemoglu_demo==0 & summarystat==1, mlabel(ccodealp)) (lfit L.change10_ineqMar pre_demo_ineg_bestMar if acemoglu_demo==1 & L.acemoglu_demo==0), yline(0, lpattern(dash) lwidth(thin) lcolor(black)) ytitle(Change in Gross Inequality Level -- 10 Years) xtitle(Pre-Democracy Inequality Level -- Gross Gini Coefficient) legend(off) scheme(s1mono) graphregion(fcolor(white)) xscale(range(20 65)) xlabel(20(10)60) 
reg  L.change10_ineqMar pre_demo_ineg_bestMar if acemoglu_demo==1 & L.acemoglu_demo==0 & summarystat==1 



*******************************
***							***
***	   	TABLE 3, (5 - 8)   	***
***							***
*******************************

xi: xtivreg2 solt_ginet   L.solt_ginet    (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo) L.log_gdp i.year, fe first cluster(ccode)
generate baseline2 = e(sample)

* column 5
eststo T35: xi: xtreg solt_ginet L.solt_ginet  L.acemoglu_demo  L.log_gdp i.year if baseline2==1, fe cluster(ccode) 

* column 6
eststo T36: xi: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year if baseline2==1, fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.464707 - .0375354*ginet10a)/(1-.892435 ) 
display (1.464707 - .0375354*ginet90a)/(1-.892435 ) 

* column 7
eststo T37: xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo  = L.neighbour_demo L6.neighbour_demo) L.log_gdp i.year if baseline2 == 1, fe first cluster(ccode)

* column 8
eststo T38: xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo) L.log_gdp i.year if baseline2 == 1, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.446069   - .0344763*ginet10a)/(1-.8930341 ) 
display (1.446069   - .0344763*ginet90a)/(1-.8930341 ) 


estout  T35 T36 T37 T38,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



*******************************
***							***
***	   	TABLE 5, Panel B   	***
***							***
*******************************

* column 1b, Excluding USSR & Warsaw pact
eststo T51b: xi: xtivreg2 solt_ginet   L.solt_ginet (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp  i.year  if warsaw!=1 & ussr != 1, fe first cluster(ccode) 
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.212961 - 0.0304398*ginet10a)/(1-0.8932891)
display (1.212961 - 0.0304398*ginet90a)/(1-0.8932891)

* column 2b, Excluding Northern Africa and Middle East 
eststo T52b: xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp i.year  if ht_region != 3, fe first cluster(ccode) 
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.444523  - 0.0376213*ginet10a)/(1- 0.8942137 )
display (1.444523  - 0.0376213*ginet90a)/(1- 0.8942137 )

* column 3b, Excluding Sub-Saharan Africa 
eststo T53b: xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp i.year  if ht_region != 4, fe first cluster(ccode) 
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.28295 - 0.0332378*ginet10a)/(1- 0.9007046)
display (1.28295 - 0.0332378*ginet90a)/(1- 0.9007046)

* column 4b, Excluding Latin America and Carribean 
eststo T54b: xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp i.year  if ht_region != 2 & ht_region != 10, fe first cluster(ccode)  partial(i.year)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.06017 - 0.0242607*ginet10a)/(1- 0.8944628)
display (1.06017 - 0.0242607*ginet90a)/(1- 0.8944628)

* column 5b, Excluding Asia and Pacific
eststo T55b: xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp i.year  if ht_region != 6 & ht_region!=9 & ht_region != 8 & ht_region != 7, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.687245 - 0.0421472 *ginet10a)/(1-0.8857156)
display (1.687245 - 0.0421472 *ginet90a)/(1-0.8857156)

estout  T51b T52b T53b T54b T55b,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



*******************************
***							***
***	   	TABLE 6, (4 - 6)   	***
***							***
******************************* 

* column 4
eststo T64: xi:xtivreg2 solt_ginet   L.solt_ginet    (L.demo L.demo_pre_demo_ineg = L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo)  L.log_gdp i.year, fe first cluster(ccode)
testparm L.demo L.demo_pre_demo_ineg
display ( 1.556361 -.0407672 *ginet10a)/(1- .8988378)
display ( 1.556361 -.0407672 *ginet90a)/(1- .8988378)

* column 5
eststo T65: xi:xtivreg2 solt_ginet   L.solt_ginet     (L.p_polity2 L.ginet_polity2 = L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo)  L.log_gdp i.year, fe first cluster(ccode)
testparm L.p_polity2 L.ginet_polity2
display 6.638316  *( ( .1433826 -.003771 *ginet10a)/(1- .8898764  ))
display 6.638316  *( ( .1433826 -.003771 *ginet90a)/(1- .8898764  ))

* column 6
eststo T66: xi: xtivreg2 solt_ginet   L.solt_ginet    (L.boix_demo L.boix_demo_pre_demo_ineg = L.neighbour_demo_boix  L.neighbour_demo_pre_ineg_best5   L6.neighbour_demo_boix)  L.log_gdp i.year, fe first cluster(ccode)
testparm L.boix_demo L.boix_demo_pre_demo_ineg
display ( 2.108364    -.0474952    *ginet10a)/(1-.8960807)
display ( 2.108364    -.0474952    *ginet90a)/(1-.8960807)

estout  T64 T65 T66,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



******************************************************
*													 *
*				APPENDIX TABLES 					 *
*													 *
******************************************************


***************************
***						***
***	   	TABLE A1   		***
***						***
***************************

list  year cname pre_demo_ineg_best L.change10_ineq if acemoglu_demo==1 & L.acemoglu_demo==0  & summarystat ==1



***************************
***						***
***	   	TABLE A2   		***
***						***
***************************

* column 1
eststo TA21: xi: xtreg L.acemoglu_demo  L.neighbour_demo L6.neighbour_demo L.log_gdp L.solt_ginet  i.year if baseline2 == 1, fe cluster(ccode)
testparm L.neighbour_demo L6.neighbour_demo

* column 2
eststo TA22: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp  L.solt_ginet i.year if baseline2 == 1, fe  cluster(ccode)
testparm L.neighbour_demo L6.neighbour_demo L.neighbour_demo_pre_ineg_best

* column 3
eststo TA23: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp  L.solt_ginet i.year if baseline2 == 1, fe  cluster(ccode)
testparm L.neighbour_demo L6.neighbour_demo L.neighbour_demo_pre_ineg_best

estout  TA21 TA22 TA23,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



*******************************
***							***
***	   	TABLE A3, (5 - 8)  	***
***							***
******************************* 

* column 5
eststo TA35: xi: xtreg solt_ginet L.solt_ginet L2.solt_ginet L3.solt_ginet L4.solt_ginet L.acemoglu_demo  L.log_gdp i.year if baseline2==1, fe cluster(ccode) 

* column 6
eststo TA36: xi: xtreg solt_ginet   L.solt_ginet L2.solt_ginet L3.solt_ginet L4.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year if baseline2==1, fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.58038 - .0413749*ginet10a)/(1-.909924 + 0.0367954 - 0.0347689 + 0.025256) 
display (1.58038 - .0413749*ginet90a)/(1-.909924 + 0.0367954 - 0.0347689 + 0.025256) 

* column 7
eststo TA37: xi: xtivreg2 solt_ginet   L.solt_ginet L2.solt_ginet L3.solt_ginet L4.solt_ginet (L.acemoglu_demo  = L.neighbour_demo L6.neighbour_demo) L.log_gdp i.year if baseline2 == 1, fe first cluster(ccode)

* column 8
eststo TA38: xi: xtivreg2 solt_ginet   L.solt_ginet L2.solt_ginet L3.solt_ginet L4.solt_ginet (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo) L.log_gdp i.year if baseline2 == 1, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.60537   - .0399586 *ginet10a)/(1-.9102534 + .0363563 - .0349594 +.0253265 ) 
display (1.60537   - .0399586 *ginet90a)/(1-.9102534 + .0363563 - .0349594 +.0253265 )

estout  TA35 TA36 TA37 TA38,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A4   		***
***						***
***************************

* column 1
eststo TA41: xi: xtreg solt_ginet   L.solt_ginet L5.acemoglu_demo    L.log_gdp i.year if L5.acemoglu_demo_pre_demo_ineg_best!=. &  L5.neighbour_demo!=. & L10.neighbour_demo!=., fe  cluster(ccode)

* column 2
eststo TA42: xi: xtreg solt_ginet   L.solt_ginet    L5.acemoglu_demo L5.acemoglu_demo_pre_demo_ineg_best   L.log_gdp i.year if  L5.neighbour_demo!=. & L10.neighbour_demo!=., fe  cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_demo_pre_demo_ineg_best
display ( 0.9017675   -0.0221108*ginet10a)/(1- 0.8818335  )
display ( 0.9017675   -0.0221108*ginet90a)/(1- 0.8818335  )

* column 3
eststo TA43: xi: xtivreg2 solt_ginet   L.solt_ginet    (L5.acemoglu_demo  = L5.neighbour_demo L10.neighbour_demo)    L.log_gdp i.year if L5.acemoglu_demo_pre_demo_ineg_best!=., fe first cluster(ccode)

* column 4
eststo TA44: xi: xtivreg2 solt_ginet   L.solt_ginet    (L5.acemoglu_demo L5.acemoglu_demo_pre_demo_ineg_best = L5.neighbour_demo L5.neighbour_demo_pre_ineg_best L10.neighbour_demo)    L.log_gdp i.year, fe first cluster(ccode)
testparm L5.acemoglu_demo L5.acemoglu_demo_pre_demo_ineg_best
display ( 1.394667   -0.0306457*ginet10a)/(1- 0.8824776  )
display ( 1.394667   -0.0306457*ginet90a)/(1- 0.8824776  )

* column 5
eststo TA45: xi: xtreg solt_ginet   L.solt_ginet L10.acemoglu_demo    L.log_gdp i.year if L10.acemoglu_demo_pre_demo_ineg_best!=. &  L10.neighbour_demo!=. & L15.neighbour_demo!=., fe  cluster(ccode)

* column 6 
eststo TA46: xi: xtreg solt_ginet   L.solt_ginet    L10.acemoglu_demo L10.acemoglu_demo_pre_demo_ineg_best   L.log_gdp i.year if  L10.neighbour_demo!=. & L15.neighbour_demo!=., fe  cluster(ccode)
testparm L10.acemoglu_demo L10.acemoglu_demo_pre_demo_ineg_best
display ( 1.038629    -0.0233761 *ginet10a)/(1- 0.8814396  )
display ( 1.038629    -0.0233761 *ginet90a)/(1- 0.8814396  )

* column 7
eststo TA47: xi: xtivreg2 solt_ginet   L.solt_ginet    (L10.acemoglu_demo  = L10.neighbour_demo L15.neighbour_demo )    L.log_gdp i.year if  L10.acemoglu_demo_pre_demo_ineg_best!=., fe first cluster(ccode)

* column 8
eststo TA48: xi: xtivreg2 solt_ginet   L.solt_ginet    (L10.acemoglu_demo L10.acemoglu_demo_pre_demo_ineg_best = L10.neighbour_demo L15.neighbour_demo L10.neighbour_demo_pre_ineg_best)    L.log_gdp i.year, fe first cluster(ccode)
testparm L10.acemoglu_demo L10.acemoglu_demo_pre_demo_ineg_best
display (2.006187  -0.0572323 *ginet10a)/(1- 0.8754511)
display (2.006187  -0.0572323 *ginet90a)/(1- 0.8754511)

estout  TA41 TA42 TA43 TA44 TA45 TA46 TA47 TA48,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A5   		***
***						***
***************************

* column 1
eststo TA51: xi: xtreg L5.acemoglu_demo L5.neighbour_demo L10.neighbour_demo L.solt_ginet  L.log_gdp i.year if L5.acemoglu_demo_pre_demo_ineg_best!=. & solt_ginet!=., fe cluster(ccode)
testparm  L5.neighbour_demo L10.neighbour_demo

* column 2
eststo TA52: xi: xtreg L5.acemoglu_demo  L5.neighbour_demo L5.neighbour_demo_pre_ineg_best L10.neighbour_demo    L.solt_ginet    L.log_gdp i.year if  solt_ginet!=., fe  cluster(ccode)
testparm L5.neighbour_demo L5.neighbour_demo_pre_ineg_best L10.neighbour_demo

* column 3
eststo TA53: xi: xtreg L5.acemoglu_demo_pre_demo_ineg_best  L5.neighbour_demo L5.neighbour_demo_pre_ineg_best L10.neighbour_demo    L.solt_ginet    L.log_gdp i.year if   solt_ginet!=., fe  cluster(ccode)
testparm L5.neighbour_demo L5.neighbour_demo_pre_ineg_best L10.neighbour_demo

* column 4
eststo TA54: xi: xtreg L10.acemoglu_demo L10.neighbour_demo L15.neighbour_demo L.solt_ginet  L.log_gdp i.year if L10.acemoglu_demo_pre_demo_ineg_best!=. & solt_ginet!=., fe cluster(ccode)
testparm  L10.neighbour_demo L15.neighbour_demo

* column 5
eststo TA55: xi: xtreg L10.acemoglu_demo  L10.neighbour_demo L10.neighbour_demo_pre_ineg_best L15.neighbour_demo    L.solt_ginet    L.log_gdp i.year if  solt_ginet!=., fe  cluster(ccode)
testparm L10.neighbour_demo L10.neighbour_demo_pre_ineg_best L15.neighbour_demo

* column 6
eststo TA56: xi: xtreg L10.acemoglu_demo_pre_demo_ineg_best  L10.neighbour_demo L10.neighbour_demo_pre_ineg_best L15.neighbour_demo    L.solt_ginet    L.log_gdp i.year if   solt_ginet!=., fe  cluster(ccode)
testparm L10.neighbour_demo L10.neighbour_demo_pre_ineg_best L15.neighbour_demo

estout  TA51 TA52 TA53 TA54 TA55 TA56,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A6   		***
***						***
***************************

* column 1, Excluding USSR & Warsaw pact
eststo TA61: xi: xtreg L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if warsaw!=1 & ussr != 1 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 2, Excluding USSR & Warsaw pact
eststo TA62: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if warsaw!=1 & ussr != 1 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 3, Excluding Northern Africa and Middle East 
eststo TA63: xi: xtreg L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 3 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 4, Excluding Northern Africa and Middle East 
eststo TA64: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 3 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 5, Excluding Sub-Saharan Africa 
eststo TA65: xi: xtreg L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 4 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 6, Excluding Sub-Saharan Africa 
eststo TA66: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 4 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 7, Excluding Latin America and Carribean 
eststo TA67: xi: xtreg L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 2 & ht_region != 10 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 8, Excluding Latin America and Carribean 
eststo TA68: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 2 & ht_region != 10 & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 9, Excluding Asia and Pacific
eststo TA69: xi: xtreg L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region !=  6 & ht_region!=9 & ht_region != 8 & ht_region != 7& solt_ginet!=. & solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 10, Excluding Asia and Pacific
eststo TA610: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp    L.solt_ginet i.year  if ht_region != 6 & ht_region!=9 & ht_region != 8 & ht_region != 7& solt_ginet!=., fe cluster(ccode) 
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

estout  TA61 TA62 TA63 TA64 TA65 TA66 TA67 TA68 TA69 TA610,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A7   		***
***						***
***************************

* column 1
eststo TA71: xi:xtreg  L.demo  L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo  L.log_gdp  L.solt_ginet i.year  if solt_ginet!=. , fe  cluster(ccode)
testparm L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo

* column 2
eststo TA72: xi:xtreg  L.demo_pre_demo_ineg  L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo  L.log_gdp  L.solt_ginet i.year if solt_ginet!=. , fe  cluster(ccode)
testparm L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo

* column 3
eststo TA73: xi:xtreg L.p_polity2 L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo  L.log_gdp    L.solt_ginet i.year if solt_ginet!=. & L.ginet_polity2!=., fe  cluster(ccode)
testparm L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo

* column 4
eststo TA74: xi:xtreg  L.ginet_polity2  L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo  L.log_gdp    L.solt_ginet i.year if solt_ginet!=. , fe  cluster(ccode)
testparm L.p_neighbour_demo  L.neighbour_demo_pre_ineg_best4   L6.p_neighbour_demo

* column 5
eststo TA75: xi: xtreg L.boix_demo    L.neighbour_demo_boix  L.neighbour_demo_pre_ineg_best5   L6.neighbour_demo_boix  L.log_gdp L.solt_ginet i.year if solt_ginet!=. , fe cluster(ccode)
testparm L.neighbour_demo_boix  L.neighbour_demo_pre_ineg_best5   L6.neighbour_demo_boix

* column 6 
eststo TA76: xi: xtreg L.boix_demo_pre_demo_ineg  L.neighbour_demo_boix  L.neighbour_demo_pre_ineg_best5   L6.neighbour_demo_boix  L.log_gdp L.solt_ginet i.year if solt_ginet!=. , fe cluster(ccode)
testparm L.neighbour_demo_boix  L.neighbour_demo_pre_ineg_best5   L6.neighbour_demo_boix

estout  TA71 TA72 TA73 TA74 TA75 TA76,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A8   		***
***						***
***************************

* column 1
eststo TA81: xi: xtivreg2 solt_ginet   L.solt_ginet  L.wdi_exp   (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp  i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.5424 -.0347463 *ginet10a)/(1- .890302  )
display ( 1.5424 -.0347463 *ginet90a)/(1- .890302  )

* column 2
eststo TA82: xi: xtivreg2 solt_ginet L.solt_ginet  L.wdi_ttr (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)   L.log_gdp i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.548135  -.0347637 *ginet10a)/(1-  .8901761 )
display (1.548135  -.0347637 *ginet90a)/(1-  .8901761 )

* column 3
eststo TA83: xi: xtivreg2 solt_ginet   L.solt_ginet  L.pwt_pop (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)   L.log_gdp i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.647964  -.0405803  *ginet10a)/(1 - .890204 )
display (1.647964  -.0405803  *ginet90a)/(1 - .890204 )

* column 4
eststo TA84: xi: xtivreg2 solt_ginet   L.solt_ginet L.region_civilwar3 (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)   L.log_gdp i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.416226 -.0321934 *ginet10a)/(1-  .8923405 )
display ( 1.416226 -.0321934 *ginet90a)/(1-  .8923405 )

* column 5
eststo TA85: xi: xtivreg2 solt_ginet L.solt_ginet L.region_ginet   (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp  i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.362438 -.032524  *ginet10a)/(1- .8903527)
display ( 1.362438 -.032524  *ginet90a)/(1- .8903527)

* column 6
eststo TA86: xi: xtivreg2 solt_ginet   L.solt_ginet  L.region_ginet L.wdi_exp L.wdi_ttr  L.pwt_pop L.region_civilwar3 (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp  i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.637599  -.0372303 *ginet10a)/(1-  .884491 )
display (1.637599  -.0372303 *ginet90a)/(1-  .884491 )

estout  TA81 TA82 TA83 TA84 TA85 TA86,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************
***						***
***	   	TABLE A9   		***
***						***
*************************** 

* column 1
eststo TA91: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.wdi_exp L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 2
eststo TA92: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.wdi_exp L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 3
eststo TA93: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.wdi_ttr L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 4
eststo TA94: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.wdi_ttr L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 5
eststo TA95: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.pwt_pop L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 6
eststo TA96: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.pwt_pop L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 7
eststo TA97: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.region_civilwar3 L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 8
eststo TA98: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.region_civilwar3 L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 9
eststo TA99: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.region_ginet L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 10
eststo TA910: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.region_ginet L.solt_ginet i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 11
eststo TA911: xi: xtreg  L.acemoglu_demo  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.solt_ginet L.region_ginet L.wdi_exp L.wdi_ttr  L.pwt_pop L.region_civilwar3 i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

* column 12
eststo TA912: xi: xtreg  L.acemoglu_demo_pre_demo_ineg_best  L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo  L.log_gdp L.solt_ginet L.region_ginet L.wdi_exp L.wdi_ttr  L.pwt_pop L.region_civilwar3 i.year if solt_ginet!=., fe cluster(ccode)
testparm L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo

estout  TA91 TA92 TA93 TA94 TA95 TA96 TA97 TA98 TA99 TA910 TA911 TA912,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend



***************************************************
***												***
***	   	Fig.4, Tab.A16, Tab.A17, & Fig.A1   	***
***												***
***************************************************

sort ccode year
gen solt_fiscal = 100*((solt_ginmar - solt_ginet)/solt_ginmar)

generate acemoglu_demo1 = acemoglu_demo
generate acemoglu_demo9 = acemoglu_demo
generate acemoglu_demo3 = acemoglu_demo
generate acemoglu_demo4 = acemoglu_demo
generate acemoglu_demo5 = acemoglu_demo
generate acemoglu_demo6 = acemoglu_demo
generate acemoglu_demo7 = acemoglu_demo
generate acemoglu_demo8 = acemoglu_demo

replace rpe_gdp = rpe_gdp*10

***************************
***						***
***	   	TABLE A16  		***
***						***
***************************

* column 1
eststo TA161: xi: xtreg solt_fiscal L.solt_fiscal L5.acemoglu_demo1 L.log_gdp i.year if L5.pre_demo_ineg_best<=38.55 & L5.pre_demo_ineg_best!=. & summarystat==1, fe cluster(ccode) 

* column 2
eststo TA162: xi: xtreg solt_fiscal L.solt_fiscal L5.acemoglu_demo1 L.log_gdp i.year if L5.pre_demo_ineg_best>38.55 & L5.pre_demo_ineg_best!=.  & summarystat==1, fe cluster(ccode)

* column 3
eststo TA163: xi: xtreg rpe_gdp L.rpe_gdp L5.acemoglu_demo L.log_gdp i.year if L5.pre_demo_ineg_best<=38.55 & L5.pre_demo_ineg_best!=. & summarystat==1, fe cluster(ccode)

* column 4
eststo TA164: xi: xtreg  rpe_gdp L.rpe_gdp L5.acemoglu_demo L.log_gdp i.year if L5.pre_demo_ineg_best>38.55 & L5.pre_demo_ineg_best!=. & summarystat==1, fe cluster(ccode)

* column 5
eststo TA165: xi: xtreg wdi_mort L.wdi_mort L5.acemoglu_demo9 L.log_gdp i.year if L5.pre_demo_ineg_best<=38.55 & L5.pre_demo_ineg_best!=.& summarystat==1 , fe cluster(ccode)

* column 6
eststo TA166: xi: xtreg  wdi_mort L.wdi_mort L5.acemoglu_demo9 L.log_gdp i.year if L5.pre_demo_ineg_best>38.55 & L5.pre_demo_ineg_best!=.  & summarystat==1, fe cluster(ccode)

estout  TA161 TA162 TA163 TA164 TA165 TA166,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend
	  
 
 
***************************
***						***
***	   	TABLE A17  		***
***						***
***************************

* column 1 
eststo TA171: xi: xtreg fi_reg_cl L5.fi_reg_cl L5.acemoglu_demo6 L5.log_gdp i.year if  fiveyear==1 & pre_demo_ineg_best<=38.55 & pre_demo_ineg_best!=. , fe cluster(ccode)

* column 2
eststo TA172: xi: xtreg fi_reg_cl L5.fi_reg_cl L5.acemoglu_demo6 L5.log_gdp i.year if  fiveyear==1 & pre_demo_ineg_best>38.55 & pre_demo_ineg_best!=. , fe cluster(ccode)

* column 3
eststo TA173: xi: xtreg fi_legprop_cl L5.fi_legprop_cl L5.acemoglu_demo7 L5.log_gdp i.year if  fiveyear==1 & pre_demo_ineg_best<=38.55 & pre_demo_ineg_best!=. , fe cluster(ccode)

* column 4
eststo TA174: xi: xtreg fi_legprop_cl L5.fi_legprop_cl L5.acemoglu_demo7 L5.log_gdp i.year if  fiveyear==1 & pre_demo_ineg_best>38.55 & pre_demo_ineg_best!=. , fe cluster(ccode)

* column 5
eststo TA175: xi: xtreg fi_ftradeint_cl L5.fi_ftradeint_cl L5.acemoglu_demo8 L5.log_gdp i.year if  fiveyear==1 & pre_demo_ineg_best<=38.55 & pre_demo_ineg_best!=. , fe cluster(ccode)

* column 6
eststo TA176: xi: xtreg fi_ftradeint_cl L5.fi_ftradeint_cl L5.acemoglu_demo8 L5.log_gdp i.year if  fiveyear==1 & pre_demo_ineg_best>38.55 & pre_demo_ineg_best!=. , fe cluster(ccode)

estout  TA171 TA172 TA173 TA174 TA175 TA176,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend


***************************
***						***
***	   	FIGURE 4   		***
***						***
***************************

coefplot (TA161 TA163 TA165  TA171 TA173 TA175, label(Low Inequality))(TA162 TA164  TA166   TA172 TA174 TA176, label(High Inequality)), drop(_cons L5.fi_reg_cl L5.fi_legprop_cl L5.fi_ftradeint_cl L.une_pet L.une_set L.une_tet L.wdi_mort L.rpe_gdp L.solt_redist L.solt_fiscal L.log_gdp L5.log_gdp _Iyear*) level(95) xline(0) ciopts(recast(rcap)) scheme(s2mono) graphregion(fcolor(white)) coeflabel(L5.acemoglu_demo1 = "Fiscal redistribution" L5.acemoglu_demo = "State capacity" L5.acemoglu_demo9 = "Infant mortality" L5.acemoglu_demo3 = "Primary education rate" L5.acemoglu_demo4 = "Secondary education rate" L5.acemoglu_demo5 = "Tertiary education rate" L5.acemoglu_demo6 = "Regulatory quality" L5.acemoglu_demo7 = "Property rights" L5.acemoglu_demo8 = "Freedom to trade") headings(L5.acemoglu_demo1 = "{bf:Fiscal policy and health}" L5.acemoglu_demo3 = "{bf:Education rates}" L5.acemoglu_demo6 = "{bf:Economic freedoms}") 


***************************
***						***
***	   	FIGURE A1  		***
***						***
***************************

display 1 - (0.05 / 6)

coefplot (TA161 TA163 TA165  TA171 TA173 TA175, label(Low Inequality))(TA162 TA164  TA166   TA172 TA174 TA176, label(High Inequality)), drop(_cons L5.fi_reg_cl L5.fi_legprop_cl L5.fi_ftradeint_cl L.une_pet L.une_set L.une_tet L.wdi_mort L.rpe_gdp L.solt_redist L.solt_fiscal L.log_gdp L5.log_gdp _Iyear*) level(99.1) xline(0) ciopts(recast(rcap)) scheme(s2mono) graphregion(fcolor(white)) coeflabel(L5.acemoglu_demo1 = "Fiscal redistribution" L5.acemoglu_demo = "State capacity" L5.acemoglu_demo9 = "Infant mortality" L5.acemoglu_demo3 = "Primary education rate" L5.acemoglu_demo4 = "Secondary education rate" L5.acemoglu_demo5 = "Tertiary education rate" L5.acemoglu_demo6 = "Regulatory quality" L5.acemoglu_demo7 = "Property rights" L5.acemoglu_demo8 = "Freedom to trade") headings(L5.acemoglu_demo1 = "{bf:Fiscal policy and health}" L5.acemoglu_demo3 = "{bf:Education rates}" L5.acemoglu_demo6 = "{bf:Economic freedoms}") 



***************************
***						***
***	   	TABLE A11  		***
***						***
***************************

* column 1
xi: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year if L.neighbour_demo!=. &  L6.neighbour_demo!=., fe  cluster(ccode)
display ( 1.464707  -.0375354  *ginet10a)/(1- 0.892435)
display ( 1.464707  -.0375354  *ginet90a)/(1- 0.892435)

* column 4
xi: xtivreg2 solt_ginet   L.solt_ginet  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo  L.neighbour_demo_pre_ineg_best L6.neighbour_demo) L.log_gdp i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.446069  -.0344763  *ginet10a)/(1- 0.893034)
display ( 1.446069  -.0344763  *ginet90a)/(1- 0.893034)

* column 2
jackknife coef1=_b[L.solt_ginet] coef2=_b[L.acemoglu_demo] coef3=_b[L.acemoglu_demo_pre_demo_ineg_best] coef4=_b[L.log_gdp],  cluster(ccode) keep: xtreg solt_ginet   L.solt_ginet  L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year if L6.neighbour_demo!=. , fe  cluster(ccode)
mat list e(b_jk) 
display ( 1.4067828 -.03622305 *ginet10a)/(1-0.89547331)
display ( 1.4067828 -.03622305 *ginet90a)/(1-0.89547331)
testparm coef1 coef2

* column 5
xi: jackknife coef12=_b[L.solt_ginet] coef22=_b[L.acemoglu_demo] coef32=_b[L.acemoglu_demo_pre_demo_ineg_best] coef42=_b[L.log_gdp] ,  cluster(ccode) keep: xtivreg2 solt_ginet   L.solt_ginet     (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best =L.neighbour_demo L6.neighbour_demo L.neighbour_demo_pre_ineg_best)   L.log_gdp i.year, fe  cluster(ccode)
mat list e(b_jk)
display (1.4225052 -.03387861   *ginet10a)/(1-.89672767)
display (1.4225052 -.03387861   *ginet90a)/(1-.89672767)
testparm coef22 coef32

gen trans = 0  if acemoglu_demo!=.
replace trans = 1 if acemoglu_demo ==1 & L.acemoglu_demo==0

list cname ccode year if trans == 1 & L.neighbour_demo!=. & L6.neighbour_demo!=. & L.solt_ginet!=. & L.acemoglu_demo_pre_demo_ineg_best!=.

gen ccode_trans = 0
replace ccode_trans = ccode if ccode == 8
replace ccode_trans = ccode if ccode == 32
replace ccode_trans = ccode if ccode == 50 
replace ccode_trans = ccode if ccode == 51
replace ccode_trans = ccode if ccode == 64
replace ccode_trans = ccode if ccode == 76
replace ccode_trans = ccode if ccode == 100
replace ccode_trans = ccode if ccode == 108
replace ccode_trans = ccode if ccode == 140
replace ccode_trans = ccode if ccode == 144
replace ccode_trans = ccode if ccode == 152
replace ccode_trans = ccode if ccode == 158
replace ccode_trans = ccode if ccode == 191
replace ccode_trans = ccode if ccode == 200
replace ccode_trans = ccode if ccode == 242
replace ccode_trans = ccode if ccode == 262
replace ccode_trans = ccode if ccode == 288
replace ccode_trans = ccode if ccode == 320
replace ccode_trans = ccode if ccode == 324
replace ccode_trans = ccode if ccode == 332
replace ccode_trans = ccode if ccode == 348
replace ccode_trans = ccode if ccode == 360
replace ccode_trans = ccode if ccode == 404
replace ccode_trans = ccode if ccode == 410
replace ccode_trans = ccode if ccode == 417
replace ccode_trans = ccode if ccode == 422
replace ccode_trans = ccode if ccode == 426
replace ccode_trans = ccode if ccode == 450
replace ccode_trans = ccode if ccode == 454
replace ccode_trans = ccode if ccode == 458
replace ccode_trans = ccode if ccode == 462
replace ccode_trans = ccode if ccode == 478
replace ccode_trans = ccode if ccode == 484
replace ccode_trans = ccode if ccode == 524
replace ccode_trans = ccode if ccode == 562
replace ccode_trans = ccode if ccode == 566
replace ccode_trans = ccode if ccode == 586
replace ccode_trans = ccode if ccode == 591
replace ccode_trans = ccode if ccode == 604
replace ccode_trans = ccode if ccode == 608
replace ccode_trans = ccode if ccode == 616
replace ccode_trans = ccode if ccode == 620
replace ccode_trans = ccode if ccode == 624
replace ccode_trans = ccode if ccode == 642
replace ccode_trans = ccode if ccode == 686
replace ccode_trans = ccode if ccode == 694
replace ccode_trans = ccode if ccode == 710
replace ccode_trans = ccode if ccode == 724
replace ccode_trans = ccode if ccode == 736
replace ccode_trans = ccode if ccode == 764
replace ccode_trans = ccode if ccode == 858
replace ccode_trans = ccode if ccode == 894

* column 3
jackknife coef13=_b[L.solt_ginet] coef23=_b[L.acemoglu_demo] coef33=_b[L.acemoglu_demo_pre_demo_ineg_best] coef43=_b[L.log_gdp],  cluster(ccode_trans) keep: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year if L.neighbour_demo!=. & L6.neighbour_demo!=. , fe  robust
mat list e(b_jk)
display (1.1975215    -.03290837 *ginet10a)/(1-.90108451  )
display (1.1975215    -.03290837 *ginet90a)/(1-.90108451  )
testparm coef23 coef33

* column 6
xi: jackknife coef14=_b[L.solt_ginet] coef24=_b[L.acemoglu_demo] coef34=_b[L.acemoglu_demo_pre_demo_ineg_best] coef44=_b[L.log_gdp],  cluster(ccode_trans) keep: xtivreg2 solt_ginet   L.solt_ginet   (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best =L.neighbour_demo L6.neighbour_demo L.neighbour_demo_pre_ineg_best)   L.log_gdp i.year, fe  robust
mat list e(b_jk)
display ( 0.89577983 -.0266138 *ginet10a)/(1- 0.90580668 )
display ( 0.89577983 -.0266138 *ginet90a)/(1- 0.90580668 )
testparm coef24 coef34



***************************
***						***
***	   	TABLE A12  		***
***						***
***************************

tsset ccode year

xi: gen Lacemoglu_demo = L.acemoglu_demo
xi: gen Lacemoglu_demo_pre_demo_ineg = L.acemoglu_demo_pre_demo_ineg_best
xi: gen Llog_gdp = L.log_gdp
xi: gen Lsolt_ginet = L.solt_ginet
xi: gen L2solt_ginet = L2.solt_ginet
xi: gen L3solt_ginet = L3.solt_ginet
xi: gen L4solt_ginet = L4.solt_ginet

set emptycells drop

* column 1
eststo TA121: xi: xtreg solt_ginet   L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp i.year, fe cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.356003 - .0351739*ginet10a)/(1-.890665 ) 
display (1.356003 - .0351739*ginet90a)/(1-.890665 ) 


* column 2
eststo TA122: xi: xtlsdvc solt_ginet  Lacemoglu_demo Lacemoglu_demo_pre_demo_ineg Llog_gdp i.year, initial(ab) bias(3) vcov(50)
testparm Lacemoglu_demo Lacemoglu_demo_pre_demo_ineg
display ( 1.111947 -.028847   *ginet10a)/(1-0.941365)
display ( 1.111947 -.028847   *ginet90a)/(1-0.941365)
  
* column 3 
eststo TA123: xi: xtabond2 solt_ginet L.solt_ginet  L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp  i.year, gmm(L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best  L.log_gdp, collapse equation(both) )  iv(i.year) robust small two orthog artests(2)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.242831    -.0349585  *ginet10a)/(1-.9567136   )
display ( 1.242831    -.0349585  *ginet90a)/(1-.9567136   )

* column 4 
eststo TA124: xi:  xtabond2 solt_ginet L.solt_ginet   L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp  i.year, gmm(L.solt_ginet  L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best  L.log_gdp,laglimits(2 .) collapse equation(both) )  iv(i.year) robust small two orthog artests(3)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.182489  -.0344349    *ginet10a)/(1-.9758638  )
display ( 1.182489  -.0344349    *ginet90a)/(1-.9758638  )

* column 5 
eststo TA125: xi: xtabond2 solt_ginet L.solt_ginet   L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp  i.year, gmm(L.solt_ginet  L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best  L.log_gdp,laglimits(3 .) collapse equation(both) )  iv(i.year) robust small two orthog artests(3)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.528913   -.0417696    *ginet10a)/(1-.9684872   )
display ( 1.528913   -.0417696    *ginet90a)/(1-.9684872   )

* column 6 
eststo TA126: xi: xtabond2 solt_ginet L.solt_ginet  L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best L.log_gdp  i.year, gmm(L.solt_ginet L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best  L.log_gdp, laglimits(2 .) collapse equation(diff) )  iv(i.year) robust small two orthog artests(3)
testparm  L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display ( 1.693477  -.0488192   *ginet10a)/(1-.9487942   )
display ( 1.693477  -.0488192   *ginet90a)/(1-.9487942   )

estout  TA121 TA122 TA123 TA124 TA125 TA126,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend




*******************************
***							***
***		TABLE A14, (3 - 4) 	***
***							***
*******************************

* column 3
eststo TA143: xi: xtivreg2 solt_ginet   L.solt_ginet L.acemoglu_demo_military L.acemoglu_demo_monarchy L.acemoglu_demo_party   (L.acemoglu_demo =   L.neighbour_demo L6.neighbour_demo)  L.log_gdp  i.year if L.acemoglu_demo_pre_demo_ineg_best!=., fe first cluster(ccode)

* column 4
eststo TA144: xi: xtivreg2 solt_ginet   L.solt_ginet L.acemoglu_demo_military L.acemoglu_demo_monarchy L.acemoglu_demo_party  (L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best = L.neighbour_demo L.neighbour_demo_pre_ineg_best L6.neighbour_demo)  L.log_gdp  i.year, fe first cluster(ccode)
testparm L.acemoglu_demo L.acemoglu_demo_pre_demo_ineg_best
display (1.454628     -.0348487   *ginet10a)/(1-.8930098)
display (1.454628     -.0348487   *ginet90a)/(1-.8930098)

estout  TA143 TA144,  style(tex) cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N R2, fmt(0 3)) margin legend

