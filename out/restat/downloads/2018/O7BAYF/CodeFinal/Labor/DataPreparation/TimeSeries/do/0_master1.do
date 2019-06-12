**********************************************************************************
***This file produces a data file with aggregate time series from CPS  microdata
**********************************************************************************


clear all
set mem 900000
set more off

**************************************************************************************
****Set the directory here and create subdirectories as described in dataprep.docx
**************************************************************************************
global dir "Z:\Projekte\HFCN\Analysen\eb_labor_demand\ReStat\test\dataprep1"




***Set output directories
global data ${dir}/data
global output ${dir}/output
global do ${dir}/do

****Define year globals		
	    global years "62 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09"
		global years6291 "62 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91"
		global years9209 "92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09"

****Define in this global the first year we have		
		global yearsf "62"

****Define in this global all but the first years we have            
		global yearsbf "64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09"

****Define in this global last year we have
         global yearsl "09"

		 
		 
		 
*************************************
*********START DATA PREPARATION
*************************************

****Create wage time series
		do "$do/1_wage_ts.do"


****Create labor supply time series
		do "$do/2_laborsupply_ts.do"

****Produce final merged time series
		do "$do/3_merge_save.do"









