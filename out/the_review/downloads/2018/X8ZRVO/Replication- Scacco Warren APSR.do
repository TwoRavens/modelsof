* Alexandra Scacco and Shana Warren
* Replication code for "Can Social Contact Reduce Prejudice and Discrimination? Evidence from a Field Experiment in Nigeria"

* Set directory
    *cd ""
    set more off

* Install package estout, if not already available
    ssc install estout

* Load wide data
    use "Data_APSR", clear
	
* Figure 2: UYVT Student Attendance 
    hist session_attend_all, scheme(s1mono) freq discrete ytitle("UYVT-assigned students" " ") xtitle(" " "UYVT sessions attended") ylabel(0(10)90) xlabel(0(2)29) xscale(range(0(1)30))
    graph export "UYVTattendance.pdf", as(pdf) replace

* Figure 3: UYVT attendance over time
    foreach var of varlist session_attend1-session_attend29 {
      egen daily`var' = sum(`var')
    }
    preserve
        collapse dailysession*
        gen i=1
        reshape long dailysession_attend, i(i) j(session)
        scatter dailysession_attend session, scheme(s1mono) ytitle("Student attendance" " ") xtitle(" " "UYVT course session") ylabel(0(50)550, labsize(2.8)) xlabel(1(2)29) xscale(range(0(1)30))
        graph export "Dailyattendanceovertime.pdf", as(pdf) replace
    restore

* Table 2: Prejudice Index, Negative Attributes
	eststo: reg prejudice_negative_end assign_AvB, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_negative_end assign_AvB if religion==0, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_negative_end assign_AvB if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_negative_end assign_CvD, robust
	tab assign_CvD if e(sample)==1
	eststo: reg prejudice_negative_end assign_CvD if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: reg prejudice_negative_end assign_CvD if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: reg prejudice_negative_end assign_EvF, robust
	tab assign_EvF if e(sample)==1
    eststo: reg prejudice_negative_end assign_EvF if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: reg prejudice_negative_end assign_EvF if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice negative.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") ///
	title("Prejudice Index, Negative Attributes (scale ranges from 1 to 5, larger values indicate more positive assessment)") ///
	nonotes addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}") replace
	est clear
	
* Table 3: Prejudice Index, Positive Attributes
    eststo: reg prejudice_positive_end assign_AvB, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_positive_end assign_AvB if religion==0, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_positive_end assign_AvB if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_positive_end assign_CvD, robust
	tab assign_CvD if e(sample)==1
	eststo: reg prejudice_positive_end assign_CvD if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: reg prejudice_positive_end assign_CvD if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: reg prejudice_positive_end assign_EvF, robust
	tab assign_EvF if e(sample)==1
    eststo: reg prejudice_positive_end assign_EvF if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: reg prejudice_positive_end assign_EvF if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice positive.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") ///
	title("Prejudice Index, Positive Attributes (scale ranges from 1 to 5, larger values indicate more positive assessment)") ///
	nonotes addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
	
* Table 4: Prejudice Index, Out-group Evaluation
	eststo: reg prejudice_eval_end assign_AvB, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_eval_end assign_AvB if religion==0, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_eval_end assign_AvB if religion==1, robust
	tab assign_AvB if e(sample)==1
    eststo: reg prejudice_eval_end assign_CvD, robust
	tab assign_CvD if e(sample)==1
	eststo: reg prejudice_eval_end assign_CvD if religion==0, robust
	tab assign_CvD if e(sample)==1
    eststo: reg prejudice_eval_end assign_CvD if religion==1, robust
	tab assign_CvD if e(sample)==1
    eststo: reg prejudice_eval_end assign_EvF, robust
	tab assign_EvF if e(sample)==1
    eststo: reg prejudice_eval_end assign_EvF if religion==0, robust
	tab assign_EvF if e(sample)==1
    eststo: reg prejudice_eval_end assign_EvF if religion==1, robust
	tab assign_EvF if e(sample)==1
	esttab using "Prejudice eval.tex", obslast nodepvars b(2) se label star(+ 0.10 * 0.05 ** 0.01) ///
	mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" "\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" ///
	"\shortstack{All in\\ heterog. class}" "\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") ///
	title("Prejudice Index, Out_group Evaluation (scale ranges from 1 to 5, larger values indicate more positive assessment)") ///
	nonotes addnotes("\specialcell{Robust standard errors in parentheses. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear

* Load long data
   use "Data_APSR_long.dta", clear

* Table 5: Number of Bills Given in Dictator Game
	eststo: areg h1_end assign_AvB otherh1 AvB_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: areg h1_end assign_AvB otherh1 AvB_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: areg h1_end assign_CvD otherh1 CvD_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: areg h1_end assign_CvD otherh1 CvD_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: areg h1_end assign_EvF otherh1 EvF_otherh1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: areg h1_end assign_EvF otherh1 EvF_otherh1 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Dictator game.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh1 assign_CvD CvD_otherh1 assign_EvF ///
	EvF_otherh1 otherh1) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes( ///
	"\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}") replace
	est clear
	
* Table 6: Mean Number of Bills Given in Dictator Game, by Treatment Assignment
	* Full sample
	ttest h1_end if assign_AvB==0, by(otherh1)
	ttest h1_end if assign_CvD==0, by(otherh1)
	ttest h1_end if assign_CvD==1, by(otherh1)
	* Muslims
	ttest h1_end if assign_AvB==0 & religion==0, by(otherh1)
	ttest h1_end if assign_CvD==0 & religion==0, by(otherh1)
	ttest h1_end if assign_CvD==1 & religion==0, by(otherh1)
	* Christians
	ttest h1_end if assign_AvB==0 & religion==1, by(otherh1)
	ttest h1_end if assign_CvD==0 & religion==1, by(otherh1)
	ttest h1_end if assign_CvD==1 & religion==1, by(otherh1)


* Table 7: Number of Bills Destroyed in Destruction Game
	eststo: areg h2_end assign_AvB otherh2 AvB_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: areg h2_end assign_AvB otherh2 AvB_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_AvB if e(sample)==1
    eststo: areg h2_end assign_CvD otherh2 CvD_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: areg h2_end assign_CvD otherh2 CvD_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_CvD if e(sample)==1
    eststo: areg h2_end assign_EvF otherh2 EvF_otherh2, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==0, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
    eststo: areg h2_end assign_EvF otherh2 EvF_otherh2 if religion==1, absorb(row_id) cluster(primary_id)
	tab assign_EvF if e(sample)==1
	esttab using "Destruction game.tex", obslast wrap nodepvars order(assign_AvB AvB_otherh2 assign_CvD CvD_otherh2 assign_EvF ///
	EvF_otherh2 otherh2) b(2) se label star(+ 0.10 * 0.05 ** 0.01) mtitles("All" "Muslims" "Christians" "\shortstack{All\\ in UYVT}" ///
	"\shortstack{Muslims\\ in UYVT}" "\shortstack{Christians\\ in UYVT}" "\shortstack{All in\\ heterog. class}" ///
	"\shortstack{Muslims in\\ heterog. class}" "\shortstack{Christians in\\ heterog. class}") nonotes addnotes( ///
	"\specialcell{Standard errors (in parentheses) clustered by respondent. \textit{\sym{+} p $<$ 0.10, \sym{*} p $<$ 0.5, \sym{**} p  $<$ 0.01}}")replace
	est clear
