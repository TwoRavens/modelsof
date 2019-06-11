clear all

* Change directory
cd "C:\Users\Carlo\Dropbox\Costly Campaigns and Political Agency\PSRM Re-Resubmission\DataVerse"

use Final_PSRM.dta
**Note: for Stata 13 or older, use file "Final_PSRM_Stata13.dta"

********************************************************************************
************************************ ESTIMATION ********************************
********************************************************************************

***** PREFERRED SPECIFICATION: 
* (i) HOUSE90 
* (ii) IMBALANCE DEFINED AS 2004 PREZ VOTE SHARE 
* (iii) ACS district covariates 
* (iv) Average outlays over FY 06 and 07 
* (V) State fixed effects
***** ROBUSTNESS to each of these five choices

* Install estout
ssc install estout, replace
net from http://myweb.uiowa.edu/fboehmke/stata/grinter
net install grinter
* package to graph interaction

***** SUMMARY STATS ***** 

* Generate amount of federal outlays in million dollars
gen outlay=exp(high_lnoutlays_cpi)
replace outlay=outlay/1000000
gen cost=exp(ln_cost)

log using Log_Final_PSRM.smcl, replace

estpost sum outlay cost imbal_abs04 Median_2005_adj Total_Pop_2005 minority_perc_ACS urban_pc if year==2006
esttab using SS.tex, cells("mean sd count") replace label title(Summary Statistics)
esttab using SS.csv, cells("mean sd count") replace label title(Summary Statistics)

log off

replace pop75=0 if pop75==.

* Testing representativeness of our sample 
ttest outlay, by(pop75)
* Test show representative in term of outlays (no difference)
ttest imbal_abs04, by(pop75)
* Test show representative in term of imbalance (no difference)
ttest Median_2005_adj, by(pop75)
* Test show not representative in term of income (sample with ad cost richer)
ttest Total_Pop_2005, by(pop75)
* Test show (barely) representative in term of total pop (no difference)
ttest minority_perc_ACS, by(pop75)
* Test show not representative in term of minority (sample with ad cost more minority)
ttest urban_pc, by(pop75)
* Test show not representative in term of urban pop (sample with ad cost more urban)

********************************************************************************
************************************ BASELINE  *********************************
********************************************************************************

log on

***** TABLE 4 & FIGURE 1 & FIGURE 2 ******
* Column (1)
reg lnoutlays_CD109 ln_cost if year==2006 & house90==1, cluster(state)
est store h1

* Column (2)
reg lnoutlays_CD109 ln_imbal04 if year==2006 & house90==1, cluster(state)
est store h2

* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 if year==2006 & house90==1, cluster(state)
est store h3

* Column (4)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & house90==1, cluster(state)
est store h4

* Figure 2
grinter ln_cost if year==2006 & house90==1, inter(ln_costimbal) const02(ln_imbal04) scheme(s1mono) nomean yla(-4(2)4) min(0) max(5) kden saving(Figure1, replace)
graph export Figure1.png, replace

* Figure 3
* Generate the effect for different quartile and decile of imbalance
qui sum ln_imbal04 if year==2006, det
gen p25_effect=(_b[ln_cost]+_b[ln_costimbal]*r(p25))*ln_cost + _b[ln_imbal04]*r(p25)+_b[_cons]
gen p50_effect=(_b[ln_cost]+_b[ln_costimbal]*r(p50))*ln_cost + _b[ln_imbal04]*r(p50)+_b[_cons]
gen p75_effect=(_b[ln_cost]+_b[ln_costimbal]*r(p75))*ln_cost + _b[ln_imbal04]*r(p75)+_b[_cons]
gen p90_effect=(_b[ln_cost]+_b[ln_costimbal]*r(p90))*ln_cost + _b[ln_imbal04]*r(p90)+_b[_cons]
gen max_effect=(_b[ln_cost]+_b[ln_costimbal]*r(max))*ln_cost + _b[ln_imbal04]*r(max)+_b[_cons]


twoway (line p25_effect ln_cost if year==2006 & house90==1, lc(gs0) lw(medthick)) (line p50_effect ln_cost if year==2006 & house90==1, lc(gs3) lw(medthick)) (line p75_effect ln_cost if year==2006 & house90==1, lc(gs6) lw(medthick)) (line p90_effect ln_cost if year==2006 & house90==1, lc(gs9) lw(medthick)) (line max_effect ln_cost if year==2006 & house90==1, lc(gs12) lw(medthick)), xtitle(Log ad cost) ytitle(Linear Predicted Log Outlays) scheme(s1mono) legend(label(1 "1st quartile log imbalance") label(2 "mean log imbalance") label(3 "3rd quartile log imbalance") label(4 "90th decile log imbalance") label(5 "max log imbalance"))
*graph export cost_by_imbal_effect.gph, replace
graph export Figure2.png, replace


* Column (5)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
* add controls district and congressman controls
est store h5

* Column (6)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store h6
* add state dummies

esttab h* using Baseline.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Baseline Specification)
esttab h* using Baseline.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Baseline Specification) tex keep(ln_cost ln_imbal04 ln_costimbal)

***** TABLE 5 & FIGURE 3 ******

gen disadvant=0
replace disadvant=1 if party==1 & margin04<=0 | party==0 & margin04>=0 | party==1 & margin00<=0 | party==0 & margin00>=0

***only 51 districts have disadvant==1, so use pop75 and use demographic and representative-specific controls one at a time

*reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006, cluster(state)

*grinter ln_cost if year==2006, inter(ln_costimbal) const02(ln_imbal04) scheme(s1mono) nomean yscale(range(-4,4)) min(0) max(5) kden saving(effect_withCI_FULL, replace)
*graph export effect_withCI_FULL.png, replace

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & disadvant==0, cluster(state)
est store T51

* Figure 3(b)
grinter ln_cost if year==2006 & disadvant==0, inter(ln_costimbal) const02(ln_imbal04) scheme(s1mono) nomean yla(-4(2)4) min(0) max(5) kden saving(Figure3a, replace)
graph export Figure3b.png, replace

* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank if year==2006 & disadvant==0, cluster(state)
est store T52

* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc mem_* if year==2006 & disadvant==0, cluster(state)
est store T53

* Column (4)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & disadvant==1, cluster(state)
est store T54

* Figure 3(a)
grinter ln_cost if year==2006 & disadvant==1, inter(ln_costimbal) const02(ln_imbal04) scheme(s1mono) nomean yla(-4(2)4) min(0) max(5) kden saving(Figure3b, replace)
graph export Figure3a.png, replace

* Column (5)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank if year==2006 & disadvant==1, cluster(state)
est store T55

* Column (6)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc mem_* if year==2006 & disadvant==1, cluster(state)
est store T56

esttab T5* using T5.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Testing Mechanism)
esttab T5* using T5.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Testing Mechanism) tex keep(ln_cost ln_imbal04 ln_costimbal)

log off

* If we look only at 2004 imbalance district, we have 43 obs, but the results are similar.

gen disadvantbis=0
replace disadvantbis=1 if party==1 & margin04<=0 | party==0 & margin04>=0 
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & disadvantbis==1, cluster(state)
grinter ln_cost if year==2006 & disadvantbis==1, inter(ln_costimbal) const02(ln_imbal04) scheme(s1mono) nomean yla(-4(2)4) min(0) max(5) kden saving(effect_withCI_DISADV, replace)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank if year==2006 & disadvantbis==1, cluster(state)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc mem_* if year==2006 & disadvantbis==1, cluster(state)


********************************************************************************
************************************ APPENDIX  *********************************
********************************************************************************

log on

***** TABLE D.1 ******

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal04 disadvant c.ln_cost#c.ln_imbal04 c.ln_imbal04#i.disadvant c.ln_cost#i.disadvant c.ln_cost#c.ln_imbal04#i.disadvant if year==2006 & house90==1, cluster(state)
est store D11
***test equality of marginal effect across subsamples***
test 1.disadvant#c.ln_cost 1.disadvant#c.ln_cost#c.ln_imbal04
* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal04 disadvant c.ln_cost#c.ln_imbal04 c.ln_imbal04#i.disadvant c.ln_cost#i.disadvant c.ln_cost#c.ln_imbal04#i.disadvant ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
est store D12
***test equality of marginal effect across subsamples***
test 1.disadvant#c.ln_cost 1.disadvant#c.ln_cost#c.ln_imbal04
* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 disadvant c.ln_cost#c.ln_imbal04 c.ln_imbal04#i.disadvant c.ln_cost#i.disadvant c.ln_cost#c.ln_imbal04#i.disadvant ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store D13

***test equality of marginal effect across subsamples***
test 1.disadvant#c.ln_cost 1.disadvant#c.ln_cost#c.ln_imbal04

esttab D1* using D1.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Testing Mechanism)
esttab D1* using D1.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Testing Mechanism) interaction(" X ")

***** TABLE D.2 ******

* Recall ads_dummy_top==1 if the top candidate from winning party advertise

* Column (1)
reg lnoutlays_CD109 ads_dummy_top if year==2006 & house90==1, cluster(state)
est store D21
* Column (2)
reg lnoutlays_CD109 ads_dummy_top ln_Margin ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc if year==2006 & house90==1, cluster(state)
est store D22
* Column (3)
reg lnoutlays_CD109 ads_dummy_top ln_Margin ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc i.state if year==2006 & house90==1, cluster(state)
est store D23
* Column (4)
reg lnoutlays_CD109 ads_dummy_top if year==2006 & pop75==1, cluster(state)
est store D24
* Column (5)
reg lnoutlays_CD109 ads_dummy_top ln_Margin ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc if year==2006 & pop75==1, cluster(state)
est store D25
* Column (6)
reg lnoutlays_CD109 ads_dummy_top ln_Margin ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc i.state if year==2006 & pop75==1, cluster(state)
est store D26


esttab D2* using D2.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Quantity of ads and federal spending)
esttab D2* using D2.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Quantity of ads and federal spending) tex keep(ads_dummy_top)

***** TABLE D.3 ******
* Generate variable for quantity

gen lnq=ln(q_ads_TopWin)
gen lnql=ln(q_ads_TopLose)

* Generate proxy for total expenditures
gen lnexp=lnq + ln_cost

* gen lnexp=lnexp_TopWin

* Column (1)
reg lnoutlays_CD109 lnexp ln_imbal04 c.lnexp#c.ln_imbal04 if year==2006 & house90==1, cluster(state)
est store D31

* Column (2)
reg lnoutlays_CD109 lnexp ln_imbal04 c.lnexp#c.ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
est store D32

* Column (3)
reg lnoutlays_CD109 lnexp ln_imbal04 c.lnexp#c.ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store D33

* Column (4)
reg lnoutlays_CD109 lnexp ln_imbal04 c.lnexp#c.ln_imbal04 if year==2006 & pop75==1, cluster(state)
est store D34

* Column (5)
reg lnoutlays_CD109 lnexp ln_imbal04 c.lnexp#c.ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & pop75==1, cluster(state)
est store D35

* Column (6)
reg lnoutlays_CD109 lnexp ln_imbal04 c.lnexp#c.ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & pop75==1, cluster(state)
est store D36

esttab D3* using D3.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Outlays)
esttab D3* using D3.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Outlays of ads) tex keep(lnexp ln_imbal04 c.lnexp#c.ln_imbal04)

***** TABLE D.4 ******

gen ln_cost_a=ln(est_cost_average)
label var ln_cost_a "log TV ads cost (included non-house races)"
gen ln_costimbal_a=ln_cost_a*ln_imbal04
label var ln_costimbal_a "log imbal * log ad cost"

corr ln_cost_a ln_cost
* Strong correlation between ad cost from house and from all races

* Column (1)
reg lnoutlays_CD109 ln_cost_a ln_imbal04 ln_costimbal_a if year==2006 & house90==1, cluster(state)
est store D41
* Column (2)
reg lnoutlays_CD109 ln_cost_a ln_imbal04 ln_costimbal_a ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
est store D42
* Column (3)
reg lnoutlays_CD109 ln_cost_a ln_imbal04 ln_costimbal_a ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store D43

esttab D4* using D4.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using All Ads Cost)
esttab D4* using D4.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using All Ads Cost) tex keep(ln_cost_a ln_imbal04 ln_costimbal_a)

***** TABLE D.6 ******

* Column (1)
reg ln_cost ln_imbal04 ln_Median05adj_ACS if year ==2006, cluster(state)
est store D61 
* Column (2)
reg ln_cost ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS if year ==2006, cluster(state)
est store D62
* Column (3)
reg ln_cost ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc if year ==2006, cluster(state)
est store D63 
* Column (4)
reg ln_cost ln_imbal04 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc if year ==2006 & house90==1, cluster(state)
est store D64 
* Column (5)
reg ln_cost ln_imbal04 ln_pop ln_medinc age65_pc black_pc constrct_pc school_pc farmer_pc foreign_pc miltpop_pc rurlfarm_pc unemployed_pc urban_pc ln_landarea if year==2006, cluster(state)
est store D65 

esttab D6* using D6.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Determinants of Ad Cost)
esttab D6* using D6.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Determinants of Ad Cost) tex

***** TABLE D.7 ******

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & house75==1, cluster(state)
est store D71
* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house75==1, cluster(state)
est store D72
* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house75==1, cluster(state)
est store D73
* Column (4)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006, cluster(state)
est store D74
* Column (5)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006, cluster(state)
est store D75
* Column (6)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006, cluster(state)
est store D76

esttab D7* using D7.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Alternative Cutoffs for Ad Cost Data)
esttab D7* using D7.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Alternative Cutoffs for Ad Cost Data) tex keep (ln_cost ln_imbal04 ln_costimbal)

***** TABLE D.8 ******

* Column (1)
reg high_lnoutlays_cpi ln_cost ln_imbal04 ln_costimbal if year==2006 & house90==1, cluster(state)
est store D81
* Column (2)
reg high_lnoutlays_cpi ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
est store D82
* Column (3)
reg high_lnoutlays_cpi ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store D83
* Column (4)
reg high_lnoutlays_cpi ln_cost ln_imbal04 ln_costimbal if year==2007 & house90==1, cluster(state)
est store D84
* Column (5)
reg high_lnoutlays_cpi ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2007 & house90==1, cluster(state)
est store D85
* Column (6)
reg high_lnoutlays_cpi ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2007 & house90==1, cluster(state)
est store D86

esttab D8* using D8.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Yearly Federal Spending (no average)) 
esttab D8* using D8.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Yearly Federal Spending (no average)) tex keep(ln_cost ln_imbal04 ln_costimbal)


***** TABLE D.9 ******

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_pop ln_medinc age65_pc black_pc constrct_pc school_pc farmer_pc foreign_pc miltpop_pc rurlfarm_pc unemployed_pc urban_pc ln_landarea if year==2006 & house90==1, cluster(state)
est store D91
* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_pop ln_medinc age65_pc black_pc constrct_pc school_pc farmer_pc foreign_pc miltpop_pc rurlfarm_pc unemployed_pc urban_pc ln_landarea  party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
est store D92
* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_pop ln_medinc age65_pc black_pc constrct_pc school_pc farmer_pc foreign_pc miltpop_pc rurlfarm_pc unemployed_pc urban_pc ln_landarea  party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store D93

esttab D9* using D9.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Larger Set of District Covariates (2000 Census)) 
esttab D9* using D9.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Larger Set of District Covariates (2000 Census)) tex keep(ln_cost ln_imbal04 ln_costimbal)

***** TABLE D.10 ******

* generate electoral imbalance variable for 2000 election
gen imbal_abs00=abs(margin00)

gen ln_imbal00=ln(imbal_abs00+1)
label var ln_imbal00 "log elect imbal"
gen ln_costimbal00=ln_cost*ln_imbal00
label var ln_costimbal00 "log imbal * log ad cost"
gen maj_ln_imbal00=majority*ln_imbal00

label var ln_imbal00 "Imbalance"
label var ln_costimbal00 "Imbalance x Ad Cost"

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal00 ln_costimbal00 if year==2006 & house90==1, cluster(state)
est store D_101
* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal00 ln_costimbal00 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1, cluster(state)
est store D_102
* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal00 ln_costimbal00 ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1, cluster(state)
est store D_103

esttab D_10* using D_10.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Alternative Definition of Imbalance)
esttab D_10* using D_10.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using Alternative Definition of Imbalance) tex keep(ln_cost ln_imbal00 ln_costimbal00)


***** TABLE D.11 ******

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal dma_* if year==2006 & house90==1
est store D_111
* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc dma_* if year==2006 & house90==1
est store D_112
* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* dma_* if year==2006 & house90==1
est store D_113

esttab D_11* using D_11.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using DMA Fixed Effects)
esttab D_11* using D_11.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Using DMA Fixed Effects) tex keep(ln_cost ln_imbal04 ln_costimbal)


***** TABLE D.12 ******

xtile percentileImb = ln_imbal04, nq(100)

*Cutoff 5th and 10th percentile
gen imb_dummy_5 = 0
replace imb_dummy_5 = 1 if percentileImb >= 4
gen imb_dummy_10 = 0
replace imb_dummy_10 = 1 if percentileImb >= 9

* Column (1)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & house90==1 & imb_dummy_5==1, cluster(state)
est store D_121
* Column (2)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1 & imb_dummy_5==1, cluster(state)
est store D_122
* Column (3)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1 & imb_dummy_5==1, cluster(state)
est store D_123
* Column (4)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal if year==2006 & house90==1 & imb_dummy_10==1, cluster(state)
est store D_124
* Column (5)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* if year==2006 & house90==1 & imb_dummy_10==1, cluster(state)
est store D_125
* Column (6)
reg lnoutlays_CD109 ln_cost ln_imbal04 ln_costimbal ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc party leader freshman any_chair any_rank mem_* i.state if year==2006 & house90==1 & imb_dummy_10==1, cluster(state)
est store D_126

esttab D_12* using D_12.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Excluding Lowest Levels of Imbalance)
esttab D_12* using D_12.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Excluding Lowest Levels of Imbalance) tex keep(ln_cost ln_imbal04 ln_costimbal)


log off

***** LOOKING AT QUANTITY OF ADS AS A FUNCTION OF AD COST ******

* Relationship between price and quantity: we need to control for loser's ads to
* get consistently an elasticity smaller than 1

reg lnq ln_cost if year==2006 & house90==1, cluster(state)
est store dem1

reg lnq ln_cost ln_imbal04 ln_costimbal lnql if year==2006 & house90==1, cluster(state)
est store dem2

reg lnq ln_cost ln_imbal04 ln_costimbal lnql ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc if year==2006 & house90==1, cluster(state)
est store dem3

reg lnq ln_cost if year==2006 & pop75==1, cluster(state)
est store dem4

reg lnq ln_cost ln_imbal04 ln_costimbal lnql if year==2006 & pop75==1, cluster(state)
est store dem5

reg lnq ln_cost ln_imbal04 ln_costimbal lnql ln_Median05adj_ACS ln_pop05_ACS minority_perc_ACS urban_pc if year==2006 & pop75==1, cluster(state)
est store dem6

esttab dem* using demOct.csv, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Quantity of ads)
esttab dem* using demOct.tex, ar2 replace star(* 0.10 ** 0.05 *** 0.01) label title(Quantity of ads) tex keep(ln_cost)




