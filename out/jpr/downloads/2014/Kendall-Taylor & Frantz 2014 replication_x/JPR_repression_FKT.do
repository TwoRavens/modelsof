**********************************************************************************
 * Author: Erica Frantz
 * Date: October 7, 2013
 *
 * Using data: 
 *      amelia_data_input-imp1.dta
 *		amelia_data_input-imp2.dta
 * 		amelia_data_input-imp3.dta
 *		amelia_data_input-imp4.dta
 *		amelia_data_input-imp5.dta
 
 * To replicate tests in article, run the following models below on all five datasets.
 * Use the techniques described in King et al. (2001) to derive the estimates of the 
 * coefficients and standard errors.
 **********************************************************************************

 * Table 1
 
* Model 1
ologit lead_fh1  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri, cluster(cowcode)
* Model 2
ologit lead_fh2  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri, cluster(cowcode)
* Model 3
ologit lead_fh3  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri, cluster(cowcode)
* Model 4
ologit lead_fh4  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri, cluster(cowcode)
* Model 5
 ologit lead_fh5  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri, cluster(cowcode)
* Model 6
xtpcse fh_5avg  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri , pairwise
* Model 7
xtpcse fh_5avg  fh_or cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri ctry_*, pairwise 


* Table 2

* Model 1
ologit lead_flip1  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or, cluster(cowcode)
* Model 2
ologit lead_flip2  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or ,cluster(cowcode)
* Model 3
ologit lead_flip3  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or ,cluster(cowcode)
* Model 4
ologit lead_flip4  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or ,cluster(cowcode)
* Model 5
ologit lead_flip5  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or ,cluster(cowcode)
* Model 6
xtpcse flip_5avg  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or , pairwise
* Model 7
xtpcse flip_5avg  flip_ciri cooptation  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or ctry_*, pairwise 


*Online Appendix B

xtpcse fh_5avg  fh_or at_least legis_1  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem flip_ciri , pairwise 

xtpcse flip_5avg  flip_ciri at_least legis_1  prio*  gled_lpop gled_lgdppc geddes_personal   geddes_monarch geddes_party  wdi_tradeg cold  wdi_gdppcgrowth  archigos_duration*  archigos_past powthy_pasta pseudo   election banks_genstrike banks_riot banks_antigovdem fh_or , pairwise 
