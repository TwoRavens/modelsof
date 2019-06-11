*********************
* DESCRIPTIVE STATS *
*********************
// Table 1: Petition Models
zinb totpet c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1, cluster(dyadc) inflate(c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1)

	sum totpet Llngdprat Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 if e(sample) == 1 & Lcow_def2 == 0

	sum totpet Llngdprat Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 if e(sample) == 1 & Lcow_def2 == 1

// Table 2: Petition Denial Models
glm prdeny c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc)

	sum prdeny Llngdprat Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 if e(sample) == 1 & Lcow_def2 == 0

	sum prdeny Llngdprat Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 if e(sample) == 1 & Lcow_def2 == 1

**********
* MODELS *
**********
// Table 3: ZINB Model of AD Petition Counts

* Run and Store the Model
zinb totpet c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1, cluster(dyadc) inflate(c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1)

	est store Petitions

* Generate Marginal Effects Plot (Figure 2)
margins, at(Llngdprat=(-7.5(.2)11.5) Lcow_def2=(0/1)) atmeans

marginsplot, plotopts(msymbol(i)) scheme(s1mono) plot1opts(lpattern(shortdash)) plot2opts(lpattern(solid)) ciopts(lwidth(vvthin) msize(tiny)) xtitle("Market Power Asymmetry") ytitle("Predicted Number of AD Petitions") title("") xline(0, lpattern(dot)) level(90) xlabel(-7.5 0 11.5) ylabel(0 .02) addplot(scatter where2 Llngdprat if e(sample) == 1 & Lcow_def2 == 1, ms(none) mlabel(pipe) mlabpos(0) xlabel(-7.5 11.5) ylabel(0 .02) || scatter where4 Llngdprat if e(sample) == 1 & Lcow_def2 == 0, ms(none) mlabel(pipe) mlabpos(0) xlabel(-7.5 0 11.5) ylabel(0 .02) legend(order(4 "Allies" 3 "Non-Allies") region(color(none))) text(-.0025 2 "Allies" -.004 2 "Non-Allies", color(white) size(vsmall))) 

graph export f-zinb.pdf, replace

* Generate Output Table in TeX
#delimit ;
estout Petitions using "t-zinb.tex", replace
title("Zero-Inflated Negative Binomial Model of AD Petition Counts")
style(tex)
varlabels(_cons Constant)
cells(b(label(Coef) star fmt(%9.2f)) se(label(SE) par fmt(%9.2f)))
msign(--) nolz varwidth(25) modelwidth(12) starlevels(* 0.1 ** 0.05 *** 0.01, label(" \(p<@\)"))
prehead("\begin{table}[p]" "\caption{\label{t-zinb}@title}" "\begin{center}" 
"\begin{tabular}{l*{@M}{r}}" "\hline")
mlabels(,titles prefix(\multicolumn{@span}{c}{) suffix(})) 
posthead(\hline) 
prefoot(\hline)
stats(N, labels("\$N\$") fmt(%9.0f))
note({Zero-inflated negative binomial model. Standard errors in parentheses are clustered on directed dyads.})
postfoot("\hline" "\end{tabular}\\[0.5ex]" "\small@starlegend. @note" "\end{center}" "\end{table}" "\clearpage" "\newpage")
drop(0b*)
substitute(
"Llngdprat" "Market Power Asymmetry (t-1)"
"c.Llngdprat" "Market Power Asymmetry (t-1)"
"1.Lcow_def2" "Alliance Ties (t-1)"
"1.Lcow_def2#c.Llngdprat" "Market Power Asymmetry X Alliance (t-1)"
"Llngdppc1" "State 1 Per capita GDP"
"Llngdppc2" "State 2 Per capita GDP"
"Lpolity1" "State 1 Polity Score"
"Lpolity2" "State 2 Polity Score"
"Ladcap2" "State 2 AD Capacity"
"Lbothmem" "Shared GATT/WTO Membership"
"Llnimpdep1" "State 1 Import Penetration"
"Llnexpdep1" "State 1 Export Dependence"
)
;

// Table 4: GLM Models of AD Petition Denial 

* Run and Store the Models
** All Alliances
glm prdeny c.Llngdprat##Lcow_allbin2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc) nolog

	est store All

** Defense Agreements
glm prdeny c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc)

	est store Defense

* Generate Marginal Effects Plot using Model 3 (Figure 3)
margins, at(Llngdprat=(-6.4(.2)8.6) Lcow_def2=(0/1)) atmeans

marginsplot, plotopts(msymbol(i)) scheme(s1mono) plot1opts(lpattern(shortdash)) plot2opts(lpattern(solid)) ciopts(lwidth(vvthin) msize(tiny)) xtitle("Market Power Asymmetry") ytitle("Predicted Percent of Petition Denial") title("") xline(0, lpattern(dot)) level(90) xlabel(-6.4 0 8.6) ylabel(0 .7) addplot(scatter where Llngdprat if e(sample) == 1 & Lcow_def2 == 1, ms(none) mlabel(pipe) mlabpos(0) xlabel(-6.4 8.6) ylabel(0 .7) || scatter where3 Llngdprat if e(sample) == 1 & Lcow_def2 == 0, ms(none) mlabel(pipe) mlabpos(0) xlabel(-6.4 0 8.6) legend(order(4 "Allies" 3 "Non-Allies") region(color(none))) text(0 2.6 "Allies" -.05 2.6 "Non-Allies", color(white) size(vsmall)))

graph export f-glm.pdf, replace

** Neutrality Agreements
glm prdeny c.Llngdprat##Lcow_neut2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc)

	est store Neutral

** Nonaggression Agreements
glm prdeny c.Llngdprat##Lcow_nonag2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc)

	est store Nonagg

** Ententes
glm prdeny c.Llngdprat##Lcow_ent2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc)

	est store Entente

* Generate Output Table in TeX
#delimit ;
estout All Defense Neutral Nonagg Entente using "~/Desktop/tables/t-glm.tex", replace
title("GLM Models of Percentage of AD Petition Denial")
style(tex)
varlabels(_cons Constant)
cells(b(label(Coef) star fmt(%9.2f)) se(label(SE) par fmt(%9.2f)))
msign(--) nolz varwidth(25) modelwidth(12) starlevels(* 0.1 ** 0.05 *** 0.01, label(" \(p<@\)"))
prehead("\begin{table}[p]" "\caption{\label{t-zinb}@title}" "\begin{center}" 
"\begin{tabular}{l*{@M}{r}}" "\hline")
mlabels(,titles prefix(\multicolumn{@span}{c}{) suffix(})) 
posthead(\hline) 
prefoot(\hline)
stats(N, labels("\$N\$") fmt(%9.0f))
note({GLM models with logit link and binomial family. Standard errors in parentheses are clustered on directed dyads.})
postfoot("\hline" "\end{tabular}\\[0.5ex]" "\small@starlegend. @note" "\end{center}" "\end{table}" "\clearpage" "\newpage")
drop(0b*)
substitute(
"Llngdprat" "Market Power Asymmetry (t-1)"
"c.Llngdprat" "Market Power Asymmetry (t-1)"
"1.Lcow_allbin2" "Alliance Ties (t-1)"
"1.Lcow_def2" "Alliance Ties (t-1)"
"1.Lcow_neut2" "Alliance Ties (t-1)"
"1.Lcow_nonag2" "Alliance Ties (t-1)"
"1.Lcow_ent2" "Alliance Ties (t-1)"
"1.Lcow_allbin2#Llngdprat" "Market Power Asymmetry X Alliance (t-1)"
"1.Lcow_def2#c.Llngdprat" "Market Power Asymmetry X Alliance (t-1)"
"1.Lcow_neut2#c.Llngdprat" "Market Power Asymmetry X Alliance (t-1)"
"1.Lcow_nonag2#c.Llngdprat" "Market Power Asymmetry X Alliance (t-1)"
"1.Lcow_ent2#c.Llngdprat" "Market Power Asymmetry X Alliance (t-1)"
"Llngdppc1" "State 1 Per capita GDP"
"Llngdppc2" "State 2 Per capita GDP"
"Lpolity1" "State 1 Polity Score"
"Lpolity2" "State 2 Polity Score"
"Ladcap2" "State 2 AD Capacity"
"Lbothmem" "Shared GATT/WTO Membership"
"Llnimpdep1" "State 1 Import Penetration"
"Llnexpdep1" "State 1 Export Dependence"
"Lcow_imr" "Inverse Mills Ratio"
)
;

*********************
* ROBUSTNESS CHECKS *
*********************
// Table 5: GLM Models with ATOP Measures of Alliances

* Run and Store the Models
** All Alliances (Model 7)
glm prdeny c.Llngdprat##Latop_allybin2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Latop_imr, link(logit) family(binomial) cluster(dyadc) nolog

	est store atop_all

** Defense Agreements (Model 8)
glm prdeny c.Llngdprat##Latop_defense2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Latop_imr, link(logit) family(binomial) cluster(dyadc)

	est store atop_def

** Neutrality (Model 9)
glm prdeny c.Llngdprat##Latop_neutral2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Latop_imr, link(logit) family(binomial) cluster(dyadc)

	est store atop_neut

** Nonaggression (Model 10)
glm prdeny c.Llngdprat##Latop_nonagg2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Latop_imr, link(logit) family(binomial) cluster(dyadc)

	est store atop_nonagg

** Entente (Model 11)
glm prdeny c.Llngdprat##Latop_consul2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Latop_imr, link(logit) family(binomial) cluster(dyadc)

	est store atop_consul

* Generate Output Table in TeX
#delimit ;
estout atop_all atop_def atop_neut atop_nonagg atop_consul using "t-atop.tex", replace
title("GLM Models of Percentage of AD Petition Denial (ATOP Measures of Alliances)")
style(tex)
varlabels(_cons Constant)
cells(b(label(Coef) star fmt(%9.2f)) se(label(SE) par fmt(%9.2f)))
msign(--) nolz varwidth(25) modelwidth(12) starlevels(* 0.1 ** 0.05 *** 0.01, label(" \(p<@\)"))
prehead("\begin{table}[p]" "\caption{\label{t-atop}@title}" "\begin{center}" 
"\begin{tabular}{l*{@M}{r}}" "\hline")
mlabels(,titles prefix(\multicolumn{@span}{c}{) suffix(})) 
posthead(\hline) 
prefoot(\hline)
stats(N, labels("\$N\$") fmt(%9.0f))
note({GLM models with logit link and binomial family. Standard errors in parentheses are clustered on directed dyads.})
postfoot("\hline" "\end{tabular}\\[0.5ex]" "\small@starlegend. @note" "\end{center}" "\end{table}" "\clearpage" "\newpage")
drop(0b*)
substitute(
"Llngdprat" "Market Power Asymmetry (t-1)"
"c.Llngdprat" "Market Power Asymmetry (t-1)"
"1.Lcow_allbin2" "ATOP Alliance Ties (t-1)"
"1.Lcow_def2" "ATOP Alliance Ties (t-1)"
"1.Lcow_neut2" "ATOP Alliance Ties (t-1)"
"1.Lcow_nonag2" "ATOP Alliance Ties (t-1)"
"1.Lcow_ent2" "ATOP Alliance Ties (t-1)"
"1.Lcow_allbin2#Llngdprat" "Market Power Asymmetry X ATOP Alliance (t-1)"
"1.Lcow_def2#c.Llngdprat" "Market Power Asymmetry X ATOP Alliance (t-1)"
"1.Lcow_neut2#c.Llngdprat" "Market Power Asymmetry X ATOP Alliance (t-1)"
"1.Lcow_nonag2#c.Llngdprat" "Market Power Asymmetry X ATOP Alliance (t-1)"
"1.Lcow_ent2#c.Llngdprat" "Market Power Asymmetry X ATOP Alliance (t-1)"
"Llngdppc1" "State 1 Per capita GDP"
"Llngdppc2" "State 2 Per capita GDP"
"Lpolity1" "State 1 Polity Score"
"Lpolity2" "State 2 Polity Score"
"Ladcap2" "State 2 AD Capacity"
"Lbothmem" "Shared GATT/WTO Membership"
"Llnimpdep1" "State 1 Import Penetration"
"Llnexpdep1" "State 1 Export Dependence"
"Latop_imr" "Inverse Mills Ratio"
)
;

// Table 6: GLM Models (Additional Robustness Checks)

* Run and Store the Models
** Population Ratio (Model 12)
glm prdeny c.Llnpoprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr, link(logit) family(binomial) cluster(dyadc)

	est store Population

** ATOP Trade Linkage (Model 13)
glm prdeny c.Llngdprat##Latop_defense2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Latop_trade2 Latop_imr, link(logit) family(binomial) cluster(dyadc)

	est store Trade

** NATO and OAS (Model 14)
glm prdeny c.Llngdprat##Lcow_def2 Llngdppc? Lpolity? Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_nato2 Lcow_oas2 Lcow_imr, link(logit) family(binomial) cluster(dyadc)
	
	est store NATO_OAS

** US Cases Only (Model 15)
glm prdeny c.Llngdprat##Lcow_def2 Llngdppc? Lpolity2 Ladcap2 Lbothmem Llnimpdep1 Llnexpdep1 Lcow_imr if ccode1 == 2, link(logit) family(binomial) cluster(dyadc)

	est store US

* Generate Output Table in TeX
#delimit ;
estout Population Trade NATO_OAS US using "t-robustness.tex", replace
title("GLM Models of Percentage of AD Petition Denial (Robustness Checks)")
style(tex)
varlabels(_cons Constant)
cells(b(label(Coef) star fmt(%9.2f)) se(label(SE) par fmt(%9.2f)))
msign(--) nolz varwidth(25) modelwidth(12) starlevels(* 0.1 ** 0.05 *** 0.01, label(" \(p<@\)"))
prehead("\begin{table}[p]" "\caption{\label{t-robustness}@title}" "\begin{center}" 
"\begin{tabular}{l*{@M}{r}}" "\hline")
mlabels(,titles prefix(\multicolumn{@span}{c}{) suffix(})) 
posthead(\hline) 
prefoot(\hline)
stats(N, labels("\$N\$") fmt(%9.0f))
note({GLM models with logit link and binomial family. Standard errors in parentheses are clustered on directed dyads.})
postfoot("\hline" "\end{tabular}\\[0.5ex]" "\small@starlegend. @note" "\end{center}" "\end{table}" "\clearpage" "\newpage")
drop(0b*)
substitute(
"Llngdprat" "Market Power Asymmetry (t-1)"
"c.Llngdprat" "Market Power Asymmetry (t-1)"
"c.Llnpoprat" "Market Power Asymmetry (t-1)"
"1.Lcow_def2" "Alliance Ties (t-1)"
"1.Latop_defense2" "Alliance Ties (t-1)"
"1.Lcow_def2#c.Llngdprat" "Market Power Asymmetry X Alliance Ties (t-1)"
"1.Latop_defense2#c.Llngdprat" "Market Power Asymmetry X Alliance Ties (t-1)"
"Llngdppc1" "State 1 Per capita GDP (t-1)"
"Llngdppc2" "State 2 Per capita GDP (t-1)"
"Lpolity1" "State 1 Polity Score (t-1)"
"Lpolity2" "State 2 Polity Score (t-1)"
"Ladcap2" "State 2 AD Capacity (t-1)"
"Lbothmem" "Shared GATT/WTO Membership (t-1)"
"Llnimpdep1" "State 1 Import Penetration (t-1)"
"Llnexpdep1" "State 1 Export Dependence (t-1)"
"Lcow_imr" "Inverse Mills Ratio (t-1)"
"Latop_imr" "Inverse Mills Ratio (t-1)"
"Latop_trade2" "ATOP Trade Linkage (t-1)"
"Lcow_nato2" "NATO Alliance Ties (t-1)"
"Lcow_oas2" "OAS Alliance Ties (t-1)"
)
;
