***Last Updated: 12/14/2018 Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Data cleaning of the Turkish National Survey on Domestic Violence against Women (TNSDVW) 2014

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

To run the do file all you need to do is to change the path of the working directory in line 34.

The dataset used in this do file is provided by the Turkish Statistical Institute (TSI). Their data availability policy 
prohibits the distribution of data to non-registered users. Researchers have to complete a form 
(http://www.turkstat.gov.tr/UstMenu/body/bilgitalep/MVKullaniciTalepFormu_ENG.pdf), and send it 
to bilgi@tuik.gov.tr by e-mail. Upon receipt of this form, the TSI sends 
the datasets through an ftp server electronically. 

Please convert this data in spss to Stata format, and save it as "Domestic Violence/originals/household_2014_destring.dta" before you run this
do file.

*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;

global dir="XXX\Domestic Violence";
cd "$dir";

use "originals/household_2014_destring.dta", clear;

*Create unique household ID;
gen HHID = hclust*1000+hnumber;
sort HHID;
order HHID;

foreach var in 
h19a h19b h19c h19d h19e h19f h19g h19h h19i h19j h19k h19l h19m h19n h19o h19p h19r h19s h19t h19u h19v h19w h19x h19y h19z{;
egen z_`var'=std(`var');
};
egen z_asset=rowmean(z_h19a z_h19b z_h19c z_h19d z_h19e z_h19f z_h19g z_h19h z_h19i z_h19j z_h19k z_h19l z_h19m z_h19n z_h19o z_h19p z_h19r z_h19s z_h19t z_h19u z_h19v z_h19w z_h19x z_h19y z_h19z);
drop z_h19a z_h19b z_h19c z_h19d z_h19e z_h19f z_h19g z_h19h z_h19i z_h19j z_h19k z_h19l z_h19m z_h19n z_h19o z_h19p z_h19r z_h19s z_h19t z_h19u z_h19v z_h19w z_h19x z_h19y z_h19z;
label variable z_asset "Z-score: all asset variables";

drop h* ;

sort HHID;
order HHID;

save "created/household_data_for_analysis_2014_final.dta", replace;






