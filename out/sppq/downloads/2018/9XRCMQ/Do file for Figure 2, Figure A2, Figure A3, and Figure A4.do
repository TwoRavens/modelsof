* Do file for creating the data tables to import into EXCEL for Figures 2, A2, and A3
* load data, using the user's personal file pathway
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
sort year state
drop in 52 / 510
* create data table for Figure 2
drop if figure2state==0
export excel cer96 cer98 cer00 cer02 cer04 cer06 cer08 cer10 cer12 cer14 using "Fig2data.xlsx", firstrow(variables)
* This created a new EXCEL file called "Fig2data.xlsx"
* Open the EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph
* You will then need to go under the "Design" tab and click "Switch row / column"
* Customize
*
* create data table for Figure A2
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
drop in 52 / 510
drop if figureA2state==0
export excel cer96 cer98 cer00 cer02 cer04 cer06 cer08 cer10 cer12 cer14 using "FigA2data.xlsx", firstrow(variables)
* This created a new EXCEL file called "FigA2data.xlsx"
* Open the EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph
* You will then need to go under the "Design" tab and click "Switch row / column"
* Customize
*
* create data table for Figure A3
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
drop in 52 / 510
drop if figureA3state==0
export excel cer96 cer98 cer00 cer02 cer04 cer06 cer08 cer10 cer12 cer14 using "FigA3data.xlsx", firstrow(variables)
* This created a new EXCEL file called "FigA3data.xlsx"
* Open the new EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph
* You will then need to go under the "Design" tab and click "Switch row / column"
* Customize
*
* create data table for Figure A4
use "Holyoke_Brown_Replication Data File_SPPQ.dta", clear
drop in 52 / 510
drop if figure2state==0
export excel stateabrev cer96 cer98 cer00 cer02 cer04 cer06 cer08 cer10 cer12 cer14 using "FigA4data.xlsx", firstrow(variables)
* This created a new EXCEL file called "FigA4data.xlsx"
* Open the EXCEL file
* Use the "Insert" tab in EXCEL to create a line graph
* You will then need to go under the "Design" tab and click "Switch row / column"
* Customize
* A "clear" command now needed to make sure data file is not accidentally saved with altered data set
clear
