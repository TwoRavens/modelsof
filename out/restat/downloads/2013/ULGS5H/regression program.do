
preserve
	qui reg $lhs $ldv $rhs1, robust
	keep if e(sample)
	sort year idcode
	qui do "$path\weight matrix calculation rowst.do"
	subsave dij* using "$path\w6.dta", replace
	spatwmat using "$path\w6.dta", name(w)
	matrix eigenvalues re im = w
	matrix e = re'	
	spatreg2 $lhs $ldv $rhs1 $extra, robust  w(w) e(e) model(lag) vce($clus)
restore

