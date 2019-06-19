* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

use DataStata/data_arrow,clear
sort weight2008 weight_std

loc subsidy = 1
loc arrow_width =0.25
loc scattercolor green
loc xline "xline(1050,lw(0.2) lp(shortdash) lc(black)) "
loc keicolor green
loc col1 red
loc col2 blue
loc sw 0.3
loc gs gs6
loc gs2 gs2
loc xvar weight2008
loc xvar2 weight_std

* For Black and White colors for ReStat
loc keicolor black
loc col1 black
loc col2 black
loc scattercolor black

twoway ///
line target_km_lit2006to2015_120 `xvar2',lc(gs14) lw(`sw')   || ///
line target_km_lit2006to2015_110 `xvar2',lc(gs10) lw(`sw')   || ///
line target_km_lit2006to2015 `xvar2',lc(black) lw(`sw') || ///
scatter kmlit2008 weight2008 ,mc(`col2') lc(`col2') msize(vsmall) ms(o) mc(`scattercolor') || ///
pcarrowi 9.4 1050 9.4 980 (9),lc(`keicolor') mc(`keicolor') || ///
pcarrowi 8.4 1050 8.4 1110 (3),lc(`keicolor') mc(`keicolor') || ///
pcarrow kmlit2008 weight2008 kmlit weight if subsidy==`subsidy' & weight>=weight2008,lc(`col1') mc(`col1') lw(`arrow_width') barbsize(0) msize(small) || ///
pcarrow kmlit2008 weight2008 kmlit weight if subsidy==`subsidy' & weight<weight2008,mc(`col2') lc(`col2') lw(`arrow_width') barbsize(0) msize(small) || ///
,text(9.5 970 "Kei cars",place(w) color(`keicolor')) ///
text(8.5 1120 "Regular cars",place(e) color(`keicolor')) ///
xtitle("Weight (kg)") ytitle("Fuel Economy (km/liter)") title("") ///
`xline' xlabel(700(100)2150,labsize(small)) ylabel(8(2)26,angle(0) labsize(small))  ///
legend(ring(0) position(2) order(1 "1.2*Subsidy Cutoff" 2 "1.1*Subsity Cutoff" 3 "Subsidy Cutoff") c(1)) 
graph export $figure/arrow.pdf,replace

*** END











