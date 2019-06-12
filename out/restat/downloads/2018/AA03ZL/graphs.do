set scheme lean1
graph set window fontface "Times New Roman"

global label_employed "A. 1(Employed)"
global label_labforce "B. 1(Participated in Labor Force)"
global label_worked_40 "C. 1(Worked At Least 40 Weeks)"
global label_ihsinctot "D. Total Income"

foreach var in employed labforce  ihsinctot  worked_40  {

	use "yby_`var'", clear
		g sample="Pooled Censuses"
		
		keep if strpos(parm,"birthyrz#c")>0 & strpos(parm,"goiter")>0
		g year=""
		replace year=substr(parm,1,4) 
		destring year, replace


		label variable year "Year"

		eclplot estimate min95 max95 year, ///
			yline(0)    supby(sample, spaceby(.3)) estopts1(msymbol(O)) estopts2(msymbol(X)) estopts3(msymbol(dh)) /*legend(position(7))*/ ///
			xline(1924,lcolor(gs8) lpattern(dash)) title("${label_`var'}") legend(off) ytitle("Goiter Interaction Coefficient")
			
	graph export "yby_`var'.png", as(png) width(4000) replace
	
}


	use "yby_ihsinctot1912", clear
		g sample="Pooled Censuses"
		
		keep if strpos(parm,"birthyrz#c")>0 & strpos(parm,"goiter")>0
		g year=""
		replace year=substr(parm,1,4) 
		destring year, replace


		label variable year "Year"

		eclplot estimate min95 max95 year, ///
			yline(0)    supby(sample, spaceby(.3)) estopts1(msymbol(O)) estopts2(msymbol(X)) estopts3(msymbol(dh)) /*legend(position(7))*/ ///
			xline(1924,lcolor(gs8) lpattern(dash)) title("") legend(off) ytitle("Goiter Interaction Coefficient")
			
	graph export "yby_ihsinctot_1912.png", as(png) width(4000) replace
	
