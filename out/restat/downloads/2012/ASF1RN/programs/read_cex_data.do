****************************************************************
****   Master DO-file for consumer expenditure survey  *********
****     By Ron Mariutto                                    ****
****                                                        ****
****   This file loads and alters the:                      ****  
****   CU/Income quarterly data w/ cu.do                    ****
****   Expenditures             w/ expend.do                ****
****************************************************************    
set mem 1000m, perm
set more off


************************************
***      Year 2000    (03395)*******

cd "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395"

**Quarter 1 Expenditures
     infile using "DS0003\03395-0003-Setup.dct", using("DS0003\03395-0003-Data.txt")
     do "expend.do"
     save "DS0003\03395-0003-AlteredData.DTA", replace
     clear

**Quarter 1 CU/Income file
     infile using "DS0001\03395-0001-Setup.dct", using("DS0001\03395-0001-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0003\03395-0003-AlteredData.DTA", unmatched(master)
     save "2000Q1.DTA"
     clear
*****************************************
**Quarter 2 Expenditures
     infile using "DS0007\03395-0007-Setup.dct", using("DS0007\03395-0007-Data.txt")
     do "expend.do"
     save "DS0007\03395-0007-AlteredData.DTA", replace
     clear

**Quarter 2 CU/Income file
     infile using "DS0005\03395-0005-Setup.dct", using("DS0005\03395-0005-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0007\03395-0007-AlteredData.DTA", unmatched(master)
     save "2000Q2.DTA"
     clear
*****************************************
**Quarter 3 Expenditures
     infile using "DS0011\03395-0011-Setup.dct", using("DS0011\03395-0011-Data.txt")
     do "expend.do"
     save "DS0011\03395-0011-AlteredData.DTA", replace
     clear

**Quarter 3 CU/Income file
     infile using "DS0009\03395-0009-Setup.dct", using("DS0009\03395-0009-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0011\03395-0011-AlteredData.DTA", unmatched(master)
     save "2000Q3.DTA"
     clear
****************************************
**Quarter 4 Expenditures
     infile using "DS0015\03395-0015-Setup.dct", using("DS0015\03395-0015-Data.txt")
     do "expend.do"
     save "DS0015\03395-0015-AlteredData.DTA", replace
     clear

**Quarter 4 CU/Income file
     infile using "DS0013\03395-0013-Setup.dct", using("DS0013\03395-0013-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0015\03395-0015-AlteredData.DTA", unmatched(master)
     save "2000Q4.DTA", replace

**********************************************************
**********************************************************
****     We now have all 4 quarters of 2000          *****
*       and there are no ID duplicates across qtrs       *
**********************************************************
*      Let's now aggregate daily category purchases in   *
*      each day in the 14day window for each individual  *
*      Consumer Unit.                                    *
**********************************************************
*we will do this by generating 8 aggregation variables.  *
*In each column, for each day, there will be one sum of  *
*expenditures.                                           *
**********************************************************
*** "Aggregation Example 1" in the appendix will help    *
***  clarify the procedure at this point                 *
***                                                      *
**********************************************************
clear
use "2000Q1.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2000Q1agg.dta"
clear
**************************************************************
*****                                                 ********
*****   Since we're only working with these aggregates *******
*****   we drop the variable 'COST' so as to not       *******
*****   accidentally use this partial data             *******
**************************************************************

*************************************************************
** We repeat this procedure for the other quarters     ******
*************************************************************
use "2000Q2.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2000Q2agg.dta"
clear
use "2000Q3.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2000Q3agg.dta"
clear
use "2000Q4.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2000Q4agg.dta"

append using "2000Q3agg.dta"
append using "2000Q2agg.dta"
append using "2000Q1agg.dta"
save "2000Agg.dta"

*********************************************************************

************************************
***      Year 2001    (03675)*******

cd "N:\Evans\2000-2003\10092627\10092627\ICPSR_03675"

**Quarter 1 Expenditures
     infile using "DS0003\03675-0003-Setup.dct", using("DS0003\03675-0003-Data.txt")
     do "expend.do"
     save "DS0003\03675-0003-AlteredData.DTA", replace
     clear

**Quarter 1 CU/Income file
     infile using "DS0001\03675-0001-Setup.dct", using("DS0001\03675-0001-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0003\03675-0003-AlteredData.DTA", unmatched(master)
     save "2001Q1.DTA"
     clear
*****************************************
**Quarter 2 Expenditures
     infile using "DS0007\03675-0007-Setup.dct", using("DS0007\03675-0007-Data.txt")
     do "expend.do"
     save "DS0007\03675-0007-AlteredData.DTA", replace
     clear

**Quarter 2 CU/Income file
     infile using "DS0005\03675-0005-Setup.dct", using("DS0005\03675-0005-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0007\03675-0007-AlteredData.DTA", unmatched(master)
     save "2001Q2.DTA"
     clear
*****************************************
**Quarter 3 Expenditures
     infile using "DS0011\03675-0011-Setup.dct", using("DS0011\03675-0011-Data.txt")
     do "expend.do"
     save "DS0011\03675-0011-AlteredData.DTA", replace
     clear

**Quarter 3 CU/Income file
     infile using "DS0009\03675-0009-Setup.dct", using("DS0009\03675-0009-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0011\03675-0011-AlteredData.DTA", unmatched(master)
     save "2001Q3.DTA"
     clear
****************************************
**Quarter 4 Expenditures
     infile using "DS0015\03675-0015-Setup.dct", using("DS0015\03675-0015-Data.txt")
     do "expend.do"
     save "DS0015\03675-0015-AlteredData.DTA", replace
     clear

**Quarter 4 CU/Income file
     infile using "DS0013\03675-0013-Setup.dct", using("DS0013\03675-0013-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0015\03675-0015-AlteredData.DTA", unmatched(master)
     save "2001Q4.DTA", replace

**********************************************************
**********************************************************
****     We now have all 4 quarters of 2000          *****
*       and there are no ID duplicates across qtrs       *
**********************************************************
*      Let's now aggregate daily category purchases in   *
*      each day in the 14day window for each individual  *
*      Consumer Unit.                                    *
**********************************************************
*we will do this by generating 8 aggregation variables.  *
*In each column, for each day, there will be one sum of  *
*expenditures.                                           *
**********************************************************
*** "Aggregation Example 1" in the appendix will help    *
***  clarify the procedure at this point                 *
***                                                      *
**********************************************************
clear
use "2001Q1.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2001Q1agg.dta"
clear
**************************************************************
*****                                                 ********
*****   Since we're only working with these aggregates *******
*****   we drop the variable 'COST' so as to not       *******
*****   accidentally use this partial data             *******
**************************************************************

*************************************************************
** We repeat this procedure for the other quarters     ******
*************************************************************
use "2001Q2.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2001Q2agg.dta"
clear
use "2001Q3.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2001Q3agg.dta"
clear
use "2001Q4.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2001Q4agg.dta"

append using "2001Q3agg.dta"
append using "2001Q2agg.dta"
append using "2001Q1agg.dta"
save "2001Agg.dta"

*********************************************************************

************************************
***      Year 2002    (03937)*******
set more off
cd "N:\Evans\2000-2003\10092627\10092627\ICPSR_03937"

**Quarter 1 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0003\03937-0003-Data.txt")
     do "expend.do"
     save "DS0003\03937-0003-AlteredData.DTA", replace
     clear

**Quarter 1 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0001\03937-0001-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0003\03937-0003-AlteredData.DTA", unmatched(master)
     save "2002Q1.DTA"
     clear
*****************************************
**Quarter 2 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0007\03937-0007-Data.txt")
     do "expend.do"
     save "DS0007\03937-0007-AlteredData.DTA", replace
     clear

**Quarter 2 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0005\03937-0005-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0007\03937-0007-AlteredData.DTA", unmatched(master)
     save "2002Q2.DTA"
     clear
*****************************************
**Quarter 3 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0011\03937-0011-Data.txt")
     do "expend.do"
     save "DS0011\03937-0011-AlteredData.DTA", replace
     clear

**Quarter 3 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0009\03937-0009-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0011\03937-0011-AlteredData.DTA", unmatched(master)
     save "2002Q3.DTA"
     clear
****************************************
**Quarter 4 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0015\03937-0015-Data.txt")
     do "expend.do"
     save "DS0015\03937-0015-AlteredData.DTA", replace
     clear

**Quarter 4 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0013\03937-0013-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0015\03937-0015-AlteredData.DTA", unmatched(master)
     save "2002Q4.DTA", replace

**********************************************************
**********************************************************
****     We now have all 4 quarters of 2000          *****
*       and there are no ID duplicates across qtrs       *
**********************************************************
*      Let's now aggregate daily category purchases in   *
*      each day in the 14day window for each individual  *
*      Consumer Unit.                                    *
**********************************************************
*we will do this by generating 8 aggregation variables.  *
*In each column, for each day, there will be one sum of  *
*expenditures.                                           *
**********************************************************
*** "Aggregation Example 1" in the appendix will help    *
***  clarify the procedure at this point                 *
***                                                      *
**********************************************************
clear
use "2002Q1.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2002Q1agg.dta"
clear
**************************************************************
*****                                                 ********
*****   Since we're only working with these aggregates *******
*****   we drop the variable 'COST' so as to not       *******
*****   accidentally use this partial data             *******
**************************************************************

*************************************************************
** We repeat this procedure for the other quarters     ******
*************************************************************
use "2002Q2.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2002Q2agg.dta"
clear
use "2002Q3.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2002Q3agg.dta"
clear
use "2002Q4.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2002Q4agg.dta"

append using "2002Q3agg.dta"
append using "2002Q2agg.dta"
append using "2002Q1agg.dta"
save "2002Agg.dta"

*********************************************************************

************************************
***      Year 2003    (04180)***
set more off
cd "N:\Evans\2000-2003\10092627\10092627\ICPSR_04180"

**Quarter 1 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0003\04180-0003-Data.txt")
     do "expend.do"
     save "DS0003\04180-0003-AlteredData.DTA", replace
     clear

**Quarter 1 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0001\04180-0001-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0003\04180-0003-AlteredData.DTA", unmatched(master)
     save "2003Q1.DTA"
     clear
*****************************************
**Quarter 2 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0007\04180-0007-Data.txt")
     do "expend.do"
     save "DS0007\04180-0007-AlteredData.DTA", replace
     clear

**Quarter 2 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0005\04180-0005-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0007\04180-0007-AlteredData.DTA", unmatched(master)
     save "2003Q2.DTA"
     clear
*****************************************
**Quarter 3 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0011\04180-0011-Data.txt")
     do "expend.do"
     save "DS0011\04180-0011-AlteredData.DTA", replace
     clear

**Quarter 3 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0009\04180-0009-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0011\04180-0011-AlteredData.DTA", unmatched(master)
     save "2003Q3.DTA"
     clear
****************************************
**Quarter 4 Expenditures
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0003\03395-0003-Setup.dct", using("DS0015\04180-0015-Data.txt")
     do "expend.do"
     save "DS0015\04180-0015-AlteredData.DTA", replace
     clear

**Quarter 4 CU/Income file
     infile using "N:\Evans\2000-2003\10092627\10092627\ICPSR_03395\DS0001\03395-0001-Setup.dct", using("DS0013\04180-0013-Data.txt")
     do "cu.do"
     joinby ID purchasedayfromfirst using "DS0015\04180-0015-AlteredData.DTA", unmatched(master)
     save "2003Q4.DTA", replace

**********************************************************
**********************************************************
****     We now have all 4 quarters of 2000          *****
*       and there are no ID duplicates across qtrs       *
**********************************************************
*      Let's now aggregate daily category purchases in   *
*      each day in the 14day window for each individual  *
*      Consumer Unit.                                    *
**********************************************************
*we will do this by generating 8 aggregation variables.  *
*In each column, for each day, there will be one sum of  *
*expenditures.                                           *
**********************************************************
*** "Aggregation Example 1" in the appendix will help    *
***  clarify the procedure at this point                 *
***                                                      *
**********************************************************
clear
use "2003Q1.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2003Q1agg.dta"
clear
**************************************************************
*****                                                 ********
*****   Since we're only working with these aggregates *******
*****   we drop the variable 'COST' so as to not       *******
*****   accidentally use this partial data             *******
**************************************************************

*************************************************************
** We repeat this procedure for the other quarters     ******
*************************************************************
use "2003Q2.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2003Q2agg.dta"
clear
use "2003Q3.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2003Q3agg.dta"
clear
use "2003Q4.dta"
destring UCC, replace
   egen food1 = total(COST) if (UCC>=010110 & UCC<=180720)|(UCC==200112), by(ID purchasedate)
      duplicates drop food1 ID purchasedate if (UCC>=010110 & UCC<=180720)|(UCC==200112), force
   
   egen food2 = total(COST) if (UCC>=190111 & UCC<=190324), by(ID purchasedate)
      duplicates drop food2 ID purchasedate if (UCC>=190111 & UCC<=190324), force

   egen alc = total(COST) if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), by(ID purchasedate)
      duplicates drop alc ID purchasedate if (UCC==200111)|(UCC>=200201 & UCC<=200513)|(UCC>=200516 & UCC<=200523)|(UCC>=200526 & UCC<=200533)|(UCC==200536), force

   egen utils = total(COST) if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), by(ID purchasedate)
      duplicates drop utils ID purchasedate if (UCC>=250110 & UCC<=270210)|(UCC>=270410 & UCC<=270905), force

   egen apparel = total(COST) if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900) , by(ID purchasedate)
      duplicates drop apparel ID purchasedate if (UCC>=360110 & UCC<=360901)|(UCC>=370110 & UCC<=370901)|(UCC>=380110 & UCC<=380902)|(UCC>=390110 & UCC<=390901)|(UCC>=410110 & UCC<=410901)|(UCC>=400110 & UCC<=400310)|(UCC>=420110 & UCC<=430120)|(UCC>=440110 & UCC<=440900), force

   egen gas = total(COST) if (UCC>=470111 & UCC<=470114), by(ID purchasedate)
      duplicates drop gas ID purchasedate if (UCC>=470111 & UCC<=470114), force

   egen cig = total(COST) if (UCC==630110), by(ID purchasedate)
      duplicates drop cig ID purchasedate if (UCC==630110), force

   egen home = total(COST) if (UCC==009000)|(UCC==210110), by(ID purchasedate)
      duplicates drop home ID purchasedate if (UCC==630110), force
drop COST 
compress
save "2003Q4agg.dta"

append using "2003Q3agg.dta"
append using "2003Q2agg.dta"
append using "2003Q1agg.dta"
save "2003Agg.dta"