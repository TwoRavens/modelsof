//////////////////////
use "data.dta", clear
cap drop idposition
egen idposition=group(sub mid def att)

foreach var in play starting minplay{
	set more off
	cap file close myfile
	local name="Table8.tex"
	file open myfile using "`name'", write text replace
	file write myfile "\begin{table}[ht]" _n
	file write myfile "	\centering" _n
	file write myfile "\begin{tabular}{lccccccc}" _n
	file write myfile "\toprule" _n
	foreach effectscore in "all" {
		cap drop a
		gen a=1 if effectpost=="`effectscore'"
		if "`effectscore'"=="all"{
			file write myfile "\multicolumn{3}{l}{\textbf{All situations}} & \\" _n
			cap drop a
			gen a=1
		}
		local line1="Effect of Scoring"
		local line2="{\footnotesize p-value}"
		local line3="{\footnotesize N}"
		foreach var2 in mv pplayerwin idposition All{
			if "`var2'"=="mv" | "`var2'"=="pplayerwin" {
			teffects nnmatch (diff`var' absx2 absy2 `var2') (postin)  ///
				if  nextmatchindataset==1 & previousmatchindataset==1 & a==1 ///
				,  nneighbor(1)  biasadj(absx2 absy2 `var2')  ematch(sub)
			}
			if "`var2'"=="idposition"{
				cap teffects nnmatch (diff`var' absx2 absy2 ) (postin)  ///
					if  nextmatchindataset==1 & previousmatchindataset==1 & a==1 ///
					,  nneighbor(1)  biasadj(absx2 absy2 )  ematch(idposition)
			}
			if "`var2'"=="All"{
				cap teffects nnmatch (diff`var' absx2 absy2 mv pplayerwin) (postin)  ///
					if  nextmatchindataset==1 & previousmatchindataset==1 & a==1 ///
					,  nneighbor(1)  biasadj(absx2 absy2  mv pplayerwin)  ematch(idposition)
			}
			matrix B=e(b)
			matrix V=e(V)
			local b1:di%4.3f B[1,1]
			if "`var'"=="minplay"{
				local b1:di%4.2f B[1,1]
			}
			local p1=2*(1-normal(abs(B[1,1]/sqrt(V[1,1]))))
			local p1:di%4.3f `p1'
			local star1=""
			local se=sqrt(V[1,1])
			local se:di%4.3f `se'
			
			if `p1'<0.1{
				local star1="^{\dag}"
			}
			if `p1'<0.05{
				local star1="^{*}"
			}
			if `p1'<0.01{
				local star1="^{**}"
			}
			if `p1'<0.001{
				local star1="^{***}"
				local p1="<0.001"
			}
			local N1=e(N)
			local N1: di%6.0fc `N1'
			
			local line1="`line1'"+" & $"+"`b1'"+"`star1'"+" $ "
			local line2="`line2'"+" & $"+"\footnotesize{"+"`se'"+"}"+"  "+" $ "
			local line3="`line3'"+" & "+"\footnotesize{"+"`N1'"+"}"+"  "
		}
			file write myfile "`line1'" "\\"  _n 
			file write myfile "`line2'" "\\"  _n
			file write myfile "`line3'" "\\"  _n 
	}
	file write myfile "\midrule"  _n
	file write myfile "Variables used for matching:\\"  _n
	file write myfile "\\"  _n
	file write myfile "Spatial coordinates & \checkmark &  \checkmark	& \checkmark &  \checkmark    \\"  _n
	file write myfile "Starting vs. Substitute $^{\delta}$   & \checkmark &  \checkmark	& \checkmark &  \checkmark    \\"  _n
	file write myfile "Players' market value &   \checkmark &   & & \checkmark \\"  _n
	file write myfile "Ex-ante probability to win &  & \checkmark  & & \checkmark \\"  _n
	file write myfile "Position $^{\delta}$  & &   & \checkmark  & \checkmark \\"  _n
	file write myfile "\bottomrule"  _n
	file write myfile "\end{tabular}"  _n
	file write myfile "\end{table}" 
	file close myfile
	//////////////
}
