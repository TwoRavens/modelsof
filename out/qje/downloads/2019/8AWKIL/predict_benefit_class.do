version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main_predict
    clean_data_predict, dep_var(snap_benefits_9m)
	gen one = 1
	classification, cat_num(7) indep_var(age_80plus                  ///
                                   city_pitt male non_english               ///
                                   race_white race_black race_others            ///
                                   Ibefore_2011                                 ///
                                   spending hospital SNF ED doctor              ///
                                   Ifull_year chronic one)
	graphs
end

program clean_data_predict
    syntax, dep_var(str)
    use ../temp/exhibit_analysis, clear
	cap drop Itrain Ipredict
	cap drop *enefit_ca* 
	cap drop one 
	cap drop *_l 
	cap drop temp_*
	cap drop xbd*
	cap drop xb*
	cap drop threshold*
	cap drop predict_cat
	cap drop predict_benefit
	cap drop id
	cap drop count
	cap drop logit_* id_* prob_* rmax *redict_ca* *redict_benefi* id count				
    gen Itrain = enrollee_9m == 1 & Imiss_benefit_9m == 0
    gen Ipredict = SP == 1

	cap gen snap_benefits_9m_win = snap_benefits_9m
    sum snap_benefits_9m, de
    replace snap_benefits_9m_win = r(p99) if snap_benefits_9m > r(p99) & !mi(snap_benefits_9m)
	
	class_define, cat_num(7) condition1(`dep_var' < 16) ///
                            condition2(`dep_var' == 16) ///
                            condition3(`dep_var' > 16 & `dep_var' < 194) ///
                            condition4(`dep_var' == 194) ///
                            condition5(`dep_var' > 194 & `dep_var' < 357) ///
                            condition6(`dep_var' == 357) ///
                            condition7(`dep_var' > 357 & `dep_var' != .) ///
							dep_var1(`dep_var')
             
    save ../temp/predict_benefits_class, replace
end

program classification
	syntax, cat_num(real) indep_var(str)
    foreach v in `indep_var' {
        assert mi(`var') == 0
    }

	forval i = 1/`cat_num' {
		qui gen temp_`i' = benefit_cat == `i' & Itrain == 1
		qui replace temp_`i' = . if Itrain != 1
		qui count if Itrain == 1
		local N = r(N)
		qui count if temp_`i' == 1
		local s`i' = log( (r(N)/`N'+ 1e-3) / (1 - r(N)/`N') )
		di "S`i' is `s`i''"
		
		logit temp_`i' `indep_var' if Itrain == 1, noconstant
		predict xb`i', xb
		
        summ xb`i' if Itrain == 1
		gen threshold`i' = `s`i'' - r(mean)
		gen xbd`i' = xb`i' + threshold`i'
    }
	
	gen predict_cat = .
	gen predict_benefit = .
	cap drop max
	egen max = rowmax(xb*)
	forvalues i = 1/`cat_num' {
		cap drop temp
		gen temp = abs(max - xbd`i') < 1e-4
		replace predict_cat = `i' if temp == 1 
	}

	summ threshold*
    
	forval it = 1/500 {
        di "it `it'"
		tab predict_cat
		forval i = 1/`cat_num' {
			qui count if predict_cat == `i' & Itrain == 1
			qui local a = (`s`i''  - log( (r(N)/`N' + 1e-3) / (1 - r(N)/`N') ) )
			di "`a'"
			qui replace threshold`i' = threshold`i' + 0.01 * (`s`i''  - log( (r(N)/`N'+ 1e-3) / (1 - r(N)/`N') ) )
			qui replace xbd`i' = xb`i' + threshold`i' 
		}
		
		cap drop max
		egen max = rowmax(xbd*)
		forvalues i = 1/`cat_num' {
			qui cap drop temp
			qui gen temp = abs(max - xbd`i') < 1e-3
			qui replace predict_cat = `i' if temp == 1 
			qui replace predict_benefit = ${weight_`i'} if predict_cat == `i' 
		}
	}
	
    replace predict_cat = . if Ipredict != 1
    replace predict_benefit = . if Ipredict != 1
    save ../temp/predict_benefit_class, replace
	
	use ../temp/predict_benefit_class, clear
	di "######## For predicted benefit section in paper ########"
	count if !mi(benefit_cat)
	local N = r(N)
	di "`N' obs have actual benefit category"
	count if predict_cat == benefit_cat & benefit_cat != .
	local match = r(N)
	local match_rate = round(`match'/`N'*100, 0.0001)
	di "`match' obs have matched predicted category, which is `match_rate'%"
	count if abs(benefit_cat -predict_cat ) == 1 & benefit_cat != .
	local one_off = r(N)
	local one_off_rate = round(`one_off'/`N'*100, 0.0001)
	di "`one_off' obs have one-off predicted category, which is `one_off_rate'%"
	forval i = 1/7 {
		count if benefit_cat == `i'
		matrix benefit_cat = nullmat(benefit_cat) \ r(N)
	}
	matrix benefit_cat = benefit_cat \ `N'
	fill_tables, mat(benefit_cat) save_excel(../output_excel/benefit_cat.xlsx)
end

program graphs
	use ../temp/predict_benefit_class, clear
	cap drop id
	sum snap_benefits_9m if benefit_cat == 3
	local cat_3 = round(r(mean), 1)
	sum snap_benefits_9m if benefit_cat == 5
	local cat_5 = round(r(mean), 1)
	sum snap_benefits_9m if benefit_cat == 7
	local cat_7 = round(r(mean), 1)
	sum snap_benefits_9m_win if Itrain == 1
	local win_max = r(max)
	
	gen id = Itrain == 1
	
    bysort predict_cat benefit_cat: egen count = sum(id)
	scatter benefit_cat predict_cat [w=count], msymbol(circle_hollow) ylabel(1 2 3 4 5 6 7)
    graph_export_convert, graph("../output/class_predict_scatter")
	
	twoway (histogram predict_benefit if Itrain == 1, color(sand) fraction)										///
		   (histogram snap_benefits_9m_win if Itrain == 1, fcolor(none) lcolor(black) lwidth(thin)	fraction		///
				title("Distribution of Benefit in Dollars") legend(order(1 "Predicted" 2 "Actual (winsorized at 99%)")) ///
				graphregion(fcolor(white)) xtitle("Monthly SNAP Benefits") 		///
				xlabel(0 "0" 18 "16" `cat_3' "`cat_3'" 194 "194" `cat_5' "`cat_5'" 357 "357" `win_max' "`win_max'" `cat_7' "`cat_7'"))
	graph_export_convert, graph("../output/dollars_predict_histogram")
	
	twoway (histogram predict_cat if Itrain == 1, color(sand) fraction)										///
		   (histogram benefit_cat if Itrain == 1, fcolor(none) lcolor(black) lwidth(thin)	fraction		///
				title("Distribution of Benefit in Classes") legend(order(1 "Predicted" 2 "Actual")) xlabel(1 2 3 4 5 6 7) ///
				graphregion(fcolor(white)) xtitle("Benefit Category"))
	graph_export_convert, graph("../output/class_predict_histogram")
end

	program class_define
        syntax, cat_num(real) condition1(str) condition2(str) [condition3(str) condition4(str) ///
            condition5(str) condition6(str) condition7(str)] dep_var1(str)
		** generate categorical actual benefit variables
        gen benefit_cat = 0
        forval x = 1/`cat_num' {
			gen Ibenefit_cat_`x' = (`condition`x'')
			replace Ibenefit_cat_`x' = . if Itrain != 1
            replace benefit_cat = `x' if `condition`x''
			sum `dep_var1' if Ibenefit_cat_`x' == 1
			global weight_`x' = r(mean)
        }
        replace benefit_cat = . if Itrain != 1
	end
	
	program graph_export_convert
		syntax, graph(str)
		graph export `graph'.eps, replace
		shell convert -density 500 `graph'.eps -quality 100 `graph'.png
		shell rm ../output/`graph'.eps
	end
	
main_predict
