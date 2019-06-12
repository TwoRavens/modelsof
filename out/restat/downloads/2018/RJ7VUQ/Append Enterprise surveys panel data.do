version 8.2
capture clear
capture log close
set more off
set mem 1000m
set mat 800


global list_var serialid countryname year h7a n2* d2 l1 d1a2


use "Enterprise surveys_Panel data/Afghanistan_2008_2010_2014_panel.dta"
drop serialid
ren panelid serialid
tostring serialid, replace force
gen countryname="Afghanistan"
keep $list_var
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Afghanistan_2003_2009_panel.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Afghanistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace


use "Enterprise surveys_Panel data/Albania_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Albania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Albania--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Albania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Angola_2006_2010_panel.dta"
ren id_panel serialid
tostring serialid, replace force
gen countryname="Angola"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Argentina_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Argentina"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Armenia_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Armenia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Armenia--panel data-.dta"
ren  panelid serialid
tostring serialid, replace force
gen countryname="Armenia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Azerbaijan_2009_2013_Panel.dta"
ren   idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Azerbaijan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Azerbaijan--panel data-.dta"
ren  panelid serialid
tostring serialid, replace force
gen countryname="Azerbaijan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bangladesh_2007_2011_2013_panel.dta"
ren  panelid serialid
tostring serialid, replace force
gen countryname="Bangladesh"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

/*This is the same data as before
use "Enterprise surveys_Panel data/Bangladesh_2007_2011_panel.dta"
ren sl serialid
tostring serialid, replace force
gen countryname="Bangladesh"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace
*/

use "Enterprise surveys_Panel data/Belarus_2008_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Belarus"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Belarus--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Belarus"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bhutan_2009-2015_Panel.dta"
ren id2015 serialid
tostring serialid, replace force
gen countryname="Bhutan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bolivia_2006_2010_Panel.dta"
ren  idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Bolivia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bih_2009_2013_Panel.dta"
ren   idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Bosnia and Herzegovina"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bosnia and Herzegovina--panel data-.dta"
ren  panelid serialid
tostring serialid, replace force
gen countryname="Bosnia and Herzegovina"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Botswana_2006_2010_panel.dta"
ren  id_panel serialid
tostring serialid, replace force
gen countryname="Botswana"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Brazil_2003_2009_panel.dta"
ren  id2003 serialid
tostring serialid, replace force
gen countryname="Brazil"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bulgaria_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Bulgaria"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Bulgaria--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Bulgaria"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Burkina Faso-2006-2009-panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Burkina Faso"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Cape Verde-2006-2009-panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Cabo Verde"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

/*
use "Enterprise surveys_Panel data/Cambodia_2013_2016.dta"
*note:
codebook _2013_h7a _2016_h7a j6
***questions were not asked similarly, so cannot use them...
gen h7a=_2016_h7a if year==2016
replace h7a=_2013_h7a if year==2013
ren idstd2016 serialid
tostring serialid, replace force
gen countryname="Cambodia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace
*/


use "Enterprise surveys_Panel data/Cameroon-2006-2009-panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Cameroon"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Chile_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Chile"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Colombia_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Colombia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/DRC_2010_2013_Panel.dta"
ren idPANEL2010 serialid
tostring serialid, replace force
gen countryname="Congo, Dem. Rep."
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/DRC_2006_2010_panel.dta"
ren id_panel serialid
tostring serialid, replace force
gen countryname="Congo, Dem. Rep."
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Croatia_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Croatia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Croatia--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Croatia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Czech_2009_2013_Panel.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Czech Republic"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Czech Republic--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Czech Republic"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Ecuador_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Ecuador"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Egypt 2007-2013.dta"
ren idstd2008 serialid
tostring serialid, replace force
gen countryname="Egypt, Arab Rep."
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

/*
use "Enterprise surveys_Panel data/Egypt, Arab Rep._2004_2007_panel.dta"
***no data on h7a
ren unitid serialid
tostring serialid, replace force
gen countryname="Egypt, Arab Rep."
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace
*/

use "Enterprise surveys_Panel data/ElSalvador_2006_2010_2016.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="El Salvador"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

/*same data as ElSalvador_2006_2010_2016
use "Enterprise surveys_Panel data/El_Salvador_2006_2010_Panel.dta"
ren  idPANEL2006 serialid
tostring serialid, replace force
gen countryname="El Salvador"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace
*/

/*There is no data for 2003!
use "Enterprise surveys_Panel data/El Salvador--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="El Salvador"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace
*/

use "Enterprise surveys_Panel data/Estonia_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Estonia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Estonia--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Estonia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace


use "Enterprise surveys_Panel data/Ethiopia_2011_2015.dta"
ren  idstd2015 serialid
tostring serialid, replace force
gen countryname="Ethiopia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Georgia_2008_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Georgia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace


use "Enterprise surveys_Panel data/Georgia--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Georgia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Ghana_2007_2013_Panel.dta"
ren  idPANEL2007 serialid
tostring serialid, replace force
gen countryname="Ghana"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Guatemala_2006_2010_Panel.dta"
ren  idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Guatemala"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Guatemala--panel data-.dta"
ren  idstd_2003 serialid
tostring serialid, replace force
gen countryname="Guatemala"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace


use "Enterprise surveys_Panel data/Honduras_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Honduras"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Honduras--panel data-.dta"
ren idstd_2003 serialid
tostring serialid, replace force
gen countryname="Honduras"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Hungary_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Hungary"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Hungary--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Hungary"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Indonesia_2009_2015.dta"
ren idstd2015 serialid
tostring serialid, replace force
gen countryname="Indonesia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Kazakhstan_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Kazakhstan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Kazakhstan--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Kazakhstan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Kenya_2007_2013_Panel.dta"
ren  idPANEL2007 serialid
tostring serialid, replace force
tab panel year
gen countryname="Kenya"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Kosovo_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Kosovo"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Kyrgyzstan_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Kyrgyz Republic"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Kyrgyz Republic--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Kyrgyz Republic"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/LaoPDR_2009_2012_2016.dta"
ren  idstd2016 serialid
tostring serialid, replace force
gen countryname="Lao PDR"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Latvia_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Latvia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Latvia--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Latvia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Lesotho_2009_2016.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Lesotho"
ren _2016_d1a2 d1a2
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Lithuania_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Lithuania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Lithuania--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Lithuania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Macedonia_2009_2013_Panel.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Macedonia, FYR"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Macedonia, FYR--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Macedonia, FYR"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Malawi_2009_2014.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Malawi"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Malawi-2005-2009-panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Malawi"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Mali_2007_2010_panel.dta"
ren id_panel serialid
tostring serialid, replace force
gen countryname="Mali"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Mali_2003_2007_panel.dta"
ren  eec_panelid serialid
tostring serialid, replace force
gen countryname="Mali"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Mexico_2006_2010_Panel.dta"
ren  idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Mexico"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Moldova_2009_2013_Panel.dta"
ren  idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Moldova"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Moldova--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Moldova"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Mongolia_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Mongolia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Montenegro_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Montenegro"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Montenegro--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Montenegro"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

/* No data on h7a:
use "Enterprise surveys_Panel data/Morocco_2004_2007_panel.dta"
ren  codeentr serialid
tostring serialid, replace force
gen countryname="Morocco"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace
*/

use "Enterprise surveys_Panel data/Nepal_2009_2013.dta"
ren id2009 serialid
tostring serialid, replace force
gen countryname="Nepal"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Nicaragua_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Nicaragua"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Nicaragua--panel data-.dta"
ren idstd_2003 serialid
tostring serialid, replace force
gen countryname="Nicaragua"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Niger-2005-2009-panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Niger"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Nigeria_2007-2009_2014_v4- FINAL_new.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Nigeria"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Pakistan_2007_2013_Panel v2_new.dta"
ren  idPANEL2007 serialid
tostring serialid, replace force
gen countryname="Pakistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Pakistan2002_2007_panel.dta"
ren  id2002 serialid
tostring serialid, replace force
ren p2a1 n2a
ren p2e1 n2e
ren p2b1 n2b
ren p2c1 n2c
ren p2f1 n2f
ren p2g1 n2g
ren p2h1 n2h
ren p2d1 n2d
gen countryname="Pakistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Panama_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Panama"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Paraguay_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Paraguay"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Peru_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Peru"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Philippines_2009_2015.dta"
ren idstd2015 serialid
tostring serialid, replace force
gen countryname="Philippines"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Poland_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Poland"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Poland--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Poland"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Poland--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Poland"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Romania_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Romania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Romania--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Romania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Russia_2009_2012_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Russian Federation"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Rwanda2006_2011_panelclean.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Rwanda"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Senegal_2007_2014_Panel.dta"
ren idPANEL2007 serialid
tostring serialid, replace force
gen countryname="Senegal"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Senegal_2003_2007_panel.dta"
ren eec_panelid serialid
tostring serialid, replace force
gen countryname="Senegal"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Serbia_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Serbia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Serbia--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Serbia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Slovakia_2009_2013_Panel.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Slovak Republic"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Slovak Republic--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Slovak Republic"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Slovenia_2009_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Slovenia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Slovenia--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Slovenia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/SouthAfrica_2003_2007_panel.dta"
ren eec_panelid serialid
tostring serialid, replace force
gen countryname="South Africa"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Tajikistan_2008_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Tajikistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Tajikistan--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Tajikistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Tanzania_2006_2013_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Tanzania"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Timor-Leste_2009_2015.dta"
ren idstd2015 serialid
tostring serialid, replace force
gen countryname="Timor-Leste"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Turkey_2008_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Turkey"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Turkey2005_2008_panel.dta"
ren interview_no serialid
tostring serialid, replace force
gen countryname="Turkey"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Uganda_2006_2013_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Uganda"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Ukraine_2008_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Ukraine"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Ukraine--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Ukraine"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Uruguay_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Uruguay"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Uzbekistan_2008_2013_Panel.dta"
ren idPANEL2009 serialid
tostring serialid, replace force
gen countryname="Uzbekistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Uzbekistan--panel data-.dta"
ren panelid serialid
tostring serialid, replace force
gen countryname="Uzbekistan"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Venezuela_2006_2010_Panel.dta"
ren idPANEL2006 serialid
tostring serialid, replace force
gen countryname="Venezuela, RB"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Vietnam_2005_2009_2015.dta"
ren idstd2015 serialid
tostring serialid, replace force
gen countryname="Vietnam"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Yemen_2010_2013_Panel.dta"
ren idPANEL2010 serialid
tostring serialid, replace force
gen countryname="Yemen"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Zambia_2007_2013_Panel.dta"
ren idPANEL2007 serialid
tostring serialid, replace force
gen countryname="Zambia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace

use "Enterprise surveys_Panel data/Zambia_2002_2007_panel.dta"
ren zentr_2002 serialid
gen countryname="Zambia"
keep $list_var
append using "panel_data_clean.dta"
save "panel_data_clean.dta", replace


