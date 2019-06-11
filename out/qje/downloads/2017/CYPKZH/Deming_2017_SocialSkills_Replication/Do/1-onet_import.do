/*
	Project: The growing importance of social skills in the labor market (2017)
	Author: David Deming
	Date Created: April 2017
	
	Description: Imports 1998 O*NET data, creates composites and links to occ1990dd
		occupation codes via crosswalks.
*/


version 14
clear all
set more off


**** Define macros ****

global topdir "YOURFILEPATH/Deming_2017_SocialSkills_Replication"
local dodir "${topdir}/Do"

local rawdir "${topdir}/Data/census-acs/raw"
local cleandir "${topdir}/Data/census-acs/clean"
local collapdir "${topdir}/Data/census-acs/collapsed" 
local occdir "${topdir}/Data/census-acs/xwalk_occ"
local inddir "${topdir}/Data/census-acs/xwalk_ind"

local onetdir "${topdir}/Data/onet"
local txtdir "${topdir}/Data/onet/text_files"
local dotdir "${topdir}/Data/dot"

local nlsydir "${topdir}/Data/nlsy"
local import79dir "${topdir}/Data/nlsy/import/nlsy79"
local import97dir "${topdir}/Data/nlsy/import/nlsy97"
local name79 "socskills_nlsy79_final"			/* Name of NLSY79 extract */
local name97 "socskills_nlsy97_final"			/* Name of NLSY97 extract */
local afqtadj "${topdir}/Data/nlsy/altonjietal2012"

local figdir "${topdir}/Results/figures"
local tabdir "${topdir}/Results/tables"


************************
****Import 1998 ONET****
************************

** Ability Variables

import delimited "`txtdir'/Ability.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	A01IM00M
rename	v3	A01LV00M
rename	v4	A02IM00M
rename	v5	A02LV00M
rename	v6	A03IM00M
rename	v7	A03LV00M
rename	v8	A04IM00M
rename	v9	A04LV00M
rename	v10	A05IM00M
rename	v11	A05LV00M
rename	v12	A06IM00M
rename	v13	A06LV00M
rename	v14	A07IM00M
rename	v15	A07LV00M
rename	v16	A08IM00M
rename	v17	A08LV00M
rename	v18	A09IM00M
rename	v19	A09LV00M
rename	v20	A10IM00M
rename	v21	A10LV00M
rename	v22	A11IM00M
rename	v23	A11LV00M
rename	v24	A12IM00M
rename	v25	A12LV00M
rename	v26	A13IM00M
rename	v27	A13LV00M
rename	v28	A14IM00M
rename	v29	A14LV00M
rename	v30	A15IM00M
rename	v31	A15LV00M
rename	v32	A16IM00M
rename	v33	A16LV00M
rename	v34	A17IM00M
rename	v35	A17LV00M
rename	v36	A18IM00M
rename	v37	A18LV00M
rename	v38	A19IM00M
rename	v39	A19LV00M
rename	v40	A20IM00M
rename	v41	A20LV00M
rename	v42	A21IM00M
rename	v43	A21LV00M
rename	v44	A22IM00M
rename	v45	A22LV00M
rename	v46	A23IM00M
rename	v47	A23LV00M
rename	v48	A24IM00M
rename	v49	A24LV00M
rename	v50	A25IM00M
rename	v51	A25LV00M
rename	v52	A26IM00M
rename	v53	A26LV00M
rename	v54	A27IM00M
rename	v55	A27LV00M
rename	v56	A28IM00M
rename	v57	A28LV00M
rename	v58	A29IM00M
rename	v59	A29LV00M
rename	v60	A30IM00M
rename	v61	A30LV00M
rename	v62	A31IM00M
rename	v63	A31LV00M
rename	v64	A32IM00M
rename	v65	A32LV00M
rename	v66	A33IM00M
rename	v67	A33LV00M
rename	v68	A34IM00M
rename	v69	A34LV00M
rename	v70	A35IM00M
rename	v71	A35LV00M
rename	v72	A36IM00M
rename	v73	A36LV00M
rename	v74	A37IM00M
rename	v75	A37LV00M
rename	v76	A38IM00M
rename	v77	A38LV00M
rename	v78	A39IM00M
rename	v79	A39LV00M
rename	v80	A40IM00M
rename	v81	A40LV00M
rename	v82	A41IM00M
rename	v83	A41LV00M
rename	v84	A42IM00M
rename	v85	A42LV00M
rename	v86	A43IM00M
rename	v87	A43LV00M
rename	v88	A44IM00M
rename	v89	A44LV00M
rename	v90	A45IM00M
rename	v91	A45LV00M
rename	v92	A46IM00M
rename	v93	A46LV00M
rename	v94	A47IM00M
rename	v95	A47LV00M
rename	v96	A48IM00M
rename	v97	A48LV00M
rename	v98	A49IM00M
rename	v99	A49LV00M
rename	v100	A50IM00M
rename	v101	A50LV00M
rename	v102	A51IM00M
rename	v103	A51LV00M
rename	v104	A52IM00M
rename	v105	A52LV00M

save "`onetdir'/onet1998.dta", replace

** Interests Variables

import delimited "`txtdir'/Interest.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	I01OI00M
rename	v3	I02OI00M
rename	v4	I03OI00M
rename	v5	I04OI00M
rename	v6	I05OI00M
rename	v7	I06OI00M
rename	v8	I07IH00H
rename	v9	I08IH00H
rename	v10	I09IH00H

merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save "`onetdir'/onet1998.dta", replace

** Knowledge Variables

import delimited "`txtdir'/Knowledge.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	K01IM00M
rename	v3	K01LV00M
rename	v4	K02IM00M
rename	v5	K02LV00M
rename	v6	K03IM00M
rename	v7	K03LV00M
rename	v8	K04IM00M
rename	v9	K04LV00M
rename	v10	K05IM00M
rename	v11	K05LV00M
rename	v12	K06IM00M
rename	v13	K06LV00M
rename	v14	K07IM00M
rename	v15	K07LV00M
rename	v16	K08IM00M
rename	v17	K08LV00M
rename	v18	K09IM00M
rename	v19	K09LV00M
rename	v20	K10IM00M
rename	v21	K10LV00M
rename	v22	K11IM00M
rename	v23	K11LV00M
rename	v24	K12IM00M
rename	v25	K12LV00M
rename	v26	K13IM00M
rename	v27	K13LV00M
rename	v28	K14IM00M
rename	v29	K14LV00M
rename	v30	K15IM00M
rename	v31	K15LV00M
rename	v32	K16IM00M
rename	v33	K16LV00M
rename	v34	K17IM00M
rename	v35	K17LV00M
rename	v36	K18IM00M
rename	v37	K18LV00M
rename	v38	K19IM00M
rename	v39	K19LV00M
rename	v40	K20IM00M
rename	v41	K20LV00M
rename	v42	K21IM00M
rename	v43	K21LV00M
rename	v44	K22IM00M
rename	v45	K22LV00M
rename	v46	K23IM00M
rename	v47	K23LV00M
rename	v48	K24IM00M
rename	v49	K24LV00M
rename	v50	K25IM00M
rename	v51	K25LV00M
rename	v52	K26IM00M
rename	v53	K26LV00M
rename	v54	K27IM00M
rename	v55	K27LV00M
rename	v56	K28IM00M
rename	v57	K28LV00M
rename	v58	K29IM00M
rename	v59	K29LV00M
rename	v60	K30IM00M
rename	v61	K30LV00M
rename	v62	K31IM00M
rename	v63	K31LV00M
rename	v64	K32IM00M
rename	v65	K32LV00M
rename	v66	K33IM00M
rename	v67	K33LV00M

merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save "`onetdir'/onet1998.dta", replace

** Skills Variables

import delimited "`txtdir'/Skills.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	B01IM00M
rename	v3	B01LV00M
rename	v4	B02IM00M
rename	v5	B02LV00M
rename	v6	B03IM00M
rename	v7	B03LV00M
rename	v8	B04IM00M
rename	v9	B04LV00M
rename	v10	B05IM00M
rename	v11	B05LV00M
rename	v12	B06IM00M
rename	v13	B06LV00M
rename	v14	B07IM00M
rename	v15	B07LV00M
rename	v16	B08IM00M
rename	v17	B08LV00M
rename	v18	B09IM00M
rename	v19	B09LV00M
rename	v20	B10IM00M
rename	v21	B10LV00M
rename	v22	C01IM00M
rename	v23	C01LV00M
rename	v24	C02IM00M
rename	v25	C02LV00M
rename	v26	C03IM00M
rename	v27	C03LV00M
rename	v28	C04IM00M
rename	v29	C04LV00M
rename	v30	C05IM00M
rename	v31	C05LV00M
rename	v32	C06IM00M
rename	v33	C06LV00M
rename	v34	C07IM00M
rename	v35	C07LV00M
rename	v36	C08IM00M
rename	v37	C08LV00M
rename	v38	C09IM00M
rename	v39	C09LV00M
rename	v40	C10IM00M
rename	v41	C10LV00M
rename	v42	C11IM00M
rename	v43	C11LV00M
rename	v44	C12IM00M
rename	v45	C12LV00M
rename	v46	C13IM00M
rename	v47	C13LV00M
rename	v48	C14IM00M
rename	v49	C14LV00M
rename	v50	C15IM00M
rename	v51	C15LV00M
rename	v52	C16IM00M
rename	v53	C16LV00M
rename	v54	C17IM00M
rename	v55	C17LV00M
rename	v56	C18IM00M
rename	v57	C18LV00M
rename	v58	C19IM00M
rename	v59	C19LV00M
rename	v60	C20IM00M
rename	v61	C20LV00M
rename	v62	C21IM00M
rename	v63	C21LV00M
rename	v64	C22IM00M
rename	v65	C22LV00M
rename	v66	C23IM00M
rename	v67	C23LV00M
rename	v68	C24IM00M
rename	v69	C24LV00M
rename	v70	C25IM00M
rename	v71	C25LV00M
rename	v72	C26IM00M
rename	v73	C26LV00M
rename	v74	C27IM00M
rename	v75	C27LV00M
rename	v76	C28IM00M
rename	v77	C28LV00M
rename	v78	C29IM00M
rename	v79	C29LV00M
rename	v80	C30IM00M
rename	v81	C30LV00M
rename	v82	C31IM00M
rename	v83	C31LV00M
rename	v84	C32IM00M
rename	v85	C32LV00M
rename	v86	C33IM00M
rename	v87	C33LV00M
rename	v88	C34IM00M
rename	v89	C34LV00M
rename	v90	C35IM00M
rename	v91	C35LV00M
rename	v92	C36IM00M
rename	v93	C36LV00M

merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save "`onetdir'/onet1998.dta", replace

** Work Activity Variables

import delimited "`txtdir'/WorkActivity.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	G01FG00M
rename	v3	G01IM00M
rename	v4	G01LV00M
rename	v5	G02FG00M
rename	v6	G02IM00M
rename	v7	G02LV00M
rename	v8	G03FG00M
rename	v9	G03IM00M
rename	v10	G03LV00M
rename	v11	G04FG00M
rename	v12	G04IM00M
rename	v13	G04LV00M
rename	v14	G05FG00M
rename	v15	G05IM00M
rename	v16	G05LV00M
rename	v17	G06FG00M
rename	v18	G06IM00M
rename	v19	G06LV00M
rename	v20	G07FG00M
rename	v21	G07IM00M
rename	v22	G07LV00M
rename	v23	G08FG00M
rename	v24	G08IM00M
rename	v25	G08LV00M
rename	v26	G09FG00M
rename	v27	G09IM00M
rename	v28	G09LV00M
rename	v29	G10FG00M
rename	v30	G10IM00M
rename	v31	G10LV00M
rename	v32	G11FG00M
rename	v33	G11IM00M
rename	v34	G11LV00M
rename	v35	G12FG00M
rename	v36	G12IM00M
rename	v37	G12LV00M
rename	v38	G13FG00M
rename	v39	G13IM00M
rename	v40	G13LV00M
rename	v41	G14FG00M
rename	v42	G14IM00M
rename	v43	G14LV00M
rename	v44	G15FG00M
rename	v45	G15IM00M
rename	v46	G15LV00M
rename	v47	G16FG00M
rename	v48	G16IM00M
rename	v49	G16LV00M
rename	v50	G17FG00M
rename	v51	G17IM00M
rename	v52	G17LV00M
rename	v53	G18FG00M
rename	v54	G18IM00M
rename	v55	G18LV00M
rename	v56	G19FG00M
rename	v57	G19IM00M
rename	v58	G19LV00M
rename	v59	G20FG00M
rename	v60	G20IM00M
rename	v61	G20LV00M
rename	v62	G21FG00M
rename	v63	G21IM00M
rename	v64	G21LV00M
rename	v65	G22FG00M
rename	v66	G22IM00M
rename	v67	G22LV00M
rename	v68	G23FG00M
rename	v69	G23IM00M
rename	v70	G23LV00M
rename	v71	G24FG00M
rename	v72	G24IM00M
rename	v73	G24LV00M
rename	v74	G25FG00M
rename	v75	G25IM00M
rename	v76	G25LV00M
rename	v77	G26FG00M
rename	v78	G26IM00M
rename	v79	G26LV00M
rename	v80	G27FG00M
rename	v81	G27IM00M
rename	v82	G27LV00M
rename	v83	G28FG00M
rename	v84	G28IM00M
rename	v85	G28LV00M
rename	v86	G29FG00M
rename	v87	G29IM00M
rename	v88	G29LV00M
rename	v89	G30FG00M
rename	v90	G30IM00M
rename	v91	G30LV00M
rename	v92	G31FG00M
rename	v93	G31IM00M
rename	v94	G31LV00M
rename	v95	G32FG00M
rename	v96	G32IM00M
rename	v97	G32LV00M
rename	v98	G33FG00M
rename	v99	G33IM00M
rename	v100	G33LV00M
rename	v101	G34FG00M
rename	v102	G34IM00M
rename	v103	G34LV00M
rename	v104	G35FG00M
rename	v105	G35IM00M
rename	v106	G35LV00M
rename	v107	G36FG00M
rename	v108	G36IM00M
rename	v109	G36LV00M
rename	v110	G37FG00M
rename	v111	G37IM00M
rename	v112	G37LV00M
rename	v113	G38FG00M
rename	v114	G38IM00M
rename	v115	G38LV00M
rename	v116	G39FG00M
rename	v117	G39IM00M
rename	v118	G39LV00M
rename	v119	G40FG00M
rename	v120	G40IM00M
rename	v121	G40LV00M
rename	v122	G41FG00M
rename	v123	G41IM00M
rename	v124	G41LV00M
rename	v125	G42FG00M
rename	v126	G42IM00M
rename	v127	G42LV00M

merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save "`onetdir'/onet1998.dta", replace

** Work Context Variables

import delimited "`txtdir'/WorkContext.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	W13OS00M
rename	v3	W14CN00M
rename	v4	W16IJ00M
rename	v5	W17IJ00M
rename	v6	W18IJ00M
rename	v7	W19IJ00M
rename	v8	W21IJ00M
rename	v9	W22IJ00M
rename	v10	W23HS00M
rename	v11	W24RE00M
rename	v12	W25CF00M
rename	v13	W26CF00M
rename	v14	W27CF00M
rename	v15	W36FN00M
rename	v16	W37FN00M
rename	v17	W38FN00M
rename	v18	W39FN00M
rename	v19	W40FN00M
rename	v20	W41FN00M
rename	v21	W42DI00M
rename	v22	W42FN00M
rename	v23	W42LI00M
rename	v24	W43DI00M
rename	v25	W43FN00M
rename	v26	W43LI00M
rename	v27	W44DI00M
rename	v28	W44FN00M
rename	v29	W44LI00M
rename	v30	W45DI00M
rename	v31	W45FN00M
rename	v32	W45LI00M
rename	v33	W46DI00M
rename	v34	W46FN00M
rename	v35	W46LI00M
rename	v36	W47DI00M
rename	v37	W47FN00M
rename	v38	W47LI00M
rename	v39	W60FN00M
rename	v40	W61FN00M
rename	v41	W62FN00M
rename	v42	W63FN00M
rename	v43	W64FN00M
rename	v44	W65FN00M
rename	v45	W66FN00M
rename	v46	W67FN00M
rename	v47	W68FN00M
rename	v48	W70FN00M
rename	v49	W72FN00M
rename	v50	W73FN00M
rename	v51	W74SR00M
rename	v52	W79FC00M
rename	v53	W80AO00M
rename	v54	W82IJ00M
rename	v55	W83IJ00M
rename	v56	W84IJ00M
rename	v57	W85IJ00M
rename	v58	W90IJ00M
rename	v59	W98FN00M
rename	v60	W99FN00M

merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save "`onetdir'/onet1998.dta", replace

** Work Value Variables

import delimited "`txtdir'/WorkValue.txt", clear delimiter(comma)

rename	v1	onet98code
rename	v2	VAGEN01M
rename	v3	VAGEN02M
rename	v4	VAGEN03M
rename	v5	VAGEN04M
rename	v6	VAGEN05M
rename	v7	VAGEN06M
rename	v8	V01EN00M
rename	v9	V02EN00M
rename	v10	V03EN00M
rename	v11	V04EN00M
rename	v12	V05EN00M
rename	v13	V06EN00M
rename	v14	V07EN00M
rename	v15	V08EN00M
rename	v16	V09EN00M
rename	v17	V10EN00M
rename	v18	V11EN00M
rename	v19	V12EN00M
rename	v20	V13EN00M
rename	v21	V14EN00M
rename	v22	V15EN00M
rename	v23	V16EN00M
rename	v24	V17EN00M
rename	v25	V18EN00M
rename	v26	V19EN00M
rename	v27	V20EN00M
rename	v28	V21EN00M

merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save "`onetdir'/onet1998.dta", replace

** Change variable numbers to lower case
renvars _all, lower
sort onet98code

** Restrict to Selected Variables

keep a12lv00m k14lv00m b05lv00m w85ij00m w80ao00m c01lv00m c02lv00m c03lv00m ///
	c04lv00m g30lv00m c06lv00m w14cn00m w21ij00m a02lv00m a08lv00m a09lv00m a13lv00m ///
	g01lv00m g02lv00m g08lv00m g09lv00m g34lv00m g35lv00m g26lv00m g27lv00m ///
	g28lv00m g29lv00m onet98code

** Transform scale of variables to 0-10	
foreach var in a12lv00m k14lv00m b05lv00m w85ij00m w80ao00m c01lv00m c02lv00m c03lv00m ///
	c04lv00m g30lv00m c06lv00m w14cn00m w21ij00m a02lv00m a08lv00m a09lv00m a13lv00m ///
	g01lv00m g02lv00m g08lv00m g09lv00m g34lv00m g35lv00m g26lv00m g27lv00m ///
	g28lv00m g29lv00m {
	sum `var', meanonly
	replace `var'=`var'-r(min)
	sum `var', meanonly
	replace `var'=`var'/r(max)
	replace `var'=`var'*10
}

** Create composites
	
* Math
egen math_onet1998=rowmean(a12lv00m k14lv00m b05lv00m)
drop a12lv00m k14lv00m b05lv00m

* Routine
egen routine_onet1998=rowmean(w80ao00m w85ij00m)
drop w80ao00m w85ij00m

* Social skills
egen socskills_onet1998=rowmean(c01lv00m c02lv00m c03lv00m c04lv00m)
drop c01lv00m c02lv00m c03lv00m c04lv00m

* Service
egen service_onet1998=rowmean(g30lv00m c06lv00m)
drop g30lv00m c06lv00m
gen customer_onet1998=w21ij00m

* Require social interaction
rename w14cn00m require_social_onet1998

* Reason
egen reason_onet1998=rowmean(a02lv00m a08lv00m a09lv00m)
drop a02lv00m a08lv00m a09lv00m

* Number facility
rename a13lv00m number_facility_onet1998

* Information use
egen info_use_onet1998=rowmean(g01lv00m g02lv00m g08lv00m g09lv00m)
drop g01lv00m g02lv00m g08lv00m g09lv00m

* Coordinate
egen coord_onet1998=rowmean(g34lv00m g35lv00m)
drop g34lv00m g35lv00m

* Interact
egen interact_onet1998=rowmean(g26lv00m g27lv00m g28lv00m g29lv00m)
drop g26lv00m g27lv00m g28lv00m g29lv00m

** Rescale composites
foreach var in require_social_onet1998 number_facility_onet1998 math_onet1998 ///
	routine_onet1998 socskills_onet1998 service_onet1998 customer_onet1998 reason_onet1998 ///
	info_use_onet1998 coord_onet1998 interact_onet1998 {
	sum `var', meanonly
	replace `var'=`var'-r(min)
	sum `var', meanonly
	replace `var'=`var'/r(max)
	replace `var'=`var'*10
}

** Save data
save "`onetdir'/onet1998.dta", replace


******************************************************
****Collapse ONET 1998 by Census Occupation 1990dd****
******************************************************

* ONET 1998 to Census 1990 Occupation crosswalk
import delimited "`txtdir'/Crosswalk.txt", clear delimiter(comma)
keep if v1=="CEN"
drop v1
rename v2 onet98code
rename v3 occ90
save "`onetdir'/onet98_occ90_xwalk.dta", replace

* Merge ONET 1998 and occ90 crosswalk
use "`onetdir'/onet1998.dta", clear
merge 1:m onet98code using "`onetdir'/onet98_occ90_xwalk.dta", keep(match) nogen

* Collapse by occ90
collapse (mean) require_social_onet1998-interact_onet1998, by(occ90)

* Merge in occ90 to occ1990dd crosswalk
rename occ90 occ
merge 1:1 occ using "`occdir'/occ1990_occ1990dd_update.dta", keep(match) nogen

* Collapse by occ1990dd
collapse (mean) require_social_onet1998-interact_onet1998, by(occ1990dd)

* Re-scale again to 0-10
foreach var of varlist require_social_onet1998-interact_onet1998 {
	sum `var', meanonly
	replace `var'=`var'-r(min)
	sum `var', meanonly
	replace `var'=`var'/r(max)
	replace `var'=`var'*10
}

* Save data
save "`onetdir'/onet98_occ1990dd.dta", replace

