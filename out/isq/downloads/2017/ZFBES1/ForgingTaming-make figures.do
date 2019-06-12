********************************************************************
* 
* Replication file for "Forging then Taming Leviathan: State Capacity, Constraints on Rulers, and Development" International Studies Quarterly, June 2014.
* Jonathan Hanson

********************************************************************
* This do file assumes that the following file is located in the current working directory:
* ForgingTaming-figure data.dta
******************************************************************

clear all
use "ForgingTaming-figure data.dta"
set more off

*** create variables to account for growth for all countries during the 1960-2005 time period
* Get the first year for which rgdpl2 exists and find corresponding value of gdpwkr, kixwkr, and ey15new.  These serve as start values.
gen rgdpl2started=1 if rgdpl2~=. & L.rgdpl2==.
gen gdpstartyear=year if rgdpl2started==1 & L.rgdpl2started~=1
gen startgdpwkr=gdpwkr if year==gdpstartyear & year<1971
gen startkixwkr=kixwkr if year==gdpstartyear & year<1971
gen startey15a=ey15new if year==gdpstartyear & year<1971

* For Checks, which starts at 1975, get the 1975 values of gdpwkr, kixwkr and ey15new.
gen gdpwkr75=gdpwkr if year==1975
gen kixwkr75=kixwkr if year==1975
gen ey15a75=ey15new if year==1975

* Get end of period values.
by cntrynum: egen endkixwkr=mean(kixwkr) if year==2005
by cntrynum: egen endgdpwkr=mean(gdpwkr) if year==2005
by cntrynum: egen endey15a=mean(ey15new) if year==2005
gen double Checkstemp=ln(checks)
by cntrynum: egen double startChecks=mean(Checkstemp) if year==1975
by cntrynum: egen double Checks=mean(Checkstemp)
by cntrynum: egen StateHist=mean(statehistn05v3)

**  Create program to make stages of development
program create_advind
	/* 1st argument `1' is rgdpl2 threshold level */
	/* 2nd argument `2' is first year */
	/* 3rd argument `3' is last year */
	gen adv`1'=0 if rgdpl2~=.
	local i = `2'
	gen level`i'=`1'
	while `i'<`=`3'+1' {
	replace adv`1'=1 if rgdpl2>=level`i' & rgdpl2~=. & year==`i'
	egen temp`i'=mean(growth) if adv`1'==1 & year==`i'
	egen mean`i'=mean(temp`i')
	gen level`=`i'+1'=level`i' * (1 + mean`i')
	drop temp`i' level`i' mean`i'
	local ++i 
	}
	drop level`i'
end

** Create stages of development.  Stage 3 countries are those that start 1960 with 8500 in GDP per capita based on PWT.  Stage 1 countries are those that start 1960 with less than 2700.

create_advind 8500 1960 2005
gen stage=1 if rgdpl2<2700
replace stage=2 if rgdpl2>=2700 & adv8500==0
replace stage=3 if adv8500==1

gen stage1temp=1 if (stage==1 & year==1960) | (stage==1 & L.stage==. & year>1960)  
by cntrynum: egen stage1start=mean(stage1temp)

gen stage1temp75=1 if (stage==1 & year==1975) | (stage==1 & L.stage==. & year>1975)
by cntrynum: egen stage1start75=mean(stage1temp75)

** Get counts of years a country spent in Stage 1
by cntrynum: egen stage1years=sum(stage) if stage==1
by cntrynum: egen stage1years75=sum(stage) if stage==1 & year>=1975

** Generate values of institutional variables during Stage 1 years
by cntrynum: egen double stage1checks=mean(Checkstemp) if year>=1975 & stage==1

** Create variables to account for growth during Stage 3 years
gen stage3startyr=1960 if stage==3 & year==1960
replace stage3startyr=year if stage3startyr==. & stage==3 & L.stage~=3 & year>1960
by cntrynum: egen checkyear=mean(stage3startyr)

* Create stage 3 gdpgrowth based upon full range of years
gen stage3gdpstart=gdpwkr if year==stage3startyr
gen stage3kixstart=kixwkr if year==stage3startyr
gen stage3ey15start=ey15new if year==stage3startyr

* Now, create version of stage 3 start year that begins with 1975 for Checks variable
gen temp=1975 if year==1975 & stage==3
replace temp=stage3startyr if stage3startyr>1975 & stage3startyr~=.
by cntrynum: egen stage3start75=mean(temp)
drop temp

* Create stage 3 gdpgrowth based on years beginning with 1975 
gen stage3gdpstart75=gdpwkr if year==stage3start75
gen stage3kixstart75=kixwkr if year==stage3start75
gen stage3ey15start75=ey15new if year==stage3start75

* Generate end year values
gen stage3endyr=2005 if stage==3 & year==2005
replace stage3endyr=year if stage==3 & F.stage==2 & year<2005 & year>checkyear
gen stage3gdpend=gdpwkr if year==stage3endyr
gen stage3kixend=kixwkr if year==stage3endyr
gen stage3ey15end=ey15new if year==stage3endyr
gen stage3years=stage3endyr-stage3startyr

* Generate values of institutional variables during stage 3 years
by cntrynum: egen double stage3checks=mean(Checkstemp) if year>=stage3start75 & year<=stage3endyr


**
collapse endkixwkr startkixwkr endgdpwkr startgdpwkr gdpwkr75 kixwkr75 ey15a75 endey15a startey15a startChecks Checks StateHist stage1start stage1start75 stage1years stage1years75 stage3gdpstart stage3kixstart stage3ey15start stage3gdpend stage3kixend stage3ey15end stage3endyr stage3startyr stage3start75 stage3gdpstart75 stage3kixstart75 stage3ey15start75 gdpstartyear stage1checks stage3checks, by(cntrynum)

gen country=""

replace country="Afghanistan" if cntrynum==1
replace country="Albania" if cntrynum==2
replace country="Algeria" if cntrynum==3
replace country="Angola" if cntrynum==4
replace country="Argentina" if cntrynum==5
replace country="Armenia" if cntrynum==6
replace country="Australia" if cntrynum==7
replace country="Austria" if cntrynum==8
replace country="Azerbaijan" if cntrynum==9
replace country="Bahamas" if cntrynum==10
replace country="Bahrain" if cntrynum==11
replace country="Bangladesh" if cntrynum==12
replace country="Barbados" if cntrynum==13
replace country="Belarus" if cntrynum==14
replace country="Belgium" if cntrynum==15
replace country="Belize" if cntrynum==16
replace country="Benin" if cntrynum==17
replace country="Bhutan" if cntrynum==18
replace country="Bolivia" if cntrynum==19
replace country="Bosnia and Herzegovina" if cntrynum==20
replace country="Botswana" if cntrynum==21
replace country="Brazil" if cntrynum==22
replace country="Brunei" if cntrynum==23
replace country="Bulgaria" if cntrynum==24
replace country="Burkina Faso" if cntrynum==25
replace country="Burundi" if cntrynum==26
replace country="Cambodia" if cntrynum==27
replace country="Cameroon" if cntrynum==28
replace country="Canada" if cntrynum==29
replace country="Cape Verde Is." if cntrynum==30
replace country="Central African Rep." if cntrynum==31
replace country="Chad" if cntrynum==32
replace country="Chile" if cntrynum==33
replace country="China" if cntrynum==34
replace country="Colombia" if cntrynum==35
replace country="Comoro Islands" if cntrynum==36
replace country="Congo, Dem Rep" if cntrynum==37
replace country="Congo, Rep." if cntrynum==38
replace country="Costa Rica" if cntrynum==39
replace country="Cote d'Ivoire" if cntrynum==40
replace country="Croatia" if cntrynum==41
replace country="Cuba" if cntrynum==42
replace country="Cyprus" if cntrynum==43
replace country="Czech Rep." if cntrynum==44
replace country="Czechoslovakia" if cntrynum==45
replace country="Denmark" if cntrynum==46
replace country="Djibouti" if cntrynum==47
replace country="Dominican Rep." if cntrynum==48
replace country="Ecuador" if cntrynum==49
replace country="Egypt" if cntrynum==50
replace country="El Salvador" if cntrynum==51
replace country="Eq. Guinea" if cntrynum==52
replace country="Eritrea" if cntrynum==53
replace country="Estonia" if cntrynum==54
replace country="Ethiopia" if cntrynum==55
replace country="Fiji" if cntrynum==56
replace country="Finland" if cntrynum==57
replace country="France" if cntrynum==58
replace country="Gabon" if cntrynum==59
replace country="Gambia" if cntrynum==60
replace country="Georgia" if cntrynum==61
replace country="Germany" if cntrynum==62
replace country="Germany, East" if cntrynum==63
replace country="Germany, West" if cntrynum==64
replace country="Ghana" if cntrynum==65
replace country="Greece" if cntrynum==66
replace country="Grenada" if cntrynum==67
replace country="Guatemala" if cntrynum==69
replace country="Guinea" if cntrynum==70
replace country="Guinea-Bissau" if cntrynum==71
replace country="Guyana" if cntrynum==72
replace country="Haiti" if cntrynum==73
replace country="Honduras" if cntrynum==74
replace country="Hong Kong" if cntrynum==75
replace country="Hungary" if cntrynum==76
replace country="Iceland" if cntrynum==77
replace country="India" if cntrynum==78
replace country="Indonesia" if cntrynum==79
replace country="Iran" if cntrynum==80
replace country="Iraq" if cntrynum==81
replace country="Ireland" if cntrynum==82
replace country="Israel" if cntrynum==83
replace country="Italy" if cntrynum==84
replace country="Jamaica" if cntrynum==85
replace country="Japan" if cntrynum==86
replace country="Jordan" if cntrynum==87
replace country="Kazakhstan" if cntrynum==88
replace country="Kenya" if cntrynum==89
replace country="North Korea" if cntrynum==90
replace country="South Korea" if cntrynum==91
replace country="Kuwait" if cntrynum==92
replace country="Kyrgyzstan" if cntrynum==93
replace country="Laos" if cntrynum==94
replace country="Latvia" if cntrynum==95
replace country="Lebanon" if cntrynum==96
replace country="Lesotho" if cntrynum==97
replace country="Liberia" if cntrynum==98
replace country="Libya" if cntrynum==99
replace country="Lithuania" if cntrynum==100
replace country="Luxembourg" if cntrynum==101
replace country="Macao" if cntrynum==102
replace country="Macedonia" if cntrynum==103
replace country="Madagascar" if cntrynum==104
replace country="Malawi" if cntrynum==105
replace country="Malaysia" if cntrynum==106
replace country="Maldives" if cntrynum==107
replace country="Mali" if cntrynum==108
replace country="Malta" if cntrynum==109
replace country="Martinique" if cntrynum==110
replace country="Mauritania" if cntrynum==111
replace country="Mauritius" if cntrynum==112
replace country="Mexico" if cntrynum==113
replace country="Moldova" if cntrynum==114
replace country="Mongolia" if cntrynum==115
replace country="Morocco" if cntrynum==116
replace country="Mozambique" if cntrynum==117
replace country="Myanmar" if cntrynum==118
replace country="Namibia" if cntrynum==119
replace country="Nepal" if cntrynum==120
replace country="Netherlands" if cntrynum==121
replace country="New Zealand" if cntrynum==122
replace country="Nicaragua" if cntrynum==123
replace country="Niger" if cntrynum==124
replace country="Nigeria" if cntrynum==125
replace country="Norway" if cntrynum==126
replace country="Oman" if cntrynum==127
replace country="Pakistan" if cntrynum==128
replace country="Panama" if cntrynum==129
replace country="Papua New Guinea" if cntrynum==130
replace country="Paraguay" if cntrynum==131
replace country="Peru" if cntrynum==132
replace country="Philippines" if cntrynum==133
replace country="Poland" if cntrynum==134
replace country="Portugal" if cntrynum==135
replace country="Puerto Rico" if cntrynum==136
replace country="Qatar" if cntrynum==137
replace country="Reunion" if cntrynum==138
replace country="Romania" if cntrynum==139
replace country="Russia" if cntrynum==140
replace country="Rwanda" if cntrynum==141
replace country="Samoa" if cntrynum==142
replace country="Sao Tome and Principe" if cntrynum==143
replace country="Saudi Arabia" if cntrynum==144
replace country="Senegal" if cntrynum==145
replace country="Seychelles" if cntrynum==146
replace country="Sierra Leone" if cntrynum==147
replace country="Singapore" if cntrynum==148
replace country="Slovakia" if cntrynum==149
replace country="Slovenia" if cntrynum==150
replace country="Solomon Islands" if cntrynum==151
replace country="Somalia" if cntrynum==152
replace country="South Africa" if cntrynum==153
replace country="Soviet Union" if cntrynum==154
replace country="Spain" if cntrynum==155
replace country="Sri Lanka" if cntrynum==156
replace country="St. Lucia" if cntrynum==157
replace country="Sudan" if cntrynum==158
replace country="Suriname" if cntrynum==159
replace country="Swaziland" if cntrynum==160
replace country="Sweden" if cntrynum==161
replace country="Switzerland" if cntrynum==162
replace country="Syria" if cntrynum==163
replace country="Taiwan" if cntrynum==164
replace country="Tajikistan" if cntrynum==165
replace country="Tanzania" if cntrynum==166
replace country="Thailand" if cntrynum==167
replace country="Togo" if cntrynum==168
replace country="Trinidad-Tobago" if cntrynum==169
replace country="Tunisia" if cntrynum==170
replace country="Turk Cyprus" if cntrynum==171
replace country="Turkey" if cntrynum==172
replace country="Turkmenistan" if cntrynum==173
replace country="Uganda" if cntrynum==174
replace country="Ukraine" if cntrynum==175
replace country="United Arab Emirates" if cntrynum==176
replace country="United Kingdom" if cntrynum==177
replace country="United States" if cntrynum==178
replace country="Uruguay" if cntrynum==179
replace country="Uzbekistan" if cntrynum==180
replace country="Vanuatu" if cntrynum==181
replace country="Venezuela" if cntrynum==182
replace country="Vietnam" if cntrynum==183
replace country="Vietnam, North" if cntrynum==184
replace country="Vietnam, South" if cntrynum==185
replace country="West Bank and Gaza" if cntrynum==186
replace country="Yemen" if cntrynum==187
replace country="Yemen (AR)" if cntrynum==188
replace country="Yemen (PDR)" if cntrynum==189
replace country="Yugoslavia" if cntrynum==190
replace country="Yugoslavia, Fed. Rep." if cntrynum==191
replace country="Zambia" if cntrynum==192
replace country="Zimbabwe" if cntrynum==193
replace country="Serbia-Montenegro" if cntrynum==194
replace country="Timor-Leste" if cntrynum==195
replace country="Serbia" if cntrynum==196
replace country="Montenegro" if cntrynum==197
replace country="Kosovo" if cntrynum==198

gen growthyears=2005-gdpstartyear

***** Generate human capital figures for all countries over 1960-2005 time span

gen temp1=startey15a
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=startey15a-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=startey15a-8
replace temp3=0 if temp3<0
gen startH= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3

gen temp1=endey15a
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=endey15a-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=endey15a-8
replace temp3=0 if temp3<0
gen endH= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3

***** Generate human capital figures for all countries over 1975-2005 time span

gen temp1=ey15a75
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=ey15a75-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=ey15a75-8
replace temp3=0 if temp3<0
gen startH75= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3

gen temp1=endey15a
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=endey15a-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=endey15a-8
replace temp3=0 if temp3<0
gen endH75= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3


*****  Generate human capital figures for Stage 3 countries for only the years that they were in Stage 3 
gen temp1=stage3ey15start
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=stage3ey15start-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=stage3ey15start-8
replace temp3=0 if temp3<0
gen stage3startH= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3

* Repeat starting with year 1975
gen temp1=stage3ey15start75
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=stage3ey15start75-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=stage3ey15start75-8
replace temp3=0 if temp3<0
gen stage3startH75= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3

* Create end years

gen temp1=stage3ey15end
replace temp1=4 if temp1>4 & temp1~=.
gen temp2=stage3ey15end-4
replace temp2=4 if temp2>4 & temp2~=.
replace temp2=0 if temp2<0
gen temp3=stage3ey15end-8
replace temp3=0 if temp3<0
gen stage3endH= exp(.13*temp1 + .1*temp2 + .07*temp3)
drop temp1 temp2 temp3


*****  Calculate growth accounting estimates for all countries over the 1960-2005 time period

gen gdpwkrgrowth=(exp((ln(endgdpwkr) - ln(startgdpwkr))/growthyears)-1)*100
gen kixwkrgrowth=(exp((ln(endkixwkr) - ln(startkixwkr))/growthyears)-1)*100
gen Hgrowth=(exp((ln(endH) - ln(startH))/growthyears)-1)*100
gen TFPgrowth= gdpwkrgrowth - .35*kixwkrgrowth - .65*(Hgrowth)

*****  Calculate growth accounting estimates for all countries over the 1975-2005 time period

gen gdpwkrgrowth75=(exp((ln(endgdpwkr) - ln(gdpwkr75))/30)-1)*100
gen kixwkrgrowth75=(exp((ln(endkixwkr) - ln(kixwkr75))/30)-1)*100
gen Hgrowth75=(exp((ln(endH) - ln(startH75))/30)-1)*100
gen TFPgrowth75= gdpwkrgrowth75 - .35*kixwkrgrowth75 - .65*(Hgrowth75)

****  Calculate growth accounting estimates for Stage 3 countries for only those years that they were in Stage 3
gen stage3years=stage3endyr - stage3startyr
gen stage3gdpwkrgrowth=(exp((ln(stage3gdpend) - ln(stage3gdpstart))/stage3years)-1)*100
gen stage3kixwkrgrowth=(exp((ln(stage3kixend) - ln(stage3kixstart))/stage3years)-1)*100
gen stage3Hgrowth=(exp((ln(stage3endH) - ln(stage3startH))/stage3years)-1)*100
gen stage3TFPgrowth= stage3gdpwkrgrowth - .35*stage3kixwkrgrowth - .65*(stage3Hgrowth)

****  Calculate growth accounting estimates for Stage 3 countries for only those years starting with and following 1975 that they were in Stage 3.

gen stage3years75=stage3endyr - stage3start75
gen stage3gdpwkrgrowth75=(exp((ln(stage3gdpend) - ln(stage3gdpstart75))/stage3years75)-1)*100
gen stage3kixwkrgrowth75=(exp((ln(stage3kixend) - ln(stage3kixstart75))/stage3years75)-1)*100
gen stage3Hgrowth75=(exp((ln(stage3endH) - ln(stage3startH75))/stage3years75)-1)*100
gen stage3TFPgrowth75= stage3gdpwkrgrowth75 - .35*stage3kixwkrgrowth75 - .65*(stage3Hgrowth75)

sort cntrynum

*** Identify which countries are Stage 1 and Stage 3
** Chose countries to count as Stage 1 countries for figures.
gen stage1include=1 if stage1start==1 & stage1years~=.
gen stage1include75=1 if stage1start75==1 & stage1years75>5 & stage1years75~=.

** Choose countries to count as Stage 3 countries for figures if they were in stage 3 at least 15 years.  Also, exclude Germany since reunification renders the data suspect.
gen stage3include=1 if stage3years>15 & stage3years~=. & country~="Germany"
gen stage3include75=1 if stage3years75>15 & stage3years75~=. & country~="Germany"


********************************************
*** Make Figure 1
********************************************
* Create variable to indicate position of country name around the dot representing country.  Values are like those of a clock.

gen kixposition=3
replace kixposition= 9 if country=="Bangladesh"
replace kixposition=1 if country=="Cameroon"
replace kixposition= 8 if country=="China"
replace kixposition=2 if country=="Colombia"
replace kixposition= 9 if country=="Cote d'Ivoire"
replace kixposition=9 if country=="Dominican Rep."
replace kixposition= 11 if country=="Ethiopia"
replace kixposition= 1 if country=="Ghana"
replace kixposition= 12 if country=="Guyana"
replace kixposition= 9 if country=="Haiti"
replace kixposition= 9 if country=="India"
replace kixposition=11 if country=="Kenya"
replace kixposition= 8 if country=="South Korea"
replace kixposition= 5 if country=="Madagascar"
replace kixposition= 10 if country=="Mozambique"
replace kixposition= 1 if country=="Nicaragua"
replace kixposition=12 if country=="Philippines"
replace kixposition=12 if country=="Rwanda"
replace kixposition= 5 if country=="Sierra Leone"
replace kixposition= 11 if country=="Tanzania"
replace kixposition= 4 if country=="Tunisia"
replace kixposition=6 if country=="Uganda"

***** Create country positions for Stage 3 graphs

gen stage3kixposition=.
replace stage3kixposition=3 if country=="United States"
replace stage3kixposition=3 if country=="Netherlands"
replace stage3kixposition=12 if country=="France"
replace stage3kixposition=9 if country=="Japan"
replace stage3kixposition=3 if country=="Australia"
replace stage3kixposition=3 if country=="Canada"
replace stage3kixposition=2 if country=="Denmark"
replace stage3kixposition=7 if country=="Belgium"
replace stage3kixposition=2 if country=="United Kingdom"
replace stage3kixposition=10 if country=="Finland"
replace stage3kixposition=9 if country=="Iceland"

** Figure 1c
twoway (scatter kixwkrgrowth StateHist if stage1start==1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(kixposition) mlabgap(tiny)) (lfit kixwkrgrowth StateHist if stage1start==1), ytitle(Growth Rate of Capital Stock per Worker) xtitle(State Authority (StateHist)) legend(off) scheme(s1mono)

* Adjust country name positions
replace kixposition=3 if country=="China"
replace kixposition=9 if country=="Mali"
replace kixposition=6 if country=="Sri Lanka" 
replace kixposition=3 if country=="Madagascar"
replace kixposition=6 if country=="Cameroon"
replace kixposition=10 if country=="Pakistan"
replace kixposition=3 if country=="Ethiopia"
replace kixposition=12 if country=="Mozambique"
replace kixposition=9 if country=="Tanzania"
replace kixposition=3 if country=="Ghana"
replace kixposition=9 if country=="Kenya"
replace kixposition=3 if country=="Philippines"
replace kixposition=12 if country=="Bangladesh"
replace kixposition=9 if country=="Sierra Leone"
replace kixposition=10 if country=="Uganda"
replace kixposition=9 if country=="Mozambique"

** Figure 1a
twoway (scatter kixwkrgrowth75 stage1checks if stage1include75==1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(kixposition) mlabgap(tiny)) (lfit kixwkrgrowth75 stage1checks if stage1include75==1), ytitle(Growth Rate of Capital Stock per Worker) xtitle(Constraints on Rulers (Checks)) legend(off) scheme(s1mono) ylabel(-5(5)10)

* Figure 1d
twoway (scatter stage3kixwkrgrowth StateHist if stage3include==1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(stage3kixposition) mlabgap(tiny)) (lfit stage3kixwkrgrowth StateHist if stage3include==1), ytitle(Growth Rate of Capital Stock per Worker) xtitle(State Authority (StateHist)) legend(off) scheme(s1mono)

replace stage3kixposition=9 if country=="Norway"
replace stage3kixposition=9 if country=="United States"
replace stage3kixposition=12 if country=="Belgium"
replace stage3kixposition=11 if country=="Switzerland"
replace stage3kixposition=9 if country=="Sweden"
replace stage3kixposition=3 if country=="Finland"
replace stage3kixposition=12 if country=="Iceland"
replace stage3kixposition=9 if country=="United Kingdom"
replace stage3kixposition=9 if country=="France"
replace stage3kixposition=9 if country=="Denmark"
replace stage3kixposition=4 if country=="Australia"
replace stage3kixposition=11 if country=="Canada"
replace stage3kixposition=3 if country=="Netherlands"

* Figure 1b
twoway (scatter stage3kixwkrgrowth75 stage3checks if stage3include75==1 & stage3checks>1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(stage3kixposition) mlabgap(tiny)) (lfit stage3kixwkrgrowth75 stage3checks if stage3include75==1 & stage3checks>1), ytitle(Growth Rate of Capital Stock per Worker) xtitle(Constraints on Rulers (Checks)) legend(off) scheme(s1mono)


**************************************
** Make Figure S1
**************************************

*** Add information for positioning country names 
gen TFPposition=3
gen stage3TFPposition=.
replace TFPposition= 2 if country=="Bangladesh"
replace TFPposition= 9 if country=="China"
replace TFPposition= 1 if country=="Cote d'Ivoire"
replace TFPposition= 12 if country=="Dominican Rep."
replace TFPposition= 10 if country=="Ecuador"
replace TFPposition= 8 if country=="Egypt"
replace TFPposition= 3 if country=="El Salvador"
replace TFPposition= 10 if country=="Ethiopia"
replace TFPposition= 2 if country=="Ghana"
replace TFPposition= 9 if country=="Guyana"
replace TFPposition= 2 if country=="Haiti"
replace TFPposition= 7 if country=="Honduras"
replace TFPposition= 3 if country=="Iceland"
replace TFPposition= 9 if country=="India"
replace TFPposition= 9 if country=="Indonesia"
replace TFPposition= 2 if country=="Kenya"
replace TFPposition= 6 if country=="South Korea"
replace TFPposition= 12 if country=="Turkey"
replace TFPposition= 2 if country=="Madagascar"
replace TFPposition= 2 if country=="Malawi"
replace TFPposition= 12 if country=="Mali"
replace TFPposition= 5 if country=="Morocco"
replace TFPposition= 2 if country=="Nicaragua"
replace TFPposition= 2 if country=="Nigeria"
replace TFPposition= 12 if country=="Pakistan"
replace TFPposition= 1 if country=="Panama"
replace TFPposition= 12 if country=="Philippines"
replace TFPposition= 8 if country=="Rwanda"
replace TFPposition= 12 if country=="Senegal"
replace TFPposition= 6 if country=="Sierra Leone"
replace TFPposition= 10 if country=="Thailand"
replace TFPposition= 7 if country=="Uganda"
replace TFPposition= 5 if country=="Zambia"
replace TFPposition= 12 if country=="Zimbabwe"
replace TFPposition=9 if country=="Tunisia"

** Figure S1c
twoway (scatter TFPgrowth StateHist if stage1start==1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(TFPposition) mlabgap(tiny)) (lfit TFPgrowth StateHist if stage1start==1), ytitle(Productivity Growth Rate) xtitle(State Authority (StateHist)) legend(off) scheme(s1mono)

replace TFPposition= 5 if country=="Egypt"
replace TFPposition= 3 if country=="Zimbabwe"
replace TFPposition= 6 if country=="Sri Lanka"
replace TFPposition= 7 if country=="Cameroon"
replace TFPposition= 3 if country=="Mali"
replace TFPposition=3 if country=="Ethiopia"
replace TFPposition=3 if country=="Kenya"
replace TFPposition=9 if country=="Tanzania"
replace TFPposition=10 if country=="Ghana"
replace TFPposition=3 if country=="Bangladesh"
replace TFPposition=3 if country=="China"
replace TFPposition=12 if country=="Indonesia"
replace TFPposition=12 if country=="Uganda"
replace TFPposition=3 if country=="Morocco"
replace TFPposition=6 if country=="Rwanda"
replace TFPposition=3 if country=="Senegal"
replace TFPposition=9 if country=="Madagascar"
replace TFPposition=3 if country=="Philippines"
replace TFPposition=3 if country=="Zambia"
replace TFPposition=9 if country=="Sierra Leone"
replace TFPposition=3 if country=="Malawi"
replace TFPposition=3 if country=="Kenya"
replace TFPposition=3 if country=="Thailand"

** Figure S1a
twoway (scatter TFPgrowth75 stage1checks if stage1include75==1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(TFPposition) mlabgap(tiny)) (lfit TFPgrowth75 stage1checks if stage1include75==1), ytitle(Productivity Growth Rate) xtitle(Constraints on Rulers (Checks)) legend(off) scheme(s1mono) xlabel(0(.5)2)

replace stage3TFPposition=3 if country=="United States"
replace stage3TFPposition=3 if country=="Australia"
replace stage3TFPposition=3 if country=="Sweden"
replace stage3TFPposition=9 if country=="Italy"
replace stage3TFPposition=9 if country=="Netherlands"
replace stage3TFPposition=3 if country=="Japan"
replace stage3TFPposition=3 if country=="France"
replace stage3TFPposition=3 if country=="Canada"
replace stage3TFPposition=12 if country=="Singapore"
replace stage3TFPposition=4 if country=="Finland"
replace stage3TFPposition=12 if country=="Iceland"
replace stage3TFPposition=5 if country=="Denmark"
replace stage3TFPposition=1 if country=="Austria"

** Figure S1d
twoway (scatter stage3TFPgrowth StateHist if stage3include==1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(stage3TFPposition) mlabgap(tiny)) (lfit stage3TFPgrowth StateHist if stage3include==1), ytitle(Productivity Growth Rate) xtitle(State Authority (StateHist)) legend(off) scheme(s1mono)

replace stage3TFPposition=9 if country=="United Kingdom"
replace stage3TFPposition=9 if country=="Austria"
replace stage3TFPposition=9 if country=="Belgium"
replace stage3TFPposition=9 if country=="Switzerland"
replace stage3TFPposition=12 if country=="United States"
replace stage3TFPposition=12 if country=="Australia"
replace stage3TFPposition=9 if country=="Japan"
replace stage3TFPposition=3 if country=="Netherlands"
replace stage3TFPposition=9 if country=="Denmark"
replace stage3TFPposition=9 if country=="France"

** Figure S1b
twoway (scatter stage3TFPgrowth75 stage3checks if stage3include75==1 & stage3checks>1, mcolor(black) msize(vsmall) mlabel(country) mlabsize(small) mlabcolor(black) mlabv(stage3TFPposition) mlabgap(tiny)) (lfit stage3TFPgrowth75 stage3checks if stage3include75==1 & stage3checks>1), ytitle(Productivity Growth Rate) xtitle(Constraints on Rulers (Checks)) legend(off) scheme(s1mono)



