*****************************************
**************** Figures **************** 
*****************************************

set more off
use isq2016_main, clear

/* Figure 1 */
#delimit ;
hist nengu, normal bcolor(black) density bin(10) 
	gap(10)  ylabel(0(.01).05, nogrid) xlabel(0(20)100) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
	xtitle("Nengu (Proportion of total rice production collected as tax)") ;


/* Figure 2 */
#delimit ;
graph bar (sum) hanran_hoki_w_misui, 
	bar(1, color(black)) outergap(*2) 
	legend(off) ytitle("") title("Insurrections") 
	yscale(range(0(10)50)) ylabel(0(10)50, nogrid) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
	saving("figure2a", replace) ;

graph bar (sum) fuon_w_misui, 
	bar(1, color(black)) outergap(*2) 
	legend(off) ytitle("") title("Protests") 
	yscale(range(0(10)50) off) ylabel(0(10)50, nogrid) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
	saving("figure2b", replace) ;

graph bar (sum) chosan_w_misui, 
	bar(1, color(black)) outergap(*2) 
	legend(off) ytitle("") title("Collective desertions") 
	yscale(range(0(10)50) off) ylabel(0(10)50, nogrid)
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
	saving("figure2c", replace) ;

graph combine "figure2a" 
	"figure2b" "figure2c", 
	ycommon cols(3) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
    imargin(0 0 0 0) 
	saving("Figure2", replace) ;


/* Figure A */
#delimit ;
graph bar (sum) goso_w_misui,
	bar(1, color(black)) outergap(*2) 
	legend(off) ytitle("") title("Coercive appeal") 
	yscale(range(0(50)250)) ylabel(0(50)250, nogrid) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
	saving("FigureAa", replace) ;

graph bar (sum) osso_shuso_hariso_w_misui, 
	bar(1, color(black)) outergap(*2) 
	legend(off) ytitle("") title("Appeals") 
	yscale(range(0(50)250) off) ylabel(0(50)250, nogrid) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
	saving("FigureAb", replace) ;

graph combine "FigureAa" 
	"FigureAb", 
	ycommon cols(2) 
	scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) 
    imargin(0 0 0 0)
	saving("Figure_Appendix", replace) ;


*****************************************
**************** Tables ***************** 
*****************************************


/* Table 1: Summary Statistics */

set more off
use isq2016_main, clear

keep nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
 	nontax_ikki nontax_ikki_w_misui ///
 	relative_samurai ///
	uchidaka growth pop_province ///
	fudai_new gosanke_new ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude
order nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
 	nontax_ikki nontax_ikki_w_misui ///
 	relative_samurai ///
	uchidaka growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
 	nontax_ikki nontax_ikki_w_misui ///
 	relative_samurai ///
	uchidaka growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude


/* Table 2: Aggregated Regression */
set more off

use isq2016_main, clear

reg nengu rebellion, robust

reg nengu relative_samurai rebellion ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new  ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust

reg nengu rebel_tax rebel_nontax, robust

reg nengu relative_samurai rebel_tax rebel_nontax ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


/* Table 3: Disaggregated Regression without attempted rebellions */
set more off

use isq2016_main, clear

reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth, robust

*Let's include population variable
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province, robust

*Let's include other alternative variables
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new, robust

*Let's include the spatial variables
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude, robust

*Let's include the natural disaster variables
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust

/* Table 4: Disaggregated Regression with Goso as a separate category */
set more off

use isq2016_main, clear

reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
 	nontax_ikki_w_misui relative_samurai ///
	growth, robust

*Let's include the variables for alternative hypotheses (i.e., pop)
reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province, robust

*Let's include other alternative variables
reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new, robust

*Let's include the spatial variables
reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude, robust

*Let's include the natural disaster variables
reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


*****************************************
**************** Appendix *************** 
*****************************************

/* Table A: Replication only with nontax rebellions */
set more off

use isq2016_main, clear

reg nengu ///
	nontax_ikki relative_samurai ///
	growth, robust

*Let's include population variable
reg nengu ///
	nontax_ikki relative_samurai ///
	growth pop_province, robust

*Let's include other alternative variables
reg nengu ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new, robust

*Let's include the spatial variables
reg nengu  ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude, robust

*Let's include the natural disaster variables
reg nengu  ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


/* Table E: Replication with square term for the samurai var */
set more off

use isq2016_main, clear

gen relative_samurai_square = relative_samurai*relative_samurai
lab var relative_samurai_square "Relative size of samurai class (square term)"

reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai relative_samurai_square ///
	growth, robust

*Let's include population variable
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai relative_samurai_square ///
	growth pop_province, robust

*Let's include fudai and gosanke
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai relative_samurai_square ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new, robust

*Let's include the spatial variables
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai relative_samurai_square ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude, robust

*Let's include the natural disaster variables
reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai relative_samurai_square ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


/* Tables B, C, and D: Different time periods */

* Table B: 1653-1868
set more off

use isq2016_1653, clear

reg nengu relative_samurai rebellion ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new  ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust

reg nengu relative_samurai rebel_tax rebel_nontax ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table B: 1713-1868
set more off

estimates clear

use isq2016_1713, clear

reg nengu relative_samurai rebellion ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new  ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust

reg nengu relative_samurai rebel_tax rebel_nontax ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table B: 1761-1868
set more off

use isq2016_1761, clear

reg nengu relative_samurai rebellion ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new  ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust

reg nengu relative_samurai rebel_tax rebel_nontax ///
	growth pop_province tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust



* Table C: 1653-1868
set more off

use isq2016_1653, clear

reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table C: 1713-1868
set more off

use isq2016_1713, clear

reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table C: 1761-1868
set more off

use isq2016_1761, clear

reg nengu hanran_hoki fuon chosan goso ///
	osso_shuso_hariso uchikoshi ///
	nontax_ikki relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table D: 1653-1868
set more off

use isq2016_1653, clear

reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table D: 1713-1868
set more off

use isq2016_1713, clear

reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust


* Table D: 1761-1868
set more off

use isq2016_1761, clear

reg nengu hanran_hoki_w_misui fuon_w_misui chosan_w_misui ///
	goso_w_misui osso_shuso_hariso_w_misui uchikoshi_w_misui ///
	nontax_ikki_w_misui relative_samurai ///
	growth pop_province ///
	tradecenter core_shinseihugun fudai_new gosanke_new ///
	elevmean elevstd longitude latitude ///
	earthquake-draught poorharvest-epidemic, robust
