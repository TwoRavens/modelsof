set more off
clear all
set mem 2000m, perm
capture log close
/*
****************************************************
This do file runs all do files which replicate 
the results in Lochner and Moretti (2014) REStat.

NOTE: 	The ado files should be placed under C:\ado
		before running this launcher.

Created by Eda Bozkurt on September 28th, 2014.
****************************************************
*/
global path "C:\RA\LM_REStat_data_code"


*****************
* Blacks Crime: *
*****************
use "$path\Crime Blacks\BLACKS", clear
locmtest4_BlackMenCrime prison educ "ca9 ca10 ca11" "CrimeBlacks"


*****************
* Whites Crime: *
*****************
use "$path\Crime Whites\WHITES", clear
locmtest4_WhiteMenCrime prison educ "ca9 ca10 ca11" "CrimeWhites"


************
* Earnings *
************
use "$path\Earnings\DataReadyForTest", clear
locmtest4_Earnings learn educ "ca9 ca10 ca11" "Earnings"


********************
* Low Birth Weight *
********************
use "$path\Low Birth Weight\LowBirthWeight", clear
locmtest4_LowBirthWeight low1 educ "college collegeB" "LowBirthWeight"


*****************
* Preterm Birth *
*****************
use "$path\Preterm Birth\PretermBirth", clear
locmtest4_PretermBirth preterm1 educ "college collegeB" "PretermBirth"


