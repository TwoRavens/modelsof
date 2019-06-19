/*******************************************

The final output of this do file is the final dataset: economic_activity_data_2000_2005.dta
 
Before running the do file, make sure you replace "directory_name" with the actual name of your directory:

Edit --> Find --> Replace

Find what: directory_name

Replace with: the actual name of your directory  

*******************************************/

clear all

cd "directory_name\Data_Replication_Files_RESTAT\datasets"

use 1993_2006_econ_activity.dta, clear
 
*Data come from "Estimador Mensual de Actividad Económica a precios de mercado de 1993 (1)"
*http://www.indec.gov.ar/nuevaweb/cuadros/17/Estim-mensual-activ-econ_SH.xls
*Period: Jan 1993 - Dec 2006

gen lindexsad=log(index_sad) //log of "Indice Serie Desestacionalizada 1993 = 100"

***Cyclical and Smooth Components, HP filter***

hprescott lindexsad, stub(HP_129600) smooth(129600)

rename  HP_129600_lindexsad_1 C_C
rename HP_129600_lindexsad_sm_1 T_C

label variable lindexsad "Log Economic Activity Index"
label variable C_C "HP-Cyclical Component"
label variable T_C "HP-Trend Component"

***Cyclcical component for each trimester of (prenatal) exposure

gen CC_T3r=(L.C_C+L2.C_C+L3.C_C)/3
gen CC_T2r=(L4.C_C+L5.C_C+L6.C_C)/3
gen CC_T1r=(L7.C_C+L8.C_C+L9.C_C)/3

gen CC_duringr=(CC_T3r+CC_T2r+CC_T1r)/3

gen CC_3mafter=(F.C_C+F2.C_C+F3.C_C)/3
gen CC_3_6mafter=(F4.C_C+F5.C_C+F6.C_C)/3
gen CC_6_9mafter=(F7.C_C+F8.C_C+F9.C_C)/3

gen CC_after=(CC_3mafter+CC_3_6mafter+CC_6_9mafter)/3

label variable CC_T3r "Average HP-Cyclical component 1-3 months before birth"
label variable CC_T2r "Average HP-Cyclical component 4-6 months before birth"
label variable CC_T1r "Average HP-Cyclical component 7-9 months before birth"
label variable CC_duringr "Average HP-Cyclical component 1-9 months before birth"
label variable CC_after "Average HP-Cyclical component 1-9 months after birth"

drop CC_3mafter CC_3_6mafter CC_6_9mafter T_C lindexsad C_C 

keep if year>=2000 & year<=2005

gen time=_n

label variable time "1 (Jan 2000), ..., 72 (Dec 2005)"

drop t2 year index_sad 

save economic_activity_data_2000_2005.dta, replace
****************************************************************






