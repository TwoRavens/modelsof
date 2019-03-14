* Alexandra Scacco and Shana Warren
* Replication code for Online Appendix to "Can Social Contact Reduce Prejudice and Discrimination? Evidence from a Field Experiment in Nigeria"

* Set directory
    *cd ""
    set more off

* Install package estout, clustse, orth_out if not already available
    ssc install estout
    ssc install clustse
    ssc install orth_out

* Load wide data
    use "Data_APSR", clear


****************************************************
* Balance
****************************************************

* Section A.4, Table A.1, Balance in UYVT vs control
    orth_out a1_base a4_hausa_base married_base a7_base religion a16_base a16_simple_base a19_base a19_simple_base ///
    	prior_computer_use a24_base a25_base b4_base b5_base b6_base b7_base asset_factor_base lived_poverty_index_base ///
    	d1a_base d2a_base d3a_base central_bus_station d7a_base d8a_base invite_index_base network_same_base network_other_base ///
    	network_share_base f1_base e5_affected_2011_base e5_serious_2011_base x7_code_base21 x7_code_base22 x7_code_base23 ///
    	x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 x7_code_base28 x7_code_base29 x7_code_base210 ///
    	x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 x7_code_base215 x7_code_base216 using "Program balance.tex", ///
    	by(assign_AvB) se compare test count bdec(2) latex replace
    sum a1_base a4_hausa_base married_base a7_base religion a16_base a16_simple_base a19_base a19_simple_base ///
    	prior_computer_use a24_base a25_base b4_base b5_base b6_base b7_base asset_factor_base lived_poverty_index_base ///
    	d1a_base d2a_base d3a_base central_bus_station d7a_base d8a_base invite_index_base network_same_base network_other_base ///
    	network_share_base f1_base e5_affected_2011_base e5_serious_2011_base
    	
* Balance in Class type (Het vs Hom)-- identifies imbalance for pre-analysis plan specified controls
    orth_out a1_base a4_hausa_base married_base a7_base religion a16_base a16_simple_base a19_base a19_simple_base ///
    	prior_computer_use a24_base a25_base b4_base b5_base b6_base b7_base asset_factor_base lived_poverty_index_base ///
    	d1a_base d2a_base d3a_base central_bus_station d7a_base d8a_base invite_index_base network_same_base network_other_base ///
    	network_share_base f1_base e5_affected_2011_base e5_serious_2011_base x7_code_base21 x7_code_base22 x7_code_base23 ///
    	x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 x7_code_base28 x7_code_base29 x7_code_base210 ///
    	x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 x7_code_base215 x7_code_base216 using "Class type balance.tex", ///
    	by(assign_CvD) se compare test count bdec(2) latex replace

* Balance in Pairs type (Het vs Hom)-- identifies imbalance for pre-analysis plan specified controls
    orth_out a1_base a4_hausa_base married_base a7_base religion a16_base a16_simple_base a19_base a19_simple_base ///
    	prior_computer_use a24_base a25_base b4_base b5_base b6_base b7_base asset_factor_base lived_poverty_index_base ///
    	d1a_base d2a_base d3a_base central_bus_station d7a_base d8a_base invite_index_base network_same_base network_other_base ///
    	network_share_base f1_base e5_affected_2011_base e5_serious_2011_base x7_code_base21 x7_code_base22 x7_code_base23 ///
    	x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 x7_code_base28 x7_code_base29 x7_code_base210 ///
    	x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 x7_code_base215 x7_code_base216 using "Pairs type balance.tex", ///
    	by(assign_CvD) se compare test count bdec(2) latex replace

	
***************************************************
* Compliance
***************************************************

* Section A.7, Table A.5 Balance in Compliance
    orth_out assign_CvD assign_EvF a1_base a4_hausa_base married_base a7_base religion a16_base a16_simple_base ///
    	a19_base a19_simple_base prior_computer_use a24_base a25_base b4_base b5_base b6_base b7_base asset_factor_base ///
    	lived_poverty_index_base d1a_base d2a_base d3a_base central_bus_station d7a_base d8a_base invite_index_base ///
    	network_same_base network_other_base network_share_base f1_base e5_affected_2011_base e5_serious_2011_base ///
    	x7_code_base21 x7_code_base22 x7_code_base23 x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 ///
    	x7_code_base28 x7_code_base29 x7_code_base210 x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 ///
    	x7_code_base215 x7_code_base216 using "Compliance balance.tex", by(compliance) se compare test count bdec(2) latex replace
    sum assign_CvD assign_EvF a1_base a4_hausa_base married_base a7_base religion a16_base a16_simple_base ///
    	a19_base a19_simple_base prior_computer_use a24_base a25_base b4_base b5_base b6_base b7_base asset_factor_base ///
    	lived_poverty_index_base d1a_base d2a_base d3a_base central_bus_station d7a_base d8a_base invite_index_base ///
    	network_same_base network_other_base network_share_base f1_base e5_affected_2011_base e5_serious_2011_base

* Omit baseline-only respondents from rest of analysis
    keep if available==2


*************************************************************
* Descriptive Statistics (except dictator, destruction game play)
*************************************************************

* Section A.5, Table A.2 Descritive Statistics
    sum prejudice_negative_end prejudice_positive_end prejudice_eval_end religion a1_base a23_base d6_base f1a_base ///
    	x7_code_base21 x7_code_base22 x7_code_base23 x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 ///
    	x7_code_base28 x7_code_base29 x7_code_base210 x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 ///
    	x7_code_base215 x7_code_base216

* Section A.5, Figure A.4: Prejudice Indices Responses
    hist prejudice_negative_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Prejudice index, negative attributes") ///
    	ylabel(0(5)30) xlabel(1(1)5) name(prejudicenegative, replace)
    hist prejudice_positive_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Prejudice index, positive attributes") ///
    	ylabel(0(5)30) xlabel(1(1)5) name(prejudicepositive, replace)
    hist prejudice_eval_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Prejudice index, out-group evaluation") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(prejudiceeval, replace)
    graph combine prejudicenegative prejudicepositive prejudiceeval, saving(prejudiceindices, replace)

* Section A.5, Figures A.5, A.6 & A.7 Prejudice indices components
    hist j16a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup friendly") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j16a, replace)
    hist j17a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup honest in business") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j17a, replace)
    hist j18a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup arrogant") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j18a, replace)
    hist j19a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup responsible") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j19a, replace)
    hist j20a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup unreasonable") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j20a, replace)
    hist j21a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup good citizens") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j21a, replace)
    hist j22a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup ungrateful") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j22a, replace)
    hist j23a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup peaceful") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j23a, replace)
    hist j24a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup dependable") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j24a, replace)
    hist j25a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup fanatical") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j25a, replace)
    hist j26a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup intelligent in school") ///
    	ylabel(0(10)70) xlabel(1(1)5) name(j26a, replace)
    hist j28a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup hardworking-lazy") ///
    	ylabel(0(10)80) xlabel(1(1)5) name(j28a, replace)
    hist j30a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup worldly-ignorant") ///
    	ylabel(0(10)80) xlabel(1(1)5) name(j30a, replace)
    hist j32a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Outgroup charitable-not generous") ///
    	ylabel(0(10)80) xlabel(1(1)5) name(j32a, replace)
    graph combine j18a j20a j22a j25a, saving(prejudicenegativecomponents, replace)
    graph combine j28a j30a j32a, saving(prejudiceevalcomponents, replace)
    graph combine j16a j17a j19a j21a j23a j24a j26a, saving(prejudicepositivecomponents, replace)


***************************************************
* Section A.6, Psychometric testing of prejudice scales
***************************************************

* Section A.6, Figure A.10: Prejudice Measures: Negative and Positive Attributes
	factor j16a_end j17a_end j18a_end j19a_end j20a_end j21a_end j22a_end j23a_end j24a_end j25a_end j26a_end
	screeplot

* Section A.6, Table A.3: Negative and Positive Attributes Components: Principal Axis Factor Loading, Oblique Rotation
	rotate, factors(2) oblique promax
	alpha j16a_end j17a_end j19a_end j21a_end j23a_end j24a_end j26a_end
	alpha j18a_end j20a_end j22a_end j25a_end

* Section A.6, Table A.4: Negative Attributes, Positive Attributes, Out-group Evaluation Components: Principal Axis Factor Loading, Oblique Rotation
	factor j16a_end j17a_end j18a_end j19a_end j20a_end j21a_end j22a_end j23a_end j24a_end j25a_end j26a_end j28a_end j30a_end j32a_end
	screeplot
	rotate, factors(3) oblique promax


***************************************************
* Robustness - prejudice
***************************************************

* Set control variables from baseline, as specified in pre-analysis plan
    local pap_controls a16_base a19_base b4_base b5_base asset_index_base lived_poverty_index_base c3b_base c3c_base d6_base network_size_base i.x7_code_base
    
    * Some imbalance with respect to UYVT vs control (AvB), Hom vs Het classes (CvD), none wrt EvF comparison
    local AvB_imbalance f1_base i.x7_code_base
	local CvD_imbalance a1_base a23_base d6_base i.x7_code_base
 	local EvF_imbalance i.x7_code_base

* Section A.8.1, Table A.6: Combined Prejudice Index, Negative and Positive Attributes
	eststo: qui reg prejudice_overall_end assign_AvB, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_AvB if religion==0, robust
 	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_AvB if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_CvD, robust
	tab assign_CvD if e(sample)==1
	eststo: qui reg prejudice_overall_end assign_CvD if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_CvD if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_EvF, robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_EvF if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_overall_end assign_EvF if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice overall AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" ///
	"\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" ///
	"\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear	

* Section A.8.2, Prejudice Indices: Treatment Group Means, Table A.7
    * Full sample
    ttest prejudice_negative_end, by(assign_AvB)
    ttest prejudice_negative_end, by(assign_CvD)
    ttest prejudice_negative_end, by(assign_EvF)
    
    ttest prejudice_positive_end, by(assign_AvB)
    ttest prejudice_positive_end, by(assign_CvD)
    ttest prejudice_positive_end, by(assign_EvF)
    
    ttest prejudice_eval_end, by(assign_AvB)
    ttest prejudice_eval_end, by(assign_CvD)
    ttest prejudice_eval_end, by(assign_EvF)
    
    * Muslims
    ttest prejudice_negative_end if religion==0, by(assign_AvB)
    ttest prejudice_negative_end if religion==0, by(assign_CvD)
    ttest prejudice_negative_end if religion==0, by(assign_EvF)
    
    ttest prejudice_positive_end if religion==0, by(assign_AvB)
    ttest prejudice_positive_end if religion==0, by(assign_CvD)
    ttest prejudice_positive_end if religion==0, by(assign_EvF)
    
    ttest prejudice_eval_end if religion==0, by(assign_AvB)
    ttest prejudice_eval_end if religion==0, by(assign_CvD)
    ttest prejudice_eval_end if religion==0, by(assign_EvF)
    
    * Christians
    ttest prejudice_negative_end if religion==1, by(assign_AvB)
    ttest prejudice_negative_end if religion==1, by(assign_CvD)
    ttest prejudice_negative_end if religion==1, by(assign_EvF)
    
    ttest prejudice_positive_end if religion==1, by(assign_AvB)
    ttest prejudice_positive_end if religion==1, by(assign_CvD)
    ttest prejudice_positive_end if religion==1, by(assign_EvF)
    
    ttest prejudice_eval_end if religion==1, by(assign_AvB)
    ttest prejudice_eval_end if religion==1, by(assign_CvD)
    ttest prejudice_eval_end if religion==1, by(assign_EvF)

* Section A.8.3, Table A.8: Main Analyses With Pre-Analysis Plan Controls Negative Attributes
	eststo: qui reg prejudice_negative_end assign_AvB `pap_controls' `AvB_imbalance', robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvB `pap_controls' `AvB_imbalance' if religion==0, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvB `pap_controls' `AvB_imbalance' if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_CvD `pap_controls' `CvD_imbalance', robust
	tab assign_CvD if e(sample)==1
	eststo: qui reg prejudice_negative_end assign_CvD `pap_controls' `CvD_imbalance' if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_CvD `pap_controls' `CvD_imbalance' if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_EvF `pap_controls' `EvF_imbalance', robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_EvF `pap_controls' `EvF_imbalance' if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_EvF `pap_controls' `EvF_imbalance' if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice negative pap imbalance AvB CvD EvF.tex", keep(assign_AvB assign_CvD assign_EvF _cons) ///
	obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.3, Table A.9: Main Analyses With Pre-Analysis Plan Controls Positive Attributes
    eststo: qui reg prejudice_positive_end assign_AvB `pap_controls' `AvB_imbalance', robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvB `pap_controls' `AvB_imbalance' if religion==0, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvB `pap_controls' `AvB_imbalance' if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_CvD `pap_controls' `CvD_imbalance', robust
	tab assign_CvD if e(sample)==1
	eststo: qui reg prejudice_positive_end assign_CvD `pap_controls' `CvD_imbalance' if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_CvD `pap_controls' `CvD_imbalance' if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_EvF `pap_controls' `EvF_imbalance', robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_EvF `pap_controls' `EvF_imbalance' if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_EvF `pap_controls' `EvF_imbalance' if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice positive pap imbalance AvB CvD EvF.tex", keep(assign_AvB assign_CvD assign_EvF _cons) ///
	obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.3, Table A.10: Main Analyses With Pre-Analysis Plan Controls Out-group Evaluation
	eststo: qui reg prejudice_eval_end assign_AvB `pap_controls' `AvB_imbalance', robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvB `pap_controls' `AvB_imbalance' if religion==0, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvB `pap_controls' `AvB_imbalance' if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_CvD `pap_controls' `CvD_imbalance', robust
	tab assign_CvD if e(sample)==1
	eststo: qui reg prejudice_eval_end assign_CvD `pap_controls' `CvD_imbalance' if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_CvD `pap_controls' `CvD_imbalance' if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_EvF `pap_controls' `EvF_imbalance', robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_EvF `pap_controls' `EvF_imbalance' if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_EvF `pap_controls' `EvF_imbalance' if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice eval pap imbalance AvB CvD EvF.tex", keep(assign_AvB assign_CvD assign_EvF _cons) ///
	obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.4 Class-clustered standard errors
* Note the loss of 5 observations never assigned to classes - (1 agreed but late recruit and never assigned, 4 did not agree)
* Section A.8.4.1, Table A.11:  Main Analyses with Standard Errors Clustered by Class Assignment Negative Attributes
    eststo: cgmwildboot prejudice_negative_end assign_CvD, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
	eststo: cgmwildboot prejudice_negative_end assign_CvD if religion==0, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_CvD if religion==1, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_EvF, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_EvF if religion==0, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_EvF if religion==1, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
	esttab using "Prejudice negative CvD EvF wildboot.tex", obslast nodepvars b(2) p label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.4.2, Table A.12:  Main Analyses with Standard Errors Clustered by Class Assignment Positive Attributes
    eststo: cgmwildboot prejudice_positive_end assign_CvD, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
	eststo: cgmwildboot prejudice_positive_end assign_CvD if religion==0, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_CvD if religion==1, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_EvF, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_EvF if religion==0, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_EvF if religion==1, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
	esttab using "Prejudice positive CvD EvF wildboot.tex", obslast nodepvars b(2) p label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.4.3, Table A.13:  Main Analyses with Standard Errors Clustered by Class Assignment Outgroup Eval
    eststo: cgmwildboot prejudice_eval_end assign_CvD, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
	eststo: cgmwildboot prejudice_eval_end assign_CvD if religion==0, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_CvD if religion==1, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_EvF, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_EvF if religion==0, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_EvF if religion==1, cluster(class_id) bootcluster(class_id) null(0) reps(1000) seed(999)
	esttab using "Prejudice other CvD EvF wildboot.tex", obslast nodepvars b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.5 Class-clustered standard errors with PAP controls
* Note the loss of 5 observations never assigned to classes - (1 agreed but late recruit and never assigned, 4 did not agree)
* Set control variables from baseline, as specified in pre-analysis plan, to work properly with cgmwildboot
	local neigh_FE x7_code_base21 x7_code_base22 x7_code_base23 x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 x7_code_base28 x7_code_base29 x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 x7_code_base215 x7_code_base216
	local pap_controls a16_base a19_base b4_base b5_base asset_index_base lived_poverty_index_base c3b_base c3c_base d6_base network_size_base
    * Some imbalance with respect to Hom vs Het classes (CvD), none wrt EvF comparison; d6_base removed from CvD_imbalance since repeats pap controls
 	local CvD_imbalance a1_base a23_base
 	 
* Section A.8.5.1, Table A.14:  Main Analyses with Standard Errors Clustered by Class Assignment Negative Attributes
 	eststo: cgmwildboot prejudice_negative_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE', cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	eststo: cgmwildboot prejudice_negative_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE' if religion==0, cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE' if religion==1, cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_EvF `pap_controls' `neigh_FE', cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_EvF `pap_controls' `neigh_FE' if religion==0, cluster(class_id) bootcluster(class_id) ///
		null(0  . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_negative_end assign_EvF `pap_controls' `neigh_FE' if religion==1, cluster(class_id) bootcluster(class_id) ///
		null(0  . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Prejudice negative pap imbalance CvD EvF wildboot.tex", obslast nodepvars b(2) p label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.5.2, Table A.15:  Main Analyses with Standard Errors Clustered by Class Assignment Positive Attributes
 	eststo: cgmwildboot prejudice_positive_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE', cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	eststo: cgmwildboot prejudice_positive_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE' if religion==0, cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE' if religion==1, cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_EvF `pap_controls' `neigh_FE', cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_EvF `pap_controls' `neigh_FE' if religion==0, cluster(class_id) bootcluster(class_id) ///
		null(0  . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_positive_end assign_EvF `pap_controls' `neigh_FE' if religion==1, cluster(class_id) bootcluster(class_id) ///
		null(0  . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Prejudice positive pap imbalance CvD EvF wildboot.tex", obslast nodepvars b(2) p label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.5.3, Table A.16:  Main Analyses with Standard Errors Clustered by Class Assignment Outgroup Eval
	eststo: cgmwildboot prejudice_eval_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE', cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	eststo: cgmwildboot prejudice_eval_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE' if religion==0, cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_CvD `pap_controls' `CvD_imbalance' `neigh_FE' if religion==1, cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_EvF `pap_controls' `neigh_FE', cluster(class_id) bootcluster(class_id) ///
		null(0 . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_EvF `pap_controls' `neigh_FE' if religion==0, cluster(class_id) bootcluster(class_id) ///
		null(0  . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot prejudice_eval_end assign_EvF `pap_controls' `neigh_FE' if religion==1, cluster(class_id) bootcluster(class_id) ///
		null(0  . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Prejudice eval pap imbalance CvD EvF wildboot.tex", obslast nodepvars b(2) p label star(+ 0.10 * 0.05 ** 0.01) ///
		mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
		"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.6 Main Analyses with Class Assignment Fixed Effects, Table A.17	
    eststo: qui areg prejudice_negative_end assign_EvF, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_negative_end assign_EvF if religion==0, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_negative_end assign_EvF if religion==1, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_positive_end assign_EvF, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_positive_end assign_EvF if religion==0, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_positive_end assign_EvF if religion==1, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_eval_end assign_EvF, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_eval_end assign_EvF if religion==0, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
    eststo: qui areg prejudice_eval_end assign_EvF if religion==1, absorb(class_idnum) robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice negative positive eval EvF class FE.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.7, Table A.18: Main Analyses with Teacher Religion Fixed Effects
* Prejudice tables- teacher religion FE for EvF
    eststo: qui reg prejudice_negative_end assign_EvF teacher_christian, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_EvF teacher_christian if religion==0, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_EvF teacher_christian if religion==1, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_EvF teacher_christian, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_EvF teacher_christian if religion==0, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_EvF teacher_christian if religion==1, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_EvF teacher_christian, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_EvF teacher_christian if religion==0, robust
	tab assign_EvF teacher_christian if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_EvF teacher_christian if religion==1, robust
	tab assign_EvF teacher_christian if e(sample)==1
	esttab using "Prejudice negative positive eval EvF teacher religion FE.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.8.8 Additional Prejudice Measures
* Section A.8.8.2 Additional Prejudice Measures Histograms, Figures A.11–A.14
    hist j4a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Understanding Customs and Ways") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j4a, replace)
    hist j5a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Have Close Friends") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j5a, replace)
    hist j7a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Comfortable Working Alongside") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j7a, replace)
    hist j8a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Feel Anxious Around Out-group") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j8a, replace)
    hist j10a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Would Enjoy Visiting Out-group Homes") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j10a, replace)
    hist j11a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Share Similar Concerns") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j11a, replace)
    hist j12a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Want Similar Things") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j12a, replace)
    hist j13a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Understand Out-group Desire for Religious Education") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j13a, replace)
    hist j14j15a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("See Good Faith in Out-group Prayer") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j14j15a, replace)
    hist j6a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Imagine Having Out-group Friends") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j6a, replace)
    hist j9a_end, scheme(s2mono) percent by(religion) ///
    	ytitle("Percent of respondents") xtitle("Rewarding to Know People of Other Faiths") ///
    	ylabel(0(10)70) xlabel(1(1)4) name(j9a, replace)

* Figure A.11
    graph combine j4a j5a, saving(prejudiceknowledge, replace)

* Figure A.12
    graph combine j7a j8a j10a, saving(prejudiceanxiety, replace)

* Figure A.13
    graph combine j11a j12a j13a j14j15a, saving(prejudiceempathy, replace)

* Figure A.14
    graph combine j6a j9a, saving(prejudicefriendship, replace)


***************************************************************************
* Section A.8.8.3, Tables A.20-A.30: Additional Prejudice Measures Analyses
***************************************************************************

* Table A.20
	eststo: qui reg j4a_end assign_AvB, robust
    eststo: qui reg j4a_end assign_AvB if religion==0, robust
    eststo: qui reg j4a_end assign_AvB if religion==1, robust
    eststo: qui reg j4a_end assign_CvD, robust
	eststo: qui reg j4a_end assign_CvD if religion==0, robust
    eststo: qui reg j4a_end assign_CvD if religion==1, robust
    eststo: qui reg j4a_end assign_EvF, robust
    eststo: qui reg j4a_end assign_EvF if religion==0, robust
    eststo: qui reg j4a_end assign_EvF if religion==1, robust
	esttab using "Prejudice understand AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.21
	eststo: qui reg j5a_end assign_AvB, robust
    eststo: qui reg j5a_end assign_AvB if religion==0, robust
    eststo: qui reg j5a_end assign_AvB if religion==1, robust
    eststo: qui reg j5a_end assign_CvD, robust
	eststo: qui reg j5a_end assign_CvD if religion==0, robust
    eststo: qui reg j5a_end assign_CvD if religion==1, robust
    eststo: qui reg j5a_end assign_EvF, robust
    eststo: qui reg j5a_end assign_EvF if religion==0, robust
    eststo: qui reg j5a_end assign_EvF if religion==1, robust
	esttab using "Prejudice have friends AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.22
	eststo: qui reg j8a_end assign_AvB, robust
    eststo: qui reg j8a_end assign_AvB if religion==0, robust
    eststo: qui reg j8a_end assign_AvB if religion==1, robust
    eststo: qui reg j8a_end assign_CvD, robust
	eststo: qui reg j8a_end assign_CvD if religion==0, robust
    eststo: qui reg j8a_end assign_CvD if religion==1, robust
    eststo: qui reg j8a_end assign_EvF, robust
    eststo: qui reg j8a_end assign_EvF if religion==0, robust
    eststo: qui reg j8a_end assign_EvF if religion==1, robust
	esttab using "Prejudice anxious AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.23
	eststo: qui reg j7a_end assign_AvB, robust
    eststo: qui reg j7a_end assign_AvB if religion==0, robust
    eststo: qui reg j7a_end assign_AvB if religion==1, robust
    eststo: qui reg j7a_end assign_CvD, robust
	eststo: qui reg j7a_end assign_CvD if religion==0, robust
    eststo: qui reg j7a_end assign_CvD if religion==1, robust
    eststo: qui reg j7a_end assign_EvF, robust
    eststo: qui reg j7a_end assign_EvF if religion==0, robust
    eststo: qui reg j7a_end assign_EvF if religion==1, robust
	esttab using "Prejudice working AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.24
	eststo: qui reg j10a_end assign_AvB, robust
    eststo: qui reg j10a_end assign_AvB if religion==0, robust
    eststo: qui reg j10a_end assign_AvB if religion==1, robust
    eststo: qui reg j10a_end assign_CvD, robust
	eststo: qui reg j10a_end assign_CvD if religion==0, robust
    eststo: qui reg j10a_end assign_CvD if religion==1, robust
    eststo: qui reg j10a_end assign_EvF, robust
    eststo: qui reg j10a_end assign_EvF if religion==0, robust
    eststo: qui reg j10a_end assign_EvF if religion==1, robust
	esttab using "Prejudice visiting AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.25
	eststo: qui reg j11a_end assign_AvB, robust
    eststo: qui reg j11a_end assign_AvB if religion==0, robust
    eststo: qui reg j11a_end assign_AvB if religion==1, robust
    eststo: qui reg j11a_end assign_CvD, robust
	eststo: qui reg j11a_end assign_CvD if religion==0, robust
    eststo: qui reg j11a_end assign_CvD if religion==1, robust
    eststo: qui reg j11a_end assign_EvF, robust
    eststo: qui reg j11a_end assign_EvF if religion==0, robust
    eststo: qui reg j11a_end assign_EvF if religion==1, robust
	esttab using "Prejudice similar worries AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.26
	eststo: qui reg j12a_end assign_AvB, robust
    eststo: qui reg j12a_end assign_AvB if religion==0, robust
    eststo: qui reg j12a_end assign_AvB if religion==1, robust
    eststo: qui reg j12a_end assign_CvD, robust
	eststo: qui reg j12a_end assign_CvD if religion==0, robust
    eststo: qui reg j12a_end assign_CvD if religion==1, robust
    eststo: qui reg j12a_end assign_EvF, robust
    eststo: qui reg j12a_end assign_EvF if religion==0, robust
    eststo: qui reg j12a_end assign_EvF if religion==1, robust
	esttab using "Prejudice similar desires AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Table A.27
	eststo: qui reg j13a_end assign_AvB, robust
    eststo: qui reg j13a_end assign_AvB if religion==0, robust
    eststo: qui reg j13a_end assign_AvB if religion==1, robust
    eststo: qui reg j13a_end assign_CvD, robust
	eststo: qui reg j13a_end assign_CvD if religion==0, robust
    eststo: qui reg j13a_end assign_CvD if religion==1, robust
    eststo: qui reg j13a_end assign_EvF, robust
    eststo: qui reg j13a_end assign_EvF if religion==0, robust
    eststo: qui reg j13a_end assign_EvF if religion==1, robust
	esttab using "Prejudice religious educ AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Table A.28
	eststo: qui reg j14j15a_end assign_AvB, robust
    eststo: qui reg j14j15a_end assign_AvB if religion==0, robust
    eststo: qui reg j14j15a_end assign_AvB if religion==1, robust
    eststo: qui reg j14j15a_end assign_CvD, robust
	eststo: qui reg j14j15a_end assign_CvD if religion==0, robust
    eststo: qui reg j14j15a_end assign_CvD if religion==1, robust
    eststo: qui reg j14j15a_end assign_EvF, robust
    eststo: qui reg j14j15a_end assign_EvF if religion==0, robust
    eststo: qui reg j14j15a_end assign_EvF if religion==1, robust
	esttab using "Prejudice good faith both groups AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.29
	eststo: qui reg j6a_end assign_AvB, robust
    eststo: qui reg j6a_end assign_AvB if religion==0, robust
    eststo: qui reg j6a_end assign_AvB if religion==1, robust
    eststo: qui reg j6a_end assign_CvD, robust
	eststo: qui reg j6a_end assign_CvD if religion==0, robust
    eststo: qui reg j6a_end assign_CvD if religion==1, robust
    eststo: qui reg j6a_end assign_EvF, robust
    eststo: qui reg j6a_end assign_EvF if religion==0, robust
    eststo: qui reg j6a_end assign_EvF if religion==1, robust
	esttab using "Prejudice imagine friends AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.30
	eststo: qui reg j9a_end assign_AvB, robust
    eststo: qui reg j9a_end assign_AvB if religion==0, robust
    eststo: qui reg j9a_end assign_AvB if religion==1, robust
    eststo: qui reg j9a_end assign_CvD, robust
	eststo: qui reg j9a_end assign_CvD if religion==0, robust
    eststo: qui reg j9a_end assign_CvD if religion==1, robust
    eststo: qui reg j9a_end assign_EvF, robust
    eststo: qui reg j9a_end assign_EvF if religion==0, robust
    eststo: qui reg j9a_end assign_EvF if religion==1, robust
	esttab using "Prejudice rewarding AvB CvD EvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


*****************************************************************************
* Section A.11 ‘Pure control:’ UYVT Treatment Groups vs. No Course Assignment
* Disaggregating program effects
*****************************************************************************

* Table A.53 Prejudice Index, Negative Attributes
	eststo: qui reg prejudice_negative_end assign_AvC, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvC if religion==0, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvC if religion==1, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvD, robust
	tab assign_AvD if e(sample)==1
	eststo: qui reg prejudice_negative_end assign_AvD if religion==0, robust
	tab assign_AvD if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvD if religion==1, robust
	tab assign_AvD if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvE, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvE if religion==0, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvE if religion==1, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvF, robust
	tab assign_AvF if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvF if religion==0, robust
	tab assign_AvF if e(sample)==1
    eststo: qui reg prejudice_negative_end assign_AvF if religion==1, robust
	tab assign_AvF if e(sample)==1
	esttab using "Prejudice negative AvC AvD AvE AvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.55 Prejudice Index, Positive Attributes
    eststo: qui reg prejudice_positive_end assign_AvC, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvC if religion==0, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvC if religion==1, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvD, robust
	tab assign_AvD if e(sample)==1
	eststo: qui reg prejudice_positive_end assign_AvD if religion==0, robust
	tab assign_AvD if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvD if religion==1, robust
	tab assign_AvD if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvE, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvE if religion==0, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvE if religion==1, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvF, robust
	tab assign_AvF if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvF if religion==0, robust
	tab assign_AvF if e(sample)==1
    eststo: qui reg prejudice_positive_end assign_AvF if religion==1, robust
	tab assign_AvF if e(sample)==1
	esttab using "Prejudice positive AvC AvD AvE AvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.56 Prejudice Index, Outgroup evaluation
	eststo: qui reg prejudice_eval_end assign_AvC, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvC if religion==0, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvC if religion==1, robust
	tab assign_AvC if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvD, robust
	tab assign_AvD if e(sample)==1
	eststo: qui reg prejudice_eval_end assign_AvD if religion==0, robust
	tab assign_AvD if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvD if religion==1, robust
	tab assign_AvD if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvE, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvE if religion==0, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvE if religion==1, robust
	tab assign_AvE if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvF, robust
	tab assign_AvF if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvF if religion==0, robust
	tab assign_AvF if e(sample)==1
    eststo: qui reg prejudice_eval_end assign_AvF if religion==1, robust
	tab assign_AvF if e(sample)==1
	esttab using "Prejudice eval AvC AvD AvE AvF.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) nonotes ///
	addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


************************************************************
* Section A.13 Heterogeneous Effects
* Heterogeneous effects loop for 15 covariates across 3 prejudice indices, Tables A.58-A.102
************************************************************

* Regression loop over 3 prejudice indices, het effects variables & 3 treatment comparisons
  foreach i of varlist prejudice_negative_end prejudice_positive_end prejudice_eval_end {
    foreach k of varlist b4_base_simple b5_base_simple f1a_base het_neighborhood_base het_neighborhood_noHB_base d1_simple_base d1_simple2_base d2_simple_base d3_simple_base d4_base_simple invite_index_simple_base e2_hood_fighting_2011_base e3_bldgs_damaged_2011_base e4_know_harmed_2011_base e5_affected_2011_base e5_serious_2011_base under21{
	    
	  foreach j of varlist assign_AvB assign_CvD assign_EvF {
         eststo: qui reg `i' c.`j'##c.`k', robust
         eststo: qui reg `i' c.`j'##c.`k' if religion==0, robust
         eststo: qui reg `i' c.`j'##c.`k' if religion==1, robust
	     }
	     esttab using "Prejudice `i' AvB CvD EvF het eff `k'.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
         est clear
      }
 }


************************************************************	
* Analysis with long data
************************************************************

* Load long data
   use "Data_APSR_long.dta", clear
   set more off


*************************************************************
* Descriptive Statistics (dictator, destruction game play)
*************************************************************

* Section A.5, Figure A.8: Dictator Game Responses
    hist h1_end, scheme(s2mono) by(religion) percent bin(11) ///
    	ytitle("Percent of respondents") xtitle("Number of N10 bills given to partner") ///
    	ylabel(0(5)30) xlabel(0(1)10) saving(dictator, replace)
	
* Section A.5, Figure A.9: Destruction game responses
    hist h2_end, scheme(s2mono) by(religion) percent bin(3) ///
    	ytitle("Percent of respondents") xtitle("Number of partner's N50 bills destroyed") ///
    	ylabel(0(5)50) xlabel(0(1)2) saving(destruction, replace)


************************************************************
* Section A.9.1 Robustness: Discrimination, Dictator Game
************************************************************

* Section A9.1.1, Table A.31: Dictator Game Treatment Group Means
    * Full sample
    ttest h1_end if assign_AvB==0, by(otherh1)
    ttest h1_end if assign_AvB==1, by(otherh1)
    ttest h1_end if assign_CvD==0, by(otherh1)
    ttest h1_end if assign_CvD==1, by(otherh1)
    ttest h1_end if assign_EvF==0, by(otherh1)
    ttest h1_end if assign_EvF==1, by(otherh1)

    * Muslims
    ttest h1_end if assign_AvB==0 & religion==0, by(otherh1)
    ttest h1_end if assign_AvB==1 & religion==0, by(otherh1)
    ttest h1_end if assign_CvD==0 & religion==0, by(otherh1)
    ttest h1_end if assign_CvD==1 & religion==0, by(otherh1)
    ttest h1_end if assign_EvF==0 & religion==0, by(otherh1)
    ttest h1_end if assign_EvF==1 & religion==0, by(otherh1)

    * Christians
    ttest h1_end if assign_AvB==0 & religion==1, by(otherh1)
    ttest h1_end if assign_AvB==1 & religion==1, by(otherh1)
    ttest h1_end if assign_CvD==0 & religion==1, by(otherh1)
    ttest h1_end if assign_CvD==1 & religion==1, by(otherh1)
    ttest h1_end if assign_EvF==0 & religion==1, by(otherh1)
    ttest h1_end if assign_EvF==1 & religion==1, by(otherh1)

* Section A.9.1.2, Table A.32: Main Analyses with Standard Errors Clustered by Class Assignment and Respondent
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210, cluster(primary_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==1, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210, cluster(primary_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==1, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Dictator CvD EvF wildboot.tex", obslast wrap nodepvars order(assign_CvD CvD_otherh1 assign_EvF EvF_otherh1 otherh1) ///
		drop(row_id2*) b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
		"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
		"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


*********************************************************************
* Section A.9.1.3 Analyses Excluding Rounds of Play with Classmates
*********************************************************************

* A.9.1.3.a, Table A.33: Main Analyses Excluding Rounds of Play with Classmates
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==0 & h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==1 & h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==0 & h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==1 & h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==0 & h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==1 & h1_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Dictator AvB CvD EvF no classmates.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 assign_CvD ///
	CvD_otherh1 assign_EvF EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" ///
	"\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* A.10.1.3.b, Table A.34: Analyses Excluding Rounds of Play with Classmates, with Standard Errors Clustered by Class Assignment and Respondent
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if h1_sameclass_end==0, cluster(primary_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==0 & h1_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==1 & h1_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if h1_sameclass_end==0, cluster(primary_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==0 & h1_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==1 & h1_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Dictator CvD EvF no classmates wildboot.tex", obslast wrap nodepvars order(assign_CvD B7_otherh1 assign_EvF ///
	EvF_otherh1 otherh1) drop(row_id2*) b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" ///
	"\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* A.9.1.3.c, Table A.35: Treatment Group Means Excluding Rounds of Play with Classmates
    * Full sample
    ttest h1_end if assign_AvB==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_AvB==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_CvD==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_CvD==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_EvF==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_EvF==1 & h1_sameclass_end==0, by(otherh1)
    
    * Muslims
    ttest h1_end if assign_AvB==0 & religion==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_AvB==1 & religion==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_CvD==0 & religion==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_CvD==1 & religion==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_EvF==0 & religion==0 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_EvF==1 & religion==0 & h1_sameclass_end==0, by(otherh1)
    
    * Christians
    ttest h1_end if assign_AvB==0 & religion==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_AvB==1 & religion==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_CvD==0 & religion==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_CvD==1 & religion==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_EvF==0 & religion==1 & h1_sameclass_end==0, by(otherh1)
    ttest h1_end if assign_EvF==1 & religion==1 & h1_sameclass_end==0, by(otherh1)


*********************************************************************
* Section A.9.1.4 Main Analyses with Pre-Analysis Plan Controls
*********************************************************************

* Section A.9.1.4.a, Table A.36: Main Analyses with Pre-Analysis Plan Controls
* Set control variables from baseline, as specified in pre-analysis plan
    local pap_controls a16_base a19_base b4_base b5_base asset_index_base lived_poverty_index_base c3b_base c3c_base d6_base network_size_base i.x7_code_base
    
    * Some imbalance with respect to UYVT vs control (A1), Hom vs Het classes (B7), none wrt D10 comparison
    local AvB_imbalance f1_base i.x7_code_base
	local CvD_imbalance a1_base a23_base d6_base i.x7_code_base
	local EvF_imbalance i.x7_code_base

    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 `pap_controls' `AvB_imbalance', absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 `pap_controls' `AvB_imbalance' if religion==0, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 `pap_controls' `AvB_imbalance' if religion==1, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 `pap_controls' `CvD_imbalance', absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 `pap_controls' `CvD_imbalance' if religion==0, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 `pap_controls' `CvD_imbalance' if religion==1, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 `pap_controls' `EvF_imbalance', absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 `pap_controls' `EvF_imbalance' if religion==0, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 `pap_controls' `EvF_imbalance' if religion==1, absorb(row_id) cluster(primary_id)
	esttab using "Dictator AvB CvD EvF pap imbalance.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 assign_CvD CvD_otherh1 ///
	assign_EvF EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" ///
	"\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Section A.9.1.4.b, Table A.37: Main Analyses with Pre-Analysis Plan Controls and Standard Errors Clustered by Class Assignment and Respondent
* Set control variables from baseline, as specified in pre-analysis plan
 	local neigh_FE x7_code_base21 x7_code_base22 x7_code_base23 x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 x7_code_base28 ///
		x7_code_base29 x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 x7_code_base215 x7_code_base216
	local pap_controls a16_base a19_base b4_base b5_base asset_index_base lived_poverty_index_base c3b_base c3c_base d6_base network_size_base
    * Some imbalance with respect to  Hom vs Het classes (B7), none wrt D10 comparison
 	local CvD_imbalance a1_base a23_base

    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 `pap_controls' `CvD_imbalance' `neigh_FE' row_id21 row_id22 row_id23 row_id24 row_id25 ///
		row_id26 row_id27 row_id28 row_id29 row_id210, cluster(primary_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 `pap_controls' `CvD_imbalance' `neigh_FE' row_id21 row_id22 row_id23 row_id24 row_id25 ///
		row_id26 row_id27 row_id28 row_id29 row_id210 if religion==0, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_CvD otherh1 CvD_otherh1 `pap_controls' `CvD_imbalance' `neigh_FE' row_id21 row_id22 row_id23 row_id24 row_id25 ///
		row_id26 row_id27 row_id28 row_id29 row_id210 if religion==1, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 `pap_controls' `neigh_FE'  row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210, cluster(primary_id) bootcluster(class_id) null(0 0 0  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) ///
		reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 `pap_controls' `neigh_FE' row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==0, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h1_end assign_EvF otherh1 EvF_otherh1 `pap_controls' `neigh_FE'  row_id21 row_id22 row_id23 row_id24 row_id25 row_id26 row_id27 ///
		row_id28 row_id29 row_id210 if religion==1, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Dictator CvD EvF wildboot pap imbalance.tex", obslast wrap nodepvars order(assign_CvD CvD_otherh1 assign_EvF EvF_otherh1 otherh1) ///
	drop(row_id2*) b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" ///
	"\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") ///
	nonotes addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.9.1.5, Table A.38: Main Analyses with Treatment and Religion Interacted
    eststo: qui areg h1_end c.assign_AvB##c.otherh1##c.religion, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end c.assign_CvD##c.otherh1##c.religion, absorb(row_id) cluster(primary_id)
    eststo: qui areg h1_end c.assign_EvF##c.otherh1##c.religion, absorb(row_id) cluster(primary_id)
	esttab using "Dictator AvB CvD EvF religion interacted.tex", obslast wrap nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
		mtitles("All" "\shortstack{All\\ in UYVT}" "\shortstack{All in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p $<$ 0.01}}")replace
	est clear

* Section A.9.1.6, Table A.39: Main Analyses with Class Assignment and Teacher Religion Fixed Effects
   eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 i.class_idnum, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 i.class_idnum if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 i.class_idnum if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 teacher_christian, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 teacher_christian if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 teacher_christian if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Dictator EvF class and teacher religion FE.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 ///
		assign_CvD CvD_otherh1 assign_EvF EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
		mtitles("\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
		"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
		"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


***************************************************************
* Section A.10.2 Robustness: Discrimination, Destruction Game
***************************************************************

* Section A9.2.1, Table A.40: Destruction Game Treatment Group Means
    * Full sample
    ttest h2_end if assign_AvB==0, by(otherh2)
    ttest h2_end if assign_AvB==1, by(otherh2)
    ttest h2_end if assign_CvD==0, by(otherh2)
    ttest h2_end if assign_CvD==1, by(otherh2)
    ttest h2_end if assign_EvF==0, by(otherh2)
    ttest h2_end if assign_EvF==1, by(otherh2)
    
    * Muslims
    ttest h2_end if assign_AvB==0 & religion==0, by(otherh2)
    ttest h2_end if assign_AvB==1 & religion==0, by(otherh2)
    ttest h2_end if assign_CvD==0 & religion==0, by(otherh2)
    ttest h2_end if assign_CvD==1 & religion==0, by(otherh2)
    ttest h2_end if assign_EvF==0 & religion==0, by(otherh2)
    ttest h2_end if assign_EvF==1 & religion==0, by(otherh2)
    
    * Christians
    ttest h2_end if assign_AvB==0 & religion==1, by(otherh2)
    ttest h2_end if assign_AvB==1 & religion==1, by(otherh2)
    ttest h2_end if assign_CvD==0 & religion==1, by(otherh2)
    ttest h2_end if assign_CvD==1 & religion==1, by(otherh2)
    ttest h2_end if assign_EvF==0 & religion==1, by(otherh2)
    ttest h2_end if assign_EvF==1 & religion==1, by(otherh2)

* Section A.9.2.2, Table A.41: Main Analyses with Standard Errors Clustered by Class Assignment and Respondent
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220, cluster(primary_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==1, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==1, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Destruction CvD EvF wildboot.tex", obslast wrap nodepvars order(assign_CvD CvD_otherh2 assign_EvF EvF_otherh2 otherh2) ///
		drop(row_id2*) b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
		"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" ///
		"\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


*********************************************************************
*Section A.9.2.3 Analyses Excluding Rounds of Play with Classmates
*********************************************************************

* A.9.2.3.a, Table A.42: Main Analyses Excluding Rounds of Play with Classmates
* Destruction game excluding classmates
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==0 & h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==1 & h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==0 & h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==1 & h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==0 & h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==1 & h2_sameclass_end==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Destruction AvB CvD EvF no classmates.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh2 assign_CvD ///
		CvD_otherh2 assign_EvF EvF_otherh2 otherh2) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" ///
		"\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
		"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* A.9.2.3.b, Table A.43: Analyses Excluding Rounds of Play with Classmates, with Standard Errors Clustered by Class Assignment and Respondent
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if h2_sameclass_end==0, cluster(primary_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==0 & h2_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==1 & h2_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if h2_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==0 & h2_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 row_id211 row_id212 row_id213 row_id214 row_id215 row_id216 row_id217 ///
		row_id218 row_id219 row_id220 if religion==1 & h2_sameclass_end==0, cluster(primary_id class_id) bootcluster(class_id) null(0 0 0 . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Destruction CvD EvF no classmates wildboot.tex", obslast wrap nodepvars order(assign_CvD CvD_otherh2 assign_EvF EvF_otherh2 otherh2) ///
		drop(row_id2*) b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" ///
		"\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* A.9.2.3.c, Table A.44: Treatment Group Means Excluding Rounds of Play with Classmates
    * Full sample
    ttest h2_end if assign_AvB==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_AvB==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_CvD==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_CvD==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_EvF==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_EvF==1 & h2_sameclass_end==0, by(otherh2)
    
    * Muslims
    ttest h2_end if assign_AvB==0 & religion==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_AvB==1 & religion==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_CvD==0 & religion==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_CvD==1 & religion==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_EvF==0 & religion==0 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_EvF==1 & religion==0 & h2_sameclass_end==0, by(otherh2)
    
    * Christians
    ttest h2_end if assign_AvB==0 & religion==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_AvB==1 & religion==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_CvD==0 & religion==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_CvD==1 & religion==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_EvF==0 & religion==1 & h2_sameclass_end==0, by(otherh2)
    ttest h2_end if assign_EvF==1 & religion==1 & h2_sameclass_end==0, by(otherh2)


*********************************************************************
* Section A.9.2.4 Main Analyses with Pre-Analysis Plan Controls
*********************************************************************

* Section A.9.2.4.a, Table A.45: Main Analyses with Pre-Analysis Plan Controls
* Set control variables from baseline, as specified in pre-analysis plan
    local pap_controls a16_base a19_base b4_base b5_base asset_index_base lived_poverty_index_base c3b_base c3c_base d6_base network_size_base i.x7_code_base
    
    * Some imbalance with respect to UYVT vs control (A1), Hom vs Het classes (B7), none wrt D10 comparison
    local AvB_imbalance f1_base i.x7_code_base
	local CvD_imbalance a1_base a23_base d6_base i.x7_code_base
	local EvF_imbalance i.x7_code_base

    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 `pap_controls' `AvB_imbalance', absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 `pap_controls' `AvB_imbalance' if religion==0, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 `pap_controls' `AvB_imbalance' if religion==1, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 `pap_controls' `CvD_imbalance', absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 `pap_controls' `CvD_imbalance' if religion==0, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 `pap_controls' `CvD_imbalance' if religion==1, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 `pap_controls' `EvF_imbalance', absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 `pap_controls' `EvF_imbalance' if religion==0, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 `pap_controls' `EvF_imbalance' if religion==1, absorb(row_id) cluster(primary_id)
	esttab using "Destruction AvB CvD EvF pap imbalance.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh2 assign_CvD CvD_otherh2 ///
	assign_EvF EvF_otherh2 otherh2) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" ///
	"\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Section A.9.2.4.b, Table A.46: Main Analyses with Pre-Analysis Plan Controls and Standard Errors Clustered by Class Assignment and Respondent
* Set control variables from baseline, as specified in pre-analysis plan
 	local neigh_FE x7_code_base21 x7_code_base22 x7_code_base23 x7_code_base24 x7_code_base25 x7_code_base26 x7_code_base27 x7_code_base28 ///
		x7_code_base29 x7_code_base211 x7_code_base212 x7_code_base213 x7_code_base214 x7_code_base215 x7_code_base216
	local pap_controls a16_base a19_base b4_base b5_base asset_index_base lived_poverty_index_base c3b_base c3c_base d6_base network_size_base
    * Some imbalance with respect to  Hom vs Het classes (B7), none wrt D10 comparison
 	local CvD_imbalance a1_base a23_base

    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 `pap_controls' `CvD_imbalance' `neigh_FE' row_id211 row_id212 row_id213 row_id214 ///
		row_id215 row_id216 row_id217 row_id218 row_id219 row_id220, cluster(primary_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 `pap_controls' `CvD_imbalance' `neigh_FE' row_id211 row_id212 row_id213 row_id214 ///
		row_id215 row_id216 row_id217 row_id218 row_id219 row_id220 if religion==0, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_CvD otherh2 CvD_otherh2 `pap_controls' `CvD_imbalance' `neigh_FE' row_id211 row_id212 row_id213 row_id214 ///
		row_id215 row_id216 row_id217 row_id218 row_id219 row_id220 if religion==1, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 `pap_controls' `neigh_FE'  row_id211 row_id212 row_id213 row_id214 row_id215 ///
		row_id216 row_id217 row_id218 row_id219 row_id220, cluster(primary_id) bootcluster(class_id) ///
		null(0 0 0  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 `pap_controls' `neigh_FE' row_id211 row_id212 row_id213 row_id214 row_id215 ///
		row_id216 row_id217 row_id218 row_id219 row_id220 if religion==0, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
    eststo: cgmwildboot h2_end assign_EvF otherh2 EvF_otherh2 `pap_controls' `neigh_FE'  row_id211 row_id212 row_id213 row_id214 row_id215 ///
		row_id216 row_id217 row_id218 row_id219 row_id220 if religion==1, cluster(primary_id class_id) bootcluster(class_id) ///
		null(0 0 0 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .) reps(1000) seed(999)
	esttab using "Destruction CvD EvF wildboot pap imbalance.tex", obslast wrap nodepvars order(assign_CvD CvD_otherh2 assign_EvF EvF_otherh2 otherh2) ///
	drop(row_id2*) b(2) p label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" ///
	"\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Wild bootstrapped standard errors clustered by class assignment (implemented by `cgmwildboot'). p-values in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.9.2.5, Table A.47: Main Analyses with Treatment and Religion Interacted
    eststo: qui areg h2_end c.assign_AvB##c.otherh2##c.religion, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end c.assign_CvD##c.otherh2##c.religion, absorb(row_id) cluster(primary_id)
    eststo: qui areg h2_end c.assign_EvF##c.otherh2##c.religion, absorb(row_id) cluster(primary_id)
	esttab using "Destruction AvB CvD EvF religion interacted.tex", obslast wrap nodepvars se label star(+ 0.10 * 0.05 ** 0.01) ///
		mtitles("All" "\shortstack{All\\ in UYVT}" "\shortstack{All in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p $<$ 0.01}}")replace
	est clear

* Section A.9.2.6, Table A.48: Main Analyses with Class Assignment and Teacher Religion Fixed Effects
	eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 i.class_idnum, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 i.class_idnum if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 i.class_idnum if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 teacher_christian, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 teacher_christian if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 teacher_christian if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Destruction EvF class and teacher religion FE.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 ///
		assign_CvD CvD_otherh1 assign_EvF EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
		mtitles("\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
		"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}" ///
		"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
		addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


*******************************************************************************************
* Section A.10 Robustness: Round-of-Play Effects in Dictator and Destruction Games
*******************************************************************************************

* Section A.10.1, Table A.49  Main Analyses Excluding First Round of Play	
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==0 & row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==1 & row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==0 & row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==1 & row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==0 & row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==1 & row_id!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Dictator AvB CvD EvF no first round.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 assign_CvD CvD_otherh1 assign_EvF EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Section A.10.1, Table A.50  Main Analyses Excluding First Round of Play		
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==0 & row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==1 & row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==0 & row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==1 & row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==0 & row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==1 & row_id!=11, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Destruction AvB CvD EvF no first round.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh2 assign_CvD CvD_otherh2 assign_EvF EvF_otherh2 otherh2) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Section A.10.2, Table A.51  Main Analyses Excl. Respondents with Classmate Prime in the First Round of Play		
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==0 & h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==1 & h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==0 & h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==1 & h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==0 & h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==1 & h1_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Dictator AvB CvD EvF excl if first round classmate.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 assign_CvD CvD_otherh1 assign_EvF EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Section A.10.2, Table A.52  Main Analyses Excl. Respondents with Classmate Prime in the First Round of Play			
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==0 & h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==1 & h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==0 & h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==1 & h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==0 & h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: qui areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==1 & h2_firstround_sameclass!=1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Destruction AvB CvD EvF excl if first round classmate.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh2 assign_CvD CvD_otherh2 assign_EvF EvF_otherh2 otherh2) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


*****************************************************************************
* Section A.11 ‘Pure control:’ UYVT Treatment Groups vs. No Course Assignment
* Disaggregating program effects
*****************************************************************************

* Table A.56 Dictator game
    eststo: qui areg h1_end assign_AvC otherh1 AvC_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_AvC if e(sample)==1
    eststo: qui areg h1_end assign_AvC otherh1 AvC_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvC if e(sample)==1
    eststo: qui areg h1_end assign_AvC otherh1 AvC_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvC if e(sample)==1
    eststo: qui areg h1_end assign_AvD otherh1 AvD_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_AvD if e(sample)==1
    eststo: qui areg h1_end assign_AvD otherh1 AvD_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvD if e(sample)==1
    eststo: qui areg h1_end assign_AvD otherh1 AvD_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvD if e(sample)==1
    eststo: qui areg h1_end assign_AvE otherh1 AvE_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_AvE if e(sample)==1
    eststo: qui areg h1_end assign_AvE otherh1 AvE_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvE if e(sample)==1
    eststo: qui areg h1_end assign_AvE otherh1 AvE_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvE if e(sample)==1
    eststo: qui areg h1_end assign_AvF otherh1 AvF_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_AvF if e(sample)==1
    eststo: qui areg h1_end assign_AvF otherh1 AvF_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvF if e(sample)==1
    eststo: qui areg h1_end assign_AvF otherh1 AvF_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvF if e(sample)==1
	esttab using "Dictator AvC AvD AvE AvF.tex", obslast wrap nodepvars order(assign_AvC AvC_otherh1 assign_AvD AvD_otherh1 ///
	assign_AvE AvE_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" ///
	"\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Table A.57 Destruction game
    eststo: qui areg h2_end assign_AvC otherh2 AvC_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_AvC if e(sample)==1
    eststo: qui areg h2_end assign_AvC otherh2 AvC_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvC if e(sample)==1
    eststo: qui areg h2_end assign_AvC otherh2 AvC_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvC if e(sample)==1
    eststo: qui areg h2_end assign_AvD otherh2 AvD_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_AvD if e(sample)==1
    eststo: qui areg h2_end assign_AvD otherh2 AvD_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvD if e(sample)==1
    eststo: qui areg h2_end assign_AvD otherh2 AvD_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvD if e(sample)==1
    eststo: qui areg h2_end assign_AvE otherh2 AvE_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_AvE if e(sample)==1
    eststo: qui areg h2_end assign_AvE otherh2 AvE_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvE if e(sample)==1
    eststo: qui areg h2_end assign_AvE otherh2 AvE_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvE if e(sample)==1
    eststo: qui areg h2_end assign_AvF otherh2 AvF_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_AvF if e(sample)==1
    eststo: qui areg h2_end assign_AvF otherh2 AvF_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvF if e(sample)==1
    eststo: qui areg h2_end assign_AvF otherh2 AvF_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvF if e(sample)==1
	esttab using "Destruction AvC AvD AvE.tex", obslast wrap nodepvars order(assign_AvC AvC_otherh2 assign_AvD AvD_otherh2 ///
	assign_AvE AvE_otherh2 otherh2) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" ///
	"\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes ///
	addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear


************************************************************************************************************************
* Section A.13 Heterogeneous Effects
* Heterogeneous effects loop for 15 covariates across dictator and destruction games, Tables A.103-A.132
************************************************************************************************************************

* Regression loop over 3 prejudice indices, het effects variables & 3 treatment comparisons
     foreach k of varlist b4_base_simple b5_base_simple f1a_base het_neighborhood_base het_neighborhood_noHB_base d1_simple_base d1_simple2_base d2_simple_base d3_simple_base d4_base_simple invite_index_simple_base e2_hood_fighting_2011_base e3_bldgs_damaged_2011_base e4_know_harmed_2011_base e5_affected_2011_base e5_serious_2011_base under21{
		foreach j of varlist assign_AvB assign_CvD assign_EvF {
	     eststo: qui areg h1_end c.`j'##c.otherh1##c.`k', absorb(row_id) cluster(primary_id)
		 eststo: qui areg h1_end c.`j'##c.otherh1##c.`k' if religion==0, absorb(row_id) cluster(primary_id)
         eststo: qui areg h1_end c.`j'##c.otherh1##c.`k' if religion==1, absorb(row_id) cluster(primary_id)
			}
	     esttab using "Dictator AvB CvD EvF het eff `k'.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
         est clear
 		foreach j of varlist assign_AvB assign_CvD assign_EvF {
	     eststo: qui areg h2_end c.`j'##c.otherh2##c.`k', absorb(row_id) cluster(primary_id)
		 eststo: qui areg h2_end c.`j'##c.otherh2##c.`k' if religion==0, absorb(row_id) cluster(primary_id)
         eststo: qui areg h2_end c.`j'##c.otherh2##c.`k' if religion==1, absorb(row_id) cluster(primary_id)
			}
	     esttab using "Destruction AvB CvD EvF het eff `k'.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes("\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace 
		 est clear
		 }

