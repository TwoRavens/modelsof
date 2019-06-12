eststo clear
reg imm treat_relig treat_sec if white==1 & born_again==1, r
est store a1
reg imm treat_relig treat_sec if born_again==0, r
est store a2
qui: reg imm treat_relig treat_sec if main==1, r
est store a3
qui: reg imm treat_relig treat_sec if none==1, r
est store a4

esttab a1 a2 a3 a4 using "~/Dropbox/Immigration/JOP Results/SSI/tables/radio_results_otherrels.tex", ///
star({*} .10 {**} 0.05) obslast nogaps ///
sfmt(4) se(2) b(2) replace booktabs compress label ///
mtitles("White born-again Christians" "Non born agains (all religions)" "Christians who are not born again" "Religious non-identifiers") ///
coeflabels(treat_relig "Religious message" ///
treat_sec "Secular message" ///
  _cons "Intercept") ///
title("Experimental treatment effects on different religious groups") 

