#delimit;
clear;
cap log close;

set mem 600m;
set matsize 800;
set more 1;
tempfile temp1 temp2; 

/* REPLACE *** WITH FILE PATH FOR DATA ON PREDICTED MARGINS (SEE FORMULA IN TEXT OF PAPER) AND FIRM CHARACTERISTICS*/

use ***;

gen price_cont= (molecule=="CEFADROXIL" | molecule=="CHLORPROMAZINE" | molecule=="CIPROFLOXACIN"| 
molecule=="ERYTHROMYCIN" | molecule=="FAMOTIDINE" | molecule=="FUROSEMIDE" | molecule=="GLIPIZIDE" | 
molecule=="IBUPROFEN" | molecule=="LEVODOPA" | molecule=="NALIDIXIC ACID"| molecule=="OXYTETRACYCLINE" |  
molecule=="RANITIDINE" | molecule=="TETRACYCLINE" |    molecule=="VERAPAMIL");      

drop if price_cont==1;

tab mol_code, gen(mol_dum);

/*Cost Regression*/
regress lnmargin mol_dum*, noconstant robust;
for num 1/141: gen lncostX = _b[mol_dumX];
for num 1/141: gen costX= exp(lncostX);

/*Robustness Check*/

regress lnmargin mol_dum* fmkt_entry incumb form_no branded foreign bigdom inst*, noconstant robust;

for num 1/141: gen lncost_robX = _b[mol_dumX];
for num 1/141: gen cost_robX= exp(lncost_robX);


log close;

