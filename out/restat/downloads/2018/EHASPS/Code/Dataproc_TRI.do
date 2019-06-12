* Dataproc_TRI.do
* Processes EPA Toxic Release Inventory basic data files.

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/TRI_proc.log", replace

* Reading and saving individual year files
forval x = 1987/2010 {
	insheet using "`work'/Data/TRI/Raw/TRI_`x'_US.csv", comma names clear
	drop v100 /* one cell with version number for data set */
	
	* Renaming variables where insheet can't do it automatically
	foreach z in "v33-v35 v46-v65 v67-v71 v73-v74 v76-v81 v84 v89-v94 v96-v97" "v85-v88" "v36-v37 v40-v41 v44" "v38-v39 v42-v43" {
		foreach var of varlist `z' {
			if "`z'"== "v33-v35 v46-v65 v67-v71 v73-v74 v76-v81 v84 v89-v94 v96-v97" {
				local len = 5
			}
			else if "`z'"== "v85-v88" {
				local len = 6
			}
			else if "`z'"== "v36-v37 v40-v41 v44" {
				local len = 7
			}
			else if "`z'"== "v38-v39 v42-v43" {
				local len = 8
			}
			local newname: variable label `var'
			local newname = strtoname(substr("`newname'", `len', .), 0)
			rename `var' `newname'
		}
	}
	
	* Fixing SIC variables
	foreach var of varlist primarysic sic2-sic6 primarynaics naics2-naics6 {
		capture replace `var' = "" if index(`var', "INVA")>0 | index(`var', "INVALD")>0
		destring `var', replace
	}
	
	* Fixing zip codes
	capture replace zip = "00" + zip if inlist(length(zip), 3, 7)
	capture replace zip = "0" + zip if inlist(length(zip), 4, 8)
	tostring zip, replace
	
	* Saving output
	save "`work'/Data/TRI/Processed/TRI_`x'_US.dta", replace
}
* Downloaded 2011-2012 files later, slightly different format, so must process separately
forval x = 2011/2014 {
	insheet using "`work'/Data/TRI/Raw/TRI_`x'_US.csv", comma names clear
	
	* Variable handling
	drop v103 /* blank field */
	
	* Renaming variables to match older data
	rename primary_sic primarysic
	rename sic_2 sic2
	rename sic_3 sic3
	rename sic_4 sic4
	rename sic_5 sic5
	rename sic_6 sic6
	rename primary_naics primarynaics
	rename naics_2 naics2
	rename naics_3 naics3
	rename naics_4 naics4
	rename naics_5 naics5
	rename naics_6 naics6
	rename v36 Fugitive_Air
	rename v37 Stack_Air
	rename v38 Water
	rename v39 Underground_Class_I
	rename v40 Underground_Class_II_V
	rename v41 RCRA_C_Landfills
	rename v42 Other_Landfills
	rename v43 Land_Treatment
	rename v44 Surface_Impoundment
	rename v45 RCRA_C_Surface_Impoundment
	rename v46 Other_Surface_Impoundment
	rename v47 Other_Disposal
	rename v49 POTW___Transfers_For_Release
	rename v50 POTW___Transfers_For_Treatment
	rename v51 POTW___Total_Transfers
	rename v52 M10
	rename v53 M41
	rename v54 M62
	rename v55 M71
	rename v56 M81
	rename v57 M82
	rename v58 M72
	rename v59 M63
	rename v60 M66
	rename v61 M67
	rename v62 M64
	rename v63 M65
	rename v64 M73
	rename v65 M79
	rename v66 M90
	rename v67 M94
	rename v68 M99
	rename v70 M20
	rename v71 M24
	rename v72 M26
	rename v73 M28
	rename v74 M93
	rename v76 M56
	rename v77 M92
	rename v79 M40
	rename v80 M50
	rename v81 M54
	rename v82 M61
	rename v83 M69
	rename v84 M95
	rename v87 Releases
	rename v88 On_site_Contained_Releases
	rename v89 On_site_Other_Releases
	rename v90 Off_site_Contained_Releases
	rename v91 Off_site_Other_Releases
	rename v92 Energy_Recovery_On_site
	rename v93 Energy_Recovery_Off_site
	rename v94 Recycling_On_Site
	rename v95 Recycling_Off_Site
	rename v96 Treatment_On_site
	rename v97 Treatement_Off_site /* typo is to match older files */
	rename v99 One_time_Release
	rename v100 Production_Ratio
	rename tri_facility_id trifacilityid
	rename facility_name facilityname
	rename street_address streetaddress
	rename cas_compound_id cascompoundid
	rename clear_air_act_chemical cleanairactchemical
	rename metal_category metalcategory
	rename form_type formtype
	rename unit_of_measure unitofmeasure
	rename onsite_release_total onsitereleasetotal
	rename offsite_release_total offsitereleasetotal
	rename offsite_recycled_total offsiterecycledtotal
	rename offsite_recovery_total offsiterecoverytotal
	rename offsite_treated_total offsitetreatedtotal
	rename total_releases totalreleases
	rename prod_waste_81_thru_87 productionwaste81thru87
	rename parent_company_name parentcompanyname
	rename parent_company_db_number parentcompanydbnumber
	
	* Dropping variables not present in older data
	drop bia_code tribe federal_facility POTW___Transfers_For_Release POTW___Transfers_For_Treatment
	
	* Fixing SIC variables
	foreach var of varlist primarysic sic2-sic6 primarynaics naics2-naics6 {
		capture replace `var' = "" if index(`var', "NA")>0 | index(`var', "INVALD")>0
		destring `var', replace
	}
	
	* Fixing zip codes
	capture replace zip = "00" + zip if inlist(length(zip), 3, 7)
	capture replace zip = "0" + zip if inlist(length(zip), 4, 8)
	tostring zip, replace
	
	* Saving output
	save "`work'/Data/TRI/Processed/TRI_`x'_US.dta", replace
}


* Appending
use "`work'/Data/TRI/Processed/TRI_1987_US.dta", clear
forval x = 1988/2014 {
	display "Appending year `x'"
	append using "`work'/Data/TRI/Processed/TRI_`x'_US.dta"
}
describe

* Dropping facilities in territories (e.g. Puerto Rico, American Samoa)
drop if inlist(st, "AS", "GU", "MP", "PR", "VI")

* Adjusting county values for merge
replace county = "ST LOUIS (CITY)" if county=="SAINT LOUIS (CITY)"
replace county = "MIAMI-DADE" if county=="DADE" & st=="FL"

* Merging county and state fips codes
* Only non-matching records are 1 plant in South Boston, VA
merge m:1 county st using "`work'/Data/FIPS/FIPS.dta", keep(1 3) nogenerate

* Modifying select chemical names for Greenstone merge
replace chemical = "CHROMIUM COMPOUNDS" if chemical=="CHROMIUM COMPOUNDS(EXCEPT CHROMITE ORE MINED IN THE TRANSVAAL REGION)"
replace chemical = "3,3-DIMETHOXYBENZIDINE (DIANISIDINE)" if index(chemical, "3,3'-DIMETHOXYBENZIDINE")>0
replace chemical = "ISOPROPYL ALCOHOL" if chemical=="ISOPROPYL ALCOHOL (MANUFACTURING,STRONG-ACID PROCESS ONLY,NO SUPPLIER)"
replace chemical = "2,4-D, SALTS AND ESTERS" if inlist(chemical, "2,4-D", "2,4-D 2-ETHYL-4-METHYLPENTYL ESTER", "2,4-D 2-ETHYLHEXYL ESTER")
replace chemical = "2,4-D, SALTS AND ESTERS" if inlist(chemical, "2,4-D BUTOXYETHYL ESTER", "2,4-D BUTYL ESTER", "2,4-D ISOPROPYL ESTER")
replace chemical = "2,4-D, SALTS AND ESTERS" if inlist(chemical, "2,4-D PROPYLENE GLYCOL BUTYL ETHER ESTE", "2,4-D SODIUM SALT", "2,4-DB")
replace chemical = "2,4-D, SALTS AND ESTERS" if inlist(chemical, "2,4-DIAMINOANISOLE", "2,4-DIAMINOANISOLE SULFATE", "2,4-DITHIOBIURET", "2,4-DP") 

* Merging Greenstone pollutant classifications
merge m:1 chemical using "`work'/Data/Greenstone/Greenstone.dta", assert(1 3) keep(1 3)
drop _merge

* Renaming class vars
rename TSP PM 
rename Lead Pb

* Changing class vars to match TRI var indicating chemical subject to CAA
replace Other = 0 if cleanairactchemical=="YES" & Other==1 /* Other denotes not subject to CAA in Greenstone paper */
replace VOC = 0 if cleanairactchemical=="NO" & VOC==1
replace Pb = 0 if cleanairactchemical=="NO" & Pb==1
replace PM = 0 if cleanairactchemical=="NO" & PM==1

* Converting grams to pounds
replace unitofmeasure=trim(unitofmeasure)
foreach var in Fugitive_Air Stack_Air Water Underground_Class_I Underground_Class_II_V RCRA_C_Landfills Other_Landfills Land_Treatment Surface_Impoundment ///
	RCRA_C_Surface_Impoundment Other_Surface_Impoundment Other_Disposal onsitereleasetotal POTW___Metals_and_Metal_Compound POTW___Non_Metals ///
	POTW___Total_Transfers M10 M41 M62 M71 M81 M82 M72 M63 M66 M67 M64 M65 M73 M79 M90 M94 M99 offsitereleasetotal M20 M24 M26 M28 M93 offsiterecycledtotal ///
	M56 M92 offsiterecoverytotal M40 M50 M54 M61 M69 M95 offsitetreatedtotal totalreleases Releases On_site_Contained_Releases On_site_Other_Releases ///
	Off_site_Contained_Releases Off_site_Other_Releases Energy_Recovery_On_site Energy_Recovery_Off_site Recycling_On_Site Recycling_Off_Site Treatment_On_site ///
	Treatement_Off_site productionwaste81thru87 One_time_Release {
	replace `var' = `var'*0.00220462 if unitofmeasure=="Grams" /* Conversion factor from Google */
}
replace unitofmeasure="Pounds" if unitofmeasure=="Grams"

* Merging toxicity weights
destring cascompoundid, generate(cas) float force
rename cascompoundid compoundid
replace compoundid = "" if !missing(cas)
replace compoundid = trim(compoundid)
merge m:1 cas using "`work'/Data/Tox_weights/Toxweights_cas.dta", keep(1 3) nogenerate
merge m:1 compoundid using "`work'/Data/Tox_weights/Toxweights_cid.dta", keep(1 3) nogenerate

* Saving
save "`work'/Data/TRI/Processed/TRI.dta", replace


timer off 1
timer list 1
capture log close




