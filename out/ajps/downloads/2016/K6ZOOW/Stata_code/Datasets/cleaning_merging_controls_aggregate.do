***************************************************************************
* File:               cleaning_merging_controls_aggregate.do
* Author:             Miguel R. Rueda
* Description:        Creates a panel with control variables.
* Created:            Feb - 01 - 2012
* Last Modified: 	  
* Language:           STATA 13.1
* Related Reference:  "Small aggregates..."
***************************************************************************

cd "\Datasets\Controls\"

*Population elegible to vote
import excel "Population_85_20_DANE.xls", sheet("aux3") firstrow clear
set more off

replace muni_code="" if muni_code=="z"
destring muni_code, generate(muni_code2)

local i=2
local a=muni_code2[1]
while `i'<=21336 { 
			local a =cond(muni_code2[`i']!=.,muni_code2[`i'],`a')
			replace muni_code2=`a' if _n==`i'&muni_code2[`i']==.
			local ++i
                }
drop muni_code
rename muni_code2 muni_code
drop if Population18_m1985==.

generate under_age=cond(edad=="0-4"||edad=="5-9"||edad=="10-14"||edad=="15-19",1,0)
replace under_age=2 if edad=="Total"
drop if under_age==0
drop edad

collapse (sum) Population18_m1985-Population18_m2020, by(muni_code under_age)
foreach year in 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020{
		replace Population18_m`year'=-1*Population18_m`year' if under_age==1
}
collapse (sum) Population18_m1985-Population18_m2020, by(muni_code)
reshape long Population18_m, i(muni_code) j(year)

rename Population18_m Population20
label var Population20 "Adult-Population 20yrs or more"
save populat_20.dta,replace


use trashumancia.dta,clear
*Mining royalties

keep Codigo_Municipio Nombre_dpt Nombre_mpi REGALIA_2010 REGALIA_2009 REGALIA_2008 REGALIA_2007 REGALIA_2006 REGALIA_2005 REGALIA_2004 REGALIA_2003 /// 
REGALIA_2002 REGALIA_2001 REGALIA_2000 REGALIA_1999 REGALIA_1998 REGALIA_1997 REGALIA_1996 REGALIA_1995 REGALIA_1994

reshape long REGALIA_, i(Codigo_Municipio) j(year)

rename REGALIA_ royalties
rename Nombre_mpi municipio
rename Nombre_dpt departamento
destring Codigo_Municipio,gen(muni_code) 
drop Codigo_Municipio
label var royalties "royalties (current pesos) DNP"
 
sort muni_code year
save controls.dta, replace


*Guerrillas' presence
use trashumancia.dta,clear
keep Codigo_Municipio Presencia_FARC_2011 Presencia_ELN_2011 Presencia_FARC_2010 Presencia_ELN_2010 Presencia_Guerrilla_2007

foreach year in 2010 2011{
recode Presencia_FARC_`year' (2=0)
recode Presencia_ELN_`year' (2=0)
gen Presencia_Guerrilla_`year'=cond(Presencia_FARC_`year'==1|Presencia_ELN_`year'==1,1,0)
}

drop Presencia_FARC_2011 Presencia_ELN_2011 Presencia_FARC_2010 Presencia_ELN_2010

reshape long Presencia_Guerrilla_, i(Codigo_Municipio) j(year)
rename Presencia_Guerrilla_ guerrillas
destring Codigo_Municipio,gen(muni_code) 
drop Codigo_Municipio
label var guerrillas "FARC or ELN presence CERAC"
sort muni_code year

save aux_c.dta,replace

use controls.dta,clear
merge 1:1 muni_code year using aux_c.dta
drop _merge

save controls.dta,replace


*Paramilitaries' presence
use trashumancia.dta,clear
keep Codigo_Municipio Presencia_neoparas_2011 Presencia_neoparas_2010 Presencia_Paras_2007

foreach year in 2010 2011{
recode Presencia_neoparas_`year' (2=0)
rename Presencia_neoparas_`year' Presencia_Paras_`year'
}

reshape long Presencia_Paras_, i(Codigo_Municipio) j(year)
rename Presencia_Paras_ paras
destring Codigo_Municipio,gen(muni_code) 
drop Codigo_Municipio
label var paras "Paras or Neoparas presence CERAC" 
sort muni_code year

save aux_c.dta,replace
use controls.dta,clear
merge 1:1 muni_code year using aux_c.dta
drop _merge

save controls.dta,replace


*Coca production 
use trashumancia.dta,clear
keep Codigo_Municipio Nombre_dpt Nombre_mpi COCACENSO2001 COCACENSO2002 COCACENSO2003 COCACENSO2004 COCACENSO2005 COCACENSO2006 COCACENSO2008 ///
 COCACENSO2007 COCACENSO2009 COCACENSO2010

reshape long COCACENSO, i(Codigo_Municipio) j(year) 
rename COCACENSO coca
rename Nombre_mpi municipio
rename Nombre_dpt departamento
destring Codigo_Municipio,gen(muni_code) 
drop Codigo_Municipio
label var coca "Area of coca fields (hectareas) UNODC (SIMCI)"

sort muni_code year
save aux_c.dta, replace

use controls.dta,clear
merge 1:1 muni_code year using aux_c.dta
drop _merge

*Fiscal data, municipality level
merge 1:1 muni_code year using ejecuciones_panel.dta
drop _merge

gen royalties_p=royalties/(ingresos_totales*1000000)
label var royalties_p "royalties % of total revenue DNP"

gen royalties2_p=royalties2/ingresos_totales
label var royalties2_p "royalties 2% of total revenue DNP"

gen tax_revenue_p=tax_revenue/ingresos_totales
label var tax_revenue_p "Tax revenues as % of Total Revenue"

save controls.dta,replace


*Population
use population_dane.dta,clear
reshape long population, i(muni_code) j(year) 
label var population "Total population DANE"
sort muni_code year
save aux_c.dta,replace

use controls.dta,clear
merge 1:1 muni_code year using aux_c.dta
drop if _merge==2
sort muni_code year
drop _merge
save controls.dta,replace

*Merging with /unsatisfied Basic Needs Index (NBI)
use nbi1993.dta,clear

replace year=1994
append using nbi2005.dta
sort muni_code year
save aux_c.dta,replace

use controls.dta,clear
merge 1:1 muni_code year using aux_c.dta
drop if _merge==2
sort muni_code year
drop _merge
label var nbi "Percentage of population living with unsatisfied basic needs DANE"

*Generating interpolated NBI
sort muni_code year
bysort muni_code: ipolate nbi year, gen(nbi_i) epolate
replace nbi_i=0 if nbi_i<0
replace nbi_i=100 if nbi_i>100 
label var nbi_i "linearly interpolated nbi"
drop nombremunicipio municipios

*Department code
gen depto_code=int(muni_code/1000)

*Merging with price deflator (IPC)
sort year
merge m:1 year using ipc.dta
drop _merge

*Deflating royalties
gen royalties2_d= royalties2/ipc
label var royalties2_d "Royalties (million of pesos of 2008)"

gen royalties2_d_pc=royalties2_d/population*1000000
label var royalties2_d_pc "Royalties (pesos of 2008) per capita"

save controls.dta,replace

*Merging with polling station data
merge 1:1 muni_code year using panel_divipol_cit_reports.dta


drop _merge

save controls.dta,replace


*Merging with electoral results variables 
merge 1:1 muni_code year using elec_citizen_report.dta
*merge 1:1 muni_code year using elec.dta

drop if _merge==2
drop _merge

label var e_parties "effective number of parties major/president"
label var e_parties_av "effective number of parties all local/president"


*Other variables that could serve as controls

gen local_e=cond(year==2007|year==2003|year==2011|year==2000|year==1997|year==1994|year==1992|year==1990,1,0)
label var local_e "Year of local elections"
replace local_e=. if (year!=2011&year!=2010&year!=2007&year!=2006&year!=2003&year!=2002&year!=2000&year!=1998&year!=1997&year!=1994)

foreach var in e_parties e_parties_av{
gen local_`var'=`var'*local_e
}

gen nbi_i_sq=nbi_i^2
label var nbi_i_sq "NBI square"

save controls.dta,replace


*Violence controls
merge 1:1 muni_code year using violence_93_07.dta
drop if _merge==2

replace paras=paras_2 if paras==.
replace guerrillas=guerrillas_2 if guerrillas==.
drop _merge
save controls.dta,replace


*Adding municipality area variables
import excel "Area_municipal_DANE2005.xls", sheet("export_area") firstrow clear
label var area_ur "Urban municipalty area km2 DANE"
label var area_ru "Rural municipality area km2 DANE"
label var area_tot "Total municipality area km2 DANE"
label var share_area_ur "Urban area/total area DANE"
label var Share_area_rur "Rural area/total area DANE"

sort muni_code year
save aux_c.dta,replace

use controls.dta,clear
merge 1:1 muni_code year using aux_c.dta
drop if _merge==2
*Here I dropped Belen de Bajira (Have no info for that municipality on other variables)
drop _merge

bysort muni_code: egen area=max(area_tot)
gen coca_area=coca/area
label var coca_area "Area cultivada de coca/area total municipio *100"


*Generating logs of variables
foreach var in royalties2_d_pc royalties2_p population pot_mesa_med pot_mesa_mean pot_mesa_min{
replace royalties2_p=0.0000001 if royalties2_p==0
replace royalties2_d_pc=0.0000001 if royalties2_d_pc==0
gen l`var'=log(`var')
label var l`var' "log of `var'"
}

*Generating voters/mesa
gen lvoter_mesa=log((total_votes+total_blancos_nulos)/mesas)
gen voter_mesa=exp(lvoter_mesa)
replace voter_mesa=. if voter_mesa>1000
replace lvoter_mesa=. if voter_mesa>1000

label var voter_mesa "Number of votes/Number of polling stations"
label var lvoter_mesa "log of voter_mesa"
label var depto_code "Department code"
label var ipc "Price index" 
label var local_e_parties "Interaction local elections and effective number of parties in major and president elections" 
label var local_e_parties_av "Interaction local elections and effective number of parties in local and president elections" 

gen armed_actor=cond(guerrillas==1|paras==1,1,0)
label var armed_actor "Either guerrillas or paras operate in municipality" 

gen reform=cond(year>=2006,1,0)

*Creating auxiliary variable for rural area
bysort muni_code: egen share_rur=max(Share_area_rur)
label var share_rur "Share of rural area in 2005" 

save controls.dta,replace

*Merging with adult population
merge 1:1 muni_code year using populat_20.dta
drop if _merge==2
drop _merge

gen pob_mesa=Population20/mesas
gen lpob_mesa=log(pob_mesa)
label var pob_mesa "Population of voting age/Mesas"
label var lpob_mesa "log of pob_mesa"


*Creating alternative size measure only with population variables
bysort year depto_code: egen depto_populat20=sum(Population20) 
bysort year: egen nal_populat20=sum(Population20) 
gen gen_populat20=(depto_populat20+nal_populat20)/2
gen loc_populat20=(depto_populat20+Population20)/2
gen size2=loc_populat20
replace size2=gen_populat20 if (year==2010|year==2006|year==2002|year==1998)
gen lsize2=log(size2)


save controls.dta,replace

*Merging with second margin index and weighted_size
merge 1:1 muni_code year using margin2.dta
drop if _merge==2
drop _merge


*Creating auxiliary effective number of parties and electorate size variables
gen le_parties=log(e_parties)
gen le_parties_av=log(e_parties_av)
gen llocal_e_parties=log(e_parties)*local_e
gen lweighted_size=log(weighted_size)
gen lsize=log(size)


*Merging with closeness
merge 1:1 muni_code year using Alcalde_parties.dta
drop if _merge==2
drop _merge


merge 1:1 muni_code year using totales.dta
drop if _merge==2
drop _merge



*Creating variables used in regression

tsset muni_code year, yearly

gen lnbi_i=log(nbi_i)
gen l4margin_index2=l4.margin_index2
gen llnbi_i=l.lnbi_i
gen lown_resources=l.own_resources
gen larmed_actor=l.armed_actor
gen l4lweighted_size=l4.lweighted_size
gen lcoca_area=l.coca_area
gen l4lsize=l4.lsize
gen l4lpob_mesa=l4.lpob_mesa

gen pob_mesa_q=0
replace pob_mesa_q=1 if l4lpob_mesa>=5.586687
replace pob_mesa_q=2 if l4lpob_mesa>=5.734318
replace pob_mesa_q=3 if l4lpob_mesa>=5.875143

gen size_q=0
replace size_q=1 if l4lsize>=21.38042

label define sizeq 0 "Small Electorate" 1 "Large Electorate"
label define pobmesaq 0 "Below q25" 1 "q25-q50" 2 "q50-q75" 3 "Above q75"
*label define armed 0 "No Armed Group Presence" 1 "Armed Group Presence"

label values pob_mesa_q  pobmesaq
label values size_q  sizeq 
label values larmed_actor armed   

***Creating RD variables***

*Creating auxiliary variables
gen m_pob_mesa=potencial/mesas
label var m_pob_mesa "Average registered per polling place"
gen z_pob_mesa=potencial/(floor((potencial-1)/400)+1)
gen z_pob_mesa2=potencial/(floor((potencial-1)/500)+1)
gen z_pob_mesa_f=z_pob_mesa
replace z_pob_mesa_f=z_pob_mesa2 if year==2010
gen z_pob_mesa3=potencial/(floor((potencial-1)/350)+1)
replace z_pob_mesa_f=z_pob_mesa3 if year==2011


label var z_pob_mesa "Legal rule polling place size"
gen lm_pob_mesa=log(m_pob_mesa)
gen lz_pob_mesa_f=log(z_pob_mesa_f)
gen lpotencial=log(potencial)
gen potencial_cu=potencial^3
gen potencial_sq=potencial^2
gen lpotencial_sq=lpotencial^2

*Defining sample of discontinuity
gen discont=0
gen discont2=0
gen discont3=0
gen trend=potencial
gen trend2=potencial
gen trend3=potencial

local y1=400
local y2=0

local y12=500
local y22=0

local y13=350
local y23=0

set more off
forvalues c = 400(400)4904400 {

	*Creating interval of dicontinuity
	local i = `c'/400+1
	
	local u = `c' + 50
	local d = `c' - 50
	replace discont=1 if potencial>=`d'&potencial<=`u'
	
	*Creating trend	
 	local y2 = `y1'+1/`i'
	replace trend=`y2'-(`c'+1)*1/`i'+potencial*1/`i' if potencial>=(`c'+1)&potencial<=(`c'+400)
	local y1 = `y2'+1/`i'*399
}
set more off
forvalues c = 500(500)4904500 {

	*Creating interval of discontinuity
	local i = `c'/500+1
	
	local u = `c' + 50
	local d = `c' - 50
	replace discont2=1 if potencial>=`d'&potencial<=`u'
	
	*Creating trend	
 	local y22= `y12'+1/`i'
	replace trend2=`y22'-(`c'+1)*1/`i'+potencial*1/`i' if potencial>=(`c'+1)&potencial<=(`c'+500)
	local y12 = `y22'+1/`i'*499
}


set more off
forvalues c = 350(350)4904350 {

	*Creating interval of dicontinuity
	local i = `c'/350+1
	
	local u = `c' + 50
	local d = `c' - 50
	replace discont3=1 if potencial>=`d'&potencial<=`u'
	
	*Creating trend	
 	local y23= `y13'+1/`i'
	replace trend3=`y23'-(`c'+1)*1/`i'+potencial*1/`i' if potencial>=(`c'+1)&potencial<=(`c'+350)
	local y13 = `y23'+1/`i'*349
}

gen trend_f=trend
replace trend_f=trend2 if year==2010
replace trend_f=trend3 if year==2011

gen discont_f=discont
replace discont_f=discont2 if year==2010
replace discont_f=discont3 if year==2011

save controls.dta,replace

*Comparing database with database on file
*cf _all using "C:\Users\mrueda\Documents\Rochester\Clientelism\Data\Colombia\Controles\controls.dta", all v

*Cleaning intermediate files
erase aux_c.dta
erase populat_20.dta
