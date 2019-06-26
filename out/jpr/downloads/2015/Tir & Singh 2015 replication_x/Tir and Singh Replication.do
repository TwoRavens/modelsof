
***********
***********This file provides model code for the paper, "Get Off My Lawn: Territorial Civil Wars and Subsequent Social Intolerance in the Public"
***********authored by Jaroslav Tir and Shane P. Singh, published in the Journal of Peace Research
***********


****
*Main Models
****

***Model 1
xtreg socintol  age10 education female relig_import lrscale c.civilwar_1_ago freedom gdppercap1000 ethfrac, i(cntryyearnum)

***Model 2
xtreg socintol  age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac, i(cntryyearnum)

***Model 3
xtreg socintol  age10 education female relig_import lrscale c.armedconflict_1_ago freedom gdppercap1000 ethfrac, i(cntryyearnum)

***Model 4
xtreg socintol  age10 education female relig_import lrscale  c.territorialac_1_ago c.armedconflict_1_ago_no_terr freedom gdppercap1000 ethfrac, i(cntryyearnum)




****
*Appendix Models
****

***Model 2A
xtlogit a124_02  age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum) intmethod(aghermite)

***Model 2B
xtlogit a124_06  age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum) intmethod(aghermite)

***Model 2C
xtlogit a124_12  age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum) intmethod(aghermite)

***Model 2D
xtlogit a124_43  age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum) intmethod(aghermite)

***Model 2E
*create social intolerance scale also including gays and people with AIDS, if answered at least two questions
gen num1 = 0
gen num2 = 0
gen num3 = 0
gen num4 = 0
gen num5 = 0
gen num6 = 0

replace num1 = 1 if a124_02 ~= . // *different race
replace num2 = 1 if a124_06 ~= . // *immi/foreign workers
replace num3 = 1 if a124_12 ~= . // *different relig
replace num4 = 1 if a124_43 ~= . // *different language
replace num5 = 1 if a124_09 ~= . // *gays
replace num6 = 1 if a124_07 ~= . // *AIDs

gen num = num1+num2+num3+num4+num5+num6
alpha a124_02 a124_06 a124_12 a124_43 a124_09 a124_07  if num>1, gen(socintol_6) asis
drop num*

xtreg socintol_6  age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum)


***Model 2F
set matsize 5000
xtivreg socintol age10 education female relig_import lrscale  (territorialcw_1_ago c.civilwar_1_ago_no_terr = oilexp_d population_log hsigo_ip_cb ) freedom gdppercap1000 ethfrac, i(cntryyearnum) first
xtoverid, noisily

***Model 2G
xtreg socintol  age10 education female relig_import c.territorialcw_1_ago##c.lrscale c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac, i(cntryyearnum)

***Model 2H
xtreg socintol  age10 education female relig_import c.territorialcw_1_ago##c.auth c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum)

***Model 2I
gen very_intol = 0 
sum socintol 
global mean_plus1sd = r(mean) + r(sd) 
replace very_intol = 1 if socintol > $mean_plus1sd  

xtlogit very_intol	age10 education female relig_import lrscale  territorialcw_1_ago c.civilwar_1_ago_no_terr freedom gdppercap1000 ethfrac , i(cntryyearnum) intmethod(aghermite)


***Model 2J
xtreg socintol  age10 education female relig_import lrscale  territorialcw_total_past_five nonterritorialcw_total_past_five freedom gdppercap1000 ethfrac, i(cntryyearnum)
