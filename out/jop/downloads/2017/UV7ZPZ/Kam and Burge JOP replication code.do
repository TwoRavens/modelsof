***************
*Replication Code for Kam, Cindy D. and Camille D. Burge.  "Uncovering Reactions to the Racial Resentment Scale Across the Racial Divide."
clear
set more off
import excel "C:\Kam_Burge.xls", firstrow

//race
recode race (1=0 "White")(2=1 "Black")(else=.), gen(black)
//Racial resentment
recode Q42 Q44 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(Q42r Q44r)
recode Q46 Q48 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(Q46r Q48r)
alpha Q42r 	Q44r Q46r Q48r
alpha Q42r 	Q44r Q46r Q48r if black==0
alpha Q42r 	Q44r Q46r Q48r if black==1
gen resent = (Q42r +Q44r +Q46r +Q48r)/4
lab var resent "Racial Resentment"
kdensity resent if black==1, addplot(kdensity resent if black==0, lpattern(dash))  legend(label(1 "Blacks") label(2 "Whites")) scheme(s1mono) title("SSI 2013") name(resent_SSI_2013, replace)
sdtest resent, by(black)

//other covariates
recode female (1=0)(2=1), gen(female01)
recode ideology (1=0 "VLib")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "VCon")(else=.), gen(lc7catd)
gen pid7cata=.
replace pid7cata = 0 if Q9==1
replace pid7cata = .17 if Q9==2
replace pid7cata = .33 if Q11==1
replace pid7cata = .5 if Q11==3
replace pid7cata = .67 if Q11==2
replace pid7cata = .83 if Q10==2
replace pid7cata = 1 if Q10==1
lab def pid7cata 0"Str Dem" 1"Str GOP"
lab val pid7cata pid7cata 
recode Q12 (1=0 "<8th grade")(2=.17)(3=.33)(4=.5)(5=.67)(6=.83)(7=1 "Adv deg")(else=.), gen(ed7cat)
recode age (18/29=1)(30/99=0)(else=.), gen(age1829)
recode age (18/29 60/99=0)(30/59=1)(else=.), gen(age3059)
recode income (1=0 "<10K")(2=.125)(3=.25)(4=.375)(5=.5)(6=.625)(7=.75)(8=.875)(9=1 ">150K"), gen(faminc)

*political information
recode Q37 (1 2 4 5=0)(3=1)(else=.), gen(info1)
recode Q38 (1 3 4 5=0)(2=1)(else=.), gen(info2)
recode Q39 (1 3 4 5=0)(2=1)(else=.), gen(info3)
recode Q40 (2 3 4 5=0)(1=1)(else=.), gen(info4)
alpha info1 info2 info3 info4
gen info = (info1+info2+info3+info4)/4

gen blackres = black*resent

//traits of blacks
egen neg_tblk = anymatch(C2Q1tblk C2Q2tblk C2Q3tblk C2Q4tblk C1Q1tblk C1Q2tblk C1Q3tblk C1Q4tblk), val(3)
egen pos_tblk = anymatch(C2Q1tblk C2Q2tblk C2Q3tblk C2Q4tblk C1Q1tblk C1Q2tblk C1Q3tblk C1Q4tblk), val(1)
sum neg_tblk pos_tblk 

//individualism 
egen indiv_rule = anymatch(C2Q1individ C2Q2individ C2Q3individ C2Q4individ C1Q1individ C1Q2individ C1Q3individ C1Q4individ), val(1)
egen indiv_notenough = anymatch(C2Q1individ C2Q2individ C2Q3individ C2Q4individ C1Q1individ C1Q2individ C1Q3individ C1Q4individ), val(2)
egen indiv_flouted = anymatch(C2Q1individ C2Q2individ C2Q3individ C2Q4individ C1Q1individ C1Q2individ C1Q3individ C1Q4individ), val(3)
sum indiv_rule indiv_notenough indiv_flouted 

//discrimination
destring C1Q1discrim, force replace
egen discrim_prob_blk= anymatch(C2Q1discrim C2Q2discrim C2Q3discrim C2Q4discrim C1Q1discrim C1Q2discrim C1Q3discrim C1Q4discrim), val(11)
egen discrim_not_prob= anymatch(C2Q1discrim C2Q2discrim C2Q3discrim C2Q4discrim C1Q1discrim C1Q2discrim C1Q3discrim C1Q4discrim), val(31)
egen discrim_reverse= anymatch(C2Q1discrim C2Q2discrim C2Q3discrim C2Q4discrim C1Q1discrim C1Q2discrim C1Q3discrim C1Q4discrim), val(2 21)
sum discrim_prob_blk discrim_not_prob discrim_reverse

probit neg_tblk resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store neg_tblk
probit pos_tblk resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store pos_tblk
probit indiv_rule resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store indiv_rule
probit indiv_notenough resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store indiv_notenough
probit indiv_flouted resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store indiv_flouted
probit discrim_prob_blk resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store discrim_prob_blk
probit discrim_not_prob resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store discrim_not_prob
probit discrim_reverse resent black blackres female age1829 age3059 pid7cata lc7cat ed7cat info faminc
est store discrim_reverse

est table neg_tblk pos_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse, b(%9.2f) se style(col) eq(1) stats(r2 N)
est table neg_tblk pos_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse, b(%9.2f) star(.1 .05 .01) style(col) eq(1) stats(r2 N)

//predicted probability graphs
graph drop _all
preserve
collapse black female age1829 age3059 pid7cata lc7cat ed7cat info faminc
expand 11
egen resent = fill(0(.1)1)
replace pid7cata=0.5
replace lc7cat= .5
replace age1829=0
replace age3059=1
replace ed7cat=.5
replace faminc =0.42
replace female=1
replace black = 0
expand 2
replace black = 1 in 12/22
gen blackres=black*resent

est restore neg_tblk
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Negative Trait Mention)") xtitle("Racial Resentment") scheme(s1mono) name(neg_tblk, replace)

drop phat*
est restore pos_tblk
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Positive Trait Mention)") xtitle("Racial Resentment") scheme(s1mono) name(pos_tblk, replace)

drop phat*
est restore indiv_rule
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Individualism Affirmed)") xtitle("Racial Resentment") scheme(s1mono) name(indiv_rule, replace)

drop phat*
est restore indiv_notenough
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Individualism Broken)") xtitle("Racial Resentment") scheme(s1mono) name(indiv_broken, replace)

drop phat*
est restore indiv_flouted
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Individualism Flouted)") xtitle("Racial Resentment") scheme(s1mono) name(indiv_flouted, replace)

drop phat*
est restore discrim_prob_blk
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Discrimination Exists)") xtitle("Racial Resentment") scheme(s1mono) name(discrim_prob_blk, replace)

drop phat*
est restore discrim_not_prob
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Discrimination Denial)") xtitle("Racial Resentment") scheme(s1mono) name(discrim_not_prob, replace)

drop phat*
est restore discrim_reverse
predict phat
gen phat_W = phat if black==0
gen phat_B = phat if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
twoway (connect phat_B resent, msymbol(i)) (connect phat_W resent, msymbol(i)), ylabel(0(.2)1) title("Pr(Reverse Discrimination)") xtitle("Racial Resentment") scheme(s1mono) name(discrim_reverse, replace)
restore

graph combine neg_tblk pos_tblk indiv_rule indiv_flouted indiv_broken discrim_prob_blk discrim_not_prob discrim_reverse, row(3) hole(3) altshrink ysize(10) xsize(7.5) name(Figure1, replace)
graph export "C:\Figure1.tif", width(3900)


//figure with confidence intervals
//calculating marginal effects
//generate marginal effect of race, LB & UB confidence intervals
graph drop _all
preserve
collapse black female age1829 age3059 pid7cata lc7cat ed7cat info faminc neg_tblk pos_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse
expand 11
egen resent = fill(0(.1)1)
replace pid7cata=0.5
replace lc7cat= .5
replace age1829=0
replace age3059=1
replace ed7cat=.5
replace faminc =0.42
replace female=1
replace black = 0
expand 2
replace black = 1 in 12/22
gen blackres=black*resent
gen str B = "B"
replace B = "W" if black==0

est restore neg_tblk
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Negative Trait Mention)") xtitle("Racial Resentment") scheme(s1mono) name(neg_tblk, replace) legend(order(1 4))

drop phat* LB* UB*
est restore pos_tblk
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Positive Trait Mention)") xtitle("Racial Resentment") scheme(s1mono) name(pos_tblk, replace) legend(order(1 4))

drop phat* LB* UB*
est restore indiv_rule
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Individualism Affirmed)") xtitle("Racial Resentment") scheme(s1mono) name(indiv_rule, replace) legend(order(1 4))

drop phat* LB* UB*
est restore indiv_flouted
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Individualism Flouted)") xtitle("Racial Resentment") scheme(s1mono) name(indiv_flouted, replace) legend(order(1 4))


drop phat* LB* UB*
est restore indiv_notenough
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Individualism Broken)") xtitle("Racial Resentment") scheme(s1mono) name(indiv_broken, replace) legend(order(1 4))

drop phat* LB* UB*
est restore discrim_prob_blk
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Discrimination Exists)") xtitle("Racial Resentment") scheme(s1mono) name(discrim_prob_blk, replace) legend(order(1 4))

drop phat* LB* UB*
est restore discrim_not_prob
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Discrimination Denial)") xtitle("Racial Resentment") scheme(s1mono) name(discrim_not_prob, replace) legend(order(1 4))

drop phat* LB* UB*
est restore discrim_reverse
predictnl phat = normal(xb()), ci(LB UB)
gen phat_W = phat if black==0
gen phat_B = phat if black==1
gen LB_W = LB if black==0
gen LB_B = LB if black==1
gen UB_W = UB if black==0
gen UB_B = UB if black==1
lab var phat_W "Whites"
lab var phat_B "Blacks"
lab var LB_W "W"
lab var LB_B "B"
lab var UB_W "W"
lab var UB_B "B"
twoway (connect phat_B resent, msymbol(i))(scatter LB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_B resent, msymbol(i) mlabel(B) mlabposition(0)) (connect phat_W resent, msymbol(i)) (scatter LB_W resent, msymbol(i) mlabel(B) mlabposition(0)) (scatter UB_W resent, msymbol(i) mlabel(B) mlabposition(0)), ylabel(0(.2)1) title("Pr(Reverse Discrimination)") xtitle("Racial Resentment") scheme(s1mono) name(discrim_reverse, replace) legend(order(1 4))
restore

graph combine neg_tblk pos_tblk indiv_rule indiv_flouted indiv_broken discrim_prob_blk discrim_not_prob discrim_reverse, row(3) hole(3) altshrink ysize(10) xsize(7.5) name(app_Figure, replace)


//factor analysis
*Removing Rs who do not provide codeable mentions
egen codedMT = anycount(C1Q1code C1Q2code C1Q3code C1Q4code), val(0 1)
egen codedMD = anycount(C2Q1code C2Q2code C2Q3code C2Q4code), val(0 1)
egen codeable = rowtotal(C2Q1code C2Q2code C2Q3code C2Q4code C1Q1code C1Q2code C1Q3code C1Q4code)
gen pctcodeable = codeable/(codedMT+codedMD)
factor pos_tblk neg_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse if pctcodeable>0
bysort race: factor pos_tblk neg_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse if pctcodeable>0

/*liberals*/ factor pos_tblk neg_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse if lc7cat<.5 & pctcodeable>0
/*conservatives*/ factor pos_tblk neg_tblk indiv_rule indiv_flouted indiv_notenough discrim_prob_blk discrim_not_prob discrim_reverse if lc7cat>.5 & pctcodeable>0


