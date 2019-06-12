
capture program drop test_ezop
do tests_ezop_bootstrap99_QTE_DISTRIBUTION_03groups.do

capture program drop tab1
program define tab1
	syntax [, myfile(string asis)]
*	local myfile "`asis'"
	file open myfile using `myfile', w replace
		file write myfile "\begin{tabular}{lcccccc}" _n "\hline\hline" _n
		file write myfile " & \multicolumn{6}{c}{Pairwise groups comparisons:}\\" _n 
		file write myfile "    & \multicolumn{2}{c}{D2 vs. D5} & \multicolumn{2}{c}{D2 vs. D9} & \multicolumn{2}{c}{D5 vs. D9}\\" _n
		file write myfile "\hline" _n
		file write myfile "\multicolumn{7}{l}{{\bf A - Cdfs, counterfactual setting ($ \pi = 0$)}}\\" _n
		file write myfile "$ H_0:\  \thicksim $ &" %12.1f (e(out1211))	"	&" "["%12.3f (e(out1212)) "]" "&"	%12.1f (e(out1311))	"&"	"["%12.3f (e(out1312))	"]" "&"	%12.1f (e(out2311))	"&"	"["%12.3f (e(out2312))	"] \\" _n
		file write myfile "$ H_0:\  \succcurlyeq$ &" %12.1f (e(out1213)) "	&" "["%12.3f (e(out1214)) "]"	"&"	%12.1f (e(out1313))	"&"	"["%12.3f (e(out1314))	"]" "&"	%12.1f (e(out2313))	"&"	"["%12.3f (e(out2314))	"] \\"  _n
		file write myfile "$ H_0:\  \preccurlyeq$ &" %12.1f (e(out1215)) "	&" "["%12.3f (e(out1216))	"]"	"&"	%12.1f (e(out1315))	"&"	"["%12.3f (e(out1316))	"]"	"&"	%12.1f (e(out2315))	"&"	"["%12.3f (e(out2316))	"] \\" _n
		file write myfile "\multicolumn{7}{l}{{\bf B - Cdfs, actual setting ($ \pi = 1$)}}\\" _n
		file write myfile "$ H_0:\  \thicksim$ &" %12.1f (e(out1221))	"	&" "["%12.3f (e(out1222))	"]" "&"	%12.1f (e(out1321))	"&"	"["%12.3f (e(out1322))	"]" "&"	%12.1f (e(out2321)) "&"	"["%12.3f (e(out2322))	"] \\" _n
		file write myfile "$ H_0:\  \succcurlyeq$ &" %12.1f (e(out1223)) "	&" "["%12.3f (e(out1224))	"]"	"&"	%12.1f (e(out1323))	"&"	"["%12.3f (e(out1324))	"]" "&"	%12.1f (e(out2323))	"&"	"["%12.3f (e(out2324))	"] \\" _n
		file write myfile "$ H_0:\  \preccurlyeq$ &" %12.1f (e(out1225)) "	&" "["%12.3f (e(out1226))	"]"	"&"	%12.1f (e(out1325))	"&"	"["%12.3f (e(out1326))	"]" "&"	%12.1f (e(out2325))	"&"	"["%12.3f (e(out2326))	"] \\" _n
		file write myfile "\multicolumn{7}{l}{{\bf C - Gap curves ($ \pi = 0$ vs $ \pi=1$)}}\\" _n
		file write myfile "$ H_0:$ Neutrality &" %12.1f (e(out1231)) "	&" "["%12.3f (e(out1232))	"]"	"&"	%12.1f (e(out1331))	"&"	"["%12.3f (e(out1332))	"]" "&"	%12.1f (e(out2331))	"&"	"["%12.3f (e(out2332))	"] \\" _n
		file write myfile "$ H_0:$ Equalization &" %12.1f (e(out1233)) "	&" "["%12.3f (e(out1234))	"]"	"&"	%12.1f (e(out1333))	"&"	"["%12.3f (e(out1334))	"]" "&"	%12.1f (e(out2333))	"&"	"["%12.3f (e(out2334))	"] \\" _n
		file write myfile "$ H_0:$  Disequalization &" %12.1f (e(out1235)) "	&" "["%12.3f (e(out1236))	"]"	"&"	%12.1f (e(out1335))	"&"	"["%12.3f (e(out1336))	"]" "&"	%12.1f (e(out2335))	"&"	"["%12.3f (e(out2336))	"] \\" _n
		file write myfile "\hline \hline" _n 
		file write myfile "\end{tabular}"
	file close myfile
end

noi test_ezop, qmin(5) qmax(95) groups(3) myfile("data_merged") qte
tab1, myfile("tab_ezop_5(5)95_QTE.tex")


*	Set material for the graphs

use data_merged.dta, clear

keep ez_i2_p1t1 ez_i5_p1t1 ez_i9_p1t1 rif_ez_*i2 rif_ez_*i5 rif_ez_*i9 quantile repl
rename ez_i2_p1t1 ez_i1_p1t1
rename ez_i5_p1t1 ez_i2_p1t1
rename ez_i9_p1t1 ez_i3_p1t1
local names "MEAN MEDIAN ATMEDIAN"
foreach x of local names {
	rename rif_ez_`x'i2 rif_ez_`x'i1
	rename rif_ez_`x'i5 rif_ez_`x'i2
	rename rif_ez_`x'i9 rif_ez_`x'i3			
}

		
qui sum repl
local repmax = r(max)
qui sum quantile if repl==1
local qmax = r(max)

foreach x of numlist 1(1)3 {
	mkmat ez_i`x'_p1t1 if repl==1, mat(Q`x') nomis
	mkmat rif_ez_MEANi`x' if repl==1, mat(QTE`x') nomis
	foreach rep of numlist 2(1)`repmax' {
		mkmat ez_i`x'_p1t1 if repl==`rep', mat(Q`x'`rep') nomis
		mkmat rif_ez_MEANi`x' if repl==`rep', mat(QTE`x'`rep') nomis
		mat Q`x' = Q`x', Q`x'`rep'
		mat QTE`x' = QTE`x', QTE`x'`rep'
	}
	mat Q0`x' = Q`x' - QTE`x'
*	mata : st_matrix("QTE`x'`rep'", sort(st_matrix("QTE`x'`rep'"), 1))
	local matn "Q`x' Q0`x' QTE`x'"
	foreach M of local matn {
		mat `M' = `M''
		mata: m`M' = mean(st_matrix("`M'"))
		mata: cv`M' = variance(st_matrix("`M'"))
		mata: st_matrix("`M'", m`M'')
		mata: st_matrix("S`M'", cv`M'')
	}
}

//	Report retuls in a .dta file for 99 quantiles
clear
foreach x of numlist 1(1)3 {
	local matn "SQ`x' SQ0`x' SQTE`x'"
	foreach M of local matn {
		mat se`M' = J(99,1,.)
		foreach i of numlist 1(1)99 {
			mat se`M'[`i',1] = sqrt(`M'[`i',`i'])
		}
	}
	local mat2 "Q`x' seSQ`x' Q0`x' seSQ0`x' QTE`x' seSQTE`x'"
	foreach M of local mat2 {
		local coln  "`M'"
		mat colnames `M' = `coln' 
		svmat `M', n(col)
	}
}
save data99q, replace
clear



//	Figures of QTE and gaps

use data99q.dta, clear

local 1 "1%-10%"
local 2 "40%-50%"
local 3 "90%-99%"

local j =  1
while `j'<=3 {
	label var QTE`j' "QTE, quantile ``j''"
	label var Q`j'  "Quantile ``j'', actual"
	label var Q0`j'  "Quantile ``j'', counterf."
	local j2 = `j' + 1
	if `j'==3 {
		local j = `j' + 1
		continue
	}
	foreach i of numlist `j2'(1)3 {
		gen gap`j'`i'0 = Q0`i' - Q0`j'
		label var gap`j'`i'0 "Gap ``i'' vs ``j'', counterf."
		gen gap`j'`i'1 = Q`i' - Q`j'
		label var gap`j'`i'1 "Gap ``i'' vs ``j'', actual"
		gen Dgap`j'`i' = gap`j'`i'0 - gap`j'`i'1
		label var Dgap`j'`i' "Difference between gap curves"
	}
	local j = `j' + 1
}
gen quantiles = _n
label var quantiles "Percentiles"



//	Produce CONFIDENCE BANDS for the differences in gap curves:


local j =  1
while `j'<=3 {
	if `j'==3 {
		local j = `j' + 1
		continue
	}
	local j2 = `j' + 1
	foreach i of numlist `j2'(1)3 {
		gen seGAP`j'`i' = sqrt(seSQTE`j'^2 + seSQTE`i'^2)
*		gen LseGAP`j'`i' = Dgap`j'`i' - 1.68*seGAP`j'`i'
*		gen UseGAP`j'`i' = Dgap`j'`i' + 1.68*seGAP`j'`i'
		gen LseGAP`j'`i' = Dgap`j'`i' - 2.33*seGAP`j'`i'
		gen UseGAP`j'`i' = Dgap`j'`i' + 2.33*seGAP`j'`i'
		label var LseGAP`j'`i' "Lower 99%CI"
		label var UseGAP`j'`i' "Upper 99%CI"
	}
	local j = `j' + 1
}




//	Corrrect graphs to put on the document  - ADVANCED VERSION WITH AREA CI AND SPECIFIC FORMAT

local if "if quantiles>=5 & quantiles<=95"
local if1 "if QTE1>=-60000 & QTE1<=60000"
local if2 "if QTE2>=-60000 & QTE2<=60000"
local if3 "if QTE3>=-60000 & QTE3<=60000"
local if4 "if QTE4>=-60000 & QTE4<=60000"
local if01 "if Q01<=800000"
local if02 "if Q02<=800000"
local if03 "if Q03<=800000"
local if04 "if Q04<=800000"
local if11 "if Q1<=800000"
local if12 "if Q2<=800000"
local if13 "if Q3<=800000"
local if14 "if Q4<=800000"

local color1 "black"
local color2 "gs9"
local opt "	ytitle(, color(black)) xtitle(, color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black)) legend(on rows(2) size(small) color(black) position(6)) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt2 "ytitle(, color(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle(, color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black)) legend(on rows(2) size(small) color(black) position(6)) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt3 "ytitle("Earnings (NOK)", size(small) color(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) ylabel(-60000(30000)60000, labels labsize(small) labcolor(black)) xtitle("Percentiles of earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labsize(small)) legend(on cols(2) size(small) color(black) position(11) ring(0) label(1 "Lower class") label(2 "Middle class") label(3 "Upper class")) scheme(s1color)"
local opt4 "ytitle("Earnings (NOK)", size(small) color(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) ylabel(0(200000)800000, labels labsize(small) labcolor(black)) xtitle("Percentiles of earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labsize(small)) legend(on cols(2) size(small) color(black) position(11) ring(0) label(1 "Lower class") label(2 "Middle class") label(3 "Upper class")) scheme(s1color)"

twoway (line Q1 quantiles `if11', lcolor(`color1') lwidth(medthick) lpattern(solid) connect(direct))  ///
	(line Q2 quantiles `if12', lcolor(`color1') lwidth(medthick) lpattern(dash) connect(direct)) ///
	(line Q3 quantiles `if13', lcolor(`color1') lwidth(medthick) lpattern(longdash_dot) connect(direct)) ///
	`if', `opt4' 
*graph export gQ.png, replace wid(918) hei(668)
graph export gQ.pdf, replace 

twoway (line Q01 quantiles `if01', lcolor(`color2') lwidth(medthick) lpattern(solid) connect(direct)) ///
	(line Q02 quantiles `if02', lcolor(`color2') lwidth(medthick) lpattern(dash) connect(direct)) ///
	(line Q03 quantiles `if03', lcolor(`color2') lwidth(medthick) lpattern(longdash_dot) connect(direct)) ///
	`if', `opt4'
*graph export gQ0.png, replace wid(918) hei(668)
graph export gQ0.pdf, replace 

twoway (line QTE1 quantiles `if1', lcolor(`color1') lwidth(medthick) lpattern(solid) connect(direct)) ///
	(line QTE2 quantiles `if2', lcolor(`color1') lwidth(medthick) lpattern(dash) connect(direct)) ///
	(line QTE3 quantiles `if3', lcolor(`color1') lwidth(medthick) lpattern(longdash_dot) connect(direct)) ///
	`if', `opt3'
*graph export gQTE.png, replace wid(918) hei(668)
graph export gQTE.pdf, replace 


local if "if quantiles>=5 & quantiles<=95"
local maxy = 200000
local color1 "black"
local color2 "gs9"
local color3 "gs14"
local opt "	ytitle(, color(black)) xtitle(, color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black)) legend(on rows(2) size(small) color(black) position(6)) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt2 "ytitle(, color(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) xtitle(, color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black)) legend(on rows(2) size(small) color(black) position(6)) graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))"
local opt3 "ytitle("Earnings (NOK)", size(small) color(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) ylabel(, labels labsize(small) labcolor(black)) xtitle("Percentiles of earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labsize(small)) legend(on order(2 3 4 1) cols(2) size(small) color(black) position(11) ring(0) label(2 "Gap curve - counterfactual") label(3 "Gap curve - actual") label(4 "Gap curves difference") label(1 "CI 99%")) scheme(s1color)"
local opt4 "ytitle("Earnings (NOK)", size(small) color(black)) yline(0, lwidth(medthin) lpattern(solid) lcolor(black)) ylabel(-50000(50000)`maxy', labels labsize(small) labcolor(black)) xtitle("Percentiles of earnings", size(small) color(black)) xscale(range(0 99)) xlabel(0(10)99, labcolor(black) labsize(small)) legend(on order(2 3 4 1) cols(2) size(small) color(black) position(11) ring(0) label(2 "Gap curve - counterfactual") label(3 "Gap curve - actual") label(4 "Gap curves difference") label(1 "CI 99%")) scheme(s1color)"

foreach x of numlist 1(1)2 {
	local y = `x'+1
	while `y'<= 3 {
		twoway (rarea LseGAP`x'`y' UseGAP`x'`y' quantiles if UseGAP`x'`y'<=`maxy', color(`color3')  ) ///
			(line gap`x'`y'0 quantiles if gap`x'`y'0<=`maxy', lcolor(`color2') lwidth(medthick) lpattern(solid) connect(direct)) ///
			(line gap`x'`y'1 quantiles if gap`x'`y'1<=`maxy', lcolor(`color1') lwidth(medthick) lpattern(solid) connect(direct)) ///
			(line Dgap`x'`y' quantiles if Dgap`x'`y'<=`maxy', lcolor(`color1') lwidth(medthick) lpattern(dash) connect(direct)) ///
			`if', `opt4'
*		graph export gGAP`x'`y'CI.png, replace wid(2062) hei(1500)
		graph export gGAP`x'`y'CI.pdf, replace 		
		local y = `y'+1
	}
}
