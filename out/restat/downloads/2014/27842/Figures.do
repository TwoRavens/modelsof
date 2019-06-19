/* Figures.do */
/* This do file constructs 2 figures */
/* Figure 1: Choice Profiles */
/* Figure 2: Individual Stability */


/* Figure 1 *//* Choice Profiles */capture drop meanchoiceegen meanchoice = mean(choice) if inconsistent != 1, by(rownumber year)capture drop meanchoiceretegen meanchoiceret = mean(choice) if (postgroup ==1 | lagpostgroup ==1) & inconsistent!=1 & ((laginconsistent !=1 & year ==2008) |(forinconsistent != 1 & year ==2007)), by(rownumber year)capture label drop yearlabellabel define yearlabel 2007 "2007" 2008 "2008"label values year yearlabel capture label drop tlabellabel define tlabel 0 "t=0" 6 "t=6"label values t tlabelcapture label drop klabellabel define klabel 1 "{&tau}=1" 6 "{&tau}=6"label values k klabel twoway (connected meanchoice optionA if year == 2007, sort) (connected meanchoice optionA if year ==2008, sort) if uniqid ==1 | uniqid ==2, ytitle("Proportion Taking Later Payment (50 USD)" ) ytitle(, orientation(vertical)) ylabel(0(.2)0.8) xtitle("Smaller Sooner Payment (X USD)") legend(order(1 "Full Sample (2007)" 2 "Full Sample (2008)")) scheme(s1mono) by(t k, rows(1) note("")) graph export "`c(pwd)'/Output/choiceprofiles.pdf", replace



/* Figure 2 */
/* Individual Level Stability */
capture label drop tlabellabel define tlabel 0 "t=0" 6 "t=6"label values t tlabelcapture label drop klabellabel define klabel 1 "{&tau}=1" 6 "{&tau}=6"label values k klabel 

histogram difchoice if returneesample ==1 , width(0.2) xlab(-1(1)1) fraction  xtitle("Choice{subscript:2008} - Choice{subscript:2007}" )  scheme(s2mono) by(t k)  by(, note("") rows(1) title("Panel A: Change in Choices")) 
graph save "`c(pwd)'/Output/graphA.gph", replace

histogram diftotalchoice if returneesample ==1 & (rownumber ==1 |rownumber ==8|rownumber ==15), xlab(-8(2)8) width(1) fraction xtitle("Row{subscript:2008} - Row{subscript:2007}") scheme(s2mono) by(t k)  by(, note("") rows(1) title("Panel B: Change in Switch Points")) 
graph save "`c(pwd)'/Output/graphB.gph", replace



histogram difbetai if returneesample ==1 & rownumber == 1, width(0.1) fraction xtitle("{&beta}{subscript:i, 2008} - {&beta}{subscript:i, 2007}") scheme(s2mono) title("Change in Present Bias, {&beta}{subscript:i}")
graph save "`c(pwd)'/Output/graphC.gph", replace

histogram difdeltai if returneesample ==1 & rownumber == 1, width(0.05) fraction xtitle("{&delta}{subscript:i, 2008} - {&delta}{subscript:i, 2007}")  scheme(s2mono) title("Change in Discount Factor, {&delta}{subscript:i}")
graph save "`c(pwd)'/Output/graphD.gph", replace

graph combine "`c(pwd)'/Output/graphC.gph" "`c(pwd)'/Output/graphD.gph", ycommon title("Panel C: Change in Discounting Parameters") scheme(s2mono)
graph save "`c(pwd)'/Output/graphE.gph", replace


graph combine "`c(pwd)'/Output/graphA.gph" "`c(pwd)'/Output/graphB.gph" "`c(pwd)'/Output/graphE.gph",  scheme(s2mono) rows(3) xsize(8) ysize(11)
graph export "`c(pwd)'/Output/combinedgraph.pdf", replace





