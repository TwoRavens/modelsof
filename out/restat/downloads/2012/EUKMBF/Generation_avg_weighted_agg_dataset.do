/*Delete variables that are not needed for the aggregate analysis*/
drop hp6cgdpt hp6cgdpc hp6unemto hp6unemco hp6serato hp6seraco hp100cgdpt hp100cgdpc hp100unemto hp100unemco hp100serato hp100seraco serate unempl cgdp cgdpt1 cgdpg1 lcgdp lcgdp1 lcgdpg unempl unempl1 unemplg1 lunempl lunempl1 lunemplg serate serate1 serateg1 lserate lserate1 lserateg


/*Multiply detrended variables with country weights*/
sort year
by year: gen gdpdevw6 =  weight_old*hp6cdpp
by year: gen unempdw6 =  weight_old*hp6unemcop
by year: gen serdevdw6 =  weight_old*hp6seratop
by year: gen gdpdevw100=  weight_old*hp100cdpp
by year: gen unempdw100 =  weight_old*hp100unemcop
by year: gen serdevdw100 =  weight_old*hp100seracop
by year: gen d1cgdpgwa =   d1cgdpg*weight_old
by year: gen d1unemplgwa =   d1unemplg*weight_old
by year: gen d1serategwa =  d1serateg*weight_old

/*Sum the weighted country obs by year*/
by year: egen gdpdev6 = total( gdpdevw6)
by year: egen gdpdev100 = total( gdpdevw100)
by year: egen unempd6 = total( unempdw6)
by year: egen unempd100 = total( unempdw100)
by year: egen servdevw6 = total( serdevdw6)
by year: egen servdevw100 = total( serdevdw100)
by year: egen  d1cgdpga = total( d1cgdpgwa)
by year: egen  d1unemplga = total( d1unemplgwa)
by year: egen  d1seratega = total( d1serategwa)


/*Drop observations for all but one country to get the averaged values of all countries per year*/
drop if id>1
/*Drop variables that are not needed anymore and missing observations*/
drop  id country OECDold weight_old hp6cdpp hp6unemcop hp6seratop hp100cdpp hp100unemcop hp100seracop gdpdevw6 unempdw6 serdevdw6 gdpdevw100 unempdw100 serdevdw100 d1cgdpg d1unemplg d1serateg d1cgdpgwa d1unemplgwa d1serategwa cgdpg unemplg serateg weight_2007o nascent nascent1 nascent2 nascent3 nascentp1 nascentp2 nascentp3 ninno ninno1 ninno2 ninno3 ninnop1 ninnop2 ninnop3 nopport nopport1 nopport2 nopport3 nopportp1 nopportp2 nopportp3 nnecess nnecess1 nnecess2 nnecess3 nnecessp1 nnecessp2 nnecessp3 simmi nimmi nimmip1 nimmip2 nimmip3 nimmi1 nimmi2 nimmi3
drop if year==1970
drop if year==1971
drop if year==2008
replace d1seratega = . in 1
replace d1seratega = . in 2
replace d1cgdpga = . in 1
replace d1unemplga = . in 1


/*Label aggregate dataset*/
label variable  gdpdev6 "Weighted avg deviation of GDP from trend in old OECD 1972-2007 with Lamda 6.25"
label variable  gdpdev100 "Weighted avg deviation of GDP from trend in old OECD 1972-2007 with Lamda 100"
label variable  unempd6 "Weighted avg deviation of unempl from trend in old OECD 1972-2007 with Lamda 6.25"
label variable  unempd6 "Weighted avg deviation unempl from trend in old OECD 1972-2007 with Lamda 6.25"
label variable  unempd100 "Weighted avg deviation unempl from trend in old OECD 1972-2007 with Lamda 100"
label variable  servdevw6 "Weighted avg deviation serate from trend in old OECD 1972-2007 with Lamda 6.25"
label variable servdevw100 "Weighted avg deviation serate from trend in old OECD 1972-2007 with Lamda 100"
label variable  d1cgdpga "D1 of cGDP growth average weight old OECD"
label variable  d1unemplga "D1 of Unemploy growth average weight old OECD"
label variable  d1seratega "D1 of Serate growth average weight old OECD"

/*Declare data to be time series*/
tsset year, yearly
