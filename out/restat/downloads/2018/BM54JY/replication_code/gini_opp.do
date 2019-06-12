*	Gini IO estimation based on GL curves area. Bootstrapped estimatators
qui {
*	set matsize 10000
*	set matsize 2000
	use data_merged.dta, clear
	keep ez_i*_p1t1 rif_ez_*i* quantile repl
		
	qui sum repl
	local repmax = r(max)
	qui sum quantile if repl==1
	local qmax = r(max)
	local w = 1/100
	foreach x of numlist 1(1)10 {
		mkmat ez_i`x'_p1t1 if repl==1, mat(Q`x') nomis
		mkmat rif_ez_MEANi`x' if repl==1, mat(QTE`x') nomis
		foreach rep of numlist 2(1)`repmax' {
			mkmat ez_i`x'_p1t1 if repl==`rep', mat(Q`x'`rep') nomis
			mkmat rif_ez_MEANi`x' if repl==`rep', mat(QTE`x'`rep') nomis
			mat Q`x' = Q`x', Q`x'`rep'
			mat QTE`x' = QTE`x', QTE`x'`rep'
		}
		mat Q0`x' = Q`x' - QTE`x'
		mat weight = J(100,1,`w')
		local matn "Q`x' Q0`x'"
		foreach M of local matn {
			mat `M' = `M' \ `M'[99,1..`repmax']
			mata: st_matrix("GL`M'", lowertriangle(J(100,100,1))*( st_matrix("weight"):*st_matrix("`M'")) )
			mat GL`M' = GL`M''
			mat GL1`M' = 0.01*GL`M'
			mat GL2`M' = 0.01*( J(`repmax',1,0) , GL`M'[1..`repmax',1..99] )
			mat pcGINI`M' = 0.5*GL1`M' + 0.5*GL2`M'
			mat avg`M' = GL`M'[1..`repmax',100]
			mat GINI`M' = 2*pcGINI`M'*J(100,1,1)
		}
	}
	
	qui sum repl
	local repmax = r(max)	
	local matn "Q Q0"
	foreach M of local matn {
		mat mu`M' = avg`M'1[1..`repmax',1]
		mat GINI`M' = J(`repmax',1,0)
		foreach x of numlist 2(1)10 {
			mat mu`M' = mu`M' , avg`M'`x'[1..`repmax',1]
		}
		mat mu`M' = 0.1*mu`M'*J(10,1,1)
		foreach i of numlist 1(1)9 {
			local i2 = `i' + 1
			foreach j of numlist `i2'(1)10 {
				mat GINI`M' = GINI`M', (GINI`M'`j' - GINI`M'`i')
			}
		}
		mat mu`M' = vecdiag(inv(diag(mu`M')))'
		mata: st_matrix("GINI`M'", 0.01*st_matrix("mu`M'"):*rowsum(abs(st_matrix("GINI`M'"))))
		mata: IOG`M' = mean(st_matrix("GINI`M'"))
		mata: SEIOG`M' = variance(st_matrix("GINI`M'"))
		mata: st_matrix("IOG`M'", IOG`M'')
		mata: st_matrix("SEIOG`M'", SEIOG`M'')
	}

	local Gini0 = IOGQ0[1,1]
	local Gini1 = IOGQ[1,1]
	local D = IOGQ[1,1] - IOGQ0[1,1]
	local R = 100*(IOGQ[1,1] - IOGQ0[1,1])/IOGQ0[1,1]
	local SEGini0 = (SEIOGQ0[1,1])^.5
	local SEGini1 = (SEIOGQ[1,1])^.5
	local jointSE = (SEIOGQ0[1,1] + SEIOGQ[1,1])^.5
	local test = (IOGQ0[1,1] - IOGQ[1,1]) / (SEIOGQ0[1,1] + SEIOGQ[1,1])^.5
	local pval = 1 - normal(`test')
}
di as text "Gini actual : `Gini1' (`SEGini1')"
di as text "Gini counterfactual : `Gini0' (`SEGini0')"
di as text "The absolute (relative) variation of the index is `D' (`R' %)"
di as text "The T-test for H0: IOG0 > IOG1 is : `test', with p-value : `pval'"



*******************************************************************************************************
*******************************************************************************************************
*******************************************************************************************************
*	GINI SEF measures for the 3 types

local matn "Q Q0"
foreach M of local matn {
	mat mu`M' = diag(mu`M'')
	foreach x of numlist 2 5 9 {
		mat WG`M'`x' = mu`M'* GINI`M'`x' 
	}
}

mat WG102 = WGQ2 - WGQ02
mat WG105 = WGQ5 - WGQ05
mat WG109 = WGQ9 - WGQ09
mat WG125 = WGQ5 - WGQ2
mat WG129 = WGQ9 - WGQ2
mat WG159 = WGQ9 - WGQ5
mat WG025 = WGQ05 - WGQ02
mat WG029 = WGQ09 - WGQ02
mat WG059 = WGQ09 - WGQ05
mat WG1025 = WG025 - WG125
mat WG1029 = WG029 - WG129
mat WG1059 = WG059 - WG159

mat WG102p = inv(diag(WGQ02))*(WGQ2 - WGQ02)
mat WG105p = inv(diag(WGQ05))*(WGQ5 - WGQ05)
mat WG109p = inv(diag(WGQ09))*(WGQ9 - WGQ09)
mat WG125p = inv(diag(WGQ2))*(WGQ5 - WGQ2)
mat WG129p = inv(diag(WGQ2))*(WGQ9 - WGQ2)
mat WG159p = inv(diag(WGQ5))*(WGQ9 - WGQ5)
mat WG025p = inv(diag(WGQ02))*(WGQ05 - WGQ02)
mat WG029p = inv(diag(WGQ02))*(WGQ09 - WGQ02)
mat WG059p = inv(diag(WGQ05))*(WGQ09 - WGQ05)
mat WG1025p = inv(diag(WG125))*(WG025 - WG125)
mat WG1029p = inv(diag(WG129))*(WG029 - WG129)
mat WG1059p = inv(diag(WG129))*(WG059 - WG159)


local names "WG102 WG105 WG109 WG125 WG129 WG159 WG025 WG029 WG059 WG1025 WG1029 WG1059"
foreach x of local names {
	qui {
		mata: m_`x' = mean(st_matrix("`x'"))
		mata: se_`x' = variance(st_matrix("`x'"))^.5
		mata: st_matrix("m_`x'", m_`x')
		mata: st_matrix("se_`x'", se_`x')
		local varm = m_`x'[1,1]
		local varse = se_`x'[1,1]
		local t = `varm'/`varse'
		local pval = 1 - normal(`t')
		local pct "`x'p"
		mata:  st_matrix("m_`pct'", mean(st_matrix("`pct'")))
		local varpct = m_`pct'[1,1]*100
	}
	di as text "Gini evaluations for -`x'- : " %5.4f `varm'  " (" %5.3f `varse' ")"
	di as text "   Pct change : " %5.2f `varpct' " %" 
	di as text "   H0: `x' = 0 : " %5.3f  `t' " [" %5.3f `pval' "]"
}

