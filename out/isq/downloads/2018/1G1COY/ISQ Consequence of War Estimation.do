cd "C:\data"



********************************
*          Cambodia	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1979 || line  percapgdploss year if year>1979 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1979 1990(10)2000) yline(0, lcolor(black))  subtitle("Cambodia" ) saving(Cambodia, replace)





********************************
*          Rwanda    	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1993 || line  percapgdploss year if year>1993 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1994 2000(5)2005) yline(0, lcolor(black))  subtitle("Rwanda" ) saving(Rwanda, replace)





********************************
*          Mozambique	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"
twoway line  poploss year if year>1991 || line  percapgdploss year if year>1991 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1992 2000(5)2005) yline(0, lcolor(black))  subtitle("Mozambique" ) saving(Mozambique, replace)





********************************
*          USSR  	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1944 || line  percapgdploss year if year>1944 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("USSR" ) saving(USSR, replace)


					
																
********************************
*          Angola    	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1993 || line  percapgdploss year if year>1993 || ,scheme(economist) legend(off)   ylabel(-60(10)30, angle(horizontal)) xlabel(1994 2000(5)2005) yline(0, lcolor(black))  subtitle("Angola" ) saving(Angola, replace)



********************************
*          Liberia	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1996 || line  percapgdploss year if year>1996 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1996 2000(5)2005) yline(0, lcolor(black))  subtitle("Liberia" ) saving(Liberia, replace)



********************************
*          Germany	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<20
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<20
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<20
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1945 || line  percapgdploss year if year>1945 || ,scheme(economist) legend(off) ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("Germany" ) saving(Germany, replace)





********************************
*          Afghanistan	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1988 || line  percapgdploss year if year>1988 || ,scheme(economist) legend(off) ylabel(-35(5)17, angle(horizontal)) xlabel(1989 1995(5)2005) yline(0, lcolor(black))  subtitle("Afghanistan" ) saving(Afghanistan, replace)

                                                                
											
********************************
*          Vietnam             *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"
twoway line  poploss year if year>1974 || line  percapgdploss year if year>1974 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1975 1980(10)2000) yline(0, lcolor(black))  subtitle("Vietnam" ) saving(Vietnam, replace)




********************************
*          Hungary	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<20
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<20
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<20
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1944 || line  percapgdploss year if year>1944 || ,scheme(economist) legend(off)  ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("Hungary" ) saving(Hungary, replace)




********************************
*          Japan	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<15
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<15
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<15
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1944 || line  percapgdploss year if year>1944 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("Japan" ) saving(Japan, replace)




********************************
*          France	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<20
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<20
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<20
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1944 || line  percapgdploss year if year>1944 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("France" ) saving(France, replace)






********************************
*          UK    	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<20
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<20
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<20
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1944 || line  percapgdploss year if year>1944 || ,scheme(economist) legend(off) ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("UK" ) saving(UK, replace)





********************************
*          US    	       *
********************************

destring, ignore(,) replace

gen lngdp=ln(gdp)
gen lnpop=ln(pop)
gen lnpercapgdp=ln(percapgdp)

reg time pop if time>=0 & time<20
predict esttimepop
gen poploss=esttimepop-time


reg time lngdp if time>=0 & time<20
predict esttimegdp
gen gdploss=esttimegdp-time

reg time lnpercapgdp if time>=0 & time<20
predict esttimepercapgdp
gen percapgdploss=esttimepercapgdp-time

label variable year "Year"
label variable poploss "Population"
label variable gdploss "GDP"
label variable percapgdploss "GDP per capita"

twoway line  poploss year if year>1944 || line  percapgdploss year if year>1944 || ,scheme(economist) legend(off)   ylabel(-35(5)17, angle(horizontal)) xlabel(1945 1950(10)1970) yline(0, lcolor(black))  subtitle("US" ) saving(US, replace)





















       																                                                              																