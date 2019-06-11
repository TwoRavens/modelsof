/* 	27 December 2017
	Mallory Compton
	Replication do-file FINALv
	*/
	
clear
cap log close
set more off
local date="$S_DATE"
local time="$S_TIME"
version 12.1

/* Insert your file path here  */
cd "/Users/mecv/Documents/Dropbox/SC_Security_v12.3/replication"
log using "SPPQ-15-0108_replication_`date'_`time'.log", replace

display "$S_TIME  $S_DATE"
****************************************************

use "SPPQ-15-0108_replication.dta", clear


global controls "l.uniondensity l.govideo l.indivinctaxpcr l.corptinctaxpcr l.enerprice  pov_rtfull post1996 devolvedpost1996 l.unemprt d.unemprt logtot gspgrowth logrgdp racialdiversity "

codebook

****************************************************
******************** Models*************************
****************************************************

// H1 & H2, Table 1	
xtabond ESI l.socap_ma l.transfers_allpcr $controls
	display _b[l.socap_ma]/(1-_b[l.ESI]) 
	testnl _b[l.socap_ma]/(1-_b[l.ESI])=0	
xtabond ESI l.socap_ma l.transfers_incpcr $controls	
	display _b[l.socap_ma]/(1-_b[l.ESI]) 
	testnl _b[l.socap_ma]/(1-_b[l.ESI])=0
xtabond ESI l.socap_ma l.transfers_uipcr $controls
	display _b[l.socap_ma]/(1-_b[l.ESI]) 
	testnl _b[l.socap_ma]/(1-_b[l.ESI])=0
xtabond ESI l.socap_ma l.transfers_medpcr $controls
	display _b[l.socap_ma]/(1-_b[l.ESI]) 
	testnl _b[l.socap_ma]/(1-_b[l.ESI])=0
xtabond ESI l.socap_ma l.transfers_incpcr l.transfers_uipcr l.transfers_medpcr $controls 
	display _b[l.socap_ma]/(1-_b[l.ESI]) 
	testnl _b[l.socap_ma]/(1-_b[l.ESI])=0
	display _b[l.transfers_incpcr]/(1-_b[l.ESI]) 
	display (_b[l.transfers_incpcr]/(1-_b[l.ESI]))*.47 
	testnl _b[l.transfers_incpcr]/(1-_b[l.ESI])=0
	display _b[l.transfers_uipcr]/(1-_b[l.ESI]) 
	display (_b[l.transfers_uipcr]/(1-_b[l.ESI]))*.06  
	testnl _b[l.transfers_uipcr]/(1-_b[l.ESI])=0
	display _b[l.transfers_medpcr]/(1-_b[l.ESI]) 
	display (_b[l.transfers_medpcr]/(1-_b[l.ESI]))*2.1 
	testnl _b[l.transfers_medpcr]/(1-_b[l.ESI])=0
xtabond ESI l.socap_ma  l.gsp_stlgovpcr $controls
	display _b[l.socap_ma]/(1-_b[l.ESI]) // 
	testnl _b[l.socap_ma]/(1-_b[l.ESI])=0



// H3, Table 2
xtabond ESI l.transfers_allpcr l.socap_ma welXsc $controls
xtabond ESI l.transfers_incpcr l.transfers_uipcr l.transfers_medpcr l.socap_ma uiXsc medXsc incXsc $controls
xtabond ESI l.transfers_incpcr l.socap_ma incXsc $controls
xtabond ESI l.transfers_uipcr l.socap_ma uiXsc $controls
xtabond ESI l.transfers_medpcr l.socap_ma medXsc $controls
xtabond ESI l.gsp_stlgovpcr l.socap_ma totXsc $controls 



****************************************************
***************** Margins Figures ******************
****************************************************
xtabond ESI l.socap_ma l.transfers_incpcr l.transfers_uipcr l.transfers_medpcr /*
	*/ uiXsc medXsc incXsc l.uniondensity l.govideo l.indivinctaxpcr l.corptinctaxpcr /*
	*/ l.enerprice  pov_rtfull post1996 devolvedpost1996 l.unemprt d.unemprt /*
	*/ logtot gspgrowth logrgdp racialdiversity 
est store marginmodel
	
global spendiv "transfers_incpcr transfers_medpcr transfers_uipcr transfers_allpcr gsp_stlgovpcr socap_ma "
	
foreach v of varlist $spendiv socap_ma {
	sum l.`v'  if e(sample), det 
	global `v'90 = r(p90)
	global `v'10 = r(p10)
	global `v'm = r(mean)
	global `v'min = r(min)
	global `v'max = r(max)
	}
	sum l.ESI  if e(sample), det
	global lesim = r(mean)
	
set obs 50000 			

est restore marginmodel
sort cps year 

global axispts = 10

global scdif = ($socap_mamax-$socap_mamin)/$axispts
global trdif = ($transfers_allpcrmax-$transfers_allpcrmin)/$axispts

global n = 1

*******FIGURE 1A Predicted Insecurity over Social Capital
xtabond ESI l.transfers_allpcr l.socap_ma welXsc l.uniondensity l.govideo /*
	*/ l.indivinctaxpcr l.corptinctaxpcr /*
	*/ l.enerprice  pov_rtfull post1996 devolvedpost1996  l.unemprt d.unemprt /*
	*/ logtot gspgrowth logrgdp racialdiversity 
	est store fig1marginmodel

cap	gen fig1apred = .
cap	gen fig1aer = .
cap	gen fig1aup = .
cap	gen fig1alo = .
cap	gen fig1bpred = .
cap	gen fig1ber = .
cap	gen fig1bup = .
cap	gen fig1blo = .
	
cap	gen fig1axis = .

	forval sc = $socap_mamin($scdif)$socap_mamax {
	
		replace fig1axis = `sc' in $n
	
	****subfigure a
		local wXsc = $transfers_allpcr90*`sc'
		est restore fig1marginmodel

		margins, at( (asobserved) _factor (mean) _continuous ///
				l.socap_ma=(`sc') ///
				l.transfers_allpcr=($transfers_allpcr90) welXsc=(`wXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace fig1apred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace fig1aer = `v' in $n
					
			replace fig1aup = fig1apred + (1.96*sqrt(fig1aer))
			replace fig1alo = fig1apred - (1.96*sqrt(fig1aer))
												
	
	****subfigure b
		local wXsc = $transfers_allpcr10*`sc'
		est restore fig1marginmodel

		margins, at( (asobserved) _factor (mean) _continuous ///
				l.socap_ma=(`sc') ///
				l.transfers_allpcr=($transfers_allpcr10) welXsc=(`wXsc') ///
				) post vsquish
		
			mat b = r(b)
			local beta = b[1,1]
			replace fig1bpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace fig1ber = `v' in $n
					
			replace fig1bup = fig1bpred + (1.96*sqrt(fig1ber))
			replace fig1blo = fig1bpred - (1.96*sqrt(fig1ber))
												
				
		global n = $n+1			
	
	
		}


twoway rconnected fig1alo fig1aup fig1axis , msym(none) lpattern(dash_dot) lc(black) lwidth(thick) /*
	*/ || rconnected fig1blo fig1bup fig1axis, msym(none) lwidth(thick) /*
	*/  legend(order(1 "High Tot. Welfare Spending" 2 "Low Tot. Welfare Spending" ) /*
	*/ tstyle(size(small))) xtitle("Social Capital") ytitle(Predicted Economic Insecurity) /*
	*/ title("", size(vlarge)) scheme(s2mono)  xlabel(-3(1)3, labsize(small)) /*
	*/ graphregion(c(white)) ylabel(, labsize(small))
	graph save fig1a, replace



*******FIGURE 1b Predicted Insecurity over Social Capital
cap	gen fig2apred = .
cap	gen fig2aer = .
cap	gen fig2aup = .
cap	gen fig2alo = .
cap	gen fig2bpred = .
cap	gen fig2ber = .
cap	gen fig2bup = .
cap	gen fig2blo = .
	
cap	gen fig2axis = .

	forval tr = $transfers_allpcrmin($scdif)$transfers_allpcrmax {
	
		replace fig2axis = `tr' in $n
	
	****subfigure a
		local wXsc = `tr'*$socap_ma90
		est restore fig1marginmodel

		margins, at( (asobserved) _factor (mean) _continuous ///
				l.socap_ma=($socap_ma90) ///
				l.transfers_allpcr=(`tr') welXsc=(`wXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace fig2apred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace fig2aer = `v' in $n

			replace fig2aup = fig2apred + (1.96*sqrt(fig2aer))
			replace fig2alo = fig2apred - (1.96*sqrt(fig2aer))
												
	
	****subfigure b
		local wXsc = `tr'*$socap_ma10
		est restore fig1marginmodel

		margins, at( (asobserved) _factor (mean) _continuous ///
				l.socap_ma=($socap_ma10) ///
				l.transfers_allpcr=(`tr') welXsc=(`wXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace fig2bpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace fig2ber = `v' in $n
					
			replace fig2bup = fig2bpred + (1.96*sqrt(fig2ber))
			replace fig2blo = fig2bpred - (1.96*sqrt(fig2ber))
																								
				
		
		global n = $n+1			
	
	
		}




twoway rconnected fig2alo fig2aup fig2axis , msym(none) lpattern(dash_dot) lc(black) lwidth(thick) /*
	*/ || rconnected fig2blo fig2bup fig2axis, msym(none) lwidth(thick) /*
	*/  legend(order(1 "High Social Capital" 2 "Low Social Capital" ) /*
	*/ tstyle(size(small))) xtitle("All Social Welfare Spending (thousands 2007 USD per capita)") /*
	*/ ytitle(Predicted Economic Insecurity) title("", size(vlarge)) scheme(s2mono) /*
	*/  xlabel(, labsize(small)) graphregion(c(white)) ylabel(, labsize(small))
		graph save fig1b, replace

graph combine fig1a.gph fig1b.gph, c(1) title("") scheme(s2mono) graphregion(c(white)) xsize(15) ysize(20) ycommon iscale(.8)
graph export FigureOne.pdf, as(pdf) replace

rm fig1a.gph
rm fig1b.gph




foreach x in inc ui med {
	cap gen `x'pred = .
	cap gen `x'er = .
	cap gen `x'up = .
	cap gen `x'lo = .
	cap gen `x'onaxis = .
	}
	
	cap gen scaxisval = .
	cap gen scaxisscen=""

xtabond ESI l.socap_ma l.transfers_incpcr l.transfers_uipcr l.transfers_medpcr /*
	*/ uiXsc medXsc incXsc	/*
	*/ l.uniondensity l.govideo /*
	*/ l.indivinctaxpcr l.corptinctaxpcr /*
	*/ l.enerprice  pov_rtfull post1996 l.unemprt d.unemprt /*
	*/ logtot gspgrowth logrgdp racialdiversity 
		est store marginmodel
	
global n = 1


****INCOME

global incdif = ($transfers_incpcrmax-$transfers_incpcrmin)/$axispts

forval inc = $transfers_incpcrmin($incdif)$transfers_incpcrmax {
	
		replace inconaxis = `inc' in $n
		replace scaxisscen ="hi" in $n
	****subfigure a.a - high social capital
		
		est restore marginmodel
			
		local iXsc= `inc'*$socap_ma90
		local mXsc = $transfers_medpcrm*$socap_ma90  
		local uXsc = $transfers_uipcrm*$socap_ma90
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=($socap_ma90) ///
				l.transfers_incpcr=(`inc') incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace incpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace incer = `v' in $n
					
			replace incup = incpred + (1.96*sqrt(incer))
			replace inclo = incpred - (1.96*sqrt(incer))
							
			global n = $n+1				
												
	
	****subfigure a.a - low social capital
		replace inconaxis = `inc' in $n
		replace scaxisscen="lo" in $n

		est restore marginmodel
			
		local iXsc= `inc'*$socap_ma10
		local mXsc = $transfers_medpcrm*$socap_ma10  
		local uXsc = $transfers_uipcrm*$socap_ma10
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=($socap_ma10) ///
				l.transfers_incpcr=(`inc') incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace incpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace incer = `v' in $n
					
			replace incup = incpred + (1.96*sqrt(incer))
			replace inclo = incpred - (1.96*sqrt(incer))
							
			global n = $n+1
			
			
			}
			

****MEDICAL

global meddif = ($transfers_medpcrmax-$transfers_medpcrmin)/$axispts

forval med = $transfers_medpcrmin($meddif)$transfers_medpcrmax {
	
		replace medonaxis = `med' in $n
		replace scaxisscen="hi" in $n
	****subfigure a.a - high social capital
		
		est restore marginmodel
			
		local mXsc= `med'*$socap_ma90
		local iXsc = $transfers_incpcrm*$socap_ma90  
		local uXsc = $transfers_uipcrm*$socap_ma90
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=($socap_ma90) ///
				l.transfers_medpcr=(`med') medXsc=(`mXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace medpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace meder = `v' in $n
					
			replace medup = medpred + (1.96*sqrt(meder))
			replace medlo = medpred - (1.96*sqrt(meder))
							
			global n = $n+1				
												
	
	****subfigure a.a - low social capital
		replace medonaxis = `med' in $n
		replace scaxisscen="lo" in $n

		est restore marginmodel
			
		local mXsc= `med'*$socap_ma10
		local iXsc = $transfers_incpcrm*$socap_ma10  
		local uXsc = $transfers_uipcrm*$socap_ma10
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=($socap_ma10) ///
				l.transfers_medpcr=(`med') medXsc=(`mXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace medpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace meder = `v' in $n
					
			replace medup = medpred + (1.96*sqrt(meder))
			replace medlo = medpred - (1.96*sqrt(meder))
							
			global n = $n+1
			
			
			}
									

****UNEMPLOYMENT 

global uidif = ($transfers_uipcrmax-$transfers_uipcrmin)/$axispts

forval ui = $transfers_uipcrmin($uidif)$transfers_uipcrmax {
	
		replace uionaxis = `ui' in $n
		replace scaxisscen="hi" in $n
	****subfigure a.a - high social capital
		
		est restore marginmodel
			
		local uXsc= `ui'*$socap_ma90
		local mXsc = $transfers_medpcrm*$socap_ma90  
		local iXsc = $transfers_incpcrm*$socap_ma90
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=($socap_ma90) ///
				l.transfers_uipcr=(`ui') uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') /// 
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace uipred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace uier = `v' in $n
					
			replace uiup = uipred + (1.96*sqrt(uier))
			replace uilo = uipred - (1.96*sqrt(uier))
							
			global n = $n+1				
												
	
	****subfigure a.a - low social capital
		replace uionaxis = `ui' in $n
		replace scaxisscen="lo" in $n

		est restore marginmodel
			
		local uXsc= `ui'*$socap_ma10
		local mXsc = $transfers_medpcrm*$socap_ma10  
		local iXsc = $transfers_incpcrm*$socap_ma10
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=($socap_ma10) ///
				l.transfers_uipcr=(`ui') uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') /// 
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace uipred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace uier = `v' in $n
					
			replace uiup = uipred + (1.96*sqrt(uier))
			replace uilo = uipred - (1.96*sqrt(uier))
							
			global n = $n+1
			
			
			}
		
		
		
twoway rconnected uilo uiup uionaxis if scaxisscen=="hi" , msym(none) lpattern(dash_dot) lc(black) lw(medthick) /*
	*/ || rconnected uilo uiup uionaxis if scaxisscen=="lo", msym(none) lw(medthick)  /*
	*/ legend(order(1 "High Soc. Capital" 2 "Low Soc. Capital" ) c(1) tstyle(size(small))) /*
	*/ xtitle("Unemp. Ins. Spending, '000s p/c 2007 USD") ytitle(Predicted Economic Insecurity) /*
	*/ title("", size(vlarge)) scheme(s2mono)  xlabel(, labsize(small)) graphregion(c(white)) /*
	*/ ylabel(, labsize(small)) title("C: Unemployment Insurance")
	graph save ui_sc, replace


twoway rconnected medlo medup medonaxis if scaxisscen=="hi" , msym(none) lpattern(dash_dot) /*
	*/  lc(black) lw(medthick)|| rconnected medlo medup medonaxis if scaxisscen=="lo", msym(none) /*
	*/ lw(medthick)  legend(order(1 "High Soc. Capital" 2 "Low Soc. Capital" ) c(1) /*
	*/ tstyle(size(small))) xtitle("Pub. Medical Care Spending, '000s p/c 2007 USD") /*
	*/ ytitle(Predicted Economic Insecurity) title("", size(vlarge)) scheme(s2mono) /*
	*/ xlabel(, labsize(small)) graphregion(c(white)) ylabel(, labsize(small)) /*
	*/ title("B: Public Healthcare Spending")
	graph save med_sc, replace

twoway rconnected inclo incup inconaxis if scaxisscen=="hi" , msym(none) lpattern(dash_dot) /*
	*/ lc(black) lw(medthick) || rconnected inclo incup inconaxis if scaxisscen=="lo", /*
	*/ msym(none) lw(medthick) legend(order(1 "High Soc. Capital." 2 "Low Soc. Capital" ) /*
	*/ c(1) tstyle(size(small))) xtitle("Income Maintenance Spending, '000s p/c 2007 USD") /*
	*/ ytitle(Predicted Economic Insecurity) title("", size(vlarge)) scheme(s2mono) /*
	*/  xlabel(, labsize(small)) graphregion(c(white)) ylabel(, labsize(small)) title("A: Income Maintenance")
	graph save inc_sc, replace


graph combine inc_sc.gph med_sc.gph ui_sc.gph, c(3) title("") scheme(s2mono) /*
	*/ graphregion(c(white)) xsize(20) ysize(10) ycommon iscale(.8)
graph export FigureTwo.pdf, as(pdf) replace
	rm ui_sc.gph
	rm med_sc.gph
	rm inc_sc.gph






cap gen spendscen = ""

****INCOME

	forval sc = $socap_mamin($scdif)$socap_mamax {
	
		replace scaxisval = `sc' in $n
		replace spendscen ="hi" in $n
	****subfigure a.a - high spend
		
		est restore marginmodel
			
		local iXsc= $transfers_incpcr90*`sc'
		local mXsc = $transfers_medpcrm*`sc'  
		local uXsc = $transfers_uipcrm*`sc'
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=(`sc') ///
				l.transfers_incpcr=($transfers_incpcr90) incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace incpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace incer = `v' in $n
					
			replace incup = incpred + (1.96*sqrt(incer))
			replace inclo = incpred - (1.96*sqrt(incer))
							
			global n = $n+1				
												
	
	****subfigure a.a - low social capital
		replace scaxisval = `sc' in $n
		replace spendscen ="lo" in $n

		est restore marginmodel
			
		local iXsc= $transfers_incpcr10*`sc'
		local mXsc = $transfers_medpcrm*`sc'  
		local uXsc = $transfers_uipcrm*`sc'
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=(`sc') ///
				l.transfers_incpcr=($transfers_incpcr10) incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace incpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace incer = `v' in $n
					
			replace incup = incpred + (1.96*sqrt(incer))
			replace inclo = incpred - (1.96*sqrt(incer))
							
			global n = $n+1				
			
			
			

****MEDICAL

		replace scaxisval = `sc' in $n
		replace spendscen ="hi" in $n

	****subfigure a.a - high spend
		
		est restore marginmodel
			
		local iXsc= $transfers_incpcrm*`sc'
		local mXsc = $transfers_medpcr90*`sc'  
		local uXsc = $transfers_uipcrm*`sc'
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=(`sc') ///
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcr90) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace medpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace meder = `v' in $n
					
			replace medup = medpred + (1.96*sqrt(meder))
			replace medlo = medpred - (1.96*sqrt(meder))
							
			global n = $n+1				
												
	
	****subfigure a.a - low social capital
		replace scaxisval = `sc' in $n
		replace spendscen ="lo" in $n

		est restore marginmodel
			
		local iXsc= $transfers_incpcrm*`sc'
		local mXsc = $transfers_medpcr10*`sc'  
		local uXsc = $transfers_uipcrm*`sc'
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=(`sc') ///
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcrm) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcr10) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace medpred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace meder = `v' in $n
					
			replace medup = medpred + (1.96*sqrt(meder))
			replace medlo = medpred - (1.96*sqrt(meder))
							
			global n = $n+1				
												
									

****UNEMPLOYMENT


		replace scaxisval = `sc' in $n
		replace spendscen ="hi" in $n

	****subfigure a.a - high spend
		
		est restore marginmodel
			
		local iXsc= $transfers_incpcrm*`sc'
		local mXsc = $transfers_medpcrm*`sc'  
		local uXsc = $transfers_uipcr90*`sc'
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=(`sc') ///
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcr90) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace uipred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace uier = `v' in $n
					
			replace uiup = uipred + (1.96*sqrt(uier))
			replace uilo = uipred - (1.96*sqrt(uier))
							
			global n = $n+1				
												
	
	****subfigure a.a - low social capital
		replace scaxisval = `sc' in $n
		replace spendscen ="lo" in $n

		est restore marginmodel
			
		local iXsc= $transfers_incpcrm*`sc'
		local mXsc = $transfers_medpcrm*`sc'  
		local uXsc = $transfers_uipcr10*`sc'
			
		margins,  at( (asobserved) _factor (mean) _continuous 	///
				l.socap_ma=(`sc') ///
				l.transfers_incpcr=($transfers_incpcrm) incXsc=(`iXsc') ///
				l.transfers_uipcr=($transfers_uipcr10) uiXsc=(`uXsc') ///
				l.transfers_medpcr=($transfers_medpcrm) medXsc=(`mXsc') ///
				) post vsquish
			
			mat b = r(b)
			local beta = b[1,1]
			replace uipred = `beta' in $n
			
			mat rv = r(V)
			local v = rv[1,1]
			replace uier = `v' in $n
					
			replace uiup = uipred + (1.96*sqrt(uier))
			replace uilo = uipred - (1.96*sqrt(uier))
							
			global n = $n+1				
			
			}
		
		
		
		
		
		
twoway rconnected uilo uiup scaxisval if spendscen =="hi" , msym(none) lpattern(dash_dot) /*
	*/ lc(black) lw(medthick) /*
	*/ || rconnected uilo uiup scaxisval if spendscen =="lo", msym(none) lw(medthick)  /*
	*/ legend(order(1 "High Spending" 2 "Low Spending" ) c(1) tstyle(size(small))) /*
	*/  xtitle("Social Capital") ytitle(Predicted Economic Insecurity) title("", size(vlarge)) /*
	*/ scheme(s2mono)  xlabel(-3(1)3, labsize(small)) graphregion(c(white)) /*
	*/ ylabel(, labsize(small)) title("C: Unemployment Insurance")
graph save ui_sc, replace


twoway rconnected medlo medup scaxisval if spendscen =="hi" , msym(none) lpattern(dash_dot) /*
	*/ lc(black) lw(medthick)|| rconnected medlo medup scaxisval if spendscen =="lo", /*
	*/ msym(none) lw(medthick)  legend(order(1 "High Spending" 2 "Low Spending" ) c(1) /*
	*/ tstyle(size(small))) xtitle("Social Capital") ytitle(Predicted Economic Insecurity) /*
	*/ title("", size(vlarge)) scheme(s2mono)  xlabel(-3(1)3, labsize(small)) /*
	*/ graphregion(c(white)) ylabel(, labsize(small)) title("B: Public Healthcare Spending")
graph save med_sc, replace

twoway rconnected inclo incup scaxisval if spendscen =="hi" , msym(none) lpattern(dash_dot) lc(black) lw(medthick) || rconnected inclo incup scaxisval if spendscen =="lo", msym(none) lw(medthick) legend(order(1 "High Spending" 2 "Low Spending" ) c(1) tstyle(size(small))) xtitle("Social Capital") ytitle(Predicted Economic Insecurity) title("", size(vlarge)) scheme(s2mono)  xlabel(-3(1)3, labsize(small)) graphregion(c(white)) ylabel(, labsize(small)) title("A: Income Maintenance")
graph save inc_sc, replace


graph combine inc_sc.gph med_sc.gph ui_sc.gph, c(3) title("") scheme(s2mono) graphregion(c(white)) xsize(20) ysize(10) xcommon ycommon iscale(.8)
graph export FigureThree.pdf, as(pdf) replace
	
rm inc_sc.gph 
rm med_sc.gph
rm ui_sc.gph
	
	
log close	
	
	
	
	
	
	
