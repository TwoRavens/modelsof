
cd "C:\Users\dtingley\Dropbox\M&A - Conjoint Experiment\data\finalgraphs"

use "C:\Users\dtingley\Dropbox\M&A - Conjoint Experiment\data\replication\USChinaReciprocity.dta", clear

forval z = 1/2 {
preserve
local reciplist1 "recipme recipse recipnc recipsh recipmh "
local reciplist2 "recip_t5 recip_t4 recip_t3 recip_t2 recip_t1"
local title1 "U.S. Experiment"
local title2 "China Experiment"
	foreach var of local reciplist`z' {
		local replace1 "1-(`var'-4)/4 if `var'!=."
		local replace2 "1-(`var'-1)/4 if `var'!=."
		replace `var'= `replace`z''
	}

	foreach i in varlabel xbar xhi xlo {
		gen `i' = .
	}

	local varcount: word count `reciplist`z''
	
	forval j = 1/`varcount' {
		local x: word `j' of `reciplist`z''
		qui sum `x'
		local se = r(sd) / sqrt(r(N))
		replace varlabel = `j' if _n==`j'
		replace xbar = r(mean) if _n==`j'
		replace xhi = xbar + (invttail(r(N),.025))*`se' if _n==`j'
		replace xlo = xbar - (invttail(r(N),.025))*`se' if _n==`j'
	}
		label values varlabel varlabs

	twoway rcap xhi xlo varlabel, lcolor(black) horiz ylab(1/`varcount', val angle(0)  ) xlab(, labsize(small)) ///
	   legend(off) ytitle("") xtitle("Average Response") ///
	   || scatter varlabel xbar, mcolor(black) ///
	   title("`title`z''", size(medsmall)) subtitle("", size(small)) xlabel(.2(.1)1) ///
	   mcolor(black black black black black)  msymbol(circle circle circle circle circle)  ///
	   note("", size(vsmall)) name(recip`z', replace) nodraw
restore
}

graph combine recip1 recip2, rows(2) b1("		0: Make much easier / 1: Make much harder", size(small))
	graph export "CombReciprocity2.pdf", replace
	


	
use "C:\Users\dtingley\Dropbox\M&A - Conjoint Experiment\data\replication\reciprocityfollowup.dta", clear
ciplot pref, by(treat) xlabel(.2(.2).8) horiz xtitle("Average Response" "(0 = Much Easier / 1 = Much Harder)") ytitle("First number is past position, second is present position.") note("")
graph export "recipfollow.pdf", replace


*Differences
encode treat, gen(treatf)
reg pref i.treatf



gen dif = .
gen diflo = .
gen difhi = .
gen var = ""
gen id = _n
gen se = .

*specify that the baseline be the 3-3 neutral level
reg pref ib5.treatf, cl(amazonid)
*3-3 to 6-3 VS 3-3 to 0-3 
mat list e(b)
nlcom abs(_b[8.treatf])-abs(_b[2.treatf] )
replace var = "58-52" if _n==1
mat b = r(b)
mat v = r(V)
replace dif = b[1,1] if _n==1
replace difhi = dif + 1.96*sqrt(v[1,1]) if _n==1
replace diflo = dif - 1.96*sqrt(v[1,1]) if _n==1
replace se = sqrt(v[1,1]) if _n==1

*3-3 to 3-0 VS 3-3 to 3-6  
* 54-56
nlcom abs(_b[4.treatf]) - abs(_b[6.treatf]) 
replace var = "54-56" if _n==2
mat b = r(b)
mat v = r(V)
replace dif = b[1,1] if _n==2
replace difhi = dif + 1.96*sqrt(v[1,1]) if _n==2
replace diflo = dif - 1.96*sqrt(v[1,1]) if _n==2
replace se = sqrt(v[1,1]) if _n==2
 
*6-0 VS 3-3 to 0-6  
* 57 - 5?

nlcom abs(_b[7.treatf]) - abs(_b[3.treatf]) 
replace var = "57-53" if _n==3
mat b = r(b)
mat v = r(V)
replace dif = b[1,1] if _n==3
replace difhi = dif + 1.96*sqrt(v[1,1]) if _n==3
replace diflo = dif - 1.96*sqrt(v[1,1]) if _n==3
replace se = sqrt(v[1,1]) if _n==3

* 0-0 VS  6-6
nlcom abs(_b[1.treatf]) - abs(_b[9.treatf]) 
replace var = "1-59" if _n==4
mat b = r(b)
mat v = r(V)
replace dif = b[1,1] if _n==4
replace difhi = dif + 1.96*sqrt(v[1,1]) if _n==4
replace diflo = dif - 1.96*sqrt(v[1,1]) if _n==4
replace se = sqrt(v[1,1]) if _n==4


twoway rcap  difhi diflo id if _n<5 , xlabel(-.2(.2).2) horiz xline(0) || scatter  id dif if _n<5 , ylabel(1 "3-3 to 6-3 VS 3-3 to 0-3" 2 "3-3 to 3-0 VS 3-3 to 3-6" 3 "3-3 to 6-0 VS 3-3 to 0-6" 4 "3-3 to 0-0 VS 3-3 to 6-6", angle(0)) ytitle("") xtitle("Difference in Absolute Difference" "(- is Negative Reciprocity / + is Positive Reciprocity)") legend(off)
graph export "recipdirection-differences2.pdf", replace

