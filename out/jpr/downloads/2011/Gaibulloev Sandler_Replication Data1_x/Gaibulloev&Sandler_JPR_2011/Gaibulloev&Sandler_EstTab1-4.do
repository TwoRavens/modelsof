*** Use Gaibulloev&Sandler_JPR2011 data

****************************************
****	Replication of Table I		****
****************************************

**** Generate new variables
	tsset id year
	gen ly=log(rgdp)
	by id: gen ly0=L.ly
	by id: gen gr=D1.ly
	gen linv=(investsh/100) 
	gen llinv=L.linv
	gen tpc=(ter*1000000)/pop
	replace tpc=ter if ter==0 & pop==. /* should be zero nomatter what is pop */
	gen cw=intcon
	gen ic=extcon

**** Estimate models 1-4
	xi i.year
	xtscc gr ly0 llinv tpc ic cw _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttpc ic cw _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtpc ic cw _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttpc dtpc ic cw _I*, fe
	est store csd4
		est table *, b se p stats(N r2_w) keep(ly0 llinv tpc ttpc dtpc cw ic)

**** Perorm tests for CSD
	xtreg gr ly0 llinv tpc cw ic _I*, fe rob
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	xtreg gr ly0 llinv ttpc cw ic _I*, fe rob
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	xtreg gr ly0 llinv dtpc cw ic _I*, fe rob
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	xtreg gr ly0 llinv ttpc dtpc cw ic _I*, fe rob
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))


****************************************
****	Replication of Table II		****
****************************************

**** Generate new variables	
	gen trsh=expsh+impsh
	gen ltr=(trsh/100)
	by id: gen lltr=L.ltr
	gen lgc=(govcsh/100)
	by id: gen llgc=L.lgc
	gen lpop =log(pop)
	by id: gen n=D1.lpop

**** Estimate models 1-4
	estimates clear
	xtscc gr ly0 llinv tpc llgc lltr ic cw polity2 n _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttpc llgc lltr ic cw polity2 n _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtpc llgc lltr ic cw polity2 n _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttpc dtpc llgc lltr ic cw polity2 n _I*, fe
	est store csd4
		est table *, b se p stats(N r2_w) ///
		keep(ly0 llinv llgc lltr tpc ttpc dtpc cw ic polity2 n)

**** Perorm tests for CSD
	xtreg gr ly0 llinv tpc llgc lltr ic cw polity2 n _I*, fe
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	xtreg gr ly0 llinv ttpc llgc lltr ic cw polity2 n _I*, fe
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	xtreg gr ly0 llinv dtpc llgc lltr ic cw polity2 n _I*, fe
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	xtreg gr ly0 llinv ttpc dtpc llgc lltr ic cw polity2 n _I*, fe
	xtcsd, pesaran abs 
	di 2*(1-normal(abs(r(pesaran))))
	
	
****************************************
****	Replication of Table III	****
****************************************

**** Robustness 1: Using unadjusted GTD data 
	
**** Generate new variables
	gen ttuadpc=(tter*1000000)/pop
	replace ttuadpc=tter if tter==0 & pop==. /* should be zero nomatter what is pop */
	gen dtuadpc=(dter*1000000)/pop
	replace dtuadpc=dter if dter==0 & pop==. /* should be zero nomatter what is pop */
	
**** Estimate models 1-4	
	estimates clear
	xtscc gr ly0 llinv tpc llgc lltr ic cw polity2 n _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttuadpc llgc lltr ic cw polity2 n _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtuadpc llgc lltr ic cw polity2 n _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttuadpc dtuadpc llgc lltr ic cw polity2 n _I*, fe
	est store csd4
		est table *, b se p keep(tpc ttuadpc dtuadpc)

		
**** Robustness 2: Estimate models 1-4 using number of terrorist incidents
	estimates clear
	xtscc gr ly0 llinv ter llgc lltr ic cw polity2 n _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttadj llgc lltr ic cw polity2 n _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtadj llgc lltr ic cw polity2 n _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttadj dtadj llgc lltr ic cw polity2 n _I*, fe
	est store csd4
		est table *, b se p keep(ter ttadj dtadj)


**** Robustness 3: Using dummy variable for terrorism 
	
**** Generate new variables
	gen td=1 if ter>0 & ter!=.
	replace td=0 if ter==0
	gen ttd=1 if ttadj>0 & ttadj!=.
	replace ttd=0 if ttadj==0
	gen dtd=1 if dtadj>0 & dtadj!=.
	replace dtd=0 if dtadj==0
		
**** Estimate models 1-4	
	estimates clear
	xtscc gr ly0 llinv td llgc lltr ic cw polity2 n _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttd llgc lltr ic cw polity2 n _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtd llgc lltr ic cw polity2 n _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttd dtd llgc lltr ic cw polity2 n _I*, fe
	est store csd4
		est table *, b se p keep(td ttd dtd)
		

**** Robustness 4: Using lagged value of terrorist attacks per million pop
 
**** Generate new variables
	by id: gen tpcl=L.tpc
	by id: gen ttpcl=L.ttpc
	by id: gen dtpcl=L.dtpc

**** Estimate models 1-4
	estimates clear
	xtscc gr ly0 llinv tpcl llgc lltr ic cw polity2 n _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttpcl llgc lltr ic cw polity2 n _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtpcl llgc lltr ic cw polity2 n _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttpcl dtpcl llgc lltr ic cw polity2 n _I*, fe
	est store csd4
		est table *, b se p keep(tpcl ttpcl dtpcl)


****************************************
****	Replication of Table IV		****
****************************************

**** Generate new variables
	gen cwtpc=cw*tpc
	gen cwttpc=cw*ttpc
	gen cwdtpc=cw*dtpc
	gen ictpc=ic*tpc
	gen icttpc=ic*ttpc
	gen icdtpc=ic*dtpc
	
**** Estimate models 1-4
	estimates clear
	xtscc gr ly0 llinv tpc ic cw cwtpc ictpc _I*, fe
	est store csd1
	xtscc gr ly0 llinv ttpc ic cw cwttpc icttpc _I*, fe
	est store csd2
	xtscc gr ly0 llinv dtpc ic cw cwdtpc icdtpc _I*, fe
	est store csd3
	xtscc gr ly0 llinv ttpc dtpc ic cw cwttpc cwdtpc icttpc icdtpc _I*, fe
	est store csd4
		est table *, b se p stats(N r2_w) ///
		keep(tpc ttpc dtpc cw ic cwtpc cwttpc cwdtpc ictpc icttpc icdtpc)	
	
	
