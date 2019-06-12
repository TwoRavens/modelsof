
global PATH = "~/Desktop/Research&Politics/replication-files"

set more off
log using "$PATH/syntax_reseach&politics.txt", text replace

	*********************************
****Direct democracy & responsiveness****
	*********************************

* open dataset
use "$PATH/swiss-mps.dta", clear


****************************************
	******** variable recoding ********
****************************************

* destring variables
encode canton, gen(canton1)
tab canton1

* direct democarcy index - centering around mean 
summarize index_direct_democracy_1, meanonly
gen index_DD_1 = index_direct_democracy_1 - r(mean)
summarize index_direct_democracy_2, meanonly
gen index_DD_2 = index_direct_democracy_2 - r(mean)


****************************************
	******** REGRESSION MODELS ********
****************************************

* TABLE 2
quietly xtmelogit replied index_DD_1 female language_french i.sender_name i.party unemployment pop i.batch sender_union i.sender_occupation || canton1:, covariance(unstructured)
est store m1
quietly xtmelogit replied index_DD_2 female language_french i.sender_name i.party unemployment pop i.batch sender_union i.sender_occupation  || canton1:, covariance(unstructured)
est store m2
esttab m1 m2

* TABLE 3
quietly xtmelogit replied_meeting index_DD_1 female language_french i.sender_name i.party unemployment pop i.batch sender_union i.sender_occupation || canton1:, covariance(unstructured)
est store m3
quietly xtmelogit replied_meeting index_DD_2 female language_french i.sender_name i.party unemployment pop i.batch sender_union i.sender_occupation  || canton1:, covariance(unstructured)
est store m4
esttab m3 m4


****************************************
	******** MAP ********
****************************************

//step 1: http://www.stata.com/support/faqs/graphics/spmap-and-maps/
//step 2: http://druedin.com/2015/11/21/a-modified-shapefile-for-plotting-swiss-cantons/
//step 3: translate map
//step 4: Determine the coding used by the map

shp2dta using "$PATH/swiss-cantons/ch-cantons", ///
	database("$PATH/cantons-shapefile.dta") ///	
	coordinates("$PATH/canton-coord") genid(id)

use "$PATH/cantons-data.dta", clear
des

spmap index_direct_democracy_1 using "$PATH/canton-coord", ///
	 id(id) fcolor(Oranges) legend(position(5)) legtitle("Formal rules index") /// 
	 legend(size(*1.80)) legstyle(2) 
	 
spmap index_direct_democracy_2 using "$PATH/canton-coord", id(id) fcolor(Oranges)

* done...
clear
log close
