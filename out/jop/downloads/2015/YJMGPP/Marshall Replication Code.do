*** Replication code for Marshall, "Education and voting Conservative: Evidence from a major schooling reform in Great Britain"

*** 28th July, 2015



****************************** PRELIMINARIES

*** Set the relevant working directory
cd "C:\Dropbox\UK Education and Voting"



*** Log analysis
log using "Replication Results.smcl", replace



*** Load the dataset used throughout the analysis; the creation of the dataset (principally from the British Election Survey) is described in the Online Appendix
use "UK Election Data Replication.dta", clear



*** Restrict to the sample used for the Conservative vote models (return to the broader sample containing turnout too below)
keep if vote_choice_sample==1



****************************** SOCIAL DESIRABILITY BIAS CHECK

*** Proportion of Conservatives matches true vote share well

di (37.9 * 7.96 + 35.8 * 7.56 + 43.9 * 5.95 + 42.4 * 13.01 + 42.2 * 12.27 + 41.9 * 11.80 + 30.7 * 14.37 + 31.7 * 8.62 + 32.4 * 12.32 + 36.1 * 6.15)/100




****************************** SUMMARY STATISTICS

*** Appendix Table 1: Summary statistics
summ con lab lib leave min15 year male white black asian fathermanual age birthyear uni nonmanual conpart perm taxspendself welfaretoofar redist gender_not_too_much econ_values crime_rights_scale leave_europe end_priv_edu abortion_too_far raceequ_too_far inform_std_new if yearat14>=1933 & yearat14<=1961
summ con lab lib leave min15 year male white black asian fathermanual age birthyear uni nonmanual conpart perm taxspendself welfaretoofar redist gender_not_too_much econ_values crime_rights_scale leave_europe end_priv_edu abortion_too_far raceequ_too_far inform_std_new 



****************************** GRAPHICAL ANALYSIS

bysort yearat14 : g weight_14 = _N
bysort yearat14 : egen meancon14 = mean(con)
bysort yearat14 : egen meanconpart14 = mean(conpart)
bysort yearat14 : egen meanleave14 = mean(leave)
bysort yearat14 : egen meantaxspendself14 = mean(taxspendself)
bysort yearat14 : egen meanwelfaretoofar14 = mean(welfaretoofar)
bysort yearat14 : egen meanredist14 = mean(redist)

g leave_l8 = leave<9 if leave!=.
by yearat14, sort : egen meanleave_l8 = mean(leave_l8)
g leave_l9 = leave<10 if leave!=.
by yearat14, sort : egen meanleave_l9 = mean(leave_l9)
g leave_l10 = leave<11 if leave!=.
by yearat14, sort : egen meanleave_l10 = mean(leave_l10)
g leave_l11 = leave<12 if leave!=.
by yearat14, sort : egen meanleave_l11 = mean(leave_l11)
g leave_l12 = leave<13 if leave!=.
by yearat14, sort : egen meanleave_l12 = mean(leave_l12)

*** Figure 1: Trends in school leaving age
twoway (lpoly leave_l8 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs14) clwidth(thick) degree(4)) ///
  (lpoly leave_l8 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs14) clwidth(thick) degree(4)) ///
  (scatter meanleave_l8 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(small) mcolor(gs14)) ///
  (lpoly leave_l9 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs11) clwidth(thick) degree(4)) ///
  (lpoly leave_l9 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs11) clwidth(thick) degree(4)) ///
  (scatter meanleave_l9 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(small) mcolor(gs11)) ///
  (lpoly leave_l10 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs7) clwidth(thick) degree(4)) ///
  (lpoly leave_l10 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs7) clwidth(thick) degree(4)) ///
  (scatter meanleave_l10 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(small) mcolor(gs7)) ///
  (lpoly leave_l11 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(gs5) clwidth(thick) degree(4)) ///
  (lpoly leave_l11 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(gs5) clwidth(thick) degree(4)) ///
  (scatter meanleave_l11 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(small) mcolor(gs5)) ///
  (lpoly leave_l12 yearat14 if yearat14<1947 & yearat14>=1925, lcolor(black) clwidth(thick) degree(4)) ///
  (lpoly leave_l12 yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(black) clwidth(thick) degree(4)) ///
  (scatter meanleave_l12 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(small) mcolor(black)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion leaving) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) xlab(1925(5)1970) ///
  legend(nobox region(fcolor(white) margin(zero) lcolor(white)) lab(3 "Leave before 14") lab(6 "Leave before 15") lab(9 "Leave before 16") lab(12 "Leave before 17") lab(15 "Leave before 18") order(3 6 9 12 15) row(1)) 



*** Figure 3: Reduced form
twoway (lpoly con yearat14 if yearat14>=1925 & yearat14<1947, lcolor(black) clwidth(thick) degree(4)) ///
  (lpoly con yearat14 if yearat14>=1947 & yearat14<=1970, lcolor(black) clwidth(thick) degree(4)) ///
  (scatter meancon14 yearat14 if yearat14>=1925 & yearat14<=1970 [weight=weight_14], msize(small) mcolor(gray)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Conservative vote share) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  yscale(range(.2 .5)) ylabel(.2[0.1]0.5) xlab(1925[5]1970) legend(off) 
    

  
****************************** CONTINUITY TESTS

*** Appendix Figure 1: McCrary test (need to use McCrary's ado file, available here: http://eml.berkeley.edu/~jmccrary/DCdensity/DCdensity.ado)
noisily DCdensity yearat14, breakpoint(1947) b(1) h(5) generate(Xj Yj r0 fhat se_fhat)
drop Xj Yj r0 fhat se_fhat



*** Frandsen test (need to use Frandsen's "rddisttest" ado file, available here: https://economics.byu.edu/frandsen/Pages/Software.aspx)
rddisttest yearat14, threshold(1947) discrete



******************************* CONTINUITY IN OTHER VARIABLES

*** Figure 2: Continuity graphs
capture by yearat14, sort : egen meanyear = mean(year)
twoway (scatter meanyear yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Year) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel A: Survey year, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g1.gph", replace

capture by yearat14, sort : egen meanmale = mean(male)
twoway (scatter meanmale yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel B: Male, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g2.gph", replace

capture by yearat14, sort : egen meanwhite = mean(white)
twoway (scatter meanwhite yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel C: White, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g3.gph", replace

capture by yearat14, sort : egen meanblack = mean(black)
twoway (scatter meanblack yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel D: Black, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g4.gph", replace

capture by yearat14, sort : egen meanasian = mean(asian)
twoway (scatter meanasian yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel E: Asian, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g5.gph", replace

capture by yearat14, sort : egen meanmanual = mean(fathermanual)
twoway (scatter meanmanual yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Proportion) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel F: Father manual/unskilled job, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g6.gph", replace

capture by yearat14, sort : egen meanurate = mean(urate)
twoway (scatter meanurate yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Rate (%)) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel G: National unemployment rate, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g7.gph", replace

twoway (scatter average_earnings yearat14 if yearat14>=1925 & yearat14<=1970, mcolor(black) msize(medsmall)), ///
  graphregion(fcolor(white) lcolor(white)) ylab(,nogrid) ytitle(Index (2000=100)) xtitle(Cohort: year aged 14) xline(1946.5, lcolor(black) lpattern(dash)) ///
  legend(off) title(Panel H: National average earnings, color(black) size(medium)) xlab(1930[10]1970)
graph save Graph "g8.gph", replace

gr combine "g1" "g2" "g3" "g4" "g5" "g6" "g7" "g8", rows(3) cols(3) subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))



*** Appendix Table 2: Continuity tests
rdrobust year yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
rdrobust male yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
rdrobust white yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
rdrobust black yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
rdrobust asian yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
rdrobust fathermanual yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)

* Note: throughout I use the conventional standard robust standard errors reported by the rdrobust command



****************************** LOCAL LINEAR REGRESSION ANALYSIS

*** Table 1: Main estimates
rdrobust leave yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
sum leave if yearat14>=1933 & yearat14<=1961
rdrobust uni yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736)
sum uni if yearat14>=1933 & yearat14<=1961
rdrobust con yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1947) fuzzy(leave) p(1) q(2) kernel(tri) bwselect(IK)
sum leave if yearat14>=1933 & yearat14<=1961
areg con leave male white black asian sagesq-sagequart syearat14 syearat14sq syearat14cub syearat14quart, ro a(survey)
areg con ib9.leave male white black asian sagesq-sagequart syearat14 syearat14sq syearat14cub syearat14quart, ro a(survey)
summ con if e(sample)
rdrobust lab yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736) fuzzy(leave)
sum lib if yearat14>=1933 & yearat14<=1961
rdrobust lib yearat14, c(1947) p(1) q(2) kernel(tri) h(14.736) fuzzy(leave)
sum lib if yearat14>=1933 & yearat14<=1961



****************************** ROBUSTNESS

*** Figure 4: Different bandwidths and kernels
foreach t in "" leave {
foreach k in tri uni {
foreach h of numlist 2/20 {
  rdrobust con yearat14, c(1947) p(1) q(2) kernel(`k') h(`h') fuzzy(`t')
}
}
}

* Note: copy these estimates from the above loop into the Stata data editor for graphical presentation
bandwidth	coef	se	kernel	version
2	0.03754	0.02491	tri	rf
3	0.04136	0.05918	tri	rf
4	0.0514	0.04421	tri	rf
5	0.04571	0.03726	tri	rf
6	0.06067	0.03332	tri	rf
7	0.05625	0.03027	tri	rf
8	0.05527	0.02797	tri	rf
9	0.05384	0.02616	tri	rf
10	0.04974	0.02464	tri	rf
11	0.04821	0.02342	tri	rf
12	0.04757	0.02243	tri	rf
13	0.04632	0.02154	tri	rf
14	0.04458	0.02071	tri	rf
15	0.044	0.02001	tri	rf
16	0.04422	0.0194	tri	rf
17	0.04473	0.01886	tri	rf
18	0.04535	0.01836	tri	rf
19	0.04603	0.01792	tri	rf
20	0.04629	0.0175	tri	rf
2	0.10638	0.07248	tri	years
3	0.1001	0.14867	tri	years
4	0.1436	0.13504	tri	years
5	0.1337	0.11731	tri	years
6	0.15863	0.09722	tri	years
7	0.14487	0.08527	tri	years
8	0.13484	0.07362	tri	years
9	0.12703	0.06588	tri	years
10	0.11941	0.06252	tri	years
11	0.11897	0.06105	tri	years
12	0.11765	0.05849	tri	years
13	0.11688	0.05723	tri	years
14	0.11545	0.05636	tri	years
15	0.11581	0.05534	tri	years
16	0.11797	0.05451	tri	years
17	0.12109	0.05396	tri	years
18	0.12454	0.0535	tri	years
19	0.12914	0.05364	tri	years
20	0.13398	0.05437	tri	years
2	0.04101	0.05905	uni	rf
3	0.05857	0.04281	uni	rf
4	0.0444	0.03554	uni	rf
5	0.07957	0.03167	uni	rf
6	0.05026	0.02847	uni	rf
7	0.05198	0.02628	uni	rf
8	0.04998	0.0245	uni	rf
9	0.03912	0.023	uni	rf
10	0.04352	0.02187	uni	rf
11	0.0451	0.02096	uni	rf
12	0.0414	0.02006	uni	rf
13	0.03776	0.01923	uni	rf
14	0.04149	0.0186	uni	rf
15	0.0452	0.01804	uni	rf
16	0.04724	0.01753	uni	rf
17	0.04872	0.01704	uni	rf
18	0.05003	0.01664	uni	rf
19	0.04824	0.01621	uni	rf
20	0.04896	0.01584	uni	rf
2	0.09971	0.14903	uni	years
3	0.16156	0.13263	uni	years
4	0.12773	0.10899	uni	years
5	0.18438	0.08534	uni	years
6	0.12523	0.07542	uni	years
7	0.11429	0.06073	uni	years
8	0.10872	0.0555	uni	years
9	0.09688	0.0587	uni	years
10	0.11593	0.06117	uni	years
11	0.11173	0.05431	uni	years
12	0.11179	0.05648	uni	years
13	0.10804	0.05709	uni	years
14	0.11737	0.05517	uni	years
15	0.12896	0.05473	uni	years
16	0.13842	0.05523	uni	years
17	0.14521	0.05524	uni	years
18	0.16118	0.0597	uni	years
19	0.17652	0.06758	uni	years
20	0.18333	0.06838	uni	years

g min95 = coef - 1.96 * se
g max95 = coef + 1.96 * se

twoway (scatter coef bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="tri" & version=="rf", mcolor(black)) ///
  (rcap min95 max95 bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="tri" & version=="rf", vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(2(1) 20, valuelabel labsize(small) nogrid) ylab(, nogrid) yline(0, lcolor(black) lpattern(dash)) ///
  xlab(, labsize(small)) ytitle("", size(small)) title("Effect of 1947 reform (triangle)", color(black) size(medium)) xtitle("Bandwidth")
graph save Graph "g1.gph", replace

twoway (scatter coef bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="uni" & version=="rf", mcolor(black)) ///
  (rcap min95 max95 bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="uni" & version=="rf", vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(2(1) 20, valuelabel labsize(small) nogrid) ylab(, nogrid) yline(0, lcolor(black) lpattern(dash)) ///
  xlab(, labsize(small)) ytitle("", size(small)) title("Effect of 1947 reform (rectangular)", color(black) size(medium)) xtitle("Bandwidth")
graph save Graph "g2.gph", replace

twoway (scatter coef bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="tri" & version=="years", mcolor(black)) ///
  (rcap min95 max95 bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="tri" & version=="years", vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(2(1) 20, valuelabel labsize(small) nogrid) ylab(, nogrid) yline(0, lcolor(black) lpattern(dash)) ///
  xlab(, labsize(small)) ytitle("", size(small)) title("Effect of years of schooling (triangle)", color(black) size(medium)) xtitle("Bandwidth")
graph save Graph "g3.gph", replace

twoway (scatter coef bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="uni" & version=="years", mcolor(black)) ///
  (rcap min95 max95 bandwidth if bandwidth>=2 & bandwidth<=20 & kernel=="uni" & version=="years", vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(2(1) 20, valuelabel labsize(small) nogrid) ylab(, nogrid) yline(0, lcolor(black) lpattern(dash)) ///
  xlab(, labsize(small)) ytitle("", size(small)) title("Effect of years of schooling (rectangular)", color(black) size(medium)) xtitle("Bandwidth")
graph save Graph "g4.gph", replace

gr combine "g1" "g2" "g3" "g4", rows(2) cols(2) subtitle(, color(black) fcolor(white) lcolor(white)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
  
drop bandwidth-max95



*** Appendix Table 3: Higher-order polynomials and CCT bias correction
rdrobust con yearat14, c(1947) p(2) q(3) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1947) p(3) q(4) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1947) p(2) q(3) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust con yearat14, c(1947) p(3) q(4) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust con yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(CCT) all
rdrobust con yearat14, c(1947) fuzzy(leave) p(1) q(2) kernel(tri) bwselect(CCT) all



*** Appendix Figure 2: Placebo reforms
rdrobust con yearat14, c(1937) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1938) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1939) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1940) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1941) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1942) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1943) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1944) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1945) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14, c(1946) p(1) q(2) kernel(tri) bwselect(IK)

* Note: copy these estimates from the above loop into the Stata data editor for graphical presentation
placebo	coef	se
1937	-0.00928	0.0202
1938	-0.02086	0.02031
1939	-0.00612	0.02112
1940	-0.00821	0.02073
1941	-0.02798	0.02202
1942	0.00904	0.02146
1943	-0.03114	0.0233
1944	0.0055	0.0218
1945	0.01058	0.02132
1946	0.02654	0.0211

g min95 = coef - 1.96 * se
g max95 = coef + 1.96 * se

twoway (scatter coef placebo, mcolor(black)) ///
  (rcap min95 max95 placebo, vertical lcolor(black)), ///
  legend(off) graphregion(fcolor(white) lcolor(white)) xlab(1937(1)1946, valuelabel labsize(small) nogrid) ylab(, nogrid) yline(0, lcolor(black) lpattern(dash)) ///
  xlab(, labsize(small)) ytitle("", size(small)) xtitle("Placebo reform year") ytitle("Effect of placebo reform on Vote Conservative")

  

*** Appendix Table 4: LFS exclusion restriction violations

preserve

use "LFS Data Replication.dta", clear

rdrobust number_dep_child yearat14 , c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust age_old_dep_child yearat14 , c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust married_once yearat14 , c(1947) p(1) q(2) kernel(tri) bwselect(IK)

restore



****************************** MECHANISMS

*** Table 2: Raising social class, Heterogeneity by age (above 60), Become a Conservative partisan, and Decide before the electoral campaign
rdrobust nonmanual yearat14 if age<60, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust nonmanual yearat14 if age<60, fuzzy(leave) c(1947) p(1) q(2) kernel(tri) bwselect(IK)
sum nonmanual if age<60 & yearat14>=1934 & yearat14<=1960

rdrobust con yearat14 if age<60, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14 if age<60, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
sum con if age<60 & yearat14>=1923 & yearat14<=1969

rdrobust con yearat14 if age>=60, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust con yearat14 if age>=60, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
sum con if age>=60 & yearat14>=1932 & yearat14<=1962

rdrobust conpart yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust conpart yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
sum conpart if yearat14>=1934 & yearat14<=1960

rdrobust perm yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust perm yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
sum perm if yearat14>=1935 & yearat14<=1959



*** Footnote 13 reference
rdrobust conpart yearat14 if age<60, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust conpart yearat14 if age>=60, c(1947) p(1) q(2) kernel(tri) bwselect(IK)



*** Table 3 Panel A: Economic policy preferences
rdrobust taxspendself yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust welfaretoofar yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust redist yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust gender_not_too_much yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
sum gender_not_too_much if yearat14>=1931 & yearat14<=1963
rdrobust econ_values yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
sum econ_values if yearat14>=1930 & yearat14<=1964

rdrobust taxspendself yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust welfaretoofar yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust redist yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust gender_not_too_much yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust econ_values yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)



*** Table 3 Panel B: Non-economic policy preferences
rdrobust crime_rights_scale yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust leave_europe yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust end_priv_edu yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust abortion_too_far yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
sum abortion_too_far if yearat14>=1933 & yearat14<=1961
rdrobust raceequ_too_far yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
sum raceequ_too_far if yearat14>=1927 & yearat14<=1967

rdrobust crime_rights_scale yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust leave_europe yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust end_priv_edu yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust abortion_too_far yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
rdrobust raceequ_too_far yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)



*** Political engagement alternative explanation
rdrobust inform_std_new yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust inform_std_new yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)

preserve
use "UK Election Data Replication.dta", clear
rdrobust turnout yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK)
rdrobust turnout yearat14, c(1947) p(1) q(2) kernel(tri) bwselect(IK) fuzzy(leave)
sum turnout if yearat14>=1929 & yearat14<=1965
sum turnout
restore
