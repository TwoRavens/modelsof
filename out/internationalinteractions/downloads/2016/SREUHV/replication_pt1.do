set more off


***************************
**install mlboolean package
***************************
help mlboolean
**choose st0078 from the returned search results, and then click to install



****************************************************************************************************
**replication data taken from Oneal & Russett (1999) World Politics paper, use sample from 1950-1992
****************************************************************************************************

use "Replication_dyadeffect/MCMCdyadeffect/dyadEffect/data/kantdata.dta", clear



******************
**Table 1: Model 1
******************

probit dispute1 smigoabi smldep smldmat lcaprat2 allies contigkb logdstab majpower py1 py2 py3 
**save Coef. column and [95% Conf. Interval] column
 
 
 
******************
**Table 1: Model 2
******************

mlboolean probit 2 (aandb) (dispute1) (smigoabi smldep smldmat lcaprat2 allies  py1 py2 py3) (smigoabi smldep contigkb logdstab majpower)
**save Coef. column and [95% Conf. Interval] column


******************
**Table 2: Model 1
******************

clogit dispute1 smigoabi smldep smldmat lcaprat2 allies contigkb logdstab majpower py1 py2 py3, group(dyadid)
**save Coef. column and [95% Conf. Interval] column


******************
**Table 2: Model 2
******************

probit dispute1 smigoabi smldep smldmat lcaprat2 allies contigkb logdstab majpower py1 py2 py3 if contigkb==1 | majpower==1
**save Coef. column and [95% Conf. Interval] column
