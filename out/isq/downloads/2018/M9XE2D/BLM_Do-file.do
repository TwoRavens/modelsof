********************************************************************************
***************************** ISQ : Aid and Democratization ********************
********************************************************************************

set more off
use BML_ISQ_final.dta, replace /* Birchler-Limpach-Michaelowa data */
sort cid year

********************************************************************************
*** TABLE 2: OLS Regessions - Levels
********************************************************************************

// Two-way fixed effects
xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5  i.year if year>=1980, fe cl(cid)
outreg2 using main_table2rev.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE") replace seeout

// Two-way fixed effect with covariates
xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using main_table2rev.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE,& cov")   seeout

// Two-way fixed effect with covariates and lagged DV
xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using main_table2rev.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE,& cov & LDV") seeout

// Country fixed effect with covariates and lagged DV subsample 1: 1999-
xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg  if year>=1999, fe cl(cid)
outreg2 using main_table2rev.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Country FE,>=1999") seeout 
 
// Two-way fixed effect with covariates and lagged DV subsample 1: 1999-
xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg  i.year if year>=1999, fe cl(cid)
outreg2 using main_table2rev.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE,>=1999") seeout 

// Fixed effect with period dummies
xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg  i.period if year>=1980, fe cl(cid)
outreg2 using main_table2rev.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Country and,Period Dummies")  seeout 




*********************************************************************************
*** TABLE 3: Robustness checks
*********************************************************************************

// Regression 1: OLS excluding those observation with only PRS programs present
xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year , fe cl(cid)

list cid year prs if prs==1 & sap==0 & stb==0 & inv_cat==0 & e(sample)

preserve

drop if cid == 119 & year == 2007
drop if cid == 22 & year == 2005
drop if cid == 22 & year == 2006
drop if cid == 22 & year == 2007
drop if cid == 22 & year == 2008
drop if cid == 22 & year == 2009

xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year , fe cl(cid)
outreg2 using robustness_table3.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Only PRS,Excluded") replace

restore


/* Regression 2: Including combined lending */
capture gen overall_aid_gdp=(aid_inv_const_gdp + aid_sap_const_gdp + aid_prs_const_gdp + aid_stb_const_gdp)

xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.overall_aid_gdp L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year , fe cl(cid)
outreg2 using robustness_table3.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Including lending volume")

/* Regression 3: Including bilateral aid */
xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.bilataid_sharegdp L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year , fe cl(cid)
outreg2 using robustness_table3.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Including bilateral aid")



/* Regression 4: Inclusion of further strategic variables (basic equation from Table 2, regr3)*/
*first adjust USmilAid that is measured in const 2012 USD to const 2005 USD as this base year is also used for GDP
replace USmilAid=USmilAid*1.141448  /* the number corresponds to the USD deflator for 2012 */
label variable USmilAid "US Military Aid, 2005 USD millions, Obligations from USAID Greenbook"

xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg ///
L5.USmilAid L5.USA_UN L5.UNSC_rotate i.year if year>=1980, fe cl(cid) /*-> No change */
outreg2 using robustness_table3.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Inluding geopolitics")



/* Regression 5: Placebo tests: DV before program */
xi: xtreg L2.p_polity2_rec inv_cat_t1 stb_t1 sap_t1 prs_t1 L3.logincome L3.pwt_grgdpch L3.wdi_popurb L3.loginflat_pwt L3.logopenc_pwt L3.ucdp_levelall L3.p_polity2_reg L3.p_polity2_rec i.year, fe cl(cid)
outreg2 using robustness_table3.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Placebo,DV(t-1)")




// GMM: Blundel-Bond, robust

/*Regression 6*/ xtabond2 p_polity2_rec L5.p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.logincome L5.pwt_grgdpch ///
L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg _Iyear_1980-_Iyear_2011 if year>=1980, gmm(_Iyear_1980-_Iyear_2011 L5.p_polity2_rec ///
logincome pwt_grgdpch wdi_popurb loginflat_pwt logopenc_pwt ucdp_levelall p_polity2_reg, laglimits(7 9) collapse) twostep robust
/// Note: As the explanatory variables are all lagged by 5 years (5 years beeing the minimum time for these relatively sticky variables to show enough change), 
/// we considered that the additional lag to be used for the instruments might also ideally be at least 5 years. This reduces the number of available instruments,
/// but we have to constrain them even further as the Hansen test otherwise becomes meaningless. Hence we limit number of lags to two. While the default for laglimits is
/// (2 infinity), the above considerations let us choose (7 9) instead (7=default value of 2+5; 9=7+2 lags that we allow).
outreg2 using robustness_table3.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("GMM") 




********************************************************************************
*** ANNEX, TABLE A2.1: OLS Regessions - lag: t1-t5
********************************************************************************
// t-1
xi: xtreg p_polity2_rec inv_cat_t1 stb_t1 sap_t1 prs_t1 L1.p_polity2_rec L1.logincome L1.pwt_grgdpch L1.wdi_popurb L1.loginflat_pwt L1.logopenc_pwt L1.ucdp_levelall L1.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using time_tableA2_1.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE") replace
// t-2
xi: xtreg p_polity2_rec inv_cat_t2 stb_t2 sap_t2 prs_t2 L2.p_polity2_rec L2.logincome L2.pwt_grgdpch L2.wdi_popurb L2.loginflat_pwt L2.logopenc_pwt L2.ucdp_levelall L2.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using time_tableA2_1.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE")
// t-3
xi: xtreg p_polity2_rec inv_cat_t3 stb_t3 sap_t3 prs_t3 L3.p_polity2_rec L3.logincome L3.pwt_grgdpch L3.wdi_popurb L3.loginflat_pwt L3.logopenc_pwt L3.ucdp_levelall L3.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using time_tableA2_1.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE")
// t-4
xi: xtreg p_polity2_rec inv_cat_t4 stb_t4 sap_t4 prs_t4 L4.p_polity2_rec L4.logincome L4.pwt_grgdpch L4.wdi_popurb L4.loginflat_pwt L4.logopenc_pwt L4.ucdp_levelall L4.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using time_tableA2_1.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE")
// t-5
xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year if year>=1980, fe cl(cid)
outreg2 using time_tableA2_1.xls, nocons bdec(2) tdec(2) rdec(2) pdec(2) pvalue e(j) ctitle("Two-way FE") seeout





*********************************************************************
*** FIGURE 2: Case-wise deletion of countries
*********************************************************************

// Country outliers

global tflist ""
                forval i = 1/131 {
					tempfile tfcur
					xi: xtreg p_polity2_rec inv_cat_t5 stb_t5 sap_t5 prs_t5 L5.p_polity2_rec L5.logincome L5.pwt_grgdpch L5.wdi_popurb L5.loginflat_pwt L5.logopenc_pwt L5.ucdp_levelall L5.p_polity2_reg i.year if cid!=`i', fe cl(cid)
					parmest, label format(estimate min95 max95 %8.2f p %8.1e) idn(`i') saving(`"`tfcur'"',replace) flist(tflist)
				}
				
drop _all		
append using $tflist
sort idnum 

keep  idnum parm label  estimate p
encode parm, gen (variable)
label list variable
/*
          35 inv_cat_t5
          48 prs_t5
          49 sap_t5
          50 stb_t5
*/
keep if variable==35 | variable==48 | variable==49 | variable==50

sort idnum
drop parm label
reshape wide estimate p, i(idnum) j(variable)

rename estimate35 INV_coef
rename estimate48 PRS_coef
rename estimate49 SAP_coef
rename estimate50 STB_coef
rename p35 INV_p
rename p48 PRS_p
rename p49 SAP_p
rename p50 STB_p


twoway (scatter PRS_p PRS_coef), xtitle("PRS Coefficient") ytitle("PRS P-Value") ylabel(0.02(0.02)0.08, format(%9.2f))
twoway (scatter INV_p INV_coef), xtitle("INV Coefficient") ytitle("INV P-Value") ylabel(0.2(0.2)0.8, format(%9.2f))
twoway (scatter STB_p STB_coef), xtitle("STB Coefficient") ytitle("STB P-Value") ylabel(0.1(0.1)0.5, format(%9.2f))
twoway (scatter SAP_p SAP_coef), xtitle("SAP Coefficient") ytitle("SAP P-Value") ylabel(0.05(0.05)0.25, format(%9.2f))










