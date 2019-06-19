// Battistin and Sianesi 
// 	Misclassified Treatment Status and Treatment Effects:
// 	An Application to Returns to Education in the UK

cap progr drop boundstable
program def boundstable
	args educ
	di as text "Returns to `educ'"
	di as text "{hline 15}{c TT}{hline 50}"
	di as text "Sum of lamda's {c |}"  _col(20) "LOW"  _col(30) "UP"  _col(38) "CI_low"  _col(49) "CI_up"  _col(58) "Error"
	di as text "{hline 15}{c +}{hline 50}"
	forvalues i=6/9 {
		hmboot lb`i' ub`i' "`lb`i'[observed]'"  "`ub`i'[observed]'" 0.05
		di as res _col(7) 1+`i'/10  as text _col(16) "{c |}" as res _col(18) %6.4f r(lo_obs) _col(28) %6.4f r(up_obs) _col(37) %6.4f r(lci)  _col(48) %6.4f r(uci) _col(57) %5.2f 100*r(diffstar) "%"
	}
	di as text "{hline 15}{c BT}{hline 50}"
	gr combine hmlb6_ub6.gph hmlb7_ub7.gph hmlb8_ub8.gph hmlb9_ub9.gph, title(`educ')
	erase hmlb6_ub6.gph
	erase hmlb7_ub7.gph
	erase hmlb8_ub8.gph
	erase hmlb9_ub9.gph

end


u bsboundsAcad, clear
boundstable Acad

u bsboundsHE, clear
boundstable HE


 

   