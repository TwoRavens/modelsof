****************************************************************************
* File-Nale: 		afro2005.do
* Date:		 04/30/2018
* Author: 		Fred Batista
* Purpose: 		individual level analyses of knowledge
* Data used: 		afro2005.dta
* Data Output:	Journal of Politics’ paper	*/
****************************************************************************


*Variables:

*Sex - q101
*Country - country
*Urban/Rural - urbrur
*Age - q1
*Religiosity -
*Household Income - 
*Education - q90
*Media Access - q93b, q93c
* Other household assets - Q93D, Q93E, Q93F
*Media Exposure - Q15A, Q15B, Q15C
*Political Interest - Q16
*Political Discussions: Q17
*Political Efficacy - Q18A
*Marital Status - 
*Housewife - Q95
*Number of Children - 
*Head of household - Q2
*Political Knowledge - Q43A2 (local representative), Q43B2 (local government councillor), Q43C2 (deputy president/vice president), Q44A2 (party most seats), Q44B2 (times one can be elected president), Q44C2 (who determines constitutionality)
* Interviewers gender - Q112
*Sample Weight - withinwt, acrosswt, combinwt


*****************RECODING VARIABLES	

tab country, gen(country)

gen woman = q101 - 2

gen man = 2-woman

gen urban = urbrur

recode urban (1=1) (2=0)

gen age = q1

recode age (-1 998 999 =.)

gen age_sq = age*age

gen education = q90 - 2

recode education (-1 10=.)

gen ownradio = q93b - 2

gen owntv = q93c - 2

recode ownradio owntv (-1 2 3=.)

pwcorr ownradio owntv, sig

alpha ownradio owntv

gen mediahome = ownradio + owntv

gen ownbike = q93d - 2

gen ownmotor = q93e - 2

gen owncar = q93f - 2

recode ownbike ownmotor owncar (-1 2 3=.)

pwcorr  ownbike ownmotor owncar, sig

alpha ownbike ownmotor owncar

gen assets = ownbike + ownmotor +  owncar

gen expradio = q15a - 2

gen exptv = q15b - 2

gen exppaper = q15c - 2

recode expradio exptv exppaper (-1 5=.)

pwcorr expradio exptv exppaper, sig

alpha expradio exptv exppaper

gen exposure = (expradio + exptv + exppaper)/4

gen interest = q16 - 2

recode interest (-1 4=.)

gen discussions = q17 - 2

recode discussion (-1 3=.)

gen efficacy = q18a - 2

recode efficacy (-1 5=.)

gen housewife = q95

recode housewife (26=1) (1 46 47=.) (else=0)

gen head = q2

recode head (3=1) (2=0) (1 4=.)

gen dependent = 1 - head

gen member = q43a2

gen councillor = q43b2

gen deputypres = q43c2

gen seats = q44a2

gen times = q44b2

gen const = q44c2 

recode member deputypres seats times const (1=.) (2 3 5 =0) (4=1)

recode councillor (1 5=.) (4=1) (2 3 6=0)

pwcorr member councillor deputypres seats times const, sig

alpha member councillor deputypres seats times const

gen knowledge = ((member + councillor +  deputypres + seats + times + const)*100)/6

gen member2 = q43a2

gen councillor2 = q43b2

gen deputypres2 = q43c2

gen seats2 = q44a2

gen times2 = q44b2

gen const2 = q44c2 

recode member2 deputypres2 seats2 times2 const2 (1=.) (2 5 =0) (3=1) (4=2)

recode councillor2 (1 5=.) (2 6=0) (3=1) (4=2)


**** ANALYSES

*** Benin

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1, base(2)

* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==1

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==1, base(2)



*** Botswana

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==2

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==2, base(2)



*** Cape Verde

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==3

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==3, base(2)


*** Ghana

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==4

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==4, base(2)


*** Kenya

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==5

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==5, base(2)


*** Lesotho

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==6

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==6, base(2)


*** Madagascar

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==7

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==7, base(2)


*** Malawi

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==8

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==8, base(2)


*** Mali

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==9

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==9, base(2)


*** Mozambique

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==10

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==10, base(2)



*** Namibia

* models

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==11

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==11, base(2)


*** Nigeria

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==12

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==12, base(2)


*** Senegal

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==13

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==13, base(2)


*** South Africa

* member (housewife predicts perfectly, so omitted)

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy [pweight = withinwt] if country==14

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy [pweight = withinwt] if country==14

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy [pweight = withinwt] if country==14, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==14

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==14, base(2)



*** Tanzania

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==15

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==15, base(2)


* const (housewife perfectly predicts, so omitted)

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy [pweight = withinwt] if country==15

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy [pweight = withinwt] if country==15

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy  [pweight = withinwt] if country==15, base(2)


*** Uganda

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==16

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==16, base(2)


*** Zambia

* member

khb probit member man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

probit member man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

mlogit member2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17, base(2)


* councillor

khb probit councillor man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

probit councillor man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

mlogit councillor2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17, base(2)


* deputypres

khb probit deputypres man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

probit deputypres man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

mlogit deputypres2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17, base(2)


* seats

khb probit seats man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

probit seats man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

mlogit seats2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17, base(2)


* times

khb probit times man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

probit times man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt]if country==17

mlogit times2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17, base(2)


* const

khb probit const man || urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

probit const man urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17

mlogit const2 woman urban age age_sq mediahome assets education interest exposure discussion efficacy housewife [pweight = withinwt] if country==17, base(2)




*** item analyses

* "discrimination"

by country: factor member councillor deputypres seats times const [aweight=withinwt], ml factor(1)

** difficulty

by country: summarize member councillor deputypres seats times const [aweight=withinwt]


