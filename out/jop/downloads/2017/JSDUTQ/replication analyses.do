use "/Users/spencerpiston/Dropbox/Yanna stuff/ambiguity/KrupnikovPistonRyan/JOP/JOP RR/Final RR Submission/OFFICIAL FINAL/conditional acceptance/replication/SSI_merged_dataset_coded.dta", clear
set more off

*Table 1. 
logit larsonvote i.precise##i.black i.ambig##i.black
logit larsonvote i.silent##i.black i.ambig##i.black
reg lmtherm0to1 i.precise##i.black i.ambig##i.black
reg lmtherm0to1 i.silent##i.black i.ambig##i.black

*Figure 1.
ttest larsonvote if silent==1, by(black)
ttest larsonvote if precise==1, by(black)
ttest larsonvote if ambig==1, by(black)

*Figure 2. 
*2a. White Candidate
reg envlars0to1 i.precise##i.black##c.envrespw10to1 i.ambig##i.black##c.envrespw10to1
margins, dydx(ambig) at(black=0 envrespw10to1=(0(.1)1) precise==0)
marginsplot, ///
    title("") ///
	ytitle("M.E. Ambiguity on Reporting Cand. Is Conservative") ///
    xtitle("Respondent Environmental Beliefs") ///
    yscale(titlegap(2)) ///
    xscale(titlegap(0)) ///
    graphregion( color(white) ) ///
    plotop(lcolor(black) lwidth(medium) mcolor(black) lpattern(solid)) ///
    ciopts(color(gs12)) /// 
    recast(line) recastci(rarea) ///
    legend(cols(1)) ///
    xlabel(.03 "Liberal" .95 "Conservative") ///
    l(90)
*2b. Black Candidate  
reg envlars0to1 i.precise##i.black##c.envrespw10to1 i.ambig##i.black##c.envrespw10to1
margins, dydx(ambig) at(black=1 envrespw10to1=(0(.1)1) precise==0)
marginsplot, ///
    title("") ///
	ytitle("M.E. Ambiguity on Reporting Cand. Is Conservative") ///
    xtitle("Respondent Environmental Beliefs") ///
    yscale(titlegap(2)) ///
    xscale(titlegap(0)) ///
    graphregion( color(white) ) ///
    plotop(lcolor(black) lwidth(medium) mcolor(black) lpattern(solid)) ///
    ciopts(color(gs12)) /// 
    recast(line) recastci(rarea) ///
    legend(cols(1)) ///
    xlabel(.03 "Liberal" .95 "Conservative") ///
    l(90)
	
*Figure 3. 
*Figure 3a. stereotypes, control is baseline
logit larsonvote i.precise##i.black#c.stindex i.ambig##i.black##c.stindex i.ambig##i.black##c.pidrep3cat ideo0to1 male rasian rhisp educ0to1 inc0to1
margins, dydx(ambig) at(stindex=(.5(.1)1) precise=0 black==1)
marginsplot, ///
	title("") ///
	ytitle("M.E. Ambiguity on Pr(Vote Candidate)") ///
    xtitle("Stereotype Index") ///
    yscale(titlegap(2)) ///
    xscale(titlegap(0)) ///
    graphregion( color(white) ) ///
    plot1op(lcolor(black) lwidth(medium) mcolor(black) lpattern(solid)) ///
    ci1opts(color(gs12)) /// 
    recast(line) recastci(rarea) ///
    legend(cols(1)) ///
    xlabel(0.5 "Neutral" .97 `" "Highest" "Prejudice" "') ///
    l(90)
*Figure 3b. stereotypes, precise is baseline
logit larsonvote i.silent##i.black#c.stindex i.ambig##i.black##c.stindex i.ambig##i.black##c.pidrep3cat ideo0to1 male rasian rhisp educ0to1 inc0to1
margins, dydx(ambig) at(stindex=(.5(.1)1) silent=0 black==1)
marginsplot, ///
    title("") ///
	ytitle("M.E. Ambiguity on Pr(Vote Candidate)") ///
    xtitle("Stereotype Index") ///
    yscale(titlegap(4)) ///
    xscale(titlegap(0)) ///
    graphregion( color(white) ) ///
    plot1op(lcolor(black) lwidth(medium) mcolor(black) lpattern(solid)) ///
    ci1opts(color(gs12)) /// 
    recast(line) recastci(rarea) ///
    legend(cols(1)) ///
    xlabel(0.5 "Neutral" .97 `" "Highest" "Prejudice" "') ///
    l(90)

