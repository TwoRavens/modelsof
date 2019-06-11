/* Tables for FUI */

/* set filepaths */
global input <filepath>
global output <filepath>

/******************************************/
/* 1.)          Basic AKM Decomp          */
/******************************************/

/* import bt-/wi-moments by firm size group */
insheet using ${input}/BTWI_Decomp_byFSize.txt, comma clear
/* drop firms with less than 20 employees */
drop if fsize_g==1
/* keep only necessary variables */
keep interval-m_e m_y_y-m_e_e m_y_pe-m_y_e m_pe_fe-m_pe_e m_fe_xb-m_fe_e m_xb_r-m_xb_e m_r_m-m_r_e m_m_e
/* collpase across firm size groups to aggregate level */
collapse (rawsum) n_wrkyear (mean) m_* [aw=n_wrkyear], by(interval)
/* compute second moments */
foreach i in y pe fe xb r {
gen var_`i'=m_`i'_`i'-m_`i'^2 
}
gen cov_pe_fe=2*(m_pe_fe-m_pe*m_fe)
gen cov_pe_xb=2*(m_pe_xb-m_pe*m_xb)
gen cov_fe_xb=2*(m_fe_xb-m_fe*m_xb)
keep interval n_wrkyear var* cov*
/* reshape to dimensions of table */
rename n_wrkyear int_0
rename var_y int_1
rename var_pe int_2
rename var_fe int_3
rename var_xb int_4
rename var_r int_5
rename cov_pe_fe int_6
rename cov_pe_xb int_7
rename cov_fe_xb int_8
/* reshape long */
reshape long int_, i(interval) j(stat)
recode stat (0=999)
/* shape wide */
reshape wide int_, i(stat) j(interval)
/* format */
label define statv 1 "var_y" 2 "var_pe" 3 "var_fe" 4 "var_xb" 5 "var_r" ///
			6 "2cov_pe_fe" 7 "2cov_pe_xb" 8 "2cov_fe_xb" 999 "N", replace
label values stat statv
forvalues i=1/5 {
format int_`i' %12.7g
}
/* export */
outsheet using ${input}/table5.txt, comma replace

/********************************************/
/* 2.)          BT-/WI-Firm AKM Decomp      */
/********************************************/

/* import bt-/wi-moments by firm size group */
insheet using ${input}/BTWI_Decomp_byFSize.txt, comma clear
/* drop firms with less than 20 employees */
drop if fsize_g==1
/* keep only necessary variables */
keep interval fsize_g n_wrkyear m_y m_y_y m_fmy m_fmy_fmy ///
		m_fmpe m_fmpe_fmpe m_fmfe m_fmfe_fmfe ///
		m_fmxb m_fmxb_fmxb m_fmpe_fmfe m_fmpe_fmxb m_fmfe_fmxb ///
		m_dfy m_dfy_dfy m_dfpe m_dfpe_dfpe m_dffe m_dffe_dffe ///
		m_dfxb m_dfxb_dfxb m_dfr m_dfr_dfr ///
		m_dfpe_dfxb m_dfpe_dfr m_dfxb_dfr ///
		m_pe m_pe_pe
/* collpase across firm size groups to aggregate level */
collapse (rawsum) n_wrkyear (mean) m_* [aw=n_wrkyear], by(interval)
/* compute second moments */
foreach i in y pe fmy fmpe fmfe fmxb dfy dfpe dfxb dfr {
gen var_`i'=m_`i'_`i'-m_`i'^2 
}
gen cov_fmpe_fmfe=2*(m_fmpe_fmfe-m_fmpe*m_fmfe)
gen cov_fmpe_fmxb=2*(m_fmpe_fmxb-m_fmpe*m_fmxb)
gen cov_fmfe_fmxb=2*(m_fmfe_fmxb-m_fmfe*m_fmxb)
gen cov_dfpe_dfxb=2*(m_dfpe_dfxb-m_dfpe*m_dfxb)
gen cov_dfpe_dfr=2*(m_dfpe_dfr-m_dfpe*m_dfr)
gen cov_dfxb_dfr=2*(m_dfxb_dfr-m_dfxb*m_dfr)
gen seg_index=var_fmpe/var_pe
keep interval n_wrkyear var* cov* seg_index
/* reshape to dimensions of table */
rename n_wrkyear int_0
rename var_y int_1
rename var_fmy int_2
rename var_fmpe int_3
rename var_fmfe int_4
rename var_fmxb int_5
rename cov_fmpe_fmfe int_6
rename cov_fmpe_fmxb int_7
rename cov_fmfe_fmxb int_8
rename var_dfy int_9
rename var_dfpe int_10
rename var_dfxb int_11
rename var_dfr int_12
rename cov_dfpe_dfxb int_13
rename cov_dfpe_dfr int_14
rename cov_dfxb_dfr int_15
rename seg_index int_16
drop var_pe
/* reshape long */
reshape long int_, i(interval) j(stat)
recode stat (0=999)
/* shape wide */
reshape wide int_, i(stat) j(interval)
/* format */
label define statv 1 "var_y" 2 "var_fmy" 3 "var_fmpe" 4 "var_fmfe" ///
	5 "var_fmxb" 6 "cov_fmpe_fmfe" 7 "cov_fmpe_fmxb" 8 "cov_fmfe_fmxb" ///
	9 "var_dfy" 10 "var_dfpe" 11 "var_dfxb" 12 "var_dfr" 13 "cov_dfpe_dfxb" ///
	14 "cov_dfpe_dfr" 15 "cov_dfxb_dfr" 16 "seg_index" 999 "N", replace
label values stat statv
forvalues i=1/5 {
format int_`i' %12.7g
}
/* export */
outsheet using ${input}/table6.txt, comma replace

/******************************************/
/* 3.)           Joint FE dist            */
/******************************************/
/* import bt-/wi-moments by firm size group */
insheet using ${input}/JointFEDist.txt, comma clear
/* create variable for proprtion of total obs */
bysort interval: egen tot_n=total(n_wkryears)
gen share=n_wkryears/tot_n
/* format */
label define fev 1 "FFE Dec 1" 2 "FFE Dec 2" 3 "FFE Dec 3" 4 "FFE Dec 4" 5 "FFE Dec 5" ///
			 6 "FFE Dec 6" 7 "FFE Dec 7" 8 "FFE Dec 8" 9 "FFE Dec 9" 10 "FFE Dec 10", replace
label values fe_dec fev
/* joint dist figure by interval */
cap program drop joint_fig
program define joint_fig
local i `1'
preserve  
keep if interval==`i'
twoway ///
	(bar share pe_dec if pe_dec==1, color("103 0 31") lw(none)) ///
	(bar share pe_dec if pe_dec==2, color("178 24 43") lw(none)) ///
	(bar share pe_dec if pe_dec==3, color("214 96 77") lw(none)) ///
	(bar share pe_dec if pe_dec==4, color("244 165 130") lw(none)) ///
	(bar share pe_dec if pe_dec==5, color("253 219 199") lw(none)) ///
	(bar share pe_dec if pe_dec==6, color("209 229 240") lw(none)) ///
	(bar share pe_dec if pe_dec==7, color("146 197 222") lw(none)) ///
	(bar share pe_dec if pe_dec==8, color("67 147 195") lw(none)) ///
	(bar share pe_dec if pe_dec==9, color("33 102 172") lw(none)) ///
	(bar share pe_dec if pe_dec==10, color("5 48 97") lw(none)) ///
	,by(fe_dec, ix  scale(.75) rows(1) im(zero)   ///
			title("Joint Worker and Firm Fixed Effect Distribution: Interval `i'", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Share of Total Observations", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Worker Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(0(.005).025,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/Fig7_JointFE_`i'.pdf, replace
restore
end
forvalues j=1/5 {
joint_fig `j'
}
/* change in joint distribution from int 1 to 5 figure */
egen panelvar=group(pe_dec fe_dec)
tsset panelvar interval
gen d_share=share-l4.share
twoway ///
	(bar d_share pe_dec if pe_dec==1, color("103 0 31") lw(none)) ///
	(bar d_share pe_dec if pe_dec==2, color("178 24 43") lw(none)) ///
	(bar d_share pe_dec if pe_dec==3, color("214 96 77") lw(none)) ///
	(bar d_share pe_dec if pe_dec==4, color("244 165 130") lw(none)) ///
	(bar d_share pe_dec if pe_dec==5, color("253 219 199") lw(none)) ///
	(bar d_share pe_dec if pe_dec==6, color("209 229 240") lw(none)) ///
	(bar d_share pe_dec if pe_dec==7, color("146 197 222") lw(none)) ///
	(bar d_share pe_dec if pe_dec==8, color("67 147 195") lw(none)) ///
	(bar d_share pe_dec if pe_dec==9, color("33 102 172") lw(none)) ///
	(bar d_share pe_dec if pe_dec==10, color("5 48 97") lw(none)) ///
	,by(fe_dec, ix  scale(.75) rows(1) im(zero)   ///
			title("Joint Worker and Firm Fixed Effect Distribution: Change from Int 1 to 5", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Change in Share of Total Observations", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Worker Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(#8,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5)  
graph set window fontface "Calibri"
graph export ${output}/Fig7_JointFE_Changes.pdf, replace


/***********************************************************/
/* 4.)          BT-/WI-Firm AKM Decomp by firm size group  */
/***********************************************************/
set more off
/* import bt-/wi-moments by firm size group */
insheet using ${input}/BTWI_Decomp_byFSize.txt, comma clear
forvalues j=1/2 {
preserve
if `j'==1 {
keep if inlist(fsize_g, 2,3,4)
}
if `j'==2 {
keep if inlist(fsize_g, 2,3)
}
/* keep only necessary variables */
keep interval fsize_g n_wrkyear m_y m_y_y m_fmy m_fmy_fmy ///
		m_fmpe m_fmpe_fmpe m_fmfe m_fmfe_fmfe ///
		m_fmxb m_fmxb_fmxb m_fmpe_fmfe m_fmpe_fmxb m_fmfe_fmxb ///
		m_dfy m_dfy_dfy m_dfpe m_dfpe_dfpe m_dffe m_dffe_dffe ///
		m_dfxb m_dfxb_dfxb m_dfr m_dfr_dfr ///
		m_dfpe_dfxb m_dfpe_dfr m_dfxb_dfr ///
		m_pe m_pe_pe
/* collpase across firm size groups to aggregate level */
collapse (rawsum) n_wrkyear (mean) m_* [aw=n_wrkyear], by(interval)
/* compute second moments */
foreach i in y pe fmy fmpe fmfe fmxb dfy dfpe dfxb dfr {
gen var_`i'=m_`i'_`i'-m_`i'^2 
}
gen cov_fmpe_fmfe=2*(m_fmpe_fmfe-m_fmpe*m_fmfe)
gen cov_fmpe_fmxb=2*(m_fmpe_fmxb-m_fmpe*m_fmxb)
gen cov_fmfe_fmxb=2*(m_fmfe_fmxb-m_fmfe*m_fmxb)
gen cov_dfpe_dfxb=2*(m_dfpe_dfxb-m_dfpe*m_dfxb)
gen cov_dfpe_dfr=2*(m_dfpe_dfr-m_dfpe*m_dfr)
gen cov_dfxb_dfr=2*(m_dfxb_dfr-m_dfxb*m_dfr)
gen seg_index=var_fmpe/var_pe
keep interval n_wrkyear var* cov* seg_index
/* reshape to dimensions of table */
rename n_wrkyear int_0
rename var_y int_1
rename var_fmy int_2
rename var_fmpe int_3
rename var_fmfe int_4
rename var_fmxb int_5
rename cov_fmpe_fmfe int_6
rename cov_fmpe_fmxb int_7
rename cov_fmfe_fmxb int_8
rename var_dfy int_9
rename var_dfpe int_10
rename var_dfxb int_11
rename var_dfr int_12
rename cov_dfpe_dfxb int_13
rename cov_dfpe_dfr int_14
rename cov_dfxb_dfr int_15
rename seg_index int_16
drop var_pe
/* reshape long */
reshape long int_, i(interval) j(stat)
recode stat (0=999)
/* shape wide */
reshape wide int_, i(stat) j(interval)
/* format */
label define statv 1 "var_y" 2 "var_fmy" 3 "var_fmpe" 4 "var_fmfe" ///
	5 "var_fmxb" 6 "cov_fmpe_fmfe" 7 "cov_fmpe_fmxb" 8 "cov_fmfe_fmxb" ///
	9 "var_dfy" 10 "var_dfpe" 11 "var_dfxb" 12 "var_dfr" 13 "cov_dfpe_dfxb" ///
	14 "cov_dfpe_dfr" 15 "cov_dfxb_dfr" 16 "seg_index" 999 "N", replace
label values stat statv
gen fs_rest=`j'
tempfile temp`j'
save "`temp`j''"
restore
}
clear
forvalues j=1/2 {
append using "`temp`j''"
}
/* format */
sort fs_rest stat
label define fs_restv 1 "Exclude FS>10,000" 2 "Exclude FS>1,000", replace
label values fs_rest fs_restv 
forvalues i=1/5 {
format int_`i' %12.7g
}
/* export */
outsheet using ${input}/table7.txt, comma replace


/********************************************/
/* 5.)           Corr(WFE,FFE) by Industry  */
/********************************************/

/* import bt-/wi-moments by firm size group */
insheet using ${input}/BTWI_Decomp_byInd.txt, comma clear
/* keep only necessary variables */
keep interval ind n_wrkyear m_pe m_pe_pe m_fe m_fe_fe m_pe_fe
/* aggregate education and public administration */
gen i=(inlist(ind,10,11))
foreach k in m_pe m_pe_pe m_fe m_fe_fe m_pe_fe {
gen x=n_wrkyear*`k'
bysort interval i: egen y=total(x)
bysort interval i: egen z=total(n_wrkyear)
gen xx=y/z
replace `k'=xx if i==1
drop x y z xx 
}
drop if inlist(ind,11)
drop i
/* aggregate agriculture, mining, and construction */
gen i=(inlist(ind,1,2,3))
foreach k in m_pe m_pe_pe m_fe m_fe_fe m_pe_fe {
gen x=n_wrkyear*`k'
bysort interval i: egen y=total(x)
bysort interval i: egen z=total(n_wrkyear)
gen xx=y/z
replace `k'=xx if i==1
drop x y z xx 
}
drop if inlist(ind,2,3)
drop i
/* aggregate wholesale and retail */
gen i=(inlist(ind,6,7))
foreach k in m_pe m_pe_pe m_fe m_fe_fe m_pe_fe {
gen x=n_wrkyear*`k'
bysort interval i: egen y=total(x)
bysort interval i: egen z=total(n_wrkyear)
gen xx=y/z
replace `k'=xx if i==1
drop x y z xx 
}
drop if inlist(ind,7)
drop i
/* create correlation of WFE and WFE */
gen var_pe=m_pe_pe-m_pe*m_pe
gen var_fe=m_fe_fe-m_fe*m_fe
gen cov_pe_fe=m_pe_fe-m_pe*m_fe
gen corr_pe_fe=cov_pe_fe/((var_pe*var_fe)^(1/2))
/* labels */
label define intv 1 "'80-'86" 2 "'87-'93" 3 "'94-'00" 4 "'01-'07" 5 "'07-'13", replace
label values interval intv
label define indv 1 "Ag, Mining, Cnstr" 4 "Manufacturing" 5 "Trans + Util" ///
			6 "Wholesale + Retail" 8 "FIRE" 9 "Services" 10 "Educ + Pub Adm" ///
			-9 "Unidentified", replace
label values ind indv
/* plot change overtime */
twoway ///
	(connected corr_pe_fe interval if ind==1, m(circle) color("166 206 227")) ///
	(connected corr_pe_fe interval if ind==4, m(diamond) color("178 223 138") msize(*.75)) ///
	(connected corr_pe_fe interval if ind==5, m(triangle) color("251 154 153")) ///
	(connected corr_pe_fe interval if ind==6, m(square) color("253 191 111") msize(*.8)) ///
	(connected corr_pe_fe interval if ind==8, m(circle) mlcolor("31 120 180") lcolor("31 120 180") mfcolor("255 255 255")) ///
	(connected corr_pe_fe interval if ind==9, m(diamond) mlcolor("51 160 44") lcolor("51 160 44") mfcolor("255 255 255") msize(*.75)) ///
	(connected corr_pe_fe interval if ind==-9, m(triangle) mlcolor("227 26 28") lcolor("227 26 28") mfcolor("255 255 255")) ///
	(connected corr_pe_fe interval if ind==10, m(square) mlcolor("255 127 0") lcolor("255 127 0") mfcolor("255 255 255") msize(*.8)) ///
	,title("Within-Industry Corr(EFE,WFE) over Time", size(medium) color(black) margin(0 0 5 2.5)) ///
	legend(order(1 "Ag, Mining, Cnstr" 2 "Manufacturing" 3 "Trans + Util" ///
			4 "Wholesale + Retail" 5 "FIRE" 6 "Services" 7 "Unidentified" ///
			8 "Educ + Pub Adm") cols(1) pos(3) symx(*.5) region(lc("255 255 255")) size(small)) ///
	ytitle("Correlation Coefficient", margin(0 5 0 0))  ///
	xtitle("", margin(0 0 0 2)) ///
	xlabel(1(1)5, nogrid val) ///
	ylabel(#6,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f)) ///
	ymtick(##2, grid glc("0 0 0") glw(vthin) glp(dot)) ///
	plotregion(fcolor("255 255 255")) graphregion(fcolor("255 255 255")) ysize(4) xsize(6.47) 
graph set window fontface "Calibri"
graph export ${output}/Fig8_Corr_EFE_WFE_byInd.pdf, replace


/********************************************/
/* 6.)          AKM Stats by Industry       */
/********************************************/

/* import bt-/wi-moments by firm size group */
insheet using ${input}/BTWI_Decomp_byInd.txt, comma clear
/* keep only necessary variables */
keep interval ind n_wrkyear m_pe m_pe_pe m_fe m_fe_fe m_pe_fe
/* create correlation of WFE and WFE */
gen var_pe=m_pe_pe-m_pe*m_pe
gen var_fe=m_fe_fe-m_fe*m_fe
gen cov_pe_fe=m_pe_fe-m_pe*m_fe
gen corr_pe_fe=cov_pe_fe/((var_pe*var_fe)^(1/2))
keep interval ind n_wrkyear var* corr*
/* rehape wide */
reshape wide n_wrkyear var_pe var_fe corr_pe_fe, i(ind) j(interval)
/* format */
label define indv 1 "Agriculture, Forestry, Fishing" 2 "Mining" 3 "Construction" ///
		4 "Manufacturing" 5 "Transportation, Public Utilities" 6 "Wholesale Trade" ///
		7 "Retail Trade" 8 "Finance, Insurance, Real Estate" 9 "Services" 10 "Education" ///
		11 "Public Administration" -9 "Unidentfied", replace
label values ind indv
forvalues i=1/5 {
format n_wrkyear`i' %12.0f
}
/* export */
outsheet using ${input}/table8.txt, comma replace


/**********************************************/
/* 7.)            Residuals by Joint FE Dist  */
/**********************************************/

/* import bt-/wi-moments by firm size group */
insheet using ${input}/JointFEDist.txt, comma clear
/* format */
label define fev 1 "FFE Dec 1" 2 "FFE Dec 2" 3 "FFE Dec 3" 4 "FFE Dec 4" 5 "FFE Dec 5" ///
			 6 "FFE Dec 6" 7 "FFE Dec 7" 8 "FFE Dec 8" 9 "FFE Dec 9" 10 "FFE Dec 10", replace
label values fe_dec fev
/* joint dist figure by interval */
cap program drop joint_fig
program define joint_fig
local i `1'
preserve  
keep if interval==`i'
twoway ///
	(bar m_r pe_dec if pe_dec==1, color("103 0 31") lw(none)) ///
	(bar m_r pe_dec if pe_dec==2, color("178 24 43") lw(none)) ///
	(bar m_r pe_dec if pe_dec==3, color("214 96 77") lw(none)) ///
	(bar m_r pe_dec if pe_dec==4, color("244 165 130") lw(none)) ///
	(bar m_r pe_dec if pe_dec==5, color("253 219 199") lw(none)) ///
	(bar m_r pe_dec if pe_dec==6, color("209 229 240") lw(none)) ///
	(bar m_r pe_dec if pe_dec==7, color("146 197 222") lw(none)) ///
	(bar m_r pe_dec if pe_dec==8, color("67 147 195") lw(none)) ///
	(bar m_r pe_dec if pe_dec==9, color("33 102 172") lw(none)) ///
	(bar m_r pe_dec if pe_dec==10, color("5 48 97") lw(none)) ///
	,by(fe_dec, ix  scale(.75) rows(1) im(zero)   ///
			title("Mean AKM Residuals by WFE and FFE Distribution: Interval `i'", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Mean Residual", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Worker Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(-0.02(.02).04,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.2f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/FigA9_Residuals_JointFE_`i'.pdf, replace
restore
end
forvalues j=1/5 {
joint_fig `j'
}
/* change in joint distribution from int 1 to 5 figure */
egen panelvar=group(pe_dec fe_dec)
tsset panelvar interval
gen d_m_r=m_r-l4.m_r
twoway ///
	(bar d_m_r pe_dec if pe_dec==1, color("103 0 31") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==2, color("178 24 43") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==3, color("214 96 77") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==4, color("244 165 130") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==5, color("253 219 199") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==6, color("209 229 240") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==7, color("146 197 222") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==8, color("67 147 195") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==9, color("33 102 172") lw(none)) ///
	(bar d_m_r pe_dec if pe_dec==10, color("5 48 97") lw(none)) ///
	,by(fe_dec, ix  scale(.75) rows(1) im(zero)   ///
			title("Mean AKM Residuals by WFE and FFE Distribution: Change from Int 1 to 5", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Change in Mean Residual", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Worker Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(#8,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/FigA9_Residuals_JointFE_Changes.pdf, replace


**********************************************/
/* 8.)             Firm size & FFE dist      */
/*********************************************/

/* import FFE-FSize distribution counts */
insheet using ${input}/FFE_FSize_Dist.txt, comma clear
/* create variable for proprtion of total obs */
bysort interval: egen tot_n=total(n_wkryears)
gen share=n_wkryears/tot_n
/* format */
label define fsize_gv 1 "FS: 1-20" 2 "FS: 20-100" 3 "FS: 100-1,000" 4 "FS: 1,000-10,000" 5 "FS: 10,000+" , replace
label values fsize_g fsize_gv
/* joint dist figure by interval */
cap program drop joint_fig
program define joint_fig
local i `1'
preserve  
keep if interval==`i'
twoway ///
	(bar share fe_dec if fe_dec==1, color("103 0 31") lw(none)) ///
	(bar share fe_dec if fe_dec==2, color("178 24 43") lw(none)) ///
	(bar share fe_dec if fe_dec==3, color("214 96 77") lw(none)) ///
	(bar share fe_dec if fe_dec==4, color("244 165 130") lw(none)) ///
	(bar share fe_dec if fe_dec==5, color("253 219 199") lw(none)) ///
	(bar share fe_dec if fe_dec==6, color("209 229 240") lw(none)) ///
	(bar share fe_dec if fe_dec==7, color("146 197 222") lw(none)) ///
	(bar share fe_dec if fe_dec==8, color("67 147 195") lw(none)) ///
	(bar share fe_dec if fe_dec==9, color("33 102 172") lw(none)) ///
	(bar share fe_dec if fe_dec==10, color("5 48 97") lw(none)) ///
	,by(fsize_g, ix  scale(.75) rows(1) im(zero)   ///
			title("Joint Firm Fixed Effect and Firm Size Distribution: Interval `i'", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Share of Total Observations", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Firm Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(0(.01).07,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/FigA10_FFE_FSize_`i'.pdf, replace
restore
end
forvalues j=1/5 {
joint_fig `j'
}
/* change in joint distribution from int 1 to 5 figure */
egen panelvar=group(fe_dec fsize_g)
tsset panelvar interval
gen d_share=share-l4.share
twoway ///
	(bar d_share fe_dec if fe_dec==1, color("103 0 31") lw(none)) ///
	(bar d_share fe_dec if fe_dec==2, color("178 24 43") lw(none)) ///
	(bar d_share fe_dec if fe_dec==3, color("214 96 77") lw(none)) ///
	(bar d_share fe_dec if fe_dec==4, color("244 165 130") lw(none)) ///
	(bar d_share fe_dec if fe_dec==5, color("253 219 199") lw(none)) ///
	(bar d_share fe_dec if fe_dec==6, color("209 229 240") lw(none)) ///
	(bar d_share fe_dec if fe_dec==7, color("146 197 222") lw(none)) ///
	(bar d_share fe_dec if fe_dec==8, color("67 147 195") lw(none)) ///
	(bar d_share fe_dec if fe_dec==9, color("33 102 172") lw(none)) ///
	(bar d_share fe_dec if fe_dec==10, color("5 48 97") lw(none)) ///
	,by(fsize_g, ix  scale(.75) rows(1) im(zero)   ///
			title("Joint Firm Fixed Effect and Firm Size Distribution: Change from Int 1 to 5", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Change in Share of Total Observations", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Firm Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(#8,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/FigA10_FFE_FSize_Changes.pdf, replace

**********************************************/
/* 9.)             Firm size & WFE dist      */
/*********************************************/

/* import FFE-FSize distribution counts */
insheet using ${input}/WFE_FSize_Dist.txt, comma clear
/* create variable for proprtion of total obs */
bysort interval: egen tot_n=total(n_wkryears)
gen share=n_wkryears/tot_n
/* format */
label define fsize_gv 1 "FS: 1-20" 2 "FS: 20-100" 3 "FS: 100-1,000" 4 "FS: 1,000-10,000" 5 "FS: 10,000+" , replace
label values fsize_g fsize_gv
/* joint dist figure by interval */
cap program drop joint_fig
program define joint_fig
local i `1'
preserve  
keep if interval==`i'
twoway ///
	(bar share pe_dec if pe_dec==1, color("103 0 31") lw(none)) ///
	(bar share pe_dec if pe_dec==2, color("178 24 43") lw(none)) ///
	(bar share pe_dec if pe_dec==3, color("214 96 77") lw(none)) ///
	(bar share pe_dec if pe_dec==4, color("244 165 130") lw(none)) ///
	(bar share pe_dec if pe_dec==5, color("253 219 199") lw(none)) ///
	(bar share pe_dec if pe_dec==6, color("209 229 240") lw(none)) ///
	(bar share pe_dec if pe_dec==7, color("146 197 222") lw(none)) ///
	(bar share pe_dec if pe_dec==8, color("67 147 195") lw(none)) ///
	(bar share pe_dec if pe_dec==9, color("33 102 172") lw(none)) ///
	(bar share pe_dec if pe_dec==10, color("5 48 97") lw(none)) ///
	,by(fsize_g, ix  scale(.75) rows(1) im(zero)   ///
			title("Joint Worker Fixed Effect and Firm Size Distribution: Interval `i'", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Share of Total Observations", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Worker Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(0(.005).035,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/FigA11_WFE_FSize_`i'.pdf, replace
restore
end
forvalues j=1/5 {
joint_fig `j'
}
/* change in joint distribution from int 1 to 5 figure */
egen panelvar=group(pe_dec fsize_g)
tsset panelvar interval
gen d_share=share-l4.share
twoway ///
	(bar d_share pe_dec if pe_dec==1, color("103 0 31") lw(none)) ///
	(bar d_share pe_dec if pe_dec==2, color("178 24 43") lw(none)) ///
	(bar d_share pe_dec if pe_dec==3, color("214 96 77") lw(none)) ///
	(bar d_share pe_dec if pe_dec==4, color("244 165 130") lw(none)) ///
	(bar d_share pe_dec if pe_dec==5, color("253 219 199") lw(none)) ///
	(bar d_share pe_dec if pe_dec==6, color("209 229 240") lw(none)) ///
	(bar d_share pe_dec if pe_dec==7, color("146 197 222") lw(none)) ///
	(bar d_share pe_dec if pe_dec==8, color("67 147 195") lw(none)) ///
	(bar d_share pe_dec if pe_dec==9, color("33 102 172") lw(none)) ///
	(bar d_share pe_dec if pe_dec==10, color("5 48 97") lw(none)) ///
	,by(fsize_g, ix  scale(.75) rows(1) im(zero)   ///
			title("Joint Worker Fixed Effect and Firm Size Distribution: Change from Int 1 to 5", size(medium) color(black) margin(0 0 5 2.5)) ///
			plotregion(color("255 255 255")) graphregion(color("255 255 255")) ///
			note("") legend(off)) ///
	ytitle("Change in Share of Total Observations", margin(0 5 0 0) size(vlarge))  ///
	xtitle("Worker Fixed Effect Decile", margin(0 0 0 2) size(vlarge)) ///
	xlabel(2(2)10, nogrid labsize(vlarge)) ///
	xtick(1(1)10, nogrid) ///
	ylabel(#8,angle(0) gmin gmax grid glc("0 0 0") glw(vthin) glp(dot) format(%9.3f) labsize(vlarge)) ///
	ymtick(##2, grid  glc("0 0 0") glw(vthin) glp(dot)) ///
	subtitle(,fc(white) lc(black) m(small) alignment(middle) size(huge)) ///
	plotregion(color("255 255 255"))  ysize(4) xsize(7.5) 
graph set window fontface "Calibri"
graph export ${output}/FigA11_WFE_FSize_Changes.pdf, replace
