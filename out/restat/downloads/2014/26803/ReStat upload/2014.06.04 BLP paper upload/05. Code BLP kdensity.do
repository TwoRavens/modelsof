********************************************************************************
* To accompany Knittel and Metaxoglou
********************************************************************************
clear all
set memo 5000m
set type double
set more off
capture log close

********************************************************************************
* Define globals for paths and files
********************************************************************************
global root     = "C:/DB/Dropbox/RCOptim/ReStat/RESTAT Codes"
global root1    = "$root/2014.06.04 BLP"
global root2    = "$root/2014.06.04 BLP tight inner"
global paper    = "$root/2014.06.04 BLP paper"
global figures  = "$paper/Figures"
global tables   = "$paper/Figures"
global logs     = "$paper/Logs"
global temp     = "$paper/Temp"	

global graph_options = "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"

set scheme sj, permanently

graph set window fontface "Times New Roman"
graph set eps    fontface "Times New Roman"

********************************************************************************
foreach myvar0    in "price" "mpg" {

foreach myvar_str in "mean" "sigma" {

	use "$tables/blp_`myvar0'_optim_var.dta", clear
	
	replace `myvar0'_sigma=abs(`myvar0'_sigma)

	if "`myvar0'"=="price" & "`myvar_str'"=="mean"  {
		global myvar     `myvar0'_mean
		global myvar_se  `myvar0'_mean_se

		global xmin = -1.05
		global xmax = -0.15
		global xinc =  0.1

		global ymin=0
		global ymax=8
		global yinc=1
	}	
	
	if "`myvar0'"=="price" & "`myvar_str'"=="sigma" {
		global myvar     `myvar0'_sigma
		global myvar_se  `myvar0'_sigma_se

		global xmin = 0
		global xmax = 0.6
		global xinc = 0.05

		global ymin=0
		global ymax=16
		global yinc=2
	}	

	if "`myvar0'"=="mpg" & "`myvar_str'"=="mean"  {
		global myvar     `myvar0'_mean
		global myvar_se  `myvar0'_mean_se

		global xmin = -10
		global xmax =   1
		global xinc =   1

		global ymin=0
		global ymax=1.2
		global yinc=0.1
	}	

	if "`myvar0'"=="mpg" & "`myvar_str'"=="sigma"  {
		global myvar     `myvar0'_sigma
		global myvar_se  `myvar0'_sigma_se

		global xmin = 0
		global xmax = 5
		global xinc = 0.5

		global ymin=0
		global ymax=1.8
		global yinc=0.2
	}	

	

	set seed 19751208
	* same upper bound with the hbox in figure 1
	* 340 is very close to the 90th percentile of fval if converged==1
	keep  if fval<340
		
	gsort fval
		
	local mean  = $myvar     in 1
	local sigma = $myvar_se  in 1
	
	

	preserve	
		clear
		set obs 10000
		set seed 2026524840
		gen draws=rnormal(`mean',`sigma')
		rename draws $myvar
		gen draws=1
		gen tol_tight=1
		gen converged=1
		gen optmethod_str="XXXX"
		gen stvalue=999
		save "$temp/xx1.dta", replace	
	restore		
	
	keep tol_tight converged optmethod_str stvalue $myvar flag_local flag_best fval
	gen draws=0
	
	append using "$temp/xx1.dta"
	
	if "`myvar0'"=="price" & "`myvar_str'"=="mean" {	
	local bw=0.04
	}
	
	if "`myvar0'"=="price" & "`myvar_str'"=="sigma" {	
	local bw=0.02
	}
	
	if "`myvar0'"=="mpg" & "`myvar_str'"=="mean" {	
	local bw=0.2
	}
	
	if "`myvar0'"=="mpg" & "`myvar_str'"=="sigma" {	
	local bw=0.2
	}
		
	kdensity $myvar            , nograph generate(x fx)       
	kdensity $myvar if draws==0, nograph generate(fx0) at(x)  
	
	kdensity $myvar if draws==1, nograph generate(fx1) at(x)  
	qui return list
	disp "`r(bwidth)'"
	
	
	kdensity $myvar if draws==0, nograph generate(x00 fx00) 
	kdensity $myvar if draws==1, nograph generate(x11 fx11) 
	
	gen fxn=normalden(x,`mean',`sigma')
	
	qui sum x11 
	qui return list 
	replace fx1=. if x>`r(max)'
	replace fx1=. if x<`r(min)'

	replace fxn=. if x>`r(max)'
	replace fxn=. if x<`r(min)'
	
	
	label var fx0 "Optimization Variation"
	label var fx1 "Sample Variation"
	label var fxn "Sample Variation"
	
	disp "the mean is  : `mean'"
	disp "the sigma is : `sigma'"
	
	gen var_round  = round($myvar,0.01)
	gen fval_round = round(fval,0.01)
			
	if "`myvar0'"=="price" & "`myvar_str'"=="mean" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.2f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, nogrid angle(h)) xtitle("Mean", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(11) cols(1)) scale(0.7)		
	}	
	
	if "`myvar0'"=="price" & "`myvar_str'"=="sigma" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.2f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, nogrid angle(h)) xtitle("Standard Deviation", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(2) cols(1)) scale(0.7)
	}	
	

	if "`myvar0'"=="mpg" & "`myvar_str'"=="mean" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.0f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, nogrid angle(h) format(%5.1f)) xtitle("Mean", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(11) cols(1)) scale(0.7)
	}	
	
	if "`myvar0'"=="mpg" & "`myvar_str'"=="sigma" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.1f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, nogrid angle(h) format(%5.1f)) xtitle("Standard Deviation", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(2) cols(1)) scale(0.7)
	}	
	
	format  fx0 fx1 fx00 x00 fx11 %8.4f
	
	

	save         "$figures/fig_blp_kdens_`myvar0'_`myvar_str'.dta", replace
	graph export "$figures/fig_blp_kdens_`myvar0'_`myvar_str'.pdf", replace
	graph export "$figures/fig_blp_kdens_`myvar0'_`myvar_str'.eps", replace
	
	hist var_round if draws==0, fraction scale(0.7) bin(20) $graph_options ylabel(#10, angle(h) format(%5.2f)) xlabel(#10, angle(h) format(%5.2f)) xtitle("$myvar")
	
	graph export "$figures/fig_blp_hist_kdens_`myvar0'_`myvar_str'.pdf", replace

	count
	

if "`myvar0'"=="price" & "`myvar_str'"=="mean" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.2f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, format(%5.0f) nogrid angle(h)) xtitle("Mean", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(2) cols(1)) scale(1.0)		
	}	
	
	if "`myvar0'"=="price" & "`myvar_str'"=="sigma" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.2f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, format(%5.0f) nogrid angle(h)) xtitle("Standard Deviation", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(2) cols(1)) scale(1.0)
	}	
	

	if "`myvar0'"=="mpg" & "`myvar_str'"=="mean" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.0f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, nogrid angle(h) format(%5.1f)) xtitle("Mean", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(11) cols(1)) scale(1.0)
	}	
	
	if "`myvar0'"=="mpg" & "`myvar_str'"=="sigma" {	
		line fx1 fx0 x, sort ytitle(Density) $graph_options xscale(range($xmin $xmax)) xlabel($xmin($xinc)$xmax, nogrid format(%5.1f)) yscale(range($ymin $ymax)) ylabel($ymin($yinc)$ymax, nogrid angle(h) format(%5.1f)) xtitle("Standard Deviation", margin(medium)) ytitle("Density", margin(medium)) title("") legend(ring(0) pos(2) cols(1)) scale(1.0)
	}	
	
	format  fx0 fx1 fx00 x00 fx11 %8.4f
	
	graph export "$figures/fig_blp_kdens_`myvar0'_`myvar_str'_beam.pdf", replace
	graph export "$figures/fig_blp_kdens_`myvar0'_`myvar_str'_beam.eps", replace
	
	hist var_round if draws==0, fraction scale(1.0) bin(20) $graph_options ylabel(#10, angle(h) format(%5.2f)) xlabel(#10, angle(h) format(%5.2f)) xtitle("$myvar")
	
	graph export "$figures/fig_blp_hist_kdens_`myvar0'_`myvar_str'_beam.pdf", replace
	

}

}	
*EOF
