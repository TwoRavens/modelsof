*-----------------------------------------*
*** DO-FILE VARIABLE GENERATION ***
*-----------------------------------------*
   
/*  
PAPER: 
"Endogenous taxation in ongoing internal conflict: The Case of Colombia"

AUTHORS:
-Rafael Ch (New York University)
-Jacob Shapiro (Princeton University)
-Abbey Steele (University of Amsterdam)
-Juan F. Vargas (Universidad del Rosario)

DO-FILE: 
-This do-file generates the variables used in the paper.

*/
***********************************

clear all
set maxvar 32500
set more off 
set varabbrev off

*Set working directory wherever the "Replication_material_R&R/DO_FILES" folder is:
cd "/Users/rafach/Dropbox/PRINCETON-COLOMBIA/RESEARCH/TAXATION/Dropbox/Taxation paper/Analysis/Replication_material_R&R/DO_FILES"

use "../DATA/ENDOGENOUS_TAXATION_V1.dta", clear

											*-----------------------*

											*INDEX:
											*1. Independent variables
											*2. Dependent variables
											*3. Control variables 

											*-----------------------*


*-----------------------*
*1. Independent Variables*
*-----------------------*

**********************************
*ATTACKS:
**********************************

*Attacks per 100,0000 inhabitants, by armed group:
  foreach i in guer para{
  gen `i'88_pc=(`i'1988/Total_Poblacion1988)*100000
  gen `i'89_pc=(`i'1989/Total_Poblacion1989)*100000
  gen `i'90_pc=(`i'1990/Total_Poblacion1990)*100000
  gen `i'91_pc=(`i'1991/Total_Poblacion1991)*100000
  gen `i'92_pc=(`i'1992/Total_Poblacion1992)*100000
  gen `i'93_pc=(`i'1993/Total_Poblacion1993)*100000
  gen `i'94_pc=(`i'1994/Total_Poblacion1994)*100000 
  gen `i'95_pc=(`i'1995/Total_Poblacion1995)*100000 
  gen `i'96_pc=(`i'1996/Total_Poblacion1996)*100000
  gen `i'97_pc=(`i'1997/Total_Poblacion1997)*100000
  gen `i'98_pc=(`i'1998/Total_Poblacion1998)*100000
  gen `i'99_pc=(`i'1999/Total_Poblacion1999)*100000
  gen `i'00_pc=(`i'2000/Total_Poblacion2000)*100000
  gen `i'01_pc=(`i'2001/Total_Poblacion2001)*100000
  gen `i'02_pc=(`i'2002/Total_Poblacion2002)*100000
  gen `i'03_pc=(`i'2003/Total_Poblacion2003)*100000
  gen `i'04_pc=(`i'2004/Total_Poblacion2004)*100000
  gen `i'05_pc=(`i'2005/Total_Poblacion2005)*100000
  gen `i'06_pc=(`i'2006/Total_Poblacion2006)*100000
  gen `i'07_pc=(`i'2007/Total_Poblacion2007)*100000
  gen `i'08_pc=(`i'2008/Total_Poblacion2008)*100000
  gen `i'09_pc=(`i'2009/Total_Poblacion2009)*100000
  gen `i'10_pc=(`i'2010/Total_Poblacion2010)*100000
  gen `i'11_pc=(`i'2011/Total_Poblacion2011)*100000
  gen `i'12_pc=(`i'2012/Total_Poblacion2012)*100000
  }
  
*Cumulative attacks by periods, by armed group:

foreach i in guer para{
*Six year windows:
egen `i'1988_1993_pc=rowtotal(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc)
egen `i'1989_1994_pc=rowtotal(`i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc)
egen `i'1990_1995_pc=rowtotal(`i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc)
egen `i'1991_1996_pc=rowtotal(`i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1992_1997_pc=rowtotal(`i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc)
egen `i'1993_1998_pc=rowtotal(`i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc)
egen `i'1994_1999_pc=rowtotal(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc)
egen `i'1995_2000_pc=rowtotal(`i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1996_2001_pc=rowtotal(`i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc)
egen `i'1997_2002_pc=rowtotal(`i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1998_2003_pc=rowtotal(`i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc)
egen `i'1999_2004_pc=rowtotal(`i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc)
egen `i'2000_2005_pc=rowtotal(`i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc)
egen `i'2001_2006_pc=rowtotal(`i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc)
egen `i'2002_2007_pc=rowtotal(`i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc)
egen `i'2003_2008_pc=rowtotal(`i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc)
egen `i'2004_2009_pc=rowtotal(`i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc)
egen `i'2005_2010_pc=rowtotal(`i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)

*Eight year windows:
egen `i'1988_1995_pc=rowtotal(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc)
egen `i'1989_1996_pc=rowtotal(`i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1990_1997_pc=rowtotal(`i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc)
egen `i'1991_1998_pc=rowtotal(`i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc)
egen `i'1992_1999_pc=rowtotal(`i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc)
egen `i'1993_2000_pc=rowtotal(`i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1994_2001_pc=rowtotal(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc)
egen `i'1995_2002_pc=rowtotal(`i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1996_2003_pc=rowtotal(`i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc)
egen `i'1997_2004_pc=rowtotal(`i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc)
egen `i'1998_2005_pc=rowtotal(`i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc)
egen `i'1999_2006_pc=rowtotal(`i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc)
egen `i'2000_2007_pc=rowtotal(`i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc)
egen `i'2001_2008_pc=rowtotal(`i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc)
egen `i'2002_2009_pc=rowtotal(`i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc)
egen `i'2003_2010_pc=rowtotal(`i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)


*4 Time periods (that where not created before):
egen `i'1988_1996_pc=rowtotal(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1997_1999_pc=rowtotal(`i'97_pc `i'98_pc `i'99_pc)
egen `i'2000_2002_pc=rowtotal(`i'00_pc `i'01_pc `i'02_pc)
egen `i'2003_2006_pc=rowtotal(`i'03_pc `i'04_pc `i'05_pc `i'06_pc)
egen `i'2007_2010_pc=rowtotal(`i'07_pc `i'08_pc `i'09_pc `i'10_pc)
}



*Logged attacks per capita (using log((count + 1)/pop))
  foreach i in guer para{
  gen ln`i'88_pc_2=log((`i'1988+1)/Total_Poblacion1988)
  gen ln`i'89_pc_2=log((`i'1989+1)/Total_Poblacion1989)
  gen ln`i'90_pc_2=log((`i'1990+1)/Total_Poblacion1990)
  gen ln`i'91_pc_2=log((`i'1991+1)/Total_Poblacion1991)
  gen ln`i'92_pc_2=log((`i'1992+1)/Total_Poblacion1992)
  gen ln`i'93_pc_2=log((`i'1993+1)/Total_Poblacion1993)
  gen ln`i'94_pc_2=log((`i'1994+1)/Total_Poblacion1994)
  gen ln`i'95_pc_2=log((`i'1995+1)/Total_Poblacion1995)
  gen ln`i'96_pc_2=log((`i'1996+1)/Total_Poblacion1996)
  gen ln`i'97_pc_2=log((`i'1997+1)/Total_Poblacion1997)
  gen ln`i'98_pc_2=log((`i'1998+1)/Total_Poblacion1998)
  gen ln`i'99_pc_2=log((`i'1999+1)/Total_Poblacion1999)
  gen ln`i'00_pc_2=log((`i'2000+1)/Total_Poblacion2000)
  gen ln`i'01_pc_2=log((`i'2001+1)/Total_Poblacion2001)
  gen ln`i'02_pc_2=log((`i'2002+1)/Total_Poblacion2002)
  gen ln`i'03_pc_2=log((`i'2003+1)/Total_Poblacion2003)
  gen ln`i'04_pc_2=log((`i'2004+1)/Total_Poblacion2004)
  gen ln`i'05_pc_2=log((`i'2005+1)/Total_Poblacion2005)
  gen ln`i'06_pc_2=log((`i'2006+1)/Total_Poblacion2006)
  gen ln`i'07_pc_2=log((`i'2007+1)/Total_Poblacion2007)
  gen ln`i'08_pc_2=log((`i'2008+1)/Total_Poblacion2008)
  gen ln`i'09_pc_2=log((`i'2009+1)/Total_Poblacion2009)
  gen ln`i'10_pc_2=log((`i'2010+1)/Total_Poblacion2010)
  }
  

*(Logged) Cumulative attacks by periods, by armed group (These are the variables used in Tables 2, 3, and 4, and all appendix tables):
foreach i in guer para{

*Six year windows:
egen ln`i'1988_1993_pc_2=rowtotal(ln`i'88_pc_2 ln`i'89_pc_2 ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2)
egen ln`i'1989_1994_pc_2=rowtotal(ln`i'89_pc_2 ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2)
egen ln`i'1990_1995_pc_2=rowtotal(ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2)
egen ln`i'1991_1996_pc_2=rowtotal(ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2)
egen ln`i'1992_1997_pc_2=rowtotal(ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2)
egen ln`i'1993_1998_pc_2=rowtotal(ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2)
egen ln`i'1994_1999_pc_2=rowtotal(ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2)
egen ln`i'1995_2000_pc_2=rowtotal(ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2)
egen ln`i'1996_2001_pc_2=rowtotal(ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2)
egen ln`i'1997_2002_pc_2=rowtotal(ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2)
egen ln`i'1998_2003_pc_2=rowtotal(ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2)
egen ln`i'1999_2004_pc_2=rowtotal(ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2)
egen ln`i'2000_2005_pc_2=rowtotal(ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2)
egen ln`i'2001_2006_pc_2=rowtotal(ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2)
egen ln`i'2002_2007_pc_2=rowtotal(ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2)
egen ln`i'2003_2008_pc_2=rowtotal(ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2 ln`i'08_pc_2)
egen ln`i'2004_2009_pc_2=rowtotal(ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2 ln`i'08_pc_2 ln`i'09_pc_2)
egen ln`i'2005_2010_pc_2=rowtotal(ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2 ln`i'08_pc_2 ln`i'09_pc_2 ln`i'10_pc_2)

*Eight year windows:
egen ln`i'1988_1995_pc_2=rowtotal(ln`i'88_pc_2 ln`i'89_pc_2 ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2)
egen ln`i'1989_1996_pc_2=rowtotal(ln`i'89_pc_2 ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2)
egen ln`i'1990_1997_pc_2=rowtotal(ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2)
egen ln`i'1991_1998_pc_2=rowtotal(ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2)
egen ln`i'1992_1999_pc_2=rowtotal(ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2)
egen ln`i'1993_2000_pc_2=rowtotal(ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2)
egen ln`i'1994_2001_pc_2=rowtotal(ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2)
egen ln`i'1995_2002_pc_2=rowtotal(ln`i'95_pc_2 ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2)
egen ln`i'1996_2003_pc_2=rowtotal(ln`i'96_pc_2 ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2)
egen ln`i'1997_2004_pc_2=rowtotal(ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2)
egen ln`i'1998_2005_pc_2=rowtotal(ln`i'98_pc_2 ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2)
egen ln`i'1999_2006_pc_2=rowtotal(ln`i'99_pc_2 ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2)
egen ln`i'2000_2007_pc_2=rowtotal(ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2)
egen ln`i'2001_2008_pc_2=rowtotal(ln`i'01_pc_2 ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2 ln`i'08_pc_2)
egen ln`i'2002_2009_pc_2=rowtotal(ln`i'02_pc_2 ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2 ln`i'08_pc_2 ln`i'09_pc_2)
egen ln`i'2003_2010_pc_2=rowtotal(ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2 ln`i'07_pc_2 ln`i'08_pc_2 ln`i'09_pc_2 ln`i'10_pc_2)

*4 Time periods (that where not created before):
egen ln`i'1988_1996_pc_2=rowtotal(ln`i'88_pc_2 ln`i'89_pc_2 ln`i'90_pc_2 ln`i'91_pc_2 ln`i'92_pc_2 ln`i'93_pc_2 ln`i'94_pc_2 ln`i'95_pc_2 ln`i'96_pc_2)
egen ln`i'1997_1999_pc_2=rowtotal(ln`i'97_pc_2 ln`i'98_pc_2 ln`i'99_pc_2)
egen ln`i'2000_2002_pc_2=rowtotal(ln`i'00_pc_2 ln`i'01_pc_2 ln`i'02_pc_2) 
egen ln`i'2003_2006_pc_2=rowtotal(ln`i'03_pc_2 ln`i'04_pc_2 ln`i'05_pc_2 ln`i'06_pc_2)
egen ln`i'2007_2010_pc_2=rowtotal(ln`i'07_pc_2 ln`i'08_pc_2 ln`i'09_pc_2 ln`i'10_pc_2)
}



*----------------------*
*2. Dependent variables*
*----------------------*


************
*LIGHT DATA*
************

*(Logged) luminosity per capita:
  foreach i in light{
  gen ln`i'92_pc=log((`i'1992+1)/Total_Poblacion1992)
  gen ln`i'93_pc=log((`i'1993+1)/Total_Poblacion1993)
  gen ln`i'94_pc=log((`i'1994+1)/Total_Poblacion1994)
  gen ln`i'95_pc=log((`i'1995+1)/Total_Poblacion1995)
  gen ln`i'96_pc=log((`i'1996+1)/Total_Poblacion1996)
  gen ln`i'97_pc=log((`i'1997+1)/Total_Poblacion1997)
  gen ln`i'98_pc=log((`i'1998+1)/Total_Poblacion1998)
  gen ln`i'99_pc=log((`i'1999+1)/Total_Poblacion1999)
  gen ln`i'00_pc=log((`i'2000+1)/Total_Poblacion2000)
  gen ln`i'01_pc=log((`i'2001+1)/Total_Poblacion2001)
  gen ln`i'02_pc=log((`i'2002+1)/Total_Poblacion2002)
  gen ln`i'03_pc=log((`i'2003+1)/Total_Poblacion2003)
  gen ln`i'04_pc=log((`i'2004+1)/Total_Poblacion2004)
  gen ln`i'05_pc=log((`i'2005+1)/Total_Poblacion2005)
  gen ln`i'06_pc=log((`i'2006+1)/Total_Poblacion2006)
  gen ln`i'07_pc=log((`i'2007+1)/Total_Poblacion2007)
  gen ln`i'08_pc=log((`i'2008+1)/Total_Poblacion2008)
  gen ln`i'09_pc=log((`i'2009+1)/Total_Poblacion2009)
  gen ln`i'10_pc=log((`i'2010+1)/Total_Poblacion2010)
  gen ln`i'11_pc=log((`i'2011+1)/Total_Poblacion2011)
  gen ln`i'12_pc=log((`i'2012+1)/Total_Poblacion2012)
  gen ln`i'13_pc=log((`i'2013+1)/Total_Poblacion2013)
  }



*(Logged) average luminosity per capita:
foreach i in light{
egen ln`i'1992_1996_pc2= rowmean(ln`i'92_pc ln`i'93_pc ln`i'94_pc ln`i'95_pc ln`i'96_pc)
egen ln`i'1992_1994_pc2= rowmean(ln`i'92_pc ln`i'93_pc ln`i'94_pc)
egen ln`i'1995_1996_pc2= rowmean(ln`i'95_pc ln`i'96_pc)
egen ln`i'1997_1999_pc2= rowmean(ln`i'97_pc ln`i'98_pc ln`i'99_pc)
egen ln`i'2000_2002_pc2= rowmean(ln`i'00_pc ln`i'01_pc ln`i'02_pc) 
egen ln`i'1997_2002_pc2= rowmean(ln`i'97_pc ln`i'98_pc ln`i'99_pc ln`i'00_pc ln`i'01_pc ln`i'02_pc)
egen ln`i'2003_2006_pc2= rowmean(ln`i'03_pc ln`i'04_pc ln`i'05_pc ln`i'06_pc)
egen ln`i'2007_2010_pc2= rowmean(ln`i'07_pc ln`i'08_pc ln`i'09_pc ln`i'10_pc)
egen ln`i'2003_2010_pc2= rowmean(ln`i'03_pc ln`i'04_pc ln`i'05_pc ln`i'06_pc ln`i'07_pc ln`i'08_pc ln`i'09_pc ln`i'10_pc)
egen ln`i'2011_2012_pc2= rowmean(ln`i'11_pc ln`i'12_pc)
egen ln`i'2011_2013_pc2= rowmean(ln`i'11_pc ln`i'12_pc ln`i'13_pc)
}



*****************************
*TAX REVENUES*
/*all variables at constant thousand Colombian pesos 2008*/
*****************************

*Tax revenues in thousand pesos:
  foreach i in ingreso_predial{
  gen `i'1985_2=(`i'1985*1000)
  gen `i'1986_2=(`i'1986*1000)
  gen `i'1987_2=(`i'1987*1000)
  gen `i'1988_2=(`i'1988*1000)
  gen `i'1989_2=(`i'1989*1000)
  gen `i'1990_2=(`i'1990*1000)
  gen `i'1991_2=(`i'1991*1000)
  gen `i'1992_2=(`i'1992*1000)
  gen `i'1993_2=(`i'1993*1000)
  gen `i'1994_2=(`i'1994*1000)
  gen `i'1995_2=(`i'1995*1000)
  gen `i'1996_2=(`i'1996*1000)
  gen `i'1997_2=(`i'1997*1000)
  gen `i'1998_2=(`i'1998*1000)
  gen `i'1999_2=(`i'1999*1000)
  gen `i'2000_2=(`i'2000*1000)
  gen `i'2001_2=(`i'2001*1000)
  gen `i'2002_2=(`i'2002*1000)
  gen `i'2003_2=(`i'2003*1000)
  gen `i'2004_2=(`i'2004*1000)
  gen `i'2005_2=(`i'2005*1000)
  gen `i'2006_2=(`i'2006*1000)
  gen `i'2007_2=(`i'2007*1000)
  gen `i'2008_2=(`i'2008*1000)
  gen `i'2009_2=(`i'2009*1000)
  gen `i'2010_2=(`i'2010*1000)
  gen `i'2011_2=(`i'2011*1000)
  gen `i'2012_2=(`i'2012*1000)
  gen `i'2013_2=(`i'2013*1000)
  }
  
**********
*PER CAPITA VALUES
/*all variables at constant thousand Colombian pesos 2008*/
**********

*Tax revenues per capita:
  foreach i in ingreso_predial{
  gen `i'85_pc2=`i'1985_2/Total_Poblacion1985
  gen `i'86_pc2=`i'1986_2/Total_Poblacion1986
  gen `i'87_pc2=`i'1987_2/Total_Poblacion1987
  gen `i'88_pc2=`i'1988_2/Total_Poblacion1988
  gen `i'89_pc2=`i'1989_2/Total_Poblacion1989
  gen `i'90_pc2=`i'1990_2/Total_Poblacion1990
  gen `i'91_pc2=`i'1991_2/Total_Poblacion1991
  gen `i'92_pc2=`i'1992_2/Total_Poblacion1992
  gen `i'93_pc2=`i'1993_2/Total_Poblacion1993
  gen `i'94_pc2=`i'1994_2/Total_Poblacion1994
  gen `i'95_pc2=`i'1995_2/Total_Poblacion1995
  gen `i'96_pc2=`i'1996_2/Total_Poblacion1996  
  gen `i'97_pc2=`i'1997_2/Total_Poblacion1997
  gen `i'98_pc2=`i'1998_2/Total_Poblacion1998
  gen `i'99_pc2=`i'1999_2/Total_Poblacion1999
  gen `i'00_pc2=`i'2000_2/Total_Poblacion2000
  gen `i'01_pc2=`i'2001_2/Total_Poblacion2001
  gen `i'02_pc2=`i'2002_2/Total_Poblacion2002
  gen `i'03_pc2=`i'2003_2/Total_Poblacion2003
  gen `i'04_pc2=`i'2004_2/Total_Poblacion2004
  gen `i'05_pc2=`i'2005_2/Total_Poblacion2005
  gen `i'06_pc2=`i'2006_2/Total_Poblacion2006
  gen `i'07_pc2=`i'2007_2/Total_Poblacion2007
  gen `i'08_pc2=`i'2008_2/Total_Poblacion2008
  gen `i'09_pc2=`i'2009_2/Total_Poblacion2009
  gen `i'10_pc2=`i'2010_2/Total_Poblacion2010
  gen `i'11_pc2=`i'2011_2/Total_Poblacion2011
  gen `i'12_pc2=`i'2012_2/Total_Poblacion2012
  gen `i'13_pc2=`i'2013_2/Total_Poblacion2013
  }
  
  
*(Average) Tax revenues per capita, by periods:
  foreach i in ingreso_predial{
  *Three year period:
  egen `i'94_96_pc2=rmean(`i'94_pc2 `i'95_pc2 `i'96_pc2)
  egen `i'95_97_pc2=rmean(`i'95_pc2 `i'96_pc2 `i'97_pc2)
  egen `i'96_98_pc2=rmean(`i'96_pc2 `i'97_pc2 `i'98_pc2)
  egen `i'97_99_pc2=rmean(`i'97_pc2 `i'98_pc2 `i'99_pc2)
  egen `i'98_00_pc2=rmean(`i'98_pc2 `i'99_pc2 `i'00_pc2)
  egen `i'99_01_pc2=rmean(`i'99_pc2 `i'00_pc2 `i'01_pc2)
  egen `i'00_02_pc2=rmean(`i'00_pc2 `i'01_pc2 `i'02_pc2)
  egen `i'01_03_pc2=rmean(`i'01_pc2 `i'02_pc2 `i'03_pc2)
  egen `i'02_04_pc2=rmean(`i'02_pc2 `i'03_pc2 `i'04_pc2)
  egen `i'03_05_pc2=rmean(`i'03_pc2 `i'04_pc2 `i'05_pc2)
  egen `i'04_06_pc2=rmean(`i'04_pc2 `i'05_pc2 `i'06_pc2)
  egen `i'05_07_pc2=rmean(`i'05_pc2 `i'06_pc2 `i'07_pc2)
  egen `i'06_08_pc2=rmean(`i'06_pc2 `i'07_pc2 `i'08_pc2)
  egen `i'07_09_pc2=rmean(`i'07_pc2 `i'08_pc2 `i'09_pc2)
  egen `i'08_10_pc2=rmean(`i'08_pc2 `i'09_pc2 `i'10_pc2)
  egen `i'09_11_pc2=rmean(`i'09_pc2 `i'10_pc2 `i'11_pc2)
  egen `i'10_12_pc2=rmean(`i'10_pc2 `i'11_pc2 `i'12_pc2)
  egen `i'11_13_pc2=rmean(`i'11_pc2 `i'12_pc2 `i'13_pc2)

  *Five year period:
  egen `i'94_98_pc2=rmean(`i'94_pc2 `i'95_pc2 `i'96_pc2 `i'97_pc2 `i'98_pc2)
  egen `i'95_99_pc2=rmean(`i'95_pc2 `i'96_pc2 `i'97_pc2 `i'98_pc2 `i'99_pc2)
  egen `i'96_00_pc2=rmean(`i'96_pc2 `i'97_pc2 `i'98_pc2 `i'99_pc2 `i'00_pc2)
  egen `i'97_01_pc2=rmean(`i'97_pc2 `i'98_pc2 `i'99_pc2 `i'00_pc2 `i'01_pc2)
  egen `i'98_02_pc2=rmean(`i'98_pc2 `i'99_pc2 `i'00_pc2 `i'01_pc2 `i'02_pc2)
  egen `i'99_03_pc2=rmean(`i'99_pc2 `i'00_pc2 `i'01_pc2 `i'02_pc2 `i'03_pc2)
  egen `i'00_04_pc2=rmean(`i'00_pc2 `i'01_pc2 `i'02_pc2 `i'03_pc2 `i'04_pc2)
  egen `i'01_05_pc2=rmean(`i'01_pc2 `i'02_pc2 `i'03_pc2 `i'04_pc2 `i'05_pc2)
  egen `i'02_06_pc2=rmean(`i'02_pc2 `i'03_pc2 `i'04_pc2 `i'05_pc2 `i'06_pc2)
  egen `i'03_07_pc2=rmean(`i'03_pc2 `i'04_pc2 `i'05_pc2 `i'06_pc2 `i'07_pc2)
  egen `i'04_08_pc2=rmean(`i'04_pc2 `i'05_pc2 `i'06_pc2 `i'07_pc2 `i'08_pc2)
  egen `i'05_09_pc2=rmean(`i'05_pc2 `i'06_pc2 `i'07_pc2 `i'08_pc2 `i'09_pc2)
  egen `i'06_10_pc2=rmean(`i'06_pc2 `i'07_pc2 `i'08_pc2 `i'09_pc2 `i'10_pc2)
  egen `i'07_11_pc2=rmean(`i'07_pc2 `i'08_pc2 `i'09_pc2 `i'10_pc2 `i'11_pc2)
  egen `i'08_12_pc2=rmean(`i'08_pc2 `i'09_pc2 `i'10_pc2 `i'11_pc2 `i'12_pc2)
  egen `i'09_13_pc2=rmean(`i'09_pc2 `i'10_pc2 `i'11_pc2 `i'12_pc2 `i'13_pc2)


  *Laggs 3 year period:
  egen `i'85_87_pc2=rmean(`i'85_pc2 `i'86_pc2 `i'87_pc2)
  egen `i'86_88_pc2=rmean(`i'86_pc2 `i'87_pc2 `i'88_pc2)
  egen `i'87_89_pc2=rmean(`i'87_pc2 `i'88_pc2 `i'89_pc2)
  egen `i'88_90_pc2=rmean(`i'88_pc2 `i'89_pc2 `i'90_pc2)
  egen `i'89_91_pc2=rmean(`i'89_pc2 `i'90_pc2 `i'91_pc2)
  egen `i'90_92_pc2=rmean(`i'90_pc2 `i'91_pc2 `i'92_pc2)
  egen `i'91_93_pc2=rmean(`i'91_pc2 `i'92_pc2 `i'93_pc2)
  egen `i'92_94_pc2=rmean(`i'92_pc2 `i'93_pc2 `i'94_pc2)
  egen `i'93_95_pc2=rmean(`i'93_pc2 `i'94_pc2 `i'95_pc2)
 
  *Laggs 5 year period:  
  egen `i'85_89_pc2=rmean(`i'85_pc2 `i'86_pc2 `i'87_pc2 `i'88_pc2 `i'89_pc2)
  egen `i'86_90_pc2=rmean(`i'86_pc2 `i'87_pc2 `i'88_pc2 `i'89_pc2 `i'90_pc2)
  egen `i'87_91_pc2=rmean(`i'87_pc2 `i'88_pc2 `i'89_pc2 `i'90_pc2 `i'91_pc2)
  egen `i'88_92_pc2=rmean(`i'88_pc2 `i'89_pc2 `i'90_pc2 `i'91_pc2 `i'92_pc2)
  egen `i'89_93_pc2=rmean(`i'89_pc2 `i'90_pc2 `i'91_pc2 `i'92_pc2 `i'93_pc2)
  egen `i'90_94_pc2=rmean(`i'90_pc2 `i'91_pc2 `i'92_pc2 `i'93_pc2 `i'94_pc2)
  egen `i'91_95_pc2=rmean(`i'91_pc2 `i'92_pc2 `i'93_pc2 `i'94_pc2 `i'95_pc2)
  egen `i'92_96_pc2=rmean(`i'92_pc2 `i'93_pc2 `i'94_pc2 `i'95_pc2 `i'96_pc2)
  egen `i'93_97_pc2=rmean(`i'93_pc2 `i'94_pc2 `i'95_pc2 `i'96_pc2 `i'97_pc2)

   
*Other years:  
  egen `i'85_88_pc2=rmean(`i'85_pc2 `i'86_pc2 `i'87_pc2 `i'88_pc2)
  egen `i'93_96_pc2=rmean(`i'93_pc2 `i'94_pc2 `i'95_pc2 `i'96_pc2)
  egen `i'97_02_pc2=rmean(`i'97_pc2 `i'98_pc2 `i'99_pc2 `i'00_pc2 `i'01_pc2 `i'02_pc2)
  egen `i'03_06_pc2=rmean(`i'03_pc2 `i'04_pc2 `i'05_pc2 `i'06_pc2)
  egen `i'07_10_pc2=rmean(`i'07_pc2 `i'08_pc2 `i'09_pc2 `i'10_pc2)
  egen `i'10_13_pc2=rmean(`i'10_pc2 `i'11_pc2 `i'12_pc2 `i'13_pc2)

  }
  
 
*(Logged) Average tax revenues per capita, by periods:
  foreach i in ingreso_predial{
  
  *Three year period: 
  gen ln`i'94_96_pc2=log(`i'94_96_pc2+1)
  gen ln`i'95_97_pc2=log(`i'95_97_pc2+1)
  gen ln`i'96_98_pc2=log(`i'96_98_pc2+1)
  gen ln`i'97_99_pc2=log(`i'97_99_pc2+1)
  gen ln`i'98_00_pc2=log(`i'98_00_pc2+1)
  gen ln`i'99_01_pc2=log(`i'99_01_pc2+1)
  gen ln`i'00_02_pc2=log(`i'00_02_pc2+1)
  gen ln`i'01_03_pc2=log(`i'01_03_pc2+1)
  gen ln`i'02_04_pc2=log(`i'02_04_pc2+1)
  gen ln`i'03_05_pc2=log(`i'03_05_pc2+1)
  gen ln`i'04_06_pc2=log(`i'04_06_pc2+1)
  gen ln`i'05_07_pc2=log(`i'05_07_pc2+1)
  gen ln`i'06_08_pc2=log(`i'06_08_pc2+1)
  gen ln`i'07_09_pc2=log(`i'07_09_pc2+1)
  gen ln`i'08_10_pc2=log(`i'08_10_pc2+1)
  gen ln`i'09_11_pc2=log(`i'09_11_pc2+1)
  gen ln`i'10_12_pc2=log(`i'10_12_pc2+1)
  gen ln`i'11_13_pc2=log(`i'11_13_pc2+1)

  *Five year period:
  gen ln`i'94_98_pc2=log(`i'94_98_pc2+1 )
  gen ln`i'95_99_pc2=log(`i'95_99_pc2+1 )
  gen ln`i'96_00_pc2=log(`i'96_00_pc2+1 )
  gen ln`i'97_01_pc2=log(`i'97_01_pc2+1 )
  gen ln`i'98_02_pc2=log(`i'98_02_pc2+1 )
  gen ln`i'99_03_pc2=log(`i'99_03_pc2+1 )
  gen ln`i'00_04_pc2=log(`i'00_04_pc2+1 )
  gen ln`i'01_05_pc2=log(`i'01_05_pc2+1 )
  gen ln`i'02_06_pc2=log(`i'02_06_pc2+1 )
  gen ln`i'03_07_pc2=log(`i'03_07_pc2+1 )
  gen ln`i'04_08_pc2=log(`i'04_08_pc2+1 )
  gen ln`i'05_09_pc2=log(`i'05_09_pc2+1 )
  gen ln`i'06_10_pc2=log(`i'06_10_pc2+1 )
  gen ln`i'07_11_pc2=log(`i'07_11_pc2+1 )
  gen ln`i'08_12_pc2=log(`i'08_12_pc2+1 )
  gen ln`i'09_13_pc2=log(`i'09_13_pc2+1 )

  
  *Laggs 3 year periods:
  gen ln`i'85_87_pc2=log(`i'85_87_pc2 +1 )
  gen ln`i'86_88_pc2=log(`i'86_88_pc2 +1 )
  gen ln`i'87_89_pc2=log(`i'87_89_pc2 +1 )
  gen ln`i'88_90_pc2=log(`i'88_90_pc2 +1 )
  gen ln`i'89_91_pc2=log(`i'89_91_pc2 +1 )
  gen ln`i'90_92_pc2=log(`i'90_92_pc2 +1 )
  gen ln`i'91_93_pc2=log(`i'91_93_pc2 +1 )
  gen ln`i'92_94_pc2=log(`i'92_94_pc2 +1 )
  gen ln`i'93_95_pc2=log(`i'93_95_pc2 +1 )


  *Laggs 5 year periods:
  gen ln`i'85_89_pc2=log(`i'85_89_pc2 +1 )
  gen ln`i'86_90_pc2=log(`i'86_90_pc2 +1 )
  gen ln`i'87_91_pc2=log(`i'87_91_pc2 +1 )
  gen ln`i'88_92_pc2=log(`i'88_92_pc2 +1 )
  gen ln`i'89_93_pc2=log(`i'89_93_pc2 +1 )
  gen ln`i'90_94_pc2=log(`i'90_94_pc2 +1 )
  gen ln`i'91_95_pc2=log(`i'91_95_pc2 +1 )
  gen ln`i'92_96_pc2=log(`i'92_96_pc2 +1 )
  gen ln`i'93_97_pc2=log(`i'93_97_pc2 +1 )
 

  
  *Other years:
  gen ln`i'85_88_pc2=log(`i'85_88_pc2+1)
  gen ln`i'93_96_pc2=log(`i'93_96_pc2+1)
  gen ln`i'97_02_pc2=log(`i'97_02_pc2+1)
  gen ln`i'03_06_pc2=log(`i'03_06_pc2+1)
  gen ln`i'07_10_pc2=log(`i'07_10_pc2+1)
  gen ln`i'10_13_pc2=log(`i'10_13_pc2+1)

  }
  
  
*****************
*SOCIAL OUTCOMES*
*****************

*Saber indicator renaming:
foreach i in Saber_ indicador_saber{
rename `i'111988 `i'1988
rename `i'111989 `i'1989
rename `i'111990 `i'1990
rename `i'111991 `i'1991
rename `i'111992 `i'1992
rename `i'111993 `i'1993
rename `i'111994 `i'1994	
rename `i'111995 `i'1995
rename `i'111996 `i'1996
rename `i'111997 `i'1997
rename `i'111998 `i'1998
rename `i'111999 `i'1999
rename `i'112000 `i'2000
rename `i'112001 `i'2001
rename `i'112002 `i'2002
rename `i'112003 `i'2003
rename `i'112004 `i'2004
rename `i'112005 `i'2005
rename `i'112006 `i'2006
rename `i'112007 `i'2007
rename `i'112008 `i'2008
rename `i'112009 `i'2009
rename `i'112010 `i'2010
rename `i'112011 `i'2011
rename `i'112012 `i'2012
rename `i'112013 `i'2013
}


*(Average) Secondary enrollment, math quality test, languaje quality test, "Saber" indicator, by time period:
foreach i in tasa_escolaridad_secund Saber_ indicador_saber sum_lenguaje sum_matematica{
egen `i'00_02=rmean(`i'2000 `i'2001 `i'2002)
egen `i'03_06=rmean(`i'2003 `i'2004 `i'2005 `i'2006)
egen `i'07_10=rmean(`i'2007 `i'2008 `i'2009 `i'2010)
egen `i'03_10=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)
egen `i'11_13=rmean(`i'2011 `i'2012 `i'2013)
}


***************
*LAND OUTCOMES*
***************
  
*(Average) Land informality:
foreach i in informalidad{
egen `i'03_06=rmean(`i'2003 `i'2004 `i'2005 `i'2006)
}


*(Average) Property owner gini, Land owner gini, share of land richest 10%, share of land richest 1%, per capita land value, cadastral update lag, and number of cadastral updates: 
foreach i in ginipropietario gini_terreno tenperc oneperc avaluo_rur avaluo_rur_pcrur rezago_catastral numactualizaciones{
egen `i'03_06=rmean(`i'2003 `i'2004 `i'2005 `i'2006)
}


********************
*ELECTORAL OUTCOMES*
********************
 
*(Average) Mayor vote share by political party ideology (or political party coalition):
  foreach i in share_left_party share_left_party_liberal share_tradicional share_uribe share_conservador share_liberal{
  egen `i'94_96=rmean(`i'94 `i'95 `i'96)
  egen `i'97_99=rmean(`i'97 `i'98 `i'99)
  egen `i'00_02=rmean(`i'00 `i'01 `i'02)
  egen `i'97_00=rmean(`i'97 `i'98 `i'99 `i'00 `i'01 `i'02)
  egen `i'03_06=rmean(`i'03 `i'04 `i'05 `i'06)
  egen `i'03_10=rmean(`i'03 `i'04 `i'05 `i'06 `i'07 `i'08 `i'09 `i'10)
  egen `i'07_10=rmean(`i'07 `i'08 `i'09 `i'10)
  egen `i'03_07=rowtotal(`i'03 `i'07)
  egen `i'11_12=rmean(`i'11 `i'12)
  }
  
  foreach i in share_uribe_conservador {
  egen `i'94_96=rmean(`i'94 `i'95 `i'96)
  egen `i'97_99=rmean(`i'97 `i'98 `i'99)
  egen `i'00_02=rmean(`i'00 `i'01 `i'02)
  egen `i'97_00=rmean(`i'97 `i'98 `i'99 `i'00 `i'01 `i'02)
  egen `i'03_06=rmean(`i'03 `i'04 `i'05 `i'06)
  egen `i'03_10=rmean(`i'03 `i'04 `i'05 `i'06 `i'07 `i'08 `i'09 `i'10)
  egen `i'07_10=rmean(`i'07 `i'08 `i'09 `i'10)
  egen `i'03_07=rowtotal(`i'03 `i'07)
  egen `i'11_12=rmean(`i'11 `i'12)
  }
  

*(Average) City council vote share by political party ideology (or political party coalition):
  foreach i in share_cc_left_party share_cc_left_party_liberal share_cc_tradicional share_cc_uribe share_cc_conservador share_cc_liberal{
  egen `i'94_96=rmean(`i'94 `i'95 `i'96)
  egen `i'97_99=rmean(`i'97 `i'98 `i'99)
  egen `i'00_02=rmean(`i'00 `i'01 `i'02)
  egen `i'97_00=rmean(`i'97 `i'98 `i'99 `i'00 `i'01 `i'02)
  egen `i'03_06=rmean(`i'03 `i'04 `i'05 `i'06)
  egen `i'03_10=rmean(`i'03 `i'04 `i'05 `i'06 `i'07 `i'08 `i'09 `i'10)
  egen `i'07_10=rmean(`i'07 `i'08 `i'09 `i'10)
  egen `i'03_07=rowtotal(`i'03 `i'07)
  egen `i'11_12=rmean(`i'11 `i'12)
  }
  
  foreach i in share_cc_uribe_conservador{
  egen `i'94_96=rmean(`i'94 `i'95 `i'96)
  egen `i'97_99=rmean(`i'97 `i'98 `i'99)
  egen `i'00_02=rmean(`i'00 `i'01 `i'02)
  egen `i'97_00=rmean(`i'97 `i'98 `i'99 `i'00 `i'01 `i'02)
  egen `i'03_06=rmean(`i'03 `i'04 `i'05 `i'06)
  egen `i'03_10=rmean(`i'03 `i'04 `i'05 `i'06 `i'07 `i'08 `i'09 `i'10)
  egen `i'07_10=rmean(`i'07 `i'08 `i'09 `i'10)
  egen `i'03_07=rowtotal(`i'03 `i'07)
  egen `i'11_12=rmean(`i'11 `i'12)
  }
  
 *Won merge 1997 and 2000 election: 
 gen won_uribe_conservador97_00 = 0 
 replace won_uribe_conservador97_00 = 1 if won_uribe_conservador97_99==1 | won_uribe_conservador00_02==1
 
 gen won_left_party97_00 = 0 
 replace won_left_party97_00 = 1 if won_left_party97_99==1 | won_left_party00_02 ==1
  
  
 *Won merge 2003 and 2007 election: 
 gen won_uribe_conservador03_07 = 0 
 replace won_uribe_conservador03_07 = 1 if won_uribe_conservador03_06==1 | won_uribe_conservador07_10==1
 
 gen won_left_party03_07 = 0 
 replace won_left_party03_07 = 1 if won_left_party03_06==1 | won_left_party07_10 ==1
 

*-------------------*
*3 Control variables*
*-------------------*

*Royalties and transfers per capita:
foreach i in regalias transferencias{
foreach j in Total_Poblacion{
gen `i'88_pc = `i'1988/`j'1988
gen `i'89_pc = `i'1989/`j'1989
gen `i'90_pc = `i'1990/`j'1990
gen `i'91_pc = `i'1991/`j'1991
gen `i'92_pc = `i'1992/`j'1992
gen `i'93_pc = `i'1993/`j'1993
gen `i'94_pc = `i'1994/`j'1994
gen `i'95_pc = `i'1995/`j'1995
gen `i'96_pc = `i'1996/`j'1996
gen `i'97_pc = `i'1997/`j'1997
gen `i'98_pc = `i'1998/`j'1998
gen `i'99_pc = `i'1999/`j'1999
gen `i'00_pc = `i'2000/`j'2000
gen `i'01_pc = `i'2001/`j'2001
gen `i'02_pc = `i'2002/`j'2002
gen `i'03_pc = `i'2003/`j'2003
gen `i'04_pc = `i'2004/`j'2004
gen `i'05_pc = `i'2005/`j'2005
gen `i'06_pc = `i'2006/`j'2006
gen `i'07_pc = `i'2007/`j'2007
gen `i'08_pc = `i'2008/`j'2008
gen `i'09_pc = `i'2009/`j'2009
gen `i'10_pc = `i'2010/`j'2010
gen `i'11_pc = `i'2011/`j'2011
gen `i'12_pc = `i'2012/`j'2012
gen `i'13_pc = `i'2013/`j'2013

}
}

*Mean of royalties and transfers per capita, by period
foreach i in regalias transferencias{

*Six year windows:
egen `i'1988_1993_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc)
egen `i'1989_1994_pc=rmean(`i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc)
egen `i'1990_1995_pc=rmean(`i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc)
egen `i'1991_1996_pc=rmean(`i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1992_1997_pc=rmean(`i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc)
egen `i'1993_1998_pc=rmean(`i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc)
egen `i'1994_1999_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc)
egen `i'1995_2000_pc=rmean(`i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1996_2001_pc=rmean(`i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc)
egen `i'1997_2002_pc=rmean(`i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1998_2003_pc=rmean(`i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc)
egen `i'1999_2004_pc=rmean(`i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc)
egen `i'2000_2005_pc=rmean(`i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc)
egen `i'2001_2006_pc=rmean(`i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc)
egen `i'2002_2007_pc=rmean(`i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc)
egen `i'2003_2008_pc=rmean(`i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc)
egen `i'2004_2009_pc=rmean(`i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc)
egen `i'2005_2010_pc=rmean(`i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)

*Eight year windows:
egen `i'1988_1995_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc)
egen `i'1989_1996_pc=rmean(`i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1990_1997_pc=rmean(`i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc)
egen `i'1991_1998_pc=rmean(`i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc)
egen `i'1992_1999_pc=rmean(`i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc)
egen `i'1993_2000_pc=rmean(`i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1994_2001_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc)
egen `i'1995_2002_pc=rmean(`i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1996_2003_pc=rmean(`i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc)
egen `i'1997_2004_pc=rmean(`i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc)
egen `i'1998_2005_pc=rmean(`i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc)
egen `i'1999_2006_pc=rmean(`i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc)
egen `i'2000_2007_pc=rmean(`i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc)
egen `i'2001_2008_pc=rmean(`i'01_pc `i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc)
egen `i'2002_2009_pc=rmean(`i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc)
egen `i'2003_2010_pc=rmean(`i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)


*Other years:
egen `i'1988_1989_pc=rmean(`i'88_pc `i'89_pc )
egen `i'1988_1990_pc=rmean(`i'88_pc `i'89_pc `i'90_pc)
egen `i'1988_1991_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc)
egen `i'1988_1992_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc)
egen `i'1988_1994_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc)
egen `i'2005_2006_pc=rmean(`i'05_pc `i'06_pc)
egen `i'1988_1996_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1988_1997_pc=rmean(`i'88_pc `i'89_pc `i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc `i'97_pc)
egen `i'1990_1996_pc=rmean(`i'90_pc `i'91_pc `i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1992_1996_pc=rmean(`i'92_pc `i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1993_1996_pc=rmean(`i'93_pc `i'94_pc `i'95_pc `i'96_pc)
egen `i'1995_1996_pc=rmean(`i'95_pc `i'96_pc)
egen `i'1996_2002_pc=rmean(`i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1996_2000_pc=rmean(`i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1996_1999_pc=rmean(`i'96_pc `i'97_pc `i'98_pc `i'99_pc)
egen `i'1996_1998_pc=rmean(`i'96_pc `i'97_pc `i'98_pc)
egen `i'1996_1997_pc=rmean(`i'96_pc `i'97_pc)
egen `i'1994_1995_pc=rmean(`i'94_pc `i'95_pc )
egen `i'1994_1996_pc=rmean(`i'94_pc `i'95_pc `i'96_pc)
egen `i'1994_1997_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc )
egen `i'1994_1998_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc)
egen `i'1994_2000_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1994_2002_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1994_2003_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc)
egen `i'1994_2004_pc=rmean(`i'94_pc `i'95_pc `i'96_pc `i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc `i'04_pc)
egen `i'1997_1998_pc=rmean(`i'97_pc `i'98_pc)
egen `i'1997_1999_pc=rmean(`i'97_pc `i'98_pc `i'99_pc)
egen `i'1997_2000_pc=rmean(`i'97_pc `i'98_pc `i'99_pc `i'00_pc)
egen `i'1997_2001_pc=rmean(`i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc)
egen `i'1997_2003_pc=rmean(`i'97_pc `i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc `i'03_pc)
egen `i'1998_2002_pc=rmean(`i'98_pc `i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'1999_2002_pc=rmean(`i'99_pc `i'00_pc `i'01_pc `i'02_pc)
egen `i'2000_2002_pc=rmean(`i'00_pc `i'01_pc `i'02_pc)
egen `i'2001_2002_pc=rmean(`i'01_pc `i'02_pc)
egen `i'2002_2010_pc=rmean(`i'02_pc `i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)
egen `i'2003_2004_pc=rmean(`i'03_pc `i'04_pc)
egen `i'2003_2005_pc=rmean(`i'03_pc `i'04_pc `i'05_pc)
egen `i'2003_2006_pc=rmean(`i'03_pc `i'04_pc `i'05_pc `i'06_pc)
egen `i'2003_2007_pc=rmean(`i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc)
egen `i'2003_2009_pc=rmean(`i'03_pc `i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc)
egen `i'2004_2010_pc=rmean(`i'04_pc `i'05_pc `i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)
egen `i'2006_2010_pc=rmean(`i'06_pc `i'07_pc `i'08_pc `i'09_pc `i'10_pc)
egen `i'2007_2010_pc=rmean(`i'07_pc `i'08_pc `i'09_pc `i'10_pc)
egen `i'2008_2010_pc=rmean(`i'08_pc `i'09_pc `i'10_pc)
egen `i'2009_2010_pc=rmean(`i'09_pc `i'10_pc)
egen `i'2011_2013_pc=rmean(`i'11_pc `i'12_pc `i'13_pc)
}


*(Average) Population, by period:
foreach i in Total_Poblacion{
/*Six year windows:
egen `i'1988_1993=rowmean(`i'88 `i'89 `i'90 `i'91 `i'92 `i'93)
egen `i'1989_1994=rowmean(`i'89 `i'90 `i'91 `i'92 `i'93 `i'94)
egen `i'1990_1995=rowmean(`i'90 `i'91 `i'92 `i'93 `i'94 `i'95)
egen `i'1991_1996=rowmean(`i'91 `i'92 `i'93 `i'94 `i'95 `i'96)
egen `i'1992_1997=rowmean(`i'92 `i'93 `i'94 `i'95 `i'96 `i'97)
egen `i'1993_1998=rowmean(`i'93 `i'94 `i'95 `i'96 `i'97 `i'98)
egen `i'1994_1999=rowmean(`i'94 `i'95 `i'96 `i'97 `i'98 `i'99)
egen `i'1995_2000=rowmean(`i'95 `i'96 `i'97 `i'98 `i'99 `i'00)
egen `i'1996_2001=rowmean(`i'96 `i'97 `i'98 `i'99 `i'00 `i'01)
egen `i'1997_2002=rowmean(`i'97 `i'98 `i'99 `i'00 `i'01 `i'02)
egen `i'1998_2003=rowmean(`i'98 `i'99 `i'00 `i'01 `i'02 `i'03)
egen `i'1999_2004=rowmean(`i'99 `i'00 `i'01 `i'02 `i'03 `i'04)
egen `i'2000_2005=rowmean(`i'00 `i'01 `i'02 `i'03 `i'04 `i'05)
egen `i'2001_2006=rowmean(`i'01 `i'02 `i'03 `i'04 `i'05 `i'06)
egen `i'2002_2007=rowmean(`i'02 `i'03 `i'04 `i'05 `i'06 `i'07)
egen `i'2003_2008=rowmean(`i'03 `i'04 `i'05 `i'06 `i'07 `i'08)
egen `i'2004_2009=rowmean(`i'04 `i'05 `i'06 `i'07 `i'08 `i'09)
egen `i'2005_2010=rowmean(`i'05 `i'06 `i'07 `i'08 `i'09 `i'10)

*Eight year windows:
egen `i'1988_1995=rowmean(`i'88 `i'89 `i'90 `i'91 `i'92 `i'93 `i'94 `i'95)
egen `i'1989_1996=rowmean(`i'89 `i'90 `i'91 `i'92 `i'93 `i'94 `i'95 `i'96)
egen `i'1990_1997=rowmean(`i'90 `i'91 `i'92 `i'93 `i'94 `i'95 `i'96 `i'97)
egen `i'1991_1998=rowmean(`i'91 `i'92 `i'93 `i'94 `i'95 `i'96 `i'97 `i'98)
egen `i'1992_1999=rowmean(`i'92 `i'93 `i'94 `i'95 `i'96 `i'97 `i'98 `i'99)
egen `i'1993_2000=rowmean(`i'93 `i'94 `i'95 `i'96 `i'97 `i'98 `i'99 `i'00)
egen `i'1994_2001=rowmean(`i'94 `i'95 `i'96 `i'97 `i'98 `i'99 `i'00 `i'01)
egen `i'1995_2002=rowmean(`i'95 `i'96 `i'97 `i'98 `i'99 `i'00 `i'01 `i'02)
egen `i'1996_2003=rowmean(`i'96 `i'97 `i'98 `i'99 `i'00 `i'01 `i'02 `i'03)
egen `i'1997_2004=rowmean(`i'97 `i'98 `i'99 `i'00 `i'01 `i'02 `i'03 `i'04)
egen `i'1998_2005=rowmean(`i'98 `i'99 `i'00 `i'01 `i'02 `i'03 `i'04 `i'05)
egen `i'1999_2006=rowmean(`i'99 `i'00 `i'01 `i'02 `i'03 `i'04 `i'05 `i'06)
egen `i'2000_2007=rowmean(`i'00 `i'01 `i'02 `i'03 `i'04 `i'05 `i'06 `i'07)
egen `i'2001_2008=rowmean(`i'01 `i'02 `i'03 `i'04 `i'05 `i'06 `i'07 `i'08)
egen `i'2002_2009=rowmean(`i'02 `i'03 `i'04 `i'05 `i'06 `i'07 `i'08 `i'09)
egen `i'2003_2010=rowmean(`i'03 `i'04 `i'05 `i'06 `i'07 `i'08 `i'09 `i'10)
*/
*Other years:
egen `i'1988_1989=rmean(`i'1988 `i'1989)
egen `i'1988_1990=rmean(`i'1988 `i'1989 `i'1990 )
egen `i'1988_1991=rmean(`i'1988 `i'1989 `i'1990 `i'1991)
egen `i'1988_1992=rmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992)
egen `i'1988_1993=rmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993)
egen `i'1988_1994=rmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994)
egen `i'1988_1995=rmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'2005_2006=rmean(`i'2005 `i'2006)
egen `i'1988_1996=rmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1988_1997=rmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1989_1996=rmean(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1990_1996=rmean(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1991_1996=rmean(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1992_1996=rmean(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1993_1996=rmean(`i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1995_1996=rmean(`i'1995 `i'1996)
egen `i'1995_2002=rmean(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1996_2003=rmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1996_2002=rmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1994_1995=rmean(`i'1994 `i'1995 `i'1996)
egen `i'1994_1996=rmean(`i'1994 `i'1995 `i'1996)
egen `i'1994_1997=rmean(`i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1994_1998=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 )
egen `i'1994_1999=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 )
egen `i'1994_2000=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1994_2001=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1994_2002=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1994_2003=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1994_2004=rmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'1996_2001=rmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1996_2000=rmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1996_1999=rmean(`i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1996_1998=rmean(`i'1996 `i'1997 `i'1998)
egen `i'1996_1997=rmean(`i'1996 `i'1997)
egen `i'1997_2003=rmean(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1997_2002=rmean(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1997_2001=rmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1997_2000=rmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1997_1999=rmean(`i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1997_1998=rmean(`i'1996 `i'1997 `i'1998)
egen `i'1998_2002=rmean(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1999_2002=rmean(`i'1999 `i'2000 `i'2001 `i'2002)
egen `i'2000_2002=rmean(`i'2000 `i'2001 `i'2002)
egen `i'2001_2002=rmean(`i'2001 `i'2002)
egen `i'2002_2010=rmean(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2003_2004=rmean(`i'2003 `i'2004)
egen `i'2003_2005=rmean(`i'2003 `i'2004 `i'2005)
egen `i'2003_2006=rmean(`i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2003_2007=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2003_2008=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2003_2009=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2003_2010=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2004_2010=rmean(`i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2005_2010=rmean(`i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2006_2010=rmean(`i'2006 `i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2007_2010=rmean(`i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2008_2010=rmean(`i'2008 `i'2009 `i'2010)
egen `i'2009_2010=rmean(`i'2009 `i'2010)
egen `i'2011_2013=rmean(`i'2011 `i'2012 `i'2013)
}

*(Logged) Average population, by period:
gen lpob1988_1989=log(Total_Poblacion1988_1989)
gen lpob1988_1990=log(Total_Poblacion1988_1990)
gen lpob1988_1991=log(Total_Poblacion1988_1991)
gen lpob1988_1992=log(Total_Poblacion1988_1992)
gen lpob1988_1993=log(Total_Poblacion1988_1993)
gen lpob1988_1994=log(Total_Poblacion1988_1994)
gen lpob1988_1995=log(Total_Poblacion1988_1995)
gen lpob1988_1996=log(Total_Poblacion1988_1996)
gen lpob1988_1997=log(Total_Poblacion1988_1997)
gen lpob2005_2006=log(Total_Poblacion2005_2006)
gen lpob1989_1996=log(Total_Poblacion1989_1996)
gen lpob1990_1996=log(Total_Poblacion1990_1996)
gen lpob1991_1996=log(Total_Poblacion1991_1996)
gen lpob1992_1996=log(Total_Poblacion1992_1996)
gen lpob1993_1996=log(Total_Poblacion1993_1996)
gen lpob1995_1996=log(Total_Poblacion1995_1996)
gen lpob1995_2002=log(Total_Poblacion1995_2002)
gen lpob1996_2003=log(Total_Poblacion1996_2003)
gen lpob1996_2002=log(Total_Poblacion1996_2002)
gen lpob1996_2001=log(Total_Poblacion1996_2001)
gen lpob1996_2000=log(Total_Poblacion1996_2000)
gen lpob1996_1999=log(Total_Poblacion1996_1999)
gen lpob1996_1998=log(Total_Poblacion1996_1998)
gen lpob1996_1997=log(Total_Poblacion1996_1997)
gen lpob1994_1995=log(Total_Poblacion1994_1995)
gen lpob1994_1996=log(Total_Poblacion1994_1996)
gen lpob1994_1997=log(Total_Poblacion1994_1997)
gen lpob1994_1998=log(Total_Poblacion1994_1998)
gen lpob1994_1999=log(Total_Poblacion1994_1999)
gen lpob1994_2000=log(Total_Poblacion1994_2000)
gen lpob1994_2001=log(Total_Poblacion1994_2001)
gen lpob1994_2002=log(Total_Poblacion1994_2002)
gen lpob1994_2003=log(Total_Poblacion1994_2003)
gen lpob1994_2004=log(Total_Poblacion1994_2004)
gen lpob1997_1998=log(Total_Poblacion1997_1998)
gen lpob1997_1999=log(Total_Poblacion1997_1999)
gen lpob1997_2000=log(Total_Poblacion1997_2000)
gen lpob1997_2001=log(Total_Poblacion1997_2001)
gen lpob1997_2002=log(Total_Poblacion1997_2002)
gen lpob1997_2003=log(Total_Poblacion1997_2003)
gen lpob1998_2002=log(Total_Poblacion1998_2002)
gen lpob1999_2002=log(Total_Poblacion1999_2002)
gen lpob2000_2002=log(Total_Poblacion2000_2002)
gen lpob2001_2002=log(Total_Poblacion2001_2002)
gen lpob2002_2010=log(Total_Poblacion2002_2010)
gen lpob2003_2004=log(Total_Poblacion2003_2004)
gen lpob2003_2005=log(Total_Poblacion2003_2005)
gen lpob2003_2006=log(Total_Poblacion2003_2006)
gen lpob2003_2007=log(Total_Poblacion2003_2007)
gen lpob2003_2008=log(Total_Poblacion2003_2008)
gen lpob2003_2009=log(Total_Poblacion2003_2009)
gen lpob2003_2010=log(Total_Poblacion2003_2010)
gen lpob2004_2010=log(Total_Poblacion2004_2010)
gen lpob2005_2010=log(Total_Poblacion2005_2010)
gen lpob2006_2010=log(Total_Poblacion2006_2010)
gen lpob2007_2010=log(Total_Poblacion2007_2010)
gen lpob2008_2010=log(Total_Poblacion2008_2010)
gen lpob2009_2010=log(Total_Poblacion2009_2010)
gen lpob2011_2013=log(Total_Poblacion2011_2013)



*Political party in government, Mayor:

 *For major: 
  foreach i in herf_alc herf_alc_party herf_conc num_candidates_alc num_candidates_conc margin N NP N_conc NP_conc I I_conc vote_share_left vote_share_trad vote_share_et vote_share_third{
  egen `i'94_96=rmean( `i'1994 `i'1995 `i'1996)
  egen `i'00_02=rmean(`i'2000 `i'2001 `i'2002)
  egen `i'03_06=rmean(`i'2003 `i'2004 `i'2005 `i'2006)
  egen `i'11_12=rmean(`i'2011 `i'2012)
  }
 
 *For city council
  foreach i in vote_share_conc_left vote_share_conc_trad vote_share_conc_et vote_share_conc_third{
  egen `i'94_96=rmean( `i'94 `i'95 `i'96)
  egen `i'00_02=rmean(`i'00 `i'01 `i'02)
  egen `i'03_06=rmean(`i'03 `i'04 `i'05 `i'06)
  egen `i'11_12=rmean(`i'11 `i'12)
  }
 
  foreach i in party_frac_N party_frac_NP party_frac_I{
  egen `i'94_96=rmean( `i'1994 `i'1995 `i'1996)
  egen `i'00_02=rmean(`i'2000 `i'2001 `i'2002)
  egen `i'03_06=rmean(`i'2003 `i'2004 `i'2005 `i'2006)
  }
  
 *The one build by Vargas et al (2014):
  foreach i in vote_share_left vote_share_trad vote_share_et vote_share_third vote_share_conc_left vote_share_conc_trad vote_share_conc_et vote_share_conc_third{
  egen `i'94_96_1=rmean( `i'94_1 `i'95_1 `i'96_1)
  egen `i'00_02_1=rmean(`i'00_1 `i'01_1 `i'02_1)
  egen `i'03_06_1=rmean(`i'03_1 `i'04_1 `i'05_1 `i'06_1)
  egen `i'11_12_1=rmean(`i'11_1 `i'12_1)
  }

foreach i in 1994 2000 2003 2007 2011{
gen left`i'=0
replace left`i' =1 if vote_share_left`i'> vote_share_trad`i' & vote_share_left`i'> vote_share_et`i' & vote_share_left`i'> vote_share_third`i'

gen trad`i'=0
replace trad`i' =1 if vote_share_trad`i'> vote_share_left`i' & vote_share_trad`i'> vote_share_et`i' & vote_share_trad`i'> vote_share_third`i'

gen et`i'=0
replace et`i'=1 if vote_share_et`i'> vote_share_left`i' & vote_share_et`i'>vote_share_trad`i' & vote_share_et`i'> vote_share_third`i'

gen third`i'=0
replace third`i'=1 if vote_share_third`i'>vote_share_left`i' & vote_share_third`i'> vote_share_trad`i' & vote_share_third`i'> vote_share_et`i'

gen otherparty`i'=0
replace otherparty`i'=1 if left`i'!=1 & trad`i'!=1 & et`i'!=1 & third`i'!=1

replace third`i'=1 if otherparty`i'==1
}

*Pol party with biggest majority (City Council):
foreach i in 94 00 07{
gen left_con`i'=0
replace left_con`i' =1 if vote_share_conc_left`i'> vote_share_conc_trad`i' & vote_share_conc_left`i'> vote_share_conc_et`i' & vote_share_conc_left`i'> vote_share_conc_third`i'

gen trad_con`i'=0
replace trad_con`i' =1 if vote_share_conc_trad`i'> vote_share_conc_left`i' & vote_share_conc_trad`i'> vote_share_conc_et`i' & vote_share_conc_trad`i'> vote_share_conc_third`i'

gen et_con`i'=0
replace et_con`i'=1 if vote_share_conc_et`i'> vote_share_conc_left`i' & vote_share_conc_et`i'>vote_share_conc_trad`i' & vote_share_conc_et`i'> vote_share_conc_third`i'

gen third_con`i'=0
replace third_con`i'=1 if vote_share_conc_third`i'>vote_share_conc_left`i' & vote_share_conc_third`i'> vote_share_conc_trad`i' & vote_share_conc_third`i'> vote_share_conc_et`i'

gen otherparty_con`i'=0
replace otherparty_con`i'=1 if left_con`i'!=1 & trad_con`i'!=1 & et_con`i'!=1 & third_con`i'!=1

replace third_con`i'=1 if otherparty_con`i'==1

}


*"Peaceful" municipalities dummy 
foreach i in guer para{

*Six year windows:
egen `i'1988_1993=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993)
egen `i'1989_1994=rowtotal(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994)
egen `i'1990_1995=rowtotal(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1991_1996=rowtotal(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1992_1997=rowtotal(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1993_1998=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1994_1999=rowtotal(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1995_2000=rowtotal(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1996_2001=rowtotal(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1997_2002=rowtotal(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1998_2003=rowtotal(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1999_2004=rowtotal(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'2000_2005=rowtotal(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'2001_2006=rowtotal(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2002_2007=rowtotal(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2003_2008=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2004_2009=rowtotal(`i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2005_2010=rowtotal(`i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)

*Eight year windows:
egen `i'1988_1995=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1989_1996=rowtotal(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1990_1997=rowtotal(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1991_1998=rowtotal(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1992_1999=rowtotal(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1993_2000=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1994_2001=rowtotal(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1995_2002=rowtotal(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1996_2003=rowtotal(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1997_2004=rowtotal(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'1998_2005=rowtotal(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'1999_2006=rowtotal(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2000_2007=rowtotal(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2001_2008=rowtotal(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2002_2009=rowtotal(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2003_2010=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)

*Other years:
egen `i'1988_1996=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1997_1999=rowtotal(`i'1997 `i'1998 `i'1999)
egen `i'2007_2010=rowtotal(`i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2003_2006=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006)
egen `i'1993_1996=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996)
egen `i'2011_2013=rowtotal(`i'2011 `i'2012 `i'2013)
}


foreach i in 1988_1996 1997_1999 2003_2006 2007_2010 1988_1993 1989_1994 1990_1995 1991_1996 1992_1997 1993_1998 1994_1999 1995_2000 1996_2001 1997_2002 1998_2003 1999_2004 2000_2005 2001_2006 2002_2007 2003_2008 2004_2009 2005_2010 1988_1995 1989_1996 1990_1997 1991_1998 1992_1999 1993_2000 1994_2001 1995_2002 1996_2003 1997_2004 1998_2005 1999_2006 2000_2007 2001_2008 2002_2009 2003_2010{
gen peaceful`i'=0
replace peaceful`i'=1 if guer`i'==0 & para`i'==0

gen peaceful_2_`i'=0
replace peaceful_2_`i'=1 if guer`i'==0 | para`i'==0
}


*(Average) Military bases: 
foreach i in mil_bases_{
*Six year windows:
egen `i'1999_2004=rmean(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'2000_2005=rmean(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'2001_2006=rmean(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2002_2007=rmean(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2003_2008=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2004_2009=rmean(`i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2005_2009=rmean(`i'2005 `i'2006 `i'2007 `i'2008 `i'2009)

*Eight year windows: 
egen `i'1999_2006=rmean(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2000_2007=rmean(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2001_2008=rmean(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2002_2009=rmean(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)

*Other years:
egen `i'1999_2000=rmean(`i'1999 `i'2000)
egen `i'1999_2001=rmean(`i'1999 `i'2000 `i'2001)
egen `i'1999_2002=rmean(`i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1999_2003=rmean(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1999_2005=rmean(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'2000_2002=rmean(`i'2000 `i'2001 `i'2002)
egen `i'2003_2010=rmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2007_2009=rmean(`i'2007 `i'2008 `i'2009)
egen `i'2003_2006=rmean(`i'2003 `i'2004 `i'2005 `i'2006)

}

*Paramilitary desmobilization dummy: 
foreach i in num_desmo{
egen `i'2003_2004=rowtotal(`i'2003 `i'2004)
egen `i'2005_2006=rowtotal(`i'2005 `i'2006)
egen `i'2003_2006=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006)
}

gen demobilization=0
replace demobilization=1 if num_desmo2003_2006>0
 
*Displacements:
foreach i in rec_total exp_total desplazados{
	
/*Six year windows:
egen `i'1988_1993=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993)
egen `i'1989_1994=rowtotal(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994)
egen `i'1990_1995=rowtotal(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1991_1996=rowtotal(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1992_1997=rowtotal(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)*/
egen `i'1993_1998=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1994_1999=rowtotal(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1995_2000=rowtotal(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1996_2001=rowtotal(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1997_2002=rowtotal(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1998_2003=rowtotal(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1999_2004=rowtotal(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'2000_2005=rowtotal(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'2001_2006=rowtotal(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2002_2007=rowtotal(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2003_2008=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2004_2009=rowtotal(`i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2005_2010=rowtotal(`i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)

/*Eight year windows:
egen `i'1988_1995=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1989_1996=rowtotal(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1990_1997=rowtotal(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1991_1998=rowtotal(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1992_1999=rowtotal(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)*/
egen `i'1993_2000=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1994_2001=rowtotal(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1995_2002=rowtotal(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1996_2003=rowtotal(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1997_2004=rowtotal(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'1998_2005=rowtotal(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'1999_2006=rowtotal(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2000_2007=rowtotal(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2001_2008=rowtotal(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2002_2009=rowtotal(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2003_2010=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)

*Other years: 
egen `i'1993_1995=rowtotal(`i'1993 `i'1994 `i'1995)
egen `i'1993_1996=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1993_1997=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1993_1999=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'2000_2002=rowtotal(`i'2000 `i'2001 `i'2002)
egen `i'1997_1999=rowtotal(`i'1997 `i'1998 `i'1999)
egen `i'2003_2006=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2007_2010=rowtotal(`i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2011_2012=rowtotal(`i'2011 `i'2012)
}

*Coca production:
foreach i in coca{

*Six year windows:
egen `i'1988_1993=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993)
egen `i'1989_1994=rowtotal(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994)
egen `i'1990_1995=rowtotal(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1991_1996=rowtotal(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1992_1997=rowtotal(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1993_1998=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1994_1999=rowtotal(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1995_2000=rowtotal(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1996_2001=rowtotal(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1997_2002=rowtotal(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1998_2003=rowtotal(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1999_2004=rowtotal(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'2000_2005=rowtotal(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'2001_2006=rowtotal(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2002_2007=rowtotal(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2003_2008=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2004_2009=rowtotal(`i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2005_2010=rowtotal(`i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)

*Eight year windows:
egen `i'1988_1995=rowtotal(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1989_1996=rowtotal(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1990_1997=rowtotal(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1991_1998=rowtotal(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1992_1999=rowtotal(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1993_2000=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1994_2001=rowtotal(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1995_2002=rowtotal(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1996_2003=rowtotal(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1997_2004=rowtotal(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'1998_2005=rowtotal(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'1999_2006=rowtotal(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2000_2007=rowtotal(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2001_2008=rowtotal(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2002_2009=rowtotal(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2003_2010=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)


*Other years:
egen `i'1993_1996=rowtotal(`i'1993 `i'1994 `i'1995 `i'1996)
egen `i'2000_2002=rowtotal(`i'2000 `i'2001 `i'2002)
egen `i'1997_1999=rowtotal(`i'1997 `i'1998 `i'1999)
egen `i'2003_2006=rowtotal(`i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2007_2010=rowtotal(`i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2011_2012=rowtotal(`i'2011 `i'2012)
}

*Endowments:
rename goldsilvplat_20081997 gold1997
rename goldsilvplat_20081998 gold1998
rename goldsilvplat_20081999 gold1999
rename goldsilvplat_20082000 gold2000
rename goldsilvplat_20082001 gold2001
rename goldsilvplat_20082002 gold2002
rename goldsilvplat_20082003 gold2003
rename goldsilvplat_20082004 gold2004
rename goldsilvplat_20082005 gold2005
rename goldsilvplat_20082006 gold2006
rename goldsilvplat_20082007 gold2007
rename goldsilvplat_20082008 gold2008
rename goldsilvplat_20082009 gold2009
rename goldsilvplat_20082010 gold2010
rename goldsilvplat_20082011 gold2011
rename goldsilvplat_20082012 gold2012


rename nickel_20081997 nickel1997
rename nickel_20081998 nickel1998
rename nickel_20081999 nickel1999
rename nickel_20082000 nickel2000
rename nickel_20082001 nickel2001
rename nickel_20082002 nickel2002
rename nickel_20082003 nickel2003
rename nickel_20082004 nickel2004
rename nickel_20082005 nickel2005
rename nickel_20082006 nickel2006
rename nickel_20082007 nickel2007
rename nickel_20082008 nickel2008
rename nickel_20082009 nickel2009
rename nickel_20082010 nickel2010
rename nickel_20082011 nickel2011
rename nickel_20082012 nickel2012


rename emeralds_20081997 emeralds1997
rename emeralds_20081998 emeralds1998
rename emeralds_20081999 emeralds1999
rename emeralds_20082000 emeralds2000
rename emeralds_20082001 emeralds2001
rename emeralds_20082002 emeralds2002
rename emeralds_20082003 emeralds2003
rename emeralds_20082004 emeralds2004
rename emeralds_20082005 emeralds2005
rename emeralds_20082006 emeralds2006
rename emeralds_20082007 emeralds2007
rename emeralds_20082008 emeralds2008
rename emeralds_20082009 emeralds2009
rename emeralds_20082010 emeralds2010
rename emeralds_20082011 emeralds2011
rename emeralds_20082012 emeralds2012


rename iron_20081997 iron1997
rename iron_20081998 iron1998
rename iron_20081999 iron1999
rename iron_20082000 iron2000
rename iron_20082001 iron2001
rename iron_20082002 iron2002
rename iron_20082003 iron2003
rename iron_20082004 iron2004
rename iron_20082005 iron2005
rename iron_20082006 iron2006
rename iron_20082007 iron2007
rename iron_20082008 iron2008
rename iron_20082009 iron2009
rename iron_20082010 iron2010
rename iron_20082011 iron2011
rename iron_20082012 iron2012


foreach i in gold nickel emeralds iron{
/*Six year windows:
egen `i'1988_1993=rowmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993)
egen `i'1989_1994=rowmean(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994)
egen `i'1990_1995=rowmean(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1991_1996=rowmean(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1992_1997=rowmean(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1993_1998=rowmean(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1994_1999=rowmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1995_2000=rowmean(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1996_2001=rowmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)*/
egen `i'1997_1998=rowmean(`i'1997 `i'1998)
egen `i'1997_1999=rowmean(`i'1997 `i'1998 `i'1999)
egen `i'1997_2000=rowmean(`i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1997_2001=rowmean(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1997_2002=rowmean(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1998_2003=rowmean(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1999_2004=rowmean(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'2000_2005=rowmean(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'2001_2006=rowmean(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2002_2007=rowmean(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2003_2008=rowmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2004_2009=rowmean(`i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2005_2010=rowmean(`i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)

/*Eight year windows:
egen `i'1988_1995=rowmean(`i'1988 `i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995)
egen `i'1989_1996=rowmean(`i'1989 `i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996)
egen `i'1990_1997=rowmean(`i'1990 `i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997)
egen `i'1991_1998=rowmean(`i'1991 `i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998)
egen `i'1992_1999=rowmean(`i'1992 `i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999)
egen `i'1993_2000=rowmean(`i'1993 `i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000)
egen `i'1994_2001=rowmean(`i'1994 `i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001)
egen `i'1995_2002=rowmean(`i'1995 `i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002)
egen `i'1996_2003=rowmean(`i'1996 `i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)*/
egen `i'1997_2003=rowmean(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003)
egen `i'1997_2004=rowmean(`i'1997 `i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004)
egen `i'1998_2005=rowmean(`i'1998 `i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005)
egen `i'1999_2006=rowmean(`i'1999 `i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2000_2007=rowmean(`i'2000 `i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007)
egen `i'2001_2008=rowmean(`i'2001 `i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008)
egen `i'2002_2009=rowmean(`i'2002 `i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009)
egen `i'2003_2010=rowmean(`i'2003 `i'2004 `i'2005 `i'2006 `i'2007 `i'2008 `i'2009 `i'2010)


*Other years:
egen `i'2000_2002= rowmean(`i'2000 `i'2001 `i'2002)
egen `i'2003_2006= rowmean(`i'2003 `i'2004 `i'2005 `i'2006)
egen `i'2007_2010= rowmean(`i'2007 `i'2008 `i'2009 `i'2010)
egen `i'2011_2012= rowmean(`i'2011 `i'2012)
}

*Endowment addiditve production index: 
foreach i in endowments{

/*Six years window:
gen `i'1988_1993 = gold1988_1993 + nickel1988_1993 + emeralds1988_1993 + iron1988_1993
gen `i'1989_1994 = gold1989_1994 + nickel1989_1994 + emeralds1989_1994 + iron1989_1994
gen `i'1990_1995 = gold1990_1995 + nickel1990_1995 + emeralds1990_1995 + iron1990_1995
gen `i'1991_1996 = gold1991_1996 + nickel1991_1996 + emeralds1991_1996 + iron1991_1996
gen `i'1992_1997 = gold1992_1997 + nickel1992_1997 + emeralds1992_1997 + iron1992_1997
gen `i'1993_1998 = gold1993_1998 + nickel1993_1998 + emeralds1993_1998 + iron1993_1998
gen `i'1994_1999 = gold1994_1999 + nickel1994_1999 + emeralds1994_1999 + iron1994_1999
gen `i'1995_2000 = gold1995_2000 + nickel1995_2000 + emeralds1995_2000 + iron1995_2000
gen `i'1996_2001 = gold1996_2001 + nickel1996_2001 + emeralds1996_2001 + iron1996_2001*/
gen `i'1997 = gold1997 + nickel1997 + emeralds1997 + iron1997
gen `i'1997_1998 = gold1997_1998 + nickel1997_1998 + emeralds1997_1998 + iron1997_1998
gen `i'1997_1999 = gold1997_1999 + nickel1997_1999 + emeralds1997_1999 + iron1997_1999
gen `i'1997_2000 = gold1997_2000 + nickel1997_2000 + emeralds1997_2000 + iron1997_2000
gen `i'1997_2001 = gold1997_2001 + nickel1997_2001 + emeralds1997_2001 + iron1997_2001
gen `i'1997_2002 = gold1997_2002 + nickel1997_2002 + emeralds1997_2002 + iron1997_2002
gen `i'1998_2003 = gold1998_2003 + nickel1998_2003 + emeralds1998_2003 + iron1998_2003
gen `i'1999_2004 = gold1999_2004 + nickel1999_2004 + emeralds1999_2004 + iron1999_2004
gen `i'2000_2005 = gold2000_2005 + nickel2000_2005 + emeralds2000_2005 + iron2000_2005
gen `i'2001_2006 = gold2001_2006 + nickel2001_2006 + emeralds2001_2006 + iron2001_2006
gen `i'2002_2007 = gold2002_2007 + nickel2002_2007 + emeralds2002_2007 + iron2002_2007
gen `i'2003_2008 = gold2003_2008 + nickel2003_2008 + emeralds2003_2008 + iron2003_2008
gen `i'2004_2009 = gold2004_2009 + nickel2004_2009 + emeralds2004_2009 + iron2004_2009
gen `i'2005_2010 = gold2005_2010 + nickel2005_2010 + emeralds2005_2010 + iron2005_2010

/*Eight years window: 
gen `i'1988_1995 = gold1988_1995 + nickel1988_1995 + emeralds1988_1995 + iron1988_1995
gen `i'1989_1996 = gold1989_1996 + nickel1989_1996 + emeralds1989_1996 + iron1989_1996
gen `i'1990_1997 = gold1990_1997 + nickel1990_1997 + emeralds1990_1997 + iron1990_1997
gen `i'1991_1998 = gold1991_1998 + nickel1991_1998 + emeralds1991_1998 + iron1991_1998
gen `i'1992_1999 = gold1992_1999 + nickel1992_1999 + emeralds1992_1999 + iron1992_1999
gen `i'1993_2000 = gold1993_2000 + nickel1993_2000 + emeralds1993_2000 + iron1993_2000
gen `i'1994_2001 = gold1994_2001 + nickel1994_2001 + emeralds1994_2001 + iron1994_2001
gen `i'1995_2002 = gold1995_2002 + nickel1995_2002 + emeralds1995_2002 + iron1995_2002
gen `i'1996_2003 = gold1996_2003 + nickel1996_2003 + emeralds1996_2003 + iron1996_2003*/
gen `i'1997_2003 = gold1997_2003 + nickel1997_2003 + emeralds1997_2003 + iron1997_2003
gen `i'1997_2004 = gold1997_2004 + nickel1997_2004 + emeralds1997_2004 + iron1997_2004
gen `i'1998_2005 = gold1998_2005 + nickel1998_2005 + emeralds1998_2005 + iron1998_2005
gen `i'1999_2006 = gold1999_2006 + nickel1999_2006 + emeralds1999_2006 + iron1999_2006
gen `i'2000_2007 = gold2000_2007 + nickel2000_2007 + emeralds2000_2007 + iron2000_2007
gen `i'2001_2008 = gold2001_2008 + nickel2001_2008 + emeralds2001_2008 + iron2001_2008
gen `i'2002_2009 = gold2002_2009 + nickel2002_2009 + emeralds2002_2009 + iron2002_2009
gen `i'2003_2010 = gold2003_2010 + nickel2003_2010 + emeralds2003_2010 + iron2003_2010


*Other years:
gen `i'2000_2002 = gold2000_2002 + nickel2000_2002 + emeralds2000_2002 + iron2000_2002
gen `i'2003_2006 = gold2003_2006 + nickel2003_2006 + emeralds2003_2006 + iron2003_2006
gen `i'2007_2010 = gold2007_2010 + nickel2007_2010 + emeralds2007_2010 + iron2007_2010
gen `i'2011_2012 = gold2011_2012 + nickel2011_2012 + emeralds2011_2012 + iron2011_2012
}


*Coffee in 1998
gen coffee=cofint1988
replace coffee=0 if cofint1988==.

*PDET (Programa de Desarrollo con Enfoque Territorial: peace-building government program)
replace pdet=0 if pdet==.


**********************************************************


*Final database:
save "../DATA/ENDOGENOUS_TAXATION_V2.dta", replace


****************** END ***********************************



