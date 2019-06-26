use "C:\Users\mmousseau\Documents\Ifolder\Publications and Datasets\JPR Terror\For Replication\Pew data 2002.dta", clear

* tab q80: How often do you pray?

g IREL=.
replace IREL=7 if q80==1
replace IREL=6 if q80==2
replace IREL=5 if q80==3
replace IREL=4 if q80==4
replace IREL=3 if q80==5
replace IREL=2 if q80==6
replace IREL=1 if q80==7

g IRELsq= IREL^2
g IRELln=ln(IREL)

gen EDUC = .
replace EDUC= q84ban if q84ban <=9
replace EDUC= q84ind if q84ind <=9
replace EDUC= q84tur if q84tur <=9
replace EDUC= q84mal if q84mal <=9
replace EDUC= q84sen if q84sen <=9
replace EDUC= q84uzb if q84uzb <=9
replace EDUC= q84ivo if q84ivo <=9
replace EDUC= q84jor if q84jor <=9
replace EDUC= q84leb if q84leb <=9
replace EDUC= q84tan if q84tan <=9
replace EDUC= q84uga if q84uga <=9

replace EDUC=4 if EDUC==6
replace EDUC=5 if EDUC==7
replace EDUC=6 if EDUC==8
replace EDUC=7 if EDUC==9

replace q84gha = . if q84gha > 9
replace EDUC=1 if q84gha==1
replace EDUC=2 if q84gha==2
replace EDUC=3 if q84gha==3
replace EDUC=4 if q84gha==4
replace EDUC=5 if q84gha==5
replace EDUC=4 if q84gha==6
replace EDUC=5 if q84gha==7
replace EDUC=6 if q84gha==8
replace EDUC=7 if q84gha==9

replace q84nig = . if q84nig > 13
replace EDUC=1 if q84nig==1
replace EDUC=2 if q84nig==2
replace EDUC=3 if q84nig==3
replace EDUC=4 if q84nig==4
replace EDUC=5 if q84nig==5
replace EDUC=4 if q84nig==6
replace EDUC=5 if q84nig==7
replace EDUC=5.5 if q84nig==8
replace EDUC=6 if q84nig==9
replace EDUC=5.5 if q84nig==10
replace EDUC=6 if q84nig==11
replace EDUC=6.5 if q84nig==12
replace EDUC=7 if q84nig==13

replace q84pak = . if q84pak > 8
replace EDUC=1 if q84pak==1
replace EDUC=1.5 if q84pak==2
replace EDUC=2 if q84pak==3
replace EDUC=3 if q84pak==4
replace EDUC=4 if q84pak==5
replace EDUC=5 if q84pak==6
replace EDUC=6 if q84pak==7
replace EDUC=7 if q84pak==8

gen EDUCsq= EDUC^2
gen EDUCln=ln(EDUC)

*Poverty

gen FOODPR=0 if q87a ~=. & q87a ~=3 & q87a ~=4
replace FOODPR =1 if q87a ==1
gen MEDPR=0 if q87b ~=.  & q87b ~=3 & q87b ~=4
replace MEDPR =1 if q87b ==1
gen CLTHPR=0 if q87c ~=. & q87c ~=3 & q87c ~=4
replace CLTHPR =1 if q87c ==1
gen ELECPR=0 if q89a ~=.  & q89a ~=3 & q89a ~=4
replace ELECPR =1 if q89a ==2
gen WATRPR=0 if q89c ~=. & q89c ~=3 & q89c ~=4
replace WATRPR =1 if q89c ==2
gen TOILPR=0 if q89d ~=. & q89d ~=3 & q89d ~=4
replace TOILPR =1 if q89d ==2

gen POV = ELECPR + WATRPR + TOILPR + FOODPR + MEDPR + CLTHPR
gen POVln=ln(POV+1)
gen POVsq= POV^2

*Dissatisfaction
gen DISATINC= q6a if q6a < 5 &  q6a ~=.
gen DSTINCsq= DISATINC^2
gen DSTINCln=ln(DISATINC)

gen URB=0 if q97~=.
replace URB=1 if q97==8 & q97~=. 
replace URB=. if q97==9 | q97==10
g URBPOV=URB*POV

*Countries
gen BAN = 1 if country==3 
gen GHA = 1 if country==14
gen IND = 1 if country==18
gen IVO = 1 if country==9 
gen JOR = 1 if country==45
gen LEB = 1 if country==44
gen MAL = 1 if country==23
gen NIG = 1 if country==26
gen PAK = 1 if country==27
gen SEN = 1 if country==32
gen TAN = 1 if country==35
gen TUR = 1 if country==36
gen UGA = 1 if country==37
gen UZB = 1 if country==41
replace BAN=0 if country~=3 
replace GHA=0 if country~=14
replace IND=0 if country~=18
replace IVO=0 if country~= 9
replace JOR=0 if country~=45
replace LEB=0 if country~=44
replace MAL=0 if country~=23
replace NIG=0 if country~=26
replace PAK=0 if country~=27
replace SEN=0 if country~=32
replace TAN=0 if country~=35
replace TUR=0 if country~=36
replace UGA=0 if country~=37
replace UZB=0 if country~=41

*Y var
gen OTERRJST = .
replace OTERRJST = 4 if q55==1
replace OTERRJST = 3 if q55==2
replace OTERRJST = 2 if q55==3
replace OTERRJST = 1 if q55==4

g mALL=0
g mIREL=0
g mEDUC=0
g mPOV=0
g mDISATINC=0
g mURBPOV=0
g mDISSATPOV=0
replace mALL 		=1 if  OTERRJST*						IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
replace mIREL 		=1 if  OTERRJST*IREL* 					IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
replace mEDUC 		=1 if  OTERRJST*EDUC*					IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
replace mPOV 		=1 if  OTERRJST*POV*					IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
replace mDISATINC 	=1 if  OTERRJST*DISATINC*				IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
replace mURBPOV 	=1 if  OTERRJST*URBPOV*				IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
replace mDISSATPOV	=1 if  OTERRJST*DISATINC*POV*			IND*MAL*PAK*BAN*SEN*TUR*UZB*GHA*IVO*JOR*LEB*NIG*TAN*UGA~=.
tab country if mALL==1
tab country if mIREL==1
tab country if mEDUC==1
tab country if mPOV==1
tab country if mDISATINC==1
tab country if mURBPOV==1
tab country if mDISSATPOV==1

g wALL=.
g wIREL=.
g wEDUC=.
g wPOV=.
g wDISATINC=.
g wURBPOV=.
g wDISSATPOV=.

replace wALL=(1-0.0682)*weight if country==3
replace wALL=(1-0.0112)*weight if country==9
replace wALL=(1-0.0107)*weight if country==14
replace wALL=(1-0.1144)*weight if country==18
replace wALL=(1-0.0748)*weight if country==23
replace wALL=(1-0.04)*weight if country==26
replace wALL=(1-0.2002)*weight if country==27
replace wALL=(1-0.081)*weight if country==32
replace wALL=(1-0.0289)*weight if country==35
replace wALL=(1-0.1066)*weight if country==36
replace wALL=(1-0.0138)*weight if country==37
replace wALL=(1-0.0707)*weight if country==41
replace wALL=(1-0.0697)*weight if country==44
replace wALL=(1-0.1098)*weight if country==45

replace wIREL=(1-0.0861)*weight if country==3
replace wIREL=(1-0.0142)*weight if country==9
replace wIREL=(1-0.0136)*weight if country==14
replace wIREL=(1-0.145)*weight if country==18
replace wIREL=(1-0.0951)*weight if country==23
replace wIREL=(1-0.0508)*weight if country==26
replace wIREL=(1-0.2525)*weight if country==27
replace wIREL=(1-0.1029)*weight if country==32
replace wIREL=(1-0.1333)*weight if country==36
replace wIREL=(1-0.0173)*weight if country==37
replace wIREL=(1-0.0892)*weight if country==41

replace wEDUC=(1-0.0683)*weight if country==3
replace wEDUC=(1-0.0112)*weight if country==9
replace wEDUC=(1-0.0106)*weight if country==14
replace wEDUC=(1-0.1146)*weight if country==18
replace wEDUC=(1-0.0747)*weight if country==23
replace wEDUC=(1-0.0401)*weight if country==26
replace wEDUC=(1-0.2002)*weight if country==27
replace wEDUC=(1-0.081)*weight if country==32
replace wEDUC=(1-0.0289)*weight if country==35
replace wEDUC=(1-0.1068)*weight if country==36
replace wEDUC=(1-0.0139)*weight if country==37
replace wEDUC=(1-0.0708)*weight if country==41
replace wEDUC=(1-0.069)*weight if country==44
replace wEDUC=(1-0.11)*weight if country==45

replace wPOV=(1-0.0684)*weight if country==3
replace wPOV=(1-0.0113)*weight if country==9
replace wPOV=(1-0.0103)*weight if country==14
replace wPOV=(1-0.1153)*weight if country==18
replace wPOV=(1-0.0751)*weight if country==23
replace wPOV=(1-0.0402)*weight if country==26
replace wPOV=(1-0.1972)*weight if country==27
replace wPOV=(1-0.0815)*weight if country==32
replace wPOV=(1-0.0291)*weight if country==35
replace wPOV=(1-0.106)*weight if country==36
replace wPOV=(1-0.014)*weight if country==37
replace wPOV=(1-0.0712)*weight if country==41
replace wPOV=(1-0.07)*weight if country==44
replace wPOV=(1-0.1105)*weight if country==45

replace wDISATINC=(1-0.0683)*weight if country==3
replace wDISATINC=(1-0.0113)*weight if country==9
replace wDISATINC=(1-0.0102)*weight if country==14
replace wDISATINC=(1-0.115)*weight if country==18
replace wDISATINC=(1-0.075)*weight if country==23
replace wDISATINC=(1-0.04)*weight if country==26
replace wDISATINC=(1-0.1994)*weight if country==27
replace wDISATINC=(1-0.0814)*weight if country==32
replace wDISATINC=(1-0.0288)*weight if country==35
replace wDISATINC=(1-0.1068)*weight if country==36
replace wDISATINC=(1-0.0137)*weight if country==37
replace wDISATINC=(1-0.0711)*weight if country==41
replace wDISATINC=(1-0.0688)*weight if country==44
replace wDISATINC=(1-0.1102)*weight if country==45

replace wURBPOV=(1-0.0845)*weight if country==3
replace wURBPOV=(1-0.0158)*weight if country==9
replace wURBPOV=(1-0.0087)*weight if country==14
replace wURBPOV=(1-0.1248)*weight if country==18
replace wURBPOV=(1-0.1038)*weight if country==23
replace wURBPOV=(1-0.0562)*weight if country==26
replace wURBPOV=(1-0.2224)*weight if country==27
replace wURBPOV=(1-0.1134)*weight if country==32
replace wURBPOV=(1-0.0226)*weight if country==35
replace wURBPOV=(1-0.1481)*weight if country==36
replace wURBPOV=(1-0.0996)*weight if country==41

replace wDISSATPOV=(1-0.0685)*weight if country==3
replace wDISSATPOV=(1-0.0114)*weight if country==9
replace wDISSATPOV=(1-0.0098)*weight if country==14
replace wDISSATPOV=(1-0.1158)*weight if country==18
replace wDISSATPOV=(1-0.0753)*weight if country==23
replace wDISSATPOV=(1-0.0401)*weight if country==26
replace wDISSATPOV=(1-0.1966)*weight if country==27
replace wDISSATPOV=(1-0.0818)*weight if country==32
replace wDISSATPOV=(1-0.029)*weight if country==35
replace wDISSATPOV=(1-0.1061)*weight if country==36
replace wDISSATPOV=(1-0.0138)*weight if country==37
replace wDISSATPOV=(1-0.0716)*weight if country==41
replace wDISSATPOV=(1-0.0692)*weight if country==44
replace wDISSATPOV=(1-0.1108)*weight if country==45

gen conALL =1 if mALL==1
egen pwALL = sum(conALL), by(country)
gen conIREL =1 if mIREL==1
egen pwIREL = sum(conIREL), by(country)
gen conEDUC =1 if mEDUC==1
egen pwEDUC = sum(conEDUC), by(country)
gen conPOV =1 if mPOV==1
egen pwPOV = sum(conPOV), by(country)
gen conDISATINC =1 if mDISATINC==1
egen pwDISATINC = sum(conDISATINC), by(country)
gen conURBPOV =1 if mURBPOV==1
egen pwURBPOV = sum(conURBPOV), by(country)
gen conDISSATPOV =1 if mDISSATPOV==1
egen pwDISSATPOV = sum(conDISSATPOV), by(country)


tab q55 if OTERRJST~=.


sum IREL EDUC DISATINC POV URB if OTERRJST~=.
corr IREL EDUC DISATINC POV URB if OTERRJST~=.


gen IRELmiss=1 if  JOR==1 |  LEB==1 |  TAN==1
tab  OTERRJST if  IRELmiss~=1
sum  IREL if OTERRJST~=. &  IRELmiss~=1

gen URBmiss=1 if  JOR==1 |  LEB==1 |  UGA==1
tab  OTERRJST if  URBmiss~=1
sum  URB if OTERRJST~=. &  URBmiss~=1



*TAB 1 _ GHA in intercept


ologit OTERRJST IREL 					BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wIREL], cl(pwIREL)
ologit OTERRJST EDUC 					BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wEDUC], cl(pwEDUC)
ologit OTERRJST DISATINC 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wDISATINC], cl(pwDISATINC)
ologit OTERRJST POV 					BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wPOV], cl(pwPOV)
ologit OTERRJST POV URB URBPOV 		    BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wURBPOV], cl(pwURBPOV)

ologit OTERRJST IRELln 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wIREL], cl(pwIREL)
ologit OTERRJST IRELsq 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wIREL], cl(pwIREL)
ologit OTERRJST EDUCln 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wEDUC], cl(pwEDUC)
ologit OTERRJST EDUCsq 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wEDUC], cl(pwEDUC)
ologit OTERRJST DSTINCln 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wDISATINC], cl(pwDISATINC)
ologit OTERRJST DSTINCsq 				BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wDISATINC], cl(pwDISATINC)
ologit OTERRJST DISATINC POV 			BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wDISSATPOV], cl(pwDISSATPOV)
ologit OTERRJST POVln 					BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wPOV], cl(pwPOV)
ologit OTERRJST POVsq 					BAN IND IVO JOR LEB MAL NIG PAK SEN TAN TUR UGA UZB [pw=wPOV], cl(pwPOV)
