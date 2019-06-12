#delimit;
cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Clean.dta", clear;
set more off;
drop if success !=1;


/*************************************************************************************************************/
/*Appendix E*/

#delimit;
set more off;
foreach x in c14 c19 c28 c34  c48 c51 c54 c58 c62 c68 {;
replace `x'=`x'*100;
};


#delimit;
cibar c14, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Fire Prevention") xtitle("n=786", size(medsmall)));
graph save c14.gph, replace;

#delimit;
cibar c19, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Safety Signs") xtitle("n=468", size(medsmall)));
graph save c19.gph, replace;

#delimit;
cibar c51, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Fuses/Sockets") xtitle("n=598", size(medsmall)));
graph save c51.gph, replace;

#delimit;
cibar c48, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Chemical Transport") xtitle("n=699", size(medsmall)));
graph save c48.gph, replace;

#delimit;
cibar c62, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Welding Equipment") xtitle("n=263", size(medsmall)));
graph save c62.gph, replace;

#delimit;
cibar c28, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Lightning Prevention") xtitle("n=689", size(medsmall)));
graph save c28.gph, replace;

#delimit;
cibar c34, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Washing Facility") xtitle("n=689", size(medsmall)));
graph save c34.gph, replace;

#delimit;
cibar c54, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Lighting System") xtitle("n=259", size(medsmall)));
graph save c54.gph, replace;

#delimit;
cibar c58, level(90) over1(group) graphopts(scheme(s1mono) legend(off) ytitle("") title("Mixing Equipment") xtitle("n=373", size(medsmall)));
graph save c58.gph, replace;


#delimit;
cibar c68, level(90) over1(group) graphopts(scheme(s1mono) legend(rows(3) size(small) position(12) ring(0)) ytitle("") title("Corrosive Chemicals") xtitle("n=301", size(medsmall)));
graph save c68.gph, replace;




#delimit;
graph combine c14.gph c19.gph c28.gph c34.gph  c48.gph , xcommon ycommon imargin(tiny) rows(1) cols(5) title("", size(large)) subtitle("Average Compliance (%)", size(medium) position(9) orientation(vertical) margin(medsmall)) scheme(s1mono);
graph save easy.gph, replace;

#delimit;
graph combine c51.gph  c54.gph c58.gph c62.gph  c68.gph, xcommon ycommon imargin(tiny) rows(1) cols(5) title("", size(large)) subtitle("Average Compliance (%)", size(medium) position(9) orientation(vertical) margin(medsmall)) scheme(s1mono);
graph save hard.gph, replace;

#delimit;
graph combine easy.gph hard.gph, rows(2) imargin(vsmall) note("90% Confidence Intervals; n=Eligible Firms", size(vsmall)) scheme(s1mono)
	title("Appendix B: Compliance by Clause", size(large) margin(large) color(black));
graph save "Figures\AppendixE_clause.gph", replace;
graph export "Figures\AppendixE_clause.pdf", as(pdf) replace;



/*************************************************************************************************************/
/*Appendix F*/

/*Appendix - Individual Regressions*/

#delimit;
xi: reg c14 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse) replace;
xi: reg c19 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c28 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c34 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c48 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c51 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c54 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c58 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c62 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c68 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression", tdec(3) bdec(3) e(N_clust rmse) excel;



#delimit;
set more off;
xi: dprobit c14 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll) replace;
xi: dprobit c19 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c28 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c34 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c48 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c51 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c54 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c58 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c62 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll);
xi: dprobit c68 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_dprobit", tdec(3) bdec(3) e(N_clust pbar ll) excel;


#delimit;
xi: reg c14 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse) replace;
xi: reg c19 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c28 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c34 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c48 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c51 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c54 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c58 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c62 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse);
xi: reg c68 treatment1 treatment2 female  r1_emp  hanoi i.r1_catsector if district_acces>.8, cluster(fe_provcatsector);
outreg2 using "Tables\AppendixF_regression_dis", tdec(3) bdec(3) e(N_clust rmse) excel;











































