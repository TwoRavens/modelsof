

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		November 28, 2017
	**		PROJECT: 	Elite Competition and State Capacity 
	**					Development: Theory and Evidence from 
	**					Post-Revolutionary Mexico
	** 	
	**		DETAILS: 	This code reproduces all the tables and 
	**					figures from the paper and supplemental 
	**					material.
	**					
	**
	** 
	**
	**				
	**		Versi—n: 	Stata MP 12.1
	**
	******************************************************************
	
	



		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Preliminaries
*-------------------------------------------------------------------------------



* Clear
*------

clear all



* Set more off
*-------------

set more off



* Directories
*------------

global dir `"~/APSR_StateCapacityReplication/"'

cd $dir


global tables `"tables/"'

/*
* PC
*---
global tables `"tables\"'
*/

global figures `"figures/"'

/*
* PC
*---
global figures `"figures\"'
*/

global data `"data/"'

/*
* PC
*---
global tables `"data\"'
*/

global code `"code/"'

/*
* PC
*---
global tables `"code\"'
*/



* R directory
*------------

global Rterm_path `"/usr/bin/r"'



* Install Stata SSC packages
*---------------------------

/*
ssc install estout
ssc install makematrix
ssc install spmap
ssc install rsource
ssc install tmpdir
ssc install reg2hdfe
ssc install ebalance
*/




		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Tables
*-------------------------------------------------------------------------------


* Table 1
*--------
local codedir $code
do "`codedir'4_Table1.do"

* Table 2
*--------
do "`codedir'5_Table2.do"


* Table 3
*--------
do "`codedir'7_Table3.do"


* Table 4
*--------
do "`codedir'8_Table4.do"


	


		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Figures
*-------------------------------------------------------------------------------



* Figure 1
*---------
do "`codedir'1_Figure1.do"


* Figure 2
*---------
do "`codedir'2_Figure2.do"


* Figure 3
*---------
do "`codedir'3_Figure3.do"


* Figure 4
*---------
do "`codedir'6_Figure4.do"

		





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Supplemental Material
*-------------------------------------------------------------------------------



* Table A.1
*----------
do "`codedir'9_SI_TableA1.do"


* Table B.1
*----------
do "`codedir'10_SI_TableB1.do"


* Table B.2
*----------
do "`codedir'11_SI_TableB2.do"


* Figure B.1
*------------
do "`codedir'12_SI_FigureB1.do"


* Figure B.2
*-----------
do "`codedir'13_SI_FigureB2.do"


* Table B.3
*----------
do "`codedir'14_SI_TableB3.do"


* Table B.4
*----------
do "`codedir'15_SI_TableB4.do"

	
* Figure B.3
*-----------
do "`codedir'16_SI_FigureB3.do"


* Figure B.4
*-----------
do "`codedir'17_SI_FigureB4.do"


* Figure B.5
*-----------
do "`codedir'18_SI_FigureB5.do"


* Table C.1
*----------
do "`codedir'19_SI_TableC1.do"


* Table C.2
*----------
do "`codedir'20_SI_TableC2.do"


* Table C.3
*----------
do "`codedir'21_SI_TableC3.do"


* Table C.4
*----------
do "`codedir'22_SI_TableC4.do"


* Table C.5
*----------
do "`codedir'23_SI_TableC5.do"


* Figure C.1
*-----------
do "`codedir'24_SI_FigureC1.do"


* Table C.6
*----------
do "`codedir'25_SI_TableC6.do"


* Table C.7
*----------
do "`codedir'26_SI_TableC7.do"


* Table C.8
*----------
do "`codedir'27_SI_TableC8.do"


* Table C.9
*----------
do "`codedir'28_SI_TableC9.do"


* Table C.10
*-----------
do "`codedir'29_SI_TableC10.do"


* Table C.11
*-----------
do "`codedir'30_SI_TableC11.do"


* Table C.12
*-----------
do "`codedir'31_SI_TableC12.do"


* Table C.13
*-----------
do "`codedir'32_SI_TableC13.do"


* Table C.14
*-----------
do "`codedir'33_SI_TableC14.do"


* Table C.15
*-----------
do "`codedir'34_SI_TableC15.do"







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



