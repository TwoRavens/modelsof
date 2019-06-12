clear
clear matrix
clear mata
set more off, perm
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/
global output /Users/zachbrown/Projects/PriceTransparency/Output/reduced_form

insheet using "web_traffic/traffic_log.csv"

drop v1

// Clean date
gen type=""
gen year = floor(month/100)
replace month =month-round(month,100)
gen ym = ym(year, month)
format ym %tm 
order ym month year type

// Clean requests
label var reqs "Requests"
destring reqs, replace force
drop if reqs==.
gsort ym -reqs

// Keep only requests related to insured wizard
keep if strpos(file,"wizard")>0 
drop if strpos(file,"uninsuredwizard")>0
format file %100s

// Keep only hits after people submit wizard
keep if strpos(file,"procedure")>0

// Find procedure name
gen proc_name = substr(file,strpos(file,"procedureName")+14,length(file)) if strpos(file,"procedureName")>0
tab proc_name, miss

// Classifcation
gen proc_class = ""
replace proc_class = "X-Ray" if strpos(file,"X-Ray")>0
replace proc_class = "MRI" if strpos(file,"MRI")>0
replace proc_class = "CT" if strpos(file,"CT")>0
replace proc_class = "Ultrasound" if strpos(file,"Ultrasound")>0
replace proc_class = "Bone Density" if strpos(file,"Bone")>0
replace proc_class = "Emergency Visit" if strpos(file,"Emergency")>0
replace proc_class = "Vaginal Birth" if strpos(file,"Vaginal")>0
replace proc_class = "Preventive Medicine" if strpos(file,"Prevent")>0
replace proc_class = "Office Visit" if strpos(file,"Office")>0
replace proc_class = "Mammogram" if strpos(file,"Mammogram")>0
replace proc_class = "Tonsillectomy" if strpos(file,"Tonsillectomy")>0
replace proc_class = "Kidney" if strpos(file,"Kidney")>0
replace proc_class = "Gall Bladder Surgery" if strpos(file,"Gall")>0
replace proc_class = "Colonoscopy" if strpos(file,"Colonoscopy")>0
replace proc_class = "Hernia" if strpos(file,"Hernia")>0
replace proc_class = "Myocardial Imaging" if strpos(file,"Myocardial")>0
replace proc_class = "Arthrocentesis" if strpos(file,"Arthrocentesis")>0
replace proc_class = "Breast Biopsy" if strpos(file,"Breast")>0
replace proc_class = "Arthroscopic Knee Surgery" if strpos(file,"Arthroscopic")>0
replace proc_class = "Destruction of Lesion" if strpos(file,"Destruction")>0


// Manual Fixes
replace proc_class = "X-Ray" if strpos(file,"Ankle")>0
replace proc_class = "X-Ray" if strpos(file,"Chest")>0
replace proc_class = "X-Ray" if strpos(file,"Foot")>0
replace proc_class = "X-Ray" if strpos(file,"Knee")>0
replace proc_class = "X-Ray" if strpos(file,"Shoulder")>0
replace proc_class = "X-Ray" if strpos(file,"Spine")>0
replace proc_class = "X-Ray" if strpos(file,"Wrist")>0
replace proc_class = "MRI" if strpos(file,"MRI")>0
replace proc_class = "CT" if strpos(file,"CT")>0

gen is_radiology_subset = 1
replace is_radiology_subset = 0 if ~inlist(proc_class,"X-Ray","MRI","CT")

gen reqs_radio_subset = reqs/1000 if is_radiology_subset==1

gen reqs_xray = reqs/1000 if proc_class=="X-Ray"
gen reqs_mri = reqs/1000 if proc_class=="MRI"
gen reqs_ct = reqs/1000 if proc_class=="CT"

replace reqs = reqs/1000

collapse (sum) reqs reqs_radio_subset reqs_xray reqs_mri reqs_ct, by(ym month year)


replace ym = ym-1

label var reqs "All Website Procedures"
label var reqs_radio_subset "Website Medical Imaging Procedures"
twoway (line reqs  ym, lwidth(thin) lp(dash) lcolor(black)) ///
	(line reqs_radio_subset  ym, lwidth(thin) lcolor(black)) ///
	, legend(region(lcolor(white))) tlabel(540(12)612, format(%tmCCYY) tposition(inside)) ///
	ylabel(0(1)7, tposition(inside) angle(horizontal))  ///
	scheme(s1mono) ytitle("Monthly Price Requests (thousands)") xtitle("Month") ///
	graphregion(margin(r+5 l-2)) plotregion(margin(r+2 l+2))
graph export $output/web_traffic.pdf, replace 
