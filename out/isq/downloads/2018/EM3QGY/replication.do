***producing Figure 1 and checking for robustness with measures of absolute inequality and redistribution***

twoway scatter rel_red_bw gini_market_bw if polity>=6, mlabel(country) || lfit rel_red_bw gini_market_bw, legend(off) xtitle("") ytitle("")

***save this file as "between.gph"

twoway scatter rel_red_wi gini_market_wi if polity>=6 || lfit rel_red_wi gini_market_wi, legend(off) xtitle("") ytitle("") 

***save this file as "within.gph"

graph combine C:\Users\Owner\Desktop\I&R\between.gph C:\Users\Owner\Desktop\I&R\within.gph, ///
l1title("Levels and Changes in Redistribution") b1title("Levels and Changes in Market Inequality")

twoway scatter abs_red_bw gini_market_bw if polity>=6, mlabel(country) || lfit abs_red_bw gini_market_bw, legend(off) xtitle("") ytitle("")

***save this file as "between1.gph"

twoway scatter abs_red_wi gini_market_wi if polity>=6, mlabel(country) || lfit abs_red_wi gini_market_wi, legend(off) xtitle("") ytitle("")

***save this file as "within1.gph"

graph combine C:\Users\Owner\Desktop\I&R\between1.gph C:\Users\Owner\Desktop\I&R\within1.gph, ///
l1title("Levels and Changes in Redistribution") b1title("Levels and Changes in Market Inequality")

pwcorr rel_red_bw gini_market_bw 

pwcorr rel_red_wi gini_market_wi, sig

pwcorr rel_red_bw gini_market_bw, sig

***producing Table 1***

xtreg abs_red std_gini_market_bw std_left_bw std_polconiii_bw std_turnout_bw std_gdp_pcp_bw std_unemploy_bw std_exports_bw std_imports_bw std_female_bw ///
std_age_depend_old_bw std_durable_bw std_al_ethnic std_labs_red_wi std_gini_market_wi std_left_wi std_polconiii_wi std_turnout_wi std_gdp_pcp_wi ///
std_unemploy_wi std_exports_wi std_imports_wi std_female_wi std_age_depend_old_wi std_durable_wi, i(nation) vce(robust)

xtreg abs_red std_gini_market_bw std_left_bw std_polconiii_bw std_turnout_bw std_gdp_pcp_bw std_unemploy_bw std_exports_bw std_imports_bw std_female_bw ///
std_age_depend_old_bw std_durable_bw std_al_ethnic std_labs_red_wi std_gini_market_wi std_left_wi std_polconiii_wi std_turnout_wi std_gdp_pcp_wi ///
std_unemploy_wi std_exports_wi std_imports_wi std_female_wi std_age_depend_old_wi std_durable_wi, i(nation) vce(jackknife) 

xtreg abs_red std_gini_market_bw std_left_bw std_polconiii_bw std_turnout_bw std_gdp_pcp_bw std_unemploy_bw std_exports_bw std_imports_bw std_female_bw ///
std_age_depend_old_bw std_durable_bw std_al_ethnic std_labs_red_wi std_gini_market_wi std_left_wi std_polconiii_wi std_turnout_wi std_gdp_pcp_wi ///
std_unemploy_wi std_exports_wi std_imports_wi std_female_wi std_age_depend_old_wi std_durable_wi std_level_bw std_level_wi std_union_dens_bw std_union_dens_wi, i(nation) vce(robust)

xtreg abs_red std_gini_market_bw std_left_bw std_polconiii_bw std_turnout_bw std_gdp_pcp_bw std_unemploy_bw std_exports_bw std_imports_bw std_female_bw ///
std_age_depend_old_bw std_durable_bw std_al_ethnic std_labs_red_wi std_gini_market_wi std_left_wi std_polconiii_wi std_turnout_wi std_gdp_pcp_wi ///
std_unemploy_wi std_exports_wi std_imports_wi std_female_wi std_age_depend_old_wi std_durable_wi std_level_bw std_level_wi std_union_dens_bw std_union_dens_wi, i(nation) vce(jackknife)

***producing Table 2***

cap erase myfile.txt
xtivreg2 abs_red left polconiii turnout gdp_pcp l.unemploy female age_depend_old durable level union_dens ///
(gini_market= l(1/3).abs_red imports), fe ffirst robust bw(3) endog(gini_market) 


version 10: xtivreg2 abs_red left polconiii turnout gdp_pcp l.unemploy female age_depend_old durable level union_dens ///
(gini_market= l(1/3).abs_red imports), fe first robust bw(3) endog(gini_market) savefirst


xtivreg2 abs_red left polconiii turnout gdp_pcp l.unemploy exports female age_depend_old durable level union_dens al_ethnic ///
(gini_market= l(1/3).abs_red imports), fe first gmm robust bw(3) endog(gini_market) 

xtabond2 abs_red l.abs_red gini_market left polconiii turnout gdp_pcp l.unemploy ///
exports imports female age_depend_old durable level union_dens al_ethnic, gmmstyle (l.abs_red gini_market left, equation (both) collapse lag (2 9)) ///
ivstyle(polconiii turnout gdp_pcp l.unemploy exports imports female age_depend_old durable level union_dens al_ethnic, equation (diff)) twostep small robust orthogonal 

drop yhat_fit
predict yhat_fit if e(sample)
twoway scatter abs_red yhat_fit || lfit abs_red yhat_fit, mlabel(country)

sum l.abs_red gini_market abs_red if e(sample)

mfx compute, at(l.abs_red=-.6858655) 
mfx compute, at(l.abs_red=26.88963)
mfx compute, at(gini_market=29.65666)
mfx compute, at(gini_market=68.01223)

***producing Table 3***

xi: xtpcse d.abs_red l.abs_red d.gini_market l.gini_market d.left l.left d.gdp_grow l.gdp_grow d.l.polconiii l2.polconiii ///
d.l.turnout l2.turnout d.l.gdp_pcp l2.gdp_pcp d.l.unemploy l2.unemploy d.l.exports l2.exports d.l.imports l2.imports ///
d.l.female l2.female d.l.age_depend_old l2.age_depend_old d.l.al_ethnic l2.al_ethnic ///
d.l.level l2.level d.l.union_dens l2.union_dens i.country if regime=="SD", pairwise 

estat bgodfrey

outreg using "C:\Users\owner\Desktop\new_ECM.out", se replace starloc(1) starlevels(10 5 1) sigsymbols(*,**,***)

xi: xtpcse d.abs_red l.abs_red d.gini_market l.gini_market d.left l.left d.gdp_grow l.gdp_grow d.l.polconiii l2.polconiii ///
d.l.turnout l2.turnout d.l.gdp_pcp l2.gdp_pcp d.l.unemploy l2.unemploy d.l.exports l2.exports d.l.imports l2.imports ///
d.l.female l2.female d.l.age_depend_old l2.age_depend_old d.l.al_ethnic l2.al_ethnic ///
d.l.level l2.level d.l.union_dens l2.union_dens i.country if regime=="CD", pairwise 

outreg using "C:\Users\owner\Desktop\new_ECM.out", se merge starloc(1) starlevels(10 5 1) sigsymbols(*,**,***)

xi: xtpcse d.abs_red l.abs_red d.gini_market l.gini_market d.left l.left d.gdp_grow l.gdp_grow d.l.polconiii l2.polconiii ///
d.l.turnout l2.turnout d.l.gdp_pcp l2.gdp_pcp d.l.unemploy l2.unemploy d.l.exports l2.exports d.l.imports l2.imports ///
d.l.female l2.female d.l.age_depend_old l2.age_depend_old d.l.al_ethnic l2.al_ethnic ///
d.l.level l2.level d.l.union_dens l2.union_dens i.country if regime=="Liberal", pairwise 

outreg using "C:\Users\owner\Desktop\new_ECM.out", se merge starloc(1) starlevels(10 5 1) sigsymbols(*,**,***)

xi: xtpcse d.abs_red l.abs_red d.gini_market l.gini_market d.left l.left d.gdp_grow l.gdp_grow d.l.polconiii l2.polconiii ///
d.l.turnout l2.turnout d.l.gdp_pcp l2.gdp_pcp d.l.unemploy l2.unemploy d.l.exports l2.exports d.l.imports l2.imports ///
d.l.female l2.female d.l.age_depend_old l2.age_depend_old d.l.al_ethnic l2.al_ethnic ///
i.country if regime=="Dual" , pairwise 

outreg using "C:\Users\owner\Desktop\new_ECM.out", se merge starloc(1) starlevels(10 5 1) sigsymbols(*,**,***)

xi:xtpcse d.abs_red l.abs_red d.gini_market l.gini_market d.left l.left d.gdp_grow l.gdp_grow d.l.polconiii l2.polconiii ///
d.l.turnout l2.turnout d.l.gdp_pcp l2.gdp_pcp d.l.unemploy l2.unemploy d.l.exports l2.exports d.l.imports l2.imports ///
d.l.female l2.female d.l.age_depend_old l2.age_depend_old d.l.al_ethnic l2.al_ethnic d.l.level l2.level ///
i.country if regime=="CEE", pairwise 

outreg using "C:\Users\owner\Desktop\new_ECM.out", se merge starloc(1) starlevels(10 5 1) sigsymbols(*,**,***)

