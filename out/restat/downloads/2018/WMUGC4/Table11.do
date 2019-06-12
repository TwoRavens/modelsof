use "data.dta", clear
set more off
cap file close myfile
file open myfile using "Table11.tex", write text replace
file write myfile "\begin{table}[htbp]" _n
file write myfile "	\centering" _n
file write myfile "\begin{tabular}{lccccccc}" _n
file write myfile "\toprule" _n
file write myfile "& \multicolumn{7}{c}{Period}" _n
file write myfile " & 0-15 & 15-30 & 30-45$^{1}$ & 45-60 & 60-75 & 75-90 & 90< \\"  _n
file write myfile "\midrule" _n
local line1="Individual Rating"
local line2se="{\footnotesize se}"
local line3="{\footnotesize N}"
foreach period in 0 15 30 45 60 75 90{
	di `period'
	local period1=`period'+15
	if `period'<30{
		teffects nnmatch (note absx2 absy2) (postin)  ///
			if  period_minute>=`period' & period_minute<`period'+15 & period_id==1 ///
			,  nneighbor(1)  biasadj(absx2 absy2)   metric(euclidean)
		}
	if `period'==30{
		teffects nnmatch (note absx2 absy2) (postin)  ///
			if  period_minute>=30 & period_id==1 ///
			,  nneighbor(1)  biasadj(absx2 absy2)  metric(euclidean)
	}
	if `period'>30{
		teffects nnmatch (note absx2 absy2) (postin)  ///
			if   period_minute>=`period' & period_minute<`period'+15 & period_id==2 ///
			,  nneighbor(1)  biasadj(absx2 absy2) metric(euclidean)
	}
	matrix B=e(b)
	matrix V=e(V)
	local b1:di%4.3f B[1,1]
	local p1=2*(1-normal(abs(B[1,1]/sqrt(V[1,1]))))
	local p1:di%4.3f `p1'
	local se=sqrt(V[1,1])
	local se:di%4.3f `se'
	local star1=""
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
	local N1: di%5.0fc `N1'
	
local line1="`line1'"+" & $"+"`b1'"+"`star1'"
local line2se="`line2se'"+" & "+"\footnotesize{"+"`se'"+"}"+"  "
local line3="`line3'"+" & "+"\footnotesize{N="+"`N1'"+"}"
}
file write myfile "`line1'" "\\"  _n 
file write myfile "`line2se'" "\\"  _n
file write myfile "`line3'" "\\"  _n 
file write myfile "\bottomrule"  _n
file write myfile "\end{tabular}"  _n
file write myfile "\end{table}" 
file close myfile
