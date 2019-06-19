gi/* #delim ;*/
set more off
capture log close
capture clear
*log using , text replace
set memory 100m

/***!***!***!***!***!*** [National_banks1.do ] ***!***!***!***!***!
*
* Project: National Banks 		
* Programmer:   Shahed Khan
	(modifications by Scott Fulford)
*
* Date:    	 6/14/2010
*
* Auditor:      
* Audit Date:   
*
* Purpose:      
* 1) Combine the National Bank Acounts from the Comptroller of the Currency 
	for years 1870 and 1880, 1890, 1900 
	2) 

* 2) Check for the ones that closed from 1870 to 1880.  
* 3)
* Inputs: National_Bank_Accounts.xls     
*
* Ouputs: National_Bank_Accounts.dta
*		
*
*
***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***/


/***Define Global Directory ****/
	local INDIR "C:\Scott\Research\National_Banks\Data"
	local PROGDIR  "C:\Scott\Research\National_Banks\Programs"
	local OUTDIR  "C:\Scott\Research\National_Banks\Intermediate"
	local GRAPHDIR "C:\Scott\Research\National_Banks\Intermediate"
/*******************************/
 tempfile temp1870 temp1880 temp1890 temp1900 temp1902 receivers1880 liquidated1880
 clear 
 cd "`INDIR'"

/*Load 1902 Data*/
 /*insheet using "National Bank Accounts1880.csv"*/
 odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Accounts_1902$") clear dialog(complete)
 keep  State BankName BankCity BankNum Capital_stock
 
 /*Check all capital stock, but only the cities of those less than 50,000
 keep if Capital_stock <= 50000*/
 /*Replace capital stock in thousands*/
 replace Capital_stock = Capital_stock/1000 
 rename Capital_stock CapitalStock1902
 
 /*Standardize data*/
 rename State statename1902
 rename BankCity cityname1902
 rename BankName BankName1902
 rename BankNum BankNumber
 
 replace statename = upper(itrim(trim(statename)))
 replace cityname = upper(itrim(trim(cityname)))
 replace BankName = upper(itrim(trim(BankName)))
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" 

 /*In Report two banks have 2367 bank number, but First National Bank of Shenandoah, Iowa should be 2363 according to 1900 data*/
 replace BankNum = 2363 if BankNum==2367 & citynam =="SHENANDOAH"

 replace cityname1902 = "PAINESVILLE" if cityname1902 =="PAINESVILE" & statename1902 =="OHIO"
 


 
 compress
 duplicates report BankNumber
 sort BankNumber BankName cityname 
 save `temp1902', replace

/*Load 1900 Data*/
 /*insheet using "National Bank Accounts1880.csv"*/
 odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Accounts_1900$") clear dialog(complete)
 
 
 rename F1 Year
 rename F2 statename1900
 rename F3 BankName1900
 rename F4 cityname1900
 rename F5 BankNumber
 rename Assets LoansAndDiscount1900
 rename Liabilities CapitalStock1900
 rename F8 TotalLiabilities1900
 drop in 1
 capture drop F9

 /*Standardize data*/
 replace statename = upper(itrim(trim(statename)))
 replace cityname = upper(itrim(trim(cityname)))
 replace BankName = upper(itrim(trim(BankName)))
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" 

  
  /*3528 is originally in Sprague but moves to Spokane WA, about 12 miles
  away. Not clear whether Spokane abosrbed a town called Sprague, it has
  as Sprague AV*/
  replace BankNumber = -10000-BankNumber if BankNumber == 3258
 

 compress
 sort BankNumber BankName cityname 
 save `temp1900', replace

 /*Load 1890 Data*/

 odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Accounts_1890$") clear dialog(complete)
 
 rename F1 Year
 rename F2 statename1890
 rename F3 BankName1890
 rename F4 cityname1890
 rename F5 BankNumber
 rename Assets LoansAndDiscount1890
 rename F7 Reserves1890
 rename Liabilities CapitalStock1890
 rename F9 NotesOutstanding1890
 rename F10 IndividualDeposits1890
 rename F11 TotalLiabilities1890
 drop in 1
 capture drop F12
 capture drop if BankNumber ==.
 
 drop Reserves1890 NotesOutstanding1890 IndividualDeposits1890
 /*Standardize data*/
 replace statename = upper(itrim(trim(statename)))
 replace cityname = upper(itrim(trim(cityname)))
 replace BankName = upper(itrim(trim(BankName)))
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" 
 /*Calumet seems to be the new name*/
 replace cityname = "CALUMET" if cityname == `"RED JACKET"'  & statename == "MICHIGAN"

  /*Bar Harbour seems to be the new name*/
 replace cityname = "BAR HARBOR" if cityname == `"EDEN"'  & statename == "MAINE"

 /*Make changes to match other banks
 replace cityname = "LAWRENCEBURG" if cityname == `"LAWRENCEBURGH"'  & statename == "INDIANA"
 replace BankName = "LAWRENCEBURG NATIONAL BANK" if BankName == "LAWRENCEBURGH NATIONAL BANK"  & statename == "INDIANA"
 replace cityname = "ATTLEBORO" if cityname == `"ATTLEBORO'"'  & statename == "MASSACHUSETTS"
*/
      /*4410 starts out in Elgin but moves to Giddings about 15 miles away*/
  replace BankNumber = -10000-BankNumber if BankNumber == 4410
 
 
 compress
 sort BankNumber BankName cityname 
 save `temp1890', replace

  /*Load Liquidations and receivers from 1880*/
  odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Receivers_1880$") clear dialog(complete)
  
  save `receivers1880', replace
  odbc load,connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Vol_liq_1880$") clear dialog(complete)
  
  
  append using `receivers1880'
  
  rename Bank_Name BankName
  rename City cityname
  rename State statename
  rename Year CloseYear
  
  /*Standardize data*/
 replace statename = upper(itrim(trim(statename)))
 replace cityname = upper(itrim(trim(cityname)))
 replace BankName = upper(itrim(trim(BankName)))
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" 
 /*Changes names so match National Accounts*/
 replace BankName = "NATIONAL BANK" if BankName == "NATIONAL BANK OF FISHKILL" & statename == "NEW YORK"
 replace cityname = "BRATTLEBORO" if cityname == `"BRATTLEBORO'"'  & statename == "VERMONT"

 replace BankName = "FIRST NATIONAL BANK" if BankName == "FIRST NATIONAL BANK ROCKVILLE"  & statename == "INDIANA"
 replace BankName = "NATIONAL BANK" if BankName == "NATIONAL BANK OF TECUMSEH"  & statename == "MICHIGAN"
 replace cityname = "LANSINGBURGH" if cityname == `"LANSINGBURG"'  & statename == "NEW YORK"
 replace cityname = "BROOKVILLE" if cityname == `"BROOKEVILLE"'  & statename == "PENNSYLVANIA"
 replace BankName = "NATIONAL BANK" if BankName == "NATIONAL BANK OF DELAVAN"  & statename == "WISCONSIN"
 replace BankName = "NATIONAL BANK" if BankName == "NATIONAL BANK OF JEFFERSON"  & statename == "WISCONSIN" 
 replace BankName = "TRADERS' NATIONAL BANK" if BankName == "TRADER'S NATIONAL BANK"  & statename == "MAINE" 


 compress
 sort statename cityname BankName
 save `liquidated1880', replace

 /*Load 1880 Data*/
 /*insheet using "National Bank Accounts1880.csv"*/
 odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Accounts_1880$") clear dialog(complete)
 
 rename F1 Year
 rename F2 statename1880
 rename F3 BankName1880
 rename F4 cityname1880
 rename F5 BankNumber
 rename Assets LoansAndDiscount1880
 rename Liabilities CapitalStock1880
 rename F8 TotalLiabilities1880
 drop in 1
 capture drop F9

 /*Standardize data*/
 replace statename = upper(itrim(trim(statename)))
 replace cityname = upper(itrim(trim(cityname)))
 replace BankName = upper(itrim(trim(BankName)))
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" 
 replace cityname = "LAWRENCEBURG" if cityname == `"LAWRENCEBURGH"'  & statename == "INDIANA"
 replace BankName = "LAWRENCEBURG NATIONAL BANK" if BankName == "LAWRENCEBURGH NATIONAL BANK"  & statename == "INDIANA"
 replace cityname = "ATTLEBORO" if cityname == `"ATTLEBORO'"'  & statename == "MASSACHUSETTS"
 replace cityname = "KANSAS" if cityname == `"KAN"'  & statename == "ILLINOIS"

  /*1875 moves from Kutztown to Reading PA, which are far enough apart to 
  be different places*/
  replace BankNumber = -10000-BankNumber if BankNumber == 1875
  /*2152 moves from Boston to Brockton (well outside Boston*/
  replace BankNumber = -10000-BankNumber if BankNumber == 2152
  /*2219 seems to go from WILLIAMSBURGH	to BATESVILLE	OHIO	and goes
   from the FIRST NATIONAL BANK OF BATESVILLE to FIRST NATIONAL BANK*/
  replace BankNumber = -10000-BankNumber if BankNumber == 2219
 
   /*564 is originally in Angelica NY, but moves to Boston in 1900, after disapearing in 1890*/
  replace BankNumber = -10000-BankNumber if BankNumber == 564
 
  /*2691 is originally in Salem OH but moves to Medina OH*/
  replace BankNumber = -10000-BankNumber if BankNumber == 2691
 
 compress
 sort BankNumber BankName cityname 
 save `temp1880', replace

 /*Load 1870 Data*/ 
  /*insheet using "National Bank Accounts1870.csv"*/
 odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\National_Bank_Accounts.xls") table("Accounts_1870$") clear dialog(complete)
 
 rename F1 Year
 rename F2 statename
 rename F3 BankName
 rename F4 cityname
 rename F5 BankNumber
 rename Assets LoansAndDiscount1870
 rename Liabilities CapitalStock1870
 rename F8 TotalLiabilities1870
 drop in 1
 capture drop F9

 /*Standardize data*/
 replace statename = upper(itrim(trim(statename)))
 replace cityname = upper(itrim(trim(cityname)))
 replace BankName = upper(itrim(trim(BankName)))
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" 
 
 /*Standardize bank and city names*/
 /*Census spells Lawrenceburg and spelled that way today*/
 replace cityname = "LAWRENCEBURG" if cityname == `"LAWRENCEBURGH"'  & statename == "INDIANA"
 replace BankName = "LAWRENCEBURG NATIONAL BANK" if BankName == "LAWRENCEBURGH NATIONAL BANK"  & statename == "INDIANA"
 replace cityname = "ATTLEBORO" if cityname == `"ATTLEBOROUGH"'  & statename == "MASSACHUSETTS"

 replace cityname = "FISHKILL LANDING" if cityname == `"FISHKILL"'  & statename == "NEW YORK"
 compress
 
 /*Put negative numbers for missing BankNums
 Most Banks with missing bank numbers closed before Bank numbers reported 
 starting in 1871, but four cannot be accounted for
 */
 replace BankNum =0 if BankNum >=.
 sort BankNum
 replace BankNum = -900-_n if BankNum ==0
 
  /*Some banks move, replace number so does not match with 1870
 Need to correct for following banks
 358 moves from Watkins to Pen Yann, NY
 */
 replace BankNumber = -10000-BankNumber if BankNumber == 358
    /*564 is originally in Angelica NY, but moves to Boston in 1900, after disapearing in 1890*/
  replace BankNumber = -10000-BankNumber if BankNumber == 564


 
 
 sort statename cityname BankName
 save `temp1870', replace
 
 merge 1:1 statename cityname BankName using `liquidated1880'

 /*CloseYear gives the year in which banks in 1870 closed if do not make it to 1880*/
 /*
 Drop the banks that are not in 1870, but closed between 1870 and 1880. Such quick closures have little affect on activity
 The JERSEY SHORE NATIONAL BANK	 of JERSEY SHORE, PENNSYLVANIA drops out between 1870 and 1871, but is not listed as having closed. Maybe a name change, but without a number (introduced in 1871) it is hard to tell. 

 */
 drop if _merge ==2
 drop _merge
 
 sort BankNumber BankName cityname 
 merge 1:1 BankNumber using `temp1880'
 
 /* Eight banks have no record of closing but are not in 1880
 		4 are missing Bank Numbers (in 1870, but not 1871)
 		4 have bank numbers but are not in 1880 and are not listed as closing
 */
 list if _merge ==1 & CloseYear >=. 
 rename _merge _merge1880
 replace cityname = cityname1880 if cityname ==""
 replace statename = statename1880 if statename ==""
 replace BankName = BankName1880 if BankName ==""
 drop Year  Notes Date
 
 sort BankNumber BankName cityname 
 merge 1:1 BankNumber using `temp1890'
 rename _merge _merge1890
 replace cityname = cityname1890 if cityname ==""
 replace statename = statename1890 if statename ==""
 replace BankName = BankName1890 if BankName ==""
 drop Year


 sort BankNumber BankName cityname 
 merge 1:1 BankNumber using `temp1900'
 rename _merge _merge1900
 replace cityname = cityname1900 if cityname ==""
 replace statename = statename1900 if statename ==""
 replace BankName = BankName1900 if BankName ==""
 drop Year

 /*Merge 1902 with 1900 first to check city names
 The remaining ones that don't match are either slight
 name changes (courthouse and court-house) which are in
 the original, or seem to be legimate changes of 
 city. All of the states are the same

  cd "`OUTDIR'"
 save "National_Bank_Accounts.dta", replace
 use `temp1900', clear
 sort BankNumber BankName cityname 
 merge 1:1 BankNumber using `temp1902'
 
	gen name = ( cityname1900 !=  cityname1902) &  _merge ==3
	tab name
	edit if name ==1

  
 Vermilion, South Dakota in 1902 is Vermillion in 1900 in report
   Cotton National Bank of Oakland, Indian Territory seems to become 
   	First National Bank of Madill, Indian Territory. Same BankNumber
 Modesta, California in 1900 becomes Modesto in 1902 the correct city is probably Modesto  

MECHANICVILLE, New York in 1900 is MECHANICSVILLE in 1902
Berkley in 1900 beomes Berkeley by 1902 (Berkeley is the correct city, even though it is not spelled correctly, go Stanford)

 */
 
 sort BankNumber BankName cityname 
 merge 1:1 BankNumber using `temp1902'
 rename _merge _merge1902
 replace cityname = cityname1902 if cityname ==""
 replace statename = statename1902 if statename ==""
 replace BankName = BankName1902 if BankName ==""

 /*Check that matching on banknumber does not miss moving banks.
 Not all city names are the same, most are in the same location, and so choosing
 one name is fine
 edit if cityname !=   cityname1880 & _merge1880==3
 */
 /*A number of banks reduce their capital holdings
 Connecticut River NB, Charleston NH (no 537) goes from 50 to 25
 STISSING NATIONAL BANK,	PINE PLAINS, NY
 */
 
/*Banks which change city name, but still listed by 1870 city, change to modern
city*/ 
 /*Birmingham absorbed by Pittsburgh, need modern name*/
 replace cityname = "PITTSBURGH" if cityname == `"BIRMINGHAM"'  & statename == "PENNSYLVANIA" 
 /*North Providence becomes Pawtucket*/
 replace cityname = "PAWTUCKET" if cityname == `"NORTH PROVIDENCE"'  & statename == "RHODE ISLAND" 
 replace cityname = "WAKEFIELD" if cityname == `"SOUTH READING"'  & statename == "MASSACHUSETTS"
 replace cityname = "WILLIMANTIC" if cityname == `"WINDHAM"'  & statename == "CONNECTICUT" 

 drop  _merge*

 
 
 cd "`OUTDIR'"
 save "National_Bank_Accounts.dta", replace

exit
 
/* Number of Banks in 1870s */


/* Number of Banks in 1880s */

/* Number of Banks that are both in 1870s and 1880s */ 

/* Number of Banks that are in 1870s but not in 1880s */ 

/* Number of Banks that are not in 1870s but in 1880s */ 

count if _merge==3 & CapitalStock1870 == CapitalStock1880 

count if _merge==3  & CapitalStock1870 != CapitalStock1880 

count if _merge==3 & CapitalStock1870 < CapitalStock1880 

count if _merge==3 & CapitalStock1870 > CapitalStock1880 
 
