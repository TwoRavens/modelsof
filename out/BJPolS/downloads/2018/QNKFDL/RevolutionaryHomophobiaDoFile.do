/*Do File for "Revolutionary Homophobia: Explaining State Repression of 
Sexual Minorities"*/

****************************
*****Main Text Results******
****************************


**Figure 2**
logit dvon revlead ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country) 
estimates store m1
logit dvon revlead civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)	
estimates store m2

coefplot m1 m2, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) ///
	levels(99 95) 
	
**Figure 3**
logit dvon idrev noidrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store m3
logit dvon idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store m4

coefplot m3 m4, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)


**Figure 4**
logit dvon personrev nonpersonrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store m5
logit dvon personrev nonpersonrev civilwar iswar leg_british muslim dem ///
	 flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store m6

coefplot m5 m6, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

	
**Figure 5**
logit dvon idrev noidrev excludeonly ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store m7
logit dvon idrev noidrev excludeonly civilwar iswar leg_british muslim dem ///
	 flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store m8

coefplot m7 m8, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)	
	
**Table 1**
logit dvon revlead ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country) 
estimates store t1
logit dvon revlead civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)	
estimates store t2
logit dvon idrev noidrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store t3
logit dvon idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store t4
logit dvon personrev nonpersonrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store t5
logit dvon personrev nonpersonrev civilwar iswar leg_british muslim dem ///
	 flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store t6
logit dvon excludeonly ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store t7
logit dvon excludeonly civilwar iswar leg_british muslim dem ///
	 flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store t8

esttab t1 t2 t3 t4 t5 t6 t7 t8, se


****************
****Appendix****
****************


//Figure A1
logit dv revlead t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country) 
estimates store a1
logit dv revlead civilwar iswar leg_british muslim dem ///
	flgdpen tpop t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)	
estimates store a2

coefplot a1 a2, xline(0) drop(t1 t2 t3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95) 

//Figure A2
logit dv idrev noidrev t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a3
logit dv idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a4

coefplot a3 a4, xline(0) drop(t1 t2 t3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A3

logit dv personrev nonpersonrev t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a5
logit dv personrev nonpersonrev civilwar iswar leg_british muslim dem ///
	coldwar flgdpen tpop t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a6

coefplot a5 a6, xline(0) drop(t1 t2 t3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A4
logit dv idrev noidrev excludeonly t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a7
logit dvon idrev noidrev excludeonly civilwar iswar leg_british muslim dem ///
	 flgdpen tpop t1 t2 t3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a8

coefplot a7 a8, xline(0) drop(t1 t2 t3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figures A5
logit dvon revlead civilwar iswar leg_british muslim dem irregulartransition ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)	

coefplot, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figures A6
logit dvon revlead personal party military monarch civilwar iswar ///
	leg_british muslim flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)  

coefplot, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A7
firthlogit dvon revlead ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a11
firthlogit dvon revlead civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a12

coefplot a11 a12, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)


//Figure A8
firthlogit dvon idrev noidrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a13
firthlogit dvon idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a14

coefplot a13 a14, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A9
firthlogit dvon personrev nonpersonrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a15
firthlogit dvon personrev nonpersonrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a16

coefplot a15 a16, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A10
firthlogit dvon idrev noidrev excludeonly ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a17
firthlogit dvon idrev noidrev excludeonly civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00
estimates store a18

coefplot a17 a18, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)


//Figure A11
logit dvon revlead ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce (jackknife, cluster(country))
estimates store a19
logit dvon revlead civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce(jackknife, cluster(country))	
estimates store a20

coefplot a19 a20, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A12
logit dvon idrev noidrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce(jackknife, cluster(country))
estimates store a21
logit dvon idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce(jackknife, cluster(country))
estimates store a22

coefplot a21 a22, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A13
logit dvon personrev nonpersonrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce(jackknife, cluster(country))
estimates store a23
logit dvon personrev nonpersonrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce(jackknife, cluster(country))
estimates store a24

coefplot a23 a24, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A14
logit dvon idrev noidrev excludeonly ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, ///
	vce(jackknife, cluster(country))
estimates store a25
logit dvon idrev noidrev excludeonly civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, vce(jackknife, cluster(country))
estimates store a26

coefplot a25 a26, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A15
mi set mlong
mi register imputed flgdpen muslim polity2 tpop
mi register regular dv dvon revlead civilwar iswar leg_british ///
	dem coldwar year military party personal monarch tenure cinc country
mi impute mvn flgdp muslim polity2 tpop = dv dvon revlead civilwar ///
	military iswar leg_british dem coldwar year party personal monarch ///
	tenure, add(10)
	
mi estimate: logit dvon revlead ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country) 
estimates store a27

mi estimate: logit dvon revlead civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)	
estimates store a28

coefplot a27 a28, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A16
mi estimate: logit dvon idrev noidrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a29

mi estimate: logit dvon idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a30

coefplot a29 a30, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A17
mi estimate: logit dvon personrev nonpersonrev ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a31
mi estimate: logit dvon personrev nonpersonrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a32

coefplot a31 a32, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)

//Figure A18
mi estimate: logit dvon idrev noidrev excludeonly ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a33
mi estimate: logit dvon idrev noidrev civilwar iswar leg_british muslim dem ///
	flgdpen tpop ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00, robust cluster(country)
estimates store a34

coefplot a33 a34, xline(0) drop(ton1 ton2 ton3 d40 d50 d60 d70 d80 d90 d00 _cons) levels(99 95)
