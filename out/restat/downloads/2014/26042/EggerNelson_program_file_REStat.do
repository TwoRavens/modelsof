clear
capture log close 
capture set virtual off
set memory 10000m 
capture set matsize 300 
capture set more off
memory

log using YOURPATH\EggerNelson_program_file_REStat, replace 
use YOURPATH\EggerNelson_data_REStat.dta, clear
keep if lxij~=.&lmij~=.

*** TABLE 1 - AD-counts ALL - time effects ***
reg ltxij adinit ccijy ncu nfta _x_* ldist nbord nlang
predict polsm, xb
destest
xtreg ltxij adinit ccijy ncu nfta _x_* ldist nbord nlang, fe i(bilat)
predict fem, xbu
destest
qui xtreg ltxij adinit ccijy ncu nfta _x_* ldist nbord nlang, re i(bilat)
xthausman
reg ltxij wadinit wccijy wncu wnfta _x_* wldist wnbord wnlang
predict wpolsm, xb
destest
gen dpolsp=polsm-wpolsm
reg ltxij dpolsp adinit ccijy ncu nfta _x_* ldist nbord nlang
xtreg ltxij wadinit wccijy wncu wnfta _x_* wldist wnbord wnlang, fe i(bilat)
predict wfem, xbu
destest
qui xtreg ltxij wadinit wccijy wncu wnfta _x_* wldist wnbord wnlang, re i(bilat)
xthausman
gen dfemp=fem-wfem
xtreg ltxij dfemp adinit ccijy ncu nfta _x_*, fe i(bilat)
drop polsm fem wpolsm dpolsp wfem dfemp

*** TABLE 2 - AD-counts ALL - time effects ***
* (i) *
qui xtreg ltxij wadinit wccijy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)
destest
testparm wnwto1 wnwto2 wnu wnp wnb wnpta

* (ii) *
qui xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)
destest
testparm wadinit wadinitl1 
di _coef[wadinit]+_coef[wadinitl1] " " invttail(r(df_r),r(p))
testparm wccijy wccijyl1
di _coef[wccijy]+_coef[wccijyl1] " " invttail(r(df_r),r(p)) 
testparm wadinitl1 wccijyl1 
bootstrap b1=(_coef[wadinit]+_coef[wadinitl1]) b2=(_coef[wccijy]+_coef[wccijyl1]): xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)

* (iii) *
qui xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)
destest
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(r(df_r),r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(r(df_r),r(p)) 
testparm wadinitl1 wccijyl1 
bootstrap b1=(_coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2]) b2=(_coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]): xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)

* (iv) *
qui xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)
destest
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(r(df_r),r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(r(df_r),r(p)) 
testparm wadinitj wccjiy
bootstrap b1=(_coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2]) b2=(_coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]): xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)

* (v) *
qui xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta lgdpx lgdpm _x_*, fe i(bilat)
destest
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(r(df_r),r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(r(df_r),r(p)) 
testparm lgdp* 
bootstrap b1=(_coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2]) b2=(_coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]): xtreg ltxij wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta lgdpx lgdpm _x_*, fe i(bilat)
qui xtreg ltxij wsadinit wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)
destest
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(r(df_r),r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(r(df_r),r(p)) 
qui xtreg ltxij wsadinit wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta lgdpx lgdpm _x_*, fe i(bilat)
destest
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(r(df_r),r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(r(df_r),r(p)) 

* (v) *
for var wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*: egen m_X=mean(X), by(bilat)
qui xtreg ltxij Gmills wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_* m_*, re i(bilat)
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(221080-137,r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(221080-137,r(p)) 
bootstrap b1=(_coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2]) b2=(_coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]): xtreg ltxij Gmills wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_* m_*, re i(bilat)

* (vi) *
keep bilat year ltxij Gmills wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_* lgdpx lgdpm
for var wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_* lgdpx lgdpm: egen m_X=mean(X), by(bilat)
qui xtreg ltxij Gmills wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta lgdpx lgdpm _x_* m_*, re i(bilat)
testparm wadinit wadinitl1 wadinitl2 
di _coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2] " " invttail(221080-137,r(p))
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2] " " invttail(221080-137,r(p)) 
bootstrap b1=(_coef[wadinit]+_coef[wadinitl1]+_coef[wadinitl2]) b2=(_coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]): xtreg ltxij Gmills wadinit wccijy wadinitl1 wccijyl1 wadinitl2 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta lgdpx lgdpm _x_* m_*, re i(bilat)

*** (viii) ***
qui xtreg ltxij Awadinit Awccijy Awccijyl1 Awccijyl2 Awadinitj Awccjiy Awncu Awnfta Awnwto1 Awnwto2 Awnu Awnp Awnb Awnpta _x_*, fe i(bilat)
destest
testparm wccijy wccijyl1 wccijyl2
di _coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]
testparm wadinitj wccjiy
bootstrap b1=(_coef[wadinit]) b2=(_coef[wccijy]+_coef[wccijyl1]+_coef[wccijyl2]): xtreg ltxij wadinit wccijy wccijyl1 wccijyl2 wadinitj wccjiy wncu wnfta wnwto1 wnwto2 wnu wnp wnb wnpta _x_*, fe i(bilat)

exit

