/*--------------------------------------------------------------

REITs checks: Fourmi immobiliere, USA REITs in one file
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Run individual files =============================================

do "${rore}/src/do_files/analysis/accuracy/fourmi_immobiliere.do"
do "${rore}/src/do_files/analysis/accuracy/usa_REITs.do"

*======================= Combine graphs =============================================

* Paper
graph combine fourmi_filter_title usa_reit_filter_title, cols(2) xsize(8) iscale(*1.1) scheme(s1color)

graph export "${rore}/bld/graphs/accuracy/reits.pdf", replace
graph export "${qje_figures}/Figure_06.pdf", replace
graph close
* Presentation: US on the left
graph combine usa_reit_filter_title fourmi_filter_title, cols(2) xsize(8) iscale(*1.1) scheme(s1color)

graph export "${rore}/bld/graphs/accuracy/reits_pres.pdf", replace
graph close
