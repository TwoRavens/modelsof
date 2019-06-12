*This do file load the data and create table 3 of the paper. This table is saved in a .tex file: Table3.tex
*you need to change the directory to the folder where data.dta is

use "data.dta", clear
set more off
cap file close myfile
local name="Table3.tex" /*name of the tex file the table will be saved in*/
file open myfile using "`name'", write text replace
file write myfile "\begin{table}[ht]" _n /*writes in the .tex file*/
file write myfile "	\centering" _n
file write myfile "\begin{tabular}{lccccccc}" _n
file write myfile "\toprule" _n
foreach effectscore in "all" "ll" "ld" "dw" "ww"{ /*effect the post would have on the score if it gets in. ll is loss->loss*/
	cap drop a
	gen a=1 if effectpost=="`effectscore'"
	if "`effectscore'"=="all"{
		file write myfile "\multicolumn{3}{l}{\textbf{All situations}} & \\" _n
		cap drop a
		gen a=1
	}
	if "`effectscore'"=="ll"{
		file write myfile "\multicolumn{3}{l}{\textbf{Loss $\rightarrow$ Loss }} & \\" _n
	}
	if "`effectscore'"=="ld"{
		file write myfile "\multicolumn{3}{l}{\textbf{Loss $\rightarrow$ Draw }} & \\" _n
	}
	if "`effectscore'"=="dw"{
		file write myfile "\multicolumn{3}{l}{\textbf{Draw $\rightarrow$ Win }} & \\" _n
	}
	if "`effectscore'"=="ww"{
		file write myfile "\multicolumn{3}{l}{\textbf{Win $\rightarrow$ Win }} & \\" _n
	}
	local line1="Effect of Scoring"
	local line2="% {\footnotesize p-value}"
	local line2se="{\footnotesize se}"
	local line3="{\footnotesize N}"
	foreach var in play starting minplay{ /*in each line of the table we do the estimation for these 3 outcome variables*/
		/*this is the command for the estimation. Matching estimator with euclidean distance*/
		teffects nnmatch (diff`var' absx2 absy2 ) (postin)  ///
			if nextmatchindataset==1 & previousmatchindataset==1 & a==1 ///
			,  nneighbor(1)  biasadj(absx2 absy2 sub)  ematch(sub) metric(euclidean) 
		
		*We now save the results of the estimation to put them in the .tex*/
		matrix B=e(b)
		matrix V=e(V)
		local b1:di%4.3f B[1,1]
		if "`var'"=="minplay"{
			local b1:di%4.2f B[1,1]
		}
		local p1=2*(1-normal(abs(B[1,1]/sqrt(V[1,1])))) /*compute the p-value*/
		local se=sqrt(V[1,1]) /*compute the standard error*/
		local se:di%4.3f `se'
		local p1:di%4.3f `p1'
		
		*We include a star if the effect is statistically significant
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
		local line2se="`line2se'"+" & "+"\footnotesize{"+"`se'"+"}"
		local line3="`line3'"+" & "+"\footnotesize{"+"`N1'"+"}"
	}
	file write myfile "`line1'" "\\"  _n 
	file write myfile "`line2se'" "\\"  _n
	file write myfile "`line3'" "\\"  _n 
	file write myfile "\midrule"  _n
}
file write myfile "\end{tabular}" _n
file write myfile "			\bottomrule"  _n
file write myfile "\end{table}" 
file close myfile
