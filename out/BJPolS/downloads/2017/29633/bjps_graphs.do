use bjps/gh_bjps.dta , clear


xtset directed_dyadid year
replace importsAB_usd_r2 =importsAB_usd_r2*10 if ccode1==255 & year==1923

sort directed_dyadid year
by directed_dyadid : egen meanM = mean(importsAB_usd_r2)
gen dM = importsAB_usd_r2- meanM
sort ccode1 year
by ccode1 : egen everaxisA = max(WWIaxisa)
by ccode1 : egen everentA = max(WWIententea)
by ccode1 : egen everneuA = max(WWIneua)
by ccode1 : egen everscandA = max(scandneua)
gen everothA = everaxisA==0 & everentA==0 & everneuA==0

sort ccode2 year
by ccode2 : egen everaxisB = max(WWIaxisb)
by ccode2 : egen everentB = max(WWIententeb)
by ccode2 : egen everneuB = max(WWIneub)
by ccode2 : egen everscandB = max(scandneub)
gen everothB = everaxisB==0 & everentB==0 & everneuB==0

gen postAH1 = (ccode1==305|ccode1==310|ccode1==315|ccode1==290)
gen postAH2 = (ccode2==305|ccode2==310|ccode2==315|ccode2==290)

replace everaxisA = 1 if postAH1==1
replace everaxisB = 1 if postAH2==1

gen unX = .

replace unX = 	10100	if year==	1900
replace unX = 	10200	if year==	1901
replace unX = 	10400	if year==	1902
replace unX = 	11100	if year==	1903
replace unX = 	11500	if year==	1904
replace unX = 	12300	if year==	1905
replace unX = 	13700	if year==	1906
replace unX = 	14500	if year==	1907
replace unX = 	13600	if year==	1908
replace unX = 	14500	if year==	1909
replace unX = 	15900	if year==	1910
replace unX = 	16800	if year==	1911
replace unX = 	18300	if year==	1912
replace unX = 	19500	if year==	1913
replace unX = 	19700	if year==	1921
replace unX = 	21700	if year==	1922
replace unX = 	24500	if year==	1923
replace unX = 	27400	if year==	1924
replace unX = 	31400	if year==	1925
replace unX = 	29800	if year==	1926
replace unX = 	31400	if year==	1927
replace unX = 	32700	if year==	1928
replace unX = 	33000	if year==	1929

preserve
drop if imp_k2==. | imp_k2==0
collapse (sum) dM imp_k2 importsAB_usd_r2  (mean) unX imp_mean=imp_k2 cpi (count) cty=imp_k2, by(year)
replace unX = . if year>=1914 & year<=1920
gen unX_k = unX/(cpi/100)
line imp_k2 year , lcolor(black ) legend(label(1 "Author Imports"))   ///
   ytitle("Imports (in million constant US$)") xtitle("") xline(1914) xline(1918) xlabel(1900(5)1930) ///
    saving(bjps/graph1.gph, replace) scheme(s2mono)
graph export bjps/graph1.eps, replace  
  restore
  
  preserve
keep if (everentA==1  & everaxisB==1) | (everaxisA==1& everentB==1) /*everaxisA*/
gen enemy = 1
drop if imp_k2==.
collapse (sum) dM imp_k2 importsAB_usd_r2 (count) cty=imp_k2 (mean) imp=imp_k2 , by(enemy year)
line imp_k2 year ,  xline(1914) xline(1918) scheme(s2mono) ///
   ytitle("Sum of imports (millions of constant US $)") xlabel(1900(10) 1930) saving(bjps/graph2.gph, replace)
graph export bjps/graph2.eps, replace  
restore

preserve
keep if everentA==1 | everentB==1 /*everaxisA*/

gen everent = (everentA==1 & everentB==1)
replace everent = 2 if (everentA==1 & everneuB==1) | (everentB==1 & everneuA==1)
replace everent = 4 if (everentA==1 & everaxisA==1) | (everentB==1 & everaxisA==1)
replace everent = 3 if everent==0

collapse (sum) dM imp_k2 importsAB_usd_r2 (mean) imp = imp_k2, by(everent year)

line imp_k2 year if everent==1 , lpattern(solid)  ///
   legend(label(1 "Entente-Entente") )  xlabel(1900(10)1930) xline(1914) xline(1918)  ytitle("Sum of imports (millions of constant US $)") ///
    saving(bjps/graph3.gph, replace)  scheme(s2mono) 
graph export bjps/graph3.eps, replace  
   restore
   
preserve
drop if imp_k2==. | imp_k2==0
collapse (sum) dM imp_k2 importsAB_usd_r2 (mean) unX imp_mean=imp_k2 cpi (count) cty=imp_k2, by(year)
replace unX = . if year>=1914 & year<=1920
gen unX_k = unX/(cpi/100)
line unX  year if year<=1913 , lcolor(black) lpattern(dash) || line unX  year if  year>=1921 , lpattern(dash) lcolor(black) || line importsAB_usd_r2 year , ///
  /*lcolor(red )*/ lpattern(solid) legend(label(1 "UN Exports") label(3 "Author Imports") order(1 3)) scheme(s2mono) ///
  saving(bjps/appendixD.gph, replace) ytitle("Value (in million US$)") xtitle("") xline(1914) xline(1918) xlabel(1900(5)1930)
graph export bjps/appendixD.eps, replace  

  restore
  
  
