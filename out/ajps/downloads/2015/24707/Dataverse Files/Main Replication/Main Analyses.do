/*open 'perez_xenophobic.dta'*/

/*variable descriptions***********************************************************************************************

**********************************************************************************************************************
                                                                                                                     *
expgroup = experimental conditions; 1=control group, 2=non-xenophobic group, 3=xenophobic group                      * 
                                                                                                                     *
noxeno = non-xenophobic treatment; 1=exposure, 0=no exposure                                                         * 
                                                                                                                     *
xeno = xenophobic treatment; 1=exposure, 0=no exposure                                                               *
                                                                                                                     *
latid = latino identity, 0=low identity to 1=high identity                                                           *
                                                                                                                     *
ancestid = national origin identity, 0=low identity to 1=high identity                                               *
                                                                                                                     *
trust = trust in government, 1=some of the time, 2= most of the time, 3 just about always                            *
                                                                                                                     *
ethnos = ethnocentrism, 0=low ethnocentrism to 1=high ethnocentrism                                                  *
                                                                                                                     *
ethnos1 = ethnocentrism, -70.5=low ethnocentrism to 84.5=high ethnocentrism                                          * 
                                                                                                                     *
latinos = latino thermometer rating, 0=unfavorable toward latinos to 100 favorable toward latinos                    *
                                                                                                                     *
whites = white thermometer rating, 0=unfavorable toward whites to 100 favorable toward whites                        *
                                                                                                                     *
blacks = black thermometer rating, 0=unfavorable toward blacks to 100 favorable toward blacks                        *
                                                                                                                     *
nation = pro-group politics (aka, ethnic nationalism), 0=strong disagreement to 1=strong agreement                   *
                                                                                                                     *
interview = language of interview, 0=spanish, 1=english                                                              *
                                                                                                                     *
enghome = language spoken at home, 1=only spanish to 5=only english                                                  *
                                                                                                                     *
gener = immigrant generation, 1=first generation, 2=second generation, 3=third generation                            *
                                                                                                                     *
ingles = language spoken at home, 1=only spanish, 2=both equally, 3=only english                                     *
                                                                                                                     *
party1 = 1=strong republican to 7=strong democrat                                                                    *
                                                                                                                     *
party = 0=strong republican to 1=strong democrat                                                                     * 
                                                                                                                     *
ideol = 0=extremely conservative to 1=extremely liberal                                                              *
                                                                                                                     *
mexies = respondents with mexican ancestry, 1=mexican, 0=not mexican                                                 *
                                                                                                                     *
bornus = born in the u.s., 1=born in u.s., 0=born outside u.s.                                                       *
                                                                                                                     *
second = second generation, 1=second generation status, 0=non-second generation status                               *
                                                                                                                     *
third = third generation, 1=third generation status, 0=non-third generation status                                   *
                                                                                                                     *
natcit = naturalized citizen, 1=naturalized citizen, 2=not naturalized citizen                                       *
                                                                                                                     *
citiz = citizenship status, 1=citizen, 0=non-citizen                                                                 *
                                                                                                                     *
educs = education level, 1=less than high school, 2=high school, 3=some college, 4=bachelor's degree or higher       *
                                                                                                                     *
educ = education level, 0=less than school to 1=bachelor's degree or higher                                          *
                                                                                                                     *
inc = income level, 0=less than $5K to 1=$175K or more, with .5555556 = median (i.e., $40K)                          *
                                                                                                                     *
age = in years, 18 to 91                                                                                             *
                                                                                                                     *
ages = age, 0=lowest age to 1=highest age                                                                            *
                                                                                                                     *
male = gender, 1=male, 0=female                                                                                      *
                                                                                                                     *
longer6 = survey completion time, 1=more than 6 minutes, 0=all others                                                *
                                                                                                                     *
longer12 = survey completion time, 1=more than 12 minutes, 0=all others                                              *
                                                                                                                     *
cont_noxen = non-xenophobic treatment, 1=exposure to non-xenophobic, 0=control condition                             *
                                                                                                                     *
cont_xen = xenophobic treatment, 1=exposure to xenophobic, 0=control condition                                       *
                                                                                                                     *
noxen_xen = xenophobic treatment, 1=exposure to xenophobic, 0=exposure to non-xenophobic                             *
                                                                                                                     *
weight = weight for analyses                                                                                         *
                                                                                                                     *
**********************************************************************************************************************

*********************************************************************************************************************/


/*Table 1. Ethnic Identity Moderates Xenophobic Rhetoric*/

/*create interactions between treatments and identity*/

gen xenoid=(xeno*latid)
gen noxenoid=(noxeno*latid)

oprobit trust xeno noxeno latid xenoid noxenoid [pweight=weight], robust
test noxeno latid noxenoid

reg ethnos xeno noxeno latid xenoid noxenoid [pweight=weight], robust

reg nation xeno noxeno latid xenoid noxenoid [pweight=weight], robust
test xeno latid xenoid


/*Figure 1. Probability of Trust by Immigration Rhetoric and Identity*/

oprobit trust xeno noxeno latid xenoid noxenoid [pweight=weight], robust

/*control group*/

prvalue, x(xeno=0 noxeno=0 latid 0 xenoid=0 noxenoid=0) level (90) delta 
prvalue, x(xeno=0 noxeno=0 latid .33 xenoid=0 noxenoid=0) level (90) delta 
prvalue, x(xeno=0 noxeno=0 latid .66 xenoid=0 noxenoid=0) level (90) delta 
prvalue, x(xeno=0 noxeno=0 latid 1 xenoid=0 noxenoid=0) level (90) delta 

/*Non-xenophobic rhetoric*/

prvalue, x(xeno=0 noxeno=1 latid 0 xenoid=0 noxenoid=0) level (90) delta 
prvalue, x(xeno=0 noxeno=1 latid .33 xenoid=0 noxenoid=.33) level (90) delta 
prvalue, x(xeno=0 noxeno=1 latid .66 xenoid=0 noxenoid=.66) level (90) delta 
prvalue, x(xeno=0 noxeno=1 latid 1 xenoid=0 noxenoid=1) level (90) delta 

/*Xenophobic rhetoric*/

prvalue, x(xeno=1 noxeno=0 latid 0 xenoid=0 noxenoid=0) level (90) delta 
prvalue, x(xeno=1 noxeno=0 latid .33 xenoid=.33 noxenoid=0) level (90) delta
prvalue, x(xeno=1 noxeno=0 latid .66 xenoid=.66 noxenoid=0) level (90) delta 
prvalue, x(xeno=1 noxeno=0 latid 1 xenoid=1 noxenoid=0) level (90) delta


/*Figure 2. Marginal Effect of Immigration Rhetoric on Ethnocentrism by Latino Identity*/

reg ethnos xeno noxeno latid xenoid noxenoid [pweight=weight], robust

/*Non-xenophobic rhetoric*/

lincom noxeno + noxenoid*0, level(90)
lincom noxeno + noxenoid*.333, level(90)
lincom noxeno + noxenoid*.666, level(90)
lincom noxeno + noxenoid*1, level(90)

/*Xenophobic rhetoric*/

lincom xeno + xenoid*0, level(90)
lincom xeno + xenoid*.333, level(90)
lincom xeno + xenoid*.666, level(90)
lincom xeno + xenoid*1, level(90)


/*Figure 3. Marginal Effect of Immigration Rhetoric on Pro-Group Politics by Latino Identity*/

reg nation xeno noxeno latid xenoid noxenoid [pweight=weight], robust

test xeno latid xenoid

lincom noxeno + noxenoid*0, level(90)
lincom noxeno + noxenoid*.333, level(90)
lincom noxeno + noxenoid*.666, level(90)
lincom noxeno + noxenoid*1, level(90)

lincom xeno + xenoid*0, level(90)
lincom xeno + xenoid*.333, level(90)
lincom xeno + xenoid*.666, level(90)
lincom xeno + xenoid*1, level(90)


/*Figure 4. Probabilty of Trust by Immigration Rhetoric, Identity, and Acculturation*/

/*create acculturation scale*/

polychoric gener ingles
alpha gener ingles, std
gen accult1=(gener + ingles)
summ accult1
gen accult=(accult1 - 2)/4
summ accult
polychoric accult latid

/*create relevant interactions*/

gen noxenoaccult=(noxeno*accult)
gen xenoaccult=(xeno*accult)
gen idaccult=(latid*accult)
gen xenoidaccult=(xeno*latid*accult)
gen noxenoidaccult=(noxeno*latid*accult)


oprobit trust xeno latid accult xenoid xenoaccult idaccult xenoidaccult [pweight=weight], robust
test xeno latid accult xenoid xenoaccult idaccult xenoidaccult

/*when acculturation is low*/

prvalue, x(xeno=0 latid=0 accult=0 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=0 latid=.33 accult=0 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=0 latid=.66 accult=0 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=0 latid=1 accult=0 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 

prvalue, x(xeno=1 latid=0 accult=0 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=1 latid=.33 accult=0 xenoid=.33 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=1 latid=.66 accult=0 xenoid=.66 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=1 latid=1 accult=0 xenoid=1 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 

/*first difference between low and high in xenophobic condition*/

prvalue, x(xeno=1 latid=0 accult=0 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta save
prvalue, x(xeno=1 latid=1 accult=0 xenoid=1 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta diff

/*when acculturation is medium*/

prvalue, x(xeno=0 latid=0 accult=.5 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta  
prvalue, x(xeno=0 latid=.33 accult=.5 xenoid=0 xenoaccult=0 idaccult=.165 xenoidaccult=0) level(90) delta  
prvalue, x(xeno=0 latid=.66 accult=.5 xenoid=0 xenoaccult=0 idaccult=.33 xenoidaccult=0) level(90) delta  
prvalue, x(xeno=0 latid=1 accult=.5 xenoid=0 xenoaccult=0 idaccult=.5 xenoidaccult=0) level(90) delta  

prvalue, x(xeno=1 latid=0 accult=.5 xenoid=0 xenoaccult=.5 idaccult=0 xenoidaccult=0) level(90) delta  
prvalue, x(xeno=1 latid=.33 accult=.5 xenoid=.33 xenoaccult=.5 idaccult=.165 xenoidaccult=.165) level(90) delta  
prvalue, x(xeno=1 latid=.66 accult=.5 xenoid=.66 xenoaccult=.5 idaccult=.33 xenoidaccult=.33) level(90) delta  
prvalue, x(xeno=1 latid=1 accult=.5 xenoid=1 xenoaccult=.5 idaccult=.5 xenoidaccult=.5) level(90) delta  

/*first difference between high and low in xenophobic condition*/

prvalue, x(xeno=1 latid=0 accult=.5 xenoid=0 xenoaccult=.5 idaccult=0 xenoidaccult=0) level(90) delta save 
prvalue, x(xeno=1 latid=1 accult=.5 xenoid=1 xenoaccult=.5 idaccult=.5 xenoidaccult=.5) level(90) delta diff

/*when acculturation is high*/

prvalue, x(xeno=0 latid=0 accult=1 xenoid=0 xenoaccult=0 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=0 latid=.33 accult=1 xenoid=0 xenoaccult=0 idaccult=.33 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=0 latid=.66 accult=1 xenoid=0 xenoaccult=0 idaccult=.66 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=0 latid=1 accult=1 xenoid=0 xenoaccult=0 idaccult=1 xenoidaccult=0) level(90) delta  

prvalue, x(xeno=1 latid=0 accult=1 xenoid=0 xenoaccult=1 idaccult=0 xenoidaccult=0) level(90) delta 
prvalue, x(xeno=1 latid=.33 accult=1 xenoid=.33 xenoaccult=1 idaccult=.33 xenoidaccult=.33) level(90) delta 
prvalue, x(xeno=1 latid=.66 accult=1 xenoid=.66 xenoaccult=1 idaccult=.66 xenoidaccult=.66) level(90) delta 
prvalue, x(xeno=1 latid=1 accult=1 xenoid=1 xenoaccult=1 idaccult=1 xenoidaccult=1) level(90) delta  

/*first difference between high and low in xenophobic condition*/

prvalue, x(xeno=1 latid=0 accult=1 xenoid=0 xenoaccult=1 idaccult=0 xenoidaccult=0) level(90) delta save
prvalue, x(xeno=1 latid=1 accult=1 xenoid=1 xenoaccult=1 idaccult=1 xenoidaccult=1) level(90) delta diff


/*Figure 5. Marginal effect on ethnocentrism of xenophobic rhetoric by latino identity and acculturation*/

reg ethnos xeno noxeno latid accult xenoid noxenoid xenoaccult noxenoaccult idaccult xenoidaccult noxenoidaccult [pweight=weight], robust

/*low acculturation, non-xenophobic condition*/

lincom noxeno + noxenoid*0 + noxenoaccult*0 + noxenoidaccult*0*0, level(90)
lincom noxeno + noxenoid*.333 + noxenoaccult*0 + noxenoidaccult*.333*0, level(90)
lincom noxeno + noxenoid*.666 + noxenoaccult*0 + noxenoidaccult*.666*0, level(90)
lincom noxeno + noxenoid*1 + noxenoaccult*0 + noxenoidaccult*1*0, level(90)

/*medium acculturation, non-xenophobic condition*/

lincom noxeno + noxenoid*0 + noxenoaccult*.5 + noxenoidaccult*0*.5, level(90)
lincom noxeno + noxenoid*.333 + noxenoaccult*.5 + noxenoidaccult*.333*.5, level(90)
lincom noxeno + noxenoid*.666 + noxenoaccult*.5 + noxenoidaccult*.666*.5, level(90)
lincom noxeno + noxenoid*1 + noxenoaccult*.5 + noxenoidaccult*1*.5, level(90)

/*high acculturation, non-xenophobic condition*/

lincom noxeno + noxenoid*0 + noxenoaccult*1 + noxenoidaccult*0*1, level(90)
lincom noxeno + noxenoid*.333 + noxenoaccult*1 + noxenoidaccult*.333*1, level(90)
lincom noxeno + noxenoid*.666 + noxenoaccult*1 + noxenoidaccult*.666*1, level(90)
lincom noxeno + noxenoid*1 + noxenoaccult*1 + noxenoidaccult*1*1, level(90)

/*low acculturation, xenophobic condition*/

lincom xeno + xenoid*0 + xenoaccult*0 + xenoidaccult*0*0, level(90)
lincom xeno + xenoid*.333 + xenoaccult*0 + xenoidaccult*.333*0, level(90)
lincom xeno + xenoid*.666 + xenoaccult*0 + xenoidaccult*.666*0, level(90)
lincom xeno + xenoid*1 + xenoaccult*0 + xenoidaccult*1*0, level(90)

/*medium acculturation, xenophobic condition*/

lincom xeno + xenoid*0 + xenoaccult*.5 + xenoidaccult*0*.5, level(90)
lincom xeno + xenoid*.333 + xenoaccult*.5 + xenoidaccult*.333*.5, level(90)
lincom xeno + xenoid*.666 + xenoaccult*.5 + xenoidaccult*.666*.5, level(90)
lincom xeno + xenoid*1 + xenoaccult*.5 + xenoidaccult*1*.5, level(90)

/*high acculturation, xenophobic condition*/

lincom xeno + xenoid*0 + xenoaccult*1 + xenoidaccult*0*1, level(90)
lincom xeno + xenoid*.333 + xenoaccult*1 + xenoidaccult*.333*1, level(90)
lincom xeno + xenoid*.666 + xenoaccult*1 + xenoidaccult*.666*1, level(90)
lincom xeno + xenoid*1 + xenoaccult*1 + xenoidaccult*1*1, level(90)


/*Table A, SI*/

/*create relevant interactions between treatment and partisanship*/

gen xenodem=(xeno*party)
gen noxenodem=(noxeno*party)

oprobit trust xeno noxeno party xenodem noxenodem [pweight=weight], robust
reg ethnos xeno noxeno party xenodem noxenodem [pweight=weight], robust
reg nation xeno noxeno party xenodem noxenodem [pweight=weight], robust


/*Table B, SI*/

reg latinos xeno noxeno latid xenoid noxenoid [pweight=weight], robust
lincom xeno + xenoid*1

reg whites xeno noxeno latid xenoid noxenoid [pweight=weight], robust
lincom xeno + xenoid*1

reg blacks xeno noxeno latid xenoid noxenoid [pweight=weight], robust
lincom xeno + xenoid*1


/*Table C, SI*/

polychoric latid ancestid

******************************
*                            * 
* See also "LNS data" folder *
*                            *
******************************

/*Table D, SI*/

summ latid ancestid party mexies second third citiz educ inc ages male

oprobit latid party mexies second third citiz educ inc ages male, level(90)
oprobit ancestid party mexies second third citiz educ inc ages male, level(90)


/*Table E and Figure F, SI*/

/*create relevant interactions between national origin id and treatments*/

gen xenoancest=(xeno*ancestid)
gen noxenoancest=(noxeno*ancestid)

oprobit trust xeno noxeno ancestid xenoancest noxenoancest [pweight=weight], robust

prvalue, x(xeno=1 noxeno=0 ancestid=0 xenoancest=0 noxenoancest=0) level (90) delta save
prvalue, x(xeno=1 noxeno=0 ancestid=.33 xenoancest=.33 noxenoancest=0) level (90) delta save
prvalue, x(xeno=1 noxeno=0 ancestid=.66 xenoancest=.66 noxenoancest=0) level (90) delta save
prvalue, x(xeno=1 noxeno=0 ancestid=1 xenoancest=1 noxenoancest=0) level (90) delta save

reg ethnos xeno noxeno ancestid xenoancest noxenoancest [pweight=weight], robust

lincom xeno + xenoancest*0, level(90)
lincom xeno + xenoancest*.333, level(90)
lincom xeno + xenoancest*.666, level(90)
lincom xeno + xenoancest*1, level(90)

reg nation xeno noxeno ancestid xenoancest noxenoancest [pweight=weight], robust

lincom xeno + xenoancest*0, level(90)
lincom xeno + xenoancest*.333, level(90)
lincom xeno + xenoancest*.666, level(90)
lincom xeno + xenoancest*1, level(90)


/*Table G, SI*/

oprobit trust xeno noxeno latid xenoid noxenoid [pweight=weight], robust level(90)
oprobit trust xeno noxeno latid xenoid noxenoid [pweight=weight] if mexies==1, robust level(90)

reg ethnos xeno noxeno latid xenoid noxenoid [pweight=weight], robust level(90)
reg ethnos xeno noxeno latid xenoid noxenoid [pweight=weight] if mexies==1, robust level(90)

reg nation xeno noxeno latid xenoid noxenoid [pweight=weight], robust level(90)
reg nation xeno noxeno latid xenoid noxenoid [pweight=weight] if mexies==1, robust level(90)


*********************************************** 
*                                             * 
* Table H, SI, is in "Perez 2013 data" folder *
*                                             *
***********************************************


/*Table I, SI*/

probit longer6 xeno noxeno
probit longer12 xeno noxeno


/*Table J, SI*/

gen contnoxenid=(cont_noxen*latid)

reg ethnos latid cont_noxen contnoxenid, robust
oprobit trust latid cont_noxen contnoxenid, robust
reg nation latid cont_noxen contnoxenid, robust


/*Table K, SI*/

/*Mexican origin proportion*/

tab mexies

summ age, detail

/*education*/

tab educs
tab educs, nolabel
summ educs, detail

/*male, 1=male*/

tab male

/*foreign-born proportion, foreign-born=0*/

tab bornus, nolabel

/*sample proportion of naturalized citizens, naturalized=1*/

tab natcit
tab natcit, nolabel

****************************************
*                                      * 
* LNS figures are in "LNS data" folder *
*                                      *
****************************************


/*Table L, SI*/

mlogit expgroup latid, baseoutcome(1)
mlogit expgroup accult, baseoutcome(1)
mlogit expgroup latid accult, baseoutcome(1)
mlogit expgroup latid accult ages educ inc male ideol party, baseoutcome(1)


/*Table M, SI*/

tab latid cont_noxen, chi2
tab latid cont_xen, chi2
tab latid noxen_xen, chi2

tab accult cont_noxen, chi2
tab accult cont_xen, chi2
tab accult noxen_xen, chi2
