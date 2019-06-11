 set more off
 
 cd "/Users/gregorylove/Dropbox/jeps submission/R&R Efforts/Final Jan'19/data"
 log using "JEPS Log file.smcl", replace
use "study 1 data", clear


***black partisan subjects only
ttest p1_da if black==1, by(pid_da)
ttest p1_anc if black==1, by(pid_da)

ttest p1_anc=p1_da if pid_da_non_identifier==0 & black==1
ttest p1_da if  black==1 & p1_anon~=., by (pid_da_non_identifier)


**mean partisan and racial trust gaps by PID
mean p1_diff_pid p1_diff_race, over(pid_da)

**Figures 1 and 2
ciplot p1_anon p1_da p1_anc, by(pid_anc) title("Fig. 1. Mean Ticket Allocations by Treatment and Partisanship, 95% c.i.", size(medium)) ylabel(2(1) 6) note("")   xlabel(, valuelabels)  scheme(s2color) graphregion(fcolor(white) lcolor(white)) xtitle("") xline(7.5, lcolor(black)) legend(rows(1)) ytitle("Tickets Sent")
*graph save "figure 1"

ciplot p1_diff_pid p1_diff_race, by(pid_anc)  title("Fig. 2. Trust Gaps by Type and Partisanship, 95% c.i.", size(medium)) ylabel(0(.5) 2) note("")   xlabel(, valuelabels)  scheme(s2color) graphregion(fcolor(white) lcolor(white)) xtitle("") xline(5.5, lcolor(black)) legend(rows(1)) ytitle("Trust Gap (in Tickets)")
*graph save "figure 2"

ciplot p1_anon p1_da p1_anc p1_white p1_black, by(pid_anc) title("Fig. 1. Mean Ticket Allocations by Treatment and Partisanship, 95% c.i.", size(medium)) ylabel(2(1) 6) note("")   xlabel(, valuelabels)  scheme(s2color) graphregion(fcolor(white) lcolor(white)) xtitle("") xline(11.5, lcolor(black)) legend(rows(2)) ytitle("Tickets Sent")
ciplot p1_anon p1_da p1_anc p1_white p1_black, by(white_black) title("Fig. 1. Mean Ticket Allocations by Treatment and Race, 95% c.i.", size(medium)) ylabel(2(1) 6) note("")   xlabel(, valuelabels)  scheme(s2color) graphregion(fcolor(white) lcolor(white)) xtitle("") xline(11.5, lcolor(black)) legend(rows(2)) ytitle("Tickets Sent")


**descriptive stats SM1
sum p1_anon p1_anc p1_da p1_black p1_white p1_same_pid p1_rival_pid p1_same_race p1_rival_race if pid_da~=.
sum p1_anon p1_anc p1_da p1_black p1_white p1_same_pid p1_rival_pid p1_same_race p1_rival_race if pid_da==1
sum p1_anon p1_anc p1_da p1_black p1_white p1_same_pid p1_rival_pid p1_same_race p1_rival_race if pid_anc==1


****distribution graph SM2

graph bar, over(p1_anon) by(, title("Anonymous Game" , size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "anon_dist.gph", replace

graph bar, over(p1_anc) by(, title("ANC Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "anc_dist.gph", replace
graph bar, over(p1_da) by(, title("DA Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "da_dist.gph", replace
graph bar, over(p1_white) by(, title("White Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "white_dist.gph", replace
graph bar, over(p1_black) by(, title("Black Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "black_dist.gph", replace

graph combine "anon_dist.gph" "anc_dist.gph" "da_dist.gph" "white_dist.gph" "black_dist.gph"




	***2015 Study (Study2)
	use "study 2 data", clear

	***Table 1
		xtreg p1 copid##corace , fe
		xtreg p1 copid##corace if pid_da==0, fe
		xtreg p1 copid##corace if pid_da==1, fe

	
	***For SM2-SM5
xtreg p1 copid##corace , re
xtreg p1 copid##corace##pid_da , re

  margins, dydx(copid) at(pid_da=(0(1)1) corace=(0(1)1))
 marginsplot, yline(0)
 xtmixed p1 copid##c.corace##pid_da ||id: 
  margins, dydx(copid) at(pid_da=(0(1)1)) pwcompare(effects)
  margins, dydx(copid) at(pid_da=(0(1)1)) 
   margins, dydx(copid) at(pid_da=(0(1)1) corace=(0(1)1)) pwcompare(effects)
   contrast copid@pid_da, effect
   
    margins, dydx(corace) 
     margins, dydx(corace) at(pid_da=(0(1)1)) 
    margins, dydx(corace) at(pid_da=(0(1)1)) pwcompare(effects)

	    margins, dydx(copid) 
     margins, dydx(copid) at(corace=(0(1)1)) 
    margins, dydx(copid) at(corace=(0(1)1)) pwcompare(effects)
	
 
 anova p1 copid##corace##pid_da id, repeated(copid corace pid_da)
 contrast copid@pid_da, effect
 
 ksmirnov p1, by(corace)
ksmirnov p1, by(copid)
ranksum p1, by(copid)
ranksum p1, by(corace)


**anova Table SM8
anova p1 copid##corace id, repeated(copid corace)
test (_b[1.copid] == _b[0.copid])
test (_b[1.corace] == _b[0.corace])
test (_b[1.copid]-_b[0.copid]=_b[1.corace]-_b[0.corace])
anova p1 copid##corace id if pid_anc==1, repeated(copid corace)
test (_b[1.copid] == _b[0.copid])
test (_b[1.corace] == _b[0.corace])

anova p1 copid##corace id if pid_anc==1, repeated(copid corace)
test (_b[1.copid] == _b[0.copid])
test (_b[1.corace] == _b[0.corace])
test (_b[1.copid]-_b[0.copid]=_b[1.corace]-_b[0.corace])

anova p1 copid##corace
test (_b[1.copid] == _b[0.copid])


**Tobit fixed effects
tobit p1 copid##corace i.id , ul ll
tobit p1 copid##corace i.id if pid_da==0 , ul ll
tobit p1 copid##corace i.id if pid_da==1, ul ll


***Figure SM3
xtreg p1 copid##corace##pid_da , re
  margins, dydx(copid) at(pid_da=(0(1)1) corace=(0(1)1))
 marginsplot


****comparison of anonymous game between Study 1 and 2--shows outgroup derigation by DA identifiers, not ingroup favoritism
	gen anon=0
replace anon=1 if copid==. & corace==.
replace copid=0 if copid==.
replace corace=0 if corace==.


mean p1 if anon==1 & pid_da==1
mean p1 if copid==1 & pid_da==1
mean p1 if copid==0 & pid_da==1

mean p1 if anon==1 & pid_da==0
mean p1 if copid==1 & pid_da==0
mean p1 if copid==0 & pid_da==0


	xtreg p1 anon copid##corace , fe
	margins, at(anon=(0) copid=(0 1)) pwcompare(effects)
	
	
	xtreg p1 anon copid##corace if pid_da==0, fe
	margins, at(anon=(0) copid=(0 1)) pwcompare(effects)

	
	xtreg p1 anon copid##corace if pid_da==1, fe
	margins, at(anon=(0) copid=(0 1)) pwcompare(effects)

	
	**mean ticket allocations Table SM 1

sort pid_anc

sum p1 if anon==1
by pid_anc: sum p1 if anon==1
sum p1 if anc_black==1
by pid_anc: sum p1 if anc_black==1
sum p1 if anc_white==1
by pid_anc: sum p1 if anc_white==1
sum p1 if da_black==1
by pid_anc: sum p1 if da_black==1
sum p1 if da_white==1
by pid_anc: sum p1 if da_white==1


	
****ticket distrubtions figrues SM2

graph bar if anon==1, over(p1) by(, title("Anonymous Game" , size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "anon_dist.gph", replace

graph bar if anc_black==1, over(p1) by(, title("ANC-Black Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "anc-black_dist.gph", replace
graph bar if da_black==1, over(p1) by(, title("DA-Black Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "da-black_dist.gph", replace
graph bar if anc_white==1 , over(p1) by(, title("ANC-White Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "anc-white_dist.gph", replace
graph bar if da_white==1, over(p1) by(, title("ANC-Black Game", size(medsmall))) by(, graphregion(margin(zero) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none))) by(pid_anc)
graph save Graph "anc-black_dist.gph", replace

graph combine "anon_dist.gph" "anc-black_dist.gph" "da-black_dist.gph" "anc-white_dist.gph" "anc-black_dist.gph"



	
 
 ***Player 2 SM6 and SM7
 
use "study 2 player 2 data.dta", clear

pwcorr race pid

reg p2 copid##corace
reg p2 copid##corace, cl(id)
xtreg p2 copid##corace , fe
margins, dydx(copid) 
margins, dydx(corace) 
xtreg p2 copid##corace if pid==1, fe
margins, dydx(copid) 
margins, dydx(corace) 
xtreg p2 copid##corace if pid==2, fe
margins, dydx(copid) 
margins, dydx(corace) 

anova p2 copid##corace id, repeated(copid corace)
test (_b[1.copid] == _b[0.copid])
anova p2 copid##corace
test (_b[1.copid] == _b[0.copid])

mean p2 , over(game_num pid)


drop game_num
drop copid corace
reshape wide p2, i(id) j(game) string
egen anc_mean=rowmean(p2anc_black p2anc_white)
egen da_mean=rowmean(p2da_black p2da_white)
ttest anc_mean= p2anon  if pid==2

log close
