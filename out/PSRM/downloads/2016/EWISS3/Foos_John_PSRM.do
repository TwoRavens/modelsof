****************************************************************************************************
* Data for the replication of Parties Are No Civic Charities: 
* Voter Contact and the Changing Partisan Composition of the Electorate	
* Florian Foos and Peter John 
* Political Science Research and Methods
* Date: July 18, 2016
****************************************************************************************************

* The following analyses were carried out using Stata/SE 13.1 for Windows (64-bit x86-64) 

* download .dta and .grec files into new personal folder and specify it as the working directory:
cd " " 
** NOTE: insert correct link to folder between " " 

* open data (from folder set as working directory):

clear


use Foos_John_PSRM_18_Jul_2016.dta


*** Recoding ***


*Create binary treatment indicator: treatment = 1, control = 0

recode group (0=0) (1 2=1), into(treatment)


*Recode treatment conditions: 1 = control, 2 = canvass, 3 = leaflet 

recode group (0=1) (1=2) (2=3), into(treat)


*Recode into canvass vs leaflet: 0 = leaflet, 1 = canvass 

recode treat (3=0) (2=1) (1=.), into(canvass)


*Rename outcome variable

rename turnout turnout2014


*Create differenced outcome

gen turnoutdif=turnout2014-turnout2010


**Create gender dummies

gen female=0
replace female=1 if gender==2

gen male=0
replace male=1 if gender==3

gen unknown=0
replace unknown=1 if gender==1


*Create pid categories

gen party_code="Cons" if lvi==4 | lvi==10
replace party_code="Against Cons" if lvi==2 | lvi==3 | lvi==5 | lvi==6 | lvi==7
replace party_code="Lab" if lvi==11 | lvi==12
replace party_code="LibDem" if lvi==8 | lvi==9
replace party_code="Undecided" if lvi==13
replace party_code="Nonvoter" if lvi==14
replace party_code="Missing" if lvi==1

**3-group operationalization

gen pid=1 if party_code=="Cons"
replace pid=2 if party_code=="Against Cons"
replace pid=2 if party_code=="Lab"
replace pid=2 if party_code=="LibDem"
replace pid=3 if party_code=="Missing"
replace pid=3 if party_code=="Undecided"
replace pid=3 if party_code=="Nonvoter"

**7-group operationalization

gen pid2=1 if party_code=="Cons"
replace pid2=2 if party_code=="Against Cons"
replace pid2=3 if party_code=="Lab"
replace pid2=4 if party_code=="LibDem"
replace pid2=5 if party_code=="Undecided"
replace pid2=6 if party_code=="Nonvoter"
replace pid2=7 if party_code=="Missing"


* Create household contact variable: 1 = spoke to at least one individual in the household, 0 = spoke to no one

gen temp=contact 
egen contact_hh=total(temp), by(id)
label var contact_hh 
drop temp

recode contact_hh (0=0) (1/5=1)


** Create interaction terms

tab pid, gen(pid_)

gen pid_1xcontact=pid_1*contact_hh

gen pid_1xcanvass=pid_1*canvass

gen pid_2xcontact=pid_2*contact_hh

gen pid_2xcanvass=pid_2*canvass

gen pid_3xcontact=pid_3*contact_hh

gen pid_3xcanvass=pid_3*canvass


gen unknownxcontact=unknown*contact_hh

gen unknownxcanvass=unknown*canvass

gen femalexcontact=female*contact_hh

gen femalexcanvass=female*canvass

gen turnout2010xcontact=turnout2010*contact_hh

gen turnout2010xcanvass=turnout2010*canvass


*Save file to load in R


save Foos_John_PSRM_18_Jul_2016_load.dta



*** Manuscript

***  Table 1 


*** Column 1
logit turnout2014 i.pid i.treatment i.ward, cluster(id)

*** Column 2

logit turnout2014 i.pid i.treatment i.pid#i.treatment i.ward, cluster(id)

*** Column 3

logit turnout2014 i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.turnout2010, cluster(id)

*** Column 4

logit turnout2014 i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.turnout2010 c.female#i.treatment c.unknown#i.treatment c.turnout2010#i.treatment, cluster(id)

*** Column 5

logit turnout2014 i.pid i.treat i.ward, cluster(id)

*** Column 6

logit turnout2014 i.pid i.treat i.pid#i.treat i.ward, cluster(id)

*** Column 7

logit turnout2014 i.pid i.treat i.pid#i.treat i.ward c.female c.unknown c.turnout2010, cluster(id)

*** Column 8

logit turnout2014 i.pid i.treat i.pid#i.treat i.ward c.female c.unknown c.turnout2010 c.female#i.treat c.unknown#i.treat c.turnout2010#i.treat, cluster(id)






***Figure 2

** Row 1, Column 1

logit turnout2014 i.pid i.treatment i.pid#i.treatment i.ward, cluster(id)

margins, dydx(treat) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"


** Row 1, Column 2

logit turnout2014 i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.turnout2010 c.female#i.treatment c.unknown#i.treatment c.turnout2010#i.treatment, cluster(id)

margins, dydx(treat) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"


** Row 2, Column 1


logit turnout2014 i.pid2 i.treatment i.pid2#i.treatment i.ward, cluster(id)

margins, dydx(treat) atmeans at(pid2=(1(1)7))

marginsplot

graph play "Foos_John.grec"

graph play "Foos_John_5cat.grec"


** Row 2, Column 2

logit turnout2014 i.pid2 i.treatment i.pid2#i.treatment i.ward c.female c.unknown c.turnout2010 c.female#i.treatment c.unknown#i.treatment c.turnout2010#i.treatment, cluster(id)

margins, dydx(treat) atmeans at(pid2=(1(1)7))

marginsplot

graph play "Foos_John.grec"

graph play "Foos_John_5cat.grec"





*** Table 3

**Columns 1+2

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward, cluster(id) b(0)

***-1 (column 1), 1 (column 2)

**Columns 3+4

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.female#i.treatment  c.unknown#i.treatment, cluster(id) b(0)

***-1 (column 3), 1 (column 4)





**Figure 3

***Column 1, row 1

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward, cluster(id) b(0)

margins, dydx(treatment) predict(outcome(-1)) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"

***Column 1, row 2

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward, cluster(id) b(0)

margins, dydx(treatment) predict(outcome(0)) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"

***Column 1, row 3

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward, cluster(id) b(1)

margins, dydx(treatment) predict(outcome(1)) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"

***Column 2, row 1

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.female#i.treatment  c.unknown#i.treatment , cluster(id) b(0)

margins, dydx(treatment) predict(outcome(-1)) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"

***Column 2, row 2

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.female#i.treatment  c.unknown#i.treatment, cluster(id) b(0)

margins, dydx(treatment) predict(outcome(0)) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"

***Column 2, row 3

mlogit turnoutdif i.pid i.treatment i.pid#i.treatment i.ward c.female c.unknown c.female#i.treatment  c.unknown#i.treatment, cluster(id) b(0)

margins, dydx(treatment) predict(outcome(1)) atmeans at(pid=(1(1)3))

marginsplot

graph play "Foos_John.grec"






*****Supporting Information


*** Table A3 


*** Column 1

logit turnout2014 i.pid2 i.treatment i.ward, cluster(id)

*** Column 2

logit turnout2014 i.pid2 i.treatment i.pid2#i.treatment i.ward, cluster(id)

*** Column 3

logit turnout2014 i.pid2 i.treatment i.pid2#i.treatment i.ward c.female c.unknown c.turnout2010, cluster(id)

*** Column 4

logit turnout2014 i.pid2 i.treatment i.pid2#i.treatment i.ward c.female c.unknown c.turnout2010 c.female#i.treatment c.unknown#i.treatment c.turnout2010#i.treatment, cluster(id)



***  Table A4 


*** Column 1

logit turnout2014 i.pid2 i.treat i.ward, cluster(id)

*** Column 2
logit turnout2014 i.pid2 i.treat i.pid2#i.treat i.ward, cluster(id)

*** Column 3

logit turnout2014 i.pid2 i.treat i.pid2#i.treat i.ward c.female c.unknown c.turnout2010, cluster(id)

*** Column 4

logit turnout2014 i.pid2 i.treat i.pid2#i.treat i.ward c.female c.unknown c.turnout2010 c.female#i.treat c.unknown#i.treat c.turnout2010#i.treat, cluster(id)



*** Table A5 


*** Column 1

ivregress 2sls turnout2014 (contact_hh=canvass) i.pid i.ward, cluster(id)

*** Column 2

ivregress 2sls turnout2014 (contact_hh=canvass) i.pid_2 i.pid_3 i.ward i.turnout2010 i.gender, cluster(id)

*** Column 3

ivregress 2sls turnout2014 (contact_hh pid_2xcontact pid_3xcontact=treat pid_2xcanvass pid_3xcanvass) i.ward i.pid_2 i.pid_3, cluster(id)

*** Column 4

ivregress 2sls turnout2014 (contact_hh pid_2xcontact pid_3xcontact unknownxcontact femalexcontact turnout2010xcontact=canvass pid_2xcanvass pid_3xcanvass turnout2010xcanvass femalexcanvass unknownxcanvass) i.ward i.pid_2 i.pid_3 i.turnout2010 unknown female if (treat==2 | treat==3), cluster(id)



***  Balance Check 

tab pid2, gen(pid2_)

regress treatment pid2_2 pid2_3 pid2_4 pid2_5 pid2_6 pid2_7 ward female unknown turnout2010, cluster(id)

test pid2_2 pid2_3 pid2_4 pid2_5 pid2_6 pid2_7  female unknown turnout2010 

*p=0.15973


*log close
*clear


***load data_analysis_12_07_2016_load.dta in R

*** continue R code
