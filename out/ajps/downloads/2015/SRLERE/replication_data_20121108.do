**************************************************************
*Weghorst Keith, R. and Staffan I. Lindberg. 2012. "What Drives the Swing Voter in Africa?" AJPS, Forthcoming.
**File Contents: Replication file for MS Analysis (includes appendicies)
*Filename: data_replication_20121108
*Data Used: replication_data_20121108.dta
*File Output: text_table.txt, appendixe1_tab1.txt, appendixe2_tab1.txt, appendixe3_tab1.txt, appendixe4_tab1.txt, apptendixe5_tab1.txt, 
*Filet Output (cont.): appendixe6_tab1.txt, tsv_countfit.gph, psv_countfit.gph, csv_countfit.gph, appendixc_fig1, appendixd_fig1

**************************************************************


**Note to Users: 
*Thank you for downloading our replication data.  This file will allow you to repdroduce every table, 
*and figure presented in the text and in the online appendix.  In some cases, the figures in the text
*have been modified with the graph editor for sylistic purposes.  When we did so, it is noted below.

*For basic tables in the text (e.g. DV distributions, Step 1 below), we did not write the .do file to
*create additional files.  The .do file does show them in the Stata results window.
*For statistical analyses in the MS and appendix, the replication file will write a .txt file for each.

*We set the replicaiton to ID your working directory at the opening of the file, so all outputs
*including tables and figures produced by the file will save to said directory, with these commands.

clear
*cd "USERfilepath," for example:
cd "/Users/keithweghorst/Desktop/swingvote_ghana/ajps_replication/"
use replication_data_20121108.dta

*If you instead prefer to open the data and run the file, asterisk before "cd" above and
*you can begin by opening the dataset and begin at Step 1 below.

*Please contact us if you have any questions--at keith.weghorst@ufl.edu and sil@ufl.edu.  

*Thanks again!

**************************************************************
*1: Text, Table 1: Distribution of DVs
**************************************************************
tab1 tsv psv csv

**************************************************************
*2: Text, Table 2: Negative Binomial Regression Analysis
**************************************************************

******************
*2.1: Esimation
******************
eststo tsv: quietly nbreg tsv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo psv: quietly nbreg psv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo csv: quietly nbreg csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)


******************
*2.2: Produces Cols 1-3 Table 2
******************
estout tsv psv csv using text_table2.txt, cells("b(fmt(3)) se p")  label varlabels(_cons Constant)  stats (N ll aic)  extracols(4 7 11)

******************
*2.3: Info for column 4, table 2, pasted manually into text_table2.txt
******************
quietly nbreg tsv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
listcoef, percent
quietly nbreg csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
listcoef, percent
quietly nbreg psv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
listcoef, percent

**************************************************************
*3: Text: Figure 1, Predicted Probability of a Zero Count ("Core Voting")
**************************************************************
*Based off variables generated from predicted probabilities
*Note: After creating the graph, we rescale tsv axis to match psv with the graph editor
twoway (line prval_constdev axis_fig1, lwidth(thin)) (line prval_lawmaking axis_fig1, lwidth(thin) lpattern(tight_dot))  (line prval_econvote axis_fig1, lwidth(thin) lpattern(dash)) (line prval_cliesup axis_fig1, lwidth(thin) lpattern(vshortdash)) (line prval_patronasst axis_fig1, lwidth(thin) lpattern(longdash_3dot)) , ytitle(Probability of Core Voter) ytitle(, size(small) margin(medium)) ylabel(, labsize(vsmall)) xscale(range(0 1.1)) xtitle(Evaluation) xtitle(, size(small)) xlabel(1 "Bad/Low" 2 "Good/High", labels labsize(vsmall)) by(, title(FIGURE 1: Performance Based Voting vs. Clientelism, size(medsmall)) note(All Other Variables at Means, size(vsmall) position(5))) by(, legend(on)) legend(order(1 "Const. Development [0,1]" 2 "Law-Making [0,1]" 3 " Econ Voting [0,1]" 4 "Clientelism Exposure [0,5]" 5 "Patron [0,1]") symplacement(west) stack rows(1) size(vsmall)) scheme(sj) by(tpc, style(rescale) imargin(medium) rows(1) colfirst yrescale)
graph save f1_text.gph

**************************************************************
*4: Text, Figure 2: Predicted Count Value, for PSV & CSV
**************************************************************
**Based off variables generated from predicted probabilities
*Policy Swing Part*
twoway (rcap psv_lowerci psv_upperci axis_fig2) (scatter psv_pointestimates axis_fig2, msize(small) msymbol(circle) mlabel(psv_pointestimates) mlabsize(small)) (line psv_mean axis_fig2, lpattern(tight_dot)), ytitle(Predicted Count) ytitle(, size(small)) ylabel(.9(.2)1.5, labsize(vsmall))    xtitle(Variable Ranges) xtitle(, size(zero)) xmtick(1.5 "Constituency Dev"  3.5"Law-Making" 5.5  "Econ Eval",labels labgap(large)  labsize(small)) xlabel( 1 " Bad [0]" 2 "Good [1]"3" Bad [0]" 4 "Good [1]"5" Bad [0]" 6 "Good [1]" , labels labsize(vsmall)) by(, title(FIGURE 2: Performance Based Voting vs. Clientelism for Total Swing, size(medsmall)) note(All Other Variables at Means, size(vsmall) position(5))) by(, legend(on)) legend(order(3 "Mean Predicted Count" 2 "Predicted Count" 1 "95 % CI") symplacement(west) stack rows(1) size(vsmall)) scheme(sj) by(cliesup_dummy, style(rescale) imargin(medium) rows(1) colfirst yrescale)
graph save Graph text_f2_psv.gph, replace
*Clientelism Swing Party*
twoway (rcap csv_lowerci csv_upperci axis_fig2) (scatter csv_pointestimates axis_fig2, msize(small) msymbol(circle) mlabel(csv_pointestimates) mlabsize(small)) (line csv_mean axis_fig2, lpattern(tight_dot)), ytitle(Predicted Count) ytitle(, size(small)) ylabel(.5(.1).8, labsize(vsmall))    xtitle(Variable Ranges) xtitle(, size(zero)) xmtick(1.5 "Constituency Dev"  3.5"Law-Making" 5.5  "Econ Eval",labels labgap(large)  labsize(small)) xlabel( 1 " Bad [0]" 2 "Good [1]"3" Bad [0]" 4 "Good [1]"5" Bad [0]" 6 "Good [1]" , labels labsize(vsmall)) by(, title(FIGURE 2: Performance Based Voting vs. Clientelism for Total Swing, size(medsmall)) note(All Other Variables at Means, size(vsmall) position(5))) by(, legend(on)) legend(order(3 "Mean Predicted Count" 2 "Predicted Count" 1 "95 % CI") symplacement(west) stack rows(1) size(vsmall)) scheme(sj) by(cliesup_dummy, style(rescale) imargin(medium) rows(1) colfirst yrescale)
graph save Graph text_f2_csv.gph, replace

**************************************************************
*5: Appendix B1: Summary Statistics of Variables
**************************************************************

summarize tsv psv csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, format

**************************************************************
*6: Appendix C, Figure 1: Distribution of DVs
**************************************************************

format tsv psv csv %9.0f
histogram tsv, discrete frequency normal ytitle(Frequency) ylabel(0(200)1000) xtitle(Total Swing Voting) scheme(sj)
graph rename Graph appendixc_tsvdist, replace
histogram psv, discrete frequency normal ytitle(Frequency) ylabel(0(200)1000) xtitle(Policy Swing Voting) scheme(sj)
graph rename Graph appendixc_psvdist, replace
histogram csv, discrete frequency normal ytitle(Frequency) ylabel(0(200)1000) xtitle(Clientelism Swing Voting) scheme(sj)
graph rename Graph appendixc_csvdist, replace
graph combine appendixc_tsvdist appendixc_psvdist appendixc_csvdist, rows(1) title(Appendix C Fig 1: Distribution of Dependent Variables, size(medsmall)) scheme(sj) commonscheme
graph save appendixc_fig1, replace 


**************************************************************
*7: Appendix D, Figure 1 & Table 1
**************************************************************
*Note: Using countfit command in Stata 11 produces the information in table 1 and also outputs 
*the figures used to create figure 1 if Appendix D. We manually enter table 1 into 
*Appendix D, which combines the information from the 3 countfit tests below.


set maxiter 100
countfit tsv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, inflate(patronasst constdev  lawmaking  execoversight  econvote cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency) gen(tsv) 
**graph slightly edited for style, save changes as tsv_countfit.gph
 graph save Graph countfit_tsv.gph, replace
  
countfit psv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, inflate(patronasst constdev  lawmaking  execoversight  econvote cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency)  prm nbreg zip gen(psv)
**graph slightly edited for style, save changes as psv_countfit.gph
graph save Graph countfit_psv.gph, replace

quietly countfit csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, inflate(patronasst constdev  lawmaking  execoversight  econvote cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency) prm nbreg gen(csv)
**graph slightly edited for style, save changes as csv_countfit.gph
graph save Graph countfit_csv.gph, replace

graph combine countfit_tsv.gph countfit_psv.gph countfit_csv.gph, rows(1) title(Appendix D Fig 1: Goodness of Fit of Dependent Variables, size(small)) altshrink scheme(sj) imargin(r=10) commonscheme note(Positive Values Indicate Over Prediction, size(small))
graph save appendixd_fig1, replace 

**************************************************************
*7: Appendix E1
**************************************************************
*Note: We manually shade the cells with significant coefficeints; 
*for the replicaiton file we provide the p-value adjacent to each cell

eststo Undecided: quietly logit undecided constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Independent: quietly logit independent constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth   incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Split_ticket: quietly logit split_ticket constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth   incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Total_Swing_Binary: quietly logit tsv_binary constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Policy_Swing_Binary: quietly logit psv_binary constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Clientelism_Swing_Binary: quietly logit csv_binary constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Our_Model_Total_Swing: quietly nbreg tsv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Our_Model_Policy_Swing: quietly nbreg psv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Our_Model_Clientelism_Swing: quietly nbreg csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
estout Undecided Independent Split_ticket Total_Swing_Binary Our_Model_Total_Swing Policy_Swing_Binary Our_Model_Policy_Swing Our_Model_Clientelism_Swing Clientelism_Swing_Binary using appendixe1_tab1.txt, cells("_sign p(fmt(2))")  label varlabels(_cons Constant)  stats (N ll)  


**************************************************************
*8. Appendix E2
**************************************************************
*Note: We manually shade the cells with significant coefficeints; 
*for the replicaiton file we provide the p-value adjacent to each cell,
*upon which the shading was based.  

eststo All_Swing_t: quietly nbreg tsv_totalswitch constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency) 
eststo Why_Did_Split_t: quietly nbreg tsv_split constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Why_Change_t: quietly nbreg tsv_change constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Would_Change_t: quietly nbreg tsv_wouldswitch constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
estout Our_Model_Total_Swing All_Swing_t Why_Did_Split_t Why_Change_t Would_Change_t using appendixe2_tab1.txt, cells("_sign p(fmt(2))")  label varlabels(_cons Constant)  stats (N ll aic bic)  


**************************************************************
*9. Appendix E3
**************************************************************
*Note: We manually shade the cells with significant coefficeints; 
*for the replicaiton file we provide the p-value adjacent to each cell,
*upon which the shading was based.  

eststo All_Swing_p: quietly nbreg psv_totalswitch constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Why_Did_Split_p: quietly nbreg psv_split constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Why_Change_p: quietly nbreg psv_change constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Would_Change_p: quietly nbreg psv_wouldswitch constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
estout Our_Model_Policy_Swing All_Swing_p Why_Did_Split_p Why_Change_p Would_Change_p using appendixe3_tab1.txt, cells("_sign p(fmt(2))")  label varlabels(_cons Constant)  stats (N ll aic bic)  


**************************************************************
*10. Appendix E4
**************************************************************
eststo All_Swing_c: quietly nbreg csv_totalswitch constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Why_Did_Split_c: quietly nbreg csv_split constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Why_Change_c: quietly nbreg csv_change constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo Would_Change_c: quietly nbreg csv_wouldswitch constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
estout Our_Model_Clientelism_Swing All_Swing_c Why_Did_Split_c Why_Change_c Would_Change_c using appendixe4_tab1.txt, cells("_sign p(fmt(2))")  label varlabels(_cons Constant)  stats (N ll aic bic)  


**************************************************************
*11. Appendix E5
**************************************************************
eststo One_Open_t: quietly nbreg tsv_onecat constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo One_Open_p: quietly nbreg psv_onecat constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
eststo One_Open_c: quietly nbreg csv_onecat constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, cluster(safe_constituency)
estout Our_Model_Total_Swing One_Open_t Our_Model_Policy_Swing One_Open_p Our_Model_Clientelism_Swing One_Open_c using appendixe5_tab1.txt, cells(b(star fmt(2)))  legend label varlabels(_cons Constant)    stats(N ll aic bic)

**************************************************************
*12. Appendix E6
**************************************************************

eststo Average_Margin_of_Victory_t: quietly nbreg tsv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe avg_margin_0004, cluster(safe_constituency)
eststo Average_Margin_of_Victory_p: quietly nbreg psv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe avg_margin_0004, cluster(safe_constituency)
eststo Average_Margin_of_Victory_c: quietly nbreg csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe avg_margin_0004, cluster(safe_constituency)
estout Our_Model_Total_Swing Average_Margin_of_Victory_t Our_Model_Policy_Swing Average_Margin_of_Victory_p Our_Model_Clientelism_Swing Average_Margin_of_Victory_c using appendixe6_tab1.txt, cells(b(star fmt(2)))  legend label varlabels(_cons Constant)    stats(N ll aic bic)


**************************************************************
*13. Appendix F
**************************************************************
*Convergence is not achieved below for psv and csv.
*We bracket them off so the .do file runs without error.
*If you wish to replicate the non-convergent results reported
*in Table 1, Appendix F, remove the asterisks below and paste them
*into the command window.

set maxiter 100
zinb tsv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, inflate(constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency) cluster(safe_constituency)
eststo Total_Swing_ZINB 


**********quietly zinb psv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, inflate(constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency) cluster(safe_constituency)
**********eststo Policy_Swing_ZINB

**********quietly zinb csv constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency, inflate(constdev  lawmaking  execoversight  econvote  patronasst cliesup  relativewealth  party_member  incum_mpvote_04 male  age  edulevel  news_access  ashanti ewe safe_constituency) cluster(safe_constituency)
**********eststo Clientelism_Swing_ZINB 

**********estout Total_Swing_ZINB Policy_Swing_ZINB Clientelism_Swing_ZINB using table_F.txt, cells(b(star fmt(2)))  legend label varlabels(_cons Constant)    stats(N ll aic bic)


**************************************************************

*Thanks again for your interest in our paper!

*Keith R. Weghorst and Staffan I. Lindberg
*11/09/2012
