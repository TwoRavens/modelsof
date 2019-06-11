use WorldCountries, clear
drop pop



foreach d in pwtWB13_gdpdata pwt7A pwt7B pwt8013_gdpdata pwtM13_gdpdata {
so iso year
merge iso year using `d'
ta _me
drop if _me==2
drop _me
}

so iso year
merge iso year using cons_stub71
ta _me
drop if _me==2
drop _me
gen rgdpch7Ac=rgdpch7A*kc

so iso year
merge iso year using wbkc
ta _me
drop if _me==2
drop _me
gen rgdpchWBc=rgdpchWB*wbkc
replace rgdpchWBc=rgdpchWB*kc if rgdpchWB!=. & kc!=. & wbkc==.
replace rgdpch7Ac=rgdpch7A*wbkc if rgdpch7A!=. & wbkc!=. & kc==.



cap drop lightindex
gen lightindex=0
forvalues i=0/63 {
replace lightindex=lightindex+`i'^(1)*cond(v`i'!=.,v`i',0)
}
gen rgdpchlight=lightindex/popWB
gen rgdpchlightdens=lightindex/area_light
gen rgdpchlightlit=1-(v0/area_light)


cap drop lightindex
gen lightindex=0
forvalues i=0/63 {
replace lightindex=lightindex+`i'*cond(v`i'!=.,v`i',0)
}
gen rgdpchlight1=lightindex/popWB
gen rgdpchlight1dens=lightindex/area_light

gen lrgdpchlight=ln(rgdpchlight)
gen lrgdpchlight1=ln(rgdpchlight1)
gen lrgdpchlightdens=ln(rgdpchlightdens)
*gen lrgdpchlight1dens=ln(rgdpchlight1dens)
gen lrgdpchlightlit=ln(rgdpchlightlit)

so sat year
merge sat year using calibration_world1
ta _me
drop _me
cap drop lightindex
forvalues i=0/63 {
replace v`i'=0 if v`i'==.
}
egen vsum=rowtotal(v0-v63)
forvalues i=0/63 {
replace v`i'=v`i'/vsum
}

gen lightindex=c0*v0+c1*v63^(3/2+z)
forvalues i=1/63 {
replace lightindex=lightindex+`i'^(3/2+z)*cond(v`i'!=.,v`i',0)
}
replace lightindex=c+ln(1+cb*lightindex)
gen rgdpchlightcal=(exp(lightindex)-1)*area_light/popWB*1e-9
gen lrgdpchlightcal=ln(rgdpchlightcal)



so isocode year
merge isocode year using fraclitstub
ta _me
drop if _me==2
drop _me
gen lrgdpchlightfrac=ln(fraclit)

drop rgdpchlight*
collapse lrgdpchlight*, by(cname isocode year rgdpch* region popWB)
/*
so iso year
by iso: ipolate lrgdpchlightfrac year, gen(lrgdpchlightfrac_new)
drop lrgdpchlightfrac
rename lrgdpchlightfrac_new lrgdpchlightfrac
*/

so iso year
merge iso year using povcal2_means_2010
ta _me
drop if _me==2
drop _me

foreach d in WB 7A 7B 80 M 7Ac WBc {
gen lrgdpch`d'=ln(rgdpch`d')
}
gen lrgdpchsurveys=ln(12*mean_ppp)
drop if iso==""
egen iso_n=group(iso)
so iso_n year
order cname iso_n year lrgdpch*



cap drop indinc
gen indinc=(incexp=="inc") if incexp!=""

gen base_sample=(lrgdpchlight!=. & lrgdpchWB!=. & lrgdpchsurveys!=.)
cap drop tag
duplicates tag iso_n year if base_sample==1, gen(tag)
*replace base_sample=0 if tag==1 & indinc==0
drop if tag==1 & indinc==0
drop tag

so isocode year
merge isocode year using wvs_small_new
drop if _me==2
drop _me
rename sat_hat sfact_hat
rename satisfaction sfaction

so isocode year
merge isocode year using covariates
ta _me
drop if _me==2
drop _me
foreach v of varlist S* {
cap gen l`v'=ln(`v')
}
replace lSoil=1 if Soil==0
drop lS0*

so isocode year
merge isocode year using gdpnrgstub
ta _me
drop if _me==2
drop _me
gen Sgdpnrg=gdpnrg
gen lSgdpnrg=ln(gdpnrg)

so isocode year
merge isocode year using djo_temp
ta _me
drop if _me==2
drop _me

gen Srichshare=d10
egen Spoorshare=rowtotal(d1-d5)
gen lSrichshare=ln(Srichshare)
gen lSpoorshare=ln(Spoorshare)
gen lSelectp=lSelect-lSpoptotal


foreach v of varlist S* lS* {
gen `v'2=`v'^2
}


by isocode, so: egen count=count(lrgdpchsurveys) if base_sample==1
gen weight1=1/count

preserve
use lis4, clear
gen rgdpchlis=rgdpchlislcu*(rgdpchWB/rgdpchlcu)
replace rgdpchlis=rgdpchlis/1e4 if cname=="Poland" & year==1992
replace rgdpchlis=rgdpchlis/13.76 if cname=="Austria" & year<2002
replace rgdpchlis=rgdpchlis/40.34 if cname=="Belgium" & year<2002
replace rgdpchlis=rgdpchlis/166.386 if cname=="Spain" & year<2002
replace rgdpchlis=rgdpchlis/5.95 if cname=="Finland" & year<2002
replace rgdpchlis=rgdpchlis/6.56 if cname=="France" & year<2002
replace rgdpchlis=rgdpchlis/1.956 if cname=="Germany" & year<2002
replace rgdpchlis=rgdpchlis/340.750 if cname=="Greece" & year<2002
replace rgdpchlis=rgdpchlis/0.787564 if cname=="Ireland" & year<2002
replace rgdpchlis=rgdpchlis/1936.27 if cname=="Italy" & year<2002
replace rgdpchlis=rgdpchlis/40.3399 if cname=="Luxembourg" & year<2002
replace rgdpchlis=rgdpchlis/2.20371 if cname=="Netherlands" & year<2002

replace rgdpchlis=rgdpchlis/15.6466 if cname=="Estonia"
replace rgdpchlis=rgdpchlis/30.126 if cname=="Slovak Republic" & year<=2007
replace rgdpchlis=rgdpchlis/239.64 if cname=="Slovenia" & year<2007
gen r=rgdpchlis/rgdpchWBc
replace rgdpchlis=. if year>=1992 & r>2
keep isocode year rgdpchlis
so iso year
save rgdpchlis_stub, replace
restore

so isocode year
merge isocode year using rgdpchlis_stub
ta _me
drop if _me==2
drop _me
gen lrgdpchlis=ln(rgdpchlis)


save NASM_base2, replace
