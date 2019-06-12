/*
Citation: Djupe, Paul A., Jacob R. Neiheisel, and Anand E. Sokhey. Forthcoming. “Reconsidering the Role of Politics in Leaving Religion: The Importance of Affiliation.” American Journal of Political Science.
Do: ANES Cumulative File through 2012.
Bill of Lading: This file draws upon raw relevant data to recode, label (select variables), and analyze the data, and produces select data displays.
It includes code for Figures A6-A8 and Tables A8-A9, all of which are in the SI.
*/

*Located directory and use the data file
cd "{directory of ANES_cumulative.dta}"
use ANES_cumulative.dta

/*INDEPENDENT VARIABLES*/

gen white=1 if VCF0106==1
replace white=0 if white==.

gen ChurchAttend=1 if VCF0130==5
replace ChurchAttend=2 if VCF0130==4
replace ChurchAttend=3 if VCF0130==3
replace ChurchAttend=4 if VCF0130==2
replace ChurchAttend=5 if VCF0130==1
replace ChurchAttend=1 if VCF0130==0
replace ChurchAttend=1 if VCF0130==7

gen male=1 if VCF0104==1
replace male=0 if VCF0104==2

gen age=VCF0101
replace age=. if age==0 

gen SomeCollege=1 if VCF0110==3
replace SomeCollege=0 if VCF0110<3
replace SomeCollege=0 if VCF0110==4
replace SomeCollege=. if VCF0110==0

gen CollegePlus=1 if VCF0110==4
replace CollegePlus=0 if VCF0110<4
replace CollegePlus=. if VCF0110==0

gen union=1 if VCF0127==1
replace union=0 if VCF0127==2
replace union=. if VCF0127==0

gen married=1 if VCF0147==1
replace married=0 if VCF0147>1
replace married=. if VCF0147>7

gen divorced=1 if VCF0147==3
replace divorced=0 if divorced==.
replace divorced=. if VCF0147>7

gen separated=1 if VCF0147==4
replace separated=0 if separated==.
replace separated=. if VCF0147>7

gen widowed=1 if VCF0147==5
replace widowed=0 if widowed==.
replace widowed=. if VCF0147>7

gen partner=1 if VCF0147==7
replace partner=0 if partner==.
replace partner=. if VCF0147>7

gen NorthCentral=1 if VCF0112==2
replace NorthCentral=0 if NorthCentral==.

gen South=1 if VCF0112==3
replace South=0 if South==.

gen West=1 if VCF0112==4
replace West=0 if West==.

gen children=1 if VCF0138>0
replace children=0 if VCF0138==0
replace children=. if VCF0138==9

gen income=VCF0114
replace income=. if VCF0114==0

gen PartyID=VCF0301
replace PartyID=. if VCF0301==0
la def pid 1"SD" 2"D" 3"Lean D" 4"Ind" 5"Lean R" 6"R" 7"SR"
la val PartyID pid

gen ideology=VCF0803
replace ideology=. if ideology==0
replace ideology=. if ideology==9

gen Evangelical=1 if VCF0129==140
replace Evangelical=1 if VCF0129==101
replace Evangelical=1 if VCF0129==123
replace Evangelical=1 if VCF0129==138
replace Evangelical=1 if VCF0129==102
replace Evangelical=1 if VCF0129==139
replace Evangelical=1 if VCF0129==149
replace Evangelical=1 if VCF0129==122
replace Evangelical=1 if VCF0129==136
replace Evangelical=1 if VCF0129==112
replace Evangelical=1 if VCF0129==141
replace Evangelical=1 if VCF0129==114
replace Evangelical=1 if VCF0129==132
replace Evangelical=1 if VCF0129==127
replace Evangelical=1 if VCF0129==131
replace Evangelical=1 if VCF0129==134
replace Evangelical=1 if VCF0129==133
replace Evangelical=1 if VCF0129==135
replace Evangelical=1 if VCF0129==126
replace Evangelical=1 if VCF0129==130
replace Evangelical=1 if VCF0129==137
replace Evangelical=1 if VCF0152==139
replace Evangelical=1 if VCF0152==100
replace Evangelical=1 if VCF0152==102
replace Evangelical=1 if VCF0152==109
replace Evangelical=1 if VCF0152==120
replace Evangelical=1 if VCF0152==121
replace Evangelical=1 if VCF0152==122
replace Evangelical=1 if VCF0152==123
replace Evangelical=1 if VCF0152==124
replace Evangelical=1 if VCF0152==125
replace Evangelical=1 if VCF0152==126
replace Evangelical=1 if VCF0152==127
replace Evangelical=1 if VCF0152==128
replace Evangelical=1 if VCF0152==138
replace Evangelical=1 if VCF0152==133
replace Evangelical=1 if VCF0152==134
replace Evangelical=1 if VCF0152==135
replace Evangelical=1 if VCF0152==140
replace Evangelical=1 if VCF0152==147
replace Evangelical=1 if VCF0152==148
replace Evangelical=1 if VCF0152==149
replace Evangelical=1 if VCF0152==160
replace Evangelical=1 if VCF0152==161
replace Evangelical=1 if VCF0152==162
replace Evangelical=1 if VCF0152==163
replace Evangelical=1 if VCF0152==164
replace Evangelical=1 if VCF0152==155
replace Evangelical=1 if VCF0152==166
replace Evangelical=1 if VCF0152==167
replace Evangelical=1 if VCF0152==168
replace Evangelical=1 if VCF0152==170
replace Evangelical=1 if VCF0152==180
replace Evangelical=1 if VCF0152==181
replace Evangelical=1 if VCF0152==182
replace Evangelical=1 if VCF0152==183
replace Evangelical=1 if VCF0152==184
replace Evangelical=1 if VCF0152==185
replace Evangelical=1 if VCF0152==186
replace Evangelical=1 if VCF0152==131
replace Evangelical=1 if VCF0152==132
replace Evangelical=1 if VCF0152==137
replace Evangelical=1 if VCF0152==199
replace Evangelical=1 if VCF0152==200
replace Evangelical=1 if VCF0152==201
replace Evangelical=1 if VCF0152==219
replace Evangelical=1 if VCF0152==221
replace Evangelical=1 if VCF0152==222
replace Evangelical=1 if VCF0152==223
replace Evangelical=1 if VCF0152==224
replace Evangelical=1 if VCF0152==141
replace Evangelical=1 if VCF0152==240
replace Evangelical=1 if VCF0152==250
replace Evangelical=1 if VCF0152==251
replace Evangelical=1 if VCF0152==252
replace Evangelical=1 if VCF0152==253
replace Evangelical=1 if VCF0152==254
replace Evangelical=1 if VCF0152==255
replace Evangelical=1 if VCF0152==256
replace Evangelical=1 if VCF0152==257
replace Evangelical=1 if VCF0152==258
replace Evangelical=1 if VCF0152==260
replace Evangelical=1 if VCF0152==261
replace Evangelical=1 if VCF0152==262
replace Evangelical=1 if VCF0152==263
replace Evangelical=1 if VCF0152==264
replace Evangelical=1 if VCF0152==265
replace Evangelical=1 if VCF0152==266
replace Evangelical=1 if VCF0152==267
replace Evangelical=1 if VCF0152==268
replace Evangelical=1 if VCF0152==269
replace Evangelical=1 if VCF0152==272
replace Evangelical=1 if VCF0152==276
replace Evangelical=1 if VCF0152==275
replace Evangelical=1 if VCF0152==280
replace Evangelical=1 if VCF0152==281
replace Evangelical=1 if VCF0152==114
replace Evangelical=1 if VCF0152==291
replace Evangelical=1 if VCF0152==292
replace Evangelical=1 if VCF0152==136
replace Evangelical=0 if Evangelical==.


/*DEPENDENT VARIABLES*/ 

*Feeling therm toward Christian Fundamentalists (1988-2012)
gen CFft=97-VCF0234 // higher is more opposition
replace CFft=. if VCF0234>97
gen CFftscaled=CFft/100

*Feeling therm toward Evangelical groups active in politics (1980-1988)
gen egapft=97-VCF9003 // higher is more opposition
replace egapft=. if VCF9003>97
gen egapftscaled=egapft/100


/*MODELS AND DATA DISPLAYS*/

*Figure A6 – CR’s Effect on Church Attendance Conditional on Partisanship (linear fit with 90% confidence intervals)
reg ChurchAttend c.CFftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004
margins, dydx(CFftscaled) at(PartyID=(1(1)7)) l(90)
marginsplot, ytitle("Marginal Effect of Affect toward Christian Fundamentalists") xtitle("Party Identification") legend(off) ///
		note("Source: ANES Time Series (1988-2012)") title("") yline(0, lp(dash)) graphregion(color(white))

*Figure A7 - CR’s Effect on Church Attendance Conditional on Partisanship (linear fit with 90% confidence intervals)
reg ChurchAttend c.egapftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004
margins, dydx(egapftscaled) at(PartyID=(1(1)7)) l(90)
marginsplot, ytitle("Marginal Effect of Affect toward Evangelical Groups") xtitle("Party Identification") legend(off) ///
		note("Source: ANES Time Series (1980-1988)") title("") yline(0, lp(dash)) graphregion(color(white))
		
*Figure A8 - CR’s Effect on Church Attendance Conditional on Partisanship (linear fit with 90% confidence intervals)
foreach x in 1988 1992 1994 1996 2000 2004 2008 2012 {
reg ChurchAttend c.CFftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South income ideology if VCF0004==`x'
margins, dydx(CFftscaled) at(PartyID=(1(1)7)) l(90)
marginsplot, graphregion(color(white)) xtitle("Party ID") yline(0, lp(dash)) ytitle("Marginal Effect") title(`x') name(me_`x', replace) legend(off) nodraw ///
	xlabel(1(1)7, val labs(vsmall))  ylabel(-3(.5)0, labs(vsmall)) 
}

graph combine me_1988 me_1992 me_1994 me_1996 me_2000 me_2004 me_2008 me_2012, ycommon graphregion(color(white)) col(3) note("Source: ANES Time Series (1988-2012)")

*Table A8 – The Conditional Effect of Opposition to Christian Fundamentalists by Partisanship on Church Attendance, 1988-2012
reg ChurchAttend c.CFftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004
reg ChurchAttend c.CFftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004 if Evangelical==1
ologit ChurchAttend c.CFftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004

*Table A9 – The Conditional Effect of Opposition to Evangelical Groups Active in Politics by Partisanship on Church Attendance, 1980-1988
reg ChurchAttend c.egapftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004
reg ChurchAttend c.egapftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004 if Evangelical==1
ologit ChurchAttend c.egapftscaled##c.PartyID age male SomeCollege CollegePlus married divorced separated widowed partner NorthCentral West South children income ideology i.VCF0004
