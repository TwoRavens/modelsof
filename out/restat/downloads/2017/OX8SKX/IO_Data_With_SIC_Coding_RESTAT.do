/***************************************
This do file uses Input Output (IO) tables that can be downloaded from the website of the Office for National Statistics (ONS).
This data are used to construct IO shares and flows across industries. In order to map IO sectors (that are more aggregated) to SIC 1992 industrial sectors, a mapping had to be created by the authors.
This was done manually by inspecting the SIC sectors/IO industry classifications. However, IO are constantly updated and sectors sometimes reclassified by the ONS.
Users interested in replicating need to start by constructing a mapping that suits their version of the IO Tables.
This file also uses an apportioning procedure based on BSD data in order to distribute more aggregated IO industries to SIC sectors on the basis on relative employment shares.
See the related Apportion_Factors_IOTables_RESTAT do file.
*****************************************/

clear all
set mem 800m
set matsize 10000
set more off

global home "Y:\53523_Sorting"
global working "$home\Working"
global output "$working\Data\Coaggl"
global IOdata "$output\IOforSDS"

*Mapping constructed in xl
insheet using "$IOdata\io_sec_sic_edited.csv", clear
rename v1 iocode	
rename v2 comb_iocode	
rename v3 industry
rename v4 nace_sic
rename v5 sic	
rename v6 note	
rename v7 use_note
sort iocode
save "$IOdata\io_sec_sic.dta", replace

*Now open the SIC sectoral coding, reclassify accordingly and create long matrix
use "$IOdata\io_sec_sic.dta", clear
drop if iocode==123

gen icode=sic
gen jcode=sic

gen icode_edit=iocode
codebook icode_edit
recode icode_edit 	///
10 14 15 16 17=10 	///
18 19=18 			///
25 26=25			///
36 37 38 39 40=36	///
45 46=45			///
52 53=52			///
109 110 111=109
codebook icode_edit

gen jcode_edit=icode_edit
codebook jcode_edit

duplicates tag  icode icode_edit, gen(t)
tab t
sort icode
by icode: gen d= icode_edit- icode_edit[_n-1]
sum d

sort icode
by icode: gen n=_n
keep if n==1

drop  iocode industry nace_sic note use_note sic t d n

reshape wide jcode_edit , i(icode) j(jcode)
reshape long jcode_edit, i(icode) j(jcode)
count

sort jcode
by jcode: egen m=max(jcode_edit) 
replace jcode_edit=m if jcode_edit==.
sort icode jcode
drop m 
order icode jcode icode_edit jcode_edit
egen ij_code=concat(icode_edit jcode_edit), punct("_")
sort ij_code

save "$IOdata\io_sic_long_ext.dta", replace

******************************************
******************************************
******************************************

set more off

forvalues k=1995(1)1999 {

*Can extend this loop in order to consider more years of IO tables. For some robustness checks to the main analysis, we considered years up to 2004

insheet using "$IOdata\io_table_`k'_extended_new.csv", clear
sort iocode
tab iocode
drop if iocode==.

*HOUSEHOLDS WITH EMPLOYEES SHOULD BE DROPPED. DO NOT BUY NOR SELL TO ANYONE 
drop if iocode==123
drop v123

forvalues i = 1(1)122 {
destring v`i', replace ignore("-" " ")
replace v`i'=0 if v`i'==.
}

destring tot_int_dem, replace ignore("-" "")

gen iocode_edit=iocode
codebook iocode_edit
recode iocode_edit 	///
10 14 15 16 17=10 	///
18 19=18 			///
25 26=25			///
36 37 38 39 40=36	///
45 46=45			///
52 53=52			///
109 110 111=109
codebook iocode_edit

/*These below are the codes that need to be modified in order to match between 
IO sectors and our SIC mapping

10	10	Vegetable and animal oils and fats	15.4	154	add with 158
14	14	Bread, rusks and biscuits; manufacture of pastry goods and cakes	15.81 + 15.82	158	together 158
15	15	Sugar	15.83	158	together 158
16	16	Cocoa; chocolate and sugar confectionery	15.84	158	together 158
17	17	Other food products	15.85 to 15.89	158	together 158
				
18	18	Alcoholic beverages	15.91 to 15.97	159	together 159
19	19	Production of mineral waters and soft drinks	15.98	159	together 159
					
25	24	Carpets and rugs	17.51	175	together 175
26	24	Other textiles	17.52 to 17.54	175	together 175
					
36	36	Industrial gases, dyes and pigments	24.11 + 24.12	241	together 241
37	37	Other inorganic basic chemicals	24.13	241	together 241
38	37	Other organic basic chemicals	24.14	241	together 241
39	39	Fertilisers and nitrogen compounds	24.15	241	together 241
40	39	Plastics and synthetic rubber in primary forms	24.16 + 24.17	241	together 241
					
45	45	Other chemical products	24.6	246	
46	45	Man-made fibres	24.7	247	with 246
					
52	51	Cement, lime and plaster	26.5	265	add with 266 267 268
53	53	Articles of concrete, plaster and cement; cutting, shaping and finishing of stone; manufacture of other non-metallic products	26.6 to 26.8	266	
53	53	Articles of concrete, plaster and cement; cutting, shaping and finishing of stone; manufacture of other non-metallic products	26.6 to 26.8	267	
53	53	Articles of concrete, plaster and cement; cutting, shaping and finishing of stone; manufacture of other non-metallic products	26.6 to 26.8	268	split
					
109	109	Legal activities	74.11	741	together 741
110	110	Accounting, book-keeping and auditing activities; tax consultancy	74.12	741	together 741
111	111	Market research and public opinion polling; business and management consultancy activities; management activities	74.13 to 74.15	741	together 741

*/

*Aggregate the rows
sort iocode_edit 
local z "1 2 3 4 5 6 7 8 9 10 11 12 13 10 18 20 21 22 23 24 25 27 28 29 30 31 32 33 34 35 36 41 42 43 44 45 47 48 49 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 112 113 114 115 116 117 118 119 120 121 122" 
foreach i of local z {
by iocode_edit: egen x`i'=sum(v`i') if iocode_edit!=.
replace v`i'=x`i' if iocode_edit!=.
drop x`i'
}

by iocode_edit: gen n=_n
keep if n==1
drop if iocode_edit==.
count

*Next need to aggregate the columns
egen sum_row=rowtotal(v10 v14 v15 v16 v17)
sum v10 v14 v15 v16 v17 sum_row
drop v10 v14 v15 v16 v17
rename sum_row v10

egen sum_row=rowtotal(v18 v19)
sum v18 v19 sum_row
drop v18 v19
rename sum_row v18

egen sum_row=rowtotal(v25 v26)
sum v25 v26 sum_row
drop v25 v26
rename sum_row v25

egen sum_row=rowtotal(v36 v37 v38 v39 v40)
sum v36 v37 v38 v39 v40 sum_row
drop v36 v37 v38 v39 v40
rename sum_row v36

egen sum_row=rowtotal(v45 v46)
sum v45 v46 sum_row
drop v45 v46
rename sum_row v45

egen sum_row=rowtotal(v52 v53)
sum v52 v53 sum_row
drop v52 v53
rename sum_row v52

egen sum_row=rowtotal(v109 v110 v111)
sum v109 v110 v111 sum_row
drop v109 v110 v111
rename sum_row v109

*Reshape data to have 108*108 points
reshape long v, i(iocode_edit) j(jcode) 
rename v use

gen icode=iocode_edit
order  iocode_edit icode jcode description use 
drop  n iocode

*Checks:
sort icode
by icode: gen d= tot_int_dem- tot_int_dem[_n-1]
sum d, det
drop d

*Input
sort jcode
by jcode: egen tot=sum(use)

sort jcode icode
gen input_ji=.
sort icode jcode
local z "1 2 3 4 5 6 7 8 9 10 11 12 13 10 18 20 21 22 23 24 25 27 28 29 30 31 32 33 34 35 36 41 42 43 44 45 47 48 49 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 112 113 114 115 116 117 118 119 120 121 122" 
local y "1 2 3 4 5 6 7 8 9 10 11 12 13 10 18 20 21 22 23 24 25 27 28 29 30 31 32 33 34 35 36 41 42 43 44 45 47 48 49 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 112 113 114 115 116 117 118 119 120 121 122" 
foreach i of local z {
	foreach j of local y {	
	replace input_ji=use/tot if icode==`i' & jcode==`j'
	}
}

/*
comb_iocode	use_note
1	Natural resources input
2	Natural resources input
3	Natural resources input
4	Natural resources input
5	Natural resources input
6	Natural resources input
85	Energy input (approx.)
86	Energy input (approx.)
87	Water input
93	Transport Input
94	Transport Input
95	Transport Input
96	Transport Input
97	Transport Input
*/
		  
sort jcode				  
by jcode: egen s=sum(use) if icode==85 | icode==86
by jcode: egen m=max(s) 
gen energy_j=m/tot
drop s m

by jcode: egen s=sum(use) if icode==87
by jcode: egen m=max(s) 
gen water_j=m/tot
drop s m

by jcode: egen s=sum(use) if icode==1 | icode==2 | icode==3 | icode==4 | icode==5 | icode==6 
by jcode: egen m=max(s) 
gen natural_j=m/tot
drop s m

by jcode: egen s=sum(use) if icode==93 | icode==94 | icode==95 | icode==96
by jcode: egen m=max(s) 
gen transp_j=m/tot
drop s m

sort jcode				  
by jcode: egen s=sum(use) if (icode>=107&icode<=115) | (icode>=118&icode<=123)
by jcode: egen m=max(s) 
gen serv_j=m/tot
drop s m

drop tot
sort icode jcode

*Output
sort icode
by icode: egen tot=sum(use)

gen output_ij=.
sort icode jcode
local z "1 2 3 4 5 6 7 8 9 10 11 12 13 10 18 20 21 22 23 24 25 27 28 29 30 31 32 33 34 35 36 41 42 43 44 45 47 48 49 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 112 113 114 115 116 117 118 119 120 121 122" 
local y "1 2 3 4 5 6 7 8 9 10 11 12 13 10 18 20 21 22 23 24 25 27 28 29 30 31 32 33 34 35 36 41 42 43 44 45 47 48 49 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 112 113 114 115 116 117 118 119 120 121 122" 
foreach i of local z {
	foreach j of local y {	
	replace output_ij=use/tot if icode==`i' & jcode==`j'
	}
}

sort icode jcode
drop tot 

sum input* output*
sum input* output*, det

*NOTES: WHOLESALE AND RETAIL OF PRIVATE DWELLINGS PURCHASE INPUTS BUT DO NOT SELL THEIR OUTPUTS
*THEY SELL DIRECTLY TO CONSUMERS, NOT IN IO INTERMEDIATE TABLES; RECODED AS ZEROS

replace output_ij=0 if output_ij==. & (icode==90| icode==91| icode==104)
sum input* output*, det

sort iocode_edit
gen year=`k'
save "$IOdata\io_input_ouput_`k'_ext.dta", replace

}
use "$IOdata\io_input_ouput_1995_ext.dta", clear
append using "$IOdata\io_input_ouput_1996_ext.dta"
append using "$IOdata\io_input_ouput_1997_ext.dta"
append using "$IOdata\io_input_ouput_1998_ext.dta"
append using "$IOdata\io_input_ouput_1999_ext.dta"

*Need to extend previous loop and append more years if want to consider more years of IO Tables. In some robustness, we extended up to 2004

sum 

collapse (mean)  use input_ji energy_j water_j natural_j transp_j serv_j output_ij, by(icode jcode)
sum 
egen ij_code=concat(icode jcode), punct("_")
sort ij_code
save "$IOdata\io_input_ouput_averaged_ext.dta", replace

****************************
use "$IOdata\io_sic_long_ext.dta", clear
sort  ij_code
merge m:1  ij_code using  "$IOdata\io_input_ouput_averaged_ext.dta"
drop _merge
drop  ij_code 
sort icode jcode

egen ij_code=concat(icode jcode), punct("_")
egen ji_code=concat(jcode icode), punct("_")
sort icode jcode
sum
save "$IOdata\io_input_ouput_averaged_sicmapping_ext.dta", replace

sort ji_code
keep ji_code  use input_ji energy_j water_j natural_j transp_j serv_j output_ij 
rename use use_j
rename input_ji input_ij 
rename energy_j energy_i 
rename water_j water_i 
rename natural_j natural_i
rename transp_j transp_i
rename serv_j serv_i
rename output_ij output_ji

sort ji_code
save "$IOdata\io_input_ouput_jicode_ext.dta", replace

**********************************
*NOTE: GIVEN THE WAY THE IO TABLES ARE CONSTRUCTED THE DATA HAS SAME INDUSTRY INPUTS AND OUTPUTS
*IF WE MERGE USING IJ_CODE WE GET OUTPUT OF I TO J, BUT INPUT OF J FROM I
*FOR EXAMPLE IJ_CODE 1_8 GIVES OUTPUT OF AGRI (1) SOLD TO MEAT PROCESSING (8) WHICH IS 0.19 APPROX
*AT THE SAME TIME THIS GIVES THE INPUT THAT MEAT PROCESSING (8) IS BUYING FROM AGRICULTURE (1) AT 0.27 APPROX
*FINALLY THE ENERGY, WATER, TRANSPORT AND NATUAL USE ARE FOR SECTOR J
*SO WHEN WE MERGE TO OUR MAIN DATA BY IJ_CODE WE GET OUTPUT FOR I AND ALL THE REST FOR J; WHEN WE MERGE BY JI_CODE WE GET OUTPUT FOR J AND ALL THE REST FOR I
**********************************

use "$IOdata\BSD_ij_pairs.dta", replace
*This is an extract from the coagglomeration data produced by the Coagglomeration_Metrics_TopTTWA do files that keeps sector i and j indicators in one year 
*(e.g. 2008 - it does not matter which year because in any case they are constant across years)

rename sec ij_code
sort ij_code
merge 1:1 ij_code using "$IOdata\io_input_ouput_averaged_sicmapping_ext.dta"
keep if _merge==3
drop _merge

drop ji_code
rename ij_code ji_code

sort ji_code
merge 1:1 ji_code using "$IOdata\io_input_ouput_jicode_ext.dta"
keep if _merge==3
drop _merge

rename ji_code sec
sort sec
gen aggreg_IO=0
replace aggreg_IO=1 if icode_edit==jcode_edit

drop icode jcode icode_edit jcode_edit
order sec sic_i sic_j use use_j output_ij output_ji input_ij input_ji energy_i water_i natural_i transp_i serv_i energy_j water_j natural_j transp_j serv_j aggreg_IO

/*These sectors here below are not in the BSD and are dropped from IO when merging
- 160 We drop this sector from BSD, so can drop from IO final data too
- 247 This sector in BSD is aggregated with 246; however, they have same IO code (45) so can just drop it
- 265 This sector in BSD is aggregated with 266, 267 and 268; however IO gives same code (52) so we can drop this
- 372 This sector in BSD is aggregated with 371; however in IO they have the same code (84) so we can drop this
*/

egen out_coeff=rowmax(output_ij output_ji) 
egen in_coeff=rowmax(input_ij input_ji)
egen io_coeff=rowmax(out_coeff in_coeff)

gen enrg_dis=0.5*abs(energy_i-energy_j)
gen enrg_sim=1/(enrg_dis)

gen wat_dis=0.5*abs(water_i-water_j)
gen wat_sim=1/(wat_dis)

gen trns_dis=0.5*abs(transp_i-transp_j)
gen trns_sim=1/(trns_dis)

gen natur_dis=0.5*abs(natural_i-natural_j)
gen natur_sim=1/(0.5*natur_dis)

gen serv_dis=0.5*abs(serv_i-serv_j)
gen serv_sim=1/(0.5*serv_dis)

sort sec

sort sic_i
merge m:1 sic_i using  "$output\apport_factors.dta"
drop if _merge!=3
drop _merge iocode sic3d 
rename tot_emp tot_emp_i
rename tot tot_i
rename apport apport_i

sort sic_j
merge m:1 sic_j using  "$output\apport_factors.dta"
drop if _merge!=3
drop _merge iocode sic3d 
rename tot_emp tot_emp_j
rename tot tot_j
rename apport apport_j

local z "output_ij output_ji input_ij input_ji "
foreach i of local z {
gen `i'_app=`i'*apport_i*apport_j
}

egen out_coeff_app=rowmax(output_ij_app output_ji_app) 
egen in_coeff_app=rowmax(input_ij_app input_ji_app)
egen io_coeff_app=rowmax(out_coeff_app in_coeff_app)

sum out_coeff_app out_coeff
sum in_coeff_app in_coeff
sum  io_coeff_app io_coeff 

save "$IOdata\io_info_tomerge_ext.dta", replace

