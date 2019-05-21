/* 
Step 6 of 6
combine 5 imputed data sets from
step 4 and merge regional gini from step 5.
*/


* Load non-imputed dta
use data_listwise
* Load 5 imputed data sets
mi import flongsep data_imputed, using (data_imp{1-5}) id(idno)
* Convert to long form
* Imputations will be identified by _mi_m == 1 ... 5
* Original, non-imputed data is _mi_m==0
mi convert flong
compress

* Add Gini
merge m:1 region using RegionalGini
drop _merge

saveold "data_imputed.dta", replace

* Remove intermediate data
rm data_imp1.dta
rm data_imp2.dta
rm data_imp3.dta
rm data_imp4.dta
rm data_imp5.dta
rm _1_data_imputed.dta
rm _2_data_imputed.dta
rm _3_data_imputed.dta
rm _4_data_imputed.dta
rm _5_data_imputed.dta
rm "working.dta"
