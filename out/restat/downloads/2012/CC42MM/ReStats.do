clear
clear matrix
clear mata

set mem 700m
set more off
use lsatisfy05
append using lsatisfy06
append using lsatisfy07
append using lsatisfy08
replace year05=0 if year05==.
replace year06=0 if year06==.
replace year07=0 if year07==.
replace year08=0 if year08==.

keep if age>=18&age<=85&age!=.

replace lsatis=. if lsatis>4
**Recode life satisfaction: higher number is more satisfied**
replace lsatis=5-lsatis

replace menthlth=0 if menthlth==88
replace menthlth=. if menthlth>30

gen black=mraceas==2
replace black=. if mraceas>6
gen hisp=hispanc2==1
gen asian=mraceas==3|mraceas==4
gen nativeam=mraceas==5
gen other=orace2==6
gen agesq=age^2
gen female=sex==2
drop if _state>56
replace income=. if income>8
gen self_emp=employ==2
gen unemp=employ==3|employ==4
gen homemaker=employ==5
gen student=employ==6
gen retired=employ==7
replace self=. if employ==.
replace unemp=. if employ==.
replace homem=. if employ==.
replace student=. if employ==.
replace retired=. if employ==.
gen married=marital==1
replace married=. if marital==.
replace married=. if marital==9
gen divorced=marital==2
gen widowed=marital==3
gen separated=marital==4
gen partner=marital==6

gen somehs=educa==3
gen hs=educa==4
gen somecoll=educa==5
gen coll=educa==6
replace somehs=. if educa==9|educa==.

gen inc1=income==1
gen inc2=income==2
gen inc3=income==3
gen inc4=income==4
gen inc5=income==5
gen inc6=income==6
gen inc7=income==7
gen inc8=income==8
replace inc1=. if income==.
replace inc2=. if income==.
replace inc3=. if income==.
replace inc4=. if income==.
replace inc5=. if income==.
replace inc6=. if income==.
replace inc7=. if income==.
replace inc8=. if income==.

destring idate, replace
replace idate=idate/10000
gen month1=idate>=101&idate<=131
gen month2=idate>=201&idate<=231
gen month3=idate>=301&idate<=331
gen month4=idate>=401&idate<=431
gen month5=idate>=501&idate<=531
gen month6=idate>=601&idate<=631
gen month7=idate>=701&idate<=731
gen month8=idate>=801&idate<=831
gen month9=idate>=901&idate<=931
gen month10=idate>=1001&idate<=1031
gen month11=idate>=1101&idate<=1131
gen month12=idate>=1201&idate<=1231

tabulate _state, generate(statedum)
replace children=0 if children==88
replace children=. if children==99|children>20
replace numadult=. if numadult>9

compress

gen hhsize=children+numadult
gen age18_22=age>=18&age<=22
gen age23_27=age>=23&age<=27
gen age28_32=age>=28&age<=32
gen age33_37=age>=33&age<=37
gen age38_42=age>=38&age<=42
gen age43_47=age>=43&age<=47
gen age48_52=age>=48&age<=52
gen age53_57=age>=53&age<=57
gen age58_62=age>=58&age<=62
gen age63_67=age>=63&age<=67
gen age68_72=age>=68&age<=72
gen age73_77=age>=73&age<=77
gen age78_82=age>=78&age<=82
gen age83p=age>=83&age!=.

compress


log using ReStats.log, replace

***Table 1****
reg lsatisf inc2-inc8 year06-year08
outreg2 using table1.out, 2aster nolabel replace
reg lsatisf hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female statedum2-statedum51 year06-year08
outreg2 using table1.out, 2aster nolabel append
reg lsatisf inc2-inc8 hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female statedum2-statedum51 year06-year08
outreg2 using table1.out, 2aster nolabel append
reg lsatisf inc2-inc8 hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female somehs hs somecoll coll married divorced sepa widow partne self unemp homem student retire statedum2-statedum51 month2-month12  year06-year08
outreg2 using table1.out, 2aster nolabel append

***Table 2****
reg lsatisf statedum2-statedum51 month2-month12 year06-year08
outreg2 using table2.out, 2aster nolabel replace
reg lsatisf hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female statedum2-statedum51  month2-month12 year06-year08
outreg2 using table2.out, 2aster nolabel append
reg lsatisf hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female somehs hs somecoll coll married divorced sepa widow partne statedum2-statedum51 month2-month12 year06-year08
outreg2 using table2.out, 2aster nolabel append
reg lsatisf hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female somehs hs somecoll coll married divorced sepa widow partne self unemp homem student retire statedum2-statedum51 month2-month12  year06-year08
outreg2 using table2.out, 2aster nolabel append

***Table 3****
tobit menth inc2-inc8 year06-year08, ll(0) 
outreg2 using table3.out, 2aster nolabel replace
tobit menth hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female statedum2-statedum51 year06-year08, ll(0)
outreg2 using table3.out, 2aster nolabel append
tobit menth inc2-inc8 hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female statedum2-statedum51 year06-year08, ll(0)
outreg2 using table3.out, 2aster nolabel append
tobit menth inc2-inc8 hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female somehs hs somecoll coll married divorced sepa widow partne self unemp homem student retire statedum2-statedum51 month2-month12 year06-year08, ll(0)
outreg2 using table3.out, 2aster nolabel append

***Table 4****
tobit menth statedum2-statedum51 month2-month12 year06-year08, ll(0)
outreg2 using table4.out, 2aster nolabel replace
tobit menth hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female statedum2-statedum51  month2-month12 year06-year08, ll(0)
outreg2 using table4.out, 2aster nolabel append
tobit menth hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female somehs hs somecoll coll married divorced sepa widow partne statedum2-statedum51 month2-month12 year06-year08, ll(0)
outreg2 using table4.out, 2aster nolabel append
tobit menth hhsize age23_27 age28_32 age33_37 age38_42 age43_47 age48_52 age53_57 age58_62 age63_67 age68_72 age73_77 age78_82 age83p black asian hisp nativeam other female somehs hs somecoll coll married divorced sepa widow partne self unemp homem student retire statedum2-statedum51 month2-month12 year06-year08, ll(0) 
outreg2 using table4.out, 2aster nolabel append

log close

