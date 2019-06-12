**********************************************************************************
***This file produces a data file with aggregates from CPS and ACS microdata
**********************************************************************************
***It is based on IPUMS
**********************************************************************************
***IPUMS data, CPS decenial waves: 1960,1970,1980,1990,2000, and ACS 2006 
**********************************************************************************
***where ipums1-5 refer to the decenial CPS waves and ipums6 to the ACS 2006 wave
**********************************************************************************
clear all
set mem 900000
set more off


****************************************************************************************
****Set the directory here and create subdirectories as described in dataprep.docx
****************************************************************************************
global dir "Z:\Projekte\HFCN\Analysen\eb_labor_demand\ReStat\test\dataprep2"


***Set directories
global data ${dir}/data
global output ${dir}/output
global do ${dir}/do


****Define in this global all years we have	
		global years "1960 1970 1980 1990 2000 2006"


****Define in this global the first year we have		
		global yearsf "1960"

****Define in this global all but the first years we have            
		global yearsbf "1970 1980 1990 2000 2006"

****Define in this global last year we have
         global yearsl "2006"

		 
		 
*********************************
*********START DATA PREPARATION
*********************************

****Micro, Create variables, order
		do "$do/1_micro_create.do"

****Merge to panel
		do "$do/2_merge_to_panel.do"














