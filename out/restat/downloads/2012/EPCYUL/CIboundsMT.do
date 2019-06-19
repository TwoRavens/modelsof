// Battistin and Sianesi 
// 	Misclassified Treatment Status and Treatment Effects:
// 	An Application to Returns to Education in the UK

cap progr drop boundstable
program def boundstable
	args l21 l22
	foreach t in 10 21 20 {
		di as text "Incremental returns: `t'  --  l21=`l21', l22=`l22'"
		di _n(1) as text "{hline 15}{c TT}{hline 50}"
		di as text "l00 + l11      {c |}"  _col(20) "LOW"  _col(30) "UP"  _col(38) "CI_low"  _col(49) "CI_up"  _col(58) "Error"
		di as text "{hline 15}{c +}{hline 50}"
		forvalues i=6/9 {
			hmboot lb`t'_`i' ub`t'_`i' "`lb`t'_`i'[observed]'"  "`ub`t'_`i'[observed]'" 0.05
			di as res _col(7) 1+`i'/10  as text _col(16) "{c |}" as res _col(18) %6.4f r(lo_obs) _col(28) %6.4f r(up_obs) _col(37) %6.4f r(lci)  _col(48) %6.4f r(uci) _col(57) %5.2f 100*r(diffstar) "%"
		}
		di as text "{hline 15}{c BT}{hline 50}"
		
		gr combine hmlb`t'_6_ub`t'_6.gph hmlb`t'_7_ub`t'_7.gph hmlb`t'_8_ub`t'_8.gph hmlb`t'_9_ub`t'_9.gph, title("`t' - l21=`l21', l22=`l22'")
		erase hmlb`t'_6_ub`t'_6.gph
		erase hmlb`t'_7_ub`t'_7.gph
		erase hmlb`t'_8_ub`t'_8.gph
		erase hmlb`t'_9_ub`t'_9.gph
     }
     
end



u bsboundsMT5_90, clear
boundstable 5 90

u bsboundsMT1_95, clear
boundstable 1 95 


   
