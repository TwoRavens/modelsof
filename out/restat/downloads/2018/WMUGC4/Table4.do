use "data.dta", clear
set more off
cap file close myfile
local name="Table4.tex"
file open myfile using "`name'", write text replace
file write myfile "\begin{table}[ht]" _n
file write myfile "	\centering" _n
file write myfile "\begin{tabular}{l cccc}" _n
file write myfile "\toprule" _n
file write myfile "&   $\Delta $ Play & $\Delta $ Start & $\Delta $ Minute" "\\" _n
foreach nplay in 3 7{
	file write myfile "\midrule" _n
	if `nplay'==3{
		file write myfile  "& \multicolumn{3}{c}{\textbf{50\% players playing the least}} & \\" _n
		}
	if `nplay'==7{
		file write myfile  "& \multicolumn{3}{c}{\textbf{25\% players playing the least}} & \\" _n
		}
	file write myfile "\midrule" _n
	local line5="Average playing time"
	 
	foreach effectpost in "all" "imp" "unimp"{
		cap drop b
		gen b=1
		file write myfile "\multicolumn{3}{l}{\textbf{""`effectpost'""}} & \\" _n
		if "`effectpost'"=="imp"{
			replace b=0 if ![effectpost=="ld" | effectpost=="dw"]
		}
		if "`effectpost'"=="unimp"{
			replace b=0 if ![effectpost=="ll" | effectpost=="ww"]
		}
		local line1="Effect of Scoring"
		local line2="{\footnotesize p-value}"
		local line3="{\footnotesize SE}"
		local line4="{\footnotesize N}"
		foreach var0 in play starting minplay{	
			cap drop a
			gen a=b
			local var="diff"+"`var0'"
			local varnplay="av"+"`var0'"+"season"
			sum `varnplay' if nextmatchindataset==1 & previousmatchindataset==1, detail
			if `nplay'==3{
				replace a=0 if `varnplay'>=r(p50) /*a=1 if play the less*/
			}
			if `nplay'==7{
				replace a=0 if ![`varnplay'<=r(p25)] /*bottom 25*/
			}
			clear matrix
			local b1=.
			local p1=.
			local strar1=.
			local ok=0
			*cap{
			teffects nnmatch (`var' absx2 absy2 ) (postin)  ///
				if nextmatchindataset==1 & previousmatchindataset==1 & a==1  ///
				,  nneighbor(1)  biasadj(absx2 absy2 sub)  metric(euclidean) ematch(sub) 
		*		}

			matrix B=e(b)
			matrix V=e(V)
			local b1:di%4.3f B[1,1]
			if "`var'"=="minplay"{
				local b1:di%4.2f B[1,1]
			}
			local p1=2*(1-normal(abs(B[1,1]/sqrt(V[1,1]))))
			local p1:di%4.3f `p1'
			local se=sqrt(V[1,1])
			local se:di%4.3f `se'
			local star1=""
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
			local line3="`line3'"+" & "+"\footnotesize{$"+"`se'"+"$}"+"  "
			local line4="`line4'"+" & "+"\footnotesize{"+"`N1'"+"}"+"  "
			
			if "`effectpost'"=="all"{
				sum `varnplay' if nextmatchindataset==1 & previousmatchindataset==1 & a==1
				local meanplay=r(mean)
				local meanplay:di%4.2f `meanplay'
				if "`var'"=="minplay"{
					local meanplay:di%4.1f `meanplay'
				}
				local line5="`line5'"+" & "+"`meanplay'"
				di "`line5'"
				}
			}
		file write myfile "`line1'" "\\"  _n 
		file write myfile "`line3'" "\\"  _n 
		file write myfile "`line4'" "\\"  _n 
	}
	file write myfile "\midrule" _n
	file write myfile "`line5'" "\\"  _n 
}
file write myfile "			\bottomrule"  _n
file write myfile "		\end{tabular}"  _n
file write myfile "\end{table}" 
file close myfile		
