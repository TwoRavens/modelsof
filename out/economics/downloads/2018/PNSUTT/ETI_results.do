/*

Article: "How do taxable income responses to marginal tax rates differ by sex, marital status and age? Evidence from Spanish dual income tax"

Authors: Carlos Diaz-Caro and Jorge Onrubia 

Economics: The Open-Access, Open-Assessment E-Journal

*/


********************************************************************************************************  
								***** ESTIMATING ELASTICITIES *****
******************************************************************************************************** 

/* VARIABLES USED			LABELS		

var_Logrentabruta :			Logrentabruta_07 - Logrentabruta_06									[lndiffrenta]

elasticidad : 				Log(1 - Tmg_weighted_07) - Log(1 - Tmg_weighted_06)					

elasticidad_2 :				Log(1 - Tmg_weighted_07_BLG_06) - Log(1 - Tmg_weighted_06)

Logrentabruta_06 :			Log(rentabruta_06) 													[lnrentabruta_2006]

var_LogNetTmed :			LogNetTmed_07 - LogNetTmed_06										[vartm]

var_LogNetTmed_06_07_06 : 	LogNetTmed_06_07 - LogNetTmed_06									[tm_var]

edad :						Age (Years: ###.##)

edad2 :						Age * Age 

grupoedad :					(1: <= 30 years of age; 2: > 30 <= 60 years of age; 3: > 60 years of age)

grupoedad_2 : 				(1: <= 30 years of age; 2: > 30 <= 64 years of age; 3: > 64 years of age)

sexo : 						Gender (0: Female; 1: Male)

numerodescen :				Number of dependent children 
 
autonomo :					Self-employment, Business and Professional Activities (Non-Corporate) 
 
rendcapital :				Income from investments and savings 

rendinmob :					Income from real estate properties

gananciascapital :			Tax filers reporting capital gains 
 
modelohogar :				Marital status (1: single; 2: Single-parent (with dependent children < 18 years of age); 3: married)

modelohogar2 :				Marital status (0: single or single-parent (with dependent children < 18 years of age); 1: married)

desempleado :				Unemployed

jubilado :					Retired

[Name of AC] :				(Spanish Autonomous Communities -AC-: 	andalucia aragon asturias baleares canarias cantabria lamancha leon 
																	catalunya extremadura galicia madrid murcia rioja valencia ceuta melilla) 
  
prop_income_main_earner :	Percentage of the total taxable income of the tax unit accounted for by the income of the main income earner

tramo :						Tax bracket (General Tax Schedule 2006: 1, 2, 3, 4, 5)

*/

******************************************************************************
				***** FOR THE ENTIRE SAMPLE OF TAX FILERS *****
******************************************************************************

***** Two-stage instrumental regression *****

ivreg2  var_Logrentabruta  (elasticidad  = elasticidad_2 ) [pweight = factor], first

** Including Log(rentabruta_06) to control the mean reversion effect **

ivreg2 var_Logrentabruta Logrentabruta_06 (elasticidad  = elasticidad_2 ) [pweight = factor], first

** Including the income effect yielded by the change in the logarithm of the net average tax rate **

ivreg2 lvar_Logrentabruta Logrentabruta_06 (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06)   [pweight = factor], first

** Including the remaining qualitative variables **

ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) [pweight = factor], first

******************************************************************************
				***** EXCLUDING RETIRED TAX FILERS *****
******************************************************************************

ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if jubilado == 0 [pweight = factor], first


******************************************************************************
			***** EXCLUDING RETIRED AND UNEMPLOYED TAX FILERS *****
******************************************************************************

ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if (jubilado == 0 & desempleado ==0) [pweight = factor], first


******************************************************************************
							***** BY GENDER *****
******************************************************************************

by sexo, sort : ivregress 2sls var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) [pweight = factor], first


******************************************************************************
						***** BY MARITAL STATUS *****
******************************************************************************

by modelohogar2, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) [pweight = factor], first


******************************************************************************
						***** BY AGE (Groups of Age) *****
******************************************************************************

by grupoedad_2, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) [pweight = factor], first

******************************************************************************
			***** BY MARITAL STATUS AND AGE (Groups of Age) *****
******************************************************************************


by sexo, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if modelohogar2==0 [pweight = factor], first

by sexo, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if modelohogar2==1 [pweight = factor], first

******************************************************************************
			***** BY MARITAL STATUS, GENDER AND AGE (Groups of Age) *****
******************************************************************************


by grupoedad_2, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if (modelohogar_2==0 & sexo==0) [pweight = factor], first

by grupoedad_2, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if (modelohogar_2==0 & sexo==1) [pweight = factor], first

by grupoedad_2, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if (modelohogar_2==1 & sexo==0) [pweight = factor], first

by grupoedad_2, sort : ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla  (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) if (modelohogar_2==1 & sexo==1) [pweight = factor], first


********************************************************************************************
		***** BY INCOME LEVEL (INCOME BRACKETS OF THE GENERAL TAX SCHEDULE 2006 *****
********************************************************************************************

/* elasticidad and elasticidad_2 are used for the first income bracket */ 


gen elasticidad_tramo2 = elasticidad*tramo2
gen elasticidad_2_tramo2 = elasticidad_2*tramo2

gen elasticidad_tramo3 = elasticidad*tramo3
gen elasticidad_2_tramo3 = elasticidad_2*tramo3

gen elasticidad_tramo4 = elasticidad*tramo4
gen elasticidad_2_tramo4 = elasticidad_2*tramo4

gen elasticidad_tramo5 = elasticidad*tramo5
gen elasticidad_2_tramo5 = elasticidad_2*tramo5


ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla (elasticidad elasticidad_tramo2 elasticidad_tramo3 elasticidad_tramo4 elasticidad_tramo5 var_LogNetTmed = elasticidad_2 elasticidad_2_tramo2 elasticidad_2_tramo3 elasticidad_2_tramo4 elasticidad_2_tramo5 var_LogNetTmed_06_07_06) [pweight = factor], first

by tramo, sort: ivreg2 var_Logrentabruta Logrentabruta_06 edad edad2 sexo numerodescen autonomo rendcapital rendinmob ganaciascapital modelohogar prop_income_main_earner andalucia aragon asturias baleares canarias cantabria lamancha leon catalunya extremadura galicia murcia rioja valencia ceuta melilla (elasticidad var_LogNetTmed = elasticidad_2 var_LogNetTmed_06_07_06) [pweight = factor], first




************************************************************************************
***** CALCULATING DEADWEIGHT LOSS (DWL) AND MARGINAL COST PUBLIC FUNDS (MCPF)  *****
************************************************************************************

/* DWL & MCPF Spanish Personal Income Tax 2006 */

*** For entire sample of tax filers ***

gen DWL_06 = 0.5*((Tmg_weighted_06*Tmg_weighted_06)/(1-Tmg_weighted_06))*0.415*rentabruta_06

gen MCPF_06 = DWL_06 /cuotaliquida_06

mean DWL_06 cuotaliquida_06 MCPF_06 rentabruta_06 [pweight = factor] 


*** By income level (income brackets of the general tax schedule 2006 ***

** Bracket 1 **

gen DWL_tramo1_06 = 0.5*((Tmg_weighted_06*Tmg_weighted_06)/(1-Tmg_weighted_06))*0.37*rentabruta_06

gen MCPF_tramo1_06 = DWL_tramo1_06 /cuotaliquida_06

mean DWL_tramo1_06 cuotaliquida_06 MCPF_tramo1_06 rentabruta_06 [pweight = factor] if tramo == 1

** Bracket 2 **

gen DWL_tramo2_06 = 0.5*((Tmg_weighted_06*Tmg_weighted_06)/(1-Tmg_weighted_06))*0.451*rentabruta_06

gen MCPF_tramo2_06 = DWL_tramo2_06 /cuotaliquida_06

mean DWL_tramo2 cuotaliquida_06 MCPF_tramo2_06 rentabruta_06 [pweight = factor] if tramo == 2

** Bracket 3 **

gen DWL_tramo3_06 = 0.5*((Tmg_weighted_06*Tmg_weighted_06)/(1-Tmg_weighted_06))*0.828*rentabruta_06

gen MCPF_tramo3_06 = DWL_tramo3_06 /cuotaliquida_06

mean DWL_tramo3_06 cuotaliquida_06 MCPF_tramo3_06 rentabruta_06 [pweight = factor] if tramo == 3

** Bracket 4 **

gen DWL_tramo4_06 = 0.5*((Tmg_weighted_06*Tmg_weighted_06)/(1-Tmg_weighted_06))*1.223*rentabruta_06

gen MCPF_tramo4_06 = DWL_tramo4_06 /cuotaliquida_06

mean DWL_tramo4_06 cuotaliquida_06 MCPF_tramo4_06 rentabruta_06 [pweight = factor] if tramo == 4

** Bracket 5 **

gen DWL_tramo5_06 = 0.5*((Tmg_weighted_06*Tmg_weighted_06)/(1-Tmg_weighted_06))*1.441*rentabruta_06

gen MCPF_tramo5_06 = DWL_tramo5_06 /cuotaliquida_06

mean DWL_tramo5_06 cuotaliquida_06 MCPF_tramo5_06 rentabruta_06 [pweight = factor] if tramo == 5


/* DWL & MCPF Spanish Personal Income Tax 2007 */

*** For entire sample of tax filers ***


gen DWL_07 = 0.5*((Tmg_weighted_07*Tmg_weighted_07)/(1-Tmg_weighted_07))*0.415*rentabruta_07

gen MCPF_07 = DWL_07 /cuotaliquida_07

mean DWL_07 cuotaliquida_07 MCPF_07 rentabruta_07 [pweight = factor] 


*** By income level (income brackets of the general tax schedule 2006 ***

** Bracket 1 **

gen DWL_tramo1_07 = 0.5*((Tmg_weighted_07*Tmg_weighted_07)/(1-Tmg_weighted_07))*0.37*rentabruta_07

gen MCPF_tramo1_07 = DWL_tramo1_07 /cuotaliquida_07

mean DWL_tramo1_07 cuotaliquida_07 MCPF_tramo1_07 rentabruta_07 [pweight = factor] if tramo == 1

** Bracket 2 **

gen DWL_tramo2_07 = 0.5*((Tmg_weighted_07*Tmg_weighted_07)/(1-Tmg_weighted_07))*0.451*rentabruta_07

gen MCPF_tramo2_07 = DWL_tramo2_07 /cuotaliquida_07

mean DWL_tramo2 cuotaliquida_07 MCPF_tramo2_07 rentabruta_07 [pweight = factor] if tramo == 2

** Bracket 3 **

gen DWL_tramo3_07 = 0.5*((Tmg_weighted_07*Tmg_weighted_07)/(1-Tmg_weighted_07))*0.828*rentabruta_07

gen MCPF_tramo3_07 = DWL_tramo3_07 /cuotaliquida_07

mean DWL_tramo3_07 cuotaliquida_07 MCPF_tramo3_07 rentabruta_07 [pweight = factor] if tramo == 3

** Bracket 4 **

gen DWL_tramo4_07 = 0.5*((Tmg_weighted_07*Tmg_weighted_07)/(1-Tmg_weighted_07))*1.223*rentabruta_07

gen MCPF_tramo4_07 = DWL_tramo4_07 /cuotaliquida_07

mean DWL_tramo4_07 cuotaliquida_07 MCPF_tramo4_07 rentabruta_07 [pweight = factor] if tramo == 4

** Bracket 5 **

gen DWL_tramo5_07 = 0.5*((Tmg_weighted_07*Tmg_weighted_07)/(1-Tmg_weighted_07))*1.441*rentabruta_07

gen MCPF_tramo5_07 = DWL_tramo5_07 /cuotaliquida_07

mean DWL_tramo5_07 cuotaliquida_07 MCPF_tramo5_07 rentabruta_07 [pweight = factor] if tramo == 5


***********************************************************************************************************************
***********************************************************************************************************************



