clear 
set memory 200m 
set more off 
cd D:\Demography\conflict\replication


/***********male*********************************************/

use li_wen_jpr05_male.dta, clear

*dups cow year 
sort cow year 
iis cow 
tis year 
set matsize 800 
tsset cow year, yearly 

heckman radj countd histag giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 


heckman radj countd  giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 
 


heckman radj type2d type34d  giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical , select(fcount count)  cluster(cow) robust 
 


heckman radj type2d type34d hist2 hist34 giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical , select(fcount count)  cluster(cow) robust 
 
 
heckman radj minord ward giniwho  urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 
 


heckman radj minord ward histm histw giniwho  urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 
 

 
  

/*****************************************************************female************************************************/
cd D:\Demography\conflict\replication

use  li_wen_jpr05_female.dta, clear
*dups cow year 
sort cow year 
iis cow 
tis year 
set matsize 800 
tsset cow year, yearly 



heckman radj countd histag giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 


heckman radj countd  giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 


heckman radj type2d type34d  giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical , select(fcount count)  cluster(cow) robust 


heckman radj type2d type34d hist2 hist34 giniwho urban   urbang gdppcgrowth dem depend oecd year   tropical , select(fcount count)  cluster(cow) robust 



heckman radj minord ward  giniwho  urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 


heckman radj minord ward histm histw giniwho  urban   urbang gdppcgrowth dem depend oecd year   tropical, select(fcount count) cluster(cow) robust 



