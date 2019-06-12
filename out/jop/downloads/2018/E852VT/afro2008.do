****************************************************************************
* File-Nale: 		afro2008.do
* Date:		 04/30/2018
* Author: 		Fred Batista
* Purpose: 		individual level analyses of knowledge
* Data used: 		afro2008.dta
* Data Output:	Journal of Politics’ paper	*/
****************************************************************************

*Variables:

*Sex - Q101
*Country - COUNTRY
*Urban/Rural - URBRUR
*Age - Q1
*Religiosity - Q91
*Household Income - 
*Education - Q89
*Media Access - Q92A, Q92B, Q92C
*Media Exposure - Q12A, Q12B, Q12C
*Political Interest - Q13
*Political Discussions: Q14
*Political Efficacy -
*Marital Status - 
*Housewife - Q94
*Number of Children - 
*Head of household - Q2
*Political Knowledge - Q41a2, Q41b2
* Interviewers gender - Q112
*Sample Weight - Withinwt, Acrosswt, Combinwt

*****************RECODING VARIABLES	

gen country = COUNTRY

tab country, gen(country)

gen woman = Q101 - 2

gen man = 2 - woman

gen urban = URBRUR

recode urban (1=1) (2=0)

gen age = Q1

recode age (-1 998 999 =.)

gen age_sq = age*age

gen religiosity = Q91 - 2

recode religiosity (-1 4 5=.)

gen education = Q89 - 2

recode education (-1 10=.)

gen ownradio = Q92A - 2

gen owntv = Q92B - 2

gen owncar = Q92C - 2

recode ownradio owntv owncar (-1 2=.)

pwcorr ownradio owntv owncar, sig

alpha ownradio owntv owncar

gen mediahome = ownradio + owntv + owncar

recode ownradio owntv owncar (-1 2=.)

gen expradio = Q12A - 2

gen exptv = Q12B - 2

gen exppaper = Q12C - 2

recode expradio exptv exppaper (-1 5=.)

pwcorr expradio exptv exppaper, sig

alpha expradio exptv exppaper

gen exposure = (expradio + exptv + exppaper)/4

gen interest = Q13 - 2

recode interest (-1 4=.)

gen discussion = Q14 - 2

recode discussion (-1 3=.)

gen housewife = Q94

recode housewife (2 3=1) (1 8=.) (4 5 6 7=0)

gen woman_housewife = woman*housewife

gen headhouse = Q2

recode headhouse (2=0) (3=1) (1 4=.)

gen dependent = 1 - headhouse

gen woman_dependent = woman*dependent

gen member = Q41A2

gen minister = Q41B2

recode member minister (1=.) (2 3 5=0) (4=1)

pwcorr member minister, sig

alpha member minister

gen knowledge = (member + minister)*50

gen member2 = Q41A2

gen minister2 = Q41B2

recode member2 minister2 (1=.) (2 5=0) (3=1) (4=2)

gen intsex = Q112

recode intsex (2=1) (3=0)

gen withinwt = Withinwt


**** ANALYSES

*** Benin

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1, base(2)



*** Botswana

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==2

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==2

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==2, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==2

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==2

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==1, base(2)


*** Burkina Faso

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==3

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==3

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==3, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==3

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==3

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==3, base(2)


*** Cape Verde

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==4

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==4

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==4, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==4

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==4

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==4, base(2)



*** Ghana

*member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==5

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==5

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==5, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==5

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==5

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==5, base(2)


*** Kenya

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==6

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==6

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==6, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==6

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==6

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==6, base(2)


*** Lesotho

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==7

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==7

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==7, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==7

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==7

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==7, base(2)



*** Liberia

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==8

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==8

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==8, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==8

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==8

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==8, base(2)


*** Madagascar

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==9

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==9

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==9, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==9

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==9

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==9, base(2)


*** Malawi

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==10

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==10

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==10, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==10

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==10

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==10, base(2)



*** Mali

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==11

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==11

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==11, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==11

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==11

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==11, base(2)


*** Mozambique

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==12

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==12

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==12, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==12

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==12

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==12, base(2)


*** Namibia

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==13

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==13

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==13, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==13

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==13

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==13, base(2)



*** Nigeria

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==14

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==14

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==14, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==14

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==14

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==14, base(2)



*** Senegal

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==15

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==15

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==15, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==15

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==15

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==15, base(2)



*** South Africa

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==16

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==16

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==16, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==16

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==16

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==16, base(2)



*** Tanzania

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==17

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==17

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==17, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==17

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==17

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==17, base(2)



***Uganda

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==18

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==18

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==18, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==18

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==18

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==18, base(2)



***Zambia

* member

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==19

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==19

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==19, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==19

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==19

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==19, base(2)



***Zimbabwe

khb probit member man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==20

probit member man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==20

mlogit member2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==20, base(2)


* minister

khb probit minister man || urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==20

probit minister man urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==20

mlogit minister2 woman urban age age_sq mediahome education interest exposure discussion intsex housewife [pweight = withinwt] if country==20, base(2)



*** item analyses

* "discrimination"

sort country

by country: alpha member minister [aweight=withinwt]

** difficulty

by country: summarize member minister [aweight=withinwt]
