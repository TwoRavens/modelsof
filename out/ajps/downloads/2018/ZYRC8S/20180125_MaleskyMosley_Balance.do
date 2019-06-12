


use "20171204_AJPS_MaleskyMosely_w_markups.dta", clear
set more off


/*Balance*/
#delimit;
set more off;


#delimit;
reg nr Europe India if export_potential==1, nocons;
outreg2 using "AppendicA_balance", tdec(3) bdec(3) replace;
reg nr  India  if export_potential==1;
outreg2 using "AppendicA_balance", tdec(3) bdec(3) pvalue;
foreach x in  male_CEO age capital hundred MNC MandA g8_3 g1_3 labor profitable losing expand2 exporter customer_SOE customer_gov customer_private customer_foreign 
customer_home customer_export vendor_SOE vendor_private vendor_HH vendor_inhouse vendor_home vendor_import European indian{;
reg `x' Europe India if export_potential==1 & g13!=. & g13 !=.b, nocons;
outreg2 using "AppendicA_balance", tdec(3) bdec(3) noaster;
reg `x'  India  if export_potential==1 & g13!=. & g13 !=.b;
outreg2 using "AppendicA_balance", tdec(3) bdec(3) pvalue;
};

reg nr India, nocons;
outreg2 using "AppendicA_balance", tdec(3) bdec(3) excel;


