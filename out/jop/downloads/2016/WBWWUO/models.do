cd "/Users/kenwick2/Dropbox/jop_response"

use jl_modified.dta, clear

set more off
version 10
logit dispute fbdef nfbdef pchaloff ///
 	pchalneu ln_distance capprop jdem s_un_glo ///
	peaceyrs peaceyrs2 peaceyrs3 ///
	, robust cluster(ddyad)
logit dispute fbdef nfbdef pchaloff ///
 	pchalneu ln_distance capprop jdem s_un_glo ///
	peaceyrs peaceyrs2 peaceyrs3 ///
	if year<1946, robust cluster(ddyad)
logit dispute fbdef nfbdef pchaloff ///
 	pchalneu ln_distance capprop jdem s_un_glo ///
	peaceyrs peaceyrs2 peaceyrs3 ///
	if year>1945, robust cluster(ddyad)
	

logit dispute def_form_5yr def_form_6to15 def_form_16plus fbdef pchaloff ///
 	pchalneu ln_distance capprop jdem s_un_glo ///
	peaceyrs peaceyrs2 peaceyrs3 ///
	, robust cluster(ddyad)
logit dispute def_form_5yr def_form_6to15 def_form_16plus fbdef pchaloff ///
 	pchalneu ln_distance capprop jdem s_un_glo ///
	peaceyrs peaceyrs2 peaceyrs3 ///
	if year<1946, robust cluster(ddyad)
logit dispute def_form_5yr def_form_6to15 def_form_16plus fbdef pchaloff ///
 	pchalneu ln_distance capprop jdem s_un_glo ///
	peaceyrs peaceyrs2 peaceyrs3 ///
	if year>1945, robust cluster(ddyad)
