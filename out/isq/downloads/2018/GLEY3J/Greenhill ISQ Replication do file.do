** Replication .do file for ISQ paper
** This refers to the 070708 data file.

** transform and rename variables:
gen loggdp=log(gdp)
rename polity2 polity
rename fdiin fdi

** generate 1 year lags:
gen polity1=polity[_n-1] if bricode==bricode[_n-1]
gen trade1=trade[_n-1] if bricode==bricode[_n-1]
gen fdi1=fdi[_n-1] if bricode==bricode[_n-1]
gen loggdp1=loggdp[_n-1] if bricode==bricode[_n-1]
gen civwar1=civwar[_n-1] if bricode==bricode[_n-1]
gen intwar1=intwar[_n-1] if bricode==bricode[_n-1]
gen durable1=durable[_n-1] if bricode==bricode[_n-1]
gen density1=density[_n-1] if bricode==bricode[_n-1]
gen hardpta1=hardpta[_n-1] if bricode==bricode[_n-1]
gen softpta1=softpta[_n-1] if bricode==bricode[_n-1]
gen neighbour1=neighbour[_n-1] if bricode==bricode[_n-1]
gen language1=language[_n-1] if bricode==bricode[_n-1]
gen colonies1=colonies[_n-1] if bricode==bricode[_n-1]
gen igoc1=igoc[_n-1] if bricode==bricode[_n-1]
gen physint1=physint[_n-1] if bricode==bricode[_n-1]
gen mortality1=mortality[_n-1] if bricode==bricode[_n-1]
gen igocxhr1=igocxhr[_n-1] if bricode==bricode[_n-1]


** generate 2 year lags:
gen polity2=polity[_n-2] if bricode==bricode[_n-2]
gen trade2=trade[_n-2] if bricode==bricode[_n-2]
gen fdi2=fdi[_n-2] if bricode==bricode[_n-2]
gen loggdp2=loggdp[_n-2] if bricode==bricode[_n-2]
gen civwar2=civwar[_n-2] if bricode==bricode[_n-2]
gen intwar2=intwar[_n-2] if bricode==bricode[_n-2]
gen durable2=durable[_n-2] if bricode==bricode[_n-2]
gen density2=density[_n-2] if bricode==bricode[_n-2]
gen hardpta2=hardpta[_n-2] if bricode==bricode[_n-2]
gen softpta2=softpta[_n-2] if bricode==bricode[_n-2]
gen neighbour2=neighbour[_n-2] if bricode==bricode[_n-2]
gen language2=language[_n-2] if bricode==bricode[_n-2]
gen colonies2=colonies[_n-2] if bricode==bricode[_n-2]
gen igoc2=igoc[_n-2] if bricode==bricode[_n-2]
gen mortality2=mortality[_n-2] if bricode==bricode[_n-2]
gen igocxhr2=igocxhr[_n-2] if bricode==bricode[_n-2]


** generate 3 year lags:
gen polity3=polity[_n-3] if bricode==bricode[_n-3]
gen trade3=trade[_n-3] if bricode==bricode[_n-3]
gen fdi3=fdi[_n-3] if bricode==bricode[_n-3]
gen loggdp3=loggdp[_n-3] if bricode==bricode[_n-3]
gen civwar3=civwar[_n-3] if bricode==bricode[_n-3]
gen intwar3=intwar[_n-3] if bricode==bricode[_n-3]
gen durable3=durable[_n-3] if bricode==bricode[_n-3]
gen density3=density[_n-3] if bricode==bricode[_n-3]
gen hardpta3=hardpta[_n-3] if bricode==bricode[_n-3]
gen softpta3=softpta[_n-3] if bricode==bricode[_n-3]
gen neighbour3=neighbour[_n-3] if bricode==bricode[_n-3]
gen language3=language[_n-3] if bricode==bricode[_n-3]
gen colonies3=colonies[_n-3] if bricode==bricode[_n-3]
gen igoc3=igoc[_n-3] if bricode==bricode[_n-3]
gen mortality3=mortality[_n-3] if bricode==bricode[_n-3]
gen igocxhr3=igocxhr[_n-3] if bricode==bricode[_n-3]


** generate 4 year lags:
gen polity4=polity[_n-4] if bricode==bricode[_n-4]
gen trade4=trade[_n-4] if bricode==bricode[_n-4]
gen fdi4=fdi[_n-4] if bricode==bricode[_n-4]
gen loggdp4=loggdp[_n-4] if bricode==bricode[_n-4]
gen civwar4=civwar[_n-4] if bricode==bricode[_n-4]
gen intwar4=intwar[_n-4] if bricode==bricode[_n-4]
gen durable4=durable[_n-4] if bricode==bricode[_n-4]
gen density4=density[_n-4] if bricode==bricode[_n-4]
gen hardpta4=hardpta[_n-4] if bricode==bricode[_n-4]
gen softpta4=softpta[_n-4] if bricode==bricode[_n-4]
gen neighbour4=neighbour[_n-4] if bricode==bricode[_n-4]
gen language4=language[_n-4] if bricode==bricode[_n-4]
gen colonies4=colonies[_n-4] if bricode==bricode[_n-4]
gen igoc4=igoc[_n-4] if bricode==bricode[_n-4]
gen mortality4=mortality[_n-4] if bricode==bricode[_n-4]
gen igocxhr4=igocxhr[_n-4] if bricode==bricode[_n-4]


** generate 5 year lags:
gen polity5=polity[_n-5] if bricode==bricode[_n-5]
gen trade5=trade[_n-5] if bricode==bricode[_n-5]
gen fdi5=fdi[_n-5] if bricode==bricode[_n-5]
gen loggdp5=loggdp[_n-5] if bricode==bricode[_n-5]
gen civwar5=civwar[_n-5] if bricode==bricode[_n-5]
gen intwar5=intwar[_n-5] if bricode==bricode[_n-5]
gen durable5=durable[_n-5] if bricode==bricode[_n-5]
gen density5=density[_n-5] if bricode==bricode[_n-5]
gen hardpta5=hardpta[_n-5] if bricode==bricode[_n-5]
gen softpta5=softpta[_n-5] if bricode==bricode[_n-5]
gen neighbour5=neighbour[_n-5] if bricode==bricode[_n-5]
gen language5=language[_n-5] if bricode==bricode[_n-5]
gen colonies5=colonies[_n-5] if bricode==bricode[_n-5]
gen igoc5=igoc[_n-5] if bricode==bricode[_n-5]
gen mortality5=mortality[_n-5] if bricode==bricode[_n-5]
gen igocxhr5=igocxhr[_n-5] if bricode==bricode[_n-5]


** Now run the basic model:
oprobit physint physint1 polity1 trade1 fdi1 loggdp1 civwar1 intwar1 durable1 density1 hardpta1 softpta1 neighbour1 language1 colonies1 igoc1, robust cluster(bricode)
oprobit physint physint1 polity2 trade2 fdi2 loggdp2 civwar2 intwar2 durable2 density2 hardpta2 softpta2 neighbour2 language2 colonies2 igoc2, robust cluster(bricode)
oprobit physint physint1 polity3 trade3 fdi3 loggdp3 civwar3 intwar3 durable3 density3 hardpta3 softpta3 neighbour3 language3 colonies3 igoc3, robust cluster(bricode)
oprobit physint physint1 polity4 trade4 fdi4 loggdp4 civwar4 intwar4 durable4 density4 hardpta4 softpta4 neighbour4 language4 colonies4 igoc4, robust cluster(bricode)
oprobit physint physint1 polity5 trade5 fdi5 loggdp5 civwar5 intwar5 durable5 density5 hardpta5 softpta5 neighbour5 language5 colonies5 igoc5, robust cluster(bricode)

** Now the basic model without the igoc variable:
oprobit physint physint1 polity1 trade1 fdi1 loggdp1 civwar1 intwar1 durable1 density1 hardpta1 softpta1 neighbour1 language1 colonies1 , robust cluster(bricode)
oprobit physint physint1 polity2 trade2 fdi2 loggdp2 civwar2 intwar2 durable2 density2 hardpta2 softpta2 neighbour2 language2 colonies2 , robust cluster(bricode)
oprobit physint physint1 polity3 trade3 fdi3 loggdp3 civwar3 intwar3 durable3 density3 hardpta3 softpta3 neighbour3 language3 colonies3 , robust cluster(bricode)
oprobit physint physint1 polity4 trade4 fdi4 loggdp4 civwar4 intwar4 durable4 density4 hardpta4 softpta4 neighbour4 language4 colonies4 , robust cluster(bricode)
oprobit physint physint1 polity5 trade5 fdi5 loggdp5 civwar5 intwar5 durable5 density5 hardpta5 softpta5 neighbour5 language5 colonies5 , robust cluster(bricode)

** Now try the basic model with the infant mortality variable instead of loggdp:
oprobit physint physint1 polity1 trade1 fdi1 mortality1 civwar1 intwar1 durable1 density1 hardpta1 softpta1 neighbour1 language1 colonies1 igoc1, robust cluster(bricode)
oprobit physint physint1 polity2 trade2 fdi2 mortality2 civwar2 intwar2 durable2 density2 hardpta2 softpta2 neighbour2 language2 colonies2 igoc2, robust cluster(bricode)
oprobit physint physint1 polity3 trade3 fdi3 mortality3 civwar3 intwar3 durable3 density3 hardpta3 softpta3 neighbour3 language3 colonies3 igoc3, robust cluster(bricode)
oprobit physint physint1 polity4 trade4 fdi4 mortality4 civwar4 intwar4 durable4 density4 hardpta4 softpta4 neighbour4 language4 colonies4 igoc4, robust cluster(bricode)
oprobit physint physint1 polity5 trade5 fdi5 mortality5 civwar5 intwar5 durable5 density5 hardpta5 softpta5 neighbour5 language5 colonies5 igoc5, robust cluster(bricode)

** now try the basic model with igocxhr instead of igoc:
oprobit physint physint1 polity1 trade1 fdi1 loggdp1 civwar1 intwar1 durable1 density1 hardpta1 softpta1 neighbour1 language1 colonies1 igocxhr1, robust cluster(bricode)
oprobit physint physint1 polity2 trade2 fdi2 loggdp2 civwar2 intwar2 durable2 density2 hardpta2 softpta2 neighbour2 language2 colonies2 igocxhr2, robust cluster(bricode)
oprobit physint physint1 polity3 trade3 fdi3 loggdp3 civwar3 intwar3 durable3 density3 hardpta3 softpta3 neighbour3 language3 colonies3 igocxhr3, robust cluster(bricode)
oprobit physint physint1 polity4 trade4 fdi4 loggdp4 civwar4 intwar4 durable4 density4 hardpta4 softpta4 neighbour4 language4 colonies4 igocxhr4, robust cluster(bricode)
oprobit physint physint1 polity5 trade5 fdi5 loggdp5 civwar5 intwar5 durable5 density5 hardpta5 softpta5 neighbour5 language5 colonies5 igocxhr5, robust cluster(bricode)

** create dummy variables for each value of the prior year's DV (with zero as the reference category)
gen py1=0
gen py2=0
gen py3=0
gen py4=0
gen py5=0
gen py6=0
gen py7=0
gen py8=0
replace py1=1 if physint1==1
replace py2=1 if physint1==2
replace py3=1 if physint1==3
replace py4=1 if physint1==4
replace py5=1 if physint1==5
replace py6=1 if physint1==6
replace py7=1 if physint1==7
replace py8=1 if physint1==8
oprobit physint py1 py2 py3 py4 py5 py6 py7 py8 polity1 trade1 fdi1 loggdp1 civwar1 intwar1 durable1 density1 hardpta1 softpta1 neighbour1 language1 colonies1 igoc1, robust cluster(bricode)
oprobit physint py1 py2 py3 py4 py5 py6 py7 py8 polity2 trade2 fdi2 loggdp2 civwar2 intwar2 durable2 density2 hardpta2 softpta2 neighbour2 language2 colonies2 igoc2, robust cluster(bricode)
oprobit physint py1 py2 py3 py4 py5 py6 py7 py8 polity3 trade3 fdi3 loggdp3 civwar3 intwar3 durable3 density3 hardpta3 softpta3 neighbour3 language3 colonies3 igoc3, robust cluster(bricode)
oprobit physint py1 py2 py3 py4 py5 py6 py7 py8 polity4 trade4 fdi4 loggdp4 civwar4 intwar4 durable4 density4 hardpta4 softpta4 neighbour4 language4 colonies4 igoc4, robust cluster(bricode)
oprobit physint py1 py2 py3 py4 py5 py6 py7 py8 polity5 trade5 fdi5 loggdp5 civwar5 intwar5 durable5 density5 hardpta5 softpta5 neighbour5 language5 colonies5 igoc5, robust cluster(bricode)


