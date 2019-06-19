global x "$masterpath/datafiles/"

use $masterpath/07202014/sic87_3-man7090, clear
rename sic87 sic3dig
sort sic3dig 
*************************************************
* Many 3-digit SIC codes for each man7090 code: *
* choose 3-digit SIC code that matches w/sitc3  *
*************************************************
*man7090=8: sic3dig==207 & sic3dig==209
drop if man7090==8 & sic3dig==207
*man7090=9: sic3dig==211 & sic3dig==212 & sic3dig==213 & sic3dig==214
drop if (man7090==9 & sic3dig==211) | (man7090==9 & sic3dig==212) | (man7090==9 & sic3dig==213)
*man7090=13: sic3dig==221 & sic3dig==222 & sic3dig==223 & sic3dig==224 & sic3dig==228 
drop if (man7090==13 & sic3dig==221) | (man7090==13 & sic3dig==222) | (man7090==13 & sic3dig==224) | (man7090==13 & sic3dig==228)
*man7090=15: sic3dig==231 & sic3dig==232 & sic3dig==233 & sic3dig==234 & sic3dig==235 & sic3dig==236 & sic3dig==237 & sic3dig==238 
drop if (man7090==15 & sic3dig==231) | (man7090==15 & sic3dig==232) | (man7090==15 & sic3dig==233) | (man7090==15 & sic3dig==234) | (man7090==15 & sic3dig==236) | (man7090==15 & sic3dig==237) | (man7090==15 & sic3dig==238)
*man7090=17: sic3dig==261 & sic3dig==262 & sic3dig==263
drop if (man7090==17 & sic3dig==261) | (man7090==17 & sic3dig==262) 
*man7090=21: sic3dig==272 & sic3dig==273 & sic3dig==274 & sic3dig==275 & sic3dig==276 & sic3dig==277 & sic3dig==278 & sic3dig==279 
drop if (man7090==21 & sic3dig==272) | (man7090==21 & sic3dig==274) | (man7090==21 & sic3dig==275) | (man7090==21 & sic3dig==276) | (man7090==21 & sic3dig==277) | (man7090==21 & sic3dig==278) | (man7090==21 & sic3dig==279)
*man7090=27: sic3dig==281 & sic3dig==286 & sic3dig==289 & sic3dig==291 
drop if (man7090==27 & sic3dig==281) | (man7090==27 & sic3dig==289) | (man7090==27 & sic3dig==291)
*man7090=29: sic3dig==295 & sic3dig==299 & sic3dig==305    
drop if (man7090==29 & sic3dig==295) | (man7090==29 & sic3dig==305) 
*man7090=30: sic3dig==301 & sic3dig==302 & sic3dig==305 & sic3dig==306       
drop if (man7090==30 & sic3dig==302) | (man7090==30 & sic3dig==305) | (man7090==30 & sic3dig==306) 
*man7090=33: sic3dig==313 & sic3dig==314        
drop if (man7090==33 & sic3dig==314)
*man7090=34: sic3dig==315 & sic3dig==316 & sic3dig==317 & sic3dig==319 
drop if (man7090==34 & sic3dig==316) | (man7090==34 & sic3dig==317) | (man7090==34 & sic3dig==319)
*man7090=36: sic3dig==242 & sic3dig==243        
drop if (man7090==36 & sic3dig==242)
*man7090=37: sic3dig==244 & sic3dig==249       
drop if (man7090==37 & sic3dig==244)
*man7090=38: sic3dig==251 & sic3dig==252 & sic3dig==253 & sic3dig==254 & sic3dig==259
drop if (man7090==38 & sic3dig==251) | (man7090==38 & sic3dig==252) | (man7090==38 & sic3dig==253) | (man7090==38 & sic3dig==254)
*man7090=39: sic3dig==321 & sic3dig==322 & sic3dig==323
drop if (man7090==39 & sic3dig==321) | (man7090==39 & sic3dig==323) 
*man7090=40: sic3dig==324 & sic3dig==327  
drop if (man7090==40 & sic3dig==324)
*man7090=43: sic3dig==328 & sic3dig==329
drop if (man7090==43 & sic3dig==328)
*man7090=46: sic3dig==333 & sic3dig==334 & sic3dig==335 & sic3dig==336 & sic3dig==339
drop if (man7090==46 & sic3dig==333) | (man7090==46 & sic3dig==334) | (man7090==46 & sic3dig==335) | (man7090==46 & sic3dig==336)
*man7090=51: sic3dig==347 & sic3dig==341 & sic3dig==343 & sic3dig==349 
drop if (man7090==51 & sic3dig==347) | (man7090==51 & sic3dig==341) | (man7090==51 & sic3dig==343)
*man7090=57: sic3dig==355 & sic3dig==356 & sic3dig==358 & sic3dig==359 
drop if (man7090==57 & sic3dig==355) | (man7090==57 & sic3dig==356) | (man7090==57 & sic3dig==359)
*man7090=60: sic3dig==361 & sic3dig==362 & sic3dig==364 & sic3dig==367 & sic3dig==369 
drop if (man7090==60 & sic3dig==362) | (man7090==60 & sic3dig==364) | (man7090==60 & sic3dig==367) | (man7090==60 & sic3dig==369)
*man7090=64: sic3dig==348 & sic3dig==372 & sic3dig==376  
drop if (man7090==64 & sic3dig==348) | (man7090==64 & sic3dig==376) 
*man7090=65: sic3dig==245 & sic3dig==375 & sic3dig==379 
drop if (man7090==65 & sic3dig==375) | (man7090==65 & sic3dig==379) 
*man7090=66: sic3dig==365 & sic3dig==366 & sic3dig==381 & sic3dig==382         
drop if (man7090==66 & sic3dig==365) | (man7090==66 & sic3dig==366) | (man7090==66 & sic3dig==382)
*man7090=67: sic3dig==384 & sic3dig==385 
drop if (man7090==67 & sic3dig==385)
*man7090=70: sic3dig==391 & sic3dig==393 & sic3dig==394 & sic3dig==395 & sic3dig==396 & sic3dig==399 
drop if (man7090==70 & sic3dig==391) | (man7090==70 & sic3dig==393) | (man7090==70 & sic3dig==394) | (man7090==70 & sic3dig==395) | (man7090==70 & sic3dig==399)
merge sic3dig using ${x}3digit
tab _merge
drop if _merge==1 /* year==. */
drop if _merge==2 /* man7090==. */
***********************************************************************************
* Assume that exports or imports are very small if the price indices do not exist *
* Assume this means zero exposure at the occupation level
***********************************************************************************
*************************************************************
* Decide whether to assign expfin=0 if expfin=. & impfin~=. *
* Decide whether to assign impfin=0 if impfin=. & expfin~=. *
*************************************************************
replace expfin=0 if expfin==. 
replace impfin=0 if impfin==.
keep sic3dig year man7090 expfin impfin 
sort man7090 year 
save ${x}man7090_sic3, replace


use $masterpath/07202014/sic87_3-man7090, clear
rename sic87 sic3dig
sort sic3dig 
*************************************************
* Many 3-digit SIC codes for each man7090 code: *
* choose 3-digit SIC code that matches w/sitc3  *
*************************************************
*man7090=8: sic3dig==207 & sic3dig==209
drop if man7090==8 & sic3dig==207
*man7090=9: sic3dig==211 & sic3dig==212 & sic3dig==213 & sic3dig==214
drop if (man7090==9 & sic3dig==211) | (man7090==9 & sic3dig==212) | (man7090==9 & sic3dig==213)
*man7090=13: sic3dig==221 & sic3dig==222 & sic3dig==223 & sic3dig==224 & sic3dig==228 
drop if (man7090==13 & sic3dig==221) | (man7090==13 & sic3dig==222) | (man7090==13 & sic3dig==224) | (man7090==13 & sic3dig==228)
*man7090=15: sic3dig==231 & sic3dig==232 & sic3dig==233 & sic3dig==234 & sic3dig==235 & sic3dig==236 & sic3dig==237 & sic3dig==238 
drop if (man7090==15 & sic3dig==231) | (man7090==15 & sic3dig==232) | (man7090==15 & sic3dig==233) | (man7090==15 & sic3dig==234) | (man7090==15 & sic3dig==236) | (man7090==15 & sic3dig==237) | (man7090==15 & sic3dig==238)
*man7090=17: sic3dig==261 & sic3dig==262 & sic3dig==263
drop if (man7090==17 & sic3dig==261) | (man7090==17 & sic3dig==262) 
*man7090=21: sic3dig==272 & sic3dig==273 & sic3dig==274 & sic3dig==275 & sic3dig==276 & sic3dig==277 & sic3dig==278 & sic3dig==279 
drop if (man7090==21 & sic3dig==272) | (man7090==21 & sic3dig==274) | (man7090==21 & sic3dig==275) | (man7090==21 & sic3dig==276) | (man7090==21 & sic3dig==277) | (man7090==21 & sic3dig==278) | (man7090==21 & sic3dig==279)
*man7090=27: sic3dig==281 & sic3dig==286 & sic3dig==289 & sic3dig==291 
drop if (man7090==27 & sic3dig==281) | (man7090==27 & sic3dig==289) | (man7090==27 & sic3dig==291)
*man7090=29: sic3dig==295 & sic3dig==299 & sic3dig==305    
drop if (man7090==29 & sic3dig==295) | (man7090==29 & sic3dig==305) 
*man7090=30: sic3dig==301 & sic3dig==302 & sic3dig==305 & sic3dig==306       
drop if (man7090==30 & sic3dig==302) | (man7090==30 & sic3dig==305) | (man7090==30 & sic3dig==306) 
*man7090=33: sic3dig==313 & sic3dig==314        
drop if (man7090==33 & sic3dig==314)
*man7090=34: sic3dig==315 & sic3dig==316 & sic3dig==317 & sic3dig==319 
drop if (man7090==34 & sic3dig==316) | (man7090==34 & sic3dig==317) | (man7090==34 & sic3dig==319)
*man7090=36: sic3dig==242 & sic3dig==243        
drop if (man7090==36 & sic3dig==242)
*man7090=37: sic3dig==244 & sic3dig==249       
drop if (man7090==37 & sic3dig==244)
*man7090=38: sic3dig==251 & sic3dig==252 & sic3dig==253 & sic3dig==254 & sic3dig==259
drop if (man7090==38 & sic3dig==251) | (man7090==38 & sic3dig==252) | (man7090==38 & sic3dig==253) | (man7090==38 & sic3dig==254)
*man7090=39: sic3dig==321 & sic3dig==322 & sic3dig==323
drop if (man7090==39 & sic3dig==321) | (man7090==39 & sic3dig==323) 
*man7090=40: sic3dig==324 & sic3dig==327  
drop if (man7090==40 & sic3dig==324)
*man7090=43: sic3dig==328 & sic3dig==329
drop if (man7090==43 & sic3dig==328)
*man7090=46: sic3dig==333 & sic3dig==334 & sic3dig==335 & sic3dig==336 & sic3dig==339
drop if (man7090==46 & sic3dig==333) | (man7090==46 & sic3dig==334) | (man7090==46 & sic3dig==335) | (man7090==46 & sic3dig==336)
*man7090=51: sic3dig==347 & sic3dig==341 & sic3dig==343 & sic3dig==349 
drop if (man7090==51 & sic3dig==347) | (man7090==51 & sic3dig==341) | (man7090==51 & sic3dig==343)
*man7090=57: sic3dig==355 & sic3dig==356 & sic3dig==358 & sic3dig==359 
drop if (man7090==57 & sic3dig==355) | (man7090==57 & sic3dig==356) | (man7090==57 & sic3dig==359)
*man7090=60: sic3dig==361 & sic3dig==362 & sic3dig==364 & sic3dig==367 & sic3dig==369 
drop if (man7090==60 & sic3dig==362) | (man7090==60 & sic3dig==364) | (man7090==60 & sic3dig==367) | (man7090==60 & sic3dig==369)
*man7090=64: sic3dig==348 & sic3dig==372 & sic3dig==376  
drop if (man7090==64 & sic3dig==348) | (man7090==64 & sic3dig==376) 
*man7090=65: sic3dig==245 & sic3dig==375 & sic3dig==379 
drop if (man7090==65 & sic3dig==375) | (man7090==65 & sic3dig==379) 
*man7090=66: sic3dig==365 & sic3dig==366 & sic3dig==381 & sic3dig==382         
drop if (man7090==66 & sic3dig==365) | (man7090==66 & sic3dig==366) | (man7090==66 & sic3dig==382)
*man7090=67: sic3dig==384 & sic3dig==385 
drop if (man7090==67 & sic3dig==385)
*man7090=70: sic3dig==391 & sic3dig==393 & sic3dig==394 & sic3dig==395 & sic3dig==396 & sic3dig==399 
drop if (man7090==70 & sic3dig==391) | (man7090==70 & sic3dig==393) | (man7090==70 & sic3dig==394) | (man7090==70 & sic3dig==395) | (man7090==70 & sic3dig==399)
merge sic3dig using ${x}2digit
tab _merge
drop if _merge==1 /* year==. */
drop if _merge==2 /* man7090==. */
***********************************************************************************
* Assume that exports or imports are very small if the price indices do not exist *
* Assume this means zero exposure at the occupation level
***********************************************************************************
*************************************************************
* Decide whether to assign expfin=0 if expfin=. & impfin~=. *
* Decide whether to assign impfin=0 if impfin=. & expfin~=. *
*************************************************************
replace expfin=0 if expfin==. 
replace impfin=0 if impfin==.
keep sic3dig year man7090 expfin impfin
sort man7090 year 
save ${x}man7090_sic2, replace


use $masterpath/prices/sic87_3-man7090.dta


rename sic87 sic3dig
sort sic3dig 
*************************************************
* Many 3-digit SIC codes for each man7090 code: *
* choose 3-digit SIC code that matches w/sitc3  *
*************************************************
*man7090=8: sic3dig==207 & sic3dig==209
drop if man7090==8 & sic3dig==207
*man7090=9: sic3dig==211 & sic3dig==212 & sic3dig==213 & sic3dig==214
drop if (man7090==9 & sic3dig==211) | (man7090==9 & sic3dig==212) | (man7090==9 & sic3dig==213)
*man7090=13: sic3dig==221 & sic3dig==222 & sic3dig==223 & sic3dig==224 & sic3dig==228 
drop if (man7090==13 & sic3dig==221) | (man7090==13 & sic3dig==222) | (man7090==13 & sic3dig==224) | (man7090==13 & sic3dig==228)
*man7090=15: sic3dig==231 & sic3dig==232 & sic3dig==233 & sic3dig==234 & sic3dig==235 & sic3dig==236 & sic3dig==237 & sic3dig==238 
drop if (man7090==15 & sic3dig==231) | (man7090==15 & sic3dig==232) | (man7090==15 & sic3dig==233) | (man7090==15 & sic3dig==234) | (man7090==15 & sic3dig==236) | (man7090==15 & sic3dig==237) | (man7090==15 & sic3dig==238)
*man7090=17: sic3dig==261 & sic3dig==262 & sic3dig==263
drop if (man7090==17 & sic3dig==261) | (man7090==17 & sic3dig==262) 
*man7090=21: sic3dig==272 & sic3dig==273 & sic3dig==274 & sic3dig==275 & sic3dig==276 & sic3dig==277 & sic3dig==278 & sic3dig==279 
drop if (man7090==21 & sic3dig==272) | (man7090==21 & sic3dig==274) | (man7090==21 & sic3dig==275) | (man7090==21 & sic3dig==276) | (man7090==21 & sic3dig==277) | (man7090==21 & sic3dig==278) | (man7090==21 & sic3dig==279)
*man7090=27: sic3dig==281 & sic3dig==286 & sic3dig==289 & sic3dig==291 
drop if (man7090==27 & sic3dig==281) | (man7090==27 & sic3dig==289) | (man7090==27 & sic3dig==291)
*man7090=29: sic3dig==295 & sic3dig==299 & sic3dig==305    
drop if (man7090==29 & sic3dig==295) | (man7090==29 & sic3dig==305) 
*man7090=30: sic3dig==301 & sic3dig==302 & sic3dig==305 & sic3dig==306       
drop if (man7090==30 & sic3dig==302) | (man7090==30 & sic3dig==305) | (man7090==30 & sic3dig==306) 
*man7090=33: sic3dig==313 & sic3dig==314        
drop if (man7090==33 & sic3dig==314)
*man7090=34: sic3dig==315 & sic3dig==316 & sic3dig==317 & sic3dig==319 
drop if (man7090==34 & sic3dig==316) | (man7090==34 & sic3dig==317) | (man7090==34 & sic3dig==319)
*man7090=36: sic3dig==242 & sic3dig==243        
drop if (man7090==36 & sic3dig==242)
*man7090=37: sic3dig==244 & sic3dig==249       
drop if (man7090==37 & sic3dig==244)
*man7090=38: sic3dig==251 & sic3dig==252 & sic3dig==253 & sic3dig==254 & sic3dig==259
drop if (man7090==38 & sic3dig==251) | (man7090==38 & sic3dig==252) | (man7090==38 & sic3dig==253) | (man7090==38 & sic3dig==254)
*man7090=39: sic3dig==321 & sic3dig==322 & sic3dig==323
drop if (man7090==39 & sic3dig==321) | (man7090==39 & sic3dig==323) 
*man7090=40: sic3dig==324 & sic3dig==327  
drop if (man7090==40 & sic3dig==324)
*man7090=43: sic3dig==328 & sic3dig==329
drop if (man7090==43 & sic3dig==328)
*man7090=46: sic3dig==333 & sic3dig==334 & sic3dig==335 & sic3dig==336 & sic3dig==339
drop if (man7090==46 & sic3dig==333) | (man7090==46 & sic3dig==334) | (man7090==46 & sic3dig==335) | (man7090==46 & sic3dig==336)
*man7090=51: sic3dig==347 & sic3dig==341 & sic3dig==343 & sic3dig==349 
drop if (man7090==51 & sic3dig==347) | (man7090==51 & sic3dig==341) | (man7090==51 & sic3dig==343)
*man7090=57: sic3dig==355 & sic3dig==356 & sic3dig==358 & sic3dig==359 
drop if (man7090==57 & sic3dig==355) | (man7090==57 & sic3dig==356) | (man7090==57 & sic3dig==359)
*man7090=60: sic3dig==361 & sic3dig==362 & sic3dig==364 & sic3dig==367 & sic3dig==369 
drop if (man7090==60 & sic3dig==362) | (man7090==60 & sic3dig==364) | (man7090==60 & sic3dig==367) | (man7090==60 & sic3dig==369)
*man7090=64: sic3dig==348 & sic3dig==372 & sic3dig==376  
drop if (man7090==64 & sic3dig==348) | (man7090==64 & sic3dig==376) 
*man7090=65: sic3dig==245 & sic3dig==375 & sic3dig==379 
drop if (man7090==65 & sic3dig==375) | (man7090==65 & sic3dig==379) 
*man7090=66: sic3dig==365 & sic3dig==366 & sic3dig==381 & sic3dig==382         
drop if (man7090==66 & sic3dig==365) | (man7090==66 & sic3dig==366) | (man7090==66 & sic3dig==382)
*man7090=67: sic3dig==384 & sic3dig==385 
drop if (man7090==67 & sic3dig==385)
*man7090=70: sic3dig==391 & sic3dig==393 & sic3dig==394 & sic3dig==395 & sic3dig==396 & sic3dig==399 
drop if (man7090==70 & sic3dig==391) | (man7090==70 & sic3dig==393) | (man7090==70 & sic3dig==394) | (man7090==70 & sic3dig==395) | (man7090==70 & sic3dig==399)
merge sic3dig using ${x}1digit
tab _merge
drop if _merge==1 /* year==. */
drop if _merge==2 /* man7090==. */
***********************************************************************************
* Assume that exports or imports are very small if the price indices do not exist *
* Assume this means zero exposure at the occupation level
***********************************************************************************
*************************************************************
* Decide whether to assign expfin=0 if expfin=. & impfin~=. *
* Decide whether to assign impfin=0 if impfin=. & expfin~=. *
*************************************************************
replace expfin=0 if expfin==. 
replace impfin=0 if impfin==. 
keep sic3dig year man7090 expfin impfin 
sort man7090 year 
save ${x}man7090_sic1, replace
