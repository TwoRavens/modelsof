********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************
********************************************************************************

* Open "2012 CCES.dta"

********************************************************************************

*** Cleaning and recoding data ***

* Party identification
gen pid = pid7 - 4
replace pid = . if pid > 3

gen dem = 1 if pid < 0
replace dem = 0 if pid > 0


****
** Which of these groups are likely to work in secret
** against the rest of us? Check all that apply.
****

* Corporations and the rich
gen concorp = MIA375_1
replace concorp = . if concorp > 2
recode concorp (2=0)


* Republicans or other conservative groups
gen conreps = MIA375_2
replace conreps = . if conreps > 2
recode conreps (2=0)


* Democrats or other liberal groups
gen condems = MIA375_3
replace condems = . if condems > 2
recode condems (2=0)


* Communists and Socialists
gen concomm = MIA375_4
replace concomm = . if concomm > 2
recode concomm (2=0)


* The government
gen congovr = MIA375_5
replace congovr = . if congovr > 2
recode congovr (2=0)


* Foreign countries
gen confore = MIA375_6
replace confore = . if confore > 2
recode confore (2=0)


* International organizations (e.g., UN, IMF, WB)
gen conintr = MIA375_7
replace conintr = . if conintr > 2
recode conintr (2=0)


* The Freemasons, or some other fraternal group
gen confree = MIA375_8
replace confree = . if confree > 2
recode confree (2=0)


* Labor unions
gen conlabu = MIA375_9
replace conlabu = . if conlabu > 2
recode conlabu (2=0)


* Some other group 
gen conothr = MIA375_10
replace conothr = . if conothr > 2
recode conothr (2=0)


* None of the above
gen connone = MIA375_11
replace conothr = . if conothr > 2
recode conothr (2=0)


********************************************************************************

*** Empirical analysis ***

* Examine proportions (Figure 1)
prtest condems, by(dem)

prtest conreps, by(dem)

prtest concorp, by(dem)

prtest concomm, by(dem)

prtest congovr, by(dem)

prtest confore, by(dem)

prtest conintr, by(dem)

prtest confree, by(dem)

prtest conlabu, by(dem)


* Factor analysis (Table A1, Supplemental Appendix)
factor condems-conlabu, ipf
