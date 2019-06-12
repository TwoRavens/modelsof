**GRAPHS

twoway (line avgprice date_j, yaxis(1)) (lowess newindex_black date_j, yaxis(2)) (lowess newindex_white date_j, yaxis(2)) (lowess newindex_white date_j if democrat==1, yaxis(2)), scheme(s1color)


*TABLE 1: Obama on Black and White Pol Eff (inlc white dems pref Obama) and HRC on men and women pol eff
*transformed pol eff index= (old index-min)/(max-min)

**OBAMA
*Naive Regression
*newindex
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg newindex obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg newindex obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg newindex obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*First Stage
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg obama avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg obama avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg obama avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust


*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg newindex avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg newindex avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg newindex avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*2SLS
local controls wa01 wa02 wa03 wa04 wa05  stated* wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg newindex `controls' dt_w12 dt_w12_2 (obama=avgprice)  if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
ivreg newindex `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg newindex `controls'  dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=.,  robust



**clinton
*Naive Regression
*newindex
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg newindex clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg newindex clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*First Stage
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg clinton avgprice_c `controls' dt_w12 dt_w12_2  [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=., robust
reg clinton avgprice_c `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=., robust


*Reduced Form
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg newindex avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & newindex!=. & newindex!=. & newindex!=. & newindex!=. & clinton!=., robust
reg newindex avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & newindex!=. & newindex!=. & newindex!=. & newindex!=. & clinton!=., robust

*2SLS
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg newindex  `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=.,  robust
ivreg newindex `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=.,  robust



**************************************************************************************************
*Table A1: Robustness Check 1: Difference IEM and Poll
**OBAMA
*First Stage
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg obama avgpricepolldiff `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg obama avgpricepolldiff `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg obama avgpricepolldiff `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg newindex avgpricepolldiff `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg newindex avgpricepolldiff `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg newindex avgpricepolldiff `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust


*2SLS
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg newindex  `controls' dt_w12 dt_w12_2 (obama=avgpricepolldiff) [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
ivreg newindex `controls' dt_w12 dt_w12_2 (obama=avgpricepolldiff) [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg newindex `controls'  dt_w12 dt_w12_2 (obama=avgpricepolldiff) [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=.,  robust


**************************************************************************************************
*Table A2: Robustness Check 2: Non-Super Tuesday States
**OBAMA
*Naive Regression
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg newindex obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1  & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg newindex obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 &  wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg newindex obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & obamaprefdemcand==1  & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*First Stage
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg obama avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1  & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg obama avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 &  wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg obama avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & obamaprefdemcand==1  & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust


*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg newindex avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1  & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
reg newindex avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 &  wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & obama!=., robust
reg newindex avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & obamaprefdemcand==1  & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & obama!=., robust


*2SLS
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg newindex  `controls' dt_w12 dt_w12_2 (obama=avgpricepolldiff) [aweight=inv_day_weight] if black==1 & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1  & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
ivreg newindex  `controls' dt_w12 dt_w12_2 (obama=avgpricepolldiff) [aweight=inv_day_weight] if white==1 &  wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust
ivreg newindex  `controls' dt_w12 dt_w12_2 (obama=avgpricepolldiff) [aweight=inv_day_weight] if white==1 & obamaprefdemcand==1  & wfc01_a!=45 & wfc01_a!=26 & wfc01_a!=12 & supertuesday!=1 & date_m<=20080331 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust




**************************************************************************************************
*Table A3: Robustness Check 3: White  Pre-Treatment Pref Obama
**OBAMA
*****White Dems Only Pre-Treatment Obama Pref Dem Cand
***Naive Regression
local controls wa01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey
reg newindex obama `controls' wave_1 dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1  &  obamaprefdemcand==1 & obamapre==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & democrat!=. & inv_day_weight!=. & avgprice!=. & obama!=., robust

*Obama First-Stage 
reg obama avgprice wa01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & obamapre==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust

*********Reduced Form
local controls wa01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey
reg newindex avgprice `controls' wave_1 dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1  & obamaprefdemcand==1 & obamapre==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & democrat!=. & inv_day_weight!=., robust

****2SLS
ivreg newindex wa01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 dt_w12 dt_w12_2  (obama=avgprice) [aweight=inv_day_weight] if white==1  & democrat==1  & obamaprefdemcand==1 & obamapre==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust




**************************************************************************************************
*Table A4: Robustness Check 4: Republicans Jan-Mar 08

**Obama POLITICAL EFFICACY Among Republicans Jan-Mar 08
**Naive Regression
local controls wc01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey
reg newindex obama `controls' wave_1 dt_w12 dt_w12_2 [aweight=inv_day_weight] if republican==1  & date_m>20080101 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & republican!=. & inv_day_weight!=. & avgprice_c!=., robust

*obama First-Stage 
reg obama avgprice wc01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1  dt_w12 dt_w12_2 [aweight=inv_day_weight] if republican==1  & date_m>20080101 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=., robust

*obama Reduced Form
local controls wc01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey
reg newindex avgprice `controls' wave_1 dt_w12 dt_w12_2 [aweight=inv_day_weight] if republican==1 & date_m>20080101  & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & republican!=. & inv_day_weight!=., robust

*obama 2SLS
ivreg newindex wc01 wa02 wa03  wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 dt_w12 dt_w12_2  (obama=avgprice) [aweight=inv_day_weight] if republican==1 & date_m>20080101  & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust








******************* MB01, MB02, MB03, MB04
**MB01

**OBAMA
*Naive Regression
*mb01
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb01 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb01 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb01 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb01 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb01 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb01 avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*2SLS
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb01  `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb01 `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb01 `controls'  dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=.,  robust

**clinton
*Naive Regression
*mb01
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb01 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb01 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*Reduced Form
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb01 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb01 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*2SLS
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb01  `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust
ivreg mb01 `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust


**MB02

**OBAMA
*Naive Regression
*mb02
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb02 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb02 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb02 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb02 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb02 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb02 avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*2SLS
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb02  `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb02 `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb02 `controls'  dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=.,  robust

**clinton
*Naive Regression
*mb01
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb02 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb02 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*Reduced Form
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb02 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb02 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*2SLS
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb02  `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust
ivreg mb02 `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust


**MB03

**OBAMA
*Naive Regression
*mb03
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb03 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb03 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb03 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb03 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb03 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb03 avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*2SLS
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb03  `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb03 `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb03 `controls'  dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=.,  robust

**clinton
*Naive Regression
*mb01
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb03 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb03 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*Reduced Form
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb03 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb03 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*2SLS
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb03  `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust
ivreg mb03 `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust



**MB04

**OBAMA
*Naive Regression
*mb04
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb04 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb04 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb04 obama `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*Reduced Form
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb04 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb04 avgprice `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust
reg mb04 avgprice `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=., robust

*2SLS
local controls wa01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb04  `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if black==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb04 `controls' dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=.,  robust
ivreg mb04 `controls'  dt_w12 dt_w12_2 (obama=avgprice) [aweight=inv_day_weight] if white==1 & democrat==1 & obamaprefdemcand==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & obama!=. & avgprice!=.,  robust

**clinton
*Naive Regression
*mb01
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1 
reg mb04 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb04 clinton `controls'  dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*Reduced Form
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
reg mb04 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust
reg mb04 avgprice_c `controls' dt_w12 dt_w12_2 [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=., robust

*2SLS
local controls wc01 wa02 wa03 wa04 wa05 stated*  wfc02 ra01  rd01 religiond* partyd* wd02 rkey wave_1
ivreg mb04  `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if female==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust
ivreg mb04 `controls' dt_w12 dt_w12_2 (clinton=avgprice_c) [aweight=inv_day_weight] if male==1 & mb01!=. & mb02!=. & mb03!=. & mb04!=. & clinton!=. & avgprice_c!=.,  robust

