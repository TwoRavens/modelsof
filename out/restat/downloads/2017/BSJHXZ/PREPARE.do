/*******************************************************************************
SOCIAL TIES IN ACADEMIA: A FRIEND IS A TREASURE
by Tommaso Colussi
do file: Data preparation
*******************************************************************************/
cd ${Dir}
do MASTER.do
set more off

********************************************************************************
* 1) Identify keywords and jel codes of all editors' publications
/*		a)consider just publications within 10 years before the first spell
		b)extract all keywords and jel codes into separate variables
		c)EDITORS_KEYS.dta contains for each editor the list of keywords and
		jel codes of their publications
*******************************************************************************/

use "${DirALL}EDITORS.dta",clear
*a)
drop if first_year-year>10
drop if year-first_year>=1

*b)
sort name year
by name: gen yy=_n
sum yy
global m_year=r(max)
forvalues i=1(1)$m_year{
gen key_edit_`i'=keywords if yy==`i'
gen jel_edit_`i'=JEL if yy==`i'
}
forvalues i=1(1)$m_year{
gsort name -key_edit_`i' 
bys name: carryforward  key_edit_`i' ,replace
gsort name -jel_edit_`i' 
bys name: carryforward  jel_edit_`i' ,replace
}

bys name: keep if _n==1

bys name :  gen jel_10y = jel_edit_1 
forvalues i=2(1)$m_year{
bys name:  replace  jel_10y= jel_10y + ";" + jel_edit_`i' if jel_edit_`i'!=""
}

bys name :  gen key_10y = key_edit_1 
forvalues i=2(1)$m_year{
bys name:  replace  key_10y= key_10y + ";" + key_edit_`i' if key_edit_`i'!=""
}
keep key_10y jel_10y name famname

bys name: keep if _n==1
foreach var of varlist key_10y jel_10y {
split `var' , p(";")
drop `var'
}
forvalues i=1(1)107{
label var jel_10y`i' "3-digit JEL code nr. `i'"
}

forvalues i=1(1)112{
label var key_10y`i' "Keyword nr. `i'"
}
*c)
save "${DirALL}EDITORS_KEYS.dta",replace

********************************************************************************
* 2) Define Social Ties
/*		a)merge authors' data (expanded by n_editors) with editors' data
		b)define social ties: Same PhD, PhD Advisor, Same Faculty, Co-authors
		c)CONNECTIONS.dta contains dummy variables for ties between each author 
		and editor
		d) merge information on articles with data on author-editor connections
		e) define article connected if at least one author is connected to at 
		least one editor.
		f) merge info on editors' fields and define "same field" ties
		g) FINAL_SAMPLE contains information on articles and ties with editors
*******************************************************************************/
use "${DirALL}AUTHORS.dta",clear
*a)
global max_edit=42 /*42=N of editors*/
expand ${max_edit}
bys author year: g name=_n
merge m:1 name year using "${DirALL}EDITORS.dta"
drop if _m==1 /*drop non-matching years*/

*b)
*Same PhD
bys author name: g conn_phd= (phd_a==phd & (phdyear_a-phdyear<4 & phdyear_a-phdyear>-4) & phdyear!=.) 

*PhD Advisor
bys author name year: g dd= (phd_a==faculty & facultyposition!="PHD" & facultyposition_a=="PHD" & (jel1_a==jel1 | jel2_a==jel1 | jel2_a==jel2 | jel1_a==jel2 ) & year<first_year) 
bys author name: egen conn_advisor=max(dd) 
drop dd

*Same Faculty  
bys author name year: g dd= (faculty_a==faculty & facultyposition!="PHD" & facultyposition_a!="PHD" & year<first_year) 
bys author name: egen conn_ever=max(dd) 
drop dd

*Co-author
bys author name year: g dd=0
forvalues i=1(1)33{
bys author name year: replace dd=1 if (author==nameco_`i' & nameco_`i'!=. & year<first_year)	
}
bys author name: egen conn_author=max(dd) 
drop dd

*c)
collapse (max) conn_* , by(author  name year) 
label var conn_author "co-authorship tie"
label var conn_ever "same faculty tie"
label var conn_advisor "phd advisor tie"
label var conn_phd "same phd tie"
label var year "year"
label var author "author"
label var name "editor's id"
save "${DirALL}CONNECTIONS.dta",replace

*d)
use "${DirALL}ARTICLES.dta",clear
merge m:1 author name year using "${DirALL}CONNECTIONS.dta"
/* _m=2 not in the sample; _m==1, not connected*/
drop if  _merge==2 
foreach x of varlist conn_*{
replace `x'=0 if _merge==1 & `x'==.
}


drop _merge 
g conn_pool=(conn_auth==1 | conn_phd==1| conn_ever==1 | conn_advisor==1)
label var conn_pool "pooled tie" /*pooled tie*/

*e)
foreach x of varlist conn_*{
bys name articletitle: egen T`x'=max(`x')
}
label var Tconn_author " co-authorship tie (max) "
label var Tconn_ever "same faculty tie (max)"
label var Tconn_advisor "phd advisor tie (max)"
label var Tconn_phd "same phd tie (max)"
label var Tconn_pool "pooled tie (max)"

bys name articletitle: keep if _n==1
drop author conn_phd conn_advisor conn_ever conn_author conn_pool


*f)
forvalues i=1(1)7{
rename jelcode`i' article_jel`i' 
}
merge m:1 name using "${DirALL}EDITORS_KEYS.dta", keepusing(famname key_10y* jel_10y*)
drop _merge

cap drop tie_jel
gen tie_jel=0
forvalues k=1(1)107{
forvalues i=1(1)7{
qui bys articletitle name: replace tie_jel=1 if (article_jel`i'==jel_10y`k' & article_jel`i'!="" & jel_10y`k'!="")
}
}
drop jel_10y*

cap drop tie_key
gen tie_key=0
split keywords, p(";")
forvalues k=1(1)112{
forvalues i=1(1)10{
qui bys articletitle name: replace tie_key=1 if (keywords`i'==key_10y`k' & keywords`i'!="" & key_10y`k'!="")
}
}
drop key_10y*
gen key_jel=(tie_key==1 & tie_jel==1)
drop tie_key tie_jel
gen refedit=0
levelsof famname, local(mymakes)
foreach ma of local mymakes{
qui bys articletitle name: replace refedit=1 if strpos(references,"ma") & famname=="`ma'"
}
sum refedit
gen key_jel_ref=(key_jel==1 & refedit==1)
label var key_jel_ref "same field tie"
label var refedit "editor cited=1"

*g)
drop keywords1-keywords10 key_jel
order name famname year term incharge journal issue articletitle first last citation8 article_jel1- article_jel7 keywords references n_references n_authors Tconn_phd Tconn_advisor Tconn_ever Tconn_author Tconn_pool key_jel_ref
save "${DirALL}FINAL_SAMPLE.dta",replace

********************************************************************************
* 3) Prepare sample for regressions
/*		a)define outcomes for each editor and type fo social tie:
		number of connected articles, pages,
		and lead articles
		b) TOREG.dta provides information for each editor on the publication
		outcomes of his/her connections
*******************************************************************************/

use "${DirALL}FINAL_SAMPLE.dta",clear
*b)
*number of connected papers
foreach x of varlist Tconn_* key_jel_ref{
bys name journal year term: egen n_`x'=sum(`x')
replace n_`x'=0 if n_`x'==.
}
*number of connected pages
g n_page=last_page-first_page
foreach x of varlist Tconn_* key_jel_ref{
bys name journal year term: egen page_`x'=sum(n_page) if `x'==1
replace page_`x'=0 if page_`x'==.
}
**number of lead connected articles
bys year journal issue: egen min_page=min(first_page)
bys articletitle: gen lead=(first_page==min_page & min_page!=.)
foreach x of varlist Tconn_* key_jel_ref{
bys name journal year term: egen lead_`x'=sum(lead) if `x'==1
replace lead_`x'=0 if lead_`x'==.
}

collapse (max) n_* lead_* page* incharge , by(name journal year term)

*d) 
egen issue_fe=group(journal year term)
egen namejournal_fe=group(name journal)
label var issue_fe "journal*issue fixed effects"
label var namejournal_fe "editor*journal fixed effects"
label var n_Tconn_phd "nr. articles of same phd ties "
label var n_Tconn_advisor "nr. articles of phd advisor ties "
label var n_Tconn_ever "nr. articles of same faculty ties "
label var n_Tconn_author "nr. articles of co-author ties "
label var n_Tconn_pool "nr. articles of phd advisor ties "
label var n_key_jel_ref "nr. articles in same field "
label var lead_Tconn_phd "nr. lead of same phd ties "
label var lead_Tconn_ad~r "nr. lead of phd advisor ties "
label var lead_Tconn_ever "nr. lead of same faculty ties "
label var lead_Tconn_au~r "nr. lead of co-author ties "
label var lead_Tconn_pool "nr. lead of phd advisor ties "
label var lead_key_jel_~f "nr. lead in same field "
label var page_Tconn_phd "nr. pages of same phd ties "
label var page_Tconn_ad~r "nr. pages of phd advisor ties "
label var page_Tconn_ever "nr. pages of same faculty ties "
label var page_Tconn_au~r "nr. pages of co-author ties "
label var page_Tconn_pool "nr. pages of phd advisor ties "
label var page_key_jel_~f "nr. pages in same field "

drop n_page n_authors n_references
order name year term journal incharge
save "${DirALL}TOREG.dta",replace
