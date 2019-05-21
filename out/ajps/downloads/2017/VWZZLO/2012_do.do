/*
Citation: Djupe, Paul A., Jacob R. Neiheisel, and Anand E. Sokhey. Forthcoming. “Reconsidering the Role of Politics in Leaving Religion: The Importance of Affiliation.” American Journal of Political Science.
Do: 2012 Panel Study (Author data).
Bill of Lading: This file draws upon raw relevant data to recode, label (select variables), and analyze the data, and produces select data displays.
It includes code for Table 1, Table 2, Figure 1, Figure A1, Figure A2, Figure A9, Figure A10, and Figure A11. (Figures/Tables beginning with "A" are in the SI).
"q" variables are from wave 1 and "w" variables are from wave 2 (post election).	
*/

*Located directory and use the data file
cd "{directory of 2012_merged.dta}"
use 2012_merged.dta

/*INDEPENDENT VARIABLES*/
*differences with church - collapsed so that very diff/different=1, very sim/similar=0.
rename (v466 v467 v468 v469 w89_5 w89_6 w89_7)(wrd1 wrd2 wrd3 wrd4 wrd5 wrd6 wrd7)
recode wrd1 wrd2 wrd3 wrd4 wrd5 wrd6 wrd7 (3 4=0)(1 2=1), gen(wrd1c wrd2c wrd3c wrd4c wrd5c wrd6c wrd7c)

*Differences with the Church Scale
alpha wrd1 wrd2 wrd3 wrd4 wrd5 wrd6 wrd7, gen(wrdt1)
gen wrdt1c=(wrdt1-1)/3

*Partisanship, 7 point scale
gen pid7=q7-1
la def pid7 0"SD" 1"D" 2"Lean D" 3"Ind" 4"Lean R" 5"R" 6"SR"
la val pid7 pid7

*Partisan difference with church
gen q23_26=(q23_2/100)*6 // equivalent of a six point scale
gen pid7dcong=abs(pid7-q23_26) // higher is greater perceived difference

*Attendance, wave 1
gen attendw1=q52

*Political Interest, wave 1
gen polint=(6-q2) // 5=extremely interested, 1=Not interested at all. 

*Church discussant, wave 1
*(There were two versions of the network battery.)
egen net_churchc=anymatch(q121_6 q122_6 q123_6 q124_6 q741_6 q742_6 q743_6 q744_6), values(1)

*Feelings twd Christian Fundamentalists, wave 2
gen cfund=w69_5
gen cfund1=w69_5/100 // on 0-1 scale

*Ideology
gen ideology=q8 //1=very con, 5=very lib

*Female
gen female=q83-1 // 0=male, 1=female

*Income
gen income=q48

*Education
gen education=q54

*Age
gen age=2012-q44_1

*Religious Tradition Variables
**reltrad - 1=mainline, 2=evangelical, 3=catholic, 4=black protestant, 5=Jewish, 6=Muslim, 7=American Christian (LDS and JWs), 
*8=Other, Non Christian, 9=Nothing institutional (religious nones), 10=Atheist/Agnostic

*African-americans Protestants
gen reltrad=4 if q49==1 & (q50==1 | q50==3)

*mainliners are non-born again protestants or other christians.
replace reltrad=1 if q49>1 & (q50==1 | q50==3) & q51==2

*evangelicals, therefore, are born again prots or OCs (and not black).
replace reltrad=2 if q49>1 & (q50==1 | q50==3) & q51==1

*Catholics, Jews,  Muslims, Nones, and Atheists
replace reltrad=3 if q50==2
replace reltrad=5 if q50==4
replace reltrad=6 if q50==5
replace reltrad=9 if q50==6
replace reltrad=10 if q50==7


*Now sorting responses for "other"
*First for Blacks
replace reltrad=4 if q50_text=="APOSTOLIC" & q49==1
replace reltrad=4 if q50_text=="BAPTIST" & q49==1
replace reltrad=4 if q50_text=="Baptist" & q49==1
replace reltrad=4 if q50_text=="Christian" & q49==1
replace reltrad=7 if q50_text=="Jehovah' Witness" & q49==1
replace reltrad=4 if q50_text=="baptis" & q49==1
replace reltrad=4 if q50_text=="baptist" & q49==1
replace reltrad=4 if q50_text=="christian" & q49==1
replace reltrad=4 if q50_text=="christianity" & q49==1
replace reltrad=4 if q50_text=="holiness" & q49==1
replace reltrad=9 if q50_text=="no up for discussion" & q49==1
replace reltrad=4 if q50_text=="nondenominational" & q49==1
replace reltrad=4 if q50_text=="some off type of christian" & q49==1


*now for non-Blacks 
replace reltrad=9 if q50_text=="AMERICAN" & q49>1
replace reltrad=2 if q50_text=="APOSTOLIC" & q49>1
replace reltrad=8 if q50_text=="Anamist" & q49>1
replace reltrad=2 if q50_text=="BAPTIST" & q49>1
replace reltrad=8 if q50_text=="Baha'i" & q49>1
replace reltrad=2 if q50_text=="Baptist" & q49>1
replace reltrad=2 if q50_text=="Baptist/Christian" & q49>1
replace reltrad=8 if q50_text=="Buddhist" & q49>1
replace reltrad=2 if q50_text=="Christian" & q49>1
replace reltrad=2 if q50_text=="Christian/Pentecostal" & q49>1
replace reltrad=9 if q50_text=="Deist" & q49>1
replace reltrad=1 if q50_text=="Episcopalian" & q49>1
replace reltrad=9 if q50_text=="Follower of Jesus" & q49>1
replace reltrad=8 if q50_text=="HINDU" & q49>1
replace reltrad=8 if q50_text=="Hindu" & q49>1
replace reltrad=10 if q50_text=="Humanist" & q49>1
replace reltrad=9 if q50_text=="believe in the faith not the institut" & q49>1
replace reltrad=9 if q50_text=="Independent" & q49>1
replace reltrad=6 if q50_text=="Islamism" & q49>1
replace reltrad=7 if q50_text=="JW" & q49>1
replace reltrad=7 if q50_text=="Jehovah' Witness" & q49>1
replace reltrad=7 if q50_text=="Jehovah's Witness" & q49>1
replace reltrad=5 if q50_text=="Jewish/Catholic" & q49>1
replace reltrad=9 if q50_text=="Just Christian" & q49>1
replace reltrad=7 if q50_text=="LDS" & q49>1
replace reltrad=7 if q50_text=="LDS (mormon)" & q49>1
replace reltrad=1 if q50_text=="Luthern" & q49>1
replace reltrad=2 if q50_text=="Mennanite" & q49>1
replace reltrad=1 if q50_text=="Methodist" & q49>1
replace reltrad=7 if q50_text=="Mormon" & q49>1
replace reltrad=8 if q50_text=="Native Am. traditions" & q49>1
replace reltrad=2 if q50_text=="Non denominational" & q49>1
replace reltrad=2 if q50_text=="Nondenominational" & q49>1
replace reltrad=8 if q50_text=="Pagan" & q49>1
replace reltrad=8 if q50_text=="Pastafarian" & q49>1
replace reltrad=2 if q50_text=="Penacastal" & q49>1
replace reltrad=2 if q50_text=="Pentecostal" & q49>1
replace reltrad=1 if q50_text=="Presbytarian" & q49>1
replace reltrad=8 if q50_text=="Religious Science" & q49>1
replace reltrad=9 if q50_text=="Saved" & q49>1
replace reltrad=9 if q50_text=="Spiritual" & q49>1
replace reltrad=9 if q50_text=="Spiritual not religious" & q49>1
replace reltrad=9 if q50_text=="Sprital" & q49>1
replace reltrad=8 if q50_text=="Taoist" & q49>1
replace reltrad=7 if q50_text=="Testigo de Jehova" & q49>1
replace reltrad=1 if q50_text=="UNITARIAN-UNIVERSALIST" & q49>1
replace reltrad=1 if q50_text=="Unitarian Universalist" & q49>1
replace reltrad=8 if q50_text=="Wicca" & q49>1
replace reltrad=8 if q50_text=="Wiccan" & q49>1
replace reltrad=2 if q50_text=="apolstolic" & q49>1
replace reltrad=2 if q50_text=="babtist" & q49>1
replace reltrad=2 if q50_text=="bapist" & q49>1
replace reltrad=2 if q50_text=="bapstist" & q49>1
replace reltrad=2 if q50_text=="baptis" & q49>1
replace reltrad=2 if q50_text=="baptist" & q49>1
replace reltrad=8 if q50_text=="bhuddist" & q49>1
replace reltrad=8 if q50_text=="buddha" & q49>1
replace reltrad=8 if q50_text=="buddhist" & q49>1
replace reltrad=9 if q50_text=="christian" & q49>1
replace reltrad=9 if q50_text=="christian identity" & q49>1
replace reltrad=9 if q50_text=="christianity" & q49>1
replace reltrad=1 if q50_text=="episcopailion" & q49>1
replace reltrad=2 if q50_text=="fundamental christian" & q49>1
replace reltrad=8 if q50_text=="hindu" & q49>1
replace reltrad=2 if q50_text=="holiness" & q49>1
replace reltrad=2 if q50_text=="indenpent baptist" & q49>1
replace reltrad=7 if q50_text=="mormon" & q49>1
replace reltrad=9 if q50_text=="new age" & q49>1
replace reltrad=9 if q50_text=="no up for discussion" & q49>1
replace reltrad=2 if q50_text=="nondenominational" & q49>1
replace reltrad=2 if q50_text=="nondenominational Bible believer" & q49>1
replace reltrad=9 if q50_text=="none" & q49>1
replace reltrad=2 if q50_text=="penecostal" & q49>1
replace reltrad=2 if q50_text=="pentecostal/nondenomination" & q49>1
replace reltrad=8 if q50_text=="sikh" & q49>1
replace reltrad=2 if q50_text=="some off type of christian" & q49>1
replace reltrad=9 if q50_text=="spiritual" & q49>1
replace reltrad=9 if q50_text=="spiritual, not religious" & q49>1
replace reltrad=9 if q50_text=="spiritualist" & q49>1
replace reltrad=9 if q50_text=="spirituality" & q49>1

la def rt 1"Mainline" 2"Evangelical" 3"Catholic" 4"Black Prot." 5"Jewish" 6"Muslim" 7"Amer. Christian" 8"Non-Christian" 9"Rel. Nones" 10"Atheist", replace
la val reltrad rt

*Now making dummies.
**reltrad - 1=mainline, 2=evangelical, 3=catholic, 4=black protestant, 5=Jewish, 6=Muslim, 7=American Christian (LDS and JWs), 
*8=Other, Non Christian, 9=Nothing institutional (religious nones), 10=Atheist/Agnostic
tab reltrad,gen(rt_)
rename rt_1 rt_mp
rename rt_2 rt_ev
rename rt_3 rt_rc
rename rt_4 rt_bp
rename rt_5 rt_j
rename rt_6 rt_m
rename rt_7 rt_ac
rename rt_8 rt_nc
rename rt_9 rt_ni
rename rt_10 rt_aa
recode reltrad (5/10=1)(else=0), ge(rt_oth)


/*DEPENDENT VARIABLES*/ 
*Apostasy, not attending the same church as 6 months ago
recode w88 (2=1)(1=0)(3=.a),gen(apostasy)

*Attendance, wave 2
gen attendw2=w52

la def att 1"Never" 2"<1x Month" 3"1x Month" 4"2-3x a Month" 5"1x Week" 6"2-3x Week" 7"Daily"
la val attendw1 attendw2 att


/*MODELS AND DATA DISPLAYS*/
*Table 1 – The Prevalence of Reported Differences from Other Church Members
sum wrd1c wrd2c wrd3c wrd4c wrd5c wrd7c wrd6c

*Table 2 – Predicting Worship Attendance and Disaffiliation by Perceived (Partisan) Difference with the Congregation (2012)
ologit attendw2 c.attendw1##c.wrdt1c polint net_churchc c.ideology##c.cfund1 female income education age rt_mp rt_rc rt_bp rt_oth if w88==1, vsquish
logit apostasy c.pid7dcong##c.attendw1 polint net_churchc c.ideology##c.cfund1 female income education age rt_mp rt_rc rt_bp rt_oth, vsquish
*note: use "estat classification" after the logit call to obtain % correctly predicted 

*Figure 1 – Predicted Levels of Disaffiliation given Feelings of Differences with the Congregation, across Wave 1 Attendance
*(Estimates from Table 2—CIs for a 90% test presented).
logit apostasy c.pid7dcong##c.attendw1 polint net_churchc c.ideology##c.cfund1 female income education age rt_mp rt_rc rt_bp rt_oth, vsquish
margins, at(attendw1=(1(1)7) pid7dcong=(0 4)) l(76)
marginsplot, graphregion(color(white)) recastci(rspike) ciopt(lc(gs10)) ytitle("Disaffiliation Rate") xtitle("Attendance, Wave 1", bm(medium)) ///
		legend(region(color(white)) order(3 "Very similar" 4 "Very different from congregants")) plot1op(ms(O) mc(black) lc(black)) ///
		plot2op(ms(Sh) mc(black) lc(black)) title("") xlabels(1(1)7,val)


/*Figure A1 – How the Interaction of Differences with the Congregation Interact with Wave 1 Church Attendance to Shape 
Wave 2 Attendance (panels run from the probability of never attending in the upper left to Daily in the bottom left); 
those experiencing many differences are more likely to reduce their attendance in wave 2 if they attended at low rates 
in wave 1 (Estimates from Table 2—90% CIs)*/
ologit attendw2 c.attendw1##c.wrdt1c polint net_churchc c.ideology##c.cfund1 female income education age rt_mp rt_rc rt_bp rt_oth if w88==1, vsquish
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76) predict(outcome(2)) 
marginsplot, graphregion(color(white)) xlabels(1(1)7, val labs(tiny)) plot1op(ms(O) mc(black) lc(black)) xtitle("Attendance, Wave 1") ///
	plot2op(ms(Sh) mc(black) lc(black)) ciopt(lc(gs10)) title("Attend: < Once a Month") name(o2, replace) ytitle("Predicted Probability") ///
	legend(order(3 "Very Similar" 4 "Very Different") region(color(white)))
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76) predict(outcome(3)) 
marginsplot, graphregion(color(white)) xlabels(1(1)7, val labs(tiny)) plot1op(ms(O) mc(black) lc(black)) xtitle("Attendance, Wave 1") ///
	plot2op(ms(Sh) mc(black) lc(black)) ciopt(lc(gs10)) title("Attend: Once a Month") name(o3, replace) ytitle("Predicted Probability")
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76) predict(outcome(4)) 
marginsplot, graphregion(color(white)) xlabels(1(1)7, val labs(tiny)) plot1op(ms(O) mc(black) lc(black)) xtitle("Attendance, Wave 1") ///
	plot2op(ms(Sh) mc(black) lc(black)) ciopt(lc(gs10)) title("Attend: 2-3x Month") name(o4, replace) ytitle("Predicted Probability")
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76) predict(outcome(5)) 
marginsplot, graphregion(color(white)) xlabels(1(1)7, val labs(tiny)) plot1op(ms(O) mc(black) lc(black)) xtitle("Attendance, Wave 1") ///
	plot2op(ms(Sh) mc(black) lc(black)) ciopt(lc(gs10)) title("Attend: Once a Week") name(o5, replace) ytitle("Predicted Probability")
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76) predict(outcome(6)) 
marginsplot, graphregion(color(white)) xlabels(1(1)7, val labs(tiny)) plot1op(ms(O) mc(black) lc(black)) xtitle("Attendance, Wave 1") ///
	plot2op(ms(Sh) mc(black) lc(black)) ciopt(lc(gs10)) title("Attend: 2-3x a Week") name(o6, replace) ytitle("Predicted Probability")
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76) predict(outcome(7)) 
marginsplot, graphregion(color(white)) xlabels(1(1)7, val labs(tiny)) plot1op(ms(O) mc(black) lc(black)) xtitle("Attendance, Wave 1") ///
	plot2op(ms(Sh) mc(black) lc(black)) ciopt(lc(gs10)) title("Attend: Daily") name(o7, replace) ytitle("Predicted Probability")

*you may need to install <grc1leg> which just displays one legend for a panel of graphs 
*net install grc1leg.pkg
grc1leg o2 o3 o4 o5 o6 o7, leg(o2)

/*Figure A2 – Feelings Toward Christian Fundamentalists Interact with Ideology to Shape Wave 2 Attendance Across Wave 1 
Attendance Once the Congregational Differences Measure is Excluded from the Model (Marginal Effects, 2012 Data—90% CIs)*/
reg attendw2 polint c.cfund1##c.ideology##c.attendw1 female income education age rt_mp rt_rc rt_bp rt_oth if w88==1, vsquish
margins, dydx(cfund1) at(attendw1=(1(1)7) ideology=(1 5)) l(90)
marginsplot, graphregion(color(white)) recastci(rspike) ciopt(lc(gs10)) yline(0) ytitle("Marginal Effect of Fundamentalist""Opposition on Attendance, Wave 2") xtitle("Attendance, Wave 1", bm(medium)) ///
		legend(region(color(white)) order(3 "Strong Liberals" 4 "Strong Conservatives")) plot1op(ms(O) mc(black) lc(black)) ///
		plot2op(ms(Sh) mc(black) lc(black)) title("") xlabels(1(1)7,val)

/*Figure A9 – Comparisons of Perceived Differences by Partisanship (2012 data)
Panel A. Perceived Partisan Differences with the Congregation*/
reg pid7dcong c.pid7##c.pid7
margins, at(pid7=(0(1)6)) l(90)
marginsplot, graphregion(color(white)) recastci(rspike) ciopt(lc(black)) plotop(mc(black) lc(black)) xtitle("Partisanship") ///
		ytitle("Partisan Difference with the Congregation") title("") ///
		addplot(scatter pid7dcong pid7, ms(Oh) below jitter(10) mc(gs10) xscale(range(-.3 6.3))) legend(off)

*Panel B. Perceived Index Differences with the Congregation
reg wrdt1c c.pid7##c.pid7
margins, at(pid7=(0(1)6)) l(90)
marginsplot, graphregion(color(white)) recastci(rspike) ciopt(lc(gs10)) plotop(mc(black) msi(medlarge) lc(black)) xtitle("Partisanship") ///
		ytitle("Perceived Difference (index) with the Congregation") title("") addplot(scatter wrdt1c pid7, ms(Oh) below jitter(10) mc(gs10)) legend(off)

*Figure A10 – Comparing Worship Attendance by Ideology and Feelings toward Christian Fundamentalists
recode 	w69_5 (0/30=1)(31/100=0), gen(w69_5lo)
reg attendw1 i.w69_5lo##i.ideology female income education age rt_mp rt_rc rt_bp rt_oth
	margins, at(ideology=(1(1)5) w69_5lo=(0 1)) l(76)
	marginsplot, graphregion(color(white)) recastci(rspike) ciopt(lc(gs10)) plot1op(mc(black) lc(black) ms(Sh)) plot2op(mc(black) lc(black) ms(O)) ///
	xtitle("Ideology") ytitle("Worship Attendance") title("") legend(region(color(white)) order(3 "High FT" 4 "Low FT toward Christian Fundamentalists")) ///
	xlabels(1 "Very Conservative" 2 "Con" 3 "Moderate" 4 "Lib" 5 "Very Liberal") xscale(range(.75 5.25))

*Figure A11 – The Probability of Having a Church Member Discussion Partner as a Function of Congregational Differences and Wave 1 Attendance
logit net_churchc c.attendw1##c.wrdt1c polint c.cfund##c.pid7 female income education age rt_mp rt_rc rt_bp rt_oth if w88==1
margins, at(attendw1=(1(1)7) wrdt1c=(0 1)) l(76)
marginsplot, graphregion(color(white)) recastci(rspike) ciopt(lc(gs10)) ytitle("Prob of Church Member Discussant") xtitle("Attendance, Wave 1", bm(medium)) ///
		legend(region(color(white)) order(3 "Very similar" 4 "Very different from congregants")) plot1op(ms(O) mc(black) lc(black)) ///
		plot2op(ms(Sh) mc(black) lc(black)) title("")
