
*******************************************
// EX POST LOBBYING REPLICATION DO FILE
*******************************************


clear
use expost_jop_replication.dta






**************************************************
//    TABLE 1 & Table A1: EX POST LOBBYING RATIO         
**************************************************

by b_id, sort: gen tt = 1 if _n == 1
tab congress if tt == 1
drop tt
tab congress lob_type if clear ==1, row
tab congress lob_type, row









**************************************************
//   FIGURE 2: Difference in vote and lobbying        
**************************************************

gen lobbying_gap =.
replace lobbying_gap = lob_month - final_vote_month if final_vote_year == lob_year
replace lobbying_gap = 12 + lob_month - final_vote_month if lobbying_gap ==. & lob_month > final_vote_month & lob_year > final_vote_year
replace lobbying_gap = 12 + lob_month - final_vote_month if lobbying_gap ==. & lob_month < final_vote_month & lob_year > final_vote_year
replace lobbying_gap = -12 +lob_month - final_vote_month if lobbying_gap ==. & lob_month > final_vote_month & lob_year < final_vote_year
replace lobbying_gap = -12 +lob_month - final_vote_month if lobbying_gap ==. & lob_month < final_vote_month & lob_year < final_vote_year
replace lobbying_gap = 12 if lob_month==final_vote_month & lob_year > final_vote_year
replace lobbying_gap = -12 if lob_month==final_vote_month & lob_year < final_vote_year
gen lobbying_gap_quarter =. 
replace lobbying_gap_quarter = 0 if lobbying_gap == 0 
replace lobbying_gap_quarter = 1 if lobbying_gap == 1 |lobbying_gap == 2 | lobbying_gap == 3 
replace lobbying_gap_quarter = 2 if lobbying_gap == 4 | lobbying_gap == 5 | lobbying_gap == 6
replace lobbying_gap_quarter = 3 if lobbying_gap == 7 | lobbying_gap == 8 | lobbying_gap == 9
replace lobbying_gap_quarter = 4 if lobbying_gap ==10 | lobbying_gap == 11| lobbying_gap == 12
replace lobbying_gap_quarter = 5 if lobbying_gap ==13 | lobbying_gap == 14| lobbying_gap == 15
replace lobbying_gap_quarter = 6 if lobbying_gap ==16 | lobbying_gap == 17| lobbying_gap == 18
replace lobbying_gap_quarter = 7 if lobbying_gap ==19 | lobbying_gap == 20| lobbying_gap == 21
replace lobbying_gap_quarter = 8 if lobbying_gap ==22 | lobbying_gap == 23

replace lobbying_gap_quarter = -1 if lobbying_gap == -1 | lobbying_gap == -2 | lobbying_gap == -3 
replace lobbying_gap_quarter = -2 if lobbying_gap == -4 | lobbying_gap == -5 | lobbying_gap == -6
replace lobbying_gap_quarter = -3 if lobbying_gap == -7 | lobbying_gap == -8 | lobbying_gap == -9
replace lobbying_gap_quarter = -4 if lobbying_gap == -10| lobbying_gap==-11 | lobbying_gap==-12
replace lobbying_gap_quarter = -5 if lobbying_gap ==-13 | lobbying_gap == -14| lobbying_gap == -15
replace lobbying_gap_quarter = -6 if lobbying_gap ==-16 | lobbying_gap == -17| lobbying_gap == -18
replace lobbying_gap_quarter = -7 if lobbying_gap ==-19 | lobbying_gap == -20| lobbying_gap == -21

hist lobbying_gap, bin(20) xline(0, lcol(gray) lpat(dash) lwid(thick)) graphregion(color(white)) fcol(none) lcol(black) xtitle("Time Difference in Lobbying Activity From Final Vote (Month)") ytitle("Density")









*****************************************************************************
//  FIGURE 4: Ex Post lobbying Ratio at a Bill Level pre- and post-2007
*****************************************************************************


by b_id, sort: egen all_lobbying = count(rollcall)
gen expost = 1 if lob_type == 2
replace expost = 0 if expost ==.
by b_id, sort: egen expost_lobbying = sum(expost)
gen expost_ratio = expost_lobbying/all_lobbying
by b_id, sort: gen tt = 1 if _n == 1   // unique bill identifier 

sum expost_ratio if tt == 1
sum expost_ratio if tt == 1 & bill_intro_year < 2008
sum expost_ratio if tt == 1 & bill_intro_year >= 2008

hist expost_ratio if tt == 1 & bill_intro_year < 2008, xline(.3439117, lcol(gray) lpat(dash) lwid(thick)) freq bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("Ex Post Lobbying Ratio") ytitle("Frequency") saving(hist1, replace)
hist expost_ratio if tt == 1 & bill_intro_year >= 2008, xline(.4972303, lcol(gray) lpat(dash) lwid(thick)) freq bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("Ex Post Lobbying Ratio") ytitle("Frequency") saving(hist2, replace)
gr combine hist1.gph hist2.gph, xsize(7) graphregion(color(white)) 




********************************************************************
//   TABLE 2: bill characteristics and ex post lobbying ratio
********************************************************************


replace reg_total_wordcount = 0 if rulemaking == 0
replace reg_mean_wordcount = 0 if rulemaking == 0
replace reg_mean_restriction = 0 if rulemaking == 0
replace reg_total_restriction = 0 if rulemaking == 0

gen ln_total_wordcount = ln(reg_total_wordcount + 1)
gen ln_mean_wordcount = ln(reg_mean_wordcount + 1)
gen ln_total_restriction = ln(reg_total_restriction +1)
gen ln_mean_restriction = ln(reg_mean_restriction + 1)

gen duration =.
replace duration = abs(final_vote_month - bill_intro_month) if bill_intro_year == final_vote_year
replace duration = final_vote_month - bill_intro_month + 12 if final_vote_year == bill_intro_year + 1

replace major = "" if major =="NULL"
encode major, gen(major2)


eststo clear
eststo: quietly reg expost_lobbying ln_total_restriction all_lobbying duration i.congress if tt == 1, robust
eststo: quietly areg expost_lobbying ln_total_restriction all_lobbying duration i.congress if tt == 1, a(agendascode) robust
eststo: quietly reg expost_lobbying ln_total_wordcount all_lobbying duration i.congress if tt == 1, robust
eststo: quietly areg expost_lobbying ln_total_wordcount all_lobbying duration i.congress if tt == 1, a(agendascode) robust
esttab, star(* 0.10 ** 0.05 *** 0.01) ar2
esttab using bill_expost_reg.tex, star(** 0.05 *** 0.01) ar2 replace



drop tt







*****************************************************************************
//  FIGURE 5: Ex Post Lobbying at the client level pre- and post- 2007 
*****************************************************************************


by client_parent_name, sort: egen client_expost07 = mean(expost) if lob_year < 2008
sort client_parent_name client_expost07
by client_parent_name, sort: replace client_expost07 = client_expost07[_n-1] if missing(client_expost07) & _n > = 1
by client_parent_name, sort: gen tt = 1 if _n == 1 & client_expost07!= .
sum client_expost07 if tt == 1


by client_parent_name, sort: egen client_expost08 = mean(expost) if lob_year > = 2008
sort client_parent_name client_expost08
by client_parent_name, sort: replace client_expost08 = client_expost08[_n-1] if missing(client_expost08) & _n > = 1
by client_parent_name, sort: gen pp = 1 if _n == 1 & client_expost08 != .
sum client_expost08 if pp == 1


hist client_expost07 if tt == 1 , xline(.1062447, lcol(gray) lpat(dash) lwid(thick)) freq bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("Ex Post Lobbying Ratio") ytitle("Frequency") saving(hist1, replace)
hist client_expost08 if pp == 1 , xline(.3524585, lcol(gray) lpat(dash) lwid(thick)) freq bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("Ex Post Lobbying Ratio") ytitle("Frequency") saving(hist2, replace)
gr combine hist1.gph hist2.gph, xsize(7) graphregion(color(white)) 





*****************************************************************************
//  TABLE 3: Lobbying Types by Firms - Dodd Frank 
*****************************************************************************


clear 
use dodd_frank.dta

gen include=.
replace include = 1
replace include = 0 if sector=="Ideology/Single-Issue"
replace include = 0 if sector=="Labor"
replace include = 0 if sector=="Unknown"
replace include = 0 if sector=="Other"
replace include = 0 if sector=="Lawyers & Lobbyists"

by client, sort: gen tt = 1 if _n == 1 
tab tt if include == 1
tab tt if association == 1 & include == 1
tab lob_type if include == 1
by lob_type, sort: egen spendtotal= sum(ave_amount) if include == 1


tab size if tt == 1 & include == 1 & association == 0
tab association if tt == 1 & include == 1

keep if include == 1 & association == 0 & size != ""

by size, sort: egen totalreport = count(lob_type)
by size, sort: egen totalspending = sum(ave_amount)
by size, sort: egen totalreport_post = count(lob_type) if lob_type == 2
sort size totalreport_post
by size, sort: replace totalreport_post = totalreport_post[_n-1] if missing(totalreport_post) & _n > = 1
by size, sort: egen totalspending_post = sum(ave_amount) if lob_type == 2
sort size totalspending_post
by size, sort: replace totalspending_post = totalspending_post[_n-1] if missing(totalspending_post) & _n > = 1

format totalspending totalspending_post %13.0f
gen expostreport = totalreport_post/totalreport
gen expostspending = totalspending_post/totalspending

by size, sort: gen pp = 1 if _n == 1
by size, sort: sum totalreport totalspending expostreport expostspending if pp == 1 

gen size2 = .
replace size2 = 1 if size =="S" | size =="M"
replace size2 = 2 if size =="L" | size =="VL"

by size2, sort: egen totalreport2 = count(lob_type)
by size2, sort: egen totalspending2 = sum(ave_amount)
by size2, sort: egen totalreport_post2 = count(lob_type) if lob_type == 2
sort size2 totalreport_post
by size2, sort: replace totalreport_post2 = totalreport_post2[_n-1] if missing(totalreport_post2) & _n > = 1
by size2, sort: egen totalspending_post2 = sum(ave_amount) if lob_type == 2
sort size2 totalspending_post2
by size2, sort: replace totalspending_post2 = totalspending_post2[_n-1] if missing(totalspending_post2) & _n > = 1

format totalspending2 totalspending_post2 %13.0f
gen expostreport2 = totalreport_post2/totalreport2
gen expostspending2 = totalspending_post2/totalspending2

by size2, sort: gen gg = 1 if _n == 1
by size2, sort: sum totalreport2 totalspending2 expostreport2 expostspending2 if gg == 1 

clear


clear 
use dodd_frank.dta

gen include=.
replace include = 1
replace include = 0 if sector=="Ideology/Single-Issue"
replace include = 0 if sector=="Labor"
replace include = 0 if sector=="Unknown"
replace include = 0 if sector=="Other"
replace include = 0 if sector=="Lawyers & Lobbyists"

keep if include == 1 & association == 1 
by client, sort: gen tt = 1 if _n == 1 

by association, sort: egen totalreport = count(lob_type)
by association, sort: egen totalspending = sum(ave_amount)
by association, sort: egen totalreport_post = count(lob_type) if lob_type == 2
sort totalreport_post
by association, sort: replace totalreport_post = totalreport_post[_n-1] if missing(totalreport_post) & _n > = 1
by association, sort: egen totalspending_post = sum(ave_amount) if lob_type == 2
sort totalspending_post
by association, sort: replace totalspending_post = totalspending_post[_n-1] if missing(totalspending_post) & _n > = 1

format totalspending totalspending_post %13.0f
gen expostreport = totalreport_post/totalreport
gen expostspending = totalspending_post/totalspending

sum totalreport totalspending expostreport expostspending 


clear







*****************************************************************************
//  TABLE 4: Lobbying Types by Targeted Agency
*****************************************************************************



clear
use lobbying_agency.dta

gen agency_type=.
replace agency_type = 1 if agency_ext_id ==1  
replace agency_type = 1 if agency_ext_id ==2  
replace agency_type = 2 if agency_ext_id != . & agency_type ==.


tab lob_type agency_type, row
tab lob_type agency_type if numbill ==1 , row
tab agency_type
tab agency_type if numbill == 1

clear







****************** APPENDIX ******************





**************************************************
//   FIGURE A2: Ex Post Lobbying by Spending    
**************************************************

clear
use issue.dta
sort transaction_id congress billtype billnum
save issue.dta, replace


clear
use expost_jop_replication.dta
sort transaction_id congress billtype billnum
merge transaction_id congress billtype billnum using issue.dta
drop if _merge == 2


// (1) subsample (1 issue, 1 bill)

gen subsample = 1 if numissue == 1 & numbill == 1
replace subsample = 0 if subsample == .

tabstat amount if subsample ==1, by(lob_type) stats(n mean sd)   
tabstat amount if subsample ==1 & clear == 1, by(lob_type) stats(n mean sd)   


// (2) all cases based on the number of issues

gen ave_amount =.
replace ave_amount = amount/numissue
label variable ave_amount "average spending for one issue in each lobbying report"

gen ave_amount2 =.
replace ave_amount2 = amount/numbill
label variable ave_amount2 "average spending for one bill in each lobbying report"

tabstat ave_amount, by(lob_type) stats(n mean sd)
tabstat ave_amount if clear == 1, by(lob_type) stats(n mean sd)

tabstat ave_amount2, by(lob_type) stats(n mean sd)
tabstat ave_amount2 if clear == 1, by(lob_type) stats(n mean sd)

gen ln_amount = ln(amount+1)
gen ln_ave_amount = ln(ave_amount+1)
br b_id lob_type clear amount ln_amount ave_amount ln_ave_amount subsample  // save as lobbying_expense.csv for the graph (spending.pdf)


clear






********************************************************************
//   FIGURE A3: Bill Introduction time and ex post lobbying
********************************************************************


clear
use expost_jop_replication.dta 
gen oddyear = .
replace oddyear = 1 
replace oddyear = 0 if bill_intro_year == 2002 | bill_intro_year == 2004 | bill_intro_year == 2006 | bill_intro_year == 2008 | bill_intro_year == 2010  


gen introduction =.
replace introduction = 1 if oddyear == 1 & bill_intro_month == 1
replace introduction = 2 if oddyear == 1 & bill_intro_month == 2
replace introduction = 3 if oddyear == 1 & bill_intro_month == 3
replace introduction = 4 if oddyear == 1 & bill_intro_month == 4
replace introduction = 5 if oddyear == 1 & bill_intro_month == 5
replace introduction = 6 if oddyear == 1 & bill_intro_month == 6
replace introduction = 7 if oddyear == 1 & bill_intro_month == 7
replace introduction = 8 if oddyear == 1 & bill_intro_month == 8
replace introduction = 9 if oddyear == 1 & bill_intro_month == 9
replace introduction = 10 if oddyear == 1 & bill_intro_month == 10
replace introduction = 11 if oddyear == 1 & bill_intro_month == 11
replace introduction = 12 if oddyear == 1 & bill_intro_month == 12
replace introduction = 13 if oddyear == 0 & bill_intro_month == 1
replace introduction = 14 if oddyear == 0 & bill_intro_month == 2
replace introduction = 15 if oddyear == 0 & bill_intro_month == 3
replace introduction = 16 if oddyear == 0 & bill_intro_month == 4
replace introduction = 17 if oddyear == 0 & bill_intro_month == 5
replace introduction = 18 if oddyear == 0 & bill_intro_month == 6
replace introduction = 19 if oddyear == 0 & bill_intro_month == 7
replace introduction = 20 if oddyear == 0 & bill_intro_month == 8
replace introduction = 21 if oddyear == 0 & bill_intro_month == 9
replace introduction = 22 if oddyear == 0 & bill_intro_month == 10
replace introduction = 23 if oddyear == 0 & bill_intro_month == 11
replace introduction = 24 if oddyear == 0 & bill_intro_month == 12



by b_id, sort: gen tt = 1 if _n == 1
gen expost = 1 if lob_type == 2
replace expost = 0 if lob_type == 1
by b_id, sort: egen expost_ratio = mean(expost)
sum expost_ratio if tt == 1

gen exante_ratio = 1 - expost_ratio

reg exante_ratio introduction  if tt == 1 
reg exante_ratio introduction  if tt == 1 & introduction < 20


scatter expost_ratio introduction if tt == 1
twoway (scatter expost_ratio introduction if tt == 1, xtitle("Legislative Month a Bill Introduced in Congress") ytitle("Ex Post Lobbying Ratio") mcolor(gray) msize(small) graphregion(color(white))) (lowess expost_ratio introduction if tt == 1, lwidth(thick) lcol(gs2))










********************************************************************
//   FIGURE A4: Appropriations vs. Non-Appropriations Bills
********************************************************************


clear
use expost_jop_replication.dta

gen appro =.
replace appro = 1 if is_bill_cycle == 1
replace appro = 0 if is_bill_cycle == 0
replace appro = 1 if strpos(titledescription, "appropriation") > 0 & appro ==.
replace appro = 1 if strpos(titledescription, "appropriations") > 0 & appro ==.
replace appro = 1 if strpos(titledescription, "Appropriations") > 0 & appro ==.
replace appro = 1 if strpos(titledescription, "autorizations") > 0 & appro ==.
replace appro = 1 if strpos(titledescription, "autorization") > 0 & appro ==.
replace appro = 1 if strpos(titledescription, "reauthorize") > 0 & appro ==.
replace appro = 0 if appro ==. 

tab appro

by b_id, sort: egen all_lobbying = count(rollcall)
gen expost = 1 if lob_type == 2
replace expost = 0 if expost ==.
by b_id, sort: egen expost_lobbying = sum(expost)
gen expost_ratio = expost_lobbying/all_lobbying
by b_id, sort: gen tt = 1 if _n == 1

sum expost_ratio if tt == 1
sum expost_ratio if tt == 1 & appro == 1
sum expost_ratio if tt == 1 & appro == 0


hist expost_ratio if tt == 1 & appro == 1, xline(.3204243, lcol(gray) lpat(dash) lwid(thick)) freq bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("Ex Post Lobbying Ratio") ytitle("Frequency") saving(hist1, replace)
hist expost_ratio if tt == 1 & appro == 0, xline(.4071395, lcol(gray) lpat(dash) lwid(thick)) freq bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("Ex Post Lobbying Ratio") ytitle("Frequency") saving(hist2, replace)
gr combine hist1.gph hist2.gph, xsize(7) graphregion(color(white)) 








******************************************************************************
//   FIGURE A5 Distribution of Restriction Index at Rule and Bill Levels
******************************************************************************

clear
use regdata_cleaned.dta

by plawnum, sort: gen tt = 1 if _n == 1

gen ln_total_wordcount = ln(total_wordcount +1)
gen ln_total_restriction = ln(total_restriction +1)

sum ln_total_wordcount ln_total_restriction if tt ==1

// word counts and restrictions 
hist ln_total_wordcount, xline(15.91613, lcol(gray) lpat(dash) lwid(thick)) density bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("(ln) Total Word Count") ytitle("Density") saving(hist1, replace)
hist ln_total_restriction if tt ==1, xline(9.30738, lcol(gray) lpat(dash) lwid(thick)) density bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("(ln) Total Restriction") ytitle("Density") saving(hist2, replace)
gr combine hist1.gph hist2.gph, xsize(7) graphregion(color(white)) 









********************************************************************
//   TABLE A2: bill characteristics and ex post lobbying ratio
********************************************************************


// (1) based on issue criteria from the Policy Agenda Project

clear
use expost_jop_replication.dta 
by b_id, sort: egen all_lobbying = count(rollcall)
gen expost = 1 if lob_type == 2
replace expost = 0 if expost ==.
by b_id, sort: egen expost_lobbying = sum(expost)
gen expost_ratio = expost_lobbying/all_lobbying
by b_id, sort: gen tt = 1 if _n == 1
tabstat expost_ratio if tt == 1, stat(N mean p25 p75)

tab major if expost_ratio >= .6666667 & tt == 1, sort
tab minor if expost_ratio > .6666667 & tt == 1, sort

tab major if expost_ratio < 0.2 & tt == 1, sort
tab minor if expost_ratio < 0.2 & tt == 1, sort

by major, sort: egen expost_major = mean(expost_ratio) if tt == 1
by major expost_major, sort: gen pp = 1 if _n == 1 
gsort - expost_major
by major, sort: egen majornumbill = sum(tt) if tt == 1
br major majornumbill expost_major if pp == 1 & expost_major !=.


by minor, sort: egen expost_minor = mean(expost_ratio) if tt == 1
by minor expost_minor, sort: gen mm = 1 if _n == 1 
by minor, sort: egen minornumbill = sum(tt) if tt == 1
gsort - expost_minor
br minor minornumbill expost_minor  if mm == 1 & expost_minor !=.






********************************************************************
//   FIGURE A6. Distribution of Word Count in Bills
********************************************************************


clear
use expost_jop_replication.dta

by plawnum, sort: gen tt = 1 if _n == 1
gen ln_bill_wordcount = ln(bill_wordcount+1)
sum bill_wordcount ln_bill_wordcount if tt == 1

hist ln_bill_wordcount if tt ==1, xline(7.391622 ,lcol(gray) lpat(dash) lwid(thick)) density bin(20) graphregion(color(white)) fcol(none) lcol(black) xtitle("(ln) Word Count in Bills") ytitle("Density") saving(hist2, replace)








********************************************************************
//  TABLE A3. WORD COUNT AND EX POST LOBBYING RATIO
********************************************************************


clear
use expost_jop_replication.dta

by plawnum, sort: gen tt = 1 if _n == 1
gen ln_bill_wordcount = ln(bill_wordcount+1)

by b_id, sort: egen all_lobbying = count(rollcall)
gen expost = 1 if lob_type == 2
replace expost = 0 if expost ==.
by b_id, sort: egen expost_lobbying = sum(expost)
gen expost_ratio = expost_lobbying/all_lobbying

gen duration =.
replace duration = abs(final_vote_month - bill_intro_month) if bill_intro_year == final_vote_year
replace duration = final_vote_month - bill_intro_month + 12 if final_vote_year == bill_intro_year + 1

replace major = "" if major =="NULL"
encode major, gen(major2)

eststo clear
eststo: quietly reg expost_ratio ln_bill_wordcount duration if tt == 1 
eststo: quietly areg expost_ratio ln_bill_wordcount duration i.congress if tt == 1, a(major2)
eststo: quietly reg expost_ratio ln_bill_wordcount duration if tt == 1 & rollcall == 1
eststo: quietly areg expost_ratio ln_bill_wordcount duration i.congress if tt == 1 & rollcall == 1, a(major2)
esttab, star(* 0.10 ** 0.05 *** 0.01) ar2
esttab using bill_wordcount_reg.tex, star(* 0.10 ** 0.05 *** 0.01) ar2 replace







********************************************************************
//   TABLE A4: All Bills that Reached the House Floor
********************************************************************


clear
use all_bills_reached_house_floor.dta

by b_id, sort: gen tt = 1 if _n == 1
tab law if tt == 1



//-------------------------------------
// Threshold = House Vote
//-------------------------------------


gen h_lob_type=. 
replace h_lob_type =1 if h_vote_year > lob_year 
replace h_lob_type =2 if lob_year > h_vote_year  


*Before 2008 codings

replace h_lob_type=1 if h_lob_type==. & h_vote_month > 6 & lob_month==6 & lob_year < 2008   
replace h_lob_type = 1 if h_lob_type==. & h_vote_month > 6 & lob_month==12 & lob_year < 2008 
replace h_lob_type = 1 if h_lob_type==. & h_vote_month < 7 & lob_month==6 & lob_year < 2008
replace h_lob_type=2 if h_lob_type==. & h_vote_month < 7 & lob_month==12 & lob_year < 2008    

*Since 2008 

replace h_lob_type=1 if h_lob_type==. & h_vote_month >= lob_month & lob_year > 2007 
replace h_lob_type =2 if h_lob_type==. & h_vote_month < lob_month & lob_year > 2007   

tab congress if tt == 1 & law == 0
tab congress if tt == 1 & law == 1

tab congress h_lob_type if law == 0, row
tab congress h_lob_type if law == 1, row

by congress law, sort: egen totallob = count(congress)
by congress law, sort: egen expost = count(congress) if h_lob_type == 2
sort congress law expost
by congress law, sort: replace expost = expost[_n-1] if missing(expost) & _n > = 1

gen expostratio = expost/totallob

by congress law, sort: gen cc = 1 if _n == 1
br congress expostratio if cc == 1 & law == 0
br congress expostratio if cc == 1 & law == 1








