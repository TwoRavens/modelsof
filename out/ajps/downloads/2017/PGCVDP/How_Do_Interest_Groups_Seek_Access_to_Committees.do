* PROGRAM :			How_Do_Interest_Groups_Seek_Access_to_Committees.do
* AUTHOR :			Alexander Fouirnaies + Andrew Hall
* INFILE(S) :		
* OUTFILE(S) :		
* DATE WRITTEN :	30 Sept 2015
*************************************************************************

clear
program drop _all
set matsize 10000


local prep_extra_data = 0
local table_1 = 1
local table_2 = 1
local table_3 = 1
local table_4 = 1
local table_5 = 1

local appendix_table_1 = 1
local appendix_table_2 = 1
local appendix_table_3 = 1
local appendix_table_4 = 1
local appendix_table_5 = 1
local appendix_table_6 = 1
local appendix_table_7 = 1
local appendix_table_8 = 1



***************** Install the Stata-modules: "reghdfe", "estout" and "labutil" *******************
**************************************************************************************************

cap ado uninstall reghdfe
ssc install reghdfe


*************************************************************************


if `prep_extra_data'==1 {

	*******************
	***Prep data sets for triple diff analysis: diff_for_r.dta, triple_diff and did_results.dta
	*******************

	*create data
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	drop if CandId==279088 & year==2012 //(legislator serving in both house and chamber in same term)
	drop *_1 *non*
	keep state chamber year CandId cmt_* log_amount_* limit  squire_rank MajorityMember py
	
	reshape long cmt log_amount , i(CandId year) j(industry) string
	
	egen industry_year = group(industry year)
	egen cand_year = group(CandId year)
	egen cand_industry = group(CandId industry)
	
	drop if industry=="_number"
	sort CandId industry year
	
	save "triple_diff.dta", replace
	
	
	
	**create dataset used to produce graphs in R
	use "triple_diff.dta", clear
	sort state chamber CandId industry year

	by state chamber CandId industry: gen switch_year_tmp = year if cmt==1 & cmt[_n-1]==0
	by state chamber CandId industry: egen switch_year = max(switch_year_tmp)
	gen t = year - switch_year
	egen control_mean_tmp = mean(log_amount) if cmt==0, by(industry year)
	egen control_mean = max(control_mean_tmp), by(industry year)
	replace log_amount = . if cmt == 0 & year > switch_year
	collapse (mean) log_amount control_mean, by(t)
	keep if abs(t) < 11
	drop if t == 10
	
	saveold "diff_for_r.dta", replace
	
	
	
	**create dataset containing diff-in-diff estimates: did_results.dta
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	matrix B = J(400, 5, .)
	local n = 1
	gen varname=""
	
	qui foreach sector in agriculture energy insurance banking health transportation defense business construction education {
		reghdfe log_amount_`sector' cmt_`sector' MajorityMember , a(CandId py  ) cluster(CandId) keepsingletons
		matrix B[`n', 1] = _b[cmt_`sector']
		matrix B[`n', 2] = _se[cmt_`sector']
		reghdfe log_amount_non`sector' cmt_`sector' MajorityMember , a(CandId py  ) cluster(CandId) keepsingletons
		matrix B[`n', 3] = _b[cmt_`sector']
		matrix B[`n', 4] = _se[cmt_`sector']
		matrix B[`n', 5] = e(N)
		replace varname = "`sector'" if _n==`n'		
	
		local n = `n' + 1
		
	}
	
	svmat B
	keep B1-B5 varname
	keep if B1 != .
	rename B1 b_interested
	rename B2 se_interested
	rename B3 b_noninterested
	rename B4 se_noninterested
	rename B5 n
	
	saveold "did_results.dta" , replace

	
	*create dataset containing pre-treatment data
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	sort CandId year
	forval i=0/4 {
		by CandId: gen appt_plus`i'=appt[_n+`i']
	}
	egen spy = group(state party year)
	
	reghdfe log_amountindustry_1   appt_plus*  MajorityMember  , a(CandId spy ) cluster(CandId) keepsingletons
	matrix B = J(50, 10, .)
	qui forval i=0/4 {
		local j=`i'+1
		matrix B[`j', 1] = _b[appt_plus`i']
		matrix B[`j', 2] = _b[appt_plus`i'] - 1.96*_se[appt_plus`i']
		matrix B[`j', 3] = _b[appt_plus`i'] + 1.96*_se[appt_plus`i']
	
		matrix B[`j', 4] = -`i' +0.15
	
	}
	
	svmat B
	keep if B1 != .
	keep B* 
		
	keep B1-B4
	saveold pretreat_for_r, replace	
	
	
	
	*create sector estimate data
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	drop if log_amountindustry_1==.
	keep state StateYear chamber year CandId MajorityMember log_amount_* appt SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR
	drop log_amount_non*
	
	gen sector = ""
	gen b_appt = .
	gen ci_lower_appt=.
	gen ci_upper_appt=.
	gen number=_n
	
	
	local i=0
	matrix B = J(150, 10, .)
	qui foreach s in agriculture energy insurance banking health transportation defense business construction education {
		local i = 1+`i'
		replace sector = "`s'" if _n == `i'	
		reghdfe log_amount_`s' appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateYear)  cluster(CandId)	keepsingletons
		replace b_appt =_b[appt] if n==`i'
		replace ci_lower_appt =_b[appt]- 1.96*_se[appt] if n==`i'
		replace ci_upper_appt =_b[appt]+ 1.96*_se[appt] if n==`i'
		}
	keep if sector!=""
	keep b_appt ci_* sector
	saveold "sector_estimates.dta", replace
	
	
	
	
	*create industry estimate data
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	gen industry=""
	rename log_amountindustry_1 log_amount87_1  
	rename amountindustry_1 amount87_1
	label var amount87_1 "Total Industry"
	
	matrix B = J(150, 10, .)
	local j=1
	qui forval i=1/87  {
	
		reghdfe log_amount`i'_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateYear)  cluster(CandId) 
		
		matrix B[`j', 1] = _b[appt]
		matrix B[`j', 2] = _b[appt] - 1.96*_se[appt]
		matrix B[`j', 3] = _b[appt] + 1.96*_se[appt]
		
		matrix B[`j', 4] =`j'
	
		local varlab : variable label amount`i'
		replace industry = "`varlab'" if _n == `j'
		local j=`j'+1
	}
	svmat B
	keep B* industry
	keep if B1 != .
	rename B1 b_appt
	rename B2 ci_lower_appt
	rename B3 ci_upper_appt
	rename B4 n
	sort b_appt
	replace n=_n
	keep industry b_appt ci_lower_appt ci_upper_appt n
	saveold "industry_estimates.dta", replace
	
	
	
	
	
	
	

}





if `table_1'==1{

	*******************
	***Table 1
	*******************

	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	drop cmt_number
	collapse (max) cmt*, by(state chamber year)
	collapse cmt* ,by(chamber )
	drop cmt_budget cmt_rules
	
	reshape long cmt_, i(chamber) j(industry) string
	replace cmt_ = 100*cmt_
	reshape wide cmt_, i(industry) j(chamber) string
	
	gen words = ""
	replace words = "agri|food|forest|livestock|fish|farm|ranch|rural" if industry=="agriculture"
	replace words = "energy|resources|oil|gas|renewab|coal|nuclea|utiliti|electric|mining" if industry=="energy"
	replace words = "insur" if industry=="insurance"
	replace words = "bank|finan" if industry=="banking"
	replace words = "health|hospi|medi" if industry=="health"
	replace words = "transpor|highway|road" if industry=="transportation"
	replace words = "defe|armed|veteran|milit|homeland|border" if  industry== "defense"
	replace words = "commerce|busine|industry" if industry=="business"
	replace words = "construc|infrastru|hous|mainten|build" if industry=="construction"
	replace words = "educ|school|universi|child|youth" if industry=="education"
	
	replace words = "means|approp|finance|budg" if industry=="budget"
	replace words = "rules" if industry=="rules"
	replace words = subinstr(words, "|","; ",.)
	replace industry = subinstr(industry, "_"," ",.)
	replace industry = subinstr(industry, "and","\&",.)
		
	set linesize 255
	capture log close
	
	quietly {
		log using "table_1.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\caption{{\bf Linking Interest Groups to Committees By Issue Area.} We link sectors identified in the campaign finance data to "
		noisily display "issue-specific legislative committees by searching for sector-relevant word stems in the committee names.\label{tab:cmt_words}}"
		noisily display "\begin{adjustbox}{max width=\textwidth} "
		noisily display "\begin{tabular}{l ccc}"
		noisily display "\toprule \toprule"
		noisily display " Interest-Group Sector  & Committee Name Word Stems & House & Senate  \\"
		noisily display "   &  &  \% state-years & \% state-years \\"
		noisily display "\midrule"
		
		local n=_N
		forval i =1/`n' {
			noisily display proper(industry[`i']) " & " words[`i'] " & " %3.1fc cmt_house[`i'] " & " %3.1fc cmt_senate[`i']  " \\ "
		}
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{3}{p{.7\textwidth}}{}"
		noisily display "\end{tabular}"
		noisily display "\end{adjustbox}"	
		noisily display "\end{table}"
		
		log close
	}
	
}






if `table_2'==1{

	*******************
	***Table 2
	*******************
	
	use "triple_diff.dta", clear
	reghdfe log_amount cmt, a(cand_industry year) cluster(CandId) keepsingletons

	reg log_amount cmt if e(sample), cluster(CandId) 
	local b1 = _b[cmt]
	local se1 = _se[cmt]
	local n1 = e(N)
	
	reghdfe log_amount cmt MajorityMember , a(cand_industry py) cluster(CandId) keepsingletons
	local b2 = _b[cmt]
	local se2 = _se[cmt]
	local n2 = e(N)
	
	reghdfe log_amount cmt , a(cand_year cand_industry) cluster(CandId) keepsingletons
	local b3 = _b[cmt]
	local se3 = _se[cmt]
	local n3 = e(N)
	
	quietly{
		cap log close
		set linesize 255
		log using "table_2.tex", text replace
		
		noisily dis "\begin{table}[t]"
		noisily dis "\centering"
		noisily dis "\caption{\textbf{Effect of Committee Membership on Contributions From Interested Donors.}\label{tab:triple}}"
		noisily dis "\begin{tabular}{lccc}"
		noisily dis "\toprule\toprule"
		noisily dis " & \multicolumn{3}{c}{Log Group Contributions (\\$)} \\"
		noisily dis " \midrule" 
		noisily dis " On Committee & " %4.2f `b1' " & " %4.2f `b2' " & " %4.2f `b3' " \\"
		noisily dis " & (" %4.2f `se1' ") & (" %4.2f `se2' ") & (" %4.2f `se3' ") \\[2mm]"
		noisily dis " Candidate by Industry FEs & No & Yes & Yes \\"
		noisily dis " Majority-Party Dummy & No & Yes & No \\"
		noisily dis " Party by Year FEs & No & Yes & No \\"
		noisily dis " Candidate by Year FEs & No & No & Yes\\"
		noisily dis "N & " %8.0fc `n1' " & " %8.0fc `n2' " & " %8.0fc `n3' " \\ "
		noisily dis "\bottomrule\bottomrule"
		noisily dis "\multicolumn{4}{p{.6\textwidth}}{\footnotesize Robust standard errors clustered by candidate in parentheses.}"
		noisily dis "\end{tabular}"
		noisily dis "\end{table}"
		
		log off
	}
		
	
	
	
}	



if `table_3'==1{

	*******************
	***Table 3
	*******************
			
	use "triple_diff", clear
	
	reghdfe log_amount cmt , a(cand_year cand_industry cand_year) cluster(CandId) keepsingletons
	local b1 = _b[cmt]
	local se1 = _se[cmt]
	local n1 = e(N)
	
	quietly {
	
		cap log close
		set linesize 255
		log using "table_3.tex", text replace
		
		noisily dis "\begin{table}[t]"
		noisily dis "\centering"
		noisily dis "\caption{\textbf{Effects of Committee Membership on Contributions.}\label{tab:diff}}"
		noisily dis "\begin{tabular}{llll}"
		noisily dis "\toprule \toprule"
		noisily dis " & Estimate & SE & N \\"
		noisily dis "\midrule"
		noisily dis "Overall & " %4.2f `b1' " & (" %4.2f `se1' ") & " %8.0fc `n1' " \\[2mm] "
	
		use "did_results.dta", clear
		gsort -b_interested
		forvalues j=1/10 {
			noisily dis strproper(varname[`j']) " & " %4.2f b_interested[`j'] " & (" %4.2f se_interested[`j'] ") & " %8.0fc n[`j'] " \\"
		}
		
		noisily dis "\bottomrule\bottomrule"
		noisily dis "\end{tabular}"
		noisily dis "\end{table}"
		log off
		
	}
	
}	






if `table_4'==1{
	
	*******************
	***Table 4
	*******************
	
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	reghdfe log_amountindustry_1 cmt_budget cmt_rules MajorityMember, absorb(CandId py)  cluster(CandId) keepsingletons
	local a1 = _b[cmt_budget]
	local a_se1 = _se[cmt_budget]
	local b1 = _b[cmt_rules]
	local b_se1 = _se[cmt_rules]
	local n1 = e(N)
	
	qui reghdfe log_amountindustry_1 cmt_budget cmt_rules  MajorityMember, absorb(CandId year)  cluster(CandId) keepsingletons
	local a2 = _b[cmt_budget]
	local a_se2 = _se[cmt_budget]
	local b2 = _b[cmt_rules]
	local b_se2 = _se[cmt_rules]
	local n2 = e(N)
	
	
	qui reghdfe log_amountindustry_1 cmt_budget cmt_rules MajorityMember , absorb(CandId StateChamberYear)  cluster(CandId) keepsingletons
	local a3 = _b[cmt_budget]
	local a_se3 = _se[cmt_budget]
	local b3 = _b[cmt_rules]
	local b_se3 = _se[cmt_rules]
	local n3 = e(N)
	
		
	set linesize 255
	capture log close
	
	quietly {
		log using "table_4.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Membership on Top Committees.} Interest groups place great value on members of committees "
		noisily display "with influence over the rules of the legislature.\label{tab:top}}"
		noisily display "\begin{tabular}{l ccc}"
		noisily display "\toprule \toprule"
		noisily dis "& \multicolumn{3}{c}{Log Group Contributions (\\$)} \\"
		noisily dis " \midrule "	
			
		noisily display " Ways \& Means/ & " %4.3fc `a1' " & " %4.3fc `a2'  " & " %4.3fc `a3' " \\ "
		noisily display " Appropriations & (" %4.3fc `a_se1' ") & (" %4.3fc `a_se2' ") & (" %4.3fc `a_se3' ")  \\[2mm] "	
	
		noisily display " Rules & " %4.3f `b1' " & " %4.3fc `b2' " & " %4.3fc `b3'   " \\ "
		noisily display "   & (" %4.3f `b_se1' ") & (" %4.3fc `b_se2' ") & (" %4.3fc `b_se3' ") \\[2mm] "	
		
		
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3'  "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes & Yes \\"
		noisily display " Majority-Party Dummy & Yes & Yes & Yes \\"
		noisily display " Year Fixed Effects & No & Yes & No  \\"
		noisily display " Party-Year Fixed Effects & Yes & No & No   \\"
		noisily display " State-Chamber-Year Fixed Effects & No & No  & Yes  \\"
	
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{4}{p{.5\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}
	
	

}




if `table_5'==1{
	
	*******************
	***Table 5
	*******************
	
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	egen spy = group(state party year)
	
	reghdfe log_amountindustry_1 appt MajorityMember , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a1 = _b[appt]
	local a_se1 = _se[appt]
	local n1 = e(N)
	
	reghdfe log_amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a2 = _b[appt]
	local a_se2 = _se[appt]
	local n2 = e(N)
	
	reghdfe log_amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateChamberYear )  cluster(CandId) keepsingletons
	local a3 = _b[appt]
	local a_se3 = _se[appt]
	local n3 = e(N)
	
	
	reghdfe log_amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateChamberYear Seniority)  cluster(CandId) keepsingletons
	local a4 = _b[appt]
	local a_se4 = _se[appt]
	local n4 = e(N)
	
	
	*for footnote: results are robust when we control for bill referral power
	reghdfe log_amountindustry_1  appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR bill_referral_power , absorb(CandId StateYear)  cluster(CandId) keepsingletons
	
	
	set linesize 255
	capture log close
	
	quietly {
		log using "table_5.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Committee Assignment Control.} Interest groups invest in legislators "
		noisily display "who possess the power to make committee assignments.\label{tab:appt}}"
		*noisily display	"\begin{adjustbox}{max width=\textwidth} "
		noisily display "\begin{tabular}{l cccc}"
		noisily display "\toprule \toprule"
		
		noisily dis "& \multicolumn{4}{c}{Log Group Contributions (\\$)} \\"
		noisily dis " \midrule "	
		
			
		noisily display " Assignment & " %4.2f `a1' " & " %4.2fc `a2' " & " %4.2fc `a3' " & " %4.2fc `a4'  " \\ "
		noisily display " Control  & (" %4.2f `a_se1' ") & (" %4.2fc `a_se2' ") & (" %4.2fc `a_se3' ") & (" %4.2fc `a_se4' ")  \\[2mm] "	
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4'  "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes & Yes & Yes  \\"
		noisily display " Majority-Party Dummy & Yes & Yes & Yes & Yes  \\"
		noisily display " State-Party-Year Fixed Effects & Yes & Yes & No & No  \\"
		noisily display " State-Chamber-Year Fixed Effects & No & No & Yes & Yes  \\"
		noisily display " Seniority Fixed Effects & No & No & No & Yes  \\"
		noisily display " Leadership Dummies & No & Yes & Yes & Yes  \\"
		
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{5}{p{.6\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		*noisily display	"\end{adjustbox}"
		noisily display "\end{table}"
		
		log close
	}
}	
	
	



if `appendix_table_1'==1{
	
	*******************
	***Appendix Table A1 (observations per state)
	*******************

	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	gen obs_house = 1 if chamber=="house"
	gen obs_senate = 1 if chamber=="senate"
	gen industrydonations_house = amountindustry_1 if chamber=="house"
	gen industrydonations_senate = amountindustry_1 if chamber=="senate"
	
	collapse (count) obs* (min) minyear = year (max) maxyear=year (mean) industrydonations* if amountindustry_1!=.   ,by(state)
	
	
	quietly {
		cap log close
		set linesize 255
		log using "appendix_table_1.tex", text replace
		noisily dis " \begin{table}[htbp] "
		noisily dis " \caption{{\bf \# observations by state and chamber.}\label{tab:obs}} "
		noisily dis " \begin{center} "
		noisily dis " \begin{adjustbox}{max width=\textwidth} "
		noisily dis "\begin{tabular}{lccccc | lccccc}"
		noisily dis "\toprule \toprule"
		noisily dis "& & \multicolumn{2}{c}{Senate} & \multicolumn{2}{c}{House}  "
		noisily dis " & & & \multicolumn{2}{c}{Senate} & \multicolumn{2}{c}{House} \\ "
		noisily dis " \cmidrule(lr){3-4}  \cmidrule(lr){5-6} \cmidrule(lr){9-10}  \cmidrule(lr){11-12} "
		noisily dis " State  & Period & Total & Avg. Industry & Total & Avg. Industry & State  & Period & Total & Avg. Industry & Total & Avg. Industry \\"
		noisily dis "  		 &  	  &  Obs. &  Donation 	  &  Obs. &  Donation 	  &        &        & Obs.  &  Donation & Obs. 		&  Donation \\"
		noisily dis "\midrule"
	
		forval i=1 (2) 50 { 
		di state[`i']	
		noisily dis  state[`i'] " & " %4.0f minyear[`i'] "-" %4.0f maxyear[`i'] " & " %9.0fc obs_senate[`i']  " & " %9.0fc industrydonations_senate[`i'] "&" %9.0fc obs_house[`i']  " & " %9.0fc industrydonations_house[`i']
		noisily dis "&" state[`i'+1] " & " %4.0f minyear[`i'+1] "-" %4.0f maxyear[`i'+1] " & " %9.0fc obs_senate[`i'+1]  " & " %9.0fc industrydonations_senate[`i'+1] "&" %9.0fc obs_house[`i'+1]  " & " %9.0fc industrydonations_house[`i'+1] "\\"
	
		}
	
		collapse (sum) obs*
		noisily dis  " \midrule"
		noisily dis  " &  &  & & && & \\" 
		
		noisily dis "\bottomrule \bottomrule"	
		noisily dis "\end{tabular}"
		noisily dis "\end{adjustbox}"
		noisily dis "\end{center}"
		noisily dis "\end{table}"
		
		log off
	}
	

}



if `appendix_table_2'==1{
	
	*******************
	***Appendix Table A2 
	*******************

	
	***main table in with pct as outcome
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	egen spy = group(state party year)
	
	reghdfe pct_1 appt  , absorb(CandId spy)  cluster(CandId)
	
	local a1 = _b[appt]
	local a_se1 = _se[appt]
	local n1 = e(N)
	
	reghdfe pct_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a2 = _b[appt]
	local a_se2 = _se[appt]
	local n2 = e(N)
	
	reghdfe pct_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateChamberYear)  cluster(CandId) keepsingletons
	local a3 = _b[appt]
	local a_se3 = _se[appt]
	local n3 = e(N)
	
	
	reghdfe pct_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateChamberYear Seniority)  cluster(CandId) keepsingletons
	local a4 = _b[appt]
	local a_se4 = _se[appt]
	local n4 = e(N)
	
	**results for footnote: effects are there when we control for bill referral power
	reghdfe pct_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR bill_referral_power , absorb(CandId StateYear)  cluster(CandId) keepsingletons
	
		
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_2.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Committee Assignment Control.} Interest groups invest in legislators "
		noisily display "who possess the power to make committee assignments.\label{tab:appt_pct}}"
		noisily display "\begin{tabular}{l cccc}"
		noisily display "\toprule \toprule"
		
		noisily dis "\\ & \multicolumn{4}{c}{Group Contributions (\%)} \\"
		noisily dis " \cmidrule(lr){2-5} "	
		
			
		noisily display " Assignment & " %4.2f `a1' " & " %4.2fc `a2' " & " %4.2fc `a3' " & " %4.2fc `a4'  " \\ "
		noisily display " Control  & (" %4.2f `a_se1' ") & (" %4.2fc `a_se2' ") & (" %4.2fc `a_se3' ") & (" %4.2fc `a_se4' ")  \\[2mm] "	
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4'  "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes & Yes & Yes  \\"
		noisily display " Majority-Party Dummy & Yes & Yes & Yes & Yes  \\"
		noisily display " State-Party-Year Fixed Effects & Yes & Yes & No & No  \\"
		noisily display " State-Chamber-Year Fixed Effects & No & No & Yes & Yes  \\"
		noisily display " Seniority Fixed Effects & No & No & No & Yes  \\"
		noisily display " Leadership Dummies & No & Yes & Yes & Yes  \\"
	
		
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{5}{p{.6\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}
	
}	




if `appendix_table_3'==1{
	
	*******************
	***Appendix Table A3 
	*******************

	****interaction: indirect effect in pct
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	gen apptXlimit = appt*limit
	gen apptXsquire = appt*squire_rank
	
	reghdfe pct_1 appt MajorityMember apptXlimit limit SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR, absorb(CandId StateYear)  cluster(CandId) keepsingletons
	
	*** test for footnote in paper
	test appt + apptXlimit == 0
	
	local a1 = _b[appt]
	local a_se1 = _se[appt]
	
	local s1 = _b[apptXlimit]
	local s_se1 = _se[apptXlimit]
	local n1 = e(N)
	
	reghdfe pct_1 appt MajorityMember apptXsquire squire SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateYear)  cluster(CandId) keepsingletons
	local a2 = _b[appt]
	local a_se2 = _se[appt]
	local s2 = _b[apptXsquire]
	local s_se2 = _se[apptXsquire]
	local n2 = e(N)
	
		
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_3.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Committee Assignment Control and State-level Institutions.}\label{tab:appt_interactions_pct}}"
		noisily display "\begin{tabular}{lcc}"
		noisily display "\toprule \toprule"
		noisily display " & Group  & Group \\"
		noisily display "& Contributions (\%) & Contributions (\%) \\"
		noisily display "\midrule"
			
		noisily display " Assignment & " %4.2f `a1' " & " %4.2fc `a2'  " \\ "
		noisily display " Control  & (" %4.2f `a_se1' ") & (" %4.2fc `a_se2' ") \\[2mm] "	
	
	
		noisily display " Assignment \(\times\) & " %4.2f `s1' " &  \\ "
		noisily display " Term Limits & (" %4.2f `s_se1' ") &  \\[2mm] "
		
		noisily display " Assignment \(\times\) &  & " %4.2fc `s2' "   \\ "
		noisily display " Squire Index &  & (" %4.2fc `s_se2' ")   \\[2mm] "		
		
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes   \\"
		noisily display " Majority-Party Dummy & Yes & Yes   \\"
		noisily display " State-Year Fixed Effects & Yes & Yes  \\"
		noisily display " Leadership Dummies & Yes & Yes  \\"
	
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{3}{p{.7\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}
	
}	




if `appendix_table_4'==1{
	
	*******************
	***Appendix Table A4 
	*******************

	***Alternative specifications
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	gen speakerpowerXspeaker = SpeakerHouse*speakerpower
	
	egen spy = group(state party year)
	
	reghdfe log_amountindustry_1 appt MajorityMember , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a1 = _b[appt]
	local a_se1 = _se[appt]
	local n1 = e(N)
	
	reghdfe log_amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a2 = _b[appt]
	local a_se2 = _se[appt]
	local n2 = e(N)
	
	reghdfe log_amountindustry_1 appt bill_referral_power MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId spy )  cluster(CandId) keepsingletons
	local a3 = _b[appt]
	local a_se3 = _se[appt]
	local n3 = e(N)
	
	
	reghdfe log_amountindustry_1 appt bill_referral_power speakerpowerXspeaker MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId spy )  cluster(CandId) keepsingletons
	local a4 = _b[appt]
	local a_se4 = _se[appt]
	local n4 = e(N)
	
	
		
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_4.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Committee Assignment Control.} The results are robust when "
		noisily display " we control for bill referral power and an index of Speaker power.\label{tab:appt_robust}}"
		noisily display "\begin{tabular}{l cccc}"
		noisily display "\toprule \toprule"
		
		noisily dis "& \multicolumn{4}{c}{Log Group Contributions (\\$)} \\"
		noisily dis " \midrule "	
		
			
		noisily display " Assignment & " %4.2f `a1' " & " %4.2fc `a2' " & " %4.2fc `a3' " & " %4.2fc `a4'  " \\ "
		noisily display " Control  & (" %4.2f `a_se1' ") & (" %4.2fc `a_se2' ") & (" %4.2fc `a_se3' ") & (" %4.2fc `a_se4' ")  \\[2mm] "	
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4'  "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes & Yes & Yes  \\"
		noisily display " State-Party-Year Fixed Effects & Yes & Yes & Yes & Yes  \\"
		noisily display " Majority-Party Dummy & Yes & Yes & Yes & Yes  \\"
		noisily display " Leadership Dummies & No & Yes & Yes & Yes  \\"
		noisily display " Bill Referral Power & No & No & Yes & Yes  \\"
		noisily display " Speaker Power $\times$ Speaker & No & No & No & Yes  \\"
	
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{5}{p{.6\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}

}	
	

	
	
if `appendix_table_5'==1{
	
	*******************
	***Appendix Table A5
	*******************
			
	**Estimates in levels
	
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	egen spy = group(state party year)
	
	reghdfe amountindustry_1 appt MajorityMember , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a1 = _b[appt]
	local a_se1 = _se[appt]
	local n1 = e(N)
	local MajorityMember1 = _b[MajorityMember]
	local MajorityMember_se1 = _se[MajorityMember]
	
	
	
	reghdfe amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId spy)  cluster(CandId) keepsingletons
	local a2 = _b[appt]
	local a_se2 = _se[appt]
	local n2 = e(N)
	foreach v in MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR {
		local `v'2 = _b[`v']
		local `v'_se2 = _se[`v']
	}
	
	reghdfe amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateChamberYear )  cluster(CandId) keepsingletons
	local a3 = _b[appt]
	local a_se3 = _se[appt]
	local n3 = e(N)
	foreach v in MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR {
		local `v'3 = _b[`v']
		local `v'_se3 = _se[`v']
	}
	
	
	reghdfe amountindustry_1 appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateChamberYear Seniority)  cluster(CandId) keepsingletons
	local a4 = _b[appt]
	local a_se4 = _se[appt]
	local n4 = e(N)
	foreach v in MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR {
		local `v'4 = _b[`v']
		local `v'_se4 = _se[`v']
	}
		
	
	
	
	*for footnote: results are robust when we control for bill referral power
	reghdfe log_amountindustry_1  appt MajorityMember SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR bill_referral_power , absorb(CandId StateYear)  cluster(CandId) keepsingletons
		
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_5.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Committee Assignment Control.} Interest groups invest in legislators "
		noisily display "who possess the power to make committee assignments.\label{tab:appt_levels}}"
		noisily display "\begin{tabular}{l cccc}"
		noisily display "\toprule \toprule"
		
		noisily dis "& \multicolumn{4}{c}{Total Group Contributions (\\$)} \\"
		noisily dis " \midrule "	
		
			
		noisily display " Assignment & " %9.0fc `a1' " & " %9.0fc `a2' " & " %9.0fc `a3' " & " %9.0fc `a4'  " \\ "
		noisily display " Control  & (" %9.0fc `a_se1' ") & (" %9.0fc `a_se2' ") & (" %9.0fc `a_se3' ") & (" %9.0fc `a_se4' ")  \\[2mm] "	
		
		noisily display " Majority & "  " & " %9.0fc `MajorityLeader2' " & " %9.0fc `MajorityLeader3' " & " %9.0fc `MajorityLeader4'  " \\ "
		noisily display " Leader  &  & (" %9.0fc `MajorityLeader_se2' ") & (" %9.0fc `MajorityLeader_se3' ") & (" %9.0fc `MajorityLeader_se4' ")  \\[2mm] "	
		
		noisily display " Minority & "  " & " %9.0fc `MinorityLeader2' " & " %9.0fc `MinorityLeader3' " & " %9.0fc `MinorityLeader4'  " \\ "
		noisily display " Leader  &  & (" %9.0fc `MinorityLeader_se2' ") & (" %9.0fc `MinorityLeader_se3' ") & (" %9.0fc `MinorityLeader_se4' ")  \\[2mm] "			
		
		noisily display " Speaker of & "  " & " %9.0fc `SpeakerHouse2' " & " %9.0fc `SpeakerHouse3' " & " %9.0fc `SpeakerHouse4'  " \\ "
		noisily display " the House  &  & (" %9.0fc `SpeakerHouse_se2' ") & (" %9.0fc `SpeakerHouse_se3' ") & (" %9.0fc `SpeakerHouse_se4' ")  \\[2mm] "	
		
		noisily display " President of & "  " & " %9.0fc `PresidentSenate2' " & " %9.0fc `PresidentSenate3' " & " %9.0fc `PresidentSenate4'  " \\ "
		noisily display " the Senate  &  & (" %9.0fc `PresidentSenate_se2' ") & (" %9.0fc `PresidentSenate_se3' ") & (" %9.0fc `PresidentSenate_se4' ")  \\[2mm] "	

		noisily display " President  & "  " & " %9.0fc `PresidentProTemSenate2' " & " %9.0fc `PresidentProTemSenate3' " & " %9.0fc `PresidentProTemSenate4'  " \\ "
		noisily display " Pro Tem  &  & (" %9.0fc `PresidentProTemSenate_se2' ") & (" %9.0fc `PresidentProTemSenate_se3' ") & (" %9.0fc `PresidentProTemSenate_se4' ")  \\[2mm] "	
							
		noisily display " Chair & "  " & " %9.0fc `ChairCR2' " & " %9.0fc `ChairCR3' " & " %9.0fc `ChairCR4'  " \\ "
		noisily display " Rules  &  & (" %9.0fc `ChairCR_se2' ") & (" %9.0fc `ChairCR_se3' ") & (" %9.0fc `ChairCR_se4' ")  \\[2mm] "	
			
		
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' " & " %6.0fc `n3' " & " %6.0fc `n4'  "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes & Yes & Yes  \\"
		noisily display " Majority-Party Dummy & Yes & Yes & Yes & Yes  \\"
		noisily display " State-Party-Year Fixed Effects & Yes & Yes & No & No  \\"
		noisily display " State-Chamber-Year Fixed Effects & No & No & Yes & Yes  \\"
		noisily display " Seniority Fixed Effects & No & No & No & Yes  \\"
		noisily display " Leadership Dummies & No & Yes & Yes & Yes  \\"
		
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{5}{p{.6\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}
	
}	
	

	
	
	
	
if `appendix_table_6'==1{
	
	*******************
	***Appendix Table A6
	*******************	
	

	****interaction: indirect effect
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	
	gen apptXlimit = appt*limit
	gen apptXsquire = appt*squire_rank
	
	reghdfe log_amountindustry_1 appt MajorityMember apptXlimit limit SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR, absorb(CandId StateYear)  cluster(CandId) keepsingletons
	
	*** test for footnote in paper
	test appt + apptXlimit == 0
	
	local a1 = _b[appt]
	local a_se1 = _se[appt]
	
	local s1 = _b[apptXlimit]
	local s_se1 = _se[apptXlimit]
	local n1 = e(N)
	
	reghdfe log_amountindustry_1 appt MajorityMember apptXsquire squire SpeakerHouse PresidentSenate PresidentProTemSenate MajorityLeader MinorityLeader ChairCC ChairCR , absorb(CandId StateYear)  cluster(CandId) keepsingletons
	local a2 = _b[appt]
	local a_se2 = _se[appt]
	local s2 = _b[apptXsquire]
	local s_se2 = _se[apptXsquire]
	local n2 = e(N)
	
	
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_6.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Committee Assignment Control and State-level Institutions.}\label{tab:appt_interactions}}"
		noisily display "\begin{tabular}{lcc}"
		noisily display "\toprule \toprule"
		noisily display " & Log Group  & Log Group \\"
		noisily display "& Contributions (\\$) & Contributions (\\$) \\"
		noisily display "\midrule"
			
		noisily display " Assignment & " %4.2f `a1' " & " %4.2fc `a2'  " \\ "
		noisily display " Control  & (" %4.2f `a_se1' ") & (" %4.2fc `a_se2' ") \\[2mm] "	
	
	
		noisily display " Assignment \(\times\) & " %4.2f `s1' " &  \\ "
		noisily display " Term Limits & (" %4.2f `s_se1' ") &  \\[2mm] "
		
		noisily display " Assignment \(\times\) &  & " %4.2fc `s2' "   \\ "
		noisily display " Squire Index &  & (" %4.2fc `s_se2' ")   \\[2mm] "		
		
		noisily display " N & " %6.0fc `n1' " & " %6.0fc `n2' "\\[2mm]"
		noisily display " Individual Fixed Effects & Yes & Yes   \\"
		noisily display " Majority-Party Dummy & Yes & Yes   \\"
		noisily display " State-Year Fixed Effects & Yes & Yes  \\"
		noisily display " Leadership Dummies & Yes & Yes  \\"
	
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{3}{p{.7\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}
	
}	
	
	

	
	
	
if `appendix_table_7'==1{
	
	*******************
	***Appendix Table A7
	*******************	
	
	****interaction: direct effect
	
	use "triple_diff.dta", clear
	
	gen cmtXlimit = cmt*limit
	gen cmtXsquire = cmt*squire_rank
	
	reghdfe log_amount cmt cmtXlimit limit, a(cand_industry cand_year industry_year) cluster(CandId) keepsingletons
	
	
	local a1 = _b[cmt]
	local a_se1 = _se[cmt]
	
	local s1 = _b[cmtXlimit]
	local s_se1 = _se[cmtXlimit]
	local n1 = e(N)
	
	reghdfe log_amount cmt cmtXsquire squire, a(cand_industry cand_year) cluster(CandId) keepsingletons
	
	local a2 = _b[cmt]
	local a_se2 = _se[cmt]
	local s2 = _b[cmtXsquire]
	local s_se2 = _se[cmtXsquire]
	
	local n2 = e(N)
	
	
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_7.tex", text replace
		
		noisily display "\begin{table}[t]"
		noisily display "\centering"
		noisily display "\footnotesize"
		noisily display "\caption{{\bf Value of Industry-Specific Committee Membership and State-level Institutions.}\label{tab:cmt_interactions}}"
		noisily display "\begin{tabular}{lcc}"
		noisily display "\toprule \toprule"
		noisily display " & Log Group  & Log Group \\"
		noisily display "& Contributions (\\$) & Contributions (\\$) \\"
		noisily display "\midrule"
			
		noisily display " Committee Membership & " %4.3f `a1' " & " %4.3fc `a2' " \\ "
		noisily display "   & (" %4.3f `a_se1' ") & (" %4.3fc `a_se2' ") \\[2mm] "	
	
	
		noisily display " Committee Membership \(\times\) & " %4.3f `s1' " &   \\ "
		noisily display " Term Limits & (" %4.3f `s_se1' ") &   \\[2mm] "
		
		noisily display " Committee Membership \(\times\) &  & " %4.3fc `s2' "  \\ "
		noisily display " Squire Index &  & (" %4.3fc `s_se2' ")  \\[2mm] "		
	
		noisily display " N & " %8.0fc `n1' " & " %8.0fc `n2' "\\[2mm]"
		noisily display " Candidate by Year FEs & Yes & Yes  \\"
		noisily display " Candidate by Industry FEs & Yes & Yes \\"
	
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{3}{p{.7\textwidth}}{Robust standard errors clustered by legislators in parentheses.}"
	
		noisily display "\end{tabular}"
		noisily display "\end{table}"
		
		log close
	}
		
}		
	
	
if `appendix_table_8'==1{
	
	*******************
	***Appendix Table A8
	*******************		
	
	** table with variation in
	use "How_Do_Interest_Groups_Seek_Access_to_Committees.dta", clear
	replace year = year + 1 if state=="MS" | state=="LA" | state=="NJ" | state=="VA"
	drop e_appt_com
	collapse (max) *_appt_com_*, by(state chamber year)
	egen tmp = rowtotal(*appt_com*) 
	gen other_appt_com_  =  tmp==0
	drop tmp
	egen tmp = rowtotal(*appt_com*) 
	qui foreach var of varlist *_appt_com_*  {
		replace `var' = 100*(`var'/tmp)
		replace `var' = . if state=="NE" & chamber=="house"
	}
	
	collapse (mean) *_appt_com_* , by(state chamber)
	

	reshape wide  s_appt_com_ p_appt_com_ pt_appt_com_ cc_appt_com_ cr_appt_com_ mjl_appt_com_ mnl_appt_com_ other_appt_com_  , i(state) j(chamber) string
		
	set linesize 255
	capture log close
	
	quietly {
		log using "appendix_table_8.tex", text replace
		
		noisily display "\begin{table}[p]"
		noisily display "\begin{center}"
		noisily display "\caption{ {\bf Committee Assignment Control (\% of years from 1988-2012).} \label{tab:overview} }" 
		noisily display "\begin{adjustbox}{max width=0.9\textwidth} "
		noisily display "\begin{tabular}{l cccccc | ccccccc}"
		noisily display "\toprule \toprule"
		noisily display "  & \multicolumn{6}{c}{{\Large House}} & \multicolumn{7}{c}{{\Large Senate}} \\ "
		noisily display "  & \rot{60}{Maj. Leader} &  \rot{60}{Min. Leader} & \rot{60}{Speaker} &  \rot{60}{Com. on Com.} & \rot{60}{Rules Com.} & \rot{60}{Other} & "
		noisily display "  \rot{60}{Maj. Leader} &  \rot{60}{Min. Leader} &  \rot{60}{President} &  \rot{60}{Pres. Pro Tem} & \rot{60}{Com. on Com.} & \rot{60}{Rules Com.} & \rot{60}{Other} \\"
		noisily display "\midrule"
		
	forval i=1/50 {
		noisily display state[`i'] " & " %3.1f mjl_appt_com_h[`i'] " & " %3.1f mnl_appt_com_h[`i'] " & " %3.1f s_appt_com_h[`i']  " & " %3.1f cc_appt_com_h[`i']  " & " %3.1f cr_appt_com_h[`i'] " & " %3.1f other_appt_com_h[`i'] 
		noisily display 		   " & " %3.1f mjl_appt_com_s[`i'] " & " %3.1f mnl_appt_com_s[`i'] " & " %3.1f p_appt_com_s[`i']  " & " %3.1f pt_appt_com_s[`i'] " & " %3.1f cc_appt_com_s[`i'] " & " %3.1f cr_appt_com_s[`i'] " & " %3.1f other_appt_com_s[`i']  "\\"
		}	
	
		noisily display " \bottomrule \bottomrule"
		noisily display "\multicolumn{12}{p{0.95\textwidth}}{Note: For each state, the table reports the percent of years in which "
		noisily display " the leader indicated by column header is responsible for appointing committee members. }"
		noisily display "\end{tabular}"
		noisily display "\end{adjustbox}"
		noisily display "\end{center}"
		noisily display "\end{table}"
		
		log close
	} 	
		
}	

