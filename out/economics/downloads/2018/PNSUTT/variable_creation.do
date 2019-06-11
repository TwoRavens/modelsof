/*

Article: "How do taxable income responses to marginal tax rates differ by sex, marital status and age? Evidence from Spanish dual income tax"

Authors: Carlos Diaz-Caro and Jorge Onrubia 

Economics: The Open-Access, Open-Assessment E-Journal

*/

/* NOTES: 

(1) In the original database, all monetary variables are stored in cents of euro 

(2) The names of variables without suffix 06 or 07 always correspond to the year 2006 

(3) The different blocks of this do-file have to be executed after the file merging corresponding to IRPF files "2006declarantes.dta" and "2007declarantes.dta".

(4) All variables including in files "2006declarantes.dta" and "2007declarantes.dta" have been renamed using, respectively Stata commands, renvars, suffix(_06) anad

	renvars, suffix(_07), to avoid duplicities after the merger. In the case of the variables from the "2006conyuges.dta", it has been used the suffix(_06_CY).
*/


********************************************************************************************************  
							***** CREATING QUANTITATIVE VARIABLES *****
******************************************************************************************************** 


***** GROSS INCOME *****

/* YEAR 2006 */

gen rentabruta_06 = c1_06 +c5_06 +c6_06 +c28_06 +c79_06 +c80_06 +c140_06 +c170_06 +c199_06 +c220_06 +c221_06 +c222_06 +c245_06 +c255_06 +c265_06 +c275_06
gen rentabruta_06 = 0 if rentabruta_2006<0

gen Logrentabruta_06 = ln(rentabruta_06) 

/* YEAR 2007 */

gen rentabruta_07 = c1_07 +c5_07 +c6_07 +c29_07 +c69_07 +c80_07 +c140_07 +c170_07 +c195_07 +c220_07 +c222_07 +c223_07 +c245_07 +c255_07 +c265_07 +c275_07
gen rentabruta_07 = 0 if rentabruta_07<0

gen Logrentabruta_07 = ln(rentabruta_07)

gen var_Logrentabruta = Logrentabruta_07 - Logrentabruta_06

mean rentabruta_06 rentabruta_07 Logrentabruta_06 Logrentabruta_07 var_Logrentabruta  [pweight = factor]



***** ADJUSTED GROSS INCOME (BEFORE APPLYING PERSONAL AND FAMILY BASIC ALLOWANCES) *****

/* YEAR 2006 */

gen baseimponible_G_06 = c476_06						/* General component of Adjusted Gross income (before applying personal and family basic allowances) */
gen baseimponible_G_06 = 0 if baseimponible_G_06<0

gen baseimponible_E_06 = c479_06 						/* Special component of Adjusted Gross income (before applying personal and family basic allowances) */
gen baseimponible_E_06 = 0 if baseimponible_E_06<0

gen baseimponible_06 = baseimponible_G_06 + baseimponible_E_06	/* Total Adjusted Gross Income */

mean baseimponible_G_06 baseimponible_E_06 baseimponible_06 [pweight = factor]


/* YEAR 2007 */

gen baseimponible_G_07 = c455_07						/* General component of Adjusted Gross income */
gen baseimponible_G_07 = 0 if baseimponible_G_07<0

gen baseimponible_A_07 = c465_07 						/* Saving component of Adjusted Gross income */
gen baseimponible_A_07 = 0 if baseimponible_A_07<0

gen baseimponible_07 = baseimponible_G_07 + baseimponible_A_07	/* Total Adjusted Gross Income */

mean baseimponible_G_07 baseimponible_A_07 baseimponible_07 [pweight = factor]


***** CAPITAL GAINS *****

/* YEAR 2006 */

gen gananciascapital_G_06 = c470_06							/* Positive Net Capital Gains included in the general component of Adjusted Gross Income */
gen gananciascapital_G_06 = 0 if gananciascapital_G_06<0

gen gananciascapital_E_06 = c477_06							/* Positive Net Capital Gains included in the special component of Adjusted Gross Income */
gen gananciascapital_E_06 = 0 if gananciascapital_E_06<0 

gen gananciascapital_06 = gananciascapital_G_06 + gananciascapital_E_06		/* Total Positive Net Capital Gains */ 

mean gananciascapital_G_06 gananciascapital_E_06 gananciascapital_06 [pweight = factor]


/* YEAR 2007 */

gen gananciascapital_G_07 = c450_07							/* Positive Net Capital Gains included in the general component of Adjusted Gross Income */
gen gananciascapital_G_07 = 0 if gananciascapital_G_07<0

gen gananciascapital_A_07 = c457_07							/* Positive Net Capital Gains included in the saving component of Adjusted Gross Income */
gen gananciascapital_A_07 = 0 if gananciascapital_A_07<0 

gen gananciascapital_07 = gananciascapital_G_07 + gananciascapital_A_07		/* Total Positive Net Capital Gains */ 

mean gananciascapital_G_07 gananciascapital_A_07 gananciascapital_07 [pweight = factor]


****  GENERAL AND SPECIAL (2006) OR SAVING (2007) COMPONENTS OF TAXABLE INCOME, AND PERCENTAGE OF EACH ON TOTAL TAXABLE INCOME ***

/* (These percentages are applied (to respective marginal tax rates) for calculating the weighted marginal tax rate of each taxpayer) */


/* YEAR 2006 */

gen BI_06_G = c630_06  						/* General Taxable Income Year 2006 (IRPF: BASE LIQUIDABLE GENERAL SOMETIDA A GRAVAMEN (c627 - c628 + c485 )) */ 
replace BL_06_G = 0 if BL_06_G <0

gen BL_06_E = c640_06						/* Special Taxable Income Year 2006 (IRPF: BASE LIQUIDABLE ESPECIAL (c487 - c631 - c632 - c633 - c634 - c635 - c636 + c488)) */ 
replace BL_06_E = 0 if BL_06_E <0

gen BL_06 = BL_06_G + BL_06_E 				/* Total Taxable Income Year 2006*/

gen prop_BLG_06 = BL_06_G/BL_06				/* Proportion of general taxable income on total taxable income */
replace por_BLG_06 = 0 if por_BLG_06 ==. 

gen prop_BLE_06 = BL_06_E/BL_06				/* Proportion of special taxable income on total taxable income */
replace por_BLE_06 = 0 if por_BLE_06 ==. 

mean BL_06 BL_06_G BL_06_E prop_BLG_06 prop_BLE_06 [pweight = factor]


***YEAR 2007**

gen BL_07_G = c620_07						/* General Taxable Income Year 2007 (IRPF: BASE LIQUIDABLE GENERAL SOMETIDA A GRAVAMEN (c618 - c619)) */
replace BL_07_G = 0 if BL_07_G<0

gen BL_07_A = c695_07						/* Saving Taxable Income Year 2007 (IRPF: BASE LIQUIDABLE DEL AHORRO SOMETIDA A GRAVAMEN (c630 - c686)) */_
replace BL_07_A = 0 if BL_07_A<0

gen BL_07 = BL_07_G + BL_07_A 				/* Total Taxable Income Year 2007 */

gen prop_BLG_07 = BL_07_G/BL_07				/* Proportion of general taxable income on total taxable income */
replace por_BLG_07 = 0 if por_BLG_07 ==. 

gen prop_BLA_07 = BL_07_A/BL_07				/* Proportion of saving taxable income on total taxable income */
replace por_BLA_07 = 0 if por_BLA_07 ==. 

mean BL_07 BL_07_G BL_07_A prop_BLG_07 prop_BLA_07 [pweight = factor]


***** NET TAX LIABILITY (GROSS TAX LIABILITY MINUS NON-REFUNDABLE TAX CREDITS *****

/* YEAR 2006 */

gen cuotaliquida_06 = c737_06						/* Net Tax Liability (IRPF: CUOTA RESULTANTE DE LA AUTOLIQUIDACIîN (c722 - c729 - c730 - c731 - c732 - c735 - c736)) */
gen cuotaliquida_06 = 0 if cuotaliquida_06<0

mean cuotaliquida_06 [pweight = factor]


/* YEAR 2007 */

gen cuotaliquida_07 = c741_07						/* Net Tax Liability (IRPF: CUOTA RESULTANTE DE LA AUTOLIQUIDACIîN (c732 - c733 - c734 - c735 - c736 - c737 - c738 -c739) */
gen cuotaliquida_07 = 0 if cuotaliquida_07<0

mean cuotaliquida_07 [pweight = factor]



***** DETERMINING STATUTORY MARGINAL TAX RATES *****

/* YEAR 2006 */ 

/* General Tax Schedule Year 2006 */

gen Tmg_G_06 = 0.15										/* Marginal tax rate corresponding to tax bracket #1 */
replace Tmg_G_06 = 0.24 if c630_06 >  416160			/* Marginal tax rate corresponding to tax bracket #2 */
replace Tmg_G_06 = 0.28 if c630_06 > 1435752			/* Marginal tax rate corresponding to tax bracket #3 */
replace Tmg_G_06 = 0.37 if c630_06 > 2684232			/* Marginal tax rate corresponding to tax bracket #4 */
replace Tmg_G_06 = 0.45 if c630_06 > 4681800			/* Marginal tax rate corresponding to tax bracket #5 */


/* Special Tax Schedule Year 2006 */

gen Tmg_E_06 = 0.15							/* Marginal tax rate (flat) corresponding to special taxable income */


/* YEAR 2007 */

/* General Tax Schedule Year 2007 */

gen Tmg_G_07 = 0.24										/* Marginal tax rate corresponding to tax bracket #1 */
replace Tmg_G_07 = 0.28 if c620_07 > 1736000			/* Marginal tax rate corresponding to tax bracket #2 */
replace Tmg_G_07 = 0.37 if c620_07 > 3236000			/* Marginal tax rate corresponding to tax bracket #3 */
replace Tmg_G_07 = 0.43 if c620_07 > 5236000			/* Marginal tax rate corresponding to tax bracket #4 */
 
/* Saving Tax Schedule Year 2007 */

gen Tmg_A_07 = 0.18							/* Marginal tax rate (flat) corresponding to saving taxable income */


***** DETERMINING THE TAX BRACKET OF THE GENERAL TAX SCHEDULE (2006) *****

gen tramo = 0								/* Tax bracket # */
replace tramo = 1 if Tmg_G_06 == 0.15
replace tramo = 2 if Tmg_G_06 == 0.24
replace tramo = 3 if Tmg_G_06 == 0.28
replace tramo = 4 if Tmg_G_06 == 0.37
replace tramo = 5 if Tmg_G_06 == 0.45

gen tramo1 = 0
replace tramo1 = 1 if tramo == 1
gen tramo2 = 0
replace tramo2 = 2 if tramo == 2
gen tramo3 = 0
replace tramo3 = 3 if tramo == 3
gen tramo4 = 0
replace tramo4 = 4 if tramo == 4
gen tramo5 = 0
replace tramo5 = 5 if tramo == 5


***** CALCULATING WEIGHTED MARGINAL TAX RATES, NET WEIGHTED MARGINAL TAX RATES, AND DIFFERENCE OF THEIR LOGARITHMS *****

/* Year 2006 */

gen Tmg_weighted_06 = Tmg_G_06 * prop_BLG_06 + Tmg_E_06 * prop_BLE_06		/* Weighted marginal tax rate */
gen NetTmg_weighted_06 = 1 - Tmg_weighted_06								/* Net Weighted marginal tax rate = 1 minus weighted marginal tax rate */
gen LogNetTmg_weighted_06 = ln(NetTmg_weighted_06)

mean Tmg_weighted_06 NetTmg_weighted_06 LogNetTmg_weighted_06 [pweight = factor]


/* Year 2007 */

gen Tmg_weighted_07 = Tmg_G_07 * prop_BLG_07 + Tmg_A_07 * prop_BLA_07		/* Weighted marginal tax rate */
gen NetTmg_weighted_07 = 1 - Tmg_weighted_07								/* Net Weighted marginal tax rate = 1 minus weighted marginal tax rate */
gen LogNetTmg_weighted_07 = ln(NetTmg_weighted_07)

mean Tmg_weighted_07 NetTmg_weighted_07 LogNetTmg_weighted_07 [pweight = factor]	/* For all taxpayers */

mean Tmg_weighted_07 NetTmg_weighted_07 LogNetTmg_weighted_07 [pweight = factor] if c620_07 <= 1736000	/* For tax bracket #1 - General Tax Schedule 2007 */
mean Tmg_weighted_07 NetTmg_weighted_07 LogNetTmg_weighted_07 [pweight = factor] if c620_07 > 1736000	/* For tax bracket #2 - General Tax Schedule 2007 */
mean Tmg_weighted_07 NetTmg_weighted_07 LogNetTmg_weighted_07 [pweight = factor] if c620_07 > 3236000	/* For tax bracket #3 - General Tax Schedule 2007 */
mean Tmg_weighted_07 NetTmg_weighted_07 LogNetTmg_weighted_07 [pweight = factor] if c620_07 > 5236000	/* For tax bracket #4 - General Tax Schedule 2007 */


/* Difference between the logarithms of 2007 and 2006 weighted marginal tax rates */

gen var_LogNetTmg_weighted = LogNetTmg_weighted_07 - LogNetTmg_weighted_06		

mean var_LogNetTmg_weighted [pweight = factor]


***** DETERMINING 2007 STATUTORY MARGINAL TAX RATES USING 2006 TAXABLE INCOME *****

gen Tmg_G_07_BLG_06 = 0.24
replace Tmg_G_07_BLG_06 = 0.28 if c630_06 >1736000
replace Tmg_G_07_BLG_06 = 0.37 if c630_06 >3236000
replace Tmg_G_07_BLG_06 = 0.43 if c630_06 >5236000


***** CALCULATING 2007 WEIGHTED MARGINAL TAX RATES AND NET WEIGHTED MARGINAL TAX RATES, USING 2006 TAXABLE INCOME *****

gen Tmg_weighted_07_BLG_06 = Tmg_G_07_BLG_06 * prop_BLG_06 + Tmg_A_07 * prop_BLE_06		/* Weighted marginal tax rate calculated using 2006 taxable income and its two components */
gen NetTmg_weighted_07_BLG_06 = 1 - Tmg_weighted_07_BLG_06								/* Net Weighted marginal tax rate = 1 minus weighted marginal tax rate calculated using 2006 taxable income */
gen LogNetTmg_weighted_07_BLG_06 = ln(NetTmg_weighted_07_BLG_06) 

mean Tmg_weighted_07_BLG_06 NetTmg_weighted_07_BLG_06 LogNetTmg_weighted_07_BLG_06 [pweight = factor]	


***** LOGARITHMS OF NET STATUTORY MARGINAL TAX RATES *****

gen LogNetTmg_G_06 = ln(1 - Tmg_G_06)
gen LogNetTmg_G_07 = ln(1 - Tmg_G_07)
gen var_LogNetTmg_G = LogNetTmg_G_07 - LogNetTmg_G_06 		/* Difference of logarithms of 2007 and 2006 net statutory marginal tax rates */

gen LogNetTmg_G_07_BLG_06 = ln(1 - Tmg_G_07_BLG_06)
gen var_LogNetTmg_G_07_BLG_06 = LogNetTmg_G_07_BLG_06 - LogNetTmg_G_06 		/* Difference of logarithms of 2007 using 2006 taxable income and 2006 net statutory marginal tax rates */


***** CALCULATING ELASTICITIES FROM NET WEIGHTED MARGINAL TAX RATES *****

gen elasticidad = ln(1 - Tmg_weighted_07) - ln(1 - Tmg_weighted_06)

gen elasticidad_2 = ln(1 - Tmg_weighted_07_BLG_06) - ln(1 - Tmg_weighted_06)


***** CALCULATING AVERAGE TAX RATES AND THEIR LOGARITHMS *****

/* Year 2006 */

gen Tmed_06 = cuotaliquida_06 / baseimponible_06
replace Tmed_06 = 0 if Tmed_06 ==. 
gen LogTmed_06 = ln(Tmed_06)

gen NetTmed_06 = (1 - Tmed_06)
gen LogNetTmed_06 = ln(1 - Tmed_06)


/* Year 2007 */

gen Tmed_07 = cuotaliquida_07/baseimponible_07
replace Tmed_07 = 0 if Tmed_07 ==. 
gen LogTmed_07 = ln(Tmed_07)

gen NetTmed_07 = (1 - Tmed_07)
gen LogNetTmed_07 = ln(1 - Tmed_07)

gen var_LogNetTmed = LogNetTmed_07 - LogNetTmed_06
replace var_LogNetTmed = 0 if var_LogNetTmed ==. 

mean Tmed_06 Tmed_07 NetTmed_06 NetTmed_07 LogTmed_06 LogTmed_07 LogNetTmed_06 LogNetTmed_07 var_LogNetTmed  [pweight = factor]

/* Year 2006 applying 2007 marginal tax rates */

gen Tmed_06_07 = cuotaliquida_07/baseimponible_06
replace Tmed_06_07 = 0 if Tmed_06_07 ==.
gen LogTmed_06_07 = ln(Tmed_06_07)

gen NetTmed_06_07 = (1 - Tmed_06_07)
gen LogNetTmed_06_07 = ln (1 - Tmed_06_07)

gen var_LogNetTmed_06_07_06 = LogNetTmed_06_07 - LogNetTmed_06
replace var_LogNetTmed_06_07_06 = 0 if var_LogNetTmed_06_07_06 ==. 

mean Tmed_06_07 NetTmed_06_07 LogTmed_06_07 LogNetTmed_06_0 var_LogNetTmed_06_07_06  [pweight = factor]



********************************************************************************************************  
							***** CREATING QUALITATIVE VARIABLES *****
******************************************************************************************************** 


***** AGE *****


gen fechanacimiento = fechappal_06
gen edad =  20061231 -  fechanacimiento
replace edad = edad/10000

gen edad2 = edad*edad

gen grupoedad = 0
replace grupoedad = 1 if (edad>0 & edad<=30)
replace grupoedad = 2 if (edad>30 & edad<=60)
replace grupoedad = 3 if edad>60

gen grupoedad_2 =0
replace grupoedad_2 = 1 if (edad>0 & edad<=30)
replace grupoedad_2 = 2 if (edad>30 & edad<=64)
replace grupoedad_2 = 3 if edad>64	


***** GENDER *****

replace sexo = 1 if sexoppal_06==1		/* Male */
replace sexo = 0 if sexoppal_06==2		/* Female */


***** NUMBER OF DEPENDENT CHILDREN *****

/* minimosdescendientes: Dependent children allowance */

/* tipohogar: Type of family-unit of taxation		("tipohogar" is a variable incorporated from the file "hogares.dta")

1 = Unmarried individuals
2 = Single-parent families
3 = Married couples filing jointly
4 = Married couples filing separately */

gen minimosdescendientes == c481_06		

gen numerodescen = 0  															/* Number of dependent children */
replace numerodescen = 1 if minimosdescendientes >0 & tipohogar_06 <=3
replace numerodescen = 2 if minimosdescendientes >140000 & tipohogar_06 <=3
replace numerodescen = 3 if minimosdescendientes >290000 & tipohogar_06 <=3
replace numerodescen = 4 if minimosdescendientes >510000 & tipohogar_06 <=3
replace numerodescen = 5 if minimosdescendientes >740000 & tipohogar_06 <=3
replace numerodescen = 6 if minimosdescendientes >970000 & tipohogar_06 <=3
replace numerodescen = 7 if minimosdescendientes >1200000 & tipohogar_06 <=3
replace numerodescen = 8 if minimosdescendientes >1430000 & tipohogar_06 <=3
replace numerodescen = 9 if minimosdescendientes >1660000 & tipohogar_06 <=3
replace numerodescen = 10 if minimosdescendientes >1890000 & tipohogar_06 <=3
replace numerodescen = 11 if minimosdescendientes >2120000 & tipohogar_06 <=3
replace numerodescen = 12 if minimosdescendientes >2350000 & tipohogar_06 <=3
replace numerodescen = 13 if minimosdescendientes >2580000 & tipohogar_06 <=3
replace numerodescen = 14 if minimosdescendientes >2810000 & tipohogar_06 <=3
replace numerodescen = 15 if minimosdescendientes >3040000 & tipohogar_06 <=3
replace numerodescen = 16 if minimosdescendientes >3270000 & tipohogar_06 <=3
replace numerodescen = 17 if minimosdescendientes >3500000 & tipohogar_06 <=3
replace numerodescen = 18 if minimosdescendientes >3730000 & tipohogar_06 <=3
replace numerodescen = 19 if minimosdescendientes >4190000 & tipohogar_06 <=3
replace numerodescen = 20 if minimosdescendientes >4420000 & tipohogar_06 <=3

replace numerodescen = 1 if minimosdescendientes >0 & tipohogar_06 >3
replace numerodescen = 2 if minimosdescendientes >70000 & tipohogar_06 >3
replace numerodescen = 3 if minimosdescendientes >145000 & tipohogar_06 >3
replace numerodescen = 4 if minimosdescendientes >255000 & tipohogar_06 >3
replace numerodescen = 5 if minimosdescendientes >370000 & tipohogar_06 >3
replace numerodescen = 6 if minimosdescendientes >485000 & tipohogar_06 >3
replace numerodescen = 7 if minimosdescendientes >600000 & tipohogar_06 >3
replace numerodescen = 8 if minimosdescendientes >7150000 & tipohogar_06 >3
replace numerodescen = 9 if minimosdescendientes >8300000 & tipohogar_06 >3
replace numerodescen = 10 if minimosdescendientes >945000 & tipohogar_06 >3
replace numerodescen = 11 if minimosdescendientes >1060000 & tipohogar_06 >3
replace numerodescen = 12 if minimosdescendientes >1175000 & tipohogar_06 >3
replace numerodescen = 13 if minimosdescendientes >1290000 & tipohogar_06 >3
replace numerodescen = 14 if minimosdescendientes >1405000 & tipohogar_06 >3
replace numerodescen = 15 if minimosdescendientes >1520000 & tipohogar_06 >3
replace numerodescen = 16 if minimosdescendientes >1635000 & tipohogar_06 >3
replace numerodescen = 17 if minimosdescendientes >1750000 & tipohogar_06 >3
replace numerodescen = 18 if minimosdescendientes >1865000 & tipohogar_06 >3
replace numerodescen = 19 if minimosdescendientes >1980000 & tipohogar_06 >3
replace numerodescen = 20 if minimosdescendientes >2210000 & tipohogar_06 >3

gen minimosdescendientes == c681_07

gen numerodescen_07 = 0
replace numerodescen_07 = 1 if minimosdescendientes_07 >0 & tipohogar_07 <=3
replace numerodescen_07 = 2 if minimosdescendientes_07 >180000 & tipohogar_07 <=3
replace numerodescen_07 = 3 if minimosdescendientes_07 >380000 & tipohogar_07 <=3
replace numerodescen_07 = 4 if minimosdescendientes_07 >740000 & tipohogar_07 <=3
replace numerodescen_07 = 5 if minimosdescendientes_07 >1150000 & tipohogar_07 <=3
replace numerodescen_07 = 6 if minimosdescendientes_07 >1560000 & tipohogar_07 <=3
replace numerodescen_07 = 7 if minimosdescendientes_07 >1970000 & tipohogar_07 <=3
replace numerodescen_07 = 8 if minimosdescendientes_07 >2380000 & tipohogar_07 <=3
replace numerodescen_07 = 9 if minimosdescendientes_07 >2790000 & tipohogar_07 <=3
replace numerodescen_07 = 10 if minimosdescendientes_07 >3200000 & tipohogar_07 <=3
replace numerodescen_07 = 11 if minimosdescendientes_07 >3610000 & tipohogar_07 <=3
replace numerodescen_07 = 12 if minimosdescendientes_07 >4020000 & tipohogar_07 <=3
replace numerodescen_07 = 13 if minimosdescendientes_07 >4430000 & tipohogar_07 <=3
replace numerodescen_07 = 14 if minimosdescendientes_07 >4840000 & tipohogar_07 <=3
replace numerodescen_07 = 15 if minimosdescendientes_07 >5250000 & tipohogar_07 <=3
replace numerodescen_07 = 16 if minimosdescendientes_07 >5660000 & tipohogar_07 <=3
replace numerodescen_07 = 17 if minimosdescendientes_07 >6070000 & tipohogar_07 <=3
replace numerodescen_07 = 18 if minimosdescendientes_07 >6480000 & tipohogar_07 <=3
replace numerodescen_07 = 19 if minimosdescendientes_07 >5890000 & tipohogar_07 <=3
replace numerodescen_07 = 20 if minimosdescendientes_07 >7300000 & tipohogar_07 <=3

replace numerodescen_07 = 1 if minimosdescendientes_07 >0 & tipohogar_07 >3
replace numerodescen_07 = 2 if minimosdescendientes_07 >90000 & tipohogar_07 >3
replace numerodescen_07 = 3 if minimosdescendientes_07 >190000 & tipohogar_07 >3
replace numerodescen_07 = 4 if minimosdescendientes_07 >370000 & tipohogar_07 >3
replace numerodescen_07 = 5 if minimosdescendientes_07 >575000 & tipohogar_07 >3
replace numerodescen_07 = 6 if minimosdescendientes_07 >780000 & tipohogar_07 >3
replace numerodescen_07 = 7 if minimosdescendientes_07 >985000 & tipohogar_07 >3
replace numerodescen_07 = 8 if minimosdescendientes_07 >1190000 & tipohogar_07 >3
replace numerodescen_07 = 9 if minimosdescendientes_07 >1395000 & tipohogar_07 >3
replace numerodescen_07 = 10 if minimosdescendientes_07 >1600000 & tipohogar_07 >3
replace numerodescen_07 = 11 if minimosdescendientes_07 >1805000 & tipohogar_07 >3
replace numerodescen_07 = 12 if minimosdescendientes_07 >2010000 & tipohogar_07 >3
replace numerodescen_07 = 13 if minimosdescendientes_07 >2215000 & tipohogar_07 >3
replace numerodescen_07 = 14 if minimosdescendientes_07 >2420000 & tipohogar_07 >3
replace numerodescen_07 = 15 if minimosdescendientes_07 >2625000 & tipohogar_07 >3
replace numerodescen_07 = 16 if minimosdescendientes_07 >2830000 & tipohogar_07 >3
replace numerodescen_07 = 17 if minimosdescendientes_07 >3035000 & tipohogar_07 >3
replace numerodescen_07 = 18 if minimosdescendientes_07 >3240000 & tipohogar_07 >3
replace numerodescen_07 = 19 if minimosdescendientes_07 >3445000 & tipohogar_07 >3
replace numerodescen_07 = 20 if minimosdescendientes_07 >3650000 & tipohogar_07 >3


***** SELF-EMPLOYMENT, AND BUSINESS AND PROFESSIONAL ACTIVITIES *****

gen actividadeseconomicas = 0   /* Business and Professional Activities (Non-Corporate) */
replace actividadeseconomicas = 1 if c140_06>0 /* Direct estimation of net income regime */
replace actividadeseconomicas = 2 if c170_06>0 /* Index-based estimation of net income, except farming and livestock activities */
replace actividadeseconomicas = 2 if c199_06>0 /* Index-based estimation of net income for farming and livestock activities*/

gen autonomo = 0  				/* autonomo: Self-Employed */
replace autonomo = 1 if c140_06>0 /* Direct estimation of net income regime */
replace autonomo = 1 if c170_06>0 /* Index-based estimation of net income, except farming and livestock activities */
replace autonomo = 1 if c199_06>0 /* Index-based estimation of net income for farming and livestock activities*/


***** INCOME FROM INVESTMENTS AND SAVINGS *****

gen rendcapital = 0
replace rendcapital = 1 if c28_06 >0     


***** INCOME FROM REAL ESTATE PROPERTIES *****
  
gen rendinmob = 0              

replace rendinmob = 1 if c80_06>0 		/* Rental income */
replace rendinmob = 1 if c87_06>0 		/* Imputed minimum rent to relatives */
replace rendinmob = 1 if c79_06>0 		/* imputed income for owner-occupied housing (except for primary residence) */


***** TAX FILERS REPORTING CAPITAL GAINS *****

gen gananciascapital = 1 if gananciascapital_06 > 0
replace gananciascapital = 0 if gananciascapital==.


***** MARITAL STATUS *****

/* 1: single; 2: Single-parent (with dependent children < 18 years of age); 3: married

tipohogar: Type of family unit of taxation
1 = Unmarried individuals
2 = Single-parent families
3 = Married couples filing jointly
4 = Married couples filing separately 

*/

gen modelohogar= 0
replace modelohogar = 1 if tipohogar_06 == 1
replace modelohogar = 2 if tipohogar_06 == 2
replace modelohogar = 3 if tipohogar_06 == 3
replace modelohogar = 3 if tipohogar_06 == 4

gen modelohogar2= 0
replace modelohogar2 = 0 if tipohogar_06 == 1
replace modelohogar2 = 0 if tipohogar_06 == 2
replace modelohogar2 = 1 if tipohogar_06 == 3
replace modelohogar2 = 1 if tipohogar_06 == 4


***** UNEMPLOYED *****

gen ingresostrabajo = c1_06 + c5_06 + c6_06  						/* Labour earnings (wages, salaries, remuneration in-kind)  */

gen cotizacionseguridadsocial = c13_06 - c12_06 -c11_06 - c10_06 	/* Employee's social contributions */

gen desempleado = 0 												/* Unemployed */

replace desempleado = 1 if (ingresostrabajo>0 & cotizacionseguridadsocial == 0 & edad<60)


***** RETIRED *****

gen jubilado = 0													/* Retired */
replace jubilado = 1 if (ingresostrabajo>0 & cotizacionseguridadsocial == 0 & edad>60)


***** SPANISH AUTONOMOUS COMMUNITIES (Common Tax Regime) *****

gen andalucia = 0 
replace andalucia =1 if ccaa==1
gen aragon = 0 
replace aragon =1 if ccaa==2
gen asturias = 0 
replace asturias =1 if ccaa==3
gen baleares = 0 
replace baleares =1 if ccaa==4
gen canarias = 0 
replace canarias =1 if ccaa==5
gen cantabria = 0 
replace cantabria =1 if ccaa==6
gen lamancha = 0 
replace lamancha =1 if ccaa==7
gen leon = 0 
replace leon =1 if ccaa==8
gen catalunya = 0 
replace catalunya =1 if ccaa==9
gen extremadura = 0 
replace extremadura =1 if ccaa==10
gen galicia = 0 
replace galicia =1 if ccaa==11
gen madrid = 0 
replace madrid =1 if ccaa==12
gen murcia = 0 
replace murcia =1 if ccaa==13
gen rioja = 0 
replace rioja =1 if ccaa==16
gen valencia = 0 
replace valencia =1 if ccaa==17
gen ceuta = 0 
replace ceuta =1 if ccaa==18
gen melilla = 0 
replace melilla =1 if ccaa==19	
	

***** PERCENTAGE OF THE TOTAL TAXABLE INCOME OF THE MARRIED COUPLES ACCOUNTED FOR BY THE MAIN INCOME EARNER *****

/* 

- Criterion of income distribution between spouses when they file jointly (tipohogar_06 = 3):

(1) Earned income, pensions, unemployment benefits, self-employment and business income are assigned to the main income earner; 
(2) Capital income and net capital gains are divided equally between both spouses. 

- Married couples filing separately: It is necessary to add the adjusted gross income of the spouse belonging to file "conyuges.dta" 

*/

gen renta_conyuge = 0
replace renta_conyuge = 0.5*(c28_06 + c79_06 + c80_06 + c87_06 + gananciascapital_06) if tipohogar_06 ==3
replace renta_conyuge = c476_06_CY + c479_06_CY	if tipohogar_06 ==4  

gen main_earner = 0
replace main_earner = 1 if tipohogar_06<4
replace main_earner = 1 if (tipohogar == 4 & (baseimponible_06 >= renta_conyuge))

gen income_main_earner = baseimponible_06 
replace income_main_earner = renta_conyuge if main_earner == 0

gen prop_income_main_earner = income_main_earner/(baseimponible_06 + c476_06_CY + c479_06_CY)


******************************************************************************************************************************************
******************************************************************************************************************************************



