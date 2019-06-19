set more off
egen country_num=group(country)
tsset country_num year, yearly
sort country year
replace frt10=frt10+ln(usder)-ln(pusa)+ln(100)
replace frt30=frt30+ln(usder)-ln(pusa)+ln(100)
replace isserlis=ln(isserlis)+ln(usder)-ln(pusa)+ln(100)
g logimports=ln(realimports)
g logexports=ln(realexports)
g logaverage=(logimports+logexports)/2
g loggdp=ln(gdp)
g logukgdp=ln(ukgdp)
g logtariffs=ln(tariffs)
g loguktariffs=ln(uktariffs)
g logavertar=ln((tariffs+uktariffs)/2)
g gold=standard==1
gen loggdpsum=ln(ukgdp+gdp)
gen suk=ukgdp/(ukgdp+gdp)
gen sj=gdp/(ukgdp+gdp)
gen logsprod=ln(suk*sj)
g exclude=0
replace exclude=1 if country=="Canada" & year>1907
replace exclude=1 if country=="Uruguay" & year>1907
replace exclude=1 if country=="Australasia" & year<1884
replace exclude=1 if country=="Denmark" & year<1884
replace exclude=1 if country=="India" & year<1884
replace exclude=1 if country=="Sweden/Norway" & year<1884
replace exclude=1 if country=="Argentina" & year<1900
replace exclude=1 if country=="Chile" & year<1900
replace exclude=1 if country=="Colombia" & year<1900
replace exclude=1 if country=="Philippines" & year<1902
egen time=group(year)
quiet tab country_num, gen(country_num_)
quiet tab time, gen(t)
gen decade=int(year/10)
quiet tab decade, gen(decade_)

*summary statistics*

sum logaverage freight loggdpsum logsprod logavertar gold ervol if (exclude==0 & ervol~=. & logavertar~=.)

*begin OLS estimation*

xtivreg2 logaverage freight if (exclude==0 & ervol~=. & logavertar~=.), fe robust bw(3)
xtivreg2 logaverage freight loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 if exclude==0, fe robust bw(3)

*begin IV estimation*

tsset country_num year, yearly
g logwages=log(wages)
g logcoal=log(coal_prices)
g logfish=log(fish_price)
g log_sail_tonnage=log(sail_tonnage)
g log_sail_numbers=log(sail_numbers)
g log_steam_tonnage=log(steamship_tonnage)
g log_steam_numbers=log(steam_numbers)
g logaversail=log(sail_tonnage)-log(sail_numbers)
g logaversteam=log(steamship_tonnage)-log(steam_numbers)
g logaversteambigger=logaversteam-logaversail
replace logwages=logwages+log(norusa_erate)-log(pusa)+log(100)
replace logcoal=logcoal+log(usder)-log(pusa)+log(100)
replace logfish=logfish+log(canusa_erate)-log(pusa)+log(100)
g country_mean=sw_mean
g country_stddev=sw_stddev
replace country_mean=ne_mean if ((country=="Denmark")|(country=="Germany")|(country=="Russia")|(country=="Sweden/Norway"))
replace country_stddev=ne_stddev if ((country=="Denmark")|(country=="Germany")|(country=="Russia")|(country=="Sweden/Norway"))
replace country_mean=nw_mean if ((country=="Canada")|(country=="United States"))
replace country_stddev=nw_stddev if ((country=="Canada")|(country=="United States"))
replace country_mean=se_mean if ((country=="Italy"))
replace country_stddev=se_stddev if ((country=="Italy"))
replace country_mean=country_mean-1000
g dist=distance
replace dist=log(distance)
g distcountry_mean=(dist)*country_mean
g distcountry_stddev=(dist)*country_stddev
g distsailtonnage=dist*log_sail_tonnage
g diststeamtonnage=dist*log_steam_tonnage
g distlogwages=(dist)*logwages
g distlogcoal=(dist)*logcoal
g distlogfish=(dist)*logfish
g distlogaversteam=(dist)*logaversteam
g distlogaversail=(dist)*logaversail
g distlog_steam_numbers=(dist)*log_steam_numbers
g distlog_sail_numbers=(dist)*log_sail_numbers
g lag_log_steam_tonnage=(L1.log_steam_tonnage+L2.log_steam_tonnage)/2
g lag_log_sail_tonnage=(L1.log_sail_tonnage+L2.log_sail_tonnage)/2
g dist_lag_log_steam_tonnage=dist*lag_log_steam_tonnage
g dist_lag_log_sail_tonnage=dist*lag_log_sail_tonnage

tsset country_num year, yearly
xtivreg2 logaverage loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 decade_5 (freight=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0, fe robust bw(3) first 

*use these 2 regressions to get the correct first-stage F, and the moreira conf set
xtivreg2 logaverage loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 decade_5 (freight=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0, fe first 
xi: condivreg logaverage loggdpsum logsprod logavertar gold ervol i.decade i.country_num (freight=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0 , liml

*begin differenced estimation*

sort country year
tsset country_num year
drop if country=="Canada" & year>1907
drop if country=="Uruguay" & year>1907
drop if country=="Australasia" & year<1884
drop if country=="Denmark" & year<1884
drop if country=="India" & year<1884
drop if country=="Sweden/Norway" & year<1884
drop if country=="Argentina" & year<1900
drop if country=="Chile" & year<1900
drop if country=="Colombia" & year<1900
drop if country=="Philippines" & year<1902
sort country year
by country: gen dtrade=logaverage-logaverage[_n-10]
by country: gen dgrowth=loggdpsum-loggdpsum[_n-10]
by country: gen dconverg=logsprod-logsprod[_n-10]
by country: gen dfreight=freight-freight[_n-10]
by country: gen davertot=logavertot-logavertot[_n-10]
by country: gen davertar=logavertar-logavertar[_n-10]
by country: gen dgold=gold-gold[_n-10]
by country: gen dervol=ervol-ervol[_n-10]
by country: gen dwages=logwages-logwages[_n-10]
by country: gen dcoal=logcoal-logcoal[_n-10]
by country: gen dfish=logfish-logfish[_n-10]
by country: gen dnw_mean=nw_mean-nw_mean[_n-10]
by country: gen dnw_stddev=nw_stddev-nw_stddev[_n-10]
by country: gen dne_mean=ne_mean-ne_mean[_n-10]
by country: gen dne_stddev=ne_stddev-ne_stddev[_n-10]
by country: gen dsw_mean=sw_mean-sw_mean[_n-10]
by country: gen dsw_stddev=sw_stddev-sw_stddev[_n-10]
by country: gen dse_mean=se_mean-se_mean[_n-10]
by country: gen dse_stddev=se_stddev-se_stddev[_n-10]
by country: gen dcountry_mean=country_mean-country_mean[_n-10]
by country: gen dcountry_stddev=country_stddev-country_stddev[_n-10]
by country: gen daversail=logaversail-logaversail[_n-10]
by country: gen daversteam=logaversteam-logaversteam[_n-10]
by country: g ddistlogwages=distlogwages-distlogwages[_n-10]
by country: g ddistlogcoal=distlogcoal-distlogcoal[_n-10]
by country: g ddistlogfish=distlogfish-distlogfish[_n-10]
by country: g ddistlogaversteam=distlogaversteam-distlogaversteam[_n-10]
by country: g ddistlogaversail=distlogaversail-distlogaversail[_n-10]
by country: g ddistcountry_mean=distcountry_mean-distcountry_mean[_n-10]
by country: g ddistcountry_stddev=distcountry_stddev-distcountry_stddev[_n-10]
by country: g dlag_log_steam_tonnage=lag_log_steam_tonnage-lag_log_steam_tonnage[_n-10]
by country: g dlag_log_sail_tonnage=lag_log_sail_tonnage-lag_log_sail_tonnage[_n-10]
by country: g ddist_lag_log_steam_tonnage=dist_lag_log_steam_tonnage-dist_lag_log_steam_tonnage[_n-10]
by country: g ddist_lag_log_sail_tonnage=dist_lag_log_sail_tonnage-dist_lag_log_sail_tonnage[_n-10]

sum dtrade dfreight dgrowth dconverg davertot davertar dgold dervol if (exclude==0 & dervol~=. & davertar~=.)

ivreg2 dtrade dgrowth dconverg davertar dgold dervol (dfreight=ddistlogwages ddistlogcoal ddistlogfish ddistlogaversail ddistlogaversteam dcountry_mean dcountry_stddev ddistcountry_mean ddistcountry_stddev) if exclude==0, noconst robust bw(3) first

*use these 2 regressions to get the correct first-stage F, and the moreira conf set

ivreg2 dtrade dgrowth dconverg davertar dgold dervol (dfreight=ddistlogwages ddistlogcoal ddistlogfish ddistlogaversail ddistlogaversteam dcountry_mean dcountry_stddev ddistcountry_mean ddistcountry_stddev) if exclude==0, noconst  first
condivreg dtrade dgrowth dconverg davertar dgold dervol (dfreight=ddistlogwages ddistlogcoal ddistlogfish ddistlogaversail ddistlogaversteam dcountry_mean dcountry_stddev ddistcountry_mean ddistcountry_stddev) if exclude==0 , nocons noinstcons liml

*begin estimation with decadal country fixed effects*

tsset country_num year
xi: xtivreg2 logaverage freight loggdpsum logsprod logavertar gold ervol i.decade i.decade*i.country if exclude==0, fe robust bw(3) 
xi: xtivreg2 logaverage loggdpsum logsprod logavertar gold ervol i.decade i.decade*i.country (freight=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0, fe robust bw(3) first

*begin estimation with Isserlis*

tsset country_num year
xtivreg2 logaverage isserlis if (exclude==0 & ervol~=. & logavertar~=.), fe robust bw(3)
xtivreg2 logaverage isserlis loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 if exclude==0, fe robust bw(3)
xtivreg2 logaverage loggdpsum logsprod logavertar gold dervol decade_1 decade_2 decade_3 decade_4 (isserlis=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0, fe robust bw(3) first 

*begin estimation with other splines*

tsset country_num year
xtivreg2 logaverage frt10 if (exclude==0 & ervol~=. & logavertar~=.), fe robust bw(3)
xtivreg2 logaverage frt10 loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 if exclude==0, fe robust bw(3)
xtivreg2 logaverage loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 (frt10=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0, fe robust bw(3) first 
xtivreg2 logaverage frt30 if (exclude==0 & ervol~=. & logavertar~=.), fe robust bw(3)
xtivreg2 logaverage frt30 loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 if exclude==0, fe robust bw(3)
xtivreg2 logaverage loggdpsum logsprod logavertar gold ervol decade_1 decade_2 decade_3 decade_4 (frt30=L1.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) L2.(log_steam_tonnage log_sail_tonnage distsailtonnage diststeamtonnage) logwages logcoal logfish distlogwages distlogcoal distlogfish logaversteam logaversail distlogaversteam distlogaversail country_mean country_stddev distcountry_mean distcountry_stddev) if exclude==0, fe robust bw(3) first 
