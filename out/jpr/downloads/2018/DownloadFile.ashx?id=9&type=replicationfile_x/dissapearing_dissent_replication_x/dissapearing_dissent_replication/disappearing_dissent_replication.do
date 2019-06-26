****************************************************************************
****************************************************************************
**** 
**** Disappearing Dissent? 
**** Osorio, Schubiger, and Weintraub
**** 
**** Replication dofile
**** 
****************************************************************************
****************************************************************************


****************************************************************************
****************************************************************************
****************************************************************************
* ARTICLE REPLICATION
****************************************************************************
****************************************************************************
****************************************************************************


clear

****************************************************************************
****************************************************************************
* Set global directory
glo dir "C:\Users\javie\Dropbox\Mexico_Desaparecidos\Analysis\dissapearing_dissent_replication"

* Set working directory
	cd "${dir}"

* Get the data
	*use "${dir}\data\desaparecidos_1.dta", clear
	use "${dir}\disappearing_dissent_data.dta", clear
	set more off



********************************************************************
********************************************************************
* GENERATE DATA 
	{
	* Human rights violations (logged)
		sum viol_dh
		gen viol_dh_log=ln(viol_dh+1)
		sum viol_dh_log

	* Desaparecidos (logged)
		gen desaparecidos_log=ln(desaparecidos_count+1)
		gen desap_groups= desaparecidos_count*gropus_72

	* Population 1960s (logged)
		gen pop60_log=ln(pop60_total)

	* Total crime )log)
		gen tot_crime2014_log = ln(total2014+1)

	* Welfare programs
		gen welfare_num=PROSPERA_Beneficiarios +LICONSA +PAM +PROSPERA_EASC_Titulares +PDZP +PEI_MPT +PEI_Resp +Mig_3x1 +PET +PAJA +FONART +POP +SEVJF +COMEDORES +INAPAM +IMJUVE1 +IMJUVE2 +FES
		gen welfare_log=ln(PROSPERA_Beneficiarios +LICONSA +PAM +PROSPERA_EASC_Titulares +PDZP +PEI_MPT +PEI_Resp +Mig_3x1 +PET +PAJA +FONART +POP +SEVJF +COMEDORES +INAPAM +IMJUVE1 +IMJUVE2 +FES)
		gen welfare_per=(PROSPERA_Beneficiarios +LICONSA +PAM +PROSPERA_EASC_Titulares +PDZP +PEI_MPT +PEI_Resp +Mig_3x1 +PET +PAJA +FONART +POP +SEVJF +COMEDORES +INAPAM +IMJUVE1 +IMJUVE2 +FES)/poverty_num

	* Taxees (land and property)
			replace ing_predial=0 if ing_predial==.
			replace ing_agua=0 if ing_agua==.
			replace ing_total=0 if ing_total==.
		gen ing_predial_share=(1+ing_predial)/(1+ing_total)
			replace ing_predial_share=0 if ing_predial_share==1
		gen ing_agua_share=(ing_agua+1)/(ing_total+1)
			replace ing_agua_share=0 if ing_agua_share==1
		
		
	* Prospera beneficiarios
		gen prospera_per=PROSPERA_Beneficiarios/poverty_num
		gen	LICONSA_per=LICONSA/poverty_num
		gen	PAM_per=PAM/poverty_num
		gen	PROSPERA_EASC_per=PROSPERA_EASC_Titulares/poverty_num
		gen	PDZP_per=PDZP/poverty_num
		gen	PEI_MPT_per=PEI_MPT/poverty_num
		gen	PEI_Resp_per=PEI_Resp/poverty_num
		gen	Mig_3x1_per=Mig_3x1/poverty_num
		gen	PET_per=PET/poverty_num
		gen	PAJA_per=PAJA/poverty_num
		gen	FONART_per=FONART/poverty_num
		gen	POP_per=POP/poverty_num
		gen	SEVJF_per=SEVJF/poverty_num
		gen	COMEDORES_per=COMEDORES/poverty_num
		gen	INAPAM_per=INAPAM/poverty_num
		gen	IMJUVE1_per=IMJUVE1/poverty_num
		gen	IMJUVE2_per=IMJUVE2/poverty_num
		gen	FES_per=FES	/poverty_num

	* Log road density
		gen road_density_15_log=ln(road_density_15+1)
		
	* Generatate homicide per 100K	
		gen homicide_100K = homicidiosdolosos2013/(population2010/100000)
			label var homicide_100K "Homicides"

	* Generatate police per capita	
		gen police_percapita = police_num/population2010
			label var police_percapita "Police"

	* Generatate HR violations per capita	
		gen viol_dh_100K = viol_dh/(population2010/100000)	
			label var viol_dh_100K "HR"
		gen viol_dh_pc = viol_dh/(population2010)	
			label var viol_dh_pc  "HR"	



	}
	*	

********************************************************************
* Label varibles
	{
	* Variables
		label var desaparecidos "Disappearances"
		label var desaparecidos_count "Number of disappearances"	
		label var desaparecidos_log "Disappearances"
		label var gropus_72	"Armed groups"
		label var myers2b "Myers"
		label var welfare_per "Welfare"
		label var prospera_per "Progresa"
		label var reg_indice "Reg."
		label var plan_indice "Plans"
		label var ing_predagua_share "Taxes"	
		label var road_density_15 "Roads"
		label var oficina_fed "Fed. O."
		label var oficina_mun "Mun. O."
		label var police_num "Police"
		label var viol_dh "HR"
		label var total_all_dto "DTOs"
		label var homicidiosdolosos2013 "Homicides"
		label var total2014 "Crimes (total 2014)"
		label var tot_crime2014_log "Crimes (total logged 2014)"
		label var population2010 "Population (2010)"
		label var desap_groups "Disappearances x groups"
		label var welfare_num "Welfare number"
		label var  welfare_log "Welfare log"
		label var pop60_log "Population 60 log"
		label var road_density_15_log "Road density (logged)"
		}
	*


********************************************************************
********************************************************************
*Export database for map
*export excel cve_mun_old cve_ent desap* gropus_72  using "${dir}\desaparecidos_for_map.xls", firstrow(variables) replace

*Export database for sensitivity analysis
saveold "${dir}\desaparecidos_1_stata12_for_R.dta",   version(12) replace	

* Export working data
save "${dir}\disappearing_dissent_data_working.dta", replace




********************************************************************
********************************************************************
** DESCRIPTIVE STATISTICS

********************************************************************
*Tabulate descriptive statistics

	tabstat myers2b, stat(mean sd min max) 
	tabstat welfare_per, stat(mean sd min max) 
	tabstat prospera_per, stat(mean sd min max)   
	tabstat reg_indice, stat(mean sd min max)  
	tabstat plan_indice, stat(mean sd min max)   
	tabstat ing_predagua_share, stat(mean sd min max) 
	tabstat road_density_15, stat(mean sd min max)  
	tabstat oficina_fed, stat(mean sd min max)  
	tabstat oficina_mun, stat(mean sd min max)  
	tabstat police_num, stat(mean sd min max)  
	tabstat viol_dh, stat(mean sd min max)  
	tabstat total_all_dto, stat(mean sd min max)  
	tabstat homicidiosdolosos2013, stat(mean sd min max) 
	tabstat desaparecidos, stat(mean sd min max) 

* Examples of variables 
	{
	sum myers2b  
	list NOM_ENT NOM_MUN if  myers2b>=13
	list NOM_ENT NOM_MUN if  myers2b<=1.6

	sum welfare_per
	list NOM_ENT NOM_MUN if  welfare_per>=2.6
	list NOM_ENT NOM_MUN if  welfare_per<=.21

	sum prospera_per
	list NOM_ENT NOM_MUN if  prospera_per>=1.9
	list NOM_ENT NOM_MUN if  prospera_per<=0.001

	sum reg_indice
	list NOM_ENT NOM_MUN if reg_indice >=100
	list NOM_ENT NOM_MUN if reg_indice <=.1

	sum  plan_indice
	list NOM_ENT NOM_MUN if  plan_indice>=95
	list NOM_ENT NOM_MUN if  plan_indice<=.1

	sum road_density_15
	list NOM_ENT NOM_MUN if  road_density_15>=1.3
	list NOM_ENT NOM_MUN if  road_density_15<=0.001
	 
	sum oficina_fed
	list NOM_ENT NOM_MUN if  oficina_fed>=160
	list NOM_ENT NOM_MUN if  oficina_fed<1

	sum oficina_mun
	list NOM_ENT NOM_MUN if  oficina_mun>=160
	list NOM_ENT NOM_MUN if  oficina_mun<1

	sum police_num
	list NOM_ENT NOM_MUN if  police_num>=3000
	list NOM_ENT NOM_MUN if  police_num<=10

	sum viol_dh
	list NOM_ENT NOM_MUN if  viol_dh>=30
	list NOM_ENT NOM_MUN if  viol_dh<=1

	sum total_all_dto
	list NOM_ENT NOM_MUN if  total_all_dto>=9
	list NOM_ENT NOM_MUN if  total_all_dto==0

	sum homicidiosdolosos2013
	list NOM_ENT NOM_MUN if  homicidiosdolosos2013>=300
	list NOM_ENT NOM_MUN if  homicidiosdolosos2013<=0
	}
	*

	
********************************************************************
********************************************************************
** GENERATE FIGURES


********************************************************************
* Figure 1

* See GIS map



********************************************************************
* Figure 2

* Preserve current data
preserve

	* Get raw data
	clear
	import excel "${dir}\desaparecidos_raw_data.xlsx", sheet("Sheet1") firstrow

	* Clean data
	gen desaparecidos=1
	drop if Año==. | Año<1972 | Año>1988

	* Collapse to generate annual data
	collapse (rawsum) desaparecidos, by(Año)

	* Declare as time series
	tsset Año

	* Generate graph
	twoway (tsline desaparecidos), ytitle(Disappeared) ttitle(Year) tlabel(1972(4)1988) scheme(s1mono)
	graph save "disappearancesovertime.pdf", replace
	
* Restore data
restore




	
********************************************************************
********************************************************************
** OLS ANALYSIS - MAIN RESULTS TABLE 

eststo clear
estimates clear	

********************************
* COLLECTIVE	
	* Clear estimates
		set more off
	* Declare variables
		local DV "myers2b welfare_per prospera_per"
		local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
		local indep "morelos mina hidalgo guerrero french "
		local infra "telegraphs Railways road_density_72"
		local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
		local PIB70 "PIB70_total"
	* Regression analysis
		local n=0
		foreach i in `DV' {
			local n=`n'+1
			reg `i'	c.desaparecidos_log gropus_72 `geo' `indep' `infra' `demo60' `PIB70' , cl(cve_mun_old) 
				eststo m1`n'
			margins, at(desaparecidos_log=(0(1)5))
			}		
		
********************************
* LEGAL		
 	* Clear estimates
		set more off
	* Declare variables
		local DV "reg_indice plan_indice "
		local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
		local indep "morelos mina hidalgo guerrero french "
		local infra "telegraphs Railways road_density_72"
		local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
		local PIB70 "PIB70_total"
	* Regression analysis
		local n=0
		foreach i in `DV' {
			local n=`n'+1
			reg `i'	c.desaparecidos_log gropus_72  `geo' `indep' `infra' `demo60' `PIB70' , cl(cve_mun_old) 
				eststo m2`n'
			margins, at(desaparecidos_log=(0(1)5))
			}		
		  
********************************
* FISCAL		
 	* Clear estimates
		set more off
	* Declare variables
		local DV "ing_predagua_share "
		local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
		local indep "morelos mina hidalgo guerrero french "
		local infra "telegraphs Railways road_density_72"
		local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
		local PIB70 "PIB70_total"
	* Regression analysis
		local n=0
		foreach i in `DV' {
			local n=`n'+1
			reg `i'	c.desaparecidos_log gropus_72  `geo' `indep' `infra' `demo60' `PIB70' , cl(cve_mun_old) 
				eststo m3`n'	
			margins, at(desaparecidos_log=(0(1)5))
			}		 
		  	  
********************************
* TERRITORY		
	* Clear estimates
		set more off
	* Declare variables
		local DV "road_density_15 oficina_fed oficina_mun"
		local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
		local indep "morelos mina hidalgo guerrero french "
		local infra "telegraphs Railways road_density_72"
		local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
		local PIB70 "PIB70_total"
	* Regression analysis
		local n=0
		foreach i in `DV' {
			local n=`n'+1
			reg `i'	c.desaparecidos_log gropus_72  `geo' `indep' `infra' `demo60' `PIB70' , cl(cve_mun_old) 
				eststo m4`n'
			margins, at(desaparecidos_log=(0(1)5))
			}		  
		  
********************************
* SECURITY		
 
	* Clear estimates
		set more off
	* Declare variables
		local DV "police_percapita viol_dh_pc total_all_dto homicide_100K"
		local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
		local indep "morelos mina hidalgo guerrero french "
		local infra "telegraphs Railways road_density_72"
		local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
		local PIB70 "PIB70_total"
	* Regression analysis
		local n=0
		foreach i in `DV' {
			local n=`n'+1
			reg `i'	c.desaparecidos_log gropus_72  `geo' `indep' `infra' `demo60' `PIB70' , cl(cve_mun_old) 
				eststo m5`n'
			margins, at(desaparecidos_log=(0(1)5))
			}		  
	
********************************
* ALL MODELS
* CREATE TABLE 1		
	* Declare variables	  
		local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
		local indep "morelos mina hidalgo guerrero french "
		local infra "telegraphs Railways road_density_72"
		local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
		local PIB70 "PIB70_total"
	* Table all results
				{
		#delimit ;
			esttab m1* m2* m3* m4* m5*  using "${dir}\table_1_main_results.tex",   
				unstack starlevels(+ .10 * 0.05 ** 0.01 *** 0.001) cells(b(star fmt(%9.1f)) se(par)) 
				stats(r2 N, fmt(%9.2f %9.0g) labels(R2 N)) replace label 
				title(Effect of Disappearances on State Capabilities )  
				collabels(, none) varlabels(_cons Constant) 
				style(tex)prehead("\begin{table}" \footnotesize \caption{@title} "\begin{tabular}{lccccccccccccc}" \hline\hline 
					& \multicolumn{3}{c}{\footnotesize Collective }
					&\multicolumn{2}{c}{\footnotesize Legal}
					&\multicolumn{1}{c}{\footnotesize Fiscal}
					&\multicolumn{3}{c}{\footnotesize Territorial}
					&\multicolumn{4}{c}{\footnotesize Security}\\\cline{2-14}) 
				posthead(\hline) prefoot(\hline) 
				postfoot(\hline\hline 
					\multicolumn{14}{l}{\footnotesize + p<0.10, * p<0.05, ** p<0.01, *** p<0.001. Standard errors in parentheses. The controls include the following sets of variables:}\\ 
					\multicolumn{14}{l}{\footnotesize Geographic: elevation, distance to the center, Northwest, Northeast, West, East, Southcentral, Southwest, and Southeast regional dummies. }\\ 
					\multicolumn{14}{l}{\footnotesize Insurgencies: Hidalgo \& Allende (1810-1811), Morelos (1810-1815), Mina (1817),  Guerrero (1816-1821), and the French intervention (1862-1867). }\\ 
					\multicolumn{14}{l}{\footnotesize Infrastructure: telegraphs in 1919, railways in 1919, road density in 1972. }\\ 
					\multicolumn{14}{l}{\footnotesize Demographics in 1960: population size (log), youth (age 18 - 35), rural, illiterate, and unemployed. }\\ 
					\multicolumn{14}{l}{\footnotesize GDP in 1970 by sector:  agriculture, banking, commerce, construction, electricity, finances, manufacturing, mining, services, and transportation. }\\ 
					"\end{tabular}" "\end{table}") 
				indicate(Controls=`geo' `indep' `infra' `demo60' `PIB70') 
			;
		#delimit cr	
		}
		*			 

********************************************************************
* MULTICOLLINEARITY TEST (Variance Inflation Factor)	

	* This command generates table in Appendix 3
	vif		
	
	
	
	
****************************************************************************
****************************************************************************
****************************************************************************
* APPENDIX REPLICATION
****************************************************************************
****************************************************************************
****************************************************************************	


********************************************************************
* APPENDIX 1 - Public opinion analysis (ENCUP)
	{

	* Load survey data
	clear
	use "Base_Quinta ENCUP_2012.dta"

	**********************************************************************************
	**********************************************************************************
	* SETUP VARIABLES

	*****************************************

	* Estado
	tab edo

	* Municipio
	tab muni
	tab muni if edo==12

	* Gen mpal_id
	gen double mpal_id=(edo*1000)+muni
	order D_R punto folio cp edo dtto muni mpal_id

	* Gen municipalities with desaparecidos
	gen desaparecidos=0
	{
		replace desaparecidos=1 if mpal_id==2002
		replace desaparecidos=1 if mpal_id==7017
		replace desaparecidos=1 if mpal_id==7048
		replace desaparecidos=1 if mpal_id==7059
		replace desaparecidos=1 if mpal_id==7101
		replace desaparecidos=1 if mpal_id==8019
		replace desaparecidos=1 if mpal_id==8021
		replace desaparecidos=1 if mpal_id==8037
		replace desaparecidos=1 if mpal_id==9002
		replace desaparecidos=1 if mpal_id==9003
		replace desaparecidos=1 if mpal_id==9012
		replace desaparecidos=1 if mpal_id==10005
		replace desaparecidos=1 if mpal_id==12001
		replace desaparecidos=1 if mpal_id==12011
		replace desaparecidos=1 if mpal_id==12021
		replace desaparecidos=1 if mpal_id==12022
		replace desaparecidos=1 if mpal_id==12023
		replace desaparecidos=1 if mpal_id==12029
		replace desaparecidos=1 if mpal_id==12035
		replace desaparecidos=1 if mpal_id==12038
		replace desaparecidos=1 if mpal_id==12057
		replace desaparecidos=1 if mpal_id==13003
		replace desaparecidos=1 if mpal_id==13079
		replace desaparecidos=1 if mpal_id==13080
		replace desaparecidos=1 if mpal_id==14039
		replace desaparecidos=1 if mpal_id==14053
		replace desaparecidos=1 if mpal_id==14055
		replace desaparecidos=1 if mpal_id==14120
		replace desaparecidos=1 if mpal_id==15013
		replace desaparecidos=1 if mpal_id==15025
		replace desaparecidos=1 if mpal_id==15033
		replace desaparecidos=1 if mpal_id==15057
		replace desaparecidos=1 if mpal_id==15058
		replace desaparecidos=1 if mpal_id==15070
		replace desaparecidos=1 if mpal_id==15081
		replace desaparecidos=1 if mpal_id==15096
		replace desaparecidos=1 if mpal_id==15104
		replace desaparecidos=1 if mpal_id==16053
		replace desaparecidos=1 if mpal_id==16107
		replace desaparecidos=1 if mpal_id==17006
		replace desaparecidos=1 if mpal_id==17007
		replace desaparecidos=1 if mpal_id==17024
		replace desaparecidos=1 if mpal_id==18017
		replace desaparecidos=1 if mpal_id==19039
		replace desaparecidos=1 if mpal_id==20043
		replace desaparecidos=1 if mpal_id==20067
		replace desaparecidos=1 if mpal_id==20469
		replace desaparecidos=1 if mpal_id==21078
		replace desaparecidos=1 if mpal_id==21083
		replace desaparecidos=1 if mpal_id==21109
		replace desaparecidos=1 if mpal_id==21114
		replace desaparecidos=1 if mpal_id==21154
		replace desaparecidos=1 if mpal_id==21181
		replace desaparecidos=1 if mpal_id==24028
		replace desaparecidos=1 if mpal_id==25001
		replace desaparecidos=1 if mpal_id==25006
		replace desaparecidos=1 if mpal_id==25009
		replace desaparecidos=1 if mpal_id==25010
		replace desaparecidos=1 if mpal_id==26003
		replace desaparecidos=1 if mpal_id==26029
		replace desaparecidos=1 if mpal_id==26030
		replace desaparecidos=1 if mpal_id==26033
		replace desaparecidos=1 if mpal_id==26043
		replace desaparecidos=1 if mpal_id==27004
		replace desaparecidos=1 if mpal_id==28002
		replace desaparecidos=1 if mpal_id==28032
		replace desaparecidos=1 if mpal_id==30039
		replace desaparecidos=1 if mpal_id==30072
	}
	*
		label var desaparecidos "Disappearances (imputed)"

	* Generate Guerrero dummy
	gen Guerrero=1 if edo==12
		replace Guerrero=0 if edo!=12
	label var Guerrero "Guerrero"


	*****************************************
	* CONFIDENCE (0 none - 10 a lot)
	* Confianza en el gobierno
		tab p30_12, nolab 
		gen conf_gobierno=p30_12
			replace conf_gobierno=. if p30_12==99	
		label var conf_gobierno "Trust in government"
	* Confianza en el presidente
		tab p30_14, nolab 
		gen conf_presidente=p30_14
			replace conf_presidente=. if p30_14==99	
		label var conf_presidente "Trust in President"
	* Confianza en la policía
		tab p30_23, nolab 
		gen conf_policia=p30_23
			replace conf_policia=. if p30_23==99	
		label var conf_policia "Trust in Police"
	* Confianza en el ejército
		tab p30_24, nolab 
		gen conf_ejercito=p30_24
			replace conf_ejercito=. if p30_24==99	
		label var conf_ejercito "Trust in Army"
	* Confianza en los militares
		tab p30_25, nolab 
		gen conf_militares=p30_25
			replace conf_militares=. if p30_25==99	
		label var conf_militares "Trust in Military"
	* Confianza en los partidos
		tab p30_26, nolab 
		gen conf_partidos=p30_26
			replace conf_partidos=. if p30_26==99	
		label var conf_partidos "Trust in Parties"


	*****************************************
	* PARTICIPATION 
	* Any participation (p56)
		forval i = 1/14 {
			replace p56_`i'=. if p56_`i'==98
			replace p56_`i'=. if p56_`i'==99
			replace p56_`i'=0 if p56_`i'==2
		} 
		egen participation_tried = anycount(p56_*) , values(1)
		label var participation_tried "Participation - ever tried"
	* Participation last year (p57)
		forval i = 1/9 {
			replace p57_`i'=. if p57_`i'==98
			replace p57_`i'=. if p57_`i'==99
			replace p57_`i'=0 if p57_`i'==2
		} 
		egen participation_year = anycount(p57_*) , values(1)
		label var participation_year "Participation - last year"
	* Donation (p59)
		forval i = 1/11 {
			replace p59_`i'=. if p59_`i'==98
			replace p59_`i'=. if p59_`i'==99
			replace p59_`i'=0 if p59_`i'==2
		} 
		egen donation = anycount(p59_*) , values(1)
		label var donation "Donation"		
	* Participation organizations (p69)
		forval i = 1/16 {
			replace p69_`i'=. if p69_`i'==98
			replace p69_`i'=. if p69_`i'==99
			replace p69_`i'=0 if p69_`i'==2
		} 
		egen participation_org = anycount(p69_*) , values(1)
		label var participation_org "Participation - organization"
	* Easyness to organize
		tab p70, nolab 
		gen easy_organize=p70
			recode easy_organize (1=5) (2=4) (3=3) (4=2) (5=1)
			replace conf_partidos=. if p70==99 | p70==98	
		label var easy_organize "Easy to organize"
	* Participated solution
		tab p72, nolab 
		gen participated_solution=p72
			recode participated_solution (2=0)
			replace participated_solution=. if p72==99 | p72==98	
		label var participated_solution "Participated in solution"

	*****************************************
	* Efficacy 
	* Citizen efficacy 
		tab p51_2, nolab 
		gen efficacy_current=p51_2
			recode efficacy_current (1=3) (3=1) 
			replace efficacy_current=. if p51_2==99	| p51_2==98
		label var efficacy_current "Citizen efficacy (current)"
	* Citizen opportunities
		tab p55, nolab 
		gen opportunities=p55
			recode opportunities (2=0)
			replace opportunities=. if p55==99	| p55==98
		label var opportunities "Citizen opportunities"

	**********************************
	* Variables for regression analysis
	* Edcation
		tab d, nolab
		gen edu=d
			recode edu (99=.)
			label var edu "Education"
	* Age
		tab b 
		gen age=b
			label var age "Age"
		 
		gen young=0
			replace young=1 if age>=18 & age<=35
			label var young "Young"			
	* Rural
		gen rural=0
			replace rural=1 if tipo==2
			label var rural "Rural"		
	* Socio-economic
		tab nivel, nol
		gen socioeco=.
			replace socioeco=1 if nivel=="E"
			replace socioeco=2 if nivel=="D"
			replace socioeco=3 if nivel=="D+"
			replace socioeco=4 if nivel=="C"
			replace socioeco=5 if nivel=="C+"
			replace socioeco=6 if nivel=="AB"
			label var socioeco "Socioeconomic level"
	* Unemployment	
		tab d1
		tab d1, nolab	
		gen unemp=0
			replace unemp=1 if d1==10
			label var unemp "Unemployment"		
	* Regional dummies
	* Northwest
		gen noroeste=0
				replace noroeste=1 if edo==2 | ///
				edo==3 | ///
				edo==8 | ///
				edo==10 | ///
				edo==25 | ///
				edo==26 
			label var noroeste "Northwest"		
	* Northeast
		gen noreste=0
				replace noreste=1 if edo==5 | ///
				edo==19 | ///
				edo==28
			label var noreste "Northeast"
	* West
		gen oeste=0
				replace oeste=1 if edo==6 | ///
				edo==14 | ///
				edo==16 | ///
				edo==18
			label var oeste "West"		
	* East
		gen este=0
				replace este=1 if edo==13 | ///
				edo==21 | ///
				edo==29 | ///
				edo==30
			label var este "East"		
	* Southcentral
		gen centrosur=0
				replace centrosur=1 if edo==9 | ///
				edo==15 | ///
				edo==17
			label var centrosur "Southcentral"			
	* Southwest
		gen suroeste=0
				replace suroeste=1 if edo==7 | ///
				edo==12 | ///
				edo==20
			label var suroeste "Southwest"	
	* Southeast
		gen sureste=0
				replace sureste=1 if edo==4 | ///
				edo==23 | ///
				edo==27 | ///
				edo==31
			label var sureste "Southeast"	
			
			
	**********************************************************************************
	* SURVEY WEIGHTS

	* Generate survey weight
	* weight(stratum x) = % population (stratum x) / % sample (stratum x)
	* For each cell/group, weight is population proportion/sample proportion. To poststratify by multiple variables, create weights for each and then multiply the weights together. 

		* weight by circunscripcion
		gen peso_circunscripcion = 0
			replace peso_circunscripcion = .206/.2 if circu==1
			replace peso_circunscripcion = .206/.2 if circu==2
			replace peso_circunscripcion = .188/.2 if circu==3
			replace peso_circunscripcion = .2/.2 if circu==4
			replace peso_circunscripcion = .2/.2 if circu==5

		* weight by age
		tab circ a  , row
		gen peso_circ_gen=0
			replace peso_circ_gen = .492/.4933 if circ==1 & a==1
			replace peso_circ_gen = .508/.5067 if circ==1 & a==2
			replace peso_circ_gen = .485/.488 if circ==2 & a==1
			replace peso_circ_gen = .515/.512 if circ==2 & a==2
			replace peso_circ_gen = .481/.4773 if circ==3 & a==1
			replace peso_circ_gen = .519/.5227 if circ==3 & a==2
			replace peso_circ_gen = .473/.48 if circ==4 & a==1
			replace peso_circ_gen = .527/.52 if circ==4 & a==2
			replace peso_circ_gen = .479/.4907 if circ==5 & a==1
			replace peso_circ_gen = .521/.5093 if circ==5 & a==2

		* weight by urban rural mixed
		tab circ tipo  , row
		gen peso_circ_tipo=0
			replace peso_circ_tipo = .761/.76 if circ==1 & tipo==1
			replace peso_circ_tipo = .139/.133 if circ==1 & tipo==2
			replace peso_circ_tipo = .1/.1067 if circ==1 & tipo==3
			replace peso_circ_tipo = .695/.6933 if circ==2 & tipo==1
			replace peso_circ_tipo = .197/.2 if circ==2 & tipo==2
			replace peso_circ_tipo = .108/.1067 if circ==2 & tipo==3
			replace peso_circ_tipo = .516/.52 if circ==3 & tipo==1
			replace peso_circ_tipo = .331/.3333 if circ==3 & tipo==2
			replace peso_circ_tipo = .153/.1467 if circ==3 & tipo==3
			replace peso_circ_tipo = .792/.7867 if circ==4 & tipo==1
			replace peso_circ_tipo = .122/.1333 if circ==4 & tipo==2
			replace peso_circ_tipo = .86/.8 if circ==4 & tipo==3
			replace peso_circ_tipo = .693/.6933 if circ==5 & tipo==1
			replace peso_circ_tipo = .197/.2 if circ==5 & tipo==2
			replace peso_circ_tipo = .11/.1067 if circ==5 & tipo==3	
			
		* weight by age 	
			* Gen age categories
				gen ed_18=1 if b==18
					replace ed_18=0 if ed_18==.
				gen ed_19=1 if b==19
					replace ed_19=0 if ed_19==.
				gen ed_2024=1 if b>=20 & b<=24
					replace ed_2024=0 if ed_2024==.
				gen ed_2529=1 if b>=25 & b<=29
					replace ed_2529=0 if ed_2529==.
				gen ed_3034=1 if b>=30 & b<=34
					replace ed_3034=0 if ed_3034==.
				gen ed_3539=1 if b>=35 & b<=39
					replace ed_3539=0 if ed_3539==.
				gen ed_4044=1 if b>=40 & b<=44
					replace ed_4044=0 if ed_4044==.
				gen ed_4549=1 if b>=45 & b<=49
					replace ed_4549=0 if ed_4549==.
				gen ed_5054=1 if b>=50 & b<=54
					replace ed_5054=0 if ed_5054==.
				gen ed_5559=1 if b>=55 & b<=59
					replace ed_5559=0 if ed_5559==.
				gen ed_6064=1 if b>=60 & b<=64
					replace ed_6064=0 if ed_6064==.
				gen ed_65100=1 if b>=65 
					replace ed_65100=0 if ed_65100==.
			* Tabulate sample proportions
				tab circu ed_18,row
				tab circu ed_19,row
				tab circu ed_2024,row
				tab circu ed_2529,row
				tab circu ed_3034,row
				tab circu ed_3539,row
				tab circu ed_4044,row
				tab circu ed_4549,row
				tab circu ed_5054,row
				tab circu ed_5559,row
				tab circu ed_6064,row
				tab circu ed_65100,row
					
			* Generate weights
				gen peso_circ_age=0
				{
				replace peso_circ_age = .016/.016 if ed_18==1 & circu==1
				replace peso_circ_age = .023/.0227 if ed_19==1 & circu==1
				replace peso_circ_age = .125/.124 if ed_2024==1 & circu==1
				replace peso_circ_age = .127/.124 if ed_2529==1 & circu==1
				replace peso_circ_age = .13/.1267 if ed_3034==1 & circu==1
				replace peso_circ_age = .124/.128 if ed_3539==1 & circu==1
				replace peso_circ_age = .102/.1013 if ed_4044==1 & circu==1
				replace peso_circ_age = .085/.084 if ed_4549==1 & circu==1
				replace peso_circ_age = .069/.0693 if ed_5054==1 & circu==1
				replace peso_circ_age = .053/.0533 if ed_5559==1 & circu==1
				replace peso_circ_age = .042/.048 if ed_6064==1 & circu==1
				replace peso_circ_age = .103/.1027 if ed_65100==1 & circu==1

				replace peso_circ_age = .016/.016 if ed_18==1 & circu==2
				replace peso_circ_age = .023/.0227 if ed_19==1 & circu==2
				replace peso_circ_age = .127/.1307 if ed_2024==1 & circu==2
				replace peso_circ_age = .131/.128 if ed_2529==1 & circu==2
				replace peso_circ_age = .131/.136 if ed_3034==1 & circu==2
				replace peso_circ_age = .123/.1187 if ed_3539==1 & circu==2
				replace peso_circ_age = .102/.1013 if ed_4044==1 & circu==2
				replace peso_circ_age = .084/.0893 if ed_4549==1 & circu==2
				replace peso_circ_age = .067/.068 if ed_5054==1 & circu==2
				replace peso_circ_age = .052/.0493 if ed_5559==1 & circu==2
				replace peso_circ_age = .041/.0427 if ed_6064==1 & circu==2
				replace peso_circ_age = .103/.0973 if ed_65100==1 & circu==2

				replace peso_circ_age = .015/.016 if ed_18==1 & circu==3
				replace peso_circ_age = .024/.0253 if ed_19==1 & circu==3
				replace peso_circ_age = .133/.128 if ed_2024==1 & circu==3
				replace peso_circ_age = .131/.128 if ed_2529==1 & circu==3
				replace peso_circ_age = .124/.1267 if ed_3034==1 & circu==3
				replace peso_circ_age = .114/.1187 if ed_3539==1 & circu==3
				replace peso_circ_age = .098/.0973 if ed_4044==1 & circu==3
				replace peso_circ_age = .085/.0827 if ed_4549==1 & circu==3
				replace peso_circ_age = .069/.0693 if ed_5054==1 & circu==3
				replace peso_circ_age = .055/.0533 if ed_5559==1 & circu==3
				replace peso_circ_age = .043/.0467 if ed_6064==1 & circu==3
				replace peso_circ_age = .109/.108 if ed_65100==1 & circu==3

				replace peso_circ_age = .014/.0147 if ed_18==1 & circu==4
				replace peso_circ_age = .021/.0213 if ed_19==1 & circu==4
				replace peso_circ_age = .12/.1187 if ed_2024==1 & circu==4
				replace peso_circ_age = .125/.1267 if ed_2529==1 & circu==4
				replace peso_circ_age = .125/.1187 if ed_3034==1 & circu==4
				replace peso_circ_age = .118/.1253 if ed_3539==1 & circu==4
				replace peso_circ_age = .099/.1013 if ed_4044==1 & circu==4
				replace peso_circ_age = .087/.0853 if ed_4549==1 & circu==4
				replace peso_circ_age = .072/.0707 if ed_5054==1 & circu==4
				replace peso_circ_age = .057/.056 if ed_5559==1 & circu==4
				replace peso_circ_age = .045/.048 if ed_6064==1 & circu==4
				replace peso_circ_age = .118/.1133 if ed_65100==1 & circu==4

				replace peso_circ_age = .015/.0147 if ed_18==1 & circu==5
				replace peso_circ_age = .023/.0227 if ed_19==1 & circu==5
				replace peso_circ_age = .129/.1307 if ed_2024==1 & circu==5
				replace peso_circ_age = .133/.1333 if ed_2529==1 & circu==5
				replace peso_circ_age = .132/.1333 if ed_3034==1 & circu==5
				replace peso_circ_age = .124/.1227 if ed_3539==1 & circu==5
				replace peso_circ_age = .102/.1013 if ed_4044==1 & circu==5
				replace peso_circ_age = .086/.084 if ed_4549==1 & circu==5
				replace peso_circ_age = .069/.068 if ed_5054==1 & circu==5
				replace peso_circ_age = .052/.052 if ed_5559==1 & circu==5
				replace peso_circ_age = .04/.04 if ed_6064==1 & circu==5
				replace peso_circ_age = .094/.0973 if ed_65100==1 & circu==5
				}
				
	* Generate weight variable
	gen weight = peso_circunscripcion*peso_circ_gen*peso_circ_tipo*peso_circ_age


	****************************************************
	* Survey set
	svyset seccion [pw=weight]  , strata(circu)


	**********************************************************************************
	**********************************************************************************
	* MERGE DATA AT THE MUNICIPAL LEVEL

	merge m:1 mpal_id using "${dir}\disappearing_dissent_data_working.dta"
	drop if _merge==2
	drop _merge


	**********************************************************************************
	**********************************************************************************
	* ANALYSIS

	eststo clear
	estimates clear	

	******************************
	* Regression 1 -  weights   
	******************************
		
	* Declare variables
		* Individual covariates
			local demo "young rural edu socioeco unemp" 
		* Municipal covariates (imputed)
			local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
			local indep "morelos mina hidalgo guerrero french "
			local infra "telegraphs Railways road_density_72"
			local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
			local PIB70 "PIB70_total"

	* Regression analysis		
		svy: reg conf_presidente  desaparecidos_log gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'   
			eststo ma_1
		svy: reg conf_policia  desaparecidos_log gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'   
			eststo ma_2
		svy: reg conf_ejercito  desaparecidos_log gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'   
			eststo ma_3
		svy: reg conf_militares  desaparecidos_log gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'    
			eststo ma_4
		svy: reg conf_partidos  desaparecidos_log gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'   
			eststo ma_5
		svy: reg participation_year  desaparecidos_log  gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'    
			eststo ma_6
		svy: reg participation_org  desaparecidos_log gropus_72 `demo'  `geo' `indep' `infra' `demo60' `PIB70'  
			eststo ma_7
		svy: reg easy_organize  desaparecidos_log gropus_72 `demo' `geo' `indep' `infra' `demo60' `PIB70'   
			eststo ma_8

			
	* Tabulate results		
	esttab ma_* using "appendix_survey_results.tex", unstack starlevels(* .10 ** 0.05 *** 0.01) cells(b(star fmt(%9.2f)) se(par)) stats(r2 N, fmt(%9.2f %9.0g) labels(R2 N)) replace label title(Title)  collabels(, none) varlabels(_cons Constant) 
		


	* Generate precise p values
		* Municipal covariates (imputed)
			local geo "elevation dist_center_log noroeste noreste oeste este  centrosur suroeste sureste"
			local indep "morelos mina hidalgo guerrero french "
			local infra "telegraphs Railways road_density_72"
			local demo60 "pop60_log age_18_35_p rural60_p illiterate60_p unemp60_p"
			local PIB70 "PIB70_total"

	esttab ma_* using "appendix_survey_results_exact_p.txt", b(a3) p(4) r2(4) nostar wide drop (`geo' `indep' `infra' `demo60' `PIB70' ) replace 

		
		
	}
	* End of Appendix 1



********************************************************************
* APPENDIX 2 - Genetic matching

	* See R script for replication



********************************************************************
* APPENDIX 3

	* See variable description in section 3 of the Appendix



********************************************************************
* APPENDIX 4 - Variance inflation factor

	* Go to "OLS ANALYSIS - MAIN RESULTS TABLE" section above
	* Re run lines 280-430



	
****************************************************************************
****************************************************************************
****************************************************************************	
** END OF DOFILE
****************************************************************************
****************************************************************************
****************************************************************************
