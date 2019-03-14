****************************************************************************************
* Replication Code: Appendix Figure 7, Figure 8,  Table 4, and Table 5
* This code created: 6/13/18
****************************************************************************************

*
* Load analysis file 
*

use "replicationdata.dta", clear

*
* Generate variables for pooled issue-long analysis
*

expand 5, gen(dupes)
bys responseid: gen dataset = _n
sort dataset responseid

gen abs_mismatch_pooled = abs_aca_mismatch if _n<=101
replace abs_mismatch_pooled = abs_minwage_mismatch if _n>101 & _n<=202
replace abs_mismatch_pooled = abs_co2_mismatch if _n>202 & _n<=303
replace abs_mismatch_pooled = abs_infra_mismatch if _n>303 & _n<=404
replace abs_mismatch_pooled = abs_gun_mismatch if _n>404 & _n<=505

gen mass_groups = mass_minwage_stdz if _n<=101
replace mass_groups = mass_minwage_stdz if _n>101 & _n<=202
replace mass_groups = mass_co2_stdz if _n>202 & _n<=303
replace mass_groups = mass_minwage_stdz if _n>303 & _n<=404
replace mass_groups = mass_gun_stdz if _n>404 & _n<=505

gen corp_groups = corp_minwage_stdz if _n<=101
replace corp_groups = corp_minwage_stdz if _n>101 & _n<=202
replace corp_groups = corp_co2_stdz if _n>202 & _n<=303
replace corp_groups = corp_infra_stdz if _n>303 & _n<=404
replace corp_groups = corp_gun_stdz if _n>404 & _n<=505

gen issue = "ACA Repeal" if _n<=101
replace issue = "Minimum Wage" if _n>101 & _n<=202
replace issue = "CO2 Limits" if _n>202 & _n<=303
replace issue = "Infrastructure Spending" if _n>303 & _n<=404
replace issue = "Gun Sales Check" if _n>404 & _n<=505

encode issue, gen(issuenum)

gen mismatch_pooled = aca_mismatch if _n<=101
replace mismatch_pooled = minwage_mismatch if _n>101 & _n<=202
replace mismatch_pooled = co2_mismatch if _n>202 & _n<=303
replace mismatch_pooled = infra_mismatch if _n>303 & _n<=404
replace mismatch_pooled = gun_mismatch if _n>404 & _n<=505

gen contribs_pooled = healthinsshare_stdz if _n<=101
replace contribs_pooled = allbizshare_stdz  if _n>101 & _n<=202
replace contribs_pooled = extractivelastshare_stdz if _n>202 & _n<=303
replace contribs_pooled = constructshare_stdz if _n>303 & _n<=404
replace contribs_pooled = gunslastshare_stdz if _n>404 & _n<=505

gen pref_pooled = personal_repealaca if _n<=101
replace pref_pooled = personal_minwage12 if _n>101 & _n<=202
replace pref_pooled = personal_co2 if _n>202 & _n<=303
replace pref_pooled = personal_infra if _n>303 & _n<=404
replace pref_pooled = personal_gunreg if _n>404 & _n<=505

gen netmasscorp = mass_group - corp_group

gen laborminusbizcontribs = laborshare-allbizshare
gen extractiveminusenvironcontrib = extractivelastshare-sierrashare-lcvshare
gen environminusextractivecontribs = (sierrashare+lcvshare) - extractivelastshare

gen issuenumnoaca = issuenum if issuenum!=1
label var issuenumnoaca issuenum

* Plot Figure 15

#delimit ;
twoway (scatter abs_co2_mismatch environminusextractivecontribs, mcolor(gray)) 
(lfit abs_co2_mismatch environminusextractivecontribs, lcolor(blue)) 
if issue=="CO2 Limits", scheme(s1mono)
ylabel(,grid)
xlabel(,grid)
xtitle("Mass - Corporate Group Contributions")
ytitle("Absolute Staffer-Consitutent Mismatch (CO2 Limits)")
aspectratio(1)
legend(off)
;

#delimit cr

graph export "appendix_figure15.pdf"

* Table 5 regressions

reg abs_mismatch_pooled netmass marginreelect_r yearsinoff if issuenum==1, cluster(office)
estimates store tab5m1
reg abs_mismatch_pooled netmass marginreelect_r yearsinoff if issuenum==2, cluster(office)
estimates store tab5m2
reg abs_mismatch_pooled netmass marginreelect_r yearsinoff if issuenum==3, cluster(office)
estimates store tab5m3
reg abs_mismatch_pooled netmass marginreelect_r yearsinoff if issuenum==4, cluster(office)
estimates store tab5m4
reg abs_mismatch_pooled netmass marginreelect_r yearsinoff if issuenum==5, cluster(office)
estimates store tab5m5

estout tab5m1 tab5m2 tab5m3 tab5m4 tab5m5 using appendix_table5.csv, cells(b(star fmt(2)) se(par fmt(2))) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

* Table 4 regressions

collapse (mean) abs_mismatch_pooled contribs_pooled netmasscorp genvoteshare yearsinoff marginreelect_r dwnom1 democrat lm_uniondens laborminusbizcontribs, by(responseid office)

reg abs_mismatch_pooled netmass marginreelect_r yearsinoff, cluster(office)
estimates store tab4m1
reg abs_mismatch_pooled contribs_pooled marginreelect_r yearsinoff, cluster(office)
estimates store tab4m2
reg abs_mismatch_pooled lm_uniondens marginreelect_r yearsinoff, cluster(office)
estimates store tab4m3

estout tab4m1 tab4m2 tab4m3  using appendix_table4.csv, cells(b(star fmt(2)) se(par fmt(2))) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

*
* Plot Figure 14
* 

#delimit ;
twoway (scatter abs_mismatch_pooled laborminusbizcontribs, mcolor(gray)) 
(lfit abs_mismatch_pooled laborminusbizcontribs, lcolor(blue)), 
scheme(s1mono)
ylabel(,grid)
xlabel(,grid)
xtitle("Labor - Corporate Group Contributions")
ytitle("Absolute Staffer-Consitutent Mismatch")
aspectratio(1)
legend(off)
;

#delimit cr

graph export "appendix_figure14.pdf"


