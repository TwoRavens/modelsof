* This program estimates models based on aggregate data in Brunner, Imazeki and Ross (.).

log using results, replace
version 9

* Estimate Models Based on High School Level Data

use dataset_hschools

tab region, gen(r)

local controls1 own prep fe private srural r1 r2 r3 r4 r5 r6 r7 hhwc_white hhwc_nwhite hhnc_white1
local controls2 own prep fe private srural r1 r2 r3 r4 r5 r6 r7 hhwc_white hhwc_nwhite hhnc_white hhwyc_white hhwyc_nwhite

qui {
* Construct Households with No School-Age Children Variables

gen hhnc_white1=hhnc_white+hhwyc_white
gen hhnc_nwhite1=hhnc_nwhite+hhwyc_nwhite

* Construct Basic Interaction Terms

gen inter_child=minority*hhwc_white
gen inter_nchild=minority*hhnc_white1
gen inter_childnw=minority*hhwc_nwhite
gen inter_nchildnw=minority*hhnc_nwhite1
gen inter_childy=minority*hhwyc_white
gen inter_childnwy=minority*hhwyc_nwhite

}

* Column 2 of Table 6 Regression

reg pyes inter_child inter_childnw inter_nchild inter_nchildnw `controls1' [w=totreg], cluster(scode)

* Column 1 of Table 8 Regression

reg pyes inter_child inter_childnw inter_nchild inter_nchildnw inter_childy inter_childnwy `controls2' [w=totreg], cluster(scode)

qui {
gen inter_child1=sphisp*hhwc_white
gen inter_child2=spasian*hhwc_white
gen inter_child3=spblack*hhwc_white

gen inter_nchild1=sphisp*hhnc_white1
gen inter_nchild2=spasian*hhnc_white1
gen inter_nchild3=spblack*hhnc_white1

gen inter_childnw1=sphisp*hhwc_nwhite
gen inter_childnw2=spasian*hhwc_nwhite
gen inter_childnw3=spblack*hhwc_nwhite

gen inter_nchildnw1=sphisp*hhnc_nwhite1
gen inter_nchildnw2=spasian*hhnc_nwhite1
gen inter_nchildnw3=spblack*hhnc_nwhite1

}
* Panel 2 of Table 7 Regressions

reg pyes inter_child1 inter_child2 inter_child3 inter_childnw1 inter_childnw2 inter_childnw3 inter_nchild1 ///
inter_nchild2 inter_nchild3 inter_nchildnw1 inter_nchildnw2 inter_nchildnw3 `controls1' [w=totreg], cluster(scode)


qui {
drop inter*

gen inter_child1=lep_minority*hhwc_white
gen inter_child2=nlep_minority*hhwc_white

gen inter_nchild1=lep_minority*hhnc_white1
gen inter_nchild2= nlep_minority*hhnc_white1

gen inter_childnw1=lep_minority*hhwc_nwhite
gen inter_childnw2=nlep_minority*hhwc_nwhite

gen inter_nchildnw1=lep_minority*hhnc_nwhite1
gen inter_nchildnw2= nlep_minority*hhnc_nwhite1

}
* Panel 3 of Table 7 Regressions

reg pyes inter_child1 inter_child2 inter_childnw1 inter_childnw2 inter_nchild1 inter_nchild2 ///
inter_nchildnw1 inter_nchildnw2 `controls1' [w=totreg], cluster(scode)

qui {
drop inter*

gen inter_child1=lep_sphisp*hhwc_white
gen inter_child2=nlep_sphisp*hhwc_white
gen inter_child3=lep_spasian*hhwc_white
gen inter_child4=nlep_spasian*hhwc_white
gen inter_child5=spblack*hhwc_white

gen inter_nchild1=lep_sphisp*hhnc_white1
gen inter_nchild2=nlep_sphisp*hhnc_white1
gen inter_nchild3=lep_spasian*hhnc_white1
gen inter_nchild4=nlep_spasian*hhnc_white1
gen inter_nchild5=spblack*hhnc_white1

gen inter_childnw1=lep_sphisp*hhwc_nwhite
gen inter_childnw2=nlep_sphisp*hhwc_nwhite
gen inter_childnw3=lep_spasian*hhwc_nwhite
gen inter_childnw4=nlep_spasian*hhwc_nwhite
gen inter_childnw5=spblack*hhwc_nwhite

gen inter_nchildnw1=lep_sphisp*hhnc_nwhite1
gen inter_nchildnw2=nlep_sphisp*hhnc_nwhite1
gen inter_nchildnw3=lep_spasian*hhnc_nwhite1
gen inter_nchildnw4=nlep_spasian*hhnc_nwhite1
gen inter_nchildnw5=spblack*hhnc_nwhite1

}
* Panel 4 of Table 7 Regressions

reg pyes inter_child1 inter_child2 inter_child3 inter_child4 inter_child5 inter_childnw1 inter_childnw2 ///
inter_childnw3 inter_childnw4 inter_childnw5 inter_nchild1 inter_nchild2 inter_nchild3 inter_nchild4 ///
inter_nchild5 inter_nchildnw1 inter_nchildnw2 inter_nchildnw3 inter_nchildnw4 inter_nchildnw5 `controls1' [w=totreg], cluster(scode)

qui {
drop inter*
gen lapi=log(api)

gen inter_child=minority*hhwc_white
gen inter_nchild=minority*hhnc_white1
gen inter_childnw=minority*hhwc_nwhite
gen inter_nchildnw=minority*hhnc_nwhite1

gen inter1_api=lapi*hhwc_white
gen inter2_api=lapi*hhnc_white1
gen inter3_api=lapi*hhwc_nwhite
gen inter4_api=lapi*hhnc_nwhite1

}
reg pyes inter_child inter_childnw inter_nchild inter_nchildnw inter1_api inter2_api inter3_api inter4_api `controls1' [w=totreg], cluster(scode)

clear

* Now Estimate Elementary Models based on Closest Elementary School

use dataset_eschools

tab region, gen(r)

local controls1 own prep fe private srural r1 r2 r3 r4 r5 r6 r7 hhwc_white hhwc_nwhite hhnc_white1
local controls2 own prep fe private srural r1 r2 r3 r4 r5 r6 r7 hhwc_white hhwc_nwhite hhnc_white hhwyc_white hhwyc_nwhite

qui {

* Construct Households with No School-Age Children Variables

gen hhnc_white1=hhnc_white+hhwyc_white
gen hhnc_nwhite1=hhnc_nwhite+hhwyc_nwhite

* Construct Basic Interaction Terms

/* Note that to create the results reported in Table 8, you need to change
two lines of code below.  Specifically, make the following changes:

Change:  gen inter_nchild=minority*hhnc_white1 to gen inter_nchild=minority*hhnc_white

Change:  gen inter_nchildnw=minority*hhnc_nwhite1 to gen inter_nchildnw=minority*hhnc_nwhite

*/

gen inter_child=minority*hhwc_white
gen inter_nchild=minority*hhnc_white1
gen inter_childnw=minority*hhwc_nwhite
gen inter_nchildnw=minority*hhnc_nwhite1
gen inter_childy=minority*hhwyc_white
gen inter_childnwy=minority*hhwyc_nwhite

}

* Column 3 of Table 6 Regression

reg pyes inter_child inter_childnw inter_nchild inter_nchildnw `controls1' [w=totreg], cluster(scode)

* Column 2 of Table 8 Regression

reg pyes inter_child inter_childnw inter_nchild inter_nchildnw inter_childy inter_childnwy `controls2' [w=totreg], cluster(scode)
 

 * Now Estimate Elementary Models based on Three Closest Elementary Schools

clear
use dataset_eschools1

tab region, gen(r)

local controls1 own prep fe private srural r1 r2 r3 r4 r5 r6 r7 hhwc_white hhwc_nwhite hhnc_white1
local controls2 own prep fe private srural r1 r2 r3 r4 r5 r6 r7 hhwc_white hhwc_nwhite hhnc_white hhwyc_white hhwyc_nwhite

qui {
* Construct Households with No School-Age Children Variables

gen hhnc_white1=hhnc_white+hhwyc_white
gen hhnc_nwhite1=hhnc_nwhite+hhwyc_nwhite

* Construct Basic Interaction Terms

/* Note that to create the results reported in Table 8, you need to change
two lines of code below.  Specifically, make the following changes:

Change:  gen inter_nchild=minority*hhnc_white1 to gen inter_nchild=minority*hhnc_white

Change:  gen inter_nchildnw=minority*hhnc_nwhite1 to gen inter_nchildnw=minority*hhnc_nwhite

*/

gen inter_child=minority*hhwc_white
gen inter_nchild=minority*hhnc_white1
gen inter_childnw=minority*hhwc_nwhite
gen inter_nchildnw=minority*hhnc_nwhite1
gen inter_childy=minority*hhwyc_white
gen inter_childnwy=minority*hhwyc_nwhite

}

* Column 4 of Table 6 Regression

reg pyes inter_child inter_childnw inter_nchild inter_nchildnw `controls1' [w=totreg], cluster(scode)

* Column 3 of Table 8 Regression

reg pyes inter_child inter_childnw inter_nchild inter_nchildnw inter_childy inter_childnwy `controls2' [w=totreg], cluster(scode)

