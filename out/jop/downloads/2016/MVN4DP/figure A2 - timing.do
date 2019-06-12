set more off

import excel using "timing.xls", firstrow clear

gen yearmonth = ym(CalendarYear, Month)

format yearmonth %tm

local preselec = ym(2004, 11)
local preselec1 = `preselec' - .75

local taxelec_2 = ym(2001, 5)
local taxelec_21 = `taxelec_2' - .75

local taxelec_1 = ym(2002, 5)
local taxelec_11 = `taxelec_1' - .75

local taxelec0 = ym(2003, 5)
local taxelec01 = `taxelec0' - .75

local taxelec1 = ym(2004, 5)
local taxelec11 = `taxelec1' - .75

local taxelec2 = ym(2005, 5)
local taxelec21 = `taxelec2' - .75

local taxelec3 = ym(2006, 5)
local taxelec31 = `taxelec3' - .75

forvalues i = 2002(1)2006 {
	local l`i' = ym(`i', 1)
}

tabulate t0, gen(t0)
tabulate t1, gen(t1)
tabulate t2, gen(t2)
tabulate t3, gen(t3)
tabulate t_1, gen(t_1)
tabulate t_2, gen(t_2)
tabulate t_3, gen(t_3)

replace t31 = t31 - 3
replace t21 = t21 - 2
replace t11 = t11 - 1
replace t12 = t12 - 1
replace t_11 = t_11 + 1
replace t_12 = t_12 + 1
replace t_21 = t_21 + 2
replace t_22 = t_22 + 2
replace t_31 = t_31 + 3
replace t_32 = t_32 + 3

local taxeff_3 = ym(2006, 7)
local taxeff_2 = ym(2005, 7)
local taxeff_1 = ym(2004, 7)
local taxeff = ym(2003, 7)
local taxeff1 = ym(2002, 7)
local taxeff2 = ym(2001, 7)
local taxeff3 = ym(2000, 7)

#delimit;

gr tw 

	(sc t_31 yearmonth if yearmonth < `taxeff_3', col(black) msym(O) mfcol(white))
	(sc t_32 yearmonth if yearmonth >= `taxeff_3', col(black) msym(O))

	(sc t_21 yearmonth if yearmonth < `taxeff_2', col(black) msym(O) mfcol(white))
	(sc t_22 yearmonth if yearmonth >= `taxeff_2', col(black) msym(O))
	
	(sc t_11 yearmonth if yearmonth < `taxeff_1', col(black) msym(O) mfcol(white))
	(sc t_12 yearmonth if yearmonth >= `taxeff_1', col(black) msym(O))
		
	(sc t01 yearmonth if yearmonth < `taxeff', col(black) msym(O) mfcol(white))
	(sc t02 yearmonth if yearmonth >= `taxeff', col(black) msym(O))

	(sc t11 yearmonth if yearmonth < `taxeff1', col(black) msym(O) mfcol(white))
	(sc t12 yearmonth if yearmonth >= `taxeff1', col(black) msym(O))
	
	(sc t21 yearmonth if yearmonth >= `taxeff2', col(black) msym(O))

	(sc t31 yearmonth if yearmonth >= `taxeff3', col(black) msym(O))

	(scatteri 5.8 `preselec1' "Presidential Vote t", msymbol(i) mlabpos(0) mlabangle(90))		
	(scatteri 5.8 `taxelec01' "Tax Increase Vote t", msymbol(i) mlabpos(0) mlabangle(90))	
	(scatteri 5.8 `taxelec_11' "Tax Increase Vote t+1", mlabcol(gray)  msymbol(i) mlabpos(0) mlabangle(90))		
	(scatteri 5.8 `taxelec11' "Tax Increase Vote t-1", mlabcol(gray)  msymbol(i) mlabpos(0) mlabangle(90))	
	(scatteri 5.8 `taxelec21' "Tax Increase Vote t-2", mlabcol(gray)  msymbol(i) mlabpos(0) mlabangle(90))	
	(scatteri 5.8 `taxelec31' "Tax Increase Vote t-3", mlabcol(gray)  msymbol(i) mlabpos(0) mlabangle(90))		
	,
		xline(`preselec') 
		xline(`taxelec0')
		xline(`taxelec_1', lpat(dash) lcol(gray))
		xline(`taxelec1', lpat(dash) lcol(gray))
		xline(`taxelec2', lpat(dash) lcol(gray))		
		xline(`taxelec3', lpat(dash) lcol(gray))		
		xlab(`l2002' `l2003' `l2004' `l2005' `l2006')
		legend(off)
		plotregion(style(none))
		yscale(range(-1 6.7))
		ylab(
			4 "(Three Year Lead [Placebo] t-3"
			3 "(Two Year Lead [Placebo] t-2"
			2 "(One Year Lead [Partially Treated] t-1"
			1 "(Treated) t" 
			0 "(One Year Lag [Treated]) t+1"
			-1 "(Two Year Lag [Treated]) t+2"
			-2 "(Three Year Lag [Treated]) t+3"
			,
			angle(horiz)
		)
		xtitle("Year and Month")
		ytitle("Tax Increase Coding")
		ysize(1) 
		xsize(2)
		;
		
#delimit cr
	
gr export "figure A2.eps", replace
