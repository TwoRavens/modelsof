* Nicolai Petrovsky
* nicolai.petrovsky@uky.edu


* This do-file generates all variables and obtains all results reported 
* in the British Journal of Political Science (2012) article 
* "Party Control, Party Competition and Public Service Performance"
* by George A. Boyne, Oliver James, Peter John, and Nicolai Petrovsky


* Stata version 9.2
* last modified September 7, 2012


* The first step you have to take is to download our data set from the 
* UK Data Archive.  Please go to 
* http://store.data-archive.ac.uk/store/
* and on the right-hand side, under "SEARCH PROJECTS", 
* search for "Petrovsky".  
* You will be taken to our data set.  

* Please download it (the filename is BoyneJamesJohnPetrovsky.dta) and 
* save it in the same directory as this do-file.  

* Then , please use Stata's command
* cd
* to change to that directory.

* Now you can run this do-file.


* How to find the result(s) you are interested in: 

* Since there is a lot of material in this do-file, you can find the results 
* for the items that most interest you in the following way: 
* After running this do-file, view the log-file (BJPS2012.smcl) and search within it for 
* "Page 653" if you'd like to see a result from page 653 in the article; same 
* for all other pages with results.  
* (For searchin within the log-file, click the search button on the top left-hand 
*  side of the Stata viewer.)

clear
clear mata
version 9.2
set more off
set memory 40m
set scheme s1mono

* Open a log and allow for replacement
log using BJPS2012.smcl, replace

* Open data
use BoyneJamesJohnPetrovsky
save workfile, replace

gen centralgrants = ((outgrants + ingrants + rsg + ndr_receipts) / pop01x) * 1000
lab var centralgrants "Per capita sum of central grants"

gen torycouncil = 1 if polcontrol == 1
replace torycouncil = 0 if polcontrol ~= 1 & polcontrol ~= .
gen labourcouncil = 1 if polcontrol == 2
replace labourcouncil = 0 if polcontrol ~= 2 & polcontrol ~= .
gen libdemcouncil = 1 if polcontrol == 3
replace libdemcouncil = 0 if polcontrol ~= 3 & polcontrol ~= .

gen toryonset = 1 if polcontrol == 1 & L1.polcontrol ~= 1 & L1.polcontrol ~= .
replace toryonset = 0 if (polcontrol == 1 & L1.polcontrol == 1) | /*
*/ (polcontrol ~= 1 & polcontrol ~= .)
gen labouronset = 1 if polcontrol == 2 & L1.polcontrol ~= 2 & L1.polcontrol ~= .
replace labouronset = 0 if (polcontrol == 2 & L1.polcontrol == 2) | /*
*/ (polcontrol ~= 2 & polcontrol ~= .)
gen libdemonset = 1 if polcontrol == 3 & L1.polcontrol ~= 3 & L1.polcontrol ~= .
replace libdemonset = 0 if (polcontrol == 3 & L1.polcontrol == 3) | /*
*/ (polcontrol ~= 3 & polcontrol ~= .)
gen noconset = 1 if polcontrol == 4 & L1.polcontrol ~= 4 & L1.polcontrol ~= .
replace noconset = 0 if (polcontrol == 4 & L1.polcontrol == 4) | /*
*/ (polcontrol ~= 4 & polcontrol ~= .)

sort year
by year: sum centralgrants
sort lacode year
save, replace

* Page 653: Table 1
xtabond sp_per L.torycouncil L.labourcouncil L.libdemcouncil q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Table1.txt, title(Model 1) /*
*/ ctitle((1)) bdec(3) tdec(2) 3aster nor2 replace

* Page 653: "Conservative control is associated with a 3.7 percentage point higher CSP, with the Labour and 
* Conservative control coefficients being statistically equal (p=0.55)."
test LD.torycouncil = LD.labourcouncil

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per L.torycouncil L.labourcouncil L.libdemcouncil q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per L.torycouncil L.labourcouncil L.libdemcouncil q1claimrate centralgrants y2005 y2006

gen party2tories = .
replace party2tories = 1 if toryonset == 1 & L.polcontrol < 4
replace party2tories = 0 if toryonset == 0 | L.polcontrol == 4

gen noc2tories = .
replace noc2tories = 1 if toryonset == 1 & L.polcontrol == 4
replace noc2tories = 0 if toryonset == 0 | L.polcontrol < 4

quietly xtabond sp_per L.torycouncil L.labourcouncil L.libdemcouncil q1claimrate centralgrants y2005 y2006, robust

* Page 660: Table A1
sum sp_per L.torycouncil L.labourcouncil L.libdemcouncil /*
*/ L.toryonset L.party2tories L.noc2tories q1claimrate centralgrants if e(sample)

gen lagtorycouncil = L.torycouncil
gen laglabourcouncil = L.labourcouncil
gen laglibdemcouncil = L.libdemcouncil
gen lagnoc = 1 if L.polcontrol == 4

* Page 660: Table A2
sum lagtorycouncil if lagtorycouncil == 1 & e(sample)
sum laglabourcouncil if laglabourcouncil == 1 & e(sample)
sum laglibdemcouncil if laglibdemcouncil == 1 & e(sample)
sum lagnoc if lagnoc == 1 & e(sample)

* Page 660: Table A3 
* and also: 
* Page 654: Footnote 56: "Each instance can be described in full: Plymouth went from 
* Conservative to Labour control in 2003 with CSP rising from 50 to 52. Oldham went 
* from No Overall Control in 2002 to Labour majority control in 2003 with CSP rising 
* from 65 to 72. Sheffield went from No Overall Control to Labour majority control in 
* 2003 with CSP rising from 65 to 73. Finally, Hartlepool went from No Overall Control 
* to Labour majority control in 2004 with its CSP of 87 falling to 82. This conclusion 
* holds when the local performance improvements are compared against the national rising 
* trend on the CSP, Plymouth and Hartlepool being worse and Oldham and Sheffield slightly 
* better.

dis "How many changes to Tory control (model 1 sample)?"

dis "Authorities that changed from Labour to Tory (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.toryonset == 1 & L2.polcontrol == 2 & e(sample)
dis "Authorities that changed from Lib Dem to Tory (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.toryonset == 1 & L2.polcontrol == 3 & e(sample)
dis "Authorities that changed from NOC to Tory (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.toryonset == 1 & L2.polcontrol == 4 & e(sample)

dis "How many changes to Labour control (model 1 sample)?"

dis "Authorities that changed from Tory to Labour (model 1 sample)"
list L2.year L2.polcontrol L2.sp_per lacode L1.year L1.polcontrol /*
*/ L1.sp_per year sp_per if L1.labouronset == 1 & L2.polcontrol == 1 & e(sample)
dis "Authorities that changed from Lib Dem to Labour (model 1 sample)"
list L2.year L2.polcontrol L2.sp_per lacode L1.year L1.polcontrol /*
*/ L1.sp_per year sp_per if L1.labouronset == 1 & L2.polcontrol == 3 & e(sample)
dis "Authorities that changed from NOC to Labour (model 1 sample)"
list L2.year L2.polcontrol L2.sp_per lacode L1.year L1.polcontrol /*
*/ L1.sp_per year sp_per if L1.labouronset == 1 & L2.polcontrol == 4 & e(sample)

* National trend on the CSP: 
dis "Year-on-year changes in CSP"
gen CSPchange = D1.sp_per
sort year
by year: sum CSPchange
sort lacode year
drop CSPchange

dis "Authorities that changed from Tory to Labour (data set)"
list L2.year L2.polcontrol L2.sp_per lacode L1.year L1.polcontrol /*
*/ L1.sp_per year sp_per if L1.labouronset == 1 & L2.polcontrol == 1
dis "Authorities that changed from Lib Dem to Labour (data set)"
list L2.year L2.polcontrol L2.sp_per lacode L1.year L1.polcontrol /*
*/ L1.sp_per year sp_per if L1.labouronset == 1 & L2.polcontrol == 3
dis "Authorities that changed from NOC to Labour (data set)"
list L2.year L2.polcontrol L2.sp_per lacode L1.year L1.polcontrol /*
*/ L1.sp_per year sp_per if L1.labouronset == 1 & L2.polcontrol == 4

dis "How many changes to Lib Dem control (model 1 sample)?"

dis "Authorities that changed from Tory to Lib Dem (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.libdemonset == 1 & L2.polcontrol == 1 & e(sample)
dis "Authorities that changed from Labour to Lib Dem (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.libdemonset == 1 & L2.polcontrol == 2 & e(sample)
dis "Authorities that changed from NOC to Lib Dem (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.libdemonset == 1 & L2.polcontrol == 4 & e(sample)

dis "How many changes to NOC (model 1 sample)?"

dis "Authorities that changed from Tory to NOC (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.noconset == 1 & L2.polcontrol == 1 & e(sample)
dis "Authorities that changed from Labour to NOC (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.noconset == 1 & L2.polcontrol == 2 & e(sample)
dis "Authorities that changed from Lib Dem to NOC (model 1 sample)"
list L2.year L2.polcontrol lacode L1.year L1.polcontrol if /*
*/ L1.noconset == 1 & L2.polcontrol == 3 & e(sample)

* Page 653: Footnote 54: "Our findings on the effects of the three parties on public service performance 
* remain substantively unchanged when previous experience governing the same local government is taken 
* into account."

* Generate dummies for experience in governing the local authority: 

gen toryexp = 0
replace toryexp = 1 if torycouncil == 1 & (L2.toryonset == 1 /*
*/ | L3.toryonset == 1 | L4.toryonset == 1 | L5.toryonset == 1 /*
*/ | L6.toryonset == 1 | L7.toryonset == 1 | L8.toryonset == 1 /*
*/ | L9.toryonset == 1 | L10.toryonset == 1)
lab var toryexp "Tories 2yrs. + in power or prev. in power"
tab torycouncil toryexp

gen labourexp = 0
replace labourexp = 1 if labourcouncil == 1 & (L2.labouronset == 1 /*
*/ | L3.labouronset == 1 | L4.labouronset == 1 | L5.labouronset == 1 /*
*/ | L6.labouronset == 1 | L7.labouronset == 1 | L8.labouronset == 1 /*
*/ | L9.labouronset == 1 | L10.labouronset == 1)
lab var labourexp "Labour 2yrs. + in power or prev. in power"
tab labourcouncil labourexp

gen libdemexp = 0
replace libdemexp = 1 if libdemcouncil == 1 & (L2.libdemonset == 1 /*
*/ | L3.libdemonset == 1 | L4.libdemonset == 1 | L5.libdemonset == 1 /*
*/ | L6.libdemonset == 1 | L7.libdemonset == 1 | L8.libdemonset == 1 /*
*/ | L9.libdemonset == 1 | L10.libdemonset == 1)
lab var libdemexp "Lib Dem 2yrs. + in power or prev. in power"
tab libdemcouncil libdemexp

* Rerun the specification in Table 1 (Page 653) with the dummies for experience 
* in governing the local authority added: 
xtabond sp_per L.torycouncil L.labourcouncil L.libdemcouncil /*
*/ L.toryexp L.labourexp L.libdemexp /*
*/ q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Footnote54_ModifiedTable1.txt, title(FN 54 Model 1) /*
*/ ctitle((FN54_M1)) bdec(3) tdec(2) 3aster nor2 replace

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per L.torycouncil L.labourcouncil L.libdemcouncil /*
*/ L.toryexp L.labourexp L.libdemexp /*
*/ q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per L.torycouncil L.labourcouncil L.libdemcouncil /*
*/ L.toryexp L.labourexp L.libdemexp /*
*/ q1claimrate centralgrants y2005 y2006

* Table 2: Testing hypothesis 2 (all changes in control)

gen party2noc = controlchange
replace party2noc = 0 if L.polcontrol == 4 | polcontrol < 4

gen noc2party = controlchange
replace noc2party = 0 if L.polcontrol < 4 | polcontrol == 4

gen party2party = controlchange
replace party2party = 0 if L.polcontrol == 4 | polcontrol == 4

gen xxxcheckvariable = party2noc + noc2party + party2party
sum xxxcheckvariable
tab xxxcheckvariable controlchange

gen l1party2noc = L.party2noc
gen l1noc2party = L.noc2party
gen l1party2party = L.party2party

* Page 654: Table 2
xtabond sp_per L.party2noc L.noc2party L.party2party q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Table2.txt, title(Model 2) /*
*/ ctitle((2)) bdec(3) tdec(2) 3aster nor2 replace

* How many are there in this estimation sample
tab l1party2noc if e(sample)
tab l1noc2party if e(sample)
tab l1party2party if e(sample)

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per L.party2noc L.noc2party L.party2party q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per L.party2noc L.noc2party L.party2party q1claimrate centralgrants y2005 y2006

* Page 655: Table 3
xtabond sp_per L.toryonset q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Table3.txt, title(Model 3) /*
*/ ctitle((3)) bdec(3) tdec(2) 3aster nor2 replace

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per L.toryonset q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per L.toryonset q1claimrate centralgrants y2005 y2006

* Page 653: Footnote 55: "These findings also hold when change to Conservative party control is disaggregated into 
* those observations where the change is from control by another party (four instances) and where the change is 
* from no overall control (thirteen instances)."

* How many changes from control by another party to Conservative party control? 
gen lagparty2tories = L.party2tories
tab lagparty2tories if e(sample)

* How many changes from no overall control to Conservative party control? 
gen lagnoc2tories = L.noc2tories
tab lagnoc2tories if e(sample)

xtabond sp_per L.party2tories L.noc2tories q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Footnote55_ModifiedTable3.txt, title(FN 55 Model 3) /*
*/ ctitle((FN55_M3)) bdec(3) tdec(2) 3aster nor2 replace

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per L.party2tories L.noc2tories q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per L.party2tories L.noc2tories q1claimrate centralgrants y2005 y2006

* Interactive models (Tables 4 and 5 and Figures 1 and 2)

gen ptoryincseats = .
replace ptoryincseats = (100 * (seatsheldbyinc/seats)) if polcontrol == 1
replace ptoryincseats = 0 if (polcontrol == 2 | polcontrol == 3 | /*
*/ polcontrol == 4)
gen torystrength = torycouncil * ptoryincseats
gen plabourincseats = .
replace plabourincseats = (100 * (seatsheldbyinc/seats)) if polcontrol == 2
replace plabourincseats = 0 if (polcontrol == 1 | polcontrol == 3 | /*
*/ polcontrol == 4)
gen labourstrength = labourcouncil * plabourincseats
gen plibdemincseats = .
replace plibdemincseats = (100 * (seatsheldbyinc/seats)) if polcontrol == 3
replace plibdemincseats = 0 if (polcontrol == 1 | polcontrol == 2 | /*
*/ polcontrol == 4)
gen libdemstrength = libdemcouncil * plibdemincseats
sum ptoryincseats, d
sum ptoryincseats if polcontrol == 1, d
sum ptoryincseats if polcontrol ~= 1, d
list lacode year if ptoryincseats <= 50 & polcontrol ==1
sum plabourincseats, d
sum plabourincseats if polcontrol == 2, d
sum plabourincseats if polcontrol ~= 2, d
list lacode year if plabourincseats <= 50 & polcontrol == 2
sum plibdemincseats, d
sum plibdemincseats if polcontrol == 3, d
sum plibdemincseats if polcontrol ~= 3, d
list lacode year if plibdemincseats <= 50 & polcontrol == 3
gen l1torycouncil = L.torycouncil
gen l1torystrength = L.torystrength
gen l1labourcouncil = L.labourcouncil
gen l1labourstrength = L.labourstrength
gen l1libdemcouncil = L.libdemcouncil
gen l1libdemstrength = L.libdemstrength
save, replace

* Page 656: Table 4
xtabond sp_per /*
*/ l1torycouncil l1torystrength /*
*/ l1labourcouncil l1labourstrength /*
*/ l1libdemcouncil l1libdemstrength /*
*/ q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Table4.txt, title(Model 4) /*
*/ ctitle((4)) bdec(3) tdec(2) 3aster nor2 replace

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per /*
*/ l1torycouncil l1torystrength /*
*/ l1labourcouncil l1labourstrength /*
*/ l1libdemcouncil l1libdemstrength /*
*/ q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per /*
*/ l1torycouncil l1torystrength /*
*/ l1labourcouncil l1labourstrength /*
*/ l1libdemcouncil l1libdemstrength /*
*/ q1claimrate centralgrants y2005 y2006

quietly xtabond sp_per /*
*/ l1torycouncil l1torystrength /*
*/ l1labourcouncil l1labourstrength /*
*/ l1libdemcouncil l1libdemstrength /*
*/ q1claimrate centralgrants y2005 y2006, robust

* Test impact of Tory control
test D1.l1torycouncil D1.l1torystrength

* Test impact of Labour control
test D1.l1labourcouncil D1.l1labourstrength

* Test impact of Lib Dem control
test D1.l1libdemcouncil D1.l1libdemstrength

* Page 657: Figure 1: Make Tory graph (first panel of figure)

quietly xtabond sp_per /*
*/ l1torycouncil l1torystrength /*
*/ l1labourcouncil l1labourstrength /*
*/ l1libdemcouncil l1libdemstrength /*
*/ q1claimrate centralgrants y2005 y2006, robust

#delimit ;

*     ****************************************************************  *;
*       Generate the values of Z for which you want to calculate the    *;
*       marginal effect (and standard errors) of X on Y.                *;
*     ****************************************************************  *;

generate MV=((_n-1)+51);

replace  MV=. if _n>36;

lab var MV " ";

*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b2=b[1,2];
scalar b3=b[1,3];

scalar varb2=V[2,2]; 
scalar varb3=V[3,3];

scalar covb2b3=V[2,3];

scalar list b2 b3 varb2 varb3 covb2b3;

*     ****************************************************************  *;
*       Calculate the impact of party control on sp_per for all         *;
*       MV values of the modifying variable % seats held by the party.  *;
*     ****************************************************************  *;

gen conb=b2+b3*MV if _n<36;

*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect of X on Y *;
*       for all MV values of the modifying variable Z.                  *;
*     ****************************************************************  *;

gen conse=sqrt(varb2+varb3*(MV^2)+2*covb2b3*MV) if _n<36; 

*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*       Specify the significance of the confidence interval.            *;
*     ****************************************************************  *;

gen a=1.645*conse;
 
gen upper=conb+a;
 
gen lower=conb-a;

*     ****************************************************************  *;
*       Graph the marginal effect of X on Y across the desired range of *;
*       the modifying variable Z.  Show the confidence interval.        *;
*     ****************************************************************  *;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(50 55 60 65 70 75 80 85, labsize(2.5)) 
             ylabel(-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12,   labsize(2.5))
             yscale(noline)
             xscale(noline)
             legend(off)
             yline(0, lcolor(black))   
             scheme(s2mono) graphregion(fcolor(white));
             
*     ****************************************************************  *;
*                 Figure can be saved in a variety of formats.          *;
*     ****************************************************************  *; 

translate @Graph BJPS2012_1Conservative.wmf, replace;     

#delimit cr;

* Page 657: Figure 1: Make Labour graph (second panel of figure)

drop MV conb conse a upper lower

quietly xtabond sp_per /*
*/ l1labourcouncil l1labourstrength /*
*/ l1torycouncil l1torystrength /*
*/ l1libdemcouncil l1libdemstrength /*
*/ q1claimrate centralgrants y2005 y2006, robust

#delimit ;

*     ****************************************************************  *;
*       Generate the values of Z for which you want to calculate the    *;
*       marginal effect (and standard errors) of X on Y.                *;
*     ****************************************************************  *;

generate MV=((_n-1)+51);

replace  MV=. if _n>36;

lab var MV " ";

*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b2=b[1,2];
scalar b3=b[1,3];

scalar varb2=V[2,2]; 
scalar varb3=V[3,3];

scalar covb2b3=V[2,3];

scalar list b2 b3 varb2 varb3 covb2b3;

*     ****************************************************************  *;
*       Calculate the impact of party control on sp_per for all         *;
*       MV values of the modifying variable % seats held by the party.  *;
*     ****************************************************************  *;

gen conb=b2+b3*MV if _n<36;

*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect of X on Y *;
*       for all MV values of the modifying variable Z.                  *;
*     ****************************************************************  *;

gen conse=sqrt(varb2+varb3*(MV^2)+2*covb2b3*MV) if _n<36; 

*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*       Specify the significance of the confidence interval.            *;
*     ****************************************************************  *;

gen a=1.645*conse;
 
gen upper=conb+a;
 
gen lower=conb-a;

*     ****************************************************************  *;
*       Graph the marginal effect of X on Y across the desired range of *;
*       the modifying variable Z.  Show the confidence interval.        *;
*     ****************************************************************  *;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(50 55 60 65 70 75 80 85, labsize(2.5)) 
             ylabel(-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12,   labsize(2.5))
             yscale(noline)
             xscale(noline)
             legend(off)
             yline(0, lcolor(black))   
             scheme(s2mono) graphregion(fcolor(white));
             
*     ****************************************************************  *;
*                 Figure can be saved in a variety of formats.          *;
*     ****************************************************************  *; 

translate @Graph BJPS2012_Figure1Labour.wmf, replace;     

#delimit cr;

* Page 657: Figure 1: Make Lib Dem graph (third panel of figure)

drop MV conb conse a upper lower

quietly xtabond sp_per /*
*/ l1libdemcouncil l1libdemstrength /*
*/ l1torycouncil l1torystrength /*
*/ l1labourcouncil l1labourstrength /*
*/ q1claimrate centralgrants y2005 y2006, robust

#delimit ;

*     ****************************************************************  *;
*       Generate the values of Z for which you want to calculate the    *;
*       marginal effect (and standard errors) of X on Y.                *;
*     ****************************************************************  *;

generate MV=((_n-1)+51);

replace  MV=. if _n>21;

lab var MV " ";

*     ****************************************************************  *;
*       Grab elements of the coefficient and variance-covariance matrix *;
*       that are required to calculate the marginal effect and standard *;
*       errors.                                                         *;
*     ****************************************************************  *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b2=b[1,2];
scalar b3=b[1,3];

scalar varb2=V[2,2]; 
scalar varb3=V[3,3];

scalar covb2b3=V[2,3];

scalar list b2 b3 varb2 varb3 covb2b3;

*     ****************************************************************  *;
*       Calculate the impact of party control on sp_per for all         *;
*       MV values of the modifying variable % seats held by the party.  *;
*     ****************************************************************  *;

gen conb=b2+b3*MV if _n<21;

*     ****************************************************************  *;
*       Calculate the standard errors for the marginal effect of X on Y *;
*       for all MV values of the modifying variable Z.                  *;
*     ****************************************************************  *;

gen conse=sqrt(varb2+varb3*(MV^2)+2*covb2b3*MV) if _n<21; 

*     ****************************************************************  *;
*       Generate upper and lower bounds of the confidence interval.     *;
*       Specify the significance of the confidence interval.            *;
*     ****************************************************************  *;

gen a=1.645*conse;
 
gen upper=conb+a;
 
gen lower=conb-a;

*     ****************************************************************  *;
*       Graph the marginal effect of X on Y across the desired range of *;
*       the modifying variable Z.  Show the confidence interval.        *;
*     ****************************************************************  *;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||   ,   
             xlabel(50 55 60 65 70, labsize(2.5)) 
             ylabel(-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12,   labsize(2.5))
             yscale(noline)
             xscale(noline)
             legend(off)
             yline(0, lcolor(black))   
             scheme(s2mono) graphregion(fcolor(white));
             
*     ****************************************************************  *;
*                 Figure can be saved in a variety of formats.          *;
*     ****************************************************************  *; 

translate @Graph BJPS2012_Figure1LibDem.wmf, replace;     

#delimit cr;

drop ptoryincseats
gen ptoryincseats = .
replace ptoryincseats = (100 * (seatsheldbyinc/seats)) if polcontrol == 1
replace ptoryincseats = 0 if (polcontrol == 2 | polcontrol == 3 | /*
*/ polcontrol == 4)

gen l1toryonset = L.toryonset

gen toryonsetseats = toryonset * ptoryincseats
gen l1toryonsetseats = L.toryonsetseats

gen toryonset1seats = party2tories * ptoryincseats
gen toryonset2seats = noc2tories * ptoryincseats
gen l1party2tories = L.party2tories
gen l1toryonset1seats = L.toryonset1seats
gen l1noc2tories = L.noc2tories
gen l1toryonset2seats = L.toryonset2seats
save, replace

sum l1toryonsetseats l1toryonset1seats l1toryonset2seats, d

* Page 658: Table 5
xtabond sp_per /*
*/ l1toryonset l1toryonsetseats /*
*/ q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Table5.txt, title(Model 5)  /*
*/ ctitle((5)) bdec(3) tdec(2) 3aster nor2 replace

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per /*
*/ l1toryonset l1toryonsetseats /*
*/ q1claimrate centralgrants y2005 y2006, fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per /*
*/ l1toryonset l1toryonsetseats /*
*/ q1claimrate centralgrants y2005 y2006

quietly xtabond sp_per /*
*/ l1toryonset l1toryonsetseats /*
*/ q1claimrate centralgrants y2005 y2006, robust

* Test impact of change to Tories
test D1.l1toryonset D1.l1toryonsetseats

* Page 659: Figure 2: Make graph w/ impact of change to Tories on CSP

quietly xtabond sp_per /*
*/ l1toryonset l1toryonsetseats /*
*/ q1claimrate centralgrants y2005 y2006, robust

#delimit ;

*     ****************************************************************   *;
*       Generate the values of Z for which you want to calculate the     *;
*       marginal effect (and standard errors) of X on Y.                 *;
*     ****************************************************************   *;

drop MV conb conse a upper lower;

generate MV=((_n-1)+51);

replace  MV=. if _n>21;

lab var MV " ";

*     ****************************************************************   *;
*       Grab elements of the coefficient and variance-covariance matrix  *;
*       that are required to calculate the marginal effect and standard  *;
*       errors.                                                          *;
*     ****************************************************************   *;

matrix b=e(b); 
matrix V=e(V);
 
scalar b2=b[1,2];
scalar b3=b[1,3];

scalar varb2=V[2,2]; 
scalar varb3=V[3,3];

scalar covb2b3=V[2,3];

scalar list b2 b3 varb2 varb3 covb2b3;

*     ****************************************************************   *;
*       Calculate the impact of change to Tory ctrl. on sp_per for all   *;
*       MV values of the modifying variable % seats held by the party.   *;
*     ****************************************************************   *;

gen conb=b2+b3*MV if _n<21;

*     ****************************************************************   *;
*       Calculate the standard errors for the marginal effect of X on Y  *;
*       for all MV values of the modifying variable Z.                   *;
*     ****************************************************************   *;

gen conse=sqrt(varb2+varb3*(MV^2)+2*covb2b3*MV) if _n<21; 

*     ****************************************************************   *;
*       Generate upper and lower bounds of the confidence interval.      *;
*       Specify the significance of the confidence interval.             *;
*     ****************************************************************   *;

gen a=1.645*conse;
 
gen upper=conb+a;
 
gen lower=conb-a;

*     ****************************************************************   *;
*       Graph the marginal effect of X on Y across the desired range of  *;
*       the modifying variable Z.  Show the confidence interval.         *;
*     ****************************************************************   *;

graph twoway line conb   MV, clwidth(medium) clcolor(blue) clcolor (black)
        ||   line upper  MV, clpattern(dash) clwidth(thin) clcolor (black)
        ||   line lower  MV, clpattern(dash) clwidth(thin) clcolor (black)
        ||   ,   
             xlabel(50 55 60 65 70, labsize(2.5)) 
             ylabel(-12 -10 -8 -6 -4 -2 0 2 4 6 8 10 12,   labsize (2.5))
             yscale(noline)
             xscale(noline)
             legend(off)
             yline(0, lcolor(black))   
             scheme(s2mono) graphregion(fcolor(white));
             
*     ****************************************************************   *;
*                 Figure can be saved in a variety of formats.           *;
*     ****************************************************************   *; 

translate @Graph BJPS2012_Figure2Change2Tory_CSP.wmf, replace;     

#delimit cr;

* Page 656: Footnote 57: "As in Table 3, the findings in Table 5 also hold when change to Conservative party 
* control is disaggregated into those observations where the change is from control by another party 
* (four instances) and where the change is from no overall control (thirteen instances)."

xtabond sp_per /*
*/ l1party2tories l1toryonset1seats l1noc2tories l1toryonset2seats /*
*/ q1claimrate centralgrants y2005 y2006, robust
outreg using BJPS2012_Footnote57_ModifiedTable5.txt, title(FN 57 Model 5) /*
*/ ctitle((FN57_M5)) bdec(3) tdec(2) 3aster nor2 replace

* Page 652: Footnote 53: "One simple check for this is to verify whether the Arellano–Bond estimates of the 
* coefficient on the lagged dependent variable lie between those obtained by fixed effects with a lagged 
* dependent variable, and ordinary least squares with a lagged dependent variable, or at least not significantly 
* outside this range. The rationale for this check is that, in the presence of unobserved heterogeneity, these 
* two estimators are inconsistent. The estimated coefficients on the lagged dependent variable tend to be small 
* in the former case and too large in the latter (see Stephen R. Bond, ‘Dynamic Panel Data Models: A Guide to 
* Micro Data Methods and Practice’, Portuguese Economic Journal, 1 (2002), 141–162, p. 144). In all our models, 
* the range between these two coefficient estimates is indeed large, and all our Arellano–Bond lagged dependent 
* variable coefficient estimates lie strictly between the fixed effects and the OLS estimate."
* COEFF. ESTIMATE ON LDV SHOULD BE TOO SMALL: F/E W/ LDV
xtreg sp_per L.sp_per , fe
* COEFF. ESTIMATE ON LDV SHOULD BE TOO LARGE: OLS W/ LDV
reg sp_per L.sp_per 

clear
erase workfile.dta
log close
exit

* You can view a record of all operations and results in the BJPS2012.smcl file.
