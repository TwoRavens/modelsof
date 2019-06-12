* =======================================
* INVESTIGATING MCP IN THE SWEDISH SAMPLE
* =======================================

* MCP
* ---

alpha mp4_Q70_1 mp4_Q70_2 mp4_Q70_5 mp4_Q70_6 mp4_Q70_7re, item
alpha mp4_Q70_1 mp4_Q70_2 mp4_Q70_5 mp4_Q70_6 mp4_Q70_7re, std gen(mcp)
gen mcp2 = mp4_Q70_1+mp4_Q70_2+mp4_Q70_5+mp4_Q70_6+mp4_Q70_7re
gen int_mcp=int(mcp)
egen mcpdummy = cut(mcp), group(2)
lab define mcpLab 0 "low MCP" 1 "high MCP"
lab value mcpdummy mcpLab

recode mp4_Q70_3 mp4_Q70_4 (-111=.) (6=.a)
alpha mp4_Q70_3 mp4_Q70_4, gen(extmcp)

* Out-group attitudes (high values = anti-outgroup)
* -------------------------------------------------
recode mp4_Q69_1 mp4_Q69_2 mp4_Q69_3 mp4_Q69_4 mp4_Q69_5 (-111 6=.)
alpha mp4_Q69_1 mp4_Q69_2 mp4_Q69_3 mp4_Q69_4 mp4_Q69_5, item reverse(mp4_Q69_2 mp4_Q69_4 mp4_Q69_5) gen(outgroup)
alpha mp4_Q69_1 mp4_Q69_2 mp4_Q69_3 mp4_Q69_4 mp4_Q69_5, item reverse(mp4_Q69_2 mp4_Q69_4 mp4_Q69_5)

alpha mp4_Q69_2 mp4_Q69_4 mp4_Q69_5, std reverse(mp4_Q69_2 mp4_Q69_4 mp4_Q69_5) item gen(immscale)
gen immscale2 = mp4_Q69_2+mp4_Q69_4+mp4_Q69_5


* Other variables
* ---------------
recode r_sex (1=0) (2=1) (-111=.), gen(gender)
label define gndr 0 "female" 1 "male"
label values gender gndr
recode mp4_Q67_8 (-111=.), gen(voteSD)
recode mp4_Q13 (-111=.) (8=1) (nonmissing=0), gen(actualvoteSD)
recode mp4_Q15 (-111=.) (1/7=0) (9=0) (8=1), gen(likebestSD)
recode r_age (-111=.), gen(age)
recode r_edu (-111=.), gen(education)
recode r_leftright5 (-111=.), gen(leftright)

* Standardizing
* -------------

egen std_mcp = std(mcp)
egen std_extmcp = std(extmcp)
egen std_immscale = std(immscale)

sum gender voteSD mcp2 immscale2 if mcp!=.

* Listwise deletion
* -----------------
foreach var of varlist gender immscale mcp {
drop if `var'==.
}


* ====================
* Descriptive analyses
* ====================

egen mcp3 = cut(mcp), group(3)
lab define mcp3Lab 0 "low" 1 "medium" 2 "high"
lab value mcp3 mcp3Lab

egen immscale3 = cut(immscale), group(3)
lab define immscale3Lab 0 "low" 1 "medium" 2 "high"
lab value immscale3 immscale3Lab

tab mcp3 gender, nofreq column
tab immscale3 gender, nofreq column chi

tab mcp3, gen(mcp3)
ttest mcp31, by(gender)
ttest mcp32, by(gender)
ttest mcp33, by(gender)
tab immscale3, gen(immscale3)
ttest immscale31, by(gender)
ttest immscale32, by(gender)
ttest immscale33, by(gender)

mean std_mcp std_immscale, over(gender)
mean mcpdummy, over(gender)
mean std_mcp std_extmcp std_immscale, over(gender)
ttest std_mcp, by(gender)
ttest std_extmcp, by(gender)
ttest std_immscale, by(gender)

bys gender: alpha mp4_Q69_1 mp4_Q69_2 mp4_Q69_3 mp4_Q69_4 mp4_Q69_5, item

 
 kdensity mcp if gender == 0, plot(kdensity mcp if gender == 1) ///
	legend(label(1 "Women") label(2 "Men") rows(1))

* ===========
* Regressions
* ===========

* Explaining MCP
* --------------
regress std_mcp gender


* Explaining SD vote (propensity 0-to-10)
* ---------------------------------------
regress voteSD gender				
regress voteSD gender immscale
regress voteSD gender mcp
regress voteSD gender mcp immscale	

* Full model
* ----------
regress voteSD gender				i.education leftright age
estimates store m1
regress voteSD gender immscale		i.education leftright age
estimates store m2
regress voteSD gender mcp			i.education leftright age
estimates store m3
regress voteSD gender mcp immscale	i.education leftright age
estimates store m4

esttab m1 m2 m3 m4, cells(b(star fmt(%9.3f)))  stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
legend label collabels(none) varlabels(_cons Constant)

* ===
* CFA
* ===

sem (MCP -> mp4_Q70_1 mp4_Q70_2 mp4_Q70_5 mp4_Q70_6 mp4_Q70_7re) (IMMSCALE -> mp4_Q69_2 mp4_Q69_4 mp4_Q69_5), stand
* chi2(19) = 801.29
sem (ONE_LATENT -> mp4_Q70_1 mp4_Q70_2 mp4_Q70_5 mp4_Q70_6 mp4_Q70_7re mp4_Q69_2 mp4_Q69_4 mp4_Q69_5), stand
* chi2(20) = 1014.00
estat gof, stats(all)
