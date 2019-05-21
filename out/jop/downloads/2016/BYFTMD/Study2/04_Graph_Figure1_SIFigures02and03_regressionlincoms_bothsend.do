
set more off
graph set eps logo off
graph set eps orientation landscape

local tempfilename="SIFigures3and4_Data_forpaper_datingdyads_bothsend_nofe_lincom_zf_mf_wf_mpf_wpf__bivariatelincom"
di "`tempfilename'"

insheet using "tables\\`tempfilename'.out", delimiter(";")

gen low=estimate-1.96*se
gen high=estimate+1.96*se
keep model mfx estimate high low

levelsof model, local(modelslist)

gen cleannedmodelloop=subinstr(model," ","_",.)
replace cleannedmodelloop=subinstr(cleannedmodelloop,",","_",.)
tab cleannedmodelloop

 * first, blank out all labels
 forvalues i = 1(1)50 {
  lab def mfxnonpollabel `i' " ", add
  lab def mfxpollabel `i' " ", add
  }

 gen mfxnonpol=.
 gen mfxpol=.
  
 *replace mfxnonpol=1 if mfx=="M age 30 to 34, F age 25 to 29 minus M age 30 to 34, F age 35 to 39"
 replace mfxnonpol=1 if mfx=="M age - F age = 5 minus M age - F age = -5"
 replace mfxnonpol=3 if mfx=="M height quintile 1, F height quintile 1 minus M height quintile 1, F height quintile 5"
 replace mfxnonpol=4 if mfx=="M height quintile 5, F height quintile 5 minus M height quintile 5, F height quintile 1"
 replace mfxnonpol=6 if mfx=="M educ college, F educ college minus M educ college, F educ hs"
 replace mfxnonpol=8 if mfx=="M race white, F race white minus M race white, F race black"
 replace mfxnonpol=9 if mfx=="M race black, F race black minus M race black, F race white"
 replace mfxnonpol=11 if mfx=="M look for ltdating, F look for ltdating minus M look for ltdating, F look for stdating"
 replace mfxnonpol=12 if mfx=="M look for stdating, F look for stdating minus M look for stdating, F look for ltdating"
 replace mfxnonpol=14 if mfx=="M admit drinklots, F admit drinklots minus M admit drinklots, F admit drinknever"
 replace mfxnonpol=16 if mfx=="M relig athagn, F relig athagn minus M relig athagn, F relig christian"
 replace mfxnonpol=17 if mfx=="M relig christian, F relig christian minus M relig christian, F relig athagn"
 replace mfxnonpol=19 if mfx=="M kids want, F kids want minus M kids want, F kids notwant"
 replace mfxnonpol=20 if mfx=="M kids notwant, F kids notwant minus M kids notwant, F kids want"
 
 replace mfxpol=1 if mfx=="Q Pol Ideology? M Liberal F Liberal minus Q Pol Ideology? M Liberal F Conservative"
 replace mfxpol=2 if mfx=="Q Pol Ideology? M Conservative F Conservative minus Q Pol Ideology? M Conservative F Liberal"
 
 replace mfxpol=16 if mfx=="Q Pol Impt? M Very Impt. F Very Impt. minus Q Pol Impt? M Very Impt. F Not at All Impt."
 replace mfxpol=17 if mfx=="Q Pol Impt? M Not at All Impt. F Not at All Impt. minus Q Pol Impt? M Not at All Impt. F Very Impt."

 replace mfxpol=4 if mfx=="Q Pol PID? M Republican F Republican minus Q Pol PID? M Republican F Democrat"
 replace mfxpol=5 if mfx=="Q Pol PID? M Democrat F Democrat minus Q Pol PID? M Democrat F Republican"
 
 replace mfxpol=7 if mfx=="Q Prefer Info Source? M Fox News F Fox News minus Q Prefer Info Source? M Fox News F MSNBC"
 replace mfxpol=8 if mfx=="Q Prefer Info Source? M MSNBC F MSNBC minus Q Prefer Info Source? M MSNBC F Fox News"
 
 *lab def mfxnonpollabel 1 "Age: Man 30-34, Woman 25-29 vs 35-39", modify
 lab def mfxnonpollabel 1 "Age: Man 5 years older - 5 years younger", modify
 lab def mfxnonpollabel 3 "Height: Man Quintile 1, Woman 1 vs 5", modify
 lab def mfxnonpollabel 4 "Height: Man Quintile 5, Woman 5 vs 1", modify
 lab def mfxnonpollabel 6 "Education: Man College, Woman College vs High School", modify
 lab def mfxnonpollabel 8 "Race: Man White, Woman White vs Black", modify
 lab def mfxnonpollabel 9 "Race: Man Black, Woman Black vs White", modify
 lab def mfxnonpollabel 11 "Looking for: Man Long-Term Dating, Woman Long-Term vs Short", modify
 lab def mfxnonpollabel 12 "Looking for: Man Short-Term Dating, Woman Short-Term vs Long", modify
 lab def mfxnonpollabel 14 "Drinking: Man Admits Drinking Lots, Woman Admits Lots vs Never", modify
 lab def mfxnonpollabel 16 "Religion: Man Athiest/Agnostic, Woman Athiest/Agnostic vs Christian", modify
 lab def mfxnonpollabel 17 "Religion: Man Christian, Woman Christian vs Athiest/Agnostic", modify
 lab def mfxnonpollabel 19 "Kids: Man Wants, Woman Wants vs Not", modify
 lab def mfxnonpollabel 20 "Kids: Man Not Want, Woman Not vs Want", modify

 lab def mfxpollabel 1 "Ideology: Man Liberal, Woman Liberal vs Conservative", modify
 lab def mfxpollabel 2 "Ideology: Man Conservative, Woman Conservative vs Liberal", modify
 lab def mfxpollabel 16 "Importance of Politics: Man Very, Woman Very vs Not", modify
 lab def mfxpollabel 17 "Importance of Politics: Man Not, Woman Not vs Very", modify
 lab def mfxpollabel 4 "PID: Man Republican, Woman Republican vs Democrat", modify
 lab def mfxpollabel 5 "PID: Man Democrat, Woman Democrat vs Republican", modify
 lab def mfxpollabel 7 "News Source: Man Fox, Woman Fox vs MSNBC", modify
 lab def mfxpollabel 8 "News Source: Man MSNBC, Woman MSNBC vs Fox", modify
 
 replace mfxpol=19 if mfx=="Q Duty vote? M Yes F Yes minus Q Duty vote? M Yes F No"
 lab def mfxpollabel 19 "Duty to Vote: Man Yes, Woman Yes vs No", modify

 replace mfxpol=20 if mfx=="Q Duty vote? M No F No minus Q Duty vote? M No F Yes"
 lab def mfxpollabel 20 "Duty to Vote: Man No, Woman No vs Yes", modify

 replace mfxpol=10 if mfx=="Q Role Gov't? M Church state separate F Church state separate minus Q Role Gov't? M Church state separate F Majority Religion shape policy"
 lab def mfxpollabel 10 "Church State: Man Separate, Woman Separate vs No Division", modify

 replace mfxpol=11 if mfx=="Q Role Gov't? M Majority Religion shape policy F Majority Religion shape policy minus Q Role Gov't? M Majority Religion shape policy F Church state separate"
 lab def mfxpollabel 11 "Church State: Man No Divison, Woman No Division vs Separate", modify

 replace mfxpol=13 if mfx=="Q How balance budget? M Cut Services F Cut Services minus Q How balance budget? M Cut Services F Raise Taxes"
 lab def mfxpollabel 13 "Balance Budget: Man Cut Services, Woman Cut Services vs Raise Taxes", modify

 replace mfxpol=14 if mfx=="Q How balance budget? M Raise Taxes F Raise Taxes minus Q How balance budget? M Raise Taxes F Cut Services"
 lab def mfxpollabel 14 "Balance Budget: Man Raise Taxes, Woman Raise Taxes vs Cut Services", modify

 label values mfxnonpol mfxnonpollabel
 label values mfxpol mfxpollabel
 keep if mfxnonpol~=. | mfxpol~=.
 
 sum mfxnonpol
 
 twoway (rcap low high mfxnonpol, horizontal lcolor(black) lwidth(thin) lpattern(solid) msize(medlarge)) (scatter mfxnonpol estimate, mcolor(black) msize(vsmall) msymbol(diamond)) if model=="No Pol Items", yscale(reverse) ytitle("") ylabel(`r(min)'(1)`r(max)', labels labsize(tiny) labcolor(black) angle(zero) valuelabel) xlabel(.00(.01).02) xscale(range(0 .02)) xtitle(Estimate and 95% Confidence Interval) xtitle(, size(small)) xline(0) title("Figure S2: Effect of Nonpolitical Characteristics on Joint Messaging Behavior", size(small) span) subtitle("Estimates from model without political items", size(small) span) note("Note: Mean of DV in this sample is .0039. See Table S8 for model specification and full regression results.", size(vsmall) span) legend(off) xsize(11) ysize(8.5) scheme(s1mono) name(FigureS2, replace)
 
 graph export "Figures\\FigureS2.eps", as(eps) preview(off) replace
 graph export "Figures\\FigureS2.pdf", as(pdf) replace
 
 sum mfxpol
 twoway (rcap low high mfxpol, horizontal lcolor(black) lwidth(thin) lpattern(solid) msize(medlarge)) (scatter mfxpol estimate, mcolor(black) msize(vsmall) msymbol(diamond)) if mfxpol~=. & model=="Individual Pol Items", yscale(reverse) ytitle("") ylabel(`r(min)'(1)`r(max)', labels labsize(tiny) labcolor(black) angle(zero) valuelabel) xlabel(.0(.005).005) xscale(range(-.001 .005)) xtitle(Estimate and 95% Confidence Interval) xtitle(, size(small)) xline(0) title("Figure 1: Effect of Political Characteristics on Joint Messaging Behavior", size(small) span) subtitle("Estimates from models with individual sets of political items", size(small) span) note("Note: Mean of DV in this sample is .0039. See SI Table S8 for model specification and full regression results.", size(vsmall) span) legend(off) xsize(11) ysize(8.5) scheme(s1mono) name(Figure1, replace) 
  
 graph export "Figures\\Figure1.eps", as(eps) preview(off) replace
 graph export "Figures\\Figure1.pdf", as(pdf) replace

 sum mfxnonpol
 twoway (rcap low high mfxpol, horizontal lcolor(black) lwidth(thin) lpattern(solid) msize(medlarge)) (scatter mfxpol estimate, mcolor(black) msize(vsmall) msymbol(diamond)) if mfxpol~=. & model=="All Questions", yscale(reverse) ytitle("") ylabel(`r(min)'(1)`r(max)', labels labsize(tiny) labcolor(black) angle(zero) valuelabel) xlabel(.0(.005).005) xscale(range(-.001 .005)) xtitle(Estimate and 95% Confidence Interval) xtitle(, size(small)) xline(0) title("Figure S3: Effect of Political Characteristics on Joint Messaging Behavior", size(small) span) subtitle("Estimates from model with all political items and 40 additional match questions", size(small) span) note("Note: Mean of DV in this sample is .0039. See SI Table S8 for model specification and full regression results.", size(vsmall) span) legend(off) xsize(11) ysize(8.5) scheme(s1mono) name(FigureS3, replace) 
 
 graph export "Figures\\FigureS3.eps", as(eps) preview(off) replace
 graph export "Figures\\FigureS3.pdf", as(pdf) replace
