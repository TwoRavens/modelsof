////////////////////
use "data.dta", clear
set more off
cap file close myfile
file open myfile using "Table7.tex", write text replace
file write myfile "\begin{table}[htbp]" _n
file write myfile "	\centering" _n
file write myfile "\begin{tabular}{l ccc ccc}" _n
file write myfile "\toprule" _n
file write myfile "  & \multicolumn{3}{c}{All} & \multicolumn{3}{c}{With ratings} \\" _n
file write myfile "& Var & SE & N & Var & SE & N "  "\\" _n
file write myfile "\midrule" _n
foreach var in starting att  mid def homeshooter ///
	sumgoalseason sumnoteseason sumpostseason sumppostin ///	
	mv avteammvstarting avteammvstarting2 avotherteammvstarting ///
	pplayerwin{
		local line1=""
		if "`var'"=="starting"{
			file write myfile "\multicolumn{6}{l}{\textbf{Player's basic characteristics}}"  "\\" _n
			local line1="Player starting the match"
			}
		if "`var'"=="att"{
			local line1="Forwards"
			}
		if "`var'"=="mid"{
			local line1="Midfielder"
			}
		if "`var'"=="def"{
			local line1="Defender"
			}
		if "`var'"=="homeshooter"{
			local line1="Home team"
			}
		if "`var'"=="sumgoalseason"{
			file write myfile "\multicolumn{6}{l}{\textbf{Player's performance since the start of the season}}"  "\\" _n
			local line1="Number of goal scored"
			}
		if "`var'"=="sumnoteseason"{
			local line1="Average rating"
			}
		if "`var'"=="sumpostseason"{
			local line1="Number of post inside"
			}
		if "`var'"=="sumppostin"{
			local line1="Frequency of post inside"
			}
		if "`var'"=="mv"{
			file write myfile "\multicolumn{6}{l}{\textbf{Market values}}" "\\" _n
			local line1="Player's market value"
			}
		if "`var'"=="avteammvstarting"{
			local line1="Team's average market value"
			}
		if "`var'"=="avteammvstarting2"{
			local line1="Team's average market value$^\delta$"
			}
		if "`var'"=="avotherteammvstarting"{
			local line1="Opponent team's average mv"
			}
		if "`var'"=="pplayerwin"{
			file write myfile "\multicolumn{6}{l}{\textbf{Ex-ante probability from betting odds}}"  "\\" _n
			local line1="Probability to win the match"
			}
		teffects nnmatch (`var' absx2 absy2) (postin)  ///
				if `var'!=.,  nneighbor(1)  biasadj(absx2 absy2)  metric(euclidean)
		
		matrix B=e(b)
		matrix V=e(V)
		local b1=B[1,1]
		local p1=2*(1-normal(abs(B[1,1]/sqrt(V[1,1]))))
		local p1:di%4.3f `p1'
		local se1=sqrt(V[1,1])
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

		teffects nnmatch (`var' absx2 absy2) (postin)  ///
				if `var'!=. & note!=.,  nneighbor(1)  biasadj(absx2 absy2) metric(euclidean)  	
		matrix B=e(b)
		matrix V=e(V)
		local b2=B[1,1]
		local p2=2*(1-normal(abs(B[1,1]/sqrt(V[1,1]))))
		local p2:di%4.3f `p2'
		local se2=sqrt(V[1,1])
		local star2=""
		if `p2'<0.05{
			local star2="^{*}"
		}
		if `p2'<0.01{
			local star2="^{**}"
		}
		if `p2'<0.001{
			local star2="^{***}"
			local p2="<0.001"
		}
		if "`var'"=="mv" | "`var'"=="avteammvstarting" | "`var'"=="avteammvstarting2" | "`var'"=="avotherteammvstarting"{
			local b1:di%9.0fc `b1'
			local b2:di%9.0fc `b2'
			local se1:di%9.0fc `se1'
			local se2:di%9.0fc `se2'
		}
		if "`var'"!="mv" & "`var'"!="avteammvstarting" & "`var'"!="avteammvstarting2" & "`var'"!="avotherteammvstarting"{
			local se1:di%4.3f `se1'	
			local se2:di%4.3f `se2'	
			local b1:di%4.3f `b1'	
			local b2:di%4.3f `b2'	
		}
		local N2=e(N)
		local N2: di%5.0fc `N2'
		sum `var' if period_id==1		
	local line1="`line1'"+"& $"+"`b1'"+"`star1'"+"$ & "+"\footnotesize{"+"`se1'"+"} "+" & "+"\footnotesize{"+"`N1'"+"}"+" & $"+"`b2'"+"`star2'"+"$ & "+"\footnotesize{"+"`se2'"+"} &"+"\footnotesize{"+"`N2'"+"}"
	file write myfile "`line1'" "\\"  _n 
	di "`line1'" 
}
file write myfile "\bottomrule"  _n
file write myfile "\end{tabular}"  _n
file write myfile "\end{table}" 
file close myfile
