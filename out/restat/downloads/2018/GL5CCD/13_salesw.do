*Set up
clear all
set memory 5g

set more off

*N.B.: Unweighted localization file;

use "\\ead02\ead_uquam\Localization\NAICS6_panel\cdf_vst_rhs.dta", clear

cd "\\ead02\ead_uquam\Localization\restat_results"

*************************************************************************************VARIABLE CONSTRUCTION************************************************************************************************

*tset function;

destring naics, replace
destring oecd80, replace

xtset naics year, delta(1)

*ADDITIONAL VARIABLE GENERATION;

gen totalemp = salemp + prdwrk
gen rdshr=rd*1000/vsm
gen naics2=floor(naics/10000)
gen naics3=floor(naics/1000)

//incremental cdf

gen ln_cdf10_25=ln(cdf25-cdf10)
gen ln_cdf10_50=ln(cdf50-cdf10)
gen ln_cdf25_50=ln(cdf50-cdf25)
gen ln_cdf50_100=ln(cdf100-cdf50)
gen ln_cdf100_200=ln(cdf200-cdf100)
gen ln_cdf100_500=ln(cdf500-cdf100)
gen ln_cdf200_500=ln(cdf500-cdf200)
gen ln_cdf500_800=ln(cdf800-cdf500)
gen cdf500_800=cdf800-cdf500
gen ln_cdf10_200=ln(cdf200-cdf10)

gen cdf10_25=cdf25-cdf10
gen cdf25_50=cdf50-cdf25
gen cdf50_100=cdf100-cdf50
gen cdf100_200=cdf200-cdf100
gen cdf200_500=cdf500-cdf200

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
gen lnnprdprdi2 = lnnprdprdi*lnnprdprdi

generate lnman = ln(man)
generate lnbss = ln(bss)
generate lnnrs = ln(nrs)
generate lnutl = ln(utl)
generate lnherf = ln(herf)
generate lnherfent = ln(herfent)
generate lnemp = ln(salemp + prdwrk)
gen ln_empl = ln(salemp+prdwrk)
gen empl = salemp+prdwrk
gen lnemplshr=ln(salemp/(salemp+prdwrk))
gen lnplantsn=ln( plantsn)
generate lnavsq = lnav_klems*lnav_klems
generate lnmlwxlnifql2 = lnm_hw*lnifql2
generate lnifql4xlnifqk2= lnifql4* lnifqk2
generate lnifql4xlnifqk3= lnifql4* lnifqk3

generate lnhc = ln(ifqh4/ifqh)
generate lnhcxlnifqk2 = lnhc*lnifqk2
*generate lnifqh3shrxlnifqk2 = lnifqh3shr*ln(ifqk2)


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
gen lnifqh23shr2=lnifqh23shr*lnifqh23shr

*gen lnifqk2=ln(ifqk2)

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

gen lndistn2=ln(distn2)
gen lndistn3=ln(distn3)
gen lndistn5=ln(distn5)
gen lndistn7=ln(distn7)
gen lndistn10=ln(distn10)

//Input and output distance imputed

gen lnl_idist_n10i=ln(l_idist_n10i)
gen lnl_odist_n10i=ln(l_odist_n10i)
gen lnl_idist_n7i=ln(l_idist_n7i)
gen lnl_odist_n7i=ln(l_odist_n7i)
gen lnl_idist_n5i=ln(l_idist_n5i)
gen lnl_odist_n5i=ln(l_odist_n5i)
gen lnl_idist_n3i=ln(l_idist_n3i)
gen lnl_odist_n3i=ln(l_odist_n3i)

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

//Generate interaction terms with textile dummies

gen textile_av_klems=textile*lnav_klems 
gen textile_rdl=textile*lnrdl
gen textile_hc=textile*lnifqh3shr
gen textile_input_n3=textile*lnl_idist_n3
gen textile_output_n3=textile*lnl_odist_n3
gen textile_input_n5=textile*lnl_idist_n5
gen textile_output_n5=textile*lnl_odist_n5
gen textile_input_n7=textile*lnl_idist_n7
gen textile_output_n7=textile*lnl_odist_n7
gen textile_input_n10=textile*lnl_idist_n10
gen textile_output_n10=textile*lnl_odist_n10


//Generate interaction terms with OECD dummies

///Natural Resources: OECD_1

gen oecd_1_av_klems=oecd_1*lnav_klems 
gen oecd_1_rdl=oecd_1*lnrdl
gen oecd_1_hc=oecd_1*lnifqh3shr
gen oecd_1_input_n3=oecd_1*lnl_idist_n3
gen oecd_1_output_n3=oecd_1*lnl_odist_n3
gen oecd_1_input_n5=oecd_1*lnl_idist_n5
gen oecd_1_output_n5=oecd_1*lnl_odist_n5
gen oecd_1_input_n7=oecd_1*lnl_idist_n7
gen oecd_1_output_n7=oecd_1*lnl_odist_n7
gen oecd_1_input_n10=oecd_1*lnl_idist_n10
gen oecd_1_output_n10=oecd_1*lnl_odist_n10

///Labour Intensive: OECD_2

gen oecd_2_av_klems=oecd_2*lnav_klems 
gen oecd_2_rdl=oecd_2*lnrdl
gen oecd_2_hc=oecd_2*lnifqh3shr
gen oecd_2_input_n3=oecd_2*lnl_idist_n3
gen oecd_2_output_n3=oecd_2*lnl_odist_n3
gen oecd_2_input_n5=oecd_2*lnl_idist_n5
gen oecd_2_output_n5=oecd_2*lnl_odist_n5
gen oecd_2_input_n7=oecd_2*lnl_idist_n7
gen oecd_2_output_n7=oecd_2*lnl_odist_n7
gen oecd_2_input_n10=oecd_2*lnl_idist_n10
gen oecd_2_output_n10=oecd_2*lnl_odist_n10

///Scale-Based: OECD_3

gen oecd_3_av_klems=oecd_3*lnav_klems 
gen oecd_3_rdl=oecd_3*lnrdl
gen oecd_3_hc=oecd_3*lnifqh3shr
gen oecd_3_input_n3=oecd_3*lnl_idist_n3
gen oecd_3_output_n3=oecd_3*lnl_odist_n3
gen oecd_3_input_n5=oecd_3*lnl_idist_n5
gen oecd_3_output_n5=oecd_3*lnl_odist_n5
gen oecd_3_input_n7=oecd_3*lnl_idist_n7
gen oecd_3_output_n7=oecd_3*lnl_odist_n7
gen oecd_3_input_n10=oecd_3*lnl_idist_n10
gen oecd_3_output_n10=oecd_3*lnl_odist_n10

///Product-Different: OECD_4

gen oecd_4_av_klems=oecd_4*lnav_klems 
gen oecd_4_rdl=oecd_4*lnrdl
gen oecd_4_hc=oecd_4*lnifqh3shr
gen oecd_4_input_n3=oecd_4*lnl_idist_n3
gen oecd_4_output_n3=oecd_4*lnl_odist_n3
gen oecd_4_input_n5=oecd_4*lnl_idist_n5
gen oecd_4_output_n5=oecd_4*lnl_odist_n5
gen oecd_4_input_n7=oecd_4*lnl_idist_n7
gen oecd_4_output_n7=oecd_4*lnl_odist_n7
gen oecd_4_input_n10=oecd_4*lnl_idist_n10
gen oecd_4_output_n10=oecd_4*lnl_odist_n10

///Science-Based: OECD_5

gen oecd_5_av_klems=oecd_5*lnav_klems 
gen oecd_5_rdl=oecd_5*lnrdl
gen oecd_5_hc=oecd_5*lnifqh3shr
gen oecd_5_input_n3=oecd_5*lnl_idist_n3
gen oecd_5_output_n3=oecd_5*lnl_odist_n3
gen oecd_5_input_n5=oecd_5*lnl_idist_n5
gen oecd_5_output_n5=oecd_5*lnl_odist_n5
gen oecd_5_input_n7=oecd_5*lnl_idist_n7
gen oecd_5_output_n7=oecd_5*lnl_odist_n7
gen oecd_5_input_n10=oecd_5*lnl_idist_n10
gen oecd_5_output_n10=oecd_5*lnl_odist_n10

//Generate interaction terms of AV_klems with IO distances

gen av_klems_input_n3=lnav_klems*lnl_idist_n3
gen av_klems_output_n3=lnav_klems*lnl_odist_n3
gen av_klems_input_n5=lnav_klems*lnl_idist_n5
gen av_klems_output_n5=av_klems*lnl_odist_n5
gen av_klems_input_n7=lnav_klems*lnl_idist_n7
gen av_klems_output_n7=lnav_klems*lnl_odist_n7
gen av_klems_input_n10=lnav_klems*lnl_idist_n10
gen av_klems_output_n10=lnav_klems*lnl_odist_n10

*N.B.: The import and export shares enter the estimation UNTRANSFORMED;

//histogram av_klems, width(0.001) start(0) percent kdensity

*Spline to allow effect of transportation costs to vary (av_klems <0.005, 0.005 <= av_klems <= 0.15; av_klems > 0.15 and above;

mkspline lnav1 -5.298317367 lnav2 -1.897119985 lnav3 = lnav_klems

//Hausman test for model choice  

xi: xtreg ln_cdf10 lnav_klems m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnifql34 lnman lnbss i.year, fe 
estimates store fixe_model
xi: xtreg ln_cdf10 lnav_klems m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnifql34 lnman lnbss i.year, re 
hausman fixe_model

/////The pvalue is less than 0.05 and we choose the fixed effect model.


*The full model is run to set a consistent sample for the models with variable subsets

xi: xtreg  ln_cdf50 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems lnl_idist_n5 lnl_odist_n5  lnnprdprd lnnprdprd2 lnrdl i.year, fe cluster(naics)

keep if e(sample)

//generate the residual of transport variable to deal with endogeneity problem
xtreg lnav_klems lnmfpa i.year, fe  cluster(naics)
predict double xb
gen lnav_klems_resid=lnav_klems-xb

/*normality test for residuals  */
xi: xtreg  ln_cdf50 ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnav_klems_resid lnl_idist_n5 lnl_odist_n5 lndistn5 lnifqh3shr lnifqh3shr2 lnrdl i.year, fe cluster(naics)
predict double xb1
gen ln_cdf50_resid=ln_cdf50-xb1

sktest ln_cdf50_resid
su ln_cdf50_resid, detail

*end


//Table 13


*FE model by by distance: 10, 100, and 500 using the base model

*CDF at 10km 

xi: xtreg  ln_cdf10 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5  i.year, fe cluster(naics)
estimates store Model_4_CDF10km
outreg2 using CDFXXFEEMP, ctitle("CDF 10km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) replace

*CDF at 100km 
xi: xtreg  ln_cdf100 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5  i.year, fe cluster(naics)
estimates store Model_4_CDF100km
outreg2 using CDFXXFEEMP, ctitle("CDF 100km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append

*CDF at 500km
xi: xtreg  ln_cdf500 lnav_klems_resid ln_empl lnherfent lnm_emp nmulti1 nfown lnnrs lnpee lnifqh3shr lnrdl m_asiashr m_oecdshr m_naftashr x_asiashr x_oecdshr x_naftashr lnl_idist_n5 lnl_odist_n5 lndistn5  i.year, fe cluster(naics)
estimates store Model_4_CDF500km
outreg2 using CDFXXFEEMP, ctitle("CDF 500km")  sideway alpha (0.01,0.05,0.10) symbol(a,b,c) stats(coef aster se) noparen excel e(all) append



