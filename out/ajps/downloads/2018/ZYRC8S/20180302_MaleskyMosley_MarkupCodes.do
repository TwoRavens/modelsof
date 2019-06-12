

/*Create Markup Data and Share Differential*/





/*Alternative Measures of Markups from Economics Literature*/

/*Merge in Comparative Markup Data from

De Loecker, Jan, Goldberg, P.K., Khandelwal, A.K. and Pavcnik, N., 2016. “Prices, Markups, and Trade Reform.” Econometrica, 84(2): 445-510.
Christopoulou, R. and Vermeulen, P., 2012. Markups in the Euro area and the US over the period 1981–2004: a comparison of 50 sectors. Empirical Economics, 42(1), pp.53-77.
Stiebale, J. and Vencappa, D., 2016. Acquisitions, markups, efficiency, and product quality: Evidence from India (No. 229). DICE Discussion Paper.
*/

use "comparative_markup_v13.dta", clear
collapse code  dlc_codes us eu unweighted india delocker, by(sector_plus)

rename us markup_us
label var markup_us "Markup in the United States"

rename eu markup_eu
label var markup_eu "Markup in the EU (Weighted by Country Size)"

rename unweighted markup_eu2
label var markup_eu2 "Markup in the EU (Unweighted by Country Size)"

rename india markup_india
label var markup_india "Markup in India (Stiebale Estimate)"


rename delocker markup_india2
label var markup_india2 "Markup in India (De Loecker Estimate)"

label var code "Stiebale Industry Codes"
label var dlc_codes "Delocker Industry Codes"

sort sector_plus
saveold "comparative_markup2.dta", version(13) replace




/*CODE MARKUPS FROM PCI DATA*/

#delimit;
use "20171204_AJPS_MaleskyMosely.dta", clear;
drop _merge;
sort sector_plus;
merge m:1 sector_plus using "comparative_markup2.dta";


/*Merge in Data from Chinese Customs Dataset at ISIC- 2 Digit Level, Converted from HS-9
< http://china-trade-research.hktdc.com/business-news/article/Facts-and-Figures/China-Customs-Statistics/ff/en/1/1X000000/1X09N9NM.htm>*/

drop _merge;
sort sector_plus;
merge m:1 sector_plus using "Chinese_markups_v13.dta";
lab var ln_delta_markup "Difference in Markups from Chinese Customs Data (ln)";






/*CALCULATE MARKUP FROM PCI DATA*/
/*CALCULATE MARKUP*/
#delimit;
generate sales=sales/10000;
impute sales performance_est performance_2013 performance_2014 expand lsize_2014 construction services agriculture mining finance, gen(sales2);
replace sales=sales2;
drop sales2;
gen markup=ln(sales)-ln(capital);
replace markup=0 if markup<0;

by sector_plus, sort: egen markup_developing=median(markup) if destination_developed==0;
by sector_plus, sort: egen markup_developed=median(markup) if destination_developed==1;
by sector_plus, sort: egen markup_developing_max=max(markup_developing);
by sector_plus, sort: egen markup_developed_max=max(markup_developed);
generate delta_markup=markup_developed_max- markup_developing_max;

#delimit;

label var markup "Markup Malesky and Mosely Estimated from PCI data";
label var delta_markup "Difference between Developed and Developing Country Markups";


by dlc_code, sort: egen markup_developing_dlc=median(markup) if destination_developed==0;
by dlc_code, sort: egen markup_developed_dlc=median(markup) if destination_developed==1;
by dlc_code, sort: egen markup_developing_max_dlc=max(markup_developing_dlc);
by dlc_code, sort: egen markup_developed_max_dlc=max(markup_developed_dlc);
generate delta_markup_dlc=markup_developed_max_dlc- markup_developing_max_dlc;

#delimit;
rename delta_markup PCI_markup;
rename markup PCI_markup_raw;
label var PCI_markup_raw "Markup Malesky and Mosely Estimated from PCI data";
label var delta_markup_dlc "Difference between Developed and Developing Country Markups (Using DLC Codes)";



/*Gen Intermediate Outputs*/
/*Handcode in Data on Share of Intermediate Output Used as Intermediate Good in Another Product by ISIC*/
/*Data from Miroudot, S., Lanz, R. and Ragoussis, A., 2009. “Trade in Intermediate Goods and Services,” OECD Trade Policy Working Paper No. 93, Paris. Table 10*/

gen share_intermediate=.65 if sector_plus=="A";
replace share_intermediate =1 if sector_plus=="B";
replace share_intermediate =.29 if sector_plus=="C10";
replace share_intermediate =.20 if sector_plus=="C13";
replace share_intermediate =.20 if sector_plus=="C14";
replace share_intermediate =.20 if sector_plus=="C15";
replace share_intermediate =.69 if sector_plus=="C16";
replace share_intermediate =.69 if sector_plus=="C17";
replace share_intermediate =.85 if sector_plus=="C20";
replace share_intermediate =.63 if sector_plus=="C22";
replace share_intermediate =.91 if sector_plus=="C24";
replace share_intermediate =.91 if sector_plus=="C25";
replace share_intermediate =.42 if sector_plus=="C26";
replace share_intermediate =.65 if sector_plus=="C27";
replace share_intermediate =.29 if sector_plus=="C28";
replace share_intermediate =.30 if sector_plus=="C29";
replace share_intermediate =.69 if sector_plus=="C31";
replace share_intermediate =.44 if sector_plus=="C32";
replace share_intermediate =1 if sector_plus=="D";
replace share_intermediate =1 if sector_plus=="F";
replace share_intermediate =.21 if sector_plus=="G";
replace share_intermediate =.39 if sector_plus=="J";
replace share_intermediate =.60 if sector_plus=="K";
replace share_intermediate =.27 if sector_plus=="L";
replace share_intermediate =.78 if sector_plus=="M";
replace share_intermediate =.56 if sector_plus=="U";

label var share_intermediate "Share of Intermediate Products in Production";
lab var sales "Total Sales in USD $";

drop _merge  markup_developing markup_developed markup_developing_max markup_developed_max markup_developing_dlc markup_developed_dlc markup_developing_max_dlc markup_developed_max_dlc;

order id pci_id date form isic* sector* companycountry managercountry country_id position strata* g13 heap India ln_delta_markup share_intermediate age hundred MNC MandA labor profitable exporter export_potential PCI_markup;

saveold "20171204_AJPS_MaleskyMosely_w_markups.dta", version(13) replace;
codebookout "ReplicationData_Codebook", replace;

