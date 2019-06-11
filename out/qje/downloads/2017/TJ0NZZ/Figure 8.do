		
cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
*open politicians data set
use "13 ENGLISH politicians with pol and background data 1988-2011.dta", clear
*add earnings power data
joinby p_id using "income residual new.dta", unmatched(master)
*add data on political competiton
ren m_id_politician m_id

joinby m_id electionyear using "competition_measures.dta", unmatched(master)
tab _merge
drop _merge
***keep one year per election
		
keep if year ==1992 | year==1995 | year == 1999 | year == 2003 | year == 2005 | year == 2011
*keep only those who are nominate (orignial data contains full panel)
keep if nominated ==1
*replace 0 with missing for draft data
		replace iq=. if iq==0
		replace leader=. if leader==0
	
		cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\Parents-politicians comparison"
			joinby p_id using "Parents income 1979.dta", unmatched(master)
			cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Data files"
			bysort llkk electionyear partyinitial: egen no_elec= sum(elected)
			drop _merge m_id
	

	
foreach depvar in iq leader inc_res {
		
		matrix `depvar'T = J(8,4,.)
		
		foreach rank in 1 2 3 4 5 6 7 8 {

			*sum `depvar' if listrank == `rank'
			tabstat `depvar' if listrank == `rank' & no_elec>=8, stat(mean semean) save
			
			matrix temp = r(StatTotal)
			matrix `depvar'T[`rank',1]=temp[1,1]
			matrix `depvar'T[`rank',2]=temp[2,1]
			matrix `depvar'T[`rank',3]=temp[2,1]
			matrix `depvar'T[`rank',4]=`rank'
				
	}
			svmat `depvar'T
			replace `depvar'T2 = `depvar'T1-(`depvar'T2*1.96)
			replace `depvar'T3 = `depvar'T1+(`depvar'T3*1.96)
	}
	
	
	* Plot scatter for means and confidence intervals (for the means)	

	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\combination valance"	
	
			 *legend(label(1 "Average Score")label(2 "95% Confidence Interval") region(lcolor(white))) ///

		graph twoway (scatter iqT1 iqT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar iqT2 iqT3 iqT4, barwidth(0.01) color(black)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Cognitive Score") legend(off)
		
		graph save "listr1_15_cog.gph", replace
		
		graph twoway (scatter leaderT1 leaderT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar leaderT2 leaderT3 leaderT4, barwidth(0.01) color(black)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Leadership Score") legend(off)
		
		graph save "listr1_15_leader.gph", replace
		
		graph twoway (scatter inc_resT1 inc_resT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar inc_resT2 inc_resT3 inc_resT4, barwidth(0.01) color(black)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Earnings Score") legend(off)
		
		graph save "listr1_15_inc_res.gph", replace
	
			egen tag_m = tag(electionyear m_id)
		gen comp = avg_dist3
		sum comp if tag_m==1, detail
	
	*define high and low competition municipaliteis based on if they are in the upper or lower quartile
		gen highcomp = 1 if comp<0.0496795
		gen lowcomp = 1 if comp>0.1336196 & comp!=.

*		create dummies for if fahters income in 1979 was above or below the median
	gen low_finc= parpct_father<=50 if parpct_father!=.
	gen high_finc= parpct_father>50 if parpct_father!=.
	
***calculte menas and confidence intervals for each subsample
	foreach split in  low_finc high_finc highcomp lowcomp{
		foreach depvar in iq leader inc_res {
		
		matrix `split'_`depvar'T = J(8,4,.)
		
		foreach rank in 1 2 3 4 5 6 7 8 {

			*sum `depvar' if listrank == `rank'
			tabstat `depvar' if listrank == `rank' & `split'==1 & no_elec>=8, stat(mean semean) save

			matrix temp = r(StatTotal)
			matrix `split'_`depvar'T[`rank',1]=temp[1,1]
			matrix `split'_`depvar'T[`rank',2]=temp[2,1]
			matrix `split'_`depvar'T[`rank',3]=temp[2,1]
			matrix `split'_`depvar'T[`rank',4]=`rank'
		
		
	}
			svmat `split'_`depvar'T
			replace `split'_`depvar'T2 = `split'_`depvar'T1-(`split'_`depvar'T2*1.96)
			replace `split'_`depvar'T3 = `split'_`depvar'T1+(`split'_`depvar'T3*1.96)
		
	}
	
	}
			foreach depvar in iq leader inc_res {
			replace low_finc_`depvar'T4= low_finc_`depvar'T4-0.1
			replace high_finc_`depvar'T4= high_finc_`depvar'T4+0.1
			replace lowcomp_`depvar'T4= lowcomp_`depvar'T4-0.1
			replace highcomp_`depvar'T4= highcomp_`depvar'T4+0.1
	}

	* Plot scatter for means and confidence intervals (for the means)	

	cd "\\micro.intra\Projekt\P0624$\P0624_Gem\Data Extraction and Files\Figures population comparisons\combination valance"	
	
		

		graph twoway (scatter low_finc_iqT1 low_finc_iqT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar low_finc_iqT2 low_finc_iqT3 low_finc_iqT4, barwidth(0.01) color(black)) ///
				(scatter high_finc_iqT1 high_finc_iqT4, color(gray) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar high_finc_iqT2 high_finc_iqT3 high_finc_iqT4, barwidth(0.01) color(gray)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Cognitive Score") legend(off)
		
		graph save "listr1_15_cog_fpct.gph", replace
		
		graph twoway (scatter low_finc_leaderT1 low_finc_leaderT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar low_finc_leaderT2 low_finc_leaderT3 low_finc_leaderT4, barwidth(0.01) color(black)) ///
				 (scatter high_finc_leaderT1 high_finc_leaderT4, color(gray) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar high_finc_leaderT2 high_finc_leaderT3 high_finc_leaderT4, barwidth(0.01) color(gray)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Leadership Score") legend(off)
		
		graph save "listr1_15_leader_fpct.gph", replace
		
		graph twoway (scatter low_finc_inc_resT1 low_finc_inc_resT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar low_finc_inc_resT2 low_finc_inc_resT3 low_finc_inc_resT4, barwidth(0.01) color(black)) ///
				 (scatter high_finc_inc_resT1 high_finc_inc_resT4, color(gray) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar high_finc_inc_resT2 high_finc_inc_resT3 high_finc_inc_resT4, barwidth(0.01) color(gray)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Earnings Score") legend(off)
		
		graph save "listr1_15_inc_res_fpct.gph", replace
		
				graph twoway (scatter lowcomp_iqT1 lowcomp_iqT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar lowcomp_iqT2 lowcomp_iqT3 lowcomp_iqT4, barwidth(0.01) color(black)) ///
				(scatter highcomp_iqT1 highcomp_iqT4, color(gray) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar highcomp_iqT2 highcomp_iqT3 highcomp_iqT4, barwidth(0.01) color(gray)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Cognitive Score") legend(off)
		
		graph save "listr1_15_cog_comp.gph", replace
		
		graph twoway (scatter lowcomp_leaderT1 lowcomp_leaderT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar lowcomp_leaderT2 lowcomp_leaderT3 lowcomp_leaderT4, barwidth(0.01) color(black)) ///
				 (scatter highcomp_leaderT1 highcomp_leaderT4, color(gray) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar highcomp_leaderT2 highcomp_leaderT3 highcomp_leaderT4, barwidth(0.01) color(gray)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Leadership Score") legend(off)
		
		graph save "listr1_15_leader_comp.gph", replace
		
		graph twoway (scatter lowcomp_inc_resT1 lowcomp_inc_resT4, color(black) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar lowcomp_inc_resT2 lowcomp_inc_resT3 lowcomp_inc_resT4, barwidth(0.01) color(black)) ///
				 (scatter highcomp_inc_resT1 highcomp_inc_resT4, color(gray) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8")) ///
				 (rbar highcomp_inc_resT2 highcomp_inc_resT3 highcomp_inc_resT4, barwidth(0.01) color(gray)), ///
				 xtitle("List Rank", size(mlarge)) ytitle("Average", size(mlarge)) ///
				 graphregion(color(white)) ylabel(,angle(0) labs(mlarge)) ///
				 xlabel(, labs(mlarge)) title("Earnings Score") legend(off)
				graph save "listr1_15_inc_res_comp.gph", replace
		
	graph combine "listr1_15_cog.gph" "listr1_15_cog_fpct.gph"  "listr1_15_cog_comp.gph" ///
	"listr1_15_leader.gph" "listr1_15_leader_fpct.gph" "listr1_15_leader_comp.gph" ///
	"listr1_15_inc_res.gph" "listr1_15_inc_res_fpct.gph" "listr1_15_inc_res_comp.gph" ///
			, ysize(14) xsize(20) iscale(.6) scheme(s1mono) col(3) row(3) 
		graph save "list rank competence fpct comp", replace
		
	

	