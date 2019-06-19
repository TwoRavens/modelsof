* This do-file creates a stata data set that combines all relevant county level information, including location
* demographic, and economic variables of interest

clear
set more off
cap log close
set mem 100m
set seed 31692361

local date = "101110"
local dir = "C:\Users\Treb\Documents\My Dropbox\Research\Fugitive Slave Law\Data\County Level Data"
cd "`dir'"
log using county_`date'.log, replace

*** Step 1: Calling Stat/Transfer to make the excel files into stata files

winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1840 Agricultural and Demographic Data.xls" "`dir'\1840 Agricultural and Demographic Data.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1850 Agricultural Output.xls" "`dir'\1850 Agricultural Output.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1850 Race Demographic Data.xls" "`dir'\1850 Race Demographic Data.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1860 Agricultural Output.xls" "`dir'\1860 Agricultural Output.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1860 Race Demographic Data.xls" "`dir'\1860 Race Demographic Data.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\County Codes.xls" "`dir'\County Codes.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\County_geocodes.xls" "`dir'\County_geocodes.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1850 number of farms by county.xls" "`dir'\1850 number of farms by county.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1850 Transportation Data.xls" "`dir'\1850 Transportation Data.dta" /Y
winexec C:\Program Files (x86)\StatTransfer9\st.exe "`dir'\1860 Transportation Data.xls" "`dir'\1860 Transportation Data.dta" /Y

sleep 5000

*** Step 2: For each data set, choosing the variables of interest and making the variables consistent

** County Codes.dta
use "county codes.dta"

* renaming
ren state state_name
ren stateicp state_icp
ren statefips state_fips
ren county_cod county_code
ren county county_name

* keeping
keep state_name state_icp state_fips county_code county_name
drop if county_code==.

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_1.dta, replace

clear

** county_geocodes.dta
use "county_geocodes.dta"

* county code needs to be multiplied by 10
gen int temp=county_fips*10
drop county_fips county_code
ren temp county_code

* renaming
ren county_name county_name1

* keeping
keep state_fips county_code county_name1 lattitude longitude

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_2.dta, replace

clear

** 1850 Agricultural Output.dta
use "1850 Agricultural Output.dta"

* renaming
ren state state_name1
gen int state_fips=statea/10
ren county county_name2
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* total value of crops per county
gen total_crop_1850=v0000001+v0000002+v0000003+v0000004+v0000005+v0000006+v0000007+v0000008+v0000009+v0000010+v0000011+v0000012+v0000013+v0000014+ ///
	v0000015+v0000016+v0000017+v0000018+v0000019+v0000020+v0000021+v0000022+v0000023+v0000024+v0000025+v0000026+v0000027+v0000028+v0000029+v0000030
lab var total_crop_1850 "Value of all agricultural output in 1850"

* total value of cotton
gen cotton_val_1850=v0000007
lab var cotton_val_1850 "Value of cotton in 1850"

* total value of rice
gen rice_val_1850=v0000005
lab var rice_val_1850 "Value of rice in 1850"

* total value of tobacco
gen tobacco_val_1850=v0000006
lab var tobacco_val_1850 "Value of tobacco in 1850"

* total value of sugar
gen sugar_val_1850=v0000027
lab var sugar_val_1850 "Value of sugar in 1850"

* keeping
keep state_fips state_name1 county_name2 county_code total_crop_1850 cotton_val_1850 tobacco_val_1850 rice_val_1850 sugar_val_1850

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_3.dta, replace
clear

** 1860 Agricultural Output.dta
use "1860 Agricultural Output.dta"

* renaming
ren state state_name2
gen int state_fips=statea/10
ren county county_name3
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953


* total value of crops per county
gen total_crop_1860=v0000001+v0000002+v0000003+v0000004+v0000005+v0000006+v0000007+v0000008+v0000009+v0000010+v0000011+v0000012+v0000013+v0000014+ ///
	v0000015+v0000016+v0000017+v0000018+v0000019+v0000020+v0000021+v0000022+v0000023+v0000024+v0000025+v0000026+v0000027+v0000028+v0000029+v0000030+ ///
	v0000031+v0000032+v0000033
lab var total_crop_1860 "Value of all agricultural output in 1860"

* total value of cotton
gen cotton_val_1860=v0000007
lab var cotton_val_1860 "Value of cotton in 1860"

* total value of rice
gen rice_val_1860=v0000005
lab var rice_val_1860 "Value of rice in 1860"

* total value of tobacco
gen tobacco_val_1860=v0000006
lab var tobacco_val_1860 "Value of tobacco in 1860"

* total value of sugar
gen sugar_val_1860=v0000028
lab var sugar_val_1860 "Value of sugar in 1860"

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* keeping
keep state_fips state_name2 county_name3 county_code total_crop_1860 cotton_val_1860 rice_val_1860 tobacco_val_1860 sugar_val_1860

* sorting
sort state_fips county_code, stable

* saving
save temp_4.dta, replace

clear

** 1850 Race Demographic Data.dta
use "1850 Race Demographic Data.dta"

* renaming
ren state state_name3
gen int state_fips=statea/10
ren county county_name4
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* 1850 total white population
gen white_total_1850=v0000001
lab var white_total_1850 "Total white population in 1850"

* 1850 free black population
gen black_total_1850=v0000002
lab var black_total_1850 "Total free non-white population in 1850"

* 1850 slave population
gen slave_total_1850=v0000003
lab var slave_total_1850 "Total slave population in 1850"

* white kids
gen under1_white_1850=v0020001+v0020016
gen yr1to4_white_1850=v0020002+v0020017
gen yr5to9_white_1850=v0020003+v0020018
gen yr10to14_white_1850=v0020004+v0020019
gen yr15to19_white_1850=v0020005+v0020020

* free black kids
gen under1_black_1850=v0020031+v0020046
gen yr1to4_black_1850=v0020032+v0020047
gen yr5to9_black_1850=v0020033+v0020048
gen yr10to14_black_1850=v0020034+v0020049
gen yr15to19_black_1850=v0020035+v0020050

* slave kids
gen under1_slave_1850=v0020061+v0020076
gen yr1to4_slave_1850=v0020062+v0020077
gen yr5to9_slave_1850=v0020063+v0020078
gen yr10to14_slave_1850=v0020064+v0020079
gen yr15to19_slave_1850=v0020065+v0020080

* white moms
gen mom20to29_white_1850=v0020021
gen mom30to39_white_1850=v0020022
gen mom40to49_white_1850=v0020023
gen mom50to59_white_1850=v0020024

* free black moms
gen mom20to29_black_1850=v0020051
gen mom30to39_black_1850=v0020052
gen mom40to49_black_1850=v0020053
gen mom50to59_black_1850=v0020054

* slave moms
gen mom20to29_slave_1850=v0020081
gen mom30to39_slave_1850=v0020082
gen mom40to49_slave_1850=v0020083
gen mom50to59_slave_1850=v0020084

* keeping
keep state_name3 county_name4 state_fips county_code white_total_1850-mom50to59_slave_1850

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_5, replace

clear

** 1860 Race Demographic Data.dta
use "1860 Race Demographic Data.dta"

* renaming
ren state state_name4
gen int state_fips=statea/10
ren county county_name5
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* 1860 total white population
gen white_total_1860=v0000001
lab var white_total_1860 "Total white population in 1860"

* 1860 free black population
gen black_total_1860=v0000002
lab var black_total_1860 "Total free non-white population in 1860"

* 1860 slave population
gen slave_total_1860=v0000003
lab var slave_total_1860 "Total slave population in 1860"

* white kids
gen under1_white_1860=v0030001+v0030002
gen yr1to4_white_1860=v0030003+v0030004
gen yr5to9_white_1860=v0030005+v0030006
gen yr10to14_white_1860=v0030007+v0030008
gen yr15to19_white_1860=v0030009+v0030010

* free black kids
gen under1_black_1860=v0030031+v0030032
gen yr1to4_black_1860=v0030033+v0030034
gen yr5to9_black_1860=v0030035+v0030036
gen yr10to14_black_1860=v0030037+v0030038
gen yr15to19_black_1860=v0030039+v0030040

* slave kids
gen under1_slave_1860=v0030061+v0030062
gen yr1to4_slave_1860=v0030063+v0030064
gen yr5to9_slave_1860=v0030065+v0030066
gen yr10to14_slave_1860=v0030067+v0030068
gen yr15to19_slave_1860=v0030069+v0030070

* white moms
gen mom20to29_white_1860=v0030012
gen mom30to39_white_1860=v0030014
gen mom40to49_white_1860=v0030016
gen mom50to59_white_1860=v0030018

* free black moms
gen mom20to29_black_1860=v0030042
gen mom30to39_black_1860=v0030044
gen mom40to49_black_1860=v0030046
gen mom50to59_black_1860=v0030048

* slave moms
gen mom20to29_slave_1860=v0030072
gen mom30to39_slave_1860=v0030074
gen mom40to49_slave_1860=v0030076
gen mom50to59_slave_1860=v0030078

* keeping
keep state_name4 county_name5 state_fips county_code white_total_1860-mom50to59_slave_1860

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_6, replace

clear

** Election Result Data
use ".\County Level Election Results\ICPSR_08611\DS0001\08611-0001-Data.dta"

* renaming
ren V1 state_icp
ren V2 county_name6
ren V3 county_code

* fixing WV / VA snafu
replace state_icp=56 if state_icp==40 & county_code==155
replace state_icp=56 if state_icp==40 & county_code==195
replace state_icp=56 if state_icp==40 & county_code==215
replace state_icp=56 if state_icp==40 & county_code==233
replace state_icp=56 if state_icp==40 & county_code==237
replace state_icp=56 if state_icp==40 & county_code==293
replace state_icp=56 if state_icp==40 & county_code==297
replace state_icp=56 if state_icp==40 & county_code==533
replace state_icp=56 if state_icp==40 & county_code==615
replace state_icp=56 if state_icp==40 & county_code==715
replace state_icp=56 if state_icp==40 & county_code==775
replace state_icp=56 if state_icp==40 & county_code==833
replace state_icp=56 if state_icp==40 & county_code==853
replace state_icp=56 if state_icp==40 & county_code==857
replace state_icp=56 if state_icp==40 & county_code==953
replace state_icp=56 if state_icp==40 & county_code==957
replace state_icp=56 if state_icp==40 & county_code==1053
replace state_icp=56 if state_icp==40 & county_code==1057
replace state_icp=56 if state_icp==40 & county_code==1135
replace state_icp=56 if state_icp==40 & county_code==1137
replace state_icp=56 if state_icp==40 & county_code==1175
replace state_icp=56 if state_icp==40 & county_code==1193
replace state_icp=56 if state_icp==40 & county_code==1197
replace state_icp=56 if state_icp==40 & county_code==1215
replace state_icp=56 if state_icp==40 & county_code==1275
replace state_icp=56 if state_icp==40 & county_code==1355
replace state_icp=56 if state_icp==40 & county_code==1415
replace state_icp=56 if state_icp==40 & county_code==1437
replace state_icp=56 if state_icp==40 & county_code==1455
replace state_icp=56 if state_icp==40 & county_code==1553
replace state_icp=56 if state_icp==40 & county_code==1555
replace state_icp=56 if state_icp==40 & county_code==1557
replace state_icp=56 if state_icp==40 & county_code==1593
replace state_icp=56 if state_icp==40 & county_code==1597
replace state_icp=56 if state_icp==40 & county_code==1835
replace state_icp=56 if state_icp==40 & county_code==1853
replace state_icp=56 if state_icp==40 & county_code==1855
replace state_icp=56 if state_icp==40 & county_code==1857
replace state_icp=56 if state_icp==40 & county_code==1913
replace state_icp=56 if state_icp==40 & county_code==1937
replace state_icp=56 if state_icp==40 & county_code==1953

replace county_code=10 if state_icp==56 & county_code==155
replace county_code=30 if state_icp==56 & county_code==195
replace county_code=50 if state_icp==56 & county_code==215
replace county_code=70 if state_icp==56 & county_code==233
replace county_code=90 if state_icp==56 & county_code==237
replace county_code=110 if state_icp==56 & county_code==293
replace county_code=130 if state_icp==56 & county_code==297
replace county_code=170 if state_icp==56 & county_code==533
replace county_code=190 if state_icp==56 & county_code==615
replace county_code=210 if state_icp==56 & county_code==715
replace county_code=250 if state_icp==56 & county_code==775
replace county_code=270 if state_icp==56 & county_code==833
replace county_code=310 if state_icp==56 & county_code==853
replace county_code=330 if state_icp==56 & county_code==857
replace county_code=370 if state_icp==56 & county_code==953
replace county_code=390 if state_icp==56 & county_code==957
replace county_code=410 if state_icp==56 & county_code==1053
replace county_code=450 if state_icp==56 & county_code==1057
replace county_code=510 if state_icp==56 & county_code==1135
replace county_code=530 if state_icp==56 & county_code==1137
replace county_code=550 if state_icp==56 & county_code==1175
replace county_code=610 if state_icp==56 & county_code==1193
replace county_code=630 if state_icp==56 & county_code==1197
replace county_code=650 if state_icp==56 & county_code==1215
replace county_code=670 if state_icp==56 & county_code==1275
replace county_code=690 if state_icp==56 & county_code==1355
replace county_code=710 if state_icp==56 & county_code==1415
replace county_code=750 if state_icp==56 & county_code==1437
replace county_code=770 if state_icp==56 & county_code==1455
replace county_code=790 if state_icp==56 & county_code==1553
replace county_code=810 if state_icp==56 & county_code==1555
replace county_code=830 if state_icp==56 & county_code==1557
replace county_code=850 if state_icp==56 & county_code==1593
replace county_code=870 if state_icp==56 & county_code==1597
replace county_code=910 if state_icp==56 & county_code==1835
replace county_code=930 if state_icp==56 & county_code==1853
replace county_code=950 if state_icp==56 & county_code==1855
replace county_code=970 if state_icp==56 & county_code==1857
replace county_code=990 if state_icp==56 & county_code==1913
replace county_code=1050 if state_icp==56 & county_code==1937
replace county_code=1070 if state_icp==56 & county_code==1953

replace V43=. if round(V43)==1000 /* missing data */
replace V44=. if round(V44)==1000 /* missing data */
replace V45=. if round(V45)==1000 /* missing data */
replace V46=. if round(V46)==1000 /* missing data */
replace V47=. if V47>9999998 /* missing data */

ren V43 pres_1848_dem
lab var pres_1848_dem "Percentage county votes going for Democratic presidential candidate in 1848"
ren V44 pres_1848_whig 
lab var pres_1848_whig "Percentage county votes going for Whig presidential candidate in 1848"
ren V45 pres_1848_fs 
lab var pres_1848_fs "Percentage county votes going for Free Soil presidential candidate in 1848"
ren V46 pres_1848_other 
lab var pres_1848_other "Percentage county votes going for other presidential candidate in 1848"
ren V47 pres_1848_votes
lab var pres_1848_votes "Total number of county votes in 1848 presidential election"

foreach var of var V87-V91 {
	replace `var'=. if round(`var')==1000
	}

replace V92=. if V92>9999998 /* missing data */

ren V87 pres_1856_dem
lab var pres_1856_dem "Percentage county votes going for Democratic presidential candidate in 1856"

ren V88 pres_1856_rep
lab var pres_1856_rep "Percentage county votes going for Republican presidential candidate in 1856"

ren V89 pres_1856_repeq
lab var pres_1856_repeq "Percentage county votes going for Republican equivalent (Fillmore) presidential candidate in 1856"

ren V90 pres_1856_amer
lab var pres_1856_amer "Percentage county votes going for American Party presidential candidate in 1856"

ren V91 pres_1856_other
lab var pres_1856_other "Percentage county votes going for other presidential candidate in 1856"

ren V92 pres_1856_votes
lab var pres_1856_votes "Total number of county votes in 1856 presidential election"

ren V109 pres_1860_dem
ren V110 pres_1860_rep 
ren V111 pres_1860_demeq 
ren V112 pres_1860_conun 
ren V113 pres_1860_other 
ren V114 pres_1860_votes

lab var pres_1860_dem "Percentage county votes going for Democratic (DOUGLAS) presidential candidate in 1856"
lab var pres_1860_rep "Percentage county votes going for Republican presidential candidate in 1856"
lab var pres_1860_demeq "Percentage county votes going for Democratic equivalent (BRECKINRIDGE) presidential candidate in 1856"
lab var pres_1860_conun "Percentage county votes going for Democratic presidential candidate in 1856"
lab var pres_1860_other "Percentage county votes going for Democratic presidential candidate in 1856"
lab var pres_1860_votes "Total number of county votes in 1860 presidential election"

* keeping
keep state_icp county_name6 county_code pres_*

* uniqueness
bysort state_icp county_code: gen temp_n=_n
bysort state_icp county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_icp county_code, stable

* saving
save temp_7, replace

clear

** 1840 Demographic AND Agricultural Data /* Note: Demographic data not fine enough to work with */
use "1840 Agricultural and Demographic Data.dta"

* renaming
ren state state_name5
gen int state_fips=statea/10
ren county county_name7
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* total value of crops per county
gen total_crop_1840=v0000001+v0000002+v0000003+v0000004+v0000005+v0000006+v0000007+v0000008+v0000009+v0000010+v0000011+v0000012+v0000013+v0000014+ ///
	v0000015+v0000016+v0000017+v0000018+v0000019+v0000020+v0000021+v0000022
lab var total_crop_1840 "Value of all agricultural output in 1840"

* total value of cotton
gen cotton_val_1840=v0000017
lab var cotton_val_1840 "Value of cotton in 1840"

* total price of cotton
gen cotton_pr_1840=v0020017
lab var cotton_pr_1840 "Price of cotton in 1840 (400-pound bale)"

* demographics

* 1840 total white population
egen white_total_1840=rowtotal(v004*)
lab var white_total_1840 "Total white population in 1840"

* 1840 free black population
egen black_total_1840=rowtotal(v0030001-v0030012)
lab var black_total_1840 "Total free non-white population in 1840"

* 1840 slave population
egen slave_total_1840=rowtotal(v0030013-v0030024)
lab var slave_total_1840 "Total slave population in 1840"

* white kids
gen yr0to4_white_1840=v0040001+v0040014
gen yr5to9_white_1840=v0040002+v0040015
gen yr10to14_white_1840=v0040003+v0040016
gen yr15to19_white_1840=v0040004+v0040017

* free black kids
gen yr0to9_black_1840=v0030001+v0030007
gen yr10to23_black_1840=v0030002+v0030008

* slave kids
gen yr0to9_slave_1840=v0030013+v0030019
gen yr10o23_slave_1840=v0030014+v0030020

* white moms
gen mom20to29_white_1840=v0040018
gen mom30to39_white_1840=v0040019
gen mom40to49_white_1840=v0040020
gen mom50to59_white_1840=v0040021

* free black moms
gen mom24to35_black_1840=v0030009
gen mom36to54_black_1840=v0030010

* slave moms
gen mom24to35_slave_1840=v0030021
gen mom36to54_slave_1840=v0030022

* keeping
keep state_name5 county_name7 state_fips county_code total_crop_1840 cotton_val_1840 cotton_pr_1840 white_total_1840 black_total_1840 slave_total_1840 yr* mom*

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_8, replace

** Number of farms in a county in 1850
clear

use "1850 number of farms by county.dta"

* renaming
ren state state_name6
gen int state_fips=statea/10
ren county county_name8
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* number of farms per county
gen num_farms_1850=v0000001__nt1__hist1850_ag___tot
lab var num_farms_1850 "Number of farms in county in 1850"

* keeping
keep state_name6 county_name8 state_fips county_code num_farms_1850

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_9, replace

clear

** 1850 Transportation Data

use "1850 Transportation Data.dta"

* renaming
ren state state_name7
gen int state_fips=statea/10
ren county county_name9
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* railroad & water
ren v0000001 rail_1850
lab var rail_1850 "Dummy: in 1850 county had railroad"
ren v0010001 water_1850 
lab var water_1850 "Dummy: in 1850 county had water transport"

* keeping
keep state_name7 county_name9 state_fips county_code rail_1850 water_1850

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_10, replace

clear

** 1860 Transportation Data

use "1860 Transportation Data.dta"

* renaming
ren state state_name8
gen int state_fips=statea/10
ren county county_name10
ren countya county_code

* fixing WV / VA snafu
replace state_fips=54 if state_fips==51 & county_code==155
replace state_fips=54 if state_fips==51 & county_code==195
replace state_fips=54 if state_fips==51 & county_code==215
replace state_fips=54 if state_fips==51 & county_code==233
replace state_fips=54 if state_fips==51 & county_code==237
replace state_fips=54 if state_fips==51 & county_code==293
replace state_fips=54 if state_fips==51 & county_code==297
replace state_fips=54 if state_fips==51 & county_code==533
replace state_fips=54 if state_fips==51 & county_code==615
replace state_fips=54 if state_fips==51 & county_code==715
replace state_fips=54 if state_fips==51 & county_code==775
replace state_fips=54 if state_fips==51 & county_code==833
replace state_fips=54 if state_fips==51 & county_code==853
replace state_fips=54 if state_fips==51 & county_code==857
replace state_fips=54 if state_fips==51 & county_code==953
replace state_fips=54 if state_fips==51 & county_code==957
replace state_fips=54 if state_fips==51 & county_code==1053
replace state_fips=54 if state_fips==51 & county_code==1057
replace state_fips=54 if state_fips==51 & county_code==1135
replace state_fips=54 if state_fips==51 & county_code==1137
replace state_fips=54 if state_fips==51 & county_code==1175
replace state_fips=54 if state_fips==51 & county_code==1193
replace state_fips=54 if state_fips==51 & county_code==1197
replace state_fips=54 if state_fips==51 & county_code==1215
replace state_fips=54 if state_fips==51 & county_code==1275
replace state_fips=54 if state_fips==51 & county_code==1355
replace state_fips=54 if state_fips==51 & county_code==1415
replace state_fips=54 if state_fips==51 & county_code==1437
replace state_fips=54 if state_fips==51 & county_code==1455
replace state_fips=54 if state_fips==51 & county_code==1553
replace state_fips=54 if state_fips==51 & county_code==1555
replace state_fips=54 if state_fips==51 & county_code==1557
replace state_fips=54 if state_fips==51 & county_code==1593
replace state_fips=54 if state_fips==51 & county_code==1597
replace state_fips=54 if state_fips==51 & county_code==1835
replace state_fips=54 if state_fips==51 & county_code==1853
replace state_fips=54 if state_fips==51 & county_code==1855
replace state_fips=54 if state_fips==51 & county_code==1857
replace state_fips=54 if state_fips==51 & county_code==1913
replace state_fips=54 if state_fips==51 & county_code==1937
replace state_fips=54 if state_fips==51 & county_code==1953

replace county_code=10 if state_fips==54 & county_code==155
replace county_code=30 if state_fips==54 & county_code==195
replace county_code=50 if state_fips==54 & county_code==215
replace county_code=70 if state_fips==54 & county_code==233
replace county_code=90 if state_fips==54 & county_code==237
replace county_code=110 if state_fips==54 & county_code==293
replace county_code=130 if state_fips==54 & county_code==297
replace county_code=170 if state_fips==54 & county_code==533
replace county_code=190 if state_fips==54 & county_code==615
replace county_code=210 if state_fips==54 & county_code==715
replace county_code=250 if state_fips==54 & county_code==775
replace county_code=270 if state_fips==54 & county_code==833
replace county_code=310 if state_fips==54 & county_code==853
replace county_code=330 if state_fips==54 & county_code==857
replace county_code=370 if state_fips==54 & county_code==953
replace county_code=390 if state_fips==54 & county_code==957
replace county_code=410 if state_fips==54 & county_code==1053
replace county_code=450 if state_fips==54 & county_code==1057
replace county_code=510 if state_fips==54 & county_code==1135
replace county_code=530 if state_fips==54 & county_code==1137
replace county_code=550 if state_fips==54 & county_code==1175
replace county_code=610 if state_fips==54 & county_code==1193
replace county_code=630 if state_fips==54 & county_code==1197
replace county_code=650 if state_fips==54 & county_code==1215
replace county_code=670 if state_fips==54 & county_code==1275
replace county_code=690 if state_fips==54 & county_code==1355
replace county_code=710 if state_fips==54 & county_code==1415
replace county_code=750 if state_fips==54 & county_code==1437
replace county_code=770 if state_fips==54 & county_code==1455
replace county_code=790 if state_fips==54 & county_code==1553
replace county_code=810 if state_fips==54 & county_code==1555
replace county_code=830 if state_fips==54 & county_code==1557
replace county_code=850 if state_fips==54 & county_code==1593
replace county_code=870 if state_fips==54 & county_code==1597
replace county_code=910 if state_fips==54 & county_code==1835
replace county_code=930 if state_fips==54 & county_code==1853
replace county_code=950 if state_fips==54 & county_code==1855
replace county_code=970 if state_fips==54 & county_code==1857
replace county_code=990 if state_fips==54 & county_code==1913
replace county_code=1050 if state_fips==54 & county_code==1937
replace county_code=1070 if state_fips==54 & county_code==1953

* railroad & water
ren v0000001 rail_1860
lab var rail_1860 "Dummy: in 1860 county had railroad"
ren v0010001 water_1860 
lab var water_1860 "Dummy: in 1860 county had water transport"

* keeping
keep state_name8 county_name10 state_fips county_code rail_1860 water_1860

* uniqueness
bysort state_fips county_code: gen temp_n=_n
bysort state_fips county_code: gen temp_N=_N
tab temp_N
drop if temp_n>1
drop temp*

* sorting
sort state_fips county_code, stable

* saving
save temp_11, replace

clear

*** Step 3: Merging all county information into one file

use temp_1
bysort state_fips county_code: gen temp=_N
drop if temp>1 /* Hawaii */
drop temp
merge state_fips county_code using temp_2
tab _merge
ren _merge merge1


sort state_fips county_code, stable
merge state_fips county_code using temp_3
tab _merge
ren _merge merge2

sort state_fips county_code, stable
merge state_fips county_code using temp_4
tab _merge
ren _merge merge3

bysort state_fips county_code: gen temp=_n
drop if temp>1
drop temp /* two observations in Nebraska */
sort state_fips county_code, stable
merge state_fips county_code using temp_5
tab _merge
ren _merge merge4

sort state_fips county_code, stable
merge state_fips county_code using temp_6
tab _merge
ren _merge merge5

sort state_icp county_code, stable
merge state_icp county_code using temp_7
tab _merge
ren _merge merge6

sort state_fips county_code, stable
merge state_fips county_code using temp_8
tab _merge
ren _merge merge7

sort state_fips county_code, stable
merge state_fips county_code using temp_9
tab _merge
ren _merge merge8

sort state_fips county_code, stable
merge state_fips county_code using temp_10
tab _merge
ren _merge merge9

sort state_fips county_code, stable
merge state_fips county_code using temp_11
tab _merge
ren _merge merge10

** Evaluating the merge process
count if merge1+merge2+merge3+merge4+merge5+merge6==18 /* 1,524 of counties were found in all files */
count if total_crop_1850<. & total_crop_1860<.		/* 1,584 counties */
count if total_crop_1850<. & total_crop_1860<. & white_total_1850<. & white_total_1860<. /* 1,581 counties - so these two data sets align very well; this makes sense since they are counties with census data */
count if total_crop_1850<. & total_crop_1860<. & white_total_1850<. & white_total_1860<. & pres_1848_dem<. /* 1,400 counties - so 89% of counties with census data have election data */
count if total_crop_1850<. & total_crop_1860<. & white_total_1850<. & white_total_1860<. & lattitude<. /* 1,512 counties - so 95.6% of counties with census data have location data */
count if total_crop_1850<. & total_crop_1860<. & white_total_1850<. & white_total_1860<. & pres_1848_dem<. & lattitude<. /* 1,380 counties - 87.3% of counties that have census data have election data and location data */
drop merge*

drop if state_fips==. /* these we don't have lattitude or longitude observations for */

*** Step 5: Adding a Slave County Variable
gen slaveperc_1850=slave_total_1850 / (white_total_1850+black_total_1850+slave_total_1850)
gen slaveperc_1860=slave_total_1860 / (white_total_1860+black_total_1860+slave_total_1860)

lab var slaveperc_1850 "Percentage of Total Population Comprised as Slaves in 1850"
lab var slaveperc_1860 "Percentage of Total Population Comprised as Slaves in 1860"

*** Step 5: Cleaning up
lab dat "County level demographic, production, location, transportation, and election data"
shell erase temp*.dta
sleep 1000
sort state_fips county_code, stable
save county_`date'.dta, replace

log close









