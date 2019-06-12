clear
cd "~/Dropbox/Life cycle paper/JOP submission/Replication files/priming partisanship experiment/"
use "priming partisanship data.dta"

*main experimental results
local controls female white black age age2 educ_a2 educ_a3 educ_a4 income2 income3 income4 income5 ideology2 ideology3 ideology4 ideology5 ideology6 ideology7

eststo clear
ologit strength priming_pol rep ind polXrep polXind 
est store a1
ologit strength priming_pol rep ind polXrep polXind `controls' 
est store a2
 ologit strength priming_pol rep ind polXrep polXind if married_wkids==1
est store a3
ologit strength priming_pol rep ind polXrep polXind `controls' if married_wkids==1
est store a4
ologit strength priming_pol rep ind polXrep polXind if married_wgrown==1
est store a5
ologit strength priming_pol rep ind polXrep polXind `controls' if married_wgrown==1
est store a6
ologit strength priming_pol rep ind polXrep polXind kids_compare primeXkids repXkids indXkids repXX indXX
est store a7
ologit strength priming_pol rep ind polXrep polXind kids_compare primeXkids repXkids indXkids repXX indXX `controls'
est store a8
esttab a1 a2 a3 a4 a5 a6 a7 a8 using "~/Dropbox/Book/Data/NSF Priming Partisanship/Appendix table/NSF_main1.tex", ///
keep(priming_pol rep ind polXrep polXind primeXkids kids_compare repXkids indXkids indXX repXX _cons) ///
star(* .10 ** 0.05) obslast nogaps ///
sfmt(4) se(2) b(2) replace booktabs compress label r2 ///
title("Priming partisanship experimental results")  ///
mtitles("full sample" "children at home" "grown children" "life cycle tests") ///
coeflabels(priming_pol  "Treatment" rep "Republican" ind "Independent" polXrep "Treat * Rep" polXind "Treat * Ind"  kids_compare "Kids (1) vs. Grown (0)" primeXkids "Treat * Kids"  repXkids "Rep * Kids" indXkids "Ind * Kids" repXX "Treat * Rep * Kids" indXX "Treat * Ind * Kids" _cons "Intercept") ///
indicate( "Control variables = female") ///
nonotes
