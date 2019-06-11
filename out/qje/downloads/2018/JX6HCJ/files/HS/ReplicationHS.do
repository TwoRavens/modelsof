
*Table 1 - All okay - Ttests with unequal variances

use lab_data.dta, clear
gen condition=(100*certain)+10*px
table certain px, c(mean condition)
reshape wide x px task certain, i(id) j(condition)

label var x5 "quantity of x, px=.5, uncertain"
label var x10 "quantity of x, px=1, uncertain"
label var x20 "quantity of x, px=2, uncertain"
label var x105 "quantity of x, px=.5, certain"
label var x110 "quantity of x, px=1, certain"
label var x120 "quantity of x, px=2, certain"

gen px05_=x5
gen px05p_=x105
gen px1_=x10
gen px1p_=x110
gen px2_=x20
gen px2p_=x120
label var px05_ "$p_x^{BC}=0.5$ (uncertainty)" 
label var px05p_ "$p_x^{BC}=0.5$ (certainty)"
label var px1_ "$p_x^{BC}=1$ (uncertainty)"
label var px1p_ "$p_x^{BC}=1$ (certainty)"
label var px2_ "$p_x^{BC}=2$ (uncertainty)"
label var px2p_ "$p_x^{BC}=2$ (certainty)"

gen economistandmore=(inlist(q6_1,"economics","financial economics","accounting","business administration") | inlist(q6_2,"economics","accounting","business administration"))
gen humanities=(inlist(q6_1,"arab language and literature","archeology","art history","bible studies","east asian studies","english","german language and literature","hebrew literature","indian and comparative folklore") | inlist(q6_1,"israeli thinking? (machshevet yisrael)","musicology","philosophy","yahadut zmanenu?")) | inlist(q6_2,"art history","comparative literature","comparetive literature","east asian studies","english","english linguistics","french","general studies (BA klali)","humanities") | inlist(q6_2,"islam","islam and middle east") | inlist(q6_2,"jewish studies","latin american studies","linguistics" 	,"linguistics", "literature", "middle eastern studies","philosophy","spanish","theater")
gen othersoc=(inlist(q6_1,"communications","education","international relations","political science","psychology" ,"social psychology","social work","sociology","sociology and anthropology") 	| inlist(q6_2,"communications","education","international relations","political science","psychology" ,"public policy","sociology","sociology and anthropology"))
gen female=(q7=="f")
gen age=2007-q8
gen d_age=age
gen highqx=(qx>5.98 & qx<6)

label var highqx "$p^S=\text{\$5.99}$"
label var econom "Economics, accounting, business"
label var humani "Humanities"
label var others "Social sciences (w/o economics)"
label var female "Female"
label var d_age "Age"
label var q2a "Caramel quality"
label var q2b "Peanut quality"
label var q3a "Caramel SWTP"
label var q3b "Peanut SWTP"

*Condensed version of their code
foreach demog in female d_age human econ othersoc q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	ttest `demog', by(highqx) unequal 
	}

*Note I drop the demographic characteristics and only examine the outcome measures

foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	ttest `demog', by(highqx) unequal
	}

save DatHS1, replace

***********************************

*Table 2 - All okay

use lab_data.dta, clear
keep if task==1 
gen q2diff=q2b-q2a
recode q2d (min/-1=-1) (1/max=1) ,gen(q2sdiff) 
gen q3diff=q3b-q3a
gen economistandmore=(inlist(q6_1,"economics","financial economics","accounting","business administration") | inlist(q6_2,"economics","accounting","business administration"))
gen humanities=(inlist(q6_1,"arab language and literature","archeology","art history","bible studies","east asian studies","english","german language and literature","hebrew literature","indian and comparative folklore") | inlist(q6_1,"israeli thinking? (machshevet yisrael)","musicology","philosophy","yahadut zmanenu?")) | inlist(q6_2,"art history","comparative literature","comparetive literature","east asian studies","english","english linguistics","french","general studies (BA klali)","humanities") | inlist(q6_2,"islam","islam and middle east") | inlist(q6_2,"jewish studies","latin american studies","linguistics" 	,"linguistics", "literature", "middle eastern studies","philosophy","spanish","theater")
gen othersoc=(inlist(q6_1,"communications","education","international relations","political science","psychology" ,"social psychology","social work","sociology","sociology and anthropology") 	| inlist(q6_2,"communications","education","international relations","political science","psychology" ,"public policy","sociology","sociology and anthropology"))
gen female=(q7=="f")
gen age=2007-q8
gen r_age=age-23 
gen r_age2=r_age^2
gen r_agemissing=(age==.)
replace r_age=0 if r_agemissing
replace r_age2=0 if r_agemissing
xi i.date,pre(day)
gen highqx=(qx>5.98 & qx<6)
sum q3d
local twicesd=2*r(sd)

foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	ologit q2sd `regressors'
	}

save DatHS2, replace

*****************************************************

*Table 3 - One rounding error

use lab_data.dta, clear

gen economistandmore=(inlist(q6_1,"economics","financial economics","accounting","business administration") | inlist(q6_2,"economics","accounting","business administration"))
gen humanities=(inlist(q6_1,"arab language and literature","archeology","art history","bible studies","east asian studies","english","german language and literature","hebrew literature","indian and comparative folklore") | inlist(q6_1,"israeli thinking? (machshevet yisrael)","musicology","philosophy","yahadut zmanenu?")) | inlist(q6_2,"art history","comparative literature","comparetive literature","east asian studies","english","english linguistics","french","general studies (BA klali)","humanities") | inlist(q6_2,"islam","islam and middle east") | inlist(q6_2,"jewish studies","latin american studies","linguistics" 	,"linguistics", "literature", "middle eastern studies","philosophy","spanish","theater")
gen othersoc=(inlist(q6_1,"communications","education","international relations","political science","psychology" ,"social psychology","social work","sociology","sociology and anthropology") 	| inlist(q6_2,"communications","education","international relations","political science","psychology" ,"public policy","sociology","sociology and anthropology"))
gen female=(q7=="f")
gen age=2007-q8
gen r_age=age-23 
gen r_age2=r_age^2
gen r_agemissing=(age==.)
replace r_age=0 if r_agemissing
replace r_age2=0 if r_agemissing
xi i.date,pre(day)
gen highqx=(qx>5.98 & qx<6)
gen stprice=0.5 if Qx==0.5 & px==0.5
replace stprice=2 if Qx==2 & px==2
label var stprice "standard price: Qx=px"

gen mypx=px
gen myQx=Qx
gen mystprice=stprice

foreach cert in 0 1 {
	foreach mainregressor in "mystprice" "mypx myQx" {
		foreach regressors in "`mainregressor'" "`mainregressor' female r_agemiss r_age r_age2 human econ othersoc day*" {
			reg x `regressors' if certain==`cert' & px~=1, cluster(id)
			}
		}
	}


*Eliminate columns 1, 2, 5 & 6 because these combine the effect of the treatment with the price (i.e. restricted to treatment = price)

foreach cert in 0 1 {
	foreach regressors in "px Qx" "px Qx female r_agemiss r_age r_age2 human econ othersoc day*" {
		reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}


save DatHS3, replace

*****************************************

*Only provide lab data, not the restaurant data (later in paper).


