set more off
*version 14
local stick "C:\Users\Andy baker\OneDrive - University of Colorado at Boulder Office 365"
capture log close
log using "`stick'\My Documents\Research\Paper PID Experiment\Brazil\JOP IRT Brazil Results.log", text replace
use "`stick'\Data\Brazil\BEPS 2014\BEPS 2014 Merged Data v3.dta", clear
*use "C:\Users\Andy baker\OneDrive - University of Colorado at Boulder Office 365\Data\Brazil\BEPS 2014\BEPS 2014 Merged Data v3.dta", clear

xtdes

fillin idtelefone wave
sort idtelefone wave

recode _fillin (1=0) (0=1), gen(respond)


*I. PARTY ID MEASURES
	*1: Working with the "sympathy" variable that was asked of everyone in every wave
recode vb10 (.a=.) (.b=.) (.c=.)
recode vb11 (.a=.) (.b=.) (.c=.)
replace vb11=. if vb10==.

gen symp=vb11
replace symp=0 if vb10==2
replace symp=. if vb10==.

xi, noomit: ci proportions i.symp if wave==1

recode vb10 (2=1) (1=0) (.=.), gen(symp_indep)

recode vb11 (1501=1) (else=0), gen(symp_pt)
recode vb11 (1502=1) (else=0), gen(symp_pmdb)
recode vb11 (1503=1) (else=0), gen(symp_psdb)
recode vb11 (1504=1) (else=0), gen(symp_psb)
recode vb11 (1505=1) (else=0), gen(symp_dem)
recode vb11 (1506=1) (else=0), gen(symp_ptb)
recode vb11 (1507=1) (else=0), gen(symp_psol)
recode vb11 (1508=1) (else=0), gen(symp_pv)
recode vb11 (1509=1) (else=0), gen(symp_pdt)

replace symp_indep=. if vb10==. 
replace symp_pt=. if vb10==. 
replace symp_pmdb=. if vb10==. 
replace symp_psdb=. if vb10==. 
replace symp_psb=. if vb10==. 
replace symp_dem=. if vb10==. 
replace symp_ptb=. if vb10==. 
replace symp_psol=. if vb10==.
replace symp_pv=. if vb10==. 
replace symp_pdt=. if vb10==.

replace symp_indep=. if vb11==. & vb10==1 
replace symp_pt=. if vb11==. & vb10==1 
replace symp_pmdb=. if vb11==. & vb10==1 
replace symp_psdb=. if vb11==. & vb10==1 
replace symp_psb=. if vb11==. & vb10==1 
replace symp_dem=. if vb11==. & vb10==1 
replace symp_ptb=. if vb11==. & vb10==1 
replace symp_psol=. if vb11==. & vb10==1
replace symp_pv=. if vb11==.  & vb10==1
replace symp_pdt=. if vb11==. & vb10==1

label define pid 0 "Independent" 1501 "PT" 1502 "PMDB" 1503 "PSDB" 1504 "PSB" 1505 "DEM" 1506 "PTB" 1507 "PSOL" 1508 "PV" 1509 "PDT" 1510 "Other"
label values symp pid

tab1 symp* if wave==1
tab1 symp* if wave==6

recode symp_indep (1=0) (0=1), gen(symp_partisan)

	*2: Working with the "preference" variable, treatment A
rename vb10expa exp_1
recode exp_1 (.a=.) (.b=.) (.c=.) (77=0), gen(preference)
tab exp_1 if wave==1
tab symp preference
label values preference pid

xi, noomit: ci proportions i.preference if wave==1

recode preference (0=1) (else=0), gen(pref_indep)
recode preference (1501=1) (else=0), gen(pref_pt)
recode preference (1502=1) (else=0), gen(pref_pmdb)
recode preference (1503=1) (else=0), gen(pref_psdb)
recode preference (1504=1) (else=0), gen(pref_psb)
recode preference (1505=1) (else=0), gen(pref_dem)
recode preference (1506=1) (else=0), gen(pref_ptb)
recode preference (1507=1) (else=0), gen(pref_psol)
recode preference (1508=1) (else=0), gen(pref_pv)
recode preference (1509=1) (else=0), gen(pref_pdt)

replace pref_indep=. if preference==. 
replace pref_pt=. if preference==. 
replace pref_pmdb=. if preference==. 
replace pref_psdb=. if preference==. 
replace pref_psb=. if preference==. 
replace pref_dem=. if preference==. 
replace pref_ptb=. if preference==. 
replace pref_psol=. if preference==.
replace pref_pv=. if preference==. 
replace pref_pdt=. if preference==.

recode pref_indep (1=0) (0=1), gen(pref_partisan)

	*3: Working with the "identity" variable, treatment B
rename vb10expb exp_2
recode exp_2 (.a=.) (.b=.) (.c=.) (77=0), gen(identity)
tab identity if wave==1
tab symp identity
label values identity pid

xi, noomit: ci proportions i.identity if wave==1

recode identity (0=1) (else=0), gen(iden_indep)
recode identity (1501=1) (else=0) , gen(iden_pt)
recode identity (1502=1) (else=0), gen(iden_pmdb)
recode identity (1503=1) (else=0), gen(iden_psdb)
recode identity (1504=1) (else=0), gen(iden_psb)
recode identity (1505=1) (else=0), gen(iden_dem)
recode identity (1506=1) (else=0), gen(iden_ptb)
recode identity (1507=1) (else=0), gen(iden_psol)
recode identity (1508=1) (else=0), gen(iden_pv)
recode identity (1509=1) (else=0), gen(iden_pdt)

replace iden_indep=. if identity==. 
replace iden_pt=. if identity==. 
replace iden_pmdb=. if identity==. 
replace iden_psdb=. if identity==. 
replace iden_psb=. if identity==. 
replace iden_dem=. if identity==. 
replace iden_ptb=. if identity==. 
replace iden_psol=. if identity==.
replace iden_pv=. if identity==. 
replace iden_pdt=. if identity==.

recode iden_indep (1=0) (0=1), gen(iden_partisan)

	*4: Working with the "way of thinking" variable, treatment C
rename vb10expc1 exp_3a
rename vb10expc2 exp_3b
recode exp_3a (.a=.) (.b=.) (.c=.)
recode exp_3b (.a=.) (.b=.) (.c=.)
gen thinking=exp_3b
replace thinking=0 if exp_3a==2

label values thinking pid

xi, noomit: ci proportions i.thinking if wave==1

recode thinking (0=1) (else=0), gen(think_indep)
recode thinking (1501=1) (else=0), gen(think_pt)
recode thinking (1502=1) (else=0), gen(think_pmdb)
recode thinking (1503=1) (else=0), gen(think_psdb)
recode thinking (1504=1) (else=0), gen(think_psb)
recode thinking (1505=1) (else=0), gen(think_dem)
recode thinking (1506=1) (else=0), gen(think_ptb)
recode thinking (1507=1) (else=0), gen(think_psol)
recode thinking (1508=1) (else=0), gen(think_pv)
recode thinking (1509=1) (else=0), gen(think_pdt)

replace think_indep=. if thinking==. 
replace think_pt=. if thinking==. 
replace think_pmdb=. if thinking==. 
replace think_psdb=. if thinking==. 
replace think_psb=. if thinking==. 
replace think_dem=. if thinking==. 
replace think_ptb=. if thinking==. 
replace think_psol=. if thinking==.
replace think_pv=. if thinking==. 
replace think_pdt=. if thinking==.

recode think_indep (1=0) (0=1), gen(think_partisan)

*test-retest
gen l5pref_pt=l5.pref_pt
gen l5pref_psdb=l5.pref_psdb
polychoric l5pref_pt pref_pt if wave==6
polychoric l5pref_psdb pref_psdb if wave==6

gen l5iden_pt=l5.iden_pt
gen l5iden_psdb=l5.iden_psdb
polychoric l5iden_pt iden_pt if wave==6
polychoric l5iden_psdb iden_psdb if wave==6

gen l5think_pt=l5.think_pt
gen l5think_psdb=l5.think_psdb
polychoric l5think_pt think_pt if wave==6
polychoric l5think_psdb think_psdb if wave==6

gen l5symp_pt=l5.symp_pt
gen l5symp_psdb=l5.symp_psdb
polychoric l5symp_pt symp_pt if wave==6
polychoric l5symp_psdb symp_psdb if wave==6

*II. OTHER MEASURES RELATED TO PARTY ID
	*1: Party dislike 
recode vb15 (1501=0) (else=1), gen(dislike_pt)
replace dislike_pt=. if wave~=1

recode vb15 (1503=0) (else=1), gen(dislike_psdb)
replace dislike_psdb=. if wave~=1

recode vb15 (1502=0) (else=1), gen(dislike_pmdb)
replace dislike_pmdb=. if wave~=1

	*2: Presidential vote choice 
recode vb1 (1=1) (.=.) (.a=.) (.b=.) (.c=.) (else=0) , gen(vote_pt)
recode vb3 (1=1) (.=.) (.a=.) (.b=.) (.c=.) (else=0) , gen(temp)
replace vote_pt=temp if wave==7
drop temp

recode vb1 (2=1) (.=.) (.a=.) (.b=.) (.c=.) (else=0) , gen(vote_psdb)
recode vb3 (2=1) (.=.) (.a=.) (.b=.) (.c=.) (else=0) , gen(temp)
replace vote_psdb=temp if wave==7


*Criterion-Related Validity graphs
recode m1 1=5 2=4 3=3 4=2 5=1
recode vb1 1=1 2=0 .=. else=., gen(votebin)

xtset idtelefone wave
gen l5vb1=l5.vb1

gen pref_symp=.
replace pref_symp=-2 if symp_pt==1 
replace pref_symp=-1 if pref_pt==1 & symp==0
replace pref_symp=0 if preference==0 & symp==0
replace pref_symp=1 if pref_psdb==1 & symp==0 
replace pref_symp=2 if symp_psdb==1
replace pref_symp=. if wave>1 & wave<6
replace pref_symp=. if wave==7
replace pref_symp=. if pref_symp==2 & preference~=1503 & preference~=0
replace pref_symp=. if pref_symp==-2 & preference~=1501 & preference~=0

gen dilma_minus_aecio=ft3-ft2
bysort pref_symp: summ votebin 
bysort pref_symp: summ dilma_minus_aecio
bysort pref_symp: summ m1

xtset idtelefone wave
gen l5pref_symp=l5.pref_symp
capture label drop party
label define party 2 "Agreed PSDBistas" 1 "Cont'ed PSDBistas" 0 "Agreed nonpart's" -1 "Cont'ed PTistas" -2 "Agreed PTistas"
label values pref_symp party
label values l5pref_symp party

gen votefuture=votebin
replace votefuture=0 if l5pref_symp>0

recode pref_symp -1=1 1=1 0=2 .=. else=0, gen(fns)
recode l5pref_symp -1=1 1=1 0=2 .=. else=0, gen(fns2)
separate votebin, by(fns)
separate votefuture, by(fns2)
separate m1, by(fns)
separate dilma_minus_aecio, by(fns)

	*bar graphs
graph bar (mean) votebin?, over(pref_symp, label(angle(0) labsize(small) alternate tick labgap(0)))  graphregion(color(white)) plotregion(lcolor(black)) ///
blabel(bar, format(%9.2f) size(small)) bar(1, color(black)) bar(2, color(gs12)) bar(3, color(gs16) lcolor(black)) title("A1: Rousseff current 2-party vote") ytitle("") ylab(, labsize(small))  legend(off) nofill
graph save "`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr1.gph", replace

graph bar (mean) votefuture? if wave==6, over(l5pref_symp, label(angle(0) labsize(small) alternate tick labgap(0)))  graphregion(color(white)) plotregion(lcolor(black)) ///
blabel(bar, format(%9.2f) size(small)) bar(3, color(gs16) lcolor(black)) bar(2, color(gs12)) bar(1, color(black)) title("A2: Rousseff future 2-party vote") ytitle("") ylab(, labsize(small)) text(.05 81 "Not enough observations", size(small) box fcolor(gs12) lcolor(white)) legend(off) nofill
graph save "`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr2.gph", replace

graph bar (mean) m1?, over(pref_symp, label(angle(0) labsize(small) alternate tick labgap(0))) graphregion(color(white)) plotregion(lcolor(black))  ///
blabel(bar, format(%9.2f) size(small)) bar(1, color(black)) bar(2, color(gs12)) bar(3, color(gs16) lcolor(black))   title("A3: Rousseff job approval") ytitle("") exclude0 yscale(range(2(.5)4)) ytick(2 2.5 3 3.5 4) ylab(2 2.5 3 3.5 4)  ylab(, labsize(small))  legend(off) nofill
graph save "`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr3.gph", replace

graph bar (mean) dilma_minus_aecio?, over(pref_symp, label(angle(0) labsize(small) alternate tick labgap(0))) graphregion(color(white)) plotregion(lcolor(black))  ///
blabel(bar, format(%9.2f) size(small)) bar(1, color(black)) bar(2, color(gs12)) bar(3, color(gs16) lcolor(black))   title("A4: Rousseff - Neves feeling therms") ytitle("") ytick(-5 -2.5 0 2.5 5) ylab(-5 -2.5 0 2.5 5)  ylab(, labsize(small))  legend(off) nofill
graph save "`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr4.gph", replace

*local stick f
graph combine ///
"`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr1.gph" ///
"`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr2.gph" ///
"`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr3.gph" ///
"`stick'\My Documents\Research\Paper PID Experiment\Brazil\gr4.gph", ///
row(2) col(2) graphregion(color(white))
graph export "`stick'\My Documents\Research\Paper PID Experiment\LaTeX\JOPBrazilCriterion.pdf", as(pdf) replace

*III. Descriptives
summ pref_pt iden_pt think_pt symp_pt dislike_pt vote_pt ft6 pref_psdb iden_psdb think_psdb symp_psdb dislike_psdb vote_psdb ft7 if wave==1 | wave==6
summ votebin m1 dilma_minus_aecio if pref_symp~=.
summ votebin if l5pref_symp~=. & wave==6

tab iden_pt vote_pt if wave==1, row
tab think_pt vote_pt if wave==1, row
tab pref_pt vote_pt if wave==1, row 
tab symp_pt vote_pt if wave==1, row 

 
*IV. Randomization check
*income, but not pretreatment
*recode p15 (1=724) (2=1810) (3=2896) (4=4711) (5=6516) (6=10860) (7=18100)
*replace p15=ln(p15)
recode p1 2=1 1=0
recode urb_rur 2=0
bysort vb10exp: ci means symp_indep symp_pt p1 idade pol1 urb_rur if wave==1

*V: Factor Analysis check for unidimensionality
polychoricpca pref_pt symp_pt vote_pt ft6
polychoricpca iden_pt symp_pt vote_pt ft6
polychoricpca think_pt symp_pt vote_pt ft6

polychoricpca pref_psdb symp_psdb vote_psdb ft7
polychoricpca iden_psdb symp_psdb vote_psdb ft7
polychoricpca think_psdb symp_psdb vote_psdb ft7

*VI. IRT models
*Note: I often fed starting values to these IRT models but it never seemed to make a difference. What does make a difference is number of integration points and the integration method.
*More intpoints are more accurate (Ayala 2009, p. 75 and 104), and ghermite is not trustworthy (see "semintro12" Stata manual, p. 6). Models using ghermite would often converge but were very unstable/sensitive and often nonsensical SEs. 
*mcaghermite produced stable results repeatedly, although slow. mvaghermite also stable and trustworthy, but slightly less likely to converge
*Small parties are more challenging to estimate because of skew (Ayala 2009, 104), so I did these with 60 intpoints

	*1: PT Results
irt grm pref_pt iden_pt think_pt symp_pt vote_pt ft6 if wave==1 | wave==6, intpoints(30) difficult vce(cluster idtelefone) intmethod(mcaghermite) 
test _b[pref_pt:Theta]=_b[think_pt:Theta]
test _b[pref_pt:Theta]=_b[symp_pt:Theta]
test _b[pref_pt:Theta]=_b[iden_pt:Theta]
predict thetapt, latent
summ thetapt

irtgraph icc (ft6 , lcolor(gs14) lwidth(vthin) lpattern(dash))  (vote_pt, lcolor(black) lwidth(medium) lpattern(dash)) (pref_pt iden_pt symp_pt think_pt, lcolor(black) lwidth(medthick)), ///
addplot((scatteri .5 0.33 "Pres. Vote", msymbol(i) mlabpos(0) mlabangle(52) mlabcolor(black) mlabsize(vsmall)) ///
(scatteri .5 .67 "Prefer({it:P{superscript:0}N{superscript:0}})", msymbol(i) mlabpos(0) mlabangle(82) mlabcolor(black) mlabsize(small)) ///
(scatteri .5 .94 "Consider({it:P{superscript:1}N{superscript:1}})", msymbol(i) mlabpos(0) mlabangle(74) mlabcolor(black) mlabsize(small)) ///
(scatteri .4 1.06 "Sympathy({it:P{superscript:0}N{superscript:1}})", msymbol(i) mlabpos(0) mlabangle(69) mlabcolor(black) mlabsize(small)) /// 
(scatteri .4 1.27 "Way of Thinking({it:P{superscript:0}N{superscript:1}})", msymbol(i) mlabpos(0) mlabangle(71) mlabcolor(black) mlabsize(small))) ///
bcc range(-1.20 1.94) legend(off) graphregion(color(white)) plotregion(lstyle(yxline) lcolor(black)) b1title("{it: θ{subscript:PT}}: Strength of PT Partisanship") xtitle("") ytitle("{it:Pr}({it:x{subscript: j•PT}}|{it: θ{subscript:PT}})")  title("") xtick(-2(.5)2) xlabel(-2(1)2) 
graph export "`stick'\My Documents\Research\Paper PID Experiment\LaTeX\JOPPTIRT.pdf", as(pdf) replace

polychoric thetapt pref_pt iden_pt think_pt symp_pt vote_pt ft6 if wave==1 | wave==6, pw verbose
	
	*2: PSDB Results
set more off
*to speed things, I did feed starting values here.  They came from this command, which took several hours to converge:
*irt grm pref_psdb iden_psdb think_psdb symp_psdb dislike_psdb vote_psdb ft7 if wave==1 | wave==6, intpoints(30) difficult vce(cluster idtelefone) intmethod(mcaghermite) 
mat start = [7.7449082, 3.6025677, 3.4145009, 8.536266, 1.1026588, 1.0339763, 1.338271, 13.02818, 7.0484067, 7.3877823, 16.618127, -3.6155326, 2.0287019, -1.9292317, -1.656367, -1.1379195, -.62497109, -.09281607, 1.0717178, 1.7532436, 2.5152163, 3.6803523, 4.2057435, 1]
mat colnames start = pref_psdb:Theta iden_psdb:Theta think_psdb:Theta symp_psdb:Theta dislike_psdb:Theta vote_psdb:Theta ft7:Theta pref_psdb_cut1:_cons iden_psdb_cut1:_cons think_psdb_cut1:_cons symp_psdb_cut1:_cons dislike_psdb_cut1:_cons vote_psdb_cut1:_cons ft7_cut1:_cons ft7_cut2:_cons ft7_cut3:_cons ft7_cut4:_cons ft7_cut5:_cons ft7_cut6:_cons ft7_cut7:_cons ft7_cut8:_cons ft7_cut9:_cons ft7_cut10:_cons var(Theta):_cons

display "$S_TIME  $S_DATE"
irt grm pref_psdb iden_psdb think_psdb symp_psdb vote_psdb ft7 if wave==1 | wave==6, intpoints(60) difficult vce(cluster idtelefone) intmethod(mcaghermite) from(start, skip)
display "$S_TIME  $S_DATE"

test _b[pref_psdb:Theta]=_b[think_psdb:Theta]
test _b[pref_psdb:Theta]=_b[symp_psdb:Theta]
test _b[pref_psdb:Theta]=_b[iden_psdb:Theta]
predict thetapsdb, latent 
summ thetapsdb

irtgraph icc (ft7, lcolor(gs14) lwidth(vthin) lpattern(dash))  (vote_psdb, lcolor(black) lwidth(medium) lpattern(dash)) (pref_psdb iden_psdb symp_psdb think_psdb, lcolor(black) lwidth(medthick)), ///
addplot((scatteri .375 1.37 "Pres. Vote", msymbol(i) mlabpos(0) mlabangle(37) mlabcolor(black) mlabsize(vsmall)) ///
(scatteri .55 1.65 "Prefer({it:P{superscript:0}N{superscript:0}})", msymbol(i) mlabpos(0) mlabangle(82) mlabcolor(black) mlabsize(small)) ///
(scatteri .88 2.39 "Consider({it:P{superscript:1}N{superscript:1}})", msymbol(i) mlabpos(0) mlabangle(55) mlabcolor(black) mlabsize(small)) ///
(scatteri .62 1.9 "Sympathy({it:P{superscript:0}N{superscript:1}})", msymbol(i) mlabpos(0) mlabangle(83) mlabcolor(black) mlabsize(small)) /// 
(scatteri .4 2.14 "Way of Thinking({it:P{superscript:0}N{superscript:1}})", msymbol(i) mlabpos(0) mlabangle(67) mlabcolor(black) mlabsize(small))) ///
bcc range(-.92 2.64) legend(off) graphregion(color(white)) plotregion(lstyle(yxline) lcolor(black)) b1title("{it: θ{subscript:PSDB}}: Strength of PSDB Partisanship") xtitle("") ytitle("{it:Pr}({it:x{subscript: j•PSDB}}|{it: θ{subscript:PSDB}})") title("") xtick(-2(.5)3) xlabel(-2(1)3)
graph export "`stick'\My Documents\Research\Paper PID Experiment\LaTeX\JOPPSDBIRT.pdf", as(pdf) replace

polychoric thetapsdb pref_psdb iden_psdb think_psdb symp_psdb vote_psdb ft7 if wave==1 | wave==6, pw verbose
*/

*Item-rest correlation
	*1: PT Results
capture drop thetapt
irt grm iden_pt think_pt symp_pt vote_pt ft6 if wave==1 | wave==6, intpoints(30) difficult vce(cluster idtelefone) intmethod(mcaghermite) 
predict thetapt, latent
polychoric thetapt pref_pt iden_pt think_pt symp_pt, pw verbose 

drop thetapt
irt grm pref_pt think_pt symp_pt vote_pt ft6 if wave==1 | wave==6, intpoints(30) difficult vce(cluster idtelefone) intmethod(mcaghermite) 
predict thetapt, latent
polychoric thetapt pref_pt iden_pt think_pt symp_pt, pw verbose 

drop thetapt
irt grm pref_pt iden_pt symp_pt vote_pt ft6 if wave==1 | wave==6, intpoints(30) difficult vce(cluster idtelefone) intmethod(mcaghermite) 
predict thetapt, latent
polychoric thetapt pref_pt iden_pt think_pt symp_pt, pw verbose 

drop thetapt
irt grm pref_pt iden_pt think_pt vote_pt ft6 if wave==1 | wave==6, intpoints(30) difficult vce(cluster idtelefone) intmethod(mcaghermite) 
predict thetapt, latent
polychoric thetapt pref_pt iden_pt think_pt symp_pt, pw verbose 


	*2: PSDB Results
capture drop thetapsdb
irt grm iden_psdb think_psdb symp_psdb vote_psdb ft7 if wave==1 | wave==6, intpoints(60) difficult vce(cluster idtelefone) intmethod(mcaghermite) from(start, skip)
predict thetapsdb, latent
polychoric thetapsdb pref_psdb iden_psdb think_psdb symp_psdb, pw verbose 

drop thetapsdb
irt grm pref_psdb think_psdb symp_psdb vote_psdb ft7 if wave==1 | wave==6, intpoints(60) difficult vce(cluster idtelefone) intmethod(mcaghermite) from(start, skip)
predict thetapsdb, latent
polychoric thetapsdb pref_psdb iden_psdb think_psdb symp_psdb, pw verbose 

drop thetapsdb
irt grm pref_psdb iden_psdb think_psdb vote_psdb ft7 if wave==1 | wave==6, intpoints(60) difficult vce(cluster idtelefone) intmethod(mcaghermite) from(start, skip)
predict thetapsdb, latent
polychoric thetapsdb pref_psdb iden_psdb think_psdb symp_psdb, pw verbose 

log close
