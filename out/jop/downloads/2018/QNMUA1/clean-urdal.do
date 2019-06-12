 

**BEGIN**
use YouthBulges_Urdal_ISQ_Posted, clear
rename ss_num cowcode
keep cowcode year country yth*
tsset cow year
gen lag1ythblgap =l.ythblgap
label var ythblgap "Youth bulge (Urdal)"
rename country urdal_country
 
replace cow = 678 if cow==679 & year>=1990  /* Yemen, North Yemen same regime */
replace cow =651 if cow==1206  /* UAR coded as Egypt */

*clean out the sample to match the global sample		/**/
sort cow year
merge cowcode year using gwf-original
tab _merge
tab year if _merge==2
tab country if _merge==2 & year<2001 & year>1949  /* Syria under UAR and South Yemen under Yemen */
keep if _merge~=1
drop _merge
sort cowcode year
save urdal-merge, replace
**END**
