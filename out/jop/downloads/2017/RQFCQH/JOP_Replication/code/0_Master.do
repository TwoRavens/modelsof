

	******************************************************************
	**
	**
	**		NAME:		Francisco Garfias
	**		DATE: 		December 10, 2017
	**		PROJECT: 	Elite Coalitions, Limited Government, and 
	**					Fiscal Capacity Development: Evidence from 
	**					Bourbon Mexico
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
set mat 11000



* Directories
*------------

global dir `"~/JOP_Replication/"'

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
ssc install texsave
ssc install makematrix
ssc install rsource
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
do "`codedir'6_Table2.do"


	


		

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
do "`codedir'5_Figure4.do"



		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* Supplemental Material
*-------------------------------------------------------------------------------



* Figure A.1.1
*-------------
do "`codedir'7_SI_FigureA1_1.do"


* Figure A.2.1
*-------------
do "`codedir'8_SI_FigureA2_1.do"


* Figure A.2.2
*-------------
do "`codedir'9_SI_FigureA2_2.do"


* Figure A.7_1
*-------------
do "`codedir'10_SI_TableA7_1.do"


* Figure A.8_1
*-------------
do "`codedir'11_SI_FigureA8_1.do"


* Table B.1.1
*------------
do "`codedir'12_SI_TableB1_1.do"


* Table B.1.2
*------------
do "`codedir'13_SI_TableB1_2.do"


* Table B.2.1
*------------
do "`codedir'14_SI_TableB2_1.do"


* Table B.2.2
*------------
do "`codedir'15_SI_TableB2_2.do"


* Table B.3.1
*------------
do "`codedir'16_SI_TableB3_1.do"


* Figure B.3.1
*-------------
do "`codedir'17_SI_FigureB3_1.do"


* Table B.4.1
*------------
do "`codedir'18_SI_TableB4_1.do"


* Table B.5.1
*------------
do "`codedir'19_SI_TableB5_1.do"


* Figure B.6.1
*-------------
do "`codedir'20_SI_FigureB6_1.do"


* Figure B.6.2
*-------------
do "`codedir'21_SI_FigureB6_2.do"


* Table B.7.1
*------------
do "`codedir'22_SI_TableB7_1.do"







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** end of do file **		



