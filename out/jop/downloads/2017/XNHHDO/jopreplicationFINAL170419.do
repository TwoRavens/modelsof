/*JOP Replication File
Electoral Cycle Fluctuations in Partisanship: Global Evidence from 86 Countries
Kristin Michelith and Stephen Utych*/


cd "C:\Users\stephenutych\Dropbox\kristin.michelitch\Global"

*Bring in Data
use jopdataFINAL.dta, clear

 
/*Table 1 - Proximity to an Election and the Presence and Intensity of Partisanship*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female  age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est store m1
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
est store m2
esttab m1 m2 using "table1_161018.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)  keep(distance_pct c.distance_pct#c.distance_pct female age urban high_ed)  pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*Figure 2 - Predicted Probability of PID Over Elecotral Cycle*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
margins, at(distance_pct=(.05(.05)1)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.40 0.65)) ylabel(.40(.05).65) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export globalproximity_direct150526.pdf, replace

/*Table 2 - Predicted Probabilities of Partisanship Closeness over the Electoral Cycle*/

ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(0)) atmeans predict(outcome(0)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(0)) atmeans predict(outcome(1)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(0)) atmeans predict(outcome(2)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(0)) atmeans predict(outcome(3)) post


ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(1)) atmeans predict(outcome(0)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(1)) atmeans predict(outcome(1)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(1)) atmeans predict(outcome(2)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(1)) atmeans predict(outcome(3)) post


ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(.5)) atmeans predict(outcome(0)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(.5)) atmeans predict(outcome(1)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(.5)) atmeans predict(outcome(2)) post
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
margins, at(distance_pct=(.5)) atmeans predict(outcome(3)) post

/*Figure 3 - Predicted Probabilities of Partisanship over the Electoral Cycle*/

logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11 female age urban high_ed  [pweight=final_weight] , cluster(newname)  
margins, at(distance_pct=(.05(.05)1) we_a11=(1.59)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export low_a1.pdf, replace

logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11 female age urban high_ed  [pweight=final_weight] , cluster(newname)  
margins, at(distance_pct=(.05(.05)1) we_a11=(2.59)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export high_a1.pdf, replace

/*Figure 4 - Position in the Electoral Cycle on the Predicted Probability of Partisanship with HDI
High and Low*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.un_hdi c.distance_pct#c.un_hdi c.distance_pct#c.distance_pct#c.un_hdi female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 

margins, at(distance_pct=(.05(.05)1) un_hdi =(.528)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export low_hdi.pdf, replace

margins, at(distance_pct=(.05(.05)1) un_hdi =(.85)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export high_hdi.pdf, replace

margins, at(distance_pct=(0 .05 .5 1) un_hdi =(.528)) l(90)
margins, at(distance_pct=(0 .05 .5 1) un_hdi =(.85)) l(90)


/*Appendix Analyses*/

/*Figure 1.1 - Histograms of DV*/
hist pty_close2cat,  discrete width(1) percent xtitle(Binary Partisanship Variable) xscale(range(0 1)) xlabel(0(1)1) title(" ") scheme(sj) graphregion(color(white))
graph export hist_closeness_binary_150727.pdf, replace

histogram pid2, discrete width(1) start(0) percent xtitle(Categorical Partisanship Variable) xscale(range(0 3)) xscale(noextend nofextend) xlabel(0(1)3) title(" ") scheme(sj) graphregion(color(white))
graph export hist_closeness_cat_150727.pdf, replace

/*Figure 1.3 - Variation in Temporal Proximity to the Last and Next Election*/
gen distance_pctgraph=distance_pct*100
vioplot distance_pctgraph, nofill horizontal title("") ytitle("") xtitle("Proximity (Percent Time Through Cycle) ") xlabel(0(10)100) xsc(r(0 100)) graphregion(color(white)) scheme(sj) 
graph export Vioplot_Proximity_150727.pdf, replace

/*Figure 5 - Marginal Effects Graph*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
 margins, dydx(distance_pct) at(distance_pct=(.05(.05)1))
 marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(-.5 .5)) ylabel(-.5(.1).5) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Marginal Effect of Temporal Proximity to an Election) ti("") scheme(sj)
 graph export margins_main.pdf, replace
 
/*Figure 6 - Lowess*/
lowess pty_close2cat distance_pct

/*3.2 - Table 1 - Multilevel Model*/

meqrlogit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed || ctryrd:
est sto mlm1
mixed pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed || ctryrd:
est sto mlm1a
esttab mlm1 mlm1a using "mlm160914.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*3.3 - Alternative Weighting*/
/*No Weights - Table 2*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88, nocon cluster(ctryrd) 
est sto uw1
margins, at(distance_pct=(0(.1)1)) l(90)

logit pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88, nocon cluster(ctryrd) 
est sto uw2
esttab uw1 uw2 using "unweighted160916.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*Survey and Population Weights - Table 3*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=pop_weight], nocon cluster(ctryrd) 
est sto pw1
margins, at(distance_pct=(0(.1)1)) l(90)

logit pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=pop_weight], nocon cluster(ctryrd) 
est sto pw2
esttab pw1 pw2 using "pop_weight161018.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)


/*Survey and Survey Round Weights - Table 4*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=rweight], nocon cluster(ctryrd) 
est sto pw1
margins, at(distance_pct=(0(.1)1)) l(90)

logit pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=rweight], nocon cluster(ctryrd) 
est sto pw2
esttab pw1 pw2 using "round_weight161018.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*Only Round Weights - Table 5*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=1/num_rounds], nocon cluster(ctryrd) 
est sto pw1
margins, at(distance_pct=(0(.1)1)) l(90)

logit pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=1/num_rounds], nocon cluster(ctryrd) 
est sto pw2
esttab pw1 pw2 using "raw_round_weight161018.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*Survey, Round and Population Weights - Table 6*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=pop_weight*(1/num_rounds)], nocon cluster(ctryrd) 
est sto pw1
margins, at(distance_pct=(0(.1)1)) l(90)

logit pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=pop_weight*(1/num_rounds)], nocon cluster(ctryrd) 
est sto pw2
esttab pw1 pw2 using "all_weight161018.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*3.4 - Dropping based on Number of Rounds*/

/*Table 7 - Only 3+, 4+ or 5+ rounds, binary DV*/
preserve
keep if num_rounds>2
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est store m1
keep if num_rounds>3
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est store m2
keep if num_rounds>4
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est store m3
esttab m1 m2 m3 using "proximity_table_roundexclusion_160225.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proximity Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons "Constant")  keep(distance_pct c.distance_pct#c.distance_pct female age urban high_ed)  pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)
restore

/*Table 8 - Only 3+, 4+ or 5+ rounds, categorical DV*/
preserve
keep if num_rounds>2
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd)
est store m4
keep if num_rounds>3
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd)
est store m5
keep if num_rounds>4
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd)
est store m6
esttab m4 m5 m6 using "proximitycloseness_table_roundexclusion_160225.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proximity Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons "Constant")  keep(distance_pct c.distance_pct#c.distance_pct female age urban high_ed)  pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)
restore 

/*3.5 - Dropping Elections whose De Jure Timing was not De Facto Respected - Table 9*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 if nelda_6!=1 [pweight=final_weight], nocon cluster(ctryrd) 
est store m1
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 if nelda_6!=1 [pweight=final_weight], cluster(ctryrd) 
est store m2
esttab m1 m2 using "proximity_table_electionsontime160225.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(cycle_year "Cycle Length (Years)" distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proximity Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)  keep(distance_pct c.distance_pct#c.distance_pct female age urban high_ed cycle_year)  pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed cycle_year)

/*3.6 - De Jure Fixed-Term Elections Only - Table 10*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed c1-c88 if v2exdfdshs_ord==0 [pweight=final_weight], nocon cluster(ctryrd) 
est store m1
ologit pid2 c.distance_pct c.distance_pct#c.distance_pct  female age urban high_ed c1-c88 if v2exdfdshs_ord==0  [pweight=final_weight], cluster(ctryrd) 
est store m2
esttab m1 m2 using "dissolve170330.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proximity Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)  keep(distance_pct c.distance_pct#c.distance_pct female age urban high_ed)  pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)


/*3.7 - Dropping Legislative Elections in Presidential Systems - Table 11*/
logit pty_close2cat c.distance_p c.distance_p#c.distance_p female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
margins, at(distance_p=(.0(.1)1)) l(90)
est store m1
ologit pid2 c.distance_p c.distance_p#c.distance_p  female age urban high_ed c1-c88  [pweight=final_weight], cluster(ctryrd) 
est store m2
esttab m1 m2 using "pres_dist170330.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proximity Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)  keep(distance_p c.distance_p#c.distance_p female age urban high_ed)  pr2 




/*4 - Party Permanence*/
/*Table 12 - Proximity to an Election and Probability of Identifying as Partisan*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11 female age urban high_ed  [pweight=final_weight] , cluster(newname)  
est store a1
esttab a1 using "table3_161018.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons "Constant")   pr2 order (distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11  female age urban high_ed)

/*Figure 7 - Variation in Permanence of Party Presence*/
vioplot we_a11, nofill horizontal title("") ytitle(" ") xtitle("Maintaining Offices") xlabel(0(1)3) ylabel(none) xsc(r(0 3)) graphregion(color(white)) scheme(sj) 
graph export maintain_office_vplot.pdf, replace

/*Figure 9 - Low and High Party Permanence: Marginal Effect of the Position in the Electoral Cycle on the
Probability of Partisanship*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11 female age urban high_ed  [pweight=final_weight] , cluster(newname)  
 margins, dydx(distance_pct) at(distance_pct=(.05(.05)1) we_a11=(1.59))
 marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(-.5 .5)) ylabel(-.5(.1).5) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Marginal Effect of Temporal Proximity to an Election) ti("") scheme(sj)
 graph export margins_permlow.pdf, replace

logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11 female age urban high_ed  [pweight=final_weight] , cluster(newname)  
 margins, dydx(distance_pct) at(distance_pct=(.05(.05)1) we_a11=(2.59))
 marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(-.5 .5)) ylabel(-.5(.1).5) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Marginal Effect of Temporal Proximity to an Election) ti("") scheme(sj)
 graph export margins_permhigh.pdf, replace
 

/*Table 13 - Excluding Countries with High Expert Disagreement on Party Presence*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11 female age urban high_ed if skip!=1  [pweight=final_weight] , cluster(newname)  
est store a1
esttab a1 using "remove_hi_sd170413.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct c.we_a11 c.distance_pct#c.we_a11 c.distance_pct#c.distance_pct#c.we_a11  female age urban high_ed)



/*5 Country-Level Controls and Moderators*/

/*Table 14 - Country Level Controls*/
*Comp
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct compete100 female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto comp
*Dem Age
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct logcda female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto cda
*HDI
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct un_hdi female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto hdi
*Compulsory
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct compul female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto compul
*Effective parties
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct eff_part99 female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto eff
*Carey-Shugart
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct avg_cs female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto cs
*Cycle Length
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed cycle_year c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto cycle
*Electoral Democracy
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed v2x_polyarchy c1-c88 [pweight=final_weight], nocon cluster(ctryrd)
est sto edem
*Average Party Age
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct female age urban high_ed average_age c1-c88 [pweight=final_weight], nocon cluster(ctryrd)
est sto age1
*Kitchen sink
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct compete100 logcda un_hdi compul eff_part99 avg_cs cycle_year v2x_polyarchy average_age female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto all
esttab cda hdi compul eff cs comp cycle edem age1 all  using "controls170413.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" compete100 "Competitiveness" logcda "Age of Democracy (Logged)" un_hdi "HDI" compul "Compulsory Voting" eff_part99 "Effective # of Parties" v2psprlnks_ord "Party Linkages" prop_sys99 "Proportional System" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*Table 15a - Country Level Moderators*/
*Competitiveness
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.compete100 c.distance_pct#c.compete100 c.distance_pct#c.distance_pct#c.compete100 female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto comp
*Dem Age (logged)
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.logcda c.distance_pct#c.logcda c.distance_pct#c.distance_pct#c.logcda female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto cda
*HDI
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.un_hdi c.distance_pct#c.un_hdi c.distance_pct#c.distance_pct#c.un_hdi female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto hdi
*Compulsory voting
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.compul c.distance_pct#c.compul c.distance_pct#c.distance_pct#c.compul female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto compul
*effective # of parties - exclude fixed, does not vary over country
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.eff_part99 c.distance_pct#c.eff_part99 c.distance_pct#c.distance_pct#c.eff_part99 female age urban high_ed [pweight=final_weight], nocon cluster(ctryrd) 
est sto eff  
*Carey Shugart - Exclude fixed bc does not vary over country
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.avg_cs c.distance_pct#c.avg_cs c.distance_pct#c.distance_pct#c.avg_cs female age urban high_ed  [pweight=final_weight], nocon cluster(ctryrd) 
est sto cs99
*Cycle Length
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.cycle_year c.distance_pct#c.cycle_year c.distance_pct#c.distance_pct#c.cycle_year female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto cycle
esttab cda hdi compul eff cs99 comp cycle  using "moderators170413a.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" c.compete100 "Competitiveness" c.logcda "Age of Democracy (Logged)" c.un_hdi "HDI" c.compul "Compulsory Voting" c.eff_part99 "Effective # of Parties" c.v2psprlnks_ord "Party Linkages" c.prop_sys99 "Proportional System" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*Table 15b - Country Level Moderators*/

*Electoral Democracy
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.v2x_polyarchy c.v2x_polyarchy#c.distance_pct  c.distance_pct#c.distance_pct#c.v2x_polyarchy female age urban high_ed c1-c88 [pweight=final_weight] , nocon cluster(ctryrd) 
est sto edem
*Average Party Age
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.average_age c.distance_pct#c.average_age c.distance_pct#c.distance_pct#c.average_age female age urban high_ed [pweight=final_weight] , cluster(newname)  
est store age1
esttab edem age1 using "moderators170413b.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" c.compete100 "Competitiveness" c.logcda "Age of Democracy (Logged)" c.un_hdi "HDI" c.compul "Compulsory Voting" c.eff_part99 "Effective # of Parties" c.v2psprlnks_ord "Party Linkages" c.prop_sys99 "Proportional System" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)



/*6 - Second Order Elections*/

/*Table 16 - All Second Order as Qualifying Dates*/
logit pty_close2cat c.distance_pct_ss c.distance_pct_ss#c.distance_pct_ss female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto dir1
ologit pid2 c.distance_pct_ss c.distance_pct_ss#c.distance_pct_ss female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
est sto ord
esttab dir1 ord using "newdates.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct female age urban high_ed)

/*Table 17 - Include only Supranational (Euro Parliament) as Qualifying Dates*/
logit pty_close2cat c.distance_pct_e c.distance_pct_e#c.distance_pct_e female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto dire
ologit pid2 c.distance_pct_e c.distance_pct_e#c.distance_pct_e female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
est sto orde
esttab dire orde using "newdates_supra.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct female age urban high_ed)

/*Table 18 - Include only Subnational Elections as Qualifying Dates*/
logit pty_close2cat c.distance_pct_s c.distance_pct_s#c.distance_pct_s female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto dirs
ologit pid2 c.distance_pct_s c.distance_pct_s#c.distance_pct_s female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
est sto ords
esttab dirs ords using "newdates_sub.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct female age urban high_ed)

/*Table 19 - Second Order Dates included on if Second Order powerful*/
logit pty_close2cat c.distance_pct_mix c.distance_pct_mix#c.distance_pct_mix female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto mix1
ologit pid2 c.distance_pct_mix c.distance_pct_mix#c.distance_pct_mix female age urban high_ed c1-c88 [pweight=final_weight], cluster(ctryrd) 
est sto mix2
esttab mix1 mix2 using "subnational_power161110.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct_mix "Electoral Proximity" c.distance_pct_mix#c.distance_pct_mix "Electoral Proxmitiy Squared" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant) order (c.distance_pct_mix c.distance_pct_mix#c.distance_pct_mix female age urban high_ed)

/*Figure 10 - Position in the Electoral Cycle on the Predicted Probability of Partisanship with Different Inclusion
of Election Events*/
*All Second Order
logit pty_close2cat c.distance_pct_ss c.distance_pct_ss#c.distance_pct_ss female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
margins, at(distance_pct_ss=(.05(.05)1)) l(90)
marginsplot, x(distance_pct_ss) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export allsecond_direct.pdf, replace

*Supranational Only
logit pty_close2cat c.distance_pct_e c.distance_pct_e#c.distance_pct_e female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
margins, at(distance_pct_e=(.05(.05)1)) l(90)
marginsplot, x(distance_pct_e) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export supra_direct.pdf, replace

*Subnational Only
logit pty_close2cat c.distance_pct_s c.distance_pct_s#c.distance_pct_s female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
margins, at(distance_pct_s=(.05(.05)1)) l(90)
marginsplot, x(distance_pct_s) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export sub_direct.pdf, replace

*Second Order if Important Only
logit pty_close2cat c.distance_pct_mix c.distance_pct_mix#c.distance_pct_mix female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
margins, at(distance_pct_mix=(.05(.05)1)) l(90)
marginsplot, x(distance_pct_mix) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export sub_important_direct.pdf, replace

/*6.3 - Regional and Local Authority Indicies*/
/*Figure 11 - RAI Moderator Graphs*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.n_RAI c.distance_pct#c.n_RAI c.distance_pct#c.distance_pct#c.n_RAI female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
*1 sd below mean
margins, at(distance_pct=(.05(.05)1) n_RAI =(1.63)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export low_rai.pdf, replace
*1 sd above mean
margins, at(distance_pct=(.05(.05)1) n_RAI =(21.83)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export high_rai.pdf, replace


/*Table 20 - Subnat Authority Moderator*/
*RAI - Missing after 2010
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.n_RAI c.distance_pct#c.n_RAI c.distance_pct#c.distance_pct#c.n_RAI female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto rai
*Regional Govt Subordinate
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.v2elrgpwr_ord c.distance_pct#c.v2elrgpwr_ord c.distance_pct#c.distance_pct#c.v2elrgpwr_ord female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto rsub
*Local Govt Subordinate
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.v2ellocpwr_ord c.distance_pct#c.v2ellocpwr_ord c.distance_pct#c.distance_pct#c.v2ellocpwr_ord female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto lsub
*Regional Govt Power Index
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.v2xel_regelec c.distance_pct#c.v2xel_regelec c.distance_pct#c.distance_pct#c.v2xel_regelec female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto rind
*Local Govt Power Index
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.v2xel_locelec c.distance_pct#c.v2xel_locelec c.distance_pct#c.distance_pct#c.v2xel_locelec female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto lind
esttab rai rsub lsub rind lind using "rai160929.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" c.distance_pct#c.distance_pct "Electoral Proxmitiy Squared" compete100 "Competitiveness" logcda "Age of Democracy (Logged)" un_hdi "HDI" compul "Compulsory Voting" eff_part99 "Effective # of Parties" v2psprlnks_ord "Party Linkages" prop_sys99 "Proportional System" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct c.distance_pct#c.distance_pct female age urban high_ed)

/*6.4 - Existence of Second Order Elections as Moderator*/
/*Figure 12 - Fluctuation Moderated by Supranational Elections Figure*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.supranat c.distance_pct#c.supranat c.distance_pct#c.distance_pct#c.supranat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
*Present
margins, at(distance_pct=(.05(.05)1) supranat=(1)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export supra_1.pdf, replace
*Not
margins, at(distance_pct=(.05(.05)1) supranat=(0)) l(90)
marginsplot, x(distance_pct) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export nosupra_1.pdf, replace

/*Table 21 - Moderation by 2nd Order Elections*/
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.subnat c.distance_pct#c.subnat c.distance_pct#c.distance_pct#c.subnat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto sub1
logit pty_close2cat c.distance_pct_s c.distance_pct_s#c.distance_pct_s c.subnat c.distance_pct_s#c.subnat c.distance_pct_s#c.distance_pct_s#c.subnat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto sub2
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.supranat c.distance_pct#c.supranat c.distance_pct#c.distance_pct#c.supranat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto sup1
logit pty_close2cat c.distance_pct_e c.distance_pct_e#c.distance_pct_e c.supranat c.distance_pct_e#c.supranat c.distance_pct_e#c.distance_pct_e#c.supranat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto sup2
logit pty_close2cat c.distance_pct c.distance_pct#c.distance_pct c.secondo c.distance_pct#c.secondo c.distance_pct#c.distance_pct#c.secondo female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto sec1
logit pty_close2cat c.distance_pct_ss c.distance_pct_ss#c.distance_pct_ss c.secondo c.distance_pct_ss#c.secondo c.distance_pct_ss#c.distance_pct_ss#c.secondo female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
est sto sec2
esttab sub1 sub2 sup1 sup2 sec1 sec2 using "moderator_secorder_161028.tex",  replace style(tex) cells(b(star fmt(2)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) legend label varlabels(distance_pct "Electoral Proximity" female "Female" age "Age" urban "Urban" high_ed "Education Above Country Mean" _cons constant)   pr2 order (distance_pct female age urban high_ed)


/*Figure 13 - Off Cycle Subnational Moderation*/
logit pty_close2cat c.distance_pct_s c.distance_pct_s#c.distance_pct_s c.subnat c.distance_pct_s#c.subnat c.distance_pct_s#c.distance_pct_s#c.subnat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
*Present
margins, at(distance_pct_s=(.05(.05)1) subnat=(1)) l(90)
marginsplot, x(distance_pct_s) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export sub_2.pdf, replace
*Not
margins, at(distance_pct_s=(.05(.05)1) subnat=(0)) l(90)
marginsplot, x(distance_pct_s) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export nosub_2.pdf, replace

/*Figure 14 - Off Cycle Supra Moderation*/
logit pty_close2cat c.distance_pct_e c.distance_pct_e#c.distance_pct_e c.supranat c.distance_pct_e#c.supranat c.distance_pct_e#c.distance_pct_e#c.supranat female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
*Present
margins, at(distance_pct_e=(.05(.05)1) supranat=(1)) l(90)
marginsplot, x(distance_pct_e) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export supra_2.pdf, replace
*Not
margins, at(distance_pct_e=(.05(.05)1) supranat=(0)) l(90)
marginsplot, x(distance_pct_e) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export nosupra_2.pdf, replace

/*Figure 15 - Off Cycle Second Order*/
logit pty_close2cat c.distance_pct_ss c.distance_pct_ss#c.distance_pct_ss c.secondo c.distance_pct_ss#c.secondo c.distance_pct_ss#c.distance_pct_ss#c.secondo female age urban high_ed c1-c88 [pweight=final_weight], nocon cluster(ctryrd) 
*Present
margins, at(distance_pct_ss=(.05(.05)1) secondo =(1)) l(90)
marginsplot, x(distance_pct_ss) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export second_2.pdf, replace
*Not
margins, at(distance_pct_ss=(.05(.05)1) secondo =(0)) l(90)
marginsplot, x(distance_pct_ss) recast(line) ciopts(recast(rarea) fi(inten40))  yscale(range(0.30 0.70)) ylabel(.30(.05).70) xlabel(0(.1)1) graphregion(color(white)) xtitle(Proximity to Election) ytitle(Probability of Identifying as Partisan) ti("") scheme(sj)
graph export nosecond_2.pdf, replace




/*Figure 1.2 - Variation in Pct Partisan*/
use countryJOPdataFINAL.dta, clear

gen gph_pct=pct_partisan*100
vioplot gph_pct if pct_partisan<1, nofill horizontal title("") ytitle("") xtitle("Percent Partisan") xlabel(0(10)100) xscale(range(0 100)) graphregion(color(white)) scheme(sj) 
graph save Vioplot_PID_country_150723.gph, replace
graph export Vioplot_PID_country_150723.pdf, replace

/*Figure 1.4 - Number of Survey Rounds*/
histogram num_rounds, discrete width(1) frequency ytitle(Number of Countries) xtitle(Number of Rounds) xscale(range(1 7)) xlabel(1(1)7) xmtick(1(1)7) title() scheme(sj) graphregion(color(white)) addlabel
graph export number_rounds_150724.pdf, replace



