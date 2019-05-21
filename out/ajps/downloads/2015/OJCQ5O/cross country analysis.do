
****************************************************************************
**		File name:	cross country analysis
**		Authors: 	Liran Harsgor, Orit Kedar, Raz Sheinerman
**		Date: 		Final version: June 8 2015
**		Purpose: 	Models for cross country regressions					 							
**		input:		cmeasures.dta
*****************************************************************************

use "cmeasures.dta", clear
capture log using "canalysis.log", replace

* user-written command, used below
ssc install outreg2


*** generate ordinal variables for electoral formulae (four alternative definitions)
* the formulae: largest remider: Hare (01), hagenbach-bischoff/Droop (02)
*		  largest Average: d'Hondt (03), sainte-lague (04), modified sainte-lague (05) 
*		  others:	stv (06) , smd/plurality (07)

* Rae's electoral formula definition
gen rae=.
replace rae=1 if ef==1 | ef==2 
replace rae=2 if ef==03 | ef==04 | ef==05
replace rae=3 if ef== 07

* Lijphart's electoral formula definition
gen lijp=.
replace lijp=1 if ef==01 | ef==4
replace lijp=2 if ef==02 | ef==06 | ef==05
replace lijp=3 if ef==03 
replace lijp=4 if ef==07

* Gallagher's electoral formula definition
gen gal=.
replace gal=1 if ef==01 | ef==4
replace gal=2 if ef==05
replace gal=3 if ef==02
replace gal=4 if ef==06
replace gal=5 if ef==03
replace gal=6 if ef==07

* Benoit's electoral formula definition
gen ben=.
replace ben=1 if ef==04
replace ben=2 if ef==01
replace ben=3 if ef==02
replace ben=4 if ef==05
replace ben=5 if ef==03
replace ben=6 if ef==07

* dummy for STV 
gen stv=0
replace stv=1 if ef==06

* dummy for SMD 
gen smd=0
replace smd=1 if ef==07


*******************************************************
*************** Models 1-12 for Table 1 *****************
*******************************************************
* model 1:
reg gini 		avglndm stv lijp 
outreg2  using Table1.doc, se dec(2)   
* model 2:
reg gini pdmst7	avglndm stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 3:
reg gini pdmst5	avglndm stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 4:
reg gini pdmst3	avglndm stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 5:
reg gini 		medlndm stv lijp
outreg2  using Table1.doc, se append dec(2)
* model 6:
reg gini pdmst7	medlndm stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 7:
reg gini pdmst5	medlndm stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 8:
reg gini pdmst3	medlndm stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 9:
reg gini 		lnmedleg stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 10:
reg gini pdmst7	lnmedleg stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 11:
reg gini pdmst5	lnmedleg stv lijp 
outreg2  using Table1.doc, se append dec(2)
* model 12:
reg gini pdmst3	lnmedleg stv lijp 
outreg2  using Table1.doc, se append dec(2)

* robustness checks (Footnote 19):
* models 1-4 with ln(average DM)
* models 5-8 with ln(median DM)

* model 1:
reg gini 		lnavgdm stv lijp 
outreg2  using cross_cntry1.doc, se dec(2)   
* model 2:
reg gini pdmst7	lnavgdm stv lijp 
outreg2  using cross_cntry1.doc, se append dec(2)
* model 3:
reg gini pdmst5	lnavgdm stv lijp 
outreg2  using cross_cntry1.doc, se append dec(2)
* model 4:
reg gini pdmst3	lnavgdm stv lijp 
outreg2  using cross_cntry1.doc, se append dec(2)
* model 5:
reg gini 		lnmeddm stv lijp
outreg2  using cross_cntry1.doc, se append dec(2)
* model 6:
reg gini pdmst7	lnmeddm stv lijp 
outreg2  using cross_cntry1.doc, se append dec(2)
* model 7:
reg gini pdmst5	lnmeddm stv lijp 
outreg2  using cross_cntry1.doc, se append dec(2)
* model 8:
reg gini pdmst3	lnmeddm stv lijp 
outreg2  using cross_cntry1.doc, se append dec(2)


*******************************************************
*************** robustness checks  ********************
*******************************************************

* electoral formulae

reg gini pdmst7	lnmedleg  	   
reg gini pdmst7	lnmedleg rae   
reg gini pdmst7	lnmedleg lijp   
reg gini pdmst7	lnmedleg gal   
reg gini pdmst7	lnmedleg ben   

reg gini pdmst5	lnmedleg       
reg gini pdmst5	lnmedleg rae   
reg gini pdmst5	lnmedleg lijp   
reg gini pdmst5	lnmedleg gal   
reg gini pdmst5	lnmedleg ben   

reg gini pdmst3	lnmedleg       
reg gini pdmst3	lnmedleg rae   
reg gini pdmst3	lnmedleg lijp   
reg gini pdmst3	lnmedleg gal   
reg gini pdmst3	lnmedleg ben   


* smd & electoral formulae

reg gini pdmst7	lnmedleg smd       
reg gini pdmst7	lnmedleg smd rae   
reg gini pdmst7	lnmedleg smd lijp   
reg gini pdmst7	lnmedleg smd gal   
reg gini pdmst7	lnmedleg smd ben   

reg gini pdmst5	lnmedleg smd      
reg gini pdmst5	lnmedleg smd rae   
reg gini pdmst5	lnmedleg smd lijp   
reg gini pdmst5	lnmedleg smd gal   
reg gini pdmst5	lnmedleg smd ben   

reg gini pdmst3	lnmedleg smd      
reg gini pdmst3	lnmedleg smd rae   
reg gini pdmst3	lnmedleg smd lijp   
reg gini pdmst3	lnmedleg smd gal   
reg gini pdmst3	lnmedleg smd ben   

* STV & electoral formulae

reg gini pdmst7	lnmedleg stv 	   
reg gini pdmst7	lnmedleg stv rae   
reg gini pdmst7	lnmedleg stv lijp   
reg gini pdmst7	lnmedleg stv gal   
reg gini pdmst7	lnmedleg stv ben   

reg gini pdmst5	lnmedleg stv 	  
reg gini pdmst5	lnmedleg stv rae   
reg gini pdmst5	lnmedleg stv lijp   
reg gini pdmst5	lnmedleg stv gal   
reg gini pdmst5	lnmedleg stv ben   

reg gini pdmst3	lnmedleg stv 	  
reg gini pdmst3	lnmedleg stv rae   
reg gini pdmst3	lnmedleg stv lijp   
reg gini pdmst3	lnmedleg stv gal   
reg gini pdmst3	lnmedleg stv ben   

* controlling for Malta
gen malta=0
replace malta=1 if country_c==120

reg gini pdmst7	lnmedleg malta 	     
reg gini pdmst7	lnmedleg malta rae   
reg gini pdmst7	lnmedleg malta lijp   
reg gini pdmst7	lnmedleg malta gal   
reg gini pdmst7	lnmedleg malta ben   

reg gini pdmst5	lnmedleg malta 	    
reg gini pdmst5	lnmedleg malta rae   
reg gini pdmst5	lnmedleg malta lijp   
reg gini pdmst5	lnmedleg malta gal   
reg gini pdmst5	lnmedleg malta ben   

reg gini pdmst3	lnmedleg malta 	    
reg gini pdmst3	lnmedleg malta rae   
reg gini pdmst3	lnmedleg malta lijp   
reg gini pdmst3	lnmedleg malta gal   
reg gini pdmst3	lnmedleg malta ben   

** SMD, STV & electoral formulae  ***
reg gini pdmst7	lnmedleg smd stv 	   
reg gini pdmst7	lnmedleg smd stv rae   
reg gini pdmst7	lnmedleg smd stv lijp   
reg gini pdmst7	lnmedleg smd stv gal   
reg gini pdmst7	lnmedleg smd stv ben   

reg gini pdmst5	lnmedleg smd stv 	  
reg gini pdmst5	lnmedleg smd stv rae   
reg gini pdmst5	lnmedleg smd stv lijp   
reg gini pdmst5	lnmedleg smd stv gal   
reg gini pdmst5	lnmedleg smd stv ben   

reg gini pdmst3	lnmedleg smd stv 	  
reg gini pdmst3	lnmedleg smd stv rae   
reg gini pdmst3	lnmedleg smd stv lijp   
reg gini pdmst3	lnmedleg smd stv gal   
reg gini pdmst3	lnmedleg smd stv ben   

* malapportiomnet & electoral formulae

reg gini pdmst7	lnmedleg malap       
reg gini pdmst7	lnmedleg malap rae   
reg gini pdmst7	lnmedleg malap lijp   
reg gini pdmst7	lnmedleg malap gal   
reg gini pdmst7	lnmedleg malap ben   

reg gini pdmst5	lnmedleg malap      
reg gini pdmst5	lnmedleg malap rae   
reg gini pdmst5	lnmedleg malap lijp   
reg gini pdmst5	lnmedleg malap gal   
reg gini pdmst5	lnmedleg malap ben   

reg gini pdmst3	lnmedleg malap      
reg gini pdmst3	lnmedleg malap rae   
reg gini pdmst3	lnmedleg malap lijp   
reg gini pdmst3	lnmedleg malap gal   
reg gini pdmst3	lnmedleg malap ben   


**** districted PR only, with STV/electoral formulae ***

reg gini pdmst7	lnmedleg stv 	 if ctry_dpr==1
reg gini pdmst5	lnmedleg stv 	 if ctry_dpr==1
reg gini pdmst3	lnmedleg stv 	 if ctry_dpr==1

reg gini pdmst7	lnmedleg rae	 if ctry_dpr==1
reg gini pdmst7	lnmedleg lijp	 if ctry_dpr==1
reg gini pdmst7	lnmedleg gal	 if ctry_dpr==1
reg gini pdmst7	lnmedleg ben	 if ctry_dpr==1

reg gini pdmst5	lnmedleg rae	 if ctry_dpr==1
reg gini pdmst5	lnmedleg lijp	 if ctry_dpr==1
reg gini pdmst5	lnmedleg gal	 if ctry_dpr==1
reg gini pdmst5	lnmedleg ben	 if ctry_dpr==1

reg gini pdmst3	lnmedleg rae	 if ctry_dpr==1
reg gini pdmst3	lnmedleg lijp	 if ctry_dpr==1
reg gini pdmst3	lnmedleg gal	 if ctry_dpr==1
reg gini pdmst3	lnmedleg ben	 if ctry_dpr==1

reg gini pdmst7	lnmedleg stv rae	 if ctry_dpr==1
reg gini pdmst7	lnmedleg stv lijp	 if ctry_dpr==1
reg gini pdmst7	lnmedleg stv gal	 if ctry_dpr==1
reg gini pdmst7	lnmedleg stv ben	 if ctry_dpr==1

reg gini pdmst5	lnmedleg stv rae	 if ctry_dpr==1
reg gini pdmst5	lnmedleg stv lijp	 if ctry_dpr==1
reg gini pdmst5	lnmedleg stv gal	 if ctry_dpr==1
reg gini pdmst5	lnmedleg stv ben	 if ctry_dpr==1

reg gini pdmst3	lnmedleg stv rae	 if ctry_dpr==1
reg gini pdmst3	lnmedleg stv lijp	 if ctry_dpr==1
reg gini pdmst3	lnmedleg stv gal	 if ctry_dpr==1
reg gini pdmst3	lnmedleg stv ben	 if ctry_dpr==1


* omitting Malta (120=Malta)

reg gini pdmst7		lnmedleg     if ctry_dpr==1 & country_c!=120 
reg gini pdmst7		lnmedleg rae if ctry_dpr==1 & country_c!=120 
reg gini pdmst7		lnmedleg lijp if ctry_dpr==1 & country_c!=120 
reg gini pdmst7		lnmedleg gal if ctry_dpr==1 & country_c!=120 
reg gini pdmst7		lnmedleg ben if ctry_dpr==1 & country_c!=120 

reg gini pdmst5		lnmedleg     if ctry_dpr==1 & country_c!=120 
reg gini pdmst5		lnmedleg rae if ctry_dpr==1 & country_c!=120 
reg gini pdmst5		lnmedleg lijp if ctry_dpr==1 & country_c!=120 
reg gini pdmst5		lnmedleg gal if ctry_dpr==1 & country_c!=120 
reg gini pdmst5		lnmedleg ben if ctry_dpr==1 & country_c!=120 

reg gini pdmst3		lnmedleg     if ctry_dpr==1 & country_c!=120 
reg gini pdmst3		lnmedleg rae if ctry_dpr==1 & country_c!=120 
reg gini pdmst3		lnmedleg lijp if ctry_dpr==1 & country_c!=120 
reg gini pdmst3		lnmedleg gal if ctry_dpr==1 & country_c!=120 
reg gini pdmst3		lnmedleg ben if ctry_dpr==1 & country_c!=120 


*** Cutoffs Robustness Analysis (Figure A2)
reg gini 			avglndm stv lijp  
reg gini pdmst2		avglndm stv lijp  
reg gini pdmst3		avglndm stv lijp  
reg gini pdmst4		avglndm stv lijp  
reg gini pdmst5		avglndm stv lijp  
reg gini pdmst6		avglndm stv lijp  
reg gini pdmst7		avglndm stv lijp  
reg gini pdmst8		avglndm stv lijp  
reg gini pdmst9		avglndm stv lijp  
reg gini pdmst10	avglndm stv lijp  
reg gini pdmst11	avglndm stv lijp  
reg gini pdmst12	avglndm stv lijp  




log close
