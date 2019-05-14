global MyDirectory /Users/martinwilliams/Desktop/apsr_replication

capture ssc install interflex
capture ssc install reghdfe

clear
set mem 100m
set matsize 600
set more off
set scheme s2mono
graph set window fontface "Times New Roman"
graph set eps logo off
graph set eps fontface "Times New Roman"
graph set eps preview off
graph set ps logo off
graph set ps fontface "Times New Roman"
set seed 15
scalar drop _all

clear
use $MyDirectory/Williams_APSR_replication.dta

*** FIGURE 3 Project type by fund source
egen projcount_fs2=count(projtype_num), by(fundsource_pie2)
gen fundsource_pie2_lab="Gov't-funded (n=2,588)" if fundsource_pie2=="dacf"
replace fundsource_pie2_lab="Donor-funded (n=2,274)" if fundsource_pie2=="ddf"
replace fundsource_pie2_lab="Centralized (n=2,030)" if fundsource_pie2=="getfund"
replace fundsource_pie2_lab="All others (n=7,354)" if fundsource_pie2=="all others"

foreach type in school staffhousing latrine road culvert office {
gen projtype_`type'=projtype=="`type'"
replace projtype_`type'=. if projtype==""
replace projtype_`type'=. if projtype_pie=="multiple"
}

gen projtype_allother=0
foreach type in schoolother borehole water waste clinic market streetlight electricity constother agric multiple {
replace projtype_allother=1 if projtype=="`type'"
}

foreach type in school staffhousing latrine road culvert office allother {
egen projtype_`type'_tot=sum(projtype_`type'), by(fundsource_pie2)
gen projtype_`type'_pct=projtype_`type'_tot / projcount_fs2
}

egen graph_tag=tag(fundsource_pie2)
gen order_temp3=1 if fundsource_pie2=="dacf"
replace order_temp3=2 if fundsource_pie2=="ddf"
replace order_temp3=3 if fundsource_pie2=="getfund"
replace order_temp3=4 if fundsource_pie2=="all others"

graph hbar (sum) projtype_school_pct projtype_staffhousing_pct projtype_latrine_pct projtype_road_pct projtype_culvert_pct projtype_office_pct projtype_allother_pct if graph_tag==1, over(fundsource_pie2_lab, sort(order_temp3) label(angle(horizontal) labsize(small))) stack graphregion(fcolor(white) style(none)) ytitle("Percentage of projects" " ", size(small)) ylabel(0(.25)1, labsize(small)) legend(order(1 "School" 2 "Staff housing" 3 "Latrine" 4 "Road" 5 "Culvert" 6 "Office" 7 "All others") col(7) symxsize(*0.35) keygap(*.35) colgap(*0.4) size(small)) caption("Note: See text and appendices for details of fund source and project type categories.", justification(left) size(small) color(black))

graph export $MyDirectory/projtypebyfs.pdf, replace

* (color)
set scheme s2color
graph hbar (sum) projtype_school_pct projtype_staffhousing_pct projtype_latrine_pct projtype_road_pct projtype_culvert_pct projtype_office_pct projtype_allother_pct if graph_tag==1, over(fundsource_pie2_lab, sort(order_temp3) label(angle(horizontal) labsize(small))) stack graphregion(fcolor(white) style(none)) ytitle("Percentage of projects" " ", size(small)) ylabel(0(.25)1, labsize(small)) legend(order(1 "School" 2 "Staff housing" 3 "Latrine" 4 "Road" 5 "Culvert" 6 "Office" 7 "All others") col(7) symxsize(*0.35) keygap(*.35) colgap(*0.4) size(small)) caption("Note: See text and appendices for details of fund source and project type categories. Projects" "coded as multiple or missing types or fund sources included in 'All others'.", justification(left) size(small) color(black))
graph export $MyDirectory/projtypebyfs_color.pdf, replace

drop order_temp* graph_tag projtype_school-projtype_allother_pct fundsource_pie2_lab
set scheme s2mono

*** CALCULATION: Linking DMTDP projects to APR records

summ dist_aprlinked_pct dist_dmtdplinked_pct if d_agg_tag==1 & aprs_b1234==3

di .057 / .338
di .038 / .338

*** FIGURE 4 Project completion by project type
* 3-yr completion for three project types, overall
sort desurvid fid
expand 2 in 1
egen tag=tag(desurvid fid)
replace tag=. if desurvid==.
foreach var in projyear proj_comp_byyear_1_cum proj_comp_sch_byyear_1_cum proj_comp_stfhs_byyear_1_cum proj_comp_off_byyear_1_cum proj_comp_clin_byyear_1_cum proj_comp_latr_byyear_1_cum proj_comp_byyear_1 proj_comp_sch_byyear_1 proj_comp_stfhs_byyear_1 proj_comp_off_byyear_1 proj_comp_clin_byyear_1 proj_comp_latr_byyear_1 {
replace `var'=0 if tag==0
}

graph twoway line proj_comp_latr_byyear_1_cum projyear, lpattern(dash) lcolor(gs9) lwidth(thick) sort(projyear) || line proj_comp_stfhs_byyear_1_cum projyear, lpattern(shortdash) lcolor(gs10) lwidth(thick) sort(projyear) || line proj_comp_sch_byyear_1_cum projyear, lpattern(dot) lcolor(gs3) lwidth(thick) sort(projyear) || line proj_comp_byyear_1_cum projyear, lpattern(solid) lcolor(gs1) lwidth(thick) sort(projyear) xscale(range(-0.1 3.1)) xtitle("Project year") xlabel(0 1 2 3) yline(1, lstyle(grid)) ytitle("Cumulative Completion Rate" " ") ylabel(0(0.25)1, angle(horizontal)) legend(order(4 "All projects" 1 "Latrines" 2 "Staff housing" 3 "Schools") rows(1) colgap(*0.6) symxsize(*0.6) size(small)) graphregion(fcolor(white) style(none)) caption("Note: Sample is all projects from districts with all three years of data.", size(small) justification(left))
graph export $MyDirectory/projcomp_cum.pdf, replace

drop if tag==0
drop tag

*** CALCULATIONS: stats on project delay

tab project_expymtocomplete
tab project_ymtocomplete
tab project_delayym
tab project_delayym_all if proj_comp_binary==0

***
*** FIGURE 5 Variation in completion across years
***

gen order_temp=1 if year==2011
replace order_temp=2 if year==2012
replace order_temp=3 if year==2013

replace order_temp=order_temp+4 if fundsource_pie2=="ddf"
replace order_temp=order_temp+8 if fundsource_pie2=="getfund"

gen mean=.
gen uci=.
gen lci=.
foreach fs in dacf ddf getfund {
foreach year in 2011 2012 2013 {
summ proj_comp_binary if fundsource_pie2=="`fs'" & year==`year' & project_years<=2
replace mean=r(mean) if fundsource_pie2=="`fs'" & year==`year'
replace uci = r(mean) + invttail(r(N)-1,0.025)*(r(sd) / sqrt(r(N))) if fundsource_pie2=="`fs'" & year==`year'
replace lci = r(mean) - invttail(r(N)-1,0.025)*(r(sd) / sqrt(r(N))) if fundsource_pie2=="`fs'" & year==`year'
}
}

graph twoway bar mean order_temp if (fundsource_pie2=="ddf" | fundsource_pie2=="dacf" | fundsource_pie2=="getfund"), color(gs10) xtitle(" " "   Government-funded                     Donor-funded                            Centralized", size(medsmall) justification(left)) ytitle("Annual completion rate" " ", size(small)) barwidth(.8) ylabel(0 0.25 0.5 0.75 1, angle(horizontal) labsize(small)) xlabel(1 "2011" 2 "2012" 3 "2013" 5 "2011" 6 "2012" 7 "2013" 9 "2011" 10 "2012" 11 "2013", labsize(small)) graphregion(fcolor(white) style(none))  || rcap uci lci order_temp if (fundsource_pie2=="ddf" | fundsource_pie2=="dacf" | fundsource_pie2=="getfund"), color(gs4) legend(off) caption(" " "Note: Sample is all projects less than three years old (using project commencement date) within each fund source." "95% confidence interval shown. Election in December 2012.", justification(left) span size(small) color(black))
graph export $MyDirectory/projcomp_byfs_byyear.pdf, replace
drop order_temp uci lci mean

*** FIGURE 6 Missing expenditures
hist missingexp if proj_comp_binary==1, start(-102.5) width(5) percent xtitle("Pct. contract sum disbursed minus pct. work complete") xlabel(-100(20)110) ytitle("Pct.") ylabel(0(10)30, angle(horizontal)) yline(30, lstyle(grid)) graphregion(fcolor(white) style(none)) title("a: Completed projects" " ", justification(left) span size(medium))
graph save $MyDirectory/missingexp_comp.gph, replace
hist missingexp if proj_comp_binary==0, start(-102.5) width(5) percent xtitle("Pct. contract sum disbursed minus pct. work complete") xlabel(-100(20)110) ytitle("Pct.") ylabel(0(10)30, angle(horizontal)) yline(30, lstyle(grid)) graphregion(fcolor(white) style(none)) title("b: Incomplete projects" " ", justification(left) span size(medium))
graph save $MyDirectory/missingexp_incomp.gph, replace
graph combine $MyDirectory/missingexp_comp.gph $MyDirectory/missingexp_incomp.gph, rows(2) graphregion(fcolor(white) style(none)) caption("Note: Sample is 2,810 projects with data on contract sum, expenditure to date, and percent work completed.", justification(left) span size(small) color(black))
graph export $MyDirectory/missingexp.pdf, replace

* no correlation between project completion month and missingexp
bysort project_compmonth: summ missingexp
pwcorr project_compmonth missingexp, sig

*** CALCULATIONS: under- vs overpayment

* all projects

egen temp1=count(missingexp) if missingexp~=. & proj_comp_binary==1
gen temp2=missingexp<-10 if missingexp~=. & proj_comp_binary==1
egen missingexp_10below_comp=sum(temp2) if proj_comp_binary==1
replace missingexp_10below_comp=missingexp_10below_comp / temp1
gen temp3=missingexp>10 if missingexp~=. & proj_comp_binary==1
egen missingexp_10above_comp=sum(temp3) if proj_comp_binary==1
replace missingexp_10above_comp=missingexp_10above_comp / temp1
drop temp*

egen temp1=count(missingexp) if missingexp~=. & proj_comp_binary==0
gen temp2=missingexp<-10 if missingexp~=. & proj_comp_binary==0
egen missingexp_10below_incomp=sum(temp2) if proj_comp_binary==0
replace missingexp_10below_incomp=missingexp_10below_incomp / temp1
gen temp3=missingexp>10 if missingexp~=. & proj_comp_binary==0
egen missingexp_10above_incomp=sum(temp3) if proj_comp_binary==0
replace missingexp_10above_incomp=missingexp_10above_incomp / temp1
drop temp*

summ missingexp_10below_comp
scalar below_comp = r(mean)
summ missingexp_10above_comp
scalar above_comp = r(mean)
di below_comp / above_comp

summ missingexp_10below_incomp
scalar below_incomp = r(mean)
summ missingexp_10above_incomp
scalar above_incomp = r(mean)
di below_incomp / above_incomp

* DACF & DDF only
egen temp1=count(missingexp) if missingexp~=. & proj_comp_binary==1 & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf")
gen temp2=missingexp<-10 if missingexp~=. & proj_comp_binary==1 & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf")
egen missingexp_10below_comp_2=sum(temp2) if proj_comp_binary==1
replace missingexp_10below_comp_2=missingexp_10below_comp_2 / temp1
gen temp3=missingexp>10 if missingexp~=. & proj_comp_binary==1 & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf")
egen missingexp_10above_comp_2=sum(temp3) if proj_comp_binary==1
replace missingexp_10above_comp_2=missingexp_10above_comp_2 / temp1
drop temp*

egen temp1=count(missingexp) if missingexp~=. & proj_comp_binary==0 & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf")
gen temp2=missingexp<-10 if missingexp~=. & proj_comp_binary==0 & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf")
egen missingexp_10below_incomp_2=sum(temp2) if proj_comp_binary==0
replace missingexp_10below_incomp_2=missingexp_10below_incomp_2 / temp1
gen temp3=missingexp>10 if missingexp~=. & proj_comp_binary==0 & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf")
egen missingexp_10above_incomp_2=sum(temp3) if proj_comp_binary==0
replace missingexp_10above_incomp_2=missingexp_10above_incomp_2 / temp1
drop temp*

summ missing*

*** Fiscal waste calculations (and also extrapolating project completion rates past 3-year window)
* Method 1: calculate completion using full sample, cost using district capexp_actual from MLGRD budget data 
* total capexp in 2013 was GHS 317 million = USD 135 million (using 31 Dec 2013 ex rate of 2.35 from www.xe.com)
summ proj_comp_byyear_1_cum if projyear==3
gen proj_comp_byyear_1_cum_3yrs=r(mean)
gen proj_comp_3plusyears=0 if project_yearstocomplete~=.
replace proj_comp_3plusyears=1 if project_yearstocomplete>=3 & project_yearstocomplete~=.
egen proj_comp_3plusyears_rate=mean(proj_comp_3plusyears)
gen proj_comp_byyear_1_cum_extrap=proj_comp_byyear_1_cum_3yrs + (proj_comp_3plusyears_rate*(proj_comp_byyear_1_cum_3yrs + proj_comp_3plusyears_rate))
gen proj_comp_byyear_1_cum_noncomp=1 - proj_comp_byyear_1_cum_extrap

gen temp=expenditure_new_outt if projyear==3 & proj_comp_binary==0
egen waste_fiscal_pct=mean(temp)
replace waste_fiscal_pct=waste_fiscal_pct * proj_comp_byyear_1_cum_noncomp
gen waste_fiscal_ghs=waste_fiscal_pct * exp_capexptotal_act_natl 
gen waste_fiscal_usd= waste_fiscal_ghs / 2.35 
drop temp
gen temp=(pctwork/100) - expenditure_new_outt if projyear==3 & proj_comp_binary==0
egen waste_contractor_pct=mean(temp)
replace waste_contractor=waste_contractor * proj_comp_byyear_1_cum_noncomp 
gen waste_contractor_ghs=waste_contractor_pct * exp_capexptotal_act_natl 
gen waste_contractor_usd= waste_contractor_ghs / 2.35 
drop temp

format waste_fiscal_ghs waste_fiscal_usd waste_contractor_ghs waste_contractor_usd %12.0f

summ waste*
summ exp_capexptotal_act_natl exp_capexptotal_act_natl_usd

* mean new3crb cost in 2013 is GHS 88389.09 = USD 37,612.38
egen temp=mean( contsumorig_new3crb) if commenceyear==2013
summ temp
di r(mean) / 2.35
* fiscal waste is equivalent to 667.8 new3crbs
gen waste_fiscal_new3crbs=waste_fiscal_ghs / temp
summ waste_fiscal_new3crbs
drop temp
* students served - Average class size of 36.6275 (World Bank EdStats database, 2011, Average size of single grade classes in Grade 1 of primary schools)
gen students_waste_new3crbs=waste_fiscal_new3crbs * 36.6275 * 3
summ students_waste_new3crbs
* cost to contractors of non-payment for incomplete projects
summ expenditure_new_outt if projyear==3 & proj_comp_binary==0
scalar mean_expenditure_new_outt=r(mean)
summ pctwork if projyear==3 & proj_comp_binary==0
scalar mean_pctwork=r(mean) / 100
di mean_pctwork - mean_expenditure_new_outt
summ exp_capexptotal_act_natl_usd
scalar mean_capexptotal_act_natl_usd = r(mean)
di (mean_pctwork - mean_expenditure_new_outt) * mean_capexptotal_act_natl_usd

* Method 2: calculate completion using DACF+DDF, cost in % terms of budget
summ proj_comp_dacf_byyear_1_cum if projyear==3
gen proj_comp_dacf_byyear_1_cum_3yrs=r(mean)
gen proj_comp_dacf_3plusyears=0 if project_yearstocomplete~=.
replace proj_comp_dacf_3plusyears=1 if project_yearstocomplete>=3 & project_yearstocomplete~=.
egen proj_comp_dacf_3plusyears_rate=mean(proj_comp_dacf_3plusyears)
gen proj_comp_dacf_byyear_1_cum_ext=proj_comp_dacf_byyear_1_cum_3yrs + (proj_comp_dacf_3plusyears_rate*(proj_comp_dacf_byyear_1_cum_3yrs + proj_comp_dacf_3plusyears_rate))
gen proj_comp_dacf_byyear_1_cum_non=1 - proj_comp_dacf_byyear_1_cum_ext
* this variable is the overall completion rate of projects extrapolated past three year mid-estimate for completion

summ proj_comp_ddf_byyear_1_cum if projyear==3
gen proj_comp_ddf_byyear_1_cum_3yrs=r(mean)
gen proj_comp_ddf_3plusyears=0 if project_yearstocomplete~=.
replace proj_comp_ddf_3plusyears=1 if project_yearstocomplete>=3 & project_yearstocomplete~=.
egen proj_comp_ddf_3plusyears_rate=mean(proj_comp_ddf_3plusyears)
gen proj_comp_ddf_byyear_1_cum_ext=proj_comp_ddf_byyear_1_cum_3yrs + (proj_comp_ddf_3plusyears_rate*(proj_comp_ddf_byyear_1_cum_3yrs + proj_comp_ddf_3plusyears_rate))
gen proj_comp_ddf_byyear_1_cum_non=1 - proj_comp_ddf_byyear_1_cum_ext

gen temp_dacf=expenditure_new_outt if projyear==3 & proj_comp_binary==0 & fundsource_pie=="dacf"
egen waste_fiscal_pct_dacf=mean(temp_dacf)
replace waste_fiscal_pct_dacf=waste_fiscal_pct_dacf * proj_comp_dacf_byyear_1_cum_non
gen waste_fiscal_ghs_dacf=waste_fiscal_pct_dacf * (115494291.21)
* note: GHS 115,494,291.21 is net release to districts of DACF in 2013 reported in Ghana Audit Service DACF/DDF audit, Appendix A
gen temp_ddf=expenditure_new_outt if projyear==3 & proj_comp_binary==0 & fundsource_pie=="ddf"
egen waste_fiscal_pct_ddf=mean(temp_ddf)
replace waste_fiscal_pct_ddf=waste_fiscal_pct_ddf * proj_comp_ddf_byyear_1_cum_non
gen waste_fiscal_ghs_ddf=waste_fiscal_pct_ddf * (73000000)
* note: GHS 73,000,000 is net release to districts of ddf in 2013 reported in Ghana Audit Service DACF/DDF audit, Appendix D
gen waste_fiscal_pct_dacfddf=(waste_fiscal_ghs_dacf + waste_fiscal_ghs_ddf) / (115494291.21 + 73000000)

summ waste_fiscal_pct_dacfddf
drop temp_dacf-waste_fiscal_ghs_ddf

*** CALCULATIONS: Correlation of revenue outturns with NDC vote share and project completion

pwcorr rev_total_outt ecpres2008_voteshare_ndc if dy_tag==1, sig
pwcorr rev_grants_outt ecpres2008_voteshare_ndc if dy_tag==1, sig

reg rev_total_outt ecpres2008_voteshare_ndc ecpres2008_voteshare_ndc_sq if dy_tag==1
reg rev_grants_outt ecpres2008_voteshare_ndc ecpres2008_voteshare_ndc_sq if dy_tag==1

egen dy_proj_comp=mean(proj_comp_binary), by(dy_group)

pwcorr dy_proj_comp rev_total_outt if dy_tag==1, sig
pwcorr dy_proj_comp rev_grants_outt if dy_tag==1, sig

*** Revenue growth

bysort year: summ rev_total_act if dy_tag==1 & aprs_b1234==3

* mean
di 3681703/3381857
di 3993479/3681703

***************************************
*************************************** Regressions
***************************************

**************
************** TABLE 2
**************

*** no FE, no interaction
 xi: xtreg proj_comp_binary fundsource_pie_dacf ///
ecpres2008_voteshare_ndc  ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs year2012 year2013 ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf", i(dy_group) robust cluster(dy_group)
 xttest0
scalar r2 = e(r2_o)

eststo a1, addscalars(R2 r2)
estadd local re "Yes"
estadd local dy " "
estadd local cont " "
estadd local loc " "
estadd local locyear " "
eststo a1, addscalars(dy_g e(N_g))

*** no FE, interaction
 xi: xtreg proj_comp_binary fundsource_pie_dacf ///
ecpres2008_voteshare_ndc fundsource_pie_dacf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs year2012 year2013 ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf", i(dy_group) robust cluster(dy_group)

scalar r2 = e(r2_o)

eststo a2, addscalars(R2 r2)
estadd local re "Yes"
estadd local dy " "
estadd local cont " "
estadd local loc " "
estadd local locyear " "
eststo a2, addscalars(dy_g e(N_g))

* CALCULATIONS: Effect size
set obs 14618
summ ecpres2008_voteshare_ndc, detail
foreach var in _Iprojtype__2 _Iprojtype__3 _Iprojtype__4 _Iprojtype__5 _Iprojtype__6 _Iprojtype__7 _Iprojtype__8 _Iprojtype__9 _Iprojtype__10 _Iprojtype__11 _Iprojtype__12 _Iprojtype__13 _Iprojtype__14 _Iprojtype__15 _Iprojtype__16 _Iprojtype__17 _Iprojtype__18 _Iprojtype__19 _Iprojtype__20 _Iprojtype__21 _Iprojtype__22 fundsource_pie_dacf_ndc consttype_const consttype_maintrehab projyear_2 projyear_3 fundsource_pie_dacf fundsource_pie_ddf {
replace `var'=0 in 14615/14618
}

replace ecpres2008_voteshare_ndc=r(p95) in 14615
replace ecpres2008_voteshare_ndc=r(p5) in 14616
replace ecpres2008_voteshare_ndc=r(p95) in 14617
replace ecpres2008_voteshare_ndc=r(p5) in 14618
replace fundsource_pie_dacf=1 in 14615/14616
replace fundsource_pie_ddf=1 in 14617/14618
replace fundsource_pie_dacf_ndc=r(p95) in 14615
replace fundsource_pie_dacf_ndc=r(p5) in 14616
replace consttype_const=1 in 14615/14618
replace _Iprojtype__17=1 in 14615/14618
replace year2012=0 in 14615/14618
replace year2013=0 in 14615/14618

predict abseff in 14615/14618

predict abseff_se in 14615/14618, stdp

gen abseff_uci=abseff + 1.96 * abseff_se
gen abseff_lci=abseff - 1.96 * abseff_se

list abseff* in 14615/14618

drop in 14615/14618
drop abseff*

 *** district-year FE, no interaction
 xi: xtreg proj_comp_binary fundsource_pie_dacf ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf", fe i(dy_group) robust cluster(dy_group)

scalar b_fundsource_pie_dacf_base = _b[fundsource_pie_dacf]

 *** district-year FE
xi: areg proj_comp_binary fundsource_pie_dacf ///
fundsource_pie_dacf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf ///
fundsource_pie_dacf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf", fe i(dy_group) robust cluster(dy_group)
eststo a3, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
estadd local cont " "
estadd local loc " "
estadd local locyear " "
eststo a3, addscalars(dy_g e(N_g))

summ ecpres2008_voteshare_ndc
scalar ecpres2008_voteshare_ndc_sd = r(sd)
scalar sdeff_ecpres2008_voteshare_ndc = ecpres2008_voteshare_ndc_sd * _b[fundsource_pie_dacf_ndc]
di sdeff_ecpres2008_voteshare_ndc
di sdeff_ecpres2008_voteshare_ndc / b_fundsource_pie_dacf_base

 *** GETFund interaction, district-year FE
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)
eststo a4, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
estadd local cont " "
estadd local loc " "
estadd local locyear " "
eststo a4, addscalars(dy_g e(N_g))

lincom fundsource_pie_getf_ndc-fundsource_pie_dacf_ndc

*** GETFund interaction, contractor FE
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
i.dy_group ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(contractor_num) robust cluster(contractor_num)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
i.dy_group ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(contractor_num) robust cluster(contractor_num)
gen dy_tag_reg=1 if (dy_tag==1 & e(sample)==1)
summ dy_tag_reg
scalar dy_group_num = r(N)
drop dy_tag_reg

eststo a5, addscalars(R2 r2)
eststo a5, addscalars(cont_g e(N_g))
estadd local re " "
estadd local dy "Yes"
estadd local cont "Yes"
estadd local loc " "
estadd local locyear " "
eststo a5, addscalars(dy_g dy_group_num)

scalar sdeff_cont_voteshare_ndc = ecpres2008_voteshare_ndc_sd * _b[fundsource_pie_dacf_ndc]
di sdeff_cont_voteshare_ndc
di sdeff_cont_voteshare_ndc / b_fundsource_pie_dacf_base

summ ecpres2008_voteshare_ndc, detail
di _b[fundsource_pie_dacf] + r(p5) * _b[fundsource_pie_dacf_ndc]
di _b[fundsource_pie_dacf] + r(p95) * _b[fundsource_pie_dacf_ndc]

*** GETFund interaction, community FE
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
year2012 year2013 ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(location_num) robust cluster(location_num)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
year2012 year2013 ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(location_num) robust cluster(location_num)
eststo a6, addscalars(R2 r2)
estadd local dy " "
estadd local cont " "
estadd local loc "Yes"
estadd local locyear " "
eststo a6, addscalars(loc_g e(N_g))

*** Community-year FE

xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), absorb(locyear) robust cluster(locyear)
scalar r2 = e(r2)

xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), fe i(locyear) robust cluster(locyear)
eststo a7, addscalars(R2 r2)
estadd local dy " "
estadd local cont " "
estadd local loc " "
estadd local locyear "Yes"
eststo a7, addscalars(locyear_g e(N_g))

* Esttab
esttab a1 a2 a3 a4 a6 a7 a5 using $MyDirectory/regtable1.tex, scalars("re District-Year random effects" "dy District-Year fixed effects" "loc Community fixed effects" "locyear Community-year fixed effects" "cont Contractor fixed effects" "dy_g District-Year groups" "loc_g Community groups" "locyear_g Community-year groups" "cont_g Contractor groups" "R2 \(R^{2}\)") coeflabels(fundsource_pie_dacf "Government-funded" fundsource_pie_getf "Centralized" ecpres2008_voteshare_ndc "NDC vote share" fundsource_pie_dacf_ndc "Gov't-funded * NDC vote share" fundsource_pie_getf_ndc "Centralized * NDC vote share") sfmt(0 0 0 0 0 0 0 0 0 3 0) keep(fundsource_pie_dacf fundsource_pie_getf ecpres2008_voteshare_ndc fundsource_pie_dacf_ndc fundsource_pie_getf_ndc) obslast order(fundsource_pie_dacf ecpres2008_voteshare_ndc fundsource_pie_dacf_ndc fundsource_pie_getf fundsource_pie_getf_ndc) nomtitles b(3) se(3) nor2 se nostar nonotes nodepvars booktabs replace

**************
************** FIGURE 7: Marginal effects
**************

*** NDC Vote share
gen fundsource_pie_margins=2 if fundsource_pie_ddf==1
replace fundsource_pie_margins=0 if fundsource_pie_dacf==1 
replace fundsource_pie_margins=1 if fundsource_pie_getf==1 
fvset base 2 fundsource_pie_margins
gen negativepoint5=-.45
generate pipe = "|"

xtreg proj_comp_binary i.fundsource_pie_margins ///
i.fundsource_pie_margins#c.ecpres2008_voteshare_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs_num ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)

margins, dydx(fundsource_pie_margins) at(ecpres2008_voteshare_ndc=(.1(.2).9)) noestimcheck
marginsplot, xtitle("NDC vote share 2008") plot1opts(mcolor(gs3) msymbol(D) lcolor(gs3)) plot2opts(mcolor(gs6) msymbol(O) lcolor(gs6)) xlabel(0(.1)1) ytitle("Predicted marginal effect" " ") yscale(range(-.5 .25)) ylabel(-.25(.25).25, angle(horizontal)) yline(0, lpattern(dash)) graphregion(fcolor(white) style(none)) title(" ") legend(order(3 "Gov't-funded" 4 "Centralized")) addplot(scatter negativepoint5 ecpres2008_voteshare_ndc, mlabel(pipe) mlabpos(0) msymbol(none) mcolor(gs9) mlabcolor(gs9) xlabel(0(.1)1) yscale(range(-.5 .25)) ylabel(-.25(.25).25, angle(horizontal)) legend(order(3 "Gov't-funded" 4 "Centralized")))  caption("Note: Marginal effects of partisan alignment on predicted completion of government-funded and centralized projects" "are shown relative to its effect on donor-funded projects (dashed line at zero), with 95% confidence intervals. Based" "on Table 2, Column 4.", size(small) justification(left) span)
graph export $MyDirectory/margins_ndc.pdf, replace

**************
************** TABLE 3: Selection on within-community unobservables
**************

*** Location FE - Unrestricted model
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
year2012 year2013 ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(location_num) robust cluster(location_num)
scalar r2 = e(r2)

scalar r2_u = e(r2)
scalar b_u = _b[fundsource_pie_dacf_ndc]

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
year2012 year2013 ///
 if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(location_num) robust cluster(location_num)
eststo b2, addscalars(R2 r2)
estadd local dy " "
estadd local loc "Yes"
eststo b2, addscalars(loc_g e(N_g))

*** District-year FE only, sample is non-missing locations - Restricted model
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if location_num~=. & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

scalar r2_r = e(r2)
scalar b_r = _b[fundsource_pie_dacf_ndc]

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if location_num~=. & (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), fe i(dy_group) robust cluster(dy_group)
eststo b1, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
estadd local loc " "
eststo b1, addscalars(dy_g e(N_g))

*** Esttab
esttab b1 b2 using $MyDirectory/regtable2.tex, scalars("dy District-Year fixed effects" "loc Community fixed effects" "dy_g District-Year groups" "loc_g Community groups" "R2 \(R^{2}\)") coeflabels(fundsource_pie_dacf "Government-funded" fundsource_pie_getf "Centralized" fundsource_pie_dacf_ndc "Gov't-funded * NDC vote share" fundsource_pie_getf_ndc "Centralized * NDC vote share") sfmt(0 0 0 0 3 0) keep(fundsource_pie_dacf fundsource_pie_getf fundsource_pie_dacf_ndc fundsource_pie_getf_ndc) obslast order(fundsource_pie_dacf fundsource_pie_getf fundsource_pie_dacf_ndc fundsource_pie_getf_ndc) nomtitles b(3) se(3) nor2 se nostar nonotes nodepvars booktabs replace

*** Estimate b with delta=1

* delta=1, rmax=1
di b_u - 1 * (b_r - b_u) * ((1 - r2_u) / (r2_u - r2_r))

* delta=1, rmax=1.3 * r2_u
di b_u - 1 * (b_r - b_u) * (((1.3 * r2_u) - r2_u) / (r2_u - r2_r))

* value of delta that makes b=0, rmax = 1.3 * r2_u
di b_u - 58.48 * (b_r - b_u) * ((1 - r2_u) / (r2_u - r2_r))


**************
************** Appendix B: balancing tests
**************

*** FIGURE A1
egen dy_tag_all=tag(district_label_post year)
gen dy_tag_all_from2011=dy_tag_all
replace dy_tag_all_from2011=0 if year==2010

egen temp=max(aprs_b1234), by(district_label_post_agg)
replace temp=0 if temp==.
egen temp2=sum(dy_tag_all_from2011), by(district_label_post_agg)
gen aprs_missing=temp2 - temp
drop temp temp2

gen temp=rev_total_act if year==2013 & dy_tag_all==1
egen rev_total_act_2013_m=max(temp), by(district_label_post_agg)
replace rev_total_act_2013_m= rev_total_act_2013_m/1000000
drop temp

egen dist_agg_proj_comp_bin=mean(proj_comp_binary), by(district_label_post_agg)

foreach var in dist_agg_proj_comp_bin foat1112_total_mean phc_pop_total_ln phc_pop_urban_pct phc_literacy_18plus phc_everschool_18plus phc_mobilephone_18plus phc_pubsector_18plus phc_lighting phc_watersource phc_toilet ecpres2008_voteshare_ndc rev_total_act_2013 {
gen bt_`var'_mean=.
gen bt_`var'_uci=.
gen bt_`var'_lci=.
foreach n in 0 1 2 3 {
summ `var' if aprs_missing==`n' & d_agg_tag==1
replace bt_`var'_mean=r(mean) if aprs_missing==`n'  & d_agg_tag==1
replace bt_`var'_uci=bt_`var'_mean + 1.96*(r(sd)/(r(N)^.5)) if aprs_missing==`n'  & d_agg_tag==1
replace bt_`var'_lci=bt_`var'_mean - 1.96*(r(sd)/(r(N)^.5)) if aprs_missing==`n'  & d_agg_tag==1
}
}

twoway rcap bt_dist_agg_proj_comp_bin_uci bt_dist_agg_proj_comp_bin_lci aprs_missing || scatter bt_dist_agg_proj_comp_bin_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.3(.10).60, angle(horizontal)) ytitle("Mean annual comp. rate", size(small)) xtitle("APRs missing") title("Project completion", size(medium))
graph save $MyDirectory/bt_projcomp.gph, replace
twoway rcap bt_phc_pop_total_ln_uci bt_phc_pop_total_ln_lci aprs_missing || scatter bt_phc_pop_total_ln_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(11(0.5)12, angle(horizontal)) yline(12, lstyle(grid)) ytitle("Log pop'n", size(small))  xtitle("APRs missing") title("Total population", size(medium))
graph save $MyDirectory/bt_pop.gph, replace
twoway rcap bt_phc_pop_urban_pct_uci bt_phc_pop_urban_pct_lci aprs_missing || scatter bt_phc_pop_urban_pct_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.1(.1).5, angle(horizontal)) ytitle("% urban", size(small))  xtitle("APRs missing") title("Population % urban", size(medium))
graph save $MyDirectory/bt_popurban.gph, replace
twoway rcap bt_foat1112_total_mean_uci bt_foat1112_total_mean_lci aprs_missing || scatter bt_foat1112_total_mean_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(70(5)90, angle(horizontal)) yline(90, lstyle(grid)) ytitle("Mean 2011-12 score", size(small))  xtitle("APRs missing") title("FOAT score", size(medium))
graph save $MyDirectory/bt_foat.gph, replace

twoway rcap bt_phc_literacy_18plus_uci bt_phc_literacy_18plus_lci aprs_missing || scatter bt_phc_literacy_18plus_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(.3(0.1).8, angle(horizontal)) yline(.8, lstyle(grid)) ytitle("% literate (18+)", size(small))  xtitle("APRs missing") title("Literacy rate", size(medium))
graph save $MyDirectory/bt_literacy.gph, replace
twoway rcap bt_phc_everschool_18plus_uci bt_phc_everschool_18plus_lci aprs_missing || scatter bt_phc_everschool_18plus_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(.3(.1).8, angle(horizontal)) yline(.8, lstyle(grid)) ytitle("% ever att. school (18+)", size(small))  xtitle("APRs missing") title("Ever attended school", size(medium))
graph save $MyDirectory/bt_everschool.gph, replace
twoway rcap bt_phc_mobilephone_18plus_uci bt_phc_mobilephone_18plus_lci aprs_missing || scatter bt_phc_mobilephone_18plus_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(.2(.1).6, angle(horizontal)) yline(.6, lstyle(grid)) ytitle("% own mob. phone (18+)", size(small))  xtitle("APRs missing") title("Mobile phone ownership", size(medium))
graph save $MyDirectory/bt_mobilephone.gph, replace
twoway rcap bt_phc_pubsector_18plus_uci bt_phc_pubsector_18plus_lci aprs_missing || scatter bt_phc_pubsector_18plus_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.01(.01).06, angle(horizontal)) yline(.06, lstyle(grid)) ytitle("% in pub. sector (18+)", size(small))  xtitle("APRs missing") title("Public sector labor share", size(medium))
graph save $MyDirectory/bt_pubsector.gph, replace
twoway rcap bt_phc_lighting_uci bt_phc_lighting_lci aprs_missing || scatter bt_phc_lighting_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.2(.1).7, angle(horizontal)) yline(.7, lstyle(grid)) ytitle("% access", size(small))  xtitle("APRs missing") title("Access to electricity", size(medium))
graph save $MyDirectory/bt_lighting.gph, replace
twoway rcap bt_phc_watersource_uci bt_phc_watersource_lci aprs_missing || scatter bt_phc_watersource_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.5(.1).8, angle(horizontal)) yline(.8, lstyle(grid)) ytitle("% access", size(small))  xtitle("APRs missing") title("Access to water", size(medium))
graph save $MyDirectory/bt_watersource.gph, replace
twoway rcap bt_phc_toilet_uci bt_phc_toilet_lci aprs_missing || scatter bt_phc_toilet_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.3(.1).9, angle(horizontal)) yline(.9, lstyle(grid)) ytitle("% access", size(small))  xtitle("APRs missing") title("Access to toilet facilities", size(medium))
graph save $MyDirectory/bt_toilet.gph, replace
twoway rcap bt_ecpres2008_voteshare_ndc_uci bt_ecpres2008_voteshare_ndc_lci aprs_missing || scatter bt_ecpres2008_voteshare_ndc_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(0.4(0.1).7, angle(horizontal)) ytitle("Voteshare", size(small))  xtitle("APRs missing") title("NDC voteshare 2008", size(medium))
graph save $MyDirectory/bt_ecpres2008.gph, replace
twoway rcap bt_rev_total_act_2013_uci bt_rev_total_act_2013_lci aprs_missing || scatter bt_rev_total_act_2013_mean aprs_missing, mcolor(gs4) xlabel( 0 1 2 3, noticks) xscale(range(-0.5 3.5)) legend(off) graphregion(fcolor(white) style(none)) ylabel(1(1)8, angle(horizontal)) ytitle("GHS millions", size(small)) yline(8, lstyle(grid)) xtitle("APRs missing") title("Revenue 2013 (actual)", size(medium))
graph save $MyDirectory/bt_revtotal.gph, replace

graph combine $MyDirectory/bt_projcomp.gph $MyDirectory/bt_pop.gph $MyDirectory/bt_popurban.gph $MyDirectory/bt_foat.gph $MyDirectory/bt_everschool.gph $MyDirectory/bt_mobilephone.gph $MyDirectory/bt_pubsector.gph $MyDirectory/bt_lighting.gph $MyDirectory/bt_watersource.gph $MyDirectory/bt_toilet.gph $MyDirectory/bt_ecpres2008.gph $MyDirectory/bt_revtotal.gph, col(3) xsize(7) ysize(8) xcommon graphregion(fcolor(white) style(none)) caption("Note: Mean and 95% confidence intervals shown for each group of districts. Access to electricity is percentage" "of individuals reporting using mains electricity for lighting; access to water is percentage reporting using" "pipe-borne, borehole, or public tap water for drinking; access to toilet facilities is percentage using a WC," "KVIP, pit latrine, or public toilet facility (all from Population and Housing Census 2010).", size(vsmall))
graph export $MyDirectory/balancing.pdf, replace

drop bt_*

*** TABLE A1: Variable coverage
count if q4~=""
count if proj_comp_binary~=.
count if fundsource1~=""
count if location_num~=.
count if q8~="" & q8~="-222" & q8~="-222.00" & q8~="-777"
count if commenceyear~=.
count if completeyear~=.
count if expcompleteyear~=.
count if contractor_num~=.
count if q17~="" & q17~="-222" & q17~="-222.00" & q17~="-777"

**************
************** Appendix D: Attrition and estimating completion
**************

*** TABLE A2

*** FS dummies only
xi: reg attrition fundsource_pie_dacf fundsource_pie_getf ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", robust cluster(dy_group)
scalar r2 = e(r2)

eststo attr1, addscalars(R2 r2)
estadd local dy " "
estadd local loc " "

*** district-year FE
xi: areg attrition fundsource_pie_dacf fundsource_pie_getf ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

xi: xtreg attrition fundsource_pie_dacf fundsource_pie_getf ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)
eststo attr2, addscalars(R2 r2)
eststo attr2, addscalars(dy_g e(N_g))

estadd local dy "Yes"
estadd local loc " "

*** community FE
xi: areg attrition fundsource_pie_dacf fundsource_pie_getf ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
year2012 year2013 ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(location_num) robust cluster(location_num)
scalar r2 = e(r2)

xi: xtreg attrition fundsource_pie_dacf fundsource_pie_getf ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
year2012 year2013 ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(location_num) robust cluster(location_num)
eststo attr3, addscalars(R2 r2)
eststo attr3, addscalars(loc_g e(N_g))
estadd local dy " "
estadd local loc "Yes"

esttab attr1 attr2 attr3 using $MyDirectory/attrition_replication.tex, scalars("dy District-Year fixed effects" "loc Community fixed effects" "dy_g District-Year groups" "loc_g Community groups" "R2 \(R^{2}\)") coeflabels(fundsource_pie_dacf "Gov't-funded" fundsource_pie_getf "Centralized") sfmt(0 0 0 0 3 0) keep(fundsource_pie_dacf fundsource_pie_getf) obslast order(fundsource_pie_dacf fundsource_pie_getf) b(3) se(3) nor2 se nostar nonotes nodepvars nomtitles booktabs replace
* Note: for some reason it is necessary to manually add the "Yes" to Community FE in the .tex file. To avoid overwriting the original file, the above file is given the suffix _replication. It is identical to the attrition.tex table except for this formatting issue.

*** FIGURE A2: Three estimation methods

*** Project completion - 3-yr and annual
sort desurvid fid

expand 2 in 1
egen tag=tag(desurvid fid)
replace tag=. if desurvid==.
foreach var in projyear project_years_plusone proj_comp_byyear_1_cum proj_comp_byyear_2_cum proj_comp_byyear_3_cum proj_comp_byyear_1 proj_comp_byyear_2 proj_comp_byyear_3 {
replace `var'=0 if tag==0
}
graph twoway line proj_comp_byyear_3_cum project_years_plusone, lpattern(dash) lcolor(gs12) lwidth(thick) sort(project_years_plusone) || line proj_comp_byyear_1_cum projyear, lpattern(dash) lcolor(gs9) lwidth(thick) sort(projyear) || line proj_comp_byyear_2_cum projyear, lpattern(dash) lcolor(gs4) lwidth(thick) sort(projyear) xscale(range(0 3)) xtitle("Project year") xlabel(0 1 2 3) yline(1, lstyle(grid)) ytitle("Completion Rate") ylabel(0(0.25)1, angle(horizontal)) legend(order(1 "Upper bound" 2 "Middle estimate" 3 "Lower bound") rows(1)) graphregion(fcolor(white) style(none)) title(" ") caption("Note: See text for details of methodology.", size(medsmall) justification(left))
graph export $MyDirectory/projcomp_3yrcum.pdf, replace
drop if tag==0
drop tag

*** FIGURE A3: Project completion by fundsource - upper and lower est.

expand 2 in 1
egen tag=tag(desurvid fid)
replace tag=. if desurvid==.
foreach var of varlist projyear project_years_plusone proj_comp_dacf_byyear_1_cum- proj_comp_getf_byyear_3_cum {
replace `var'=0 if tag==0
}
graph twoway line proj_comp_ddf_byyear_3_cum project_years_plusone, lpattern(dash) lcolor(gs9) lwidth(thick) sort(project_years_plusone) || line proj_comp_dacf_byyear_3_cum project_years_plusone, lpattern(shortdash) lcolor(gs5) lwidth(thick) sort(project_years_plusone) || line proj_comp_getf_byyear_3_cum project_years_plusone, lpattern(solid) lcolor(gs11) lwidth(thick) sort(project_years_plusone) xscale(range(0 3)) xtitle("Project year", size(medsmall)) xlabel(0 1 2 3) yline(1, lstyle(grid)) ytitle("Completion Rate" " ", size(medsmall)) ylabel(0(0.25)1, angle(horizontal)) legend(order(1 "Donor-funded" 2 "Gov't-funded" 3 "Centralized") rows(1)) graphregion(fcolor(white) style(none)) title("a. Upper bound estimate", justification(center))
graph save $MyDirectory/comp_byfs_upper.gph, replace
graph twoway line proj_comp_ddf_byyear_1_cum projyear, lpattern(dash) lcolor(gs9) lwidth(thick) sort(projyear) || line proj_comp_dacf_byyear_1_cum projyear, lpattern(shortdash) lcolor(gs5) lwidth(thick) sort(projyear) || line proj_comp_getf_byyear_1_cum projyear, lpattern(solid) lcolor(gs11) lwidth(thick) sort(projyear) xscale(range(0 3)) xtitle("Project year", size(medsmall)) xlabel(0 1 2 3) yline(1, lstyle(grid)) ytitle(" ", size(small)) ylabel(0(0.25)1, angle(horizontal)) graphregion(fcolor(white) style(none)) title("b. Middle estimate", justification(center))
graph save $MyDirectory/comp_byfs_mid.gph, replace
graph twoway line proj_comp_ddf_byyear_2_cum projyear, lpattern(dash) lcolor(gs9) lwidth(thick) sort(projyear) || line proj_comp_dacf_byyear_2_cum projyear, lpattern(shortdash) lcolor(gs5) lwidth(thick) sort(projyear) || line proj_comp_getf_byyear_2_cum projyear, lpattern(solid) lcolor(gs11) lwidth(thick) sort(projyear) xscale(range(0 3)) xtitle("Project year", size(medsmall)) xlabel(0 1 2 3) yline(1, lstyle(grid)) ytitle(" ", size(small)) ylabel(0(0.25)1, angle(horizontal)) graphregion(fcolor(white) style(none)) title("c. Lower bound estimate", justification(center))
graph save $MyDirectory/comp_byfs_lower.gph, replace
grc1leg $MyDirectory/comp_byfs_upper.gph $MyDirectory/comp_byfs_mid.gph $MyDirectory/comp_byfs_lower.gph, xcommon ycommon rows(1) graphregion(fcolor(white) style(none)) legendfrom($MyDirectory/comp_byfs_upper.gph) caption("Note: See text for details of methodology.", size(small) justification(left)) name(temp, replace)
graph export $MyDirectory/projcomp_byfs_uppermiddlelower.pdf, replace
drop if tag==0
drop tag

**************
************** Appendix F: Robustness 
**************

*** TABLE A3

 * Logit of baseline specification
 xi: xtlogit proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs  ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), re i(dy_group) vce(cluster dy_group)

eststo rob1
estadd local re "Yes"
estadd local dy " "
 
 *** Schools only, dy FE
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund") & projtype=="school", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund") & projtype=="school", fe i(dy_group) robust cluster(dy_group)
eststo rob2, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
eststo rob2, addscalars(dy_g e(N_g))

*** Schools with additional facilities
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
crb_ancillary crb_toilet crb_officestorelibrary ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund") & projtype=="school", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
crb_ancillary crb_toilet crb_officestorelibrary ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund") & projtype=="school", fe i(dy_group) robust cluster(dy_group)
eststo rob3, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
eststo rob3, addscalars(dy_g e(N_g))

 *** First year projects only, dy FE
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund") & project_years==0, absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund") & project_years==0, fe i(dy_group) robust cluster(dy_group)
eststo rob4, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
eststo rob4, addscalars(dy_g e(N_g))

* DY FE, including contract sum
 xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs contsumorig_new_ln ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)
 
 xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs contsumorig_new_ln ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), fe i(dy_group) robust cluster(dy_group)
eststo rob5, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
eststo rob5, addscalars(dy_g e(N_g))

* Baseline specification, including expected completion months
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs project_expymtocomplete ///
if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs project_expymtocomplete ///
 if (fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund"), fe i(dy_group) robust cluster(dy_group)
eststo rob6, addscalars(R2 r2)
estadd local re " "
estadd local dy "Yes"
eststo rob6, addscalars(dy_g e(N_g))

esttab rob1 rob3 rob4 rob5 rob6 using $MyDirectory/robustness_replication.tex, scalars("re District-Year RE" "dy District-Year FE" "dy_g District-Year groups" "R2 \(R^{2}\)") coeflabels(fundsource_pie_dacf "Gov't-funded" fundsource_pie_getf "Centralized" fundsource_pie_dacf_ndc "Gov't-funded * NDC vote share" fundsource_pie_getf_ndc "Centralized * NDC vote share" crb_ancillary "Ancillary facilities" crb_toilet "Toilet" crb_officestorelibrary "Office/ store/ library" contsumorig_new_ln "Ln(contract sum)" project_expymtocomplete "Scheduled duration") sfmt(0 0 0 3 0) keep(fundsource_pie_dacf fundsource_pie_getf fundsource_pie_dacf_ndc fundsource_pie_dacf_ndc fundsource_pie_getf_ndc crb_ancillary crb_toilet crb_officestorelibrary contsumorig_new_ln project_expymtocomplete) obslast order(fundsource_pie_dacf fundsource_pie_getf fundsource_pie_dacf_ndc fundsource_pie_dacf_ndc fundsource_pie_getf_ndc crb_ancillary crb_toilet crb_officestorelibrary contsumorig_new_ln project_expymtocomplete) mtitles("Logit" "Schools" "First-year" "Cost" "Duration") b(3) se(3) nor2 se nostar nonotes nodepvars booktabs replace
* Note: because of the logit, the first variable row ("main") has to be deleted from the .tex table, so the suffix _replication is added to the .tex file in the command above to avoid overwriting the table with this formatting correction

**************
************** FIGURE A4: Hainmueller et al 2017 interaction term diagnostics
************** 

gen D=0 if fundsource_pie_ddf==1
replace D=1 if fundsource_pie_dacf==1

*** common support
twoway (scatter proj_comp_binary ecpres2008_voteshare_ndc) (lowess proj_comp_binary ecpres2008_voteshare_ndc), by(D)

*** marginal effects, no FE
xi: interflex proj_comp_binary D ecpres2008_voteshare_ndc consttype_const consttype_maintrehab projyear_2 projyear_3 i.projtype_cs project_expymtocomplete, cl(dy_group) dlabel("Gov't-funded") ylabel("Project completion") xlabel("NDC vote share 2008") title("a. No FE")
graph save $MyDirectory/mfx_noFE.gph, replace

*** marginal effects, DY FE
xi: interflex proj_comp_binary D ecpres2008_voteshare_ndc consttype_const consttype_maintrehab projyear_2 projyear_3 i.projtype_cs project_expymtocomplete, cl(dy_group) fe(dy_group) vce(robust) dlabel("Gov't-funded") ylabel("Project completion") xlabel("NDC vote share 2008") title("b. District-year FE")
graph save $MyDirectory/mfx_DYFE.gph, replace

graph combine $MyDirectory/mfx_noFE.gph $MyDirectory/mfx_DYFE.gph, rows(1) graphregion(fcolor(white) style(none)) caption("Note: Marginal effects calculated using Stata command interflex. Sample is all donor- or" "government- funded projects. Both graphs include controls described in Table A3. Robust" "standard errors clustered by district-year.")
graph export $MyDirectory/mfx.pdf, replace

**************
************** TABLE A4: Ethnicity
**************

* Ethnic fractionalization
areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_frac fundsource_pie_getf_frac /// ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs_num ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_frac fundsource_pie_getf_frac /// ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs_num ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)
eststo alt1, addscalars(R2 r2)
estadd local dy "Yes"
eststo alt1, addscalars(dy_g e(N_g))

* Ethnic polarization 
areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_polar fundsource_pie_getf_polar ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs_num ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_polar fundsource_pie_getf_polar ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs_num ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)
eststo alt2, addscalars(R2 r2)
estadd local dy "Yes"
eststo alt2, addscalars(dy_g e(N_g))

* Fractionalization + NDC vote share
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
fundsource_pie_dacf_frac fundsource_pie_getf_frac ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
fundsource_pie_dacf_frac fundsource_pie_getf_frac ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)
eststo alt3, addscalars(R2 r2)
estadd local dy "Yes"
eststo alt3, addscalars(dy_g e(N_g))

* Fractionalization + NDC vote share
xi: areg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
fundsource_pie_dacf_frac fundsource_pie_getf_frac ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", absorb(dy_group) robust cluster(dy_group)
scalar r2 = e(r2)

xi: xtreg proj_comp_binary fundsource_pie_dacf fundsource_pie_getf ///
fundsource_pie_dacf_ndc fundsource_pie_getf_ndc ///
fundsource_pie_dacf_polar fundsource_pie_getf_polar ///
consttype_const consttype_maintrehab projyear_2 projyear_3 /// 
i.projtype_cs ///
if fundsource_pie2=="dacf" | fundsource_pie2=="ddf" | fundsource_pie2=="getfund", fe i(dy_group) robust cluster(dy_group)
eststo alt4, addscalars(R2 r2)
estadd local dy "Yes"
eststo alt4, addscalars(dy_g e(N_g))

esttab alt1 alt2 alt3 alt4 using $MyDirectory/ethnic.tex, scalars("dy District-Year FE" "dy_g District-Year groups" "R2 \(R^{2}\)") coeflabels(fundsource_pie_dacf "Gov't-funded" fundsource_pie_getf "Centralized" fundsource_pie_dacf_ndc "Gov't-funded * NDC vote share" fundsource_pie_getf_ndc "Centralized * NDC vote share" fundsource_pie_dacf_frac "Gov't-funded * Ethnic fractionalization" fundsource_pie_getf_frac "Centralized * Ethnic fractionalization" fundsource_pie_dacf_polar "Gov't-funded * Ethnic polarization" fundsource_pie_getf_polar "Centralized * Ethnic polarization" ) sfmt(0 0 3 0) keep(fundsource_pie_dacf fundsource_pie_getf fundsource_pie_dacf_frac fundsource_pie_getf_frac fundsource_pie_dacf_polar fundsource_pie_getf_polar fundsource_pie_dacf_ndc fundsource_pie_getf_ndc) obslast order(fundsource_pie_dacf fundsource_pie_getf fundsource_pie_dacf_frac fundsource_pie_getf_frac fundsource_pie_dacf_polar fundsource_pie_getf_polar fundsource_pie_dacf_ndc fundsource_pie_getf_ndc) nomtitles b(3) se(3) nor2 se nostar nonotes nodepvars booktabs replace
