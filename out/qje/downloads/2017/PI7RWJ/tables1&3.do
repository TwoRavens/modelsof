
/*table 1 
col (5) level 
col (6) log
col (7) level chronic 
col (8) log chronic

table 3 
col (5) fraction migrants as instrument 
col (6) South only  - migrants  
col (7) South only -distance log chronic 
col (8) kids levels
*/

log using "tables1&3.smcl", replace 
use "$repdrive/Tables_data", clear

	foreach x in  $allcause_outcome _1940_amort  $outcome  _1940_chronic {
 qui reghdfe `x'  tuskegeedist_post_black_male tuskegeedist_post_male tuskegeedist_post_black $controls   , ///
  absorb(i.black#i.male#i.sea  i.sea#i.yrs i.yrs#i.black#i.male) dofadjustments(clusters)  vce(cluster sea)
   estimates store table1`x' 
   }
 

  qui reghdfe $outcome    frcn_post_black_male frcn_post_black frcn_post_male $controls  , ///
   absorb(i.black#i.male#i.sea  i.sea#i.yrs i.yrs#i.black#i.male) dofadjustments(clusters)  vce(cluster sea)
 
 estimates store table3col5
 
   qui reghdfe $outcome    frcn_post_black_male frcn_post_black frcn_post_male $controls if reg_3 == 1   , ///
  absorb(i.black#i.male#i.sea i.sea#i.yrs i.yrs#i.black#i.male) dofadjustments(clusters)  vce(cluster sea)
	  
estimates store table3col6	
  qui reghdfe $outcome   tuskegeedist_post_black_male tuskegeedist_post_male tuskegeedist_post_black $controls if reg_3 == 1    , ///
  absorb(i.black#i.male#i.sea  i.sea#i.yrs i.yrs#i.black#i.male) dofadjustments(clusters)  vce(cluster sea)

estimates store table3col7

   qui reghdfe _1940_childmort_0to14 tuskegeedist_post_black_male tuskegeedist_post_male tuskegeedist_post_black $controls   , ///
  absorb(i.black#i.male#i.sea  i.sea#i.yrs i.yrs#i.black#i.male) dofadjustments(clusters)  vce(cluster sea)
estimates store table3col8
  
  estimates table _all, ///
  stats(N r2_a N_clust) equations(1) b(%9.6f) t(%9.2f) se(%9.6f) p(%9.4f) ///
  keep(tuskegeedist_post_black_male tuskegeedist_post_black tuskegeedist_post_male ///
  frcn_post_black_male frcn_post_black frcn_post_male ) 

 log close 
