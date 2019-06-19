
set more off
clear all
set mem 500m

log using "C:\output\logs\newcodes_log", replace

use c:\research\denver\temp\raw.dta

gen newcode=0

* assign 3 good categories
replace newcode=1 if modcode==1033
replace newcode=1 if modcode==1034
replace newcode=1 if modcode==1037
replace newcode=1 if modcode==1040
replace newcode=1 if modcode==1054
replace newcode=1 if modcode==1458
replace newcode=1 if modcode==1461
replace newcode=1 if modcode==1463
replace newcode=1 if modcode==1465
replace newcode=1 if modcode==1484
replace newcode=1 if modcode==1553
replace newcode=1 if modcode==2667
replace newcode=1 if modcode==3625
replace newcode=2 if modcode==1120
replace newcode=2 if modcode==1131
replace newcode=2 if modcode==1290
replace newcode=2 if modcode==1293
replace newcode=2 if modcode==1331
replace newcode=2 if modcode==1334
replace newcode=2 if modcode==1344
replace newcode=3 if modcode==1353
replace newcode=3 if modcode==1355
replace newcode=3 if modcode==1360
replace newcode=3 if modcode==1362
replace newcode=3 if modcode==1372
replace newcode=3 if modcode==1375
replace newcode=3 if modcode==1376
replace newcode=2 if modcode==1405
replace newcode=2 if modcode==1410
replace newcode=2 if modcode==1412
replace newcode=2 if modcode==1421
replace newcode=2 if modcode==2659
replace newcode=3 if modcode==2672
replace newcode=2 if modcode==3608
replace newcode=2 if modcode==3611
replace newcode=1 if modcode==3612
replace newcode=1 if modcode==5000
replace newcode=1 if modcode==5010

drop if newcode==0

* define goods (3 categories)
sort newcode
gen good_group=newcode
drop newcode

* * define goods (38 categories)
* sort newcode
* gen good_group=modcode
* drop newcode

* records by good and category
table good_group sizedes, col

* drop counts to fix units
drop if sizedes=="CT"

save c:\research\denver\temp\newcodes.dta, replace

log close

clear all
set more on

