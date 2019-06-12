*Set up for the weighted (employment and sales) and 5 years average regression tables

clear all
set memory 5g

set more off

log using "\\ead02\ead_uquam\Localization\results\weighted_emp\cdf_wght1", replace 

///employment weighted
use "\\ead02\ead_uquam\Localization\NAICS6_panel\cdf_emp_rhs.dta", clear

cd "\\ead02\ead_uquam\Localization\results_july14\weighted_results"


*tset function;

destring naics, replace
destring oecd80, replace

xtset naics year, delta(1)

gen totalemp = salemp + prdwrk
gen rdshr=rd*1000/vsm

*variable preparation

generate ln_cdf10 = ln(cdf10)
generate ln_cdf25 = ln(cdf25)
generate ln_cdf50 = ln(cdf50)
generate ln_cdf100 = ln(cdf100)
generate ln_cdf200 = ln(cdf200)
generate ln_cdf500 = ln(cdf500)
generate ln_cdf800 = ln(cdf800)

generate ln_av = ln(av_klems)
generate ln_m_asianshr = ln(m_asiashr)
generate ln_ifql3 = ln(ifql3)
generate ln_ifql4 = ln(ifql4)

gen lnifql34=ln(ifql3+ifql4)

generate lnefown = ln(efown)
generate lnnfown = ln(nfown)
generate lnemulti = ln(emulti1)
generate lnnmulti = ln(nmulti1)
generate lnm_emp = ln(m_emp)
generate lnvsm = ln(vsm)
generate lnvam = ln(vam)
generate lnmat_sales = ln(mat_sales)
generate lnmat_va = ln(mat_va)
generate lnnprdprd = ln(nprdprd)
generate lnnprdprdi = ln(nprdprdi)
generate lnnprdprdis = ln(nprdprdis)

gen lnnprdprd2 = lnnprdprd*lnnprdprd
generate lnman = ln(man)
generate lnbss = ln(bss)
generate lnnrs = ln(nrs)
generate lnutl = ln(utl)
generate lnherf = ln(herf)
generate lnherfent = ln(herfent)
generate lnemp = ln(salemp + prdwrk)
gen ln_empl = ln(salemp+prdwrk)
gen empl = salemp+prdwrk

generate lnavsq = lnav_klems*lnav_klems
generate lnmlwxlnifql2 = lnm_hw*lnifql2
generate lnifql4xlnifqk2= lnifql4* lnifqk2
generate lnifql4xlnifqk3= lnifql4* lnifqk3

generate lnhc = ln(ifqh4/ifqh)
generate lnhcxlnifqk2 = lnhc*lnifqk2

//generate proxy for labor market pooling: 

gen test = ln(salemp/prdwrk)
gen test1 = ln(lnifqh4/(lnifqh2+lnifqh3+lnifqh4))
gen test2 = ln(lnifqh3/(lnifqh2+lnifqh3+lnifqh4))

*hours worked

gen ifqh2shr=ifqh2/ifqh
gen ifqh3shr=ifqh3/ifqh
gen ifqh4shr=ifqh4/ifqh
gen ifqh34shr=(ifqh3+ifqh4)/ifqh
gen ifqh23shr=(ifqh2+ifqh3)/ifqh

gen lnifqh2shr=ln(ifqh2shr)
gen lnifqh3shr=ln(ifqh3shr)
gen lnifqh4shr=ln(ifqh4shr)
gen lnifqh23shr=ln(ifqh23shr)
gen lnifqh34shr=ln((ifqh3+ifqh4)/ifqh)

gen lnifqh2shr2=lnifqh2shr*lnifqh2shr
gen lnifqh3shr2=lnifqh3shr*lnifqh3shr
gen lnifqh4shr2=lnifqh4shr*lnifqh4shr



//Another proxy for inputs sharing:Export intensity
gen lnexpint=ln(export_tot/vsm)

//adding entry and exit variables
gen lnent6 = ln(ent6)
gen lnext6 = ln(ext6)
gen lnent4 = ln(ent4)
gen lnext4 = ln(ext4)

//proxying R&D intensity: R&D expenditure / total output
gen lnrd=ln(rd/vsm)
gen lnrd1=ln(rd)
gen lnrds=ln(rds/vsm)

gen rdlshr=rdl/vsml
gen lnrdl=ln(rdl/vsml)
gen lnrdls=ln(rdls/vsml)

//generate proxy for natural advantage
gen lnpee =ln(pee/pvv)
*gen lnpee =ln(pee_gn)/ln(pvv_gn)
gen peeshr=pee/pvv

//Input and output distance

gen lnl_idist_n10=ln(l_idist_n10)
gen lnl_odist_n10=ln(l_odist_n10)
gen lnl_idist_n7=ln(l_idist_n7)
gen lnl_odist_n7=ln(l_odist_n7)
gen lnl_idist_n5=ln(l_idist_n5)
gen lnl_odist_n5=ln(l_odist_n5)
gen lnl_idist_n3=ln(l_idist_n3)
gen lnl_odist_n3=ln(l_odist_n3)

//Input and output distance imputed

gen lnl_idist_n10i=ln(l_idist_n10i)
gen lnl_odist_n10i=ln(l_odist_n10i)
gen lnl_idist_n7i=ln(l_idist_n7i)
gen lnl_odist_n7i=ln(l_odist_n7i)
gen lnl_idist_n5i=ln(l_idist_n5i)
gen lnl_odist_n5i=ln(l_odist_n5i)
gen lnl_idist_n3i=ln(l_idist_n3i)
gen lnl_odist_n3i=ln(l_odist_n3i)

gen lndistn2=ln(distn2)
gen lndistn3=ln(distn3)
gen lndistn5=ln(distn5)
gen lndistn7=ln(distn7)
gen lndistn10=ln(distn10)

gen lndistn2i=ln(distn2i)
gen lndistn3i=ln(distn3i)
gen lndistn5i=ln(distn5i)
gen lndistn7i=ln(distn7i)
gen lndistn10i=ln(distn10i)

**gen textiles dumies
gen textile=0
replace textile=1 if naics==313110 | naics==313110 | naics==313210 | naics== 313220 | naics==313230 | naics==313240 | naics==313310 | naics==313320 | naics==314110 | naics==314120 | naics==314910 | naics==314990 | naics==315110 | naics==315190 | naics==315210 | naics==315221 | naics==315222 | naics==315226 | naics==315227 | naics==315229 | naics==315231 | naics==315232 | naics==315233 | naics==315234 | naics==315239 | naics==315291 | naics==315292 | naics==315299 | naics==315990

**gen high tech dummies

//generate hightech dummies variable
gen level1=0
replace level1=1 if naics==325410 | naics==334110 | naics==334511 | naics==334512 | naics==336410 | naics==334210 | naics==334220 | naics==334290 | naics==334410 
gen level2=0
replace level2=1 if naics==333310 | naics==334610 | naics==325110 | naics==333210 | naics==333220 | naics==333291 | naics==333299 | naics==334310 | naics==325210 | naics==325220
gen level3=0
replace level3=1 if naics==335311 | naics==335312 | naics==335315 | naics==325910 | naics==325920 | naics==325991 | naics==325999 | naics==333910 | naics==333920 | naics==333990 | naics==333611 | naics==333619 | naics==325510 | naics==325520 | naics==324110 | naics==324121 | naics==324122 | naics==324190 | naics==325313 | naics==325314 | naics==325320 | naics==336990
gen level4=0
replace level4=1 if naics==332910 | naics==332991 | naics==332999 | naics==332991 | naics==335910 | naics==335920 | naics==335930 | naics==335990 | naics==336110 | naics==336120 | naics==333511 | naics==333519 | naics==332410 | naics==332420 | naics==332431 | naics==332439 | naics==336211 | naics==336212 | naics==336215
gen high_comp=level1+level2 +level3+level4
gen hightech=0
replace hightech=1 if high_comp>0
drop high_comp

//generate OECD dummies variable
gen oecd_1=0
replace oecd_1=1 if oecd80==1 
gen oecd_2=0
replace oecd_2=1 if oecd80==2
gen oecd_3=0
replace oecd_3=1 if oecd80==3
gen oecd_4=0
replace oecd_4=1 if oecd80==4
gen oecd_5=0
replace oecd_5=1 if oecd80==5   


//generate the residual of transport variable
xtreg lnav_klems lnmfpa i.year, fe  cluster(naics)
predict double xb
gen lnav_klems_resid=lnav_klems-xb


///Table 12 of the paper: Employment weighted CDF

////Fixed effect employment weighted Model


////Fixed effect Model
*Standard model at 10km + trade + transports cost + inputs distance + labor + rdl at 10km

xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4e_CDF10km
outreg2 using CDF10FE, ctitle("FE4: CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*Standard model at 100km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4e_CDF100km
outreg2 using CDF100FE, ctitle("FE4: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append


*Standard model at 500km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4e_CDF500km
outreg2 using CDF500FE, ctitle("FE4: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4e_CDF10km Model_4e_CDF100km Model_4e_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)


////Fixed effect employment weighted Model:  Residual


////Fixed effect Model
*Standard model at 10km + trade + transports cost + inputs distance + labor + rdl at 10km

xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4er_CDF10km
outreg2 using CDF10FE, ctitle("FE4: CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*Standard model at 100km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4er_CDF100km
outreg2 using CDF100FE, ctitle("FE4: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append


*Standard model at 500km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4er_CDF500km
outreg2 using CDF500FE, ctitle("FE4: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4er_CDF10km Model_4er_CDF100km Model_4er_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)

///Sales weighetd CDF

use "\\ead02\ead_uquam\Localization\NAICS6_panel\cdf_vst_rhs.dta", clear


*tset function;

destring naics, replace
destring oecd80, replace

xtset naics year, delta(1)

gen totalemp = salemp + prdwrk
gen rdshr=rd*1000/vsm

*variable preparation

generate ln_cdf10 = ln(cdf10)
generate ln_cdf25 = ln(cdf25)
generate ln_cdf50 = ln(cdf50)
generate ln_cdf100 = ln(cdf100)
generate ln_cdf200 = ln(cdf200)
generate ln_cdf500 = ln(cdf500)
generate ln_cdf800 = ln(cdf800)

generate ln_av = ln(av_klems)
generate ln_m_asianshr = ln(m_asiashr)
generate ln_ifql3 = ln(ifql3)
generate ln_ifql4 = ln(ifql4)

gen lnifql34=ln(ifql3+ifql4)

generate lnefown = ln(efown)
generate lnnfown = ln(nfown)
generate lnemulti = ln(emulti1)
generate lnnmulti = ln(nmulti1)
generate lnm_emp = ln(m_emp)
generate lnvsm = ln(vsm)
generate lnvam = ln(vam)
generate lnmat_sales = ln(mat_sales)
generate lnmat_va = ln(mat_va)
generate lnnprdprd = ln(nprdprd)
generate lnnprdprdi = ln(nprdprdi)
generate lnnprdprdis = ln(nprdprdis)

gen lnnprdprd2 = lnnprdprd*lnnprdprd
generate lnman = ln(man)
generate lnbss = ln(bss)
generate lnnrs = ln(nrs)
generate lnutl = ln(utl)
generate lnherf = ln(herf)
generate lnherfent = ln(herfent)
generate lnemp = ln(salemp + prdwrk)
gen ln_empl = ln(salemp+prdwrk)
gen empl = salemp+prdwrk

generate lnavsq = lnav_klems*lnav_klems
generate lnmlwxlnifql2 = lnm_hw*lnifql2
generate lnifql4xlnifqk2= lnifql4* lnifqk2
generate lnifql4xlnifqk3= lnifql4* lnifqk3

generate lnhc = ln(ifqh4/ifqh)
generate lnhcxlnifqk2 = lnhc*lnifqk2

//generate proxy for labor market pooling: 

gen test = ln(salemp/prdwrk)
gen test1 = ln(lnifqh4/(lnifqh2+lnifqh3+lnifqh4))
gen test2 = ln(lnifqh3/(lnifqh2+lnifqh3+lnifqh4))

*hours worked

gen ifqh2shr=ifqh2/ifqh
gen ifqh3shr=ifqh3/ifqh
gen ifqh4shr=ifqh4/ifqh
gen ifqh34shr=(ifqh3+ifqh4)/ifqh
gen ifqh23shr=(ifqh2+ifqh3)/ifqh

gen lnifqh2shr=ln(ifqh2shr)
gen lnifqh3shr=ln(ifqh3shr)
gen lnifqh4shr=ln(ifqh4shr)
gen lnifqh23shr=ln(ifqh23shr)
gen lnifqh34shr=ln((ifqh3+ifqh4)/ifqh)

gen lnifqh2shr2=lnifqh2shr*lnifqh2shr
gen lnifqh3shr2=lnifqh3shr*lnifqh3shr
gen lnifqh4shr2=lnifqh4shr*lnifqh4shr

//Another proxy for inputs sharing:Export intensity
gen lnexpint=ln(export_tot/vsm)

//adding entry and exit variables
gen lnent6 = ln(ent6)
gen lnext6 = ln(ext6)
gen lnent4 = ln(ent4)
gen lnext4 = ln(ext4)

//proxying R&D intensity: R&D expenditure / total output
gen lnrd=ln(rd/vsm)
gen lnrd1=ln(rd)
gen lnrds=ln(rds/vsm)

gen rdlshr=rdl/vsml
gen lnrdl=ln(rdl/vsml)
gen lnrdls=ln(rdls/vsml)

//generate proxy for natural advantage
gen lnpee =ln(pee/pvv)
*gen lnpee =ln(pee_gn)/ln(pvv_gn)
gen peeshr=pee/pvv

//Input and output distance

gen lnl_idist_n10=ln(l_idist_n10)
gen lnl_odist_n10=ln(l_odist_n10)
gen lnl_idist_n7=ln(l_idist_n7)
gen lnl_odist_n7=ln(l_odist_n7)
gen lnl_idist_n5=ln(l_idist_n5)
gen lnl_odist_n5=ln(l_odist_n5)
gen lnl_idist_n3=ln(l_idist_n3)
gen lnl_odist_n3=ln(l_odist_n3)

//Input and output distance imputed

gen lnl_idist_n10i=ln(l_idist_n10i)
gen lnl_odist_n10i=ln(l_odist_n10i)
gen lnl_idist_n7i=ln(l_idist_n7i)
gen lnl_odist_n7i=ln(l_odist_n7i)
gen lnl_idist_n5i=ln(l_idist_n5i)
gen lnl_odist_n5i=ln(l_odist_n5i)
gen lnl_idist_n3i=ln(l_idist_n3i)
gen lnl_odist_n3i=ln(l_odist_n3i)

gen lndistn2=ln(distn2)
gen lndistn3=ln(distn3)
gen lndistn5=ln(distn5)
gen lndistn7=ln(distn7)
gen lndistn10=ln(distn10)

gen lndistn2i=ln(distn2i)
gen lndistn3i=ln(distn3i)
gen lndistn5i=ln(distn5i)
gen lndistn7i=ln(distn7i)
gen lndistn10i=ln(distn10i)

**gen textiles dumies
gen textile=0
replace textile=1 if naics==313110 | naics==313110 | naics==313210 | naics== 313220 | naics==313230 | naics==313240 | naics==313310 | naics==313320 | naics==314110 | naics==314120 | naics==314910 | naics==314990 | naics==315110 | naics==315190 | naics==315210 | naics==315221 | naics==315222 | naics==315226 | naics==315227 | naics==315229 | naics==315231 | naics==315232 | naics==315233 | naics==315234 | naics==315239 | naics==315291 | naics==315292 | naics==315299 | naics==315990

**gen high tech dummies

//generate hightech dummies variable
gen level1=0
replace level1=1 if naics==325410 | naics==334110 | naics==334511 | naics==334512 | naics==336410 | naics==334210 | naics==334220 | naics==334290 | naics==334410 
gen level2=0
replace level2=1 if naics==333310 | naics==334610 | naics==325110 | naics==333210 | naics==333220 | naics==333291 | naics==333299 | naics==334310 | naics==325210 | naics==325220
gen level3=0
replace level3=1 if naics==335311 | naics==335312 | naics==335315 | naics==325910 | naics==325920 | naics==325991 | naics==325999 | naics==333910 | naics==333920 | naics==333990 | naics==333611 | naics==333619 | naics==325510 | naics==325520 | naics==324110 | naics==324121 | naics==324122 | naics==324190 | naics==325313 | naics==325314 | naics==325320 | naics==336990
gen level4=0
replace level4=1 if naics==332910 | naics==332991 | naics==332999 | naics==332991 | naics==335910 | naics==335920 | naics==335930 | naics==335990 | naics==336110 | naics==336120 | naics==333511 | naics==333519 | naics==332410 | naics==332420 | naics==332431 | naics==332439 | naics==336211 | naics==336212 | naics==336215
gen high_comp=level1+level2 +level3+level4
gen hightech=0
replace hightech=1 if high_comp>0
drop high_comp

//generate OECD dummies variable
gen oecd_1=0
replace oecd_1=1 if oecd80==1 
gen oecd_2=0
replace oecd_2=1 if oecd80==2
gen oecd_3=0
replace oecd_3=1 if oecd80==3
gen oecd_4=0
replace oecd_4=1 if oecd80==4
gen oecd_5=0
replace oecd_5=1 if oecd80==5   


//generate the residual of transport variable
xtreg lnav_klems lnmfpa i.year, fe  cluster(naics)
predict double xb
gen lnav_klems_resid=lnav_klems-xb


/// Sales weighted CDF

////Fixed effect employment weighted Model


////Fixed effect Model
*Standard model at 10km + trade + transports cost + inputs distance + labor + rdl at 10km

xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4s_CDF10km
outreg2 using CDF10FEs, ctitle("FE4: CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*Standard model at 100km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4s_CDF100km
outreg2 using CDF100FEs, ctitle("FE4: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append


*Standard model at 500km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4s_CDF500km
outreg2 using CDF500FEs, ctitle("FE4: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4s_CDF10km Model_4s_CDF100km Model_4s_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)


////Fixed effect sales weighted Model:  Residual


////Fixed effect Model
*Standard model at 10km + trade + transports cost + inputs distance + labor + rdl at 10km

xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4sr_CDF10km
outreg2 using CDF10FEs, ctitle("FE4: CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*Standard model at 100km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4sr_CDF100km
outreg2 using CDF100FEs, ctitle("FE4: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append


*Standard model at 500km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4sr_CDF500km
outreg2 using CDF500FEs, ctitle("FE4: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4sr_CDF10km Model_4sr_CDF100km Model_4sr_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)



///5 years averages

use "\\ead02\ead_uquam\Localization\NAICS6_panel\cdf_rhs_5yrs_avg", clear


*tset function;

xtset naics year, delta(1)

gen totalemp = salemp + prdwrk
gen rdshr=rd*1000/vsm
gen naics2=floor(naics/10000)
gen naics3=floor(naics/1000)

//incremental cdf

gen ln_cdf10_25=ln(cdf25-cdf10)
gen ln_cdf25_50=ln(cdf50-cdf25)
gen ln_cdf50_100=ln(cdf100-cdf50)
gen ln_cdf100_200=ln(cdf200-cdf100)
gen ln_cdf200_500=ln(cdf500-cdf200)
gen ln_cdf500_800=ln(cdf800-cdf500)
gen cdf500_800=cdf800-cdf500
gen ln_cdf10_200=ln(cdf200-cdf10)

gen cdf10_25=cdf25-cdf10
gen cdf25_50=cdf50-cdf25
gen cdf50_100=cdf100-cdf50
gen cdf100_200=cdf200-cdf100
gen cdf200_500=cdf500-cdf200


*variable preparation;

generate ln_cdf10 = ln(cdf10)
generate ln_cdf50 = ln(cdf50)
generate ln_cdf100 = ln(cdf100)
generate ln_cdf200 = ln(cdf200)
generate ln_cdf500 = ln(cdf500)
generate ln_cdf800 = ln(cdf800)

generate lnmfpa = ln(mfpa)

generate lnav_klems = ln(av_klems)
generate ln_m_asianshr = ln(m_asiashr)
generate ln_ifql3 = ln(ifql3)
generate ln_ifql4 = ln(ifql4)

gen lnifql34=ln(ifql3+ifql4)

generate lnefown = ln(efown)
generate lnnfown = ln(nfown)
generate lnemulti = ln(emulti1)
generate lnnmulti = ln(nmulti1)
generate lnm_emp = ln(m_emp)
generate lnvsm = ln(vsm)
generate lnvam = ln(vam)
generate lnmat_sales = ln(mat_sales)
generate lnmat_va = ln(mat_va)
generate lnnprdprd = ln(nprdprd)
gen lnnprdprd2 = lnnprdprd*lnnprdprd
generate lnman = ln(man)
generate lnbss = ln(bss)
generate lnnrs = ln(nrs)
generate lnutl = ln(utl)
generate lnherf = ln(herf)
generate lnherfent = ln(herfent)
generate lnemp = ln(salemp + prdwrk)
gen ln_empl = ln(salemp+prdwrk)
gen empl = salemp+prdwrk

generate lnavsq = lnav_klems*lnav_klems
generate lnmlwxlnifql2 = ln(m_hw*ifql2)
generate lnifql4xlnifqk2= ln(ifql4*ifqk2)
generate lnifql4xlnifqk3= ln(ifql4*ifqk3)

generate lnhc = ln(ifqh4/ifqh)
generate lnhc1 = ln(ifqh3/ifqh)

generate lnhcxlnifqk2 = lnhc*ln(ifqk2)

//generate proxy for labor market pooling: 

gen test = ln(salemp/prdwrk)
gen test1 = ln(ifqh4/(ifqh2+ifqh3+ifqh4))
gen test2 = ln(ifqh3/(ifqh2+ifqh3+ifqh4))

*hours worked

gen ifqh2shr=ifqh2/ifqh
gen ifqh3shr=ifqh3/ifqh
gen ifqh4shr=ifqh4/ifqh
gen ifqh34shr=(ifqh3+ifqh4)/ifqh
gen ifqh23shr=(ifqh2+ifqh3)/ifqh

gen lnifqh2shr=ln(ifqh2shr)
gen lnifqh3shr=ln(ifqh3shr)
gen lnifqh4shr=ln(ifqh4shr)
gen lnifqh23shr=ln(ifqh23shr)
gen lnifqh34shr=ln((ifqh3+ifqh4)/ifqh)

gen lnifqh2shr2=lnifqh2shr*lnifqh2shr
gen lnifqh3shr2=lnifqh3shr*lnifqh3shr
gen lnifqh4shr2=lnifqh4shr*lnifqh4shr
generate lnifqh2shrxlnifqk2 = lnifqh2shr*ln(ifqk2)


//Another proxy for inputs sharing:Export intensity
gen lnexpint=ln(export_tot/vsm)

//adding entry and exit variables
gen lnent6 = ln(ent6)
gen lnext6 = ln(ext6)
gen lnent4 = ln(ent4)
gen lnext4 = ln(ext4)

//proxying R&D intensity: R&D expenditure / total output
gen lnrd=ln(rd/vsm)
gen lnrd1=ln(rd)
gen lnrds=ln(rds/vsm)

gen rdlshr=rdl/vsml
gen lnrdl=ln(rdl/vsml)
gen lnrdls=ln(rdls/vsml)

//generate proxy for natural advantage
gen lnpee =ln(pee/pvv)
*gen lnpee =ln(pee_gn)/ln(pvv_gn)
gen peeshr=pee/pvv

//Input and output distance

gen lnl_idist_n10=ln(l_idist_n10)
gen lnl_odist_n10=ln(l_odist_n10)
gen lnl_idist_n7=ln(l_idist_n7)
gen lnl_odist_n7=ln(l_odist_n7)
gen lnl_idist_n5=ln(l_idist_n5)
gen lnl_odist_n5=ln(l_odist_n5)
gen lnl_idist_n3=ln(l_idist_n3)
gen lnl_odist_n3=ln(l_odist_n3)

//Input and output distance imputed

gen lnl_idist_n10i=ln(l_idist_n10i)
gen lnl_odist_n10i=ln(l_odist_n10i)
gen lnl_idist_n7i=ln(l_idist_n7i)
gen lnl_odist_n7i=ln(l_odist_n7i)
gen lnl_idist_n5i=ln(l_idist_n5i)
gen lnl_odist_n5i=ln(l_odist_n5i)
gen lnl_idist_n3i=ln(l_idist_n3i)
gen lnl_odist_n3i=ln(l_odist_n3i)

gen lndistn2=ln(distn2)
gen lndistn3=ln(distn3)
gen lndistn5=ln(distn5)
gen lndistn7=ln(distn7)
gen lndistn10=ln(distn10)

gen lndistn2i=ln(distn2i)
gen lndistn3i=ln(distn3i)
gen lndistn5i=ln(distn5i)
gen lndistn7i=ln(distn7i)
gen lndistn10i=ln(distn10i)

**gen textiles dumies
gen textile=0
replace textile=1 if naics==313110 | naics==313110 | naics==313210 | naics== 313220 | naics==313230 | naics==313240 | naics==313310 | naics==313320 | naics==314110 | naics==314120 | naics==314910 | naics==314990 | naics==315110 | naics==315190 | naics==315210 | naics==315221 | naics==315222 | naics==315226 | naics==315227 | naics==315229 | naics==315231 | naics==315232 | naics==315233 | naics==315234 | naics==315239 | naics==315291 | naics==315292 | naics==315299 | naics==315990

**gen high tech dummies

//generate hightech dummies variable
gen level1=0
replace level1=1 if naics==325410 | naics==334110 | naics==334511 | naics==334512 | naics==336410 | naics==334210 | naics==334220 | naics==334290 | naics==334410 
gen level2=0
replace level2=1 if naics==333310 | naics==334610 | naics==325110 | naics==333210 | naics==333220 | naics==333291 | naics==333299 | naics==334310 | naics==325210 | naics==325220
gen level3=0
replace level3=1 if naics==335311 | naics==335312 | naics==335315 | naics==325910 | naics==325920 | naics==325991 | naics==325999 | naics==333910 | naics==333920 | naics==333990 | naics==333611 | naics==333619 | naics==325510 | naics==325520 | naics==324110 | naics==324121 | naics==324122 | naics==324190 | naics==325313 | naics==325314 | naics==325320 | naics==336990
gen level4=0
replace level4=1 if naics==332910 | naics==332991 | naics==332999 | naics==332991 | naics==335910 | naics==335920 | naics==335930 | naics==335990 | naics==336110 | naics==336120 | naics==333511 | naics==333519 | naics==332410 | naics==332420 | naics==332431 | naics==332439 | naics==336211 | naics==336212 | naics==336215
gen high_comp=level1+level2 +level3+level4
gen hightech=0
replace hightech=1 if high_comp>0
drop high_comp

//generate OECD dummies variable
gen oecd_1=0
replace oecd_1=1 if oecd80==1 
gen oecd_2=0
replace oecd_2=1 if oecd80==2
gen oecd_3=0
replace oecd_3=1 if oecd80==3
gen oecd_4=0
replace oecd_4=1 if oecd80==4
gen oecd_5=0
replace oecd_5=1 if oecd80==5   


*N.B.: The import and export shares enter the estimation UNTRANSFORMED;

//generate the residual of transport variable
xtreg lnav_klems lnmfpa i.year, fe  cluster(naics)
predict double xb
gen lnav_klems_resid=lnav_klems-xb


////Fixed effect 5 years average Model:  Residual


////Fixed effect Model
*Standard model at 10km + trade + transports cost + inputs distance + labor + rdl at 10km

xi: xtreg  ln_cdf10 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4ar_CDF10km
outreg2 using CDF10FEav, ctitle("FE4: CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*Standard model at 100km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf100 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4ar_CDF100km
outreg2 using CDF100FEav, ctitle("FE4: CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append


*Standard model at 500km + trade + transports cost + inputs distance + labor +rd
xi: xtreg  ln_cdf500 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 i.year, fe cluster(naics)
estimates store Model_4ar_CDF500km
outreg2 using CDF500FEav, ctitle("FE4: CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

estimates table Model_4ar_CDF10km Model_4ar_CDF100km Model_4ar_CDF500km, b(%7.3f) star (.10 .05 .01) stat(N r2_a)
                                                                                 					    //																									

log close


