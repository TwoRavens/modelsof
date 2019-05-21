
  clear
  
  use Lindvall_JOP_data.dta  
  
* Define conditions and controls

  local conditions boix_democracy==1 & L1.boix_democracy==1 & L1.other!=1 & other!=1 & right!=. & L1.right!=. & l_election==1 & year!=1915 & year!=1916 & year!=1917 & year!=1918 & year!=1919 & year!=1940 & year!=1941 & year!=1942 & year!=1943 & year!=1944 & year!=1945 & year!=1946 & (L1.recession != . | L1.recession_b!= . | L1.recession_c!= .)
  local conditions2 polity2>5 & L1.polity2>5 & polity2!=. & L1.polity2!=. & L1.other!=1 & other!=1 & right!=. & L1.right!=. & l_election==1 & year!=1915 & year!=1916 & year!=1917 & year!=1918 & year!=1919 & year!=1940 & year!=1941 & year!=1942 & year!=1943 & year!=1944 & year!=1945 & year!=1946 & (L1.recession != . | L1.recession_b!= . | L1.recession_c!= .)
  local controls0 l_war l_madd_gdpcap prewar interwar regLA
  local controls l_war l_presidentialism l_proportional l_madd_gdpcap prewar interwar regLA
  local controls1  l_war l_presidentialism l_fractionalization l_madd_gdpcap prewar interwar regLA
  local controls3 i.l_war##i.l_lc i.l_presidentialism##i.l_lc i.l_proportional##i.l_lc c.l_madd_gdpcap##i.l_lc i.interwar##i.l_lc i.prewar##i.l_lc i.regLA##i.l_lc  
  local excludelindvall2014 year!=1930 & year!=1931 & year!=1932 & year!=1933 & year!=1934 & year!=2009 & year!=2010 & year!=2011 & year!=2012 & year!=2013 & year!=2014   
  
  
* TABLES IN THE ARTICLE ITSELF 
  
* TABLE 1
  
  bysort ccodecow: generate ue_change_1 = ar_ue - ar_ue[_n-1] 
  bysort ccodecow: generate ue_change_2 = ar_ue - ar_ue[_n-2] 
  bysort ccodecow: generate ue_change_3 = ar_ue - ar_ue[_n-3] 
  bysort ccodecow: generate ue_change_4 = ar_ue - ar_ue[_n-4] 

  sum ue_change_1 if recession_c == 1 & length_recession_c==1
  sum ue_change_2 if recession_c == 1 & length_recession_c==2
  sum ue_change_3 if recession_c == 1 & length_recession_c==3
  sum ue_change_4 if recession_c == 1 & length_recession_c==4
  
  sort ccodecow year
  
  bysort ccodecow: generate ue3_change_1 = unemp_us - unemp_us[_n-1] 
  bysort ccodecow: generate ue3_change_2 = unemp_us - unemp_us[_n-2] 
  bysort ccodecow: generate ue3_change_3 = unemp_us - unemp_us[_n-3] 
  bysort ccodecow: generate ue3_change_4 = unemp_us - unemp_us[_n-4] 
  
  preserve
  
  drop if year > 1913 & year < 1919
  drop if year > 1938 & year < 1946
  
  sum ue3_change_1 if recession_c == 1 & length_recession_c==1 
  sum ue3_change_2 if recession_c == 1 & length_recession_c==2
  sum ue3_change_3 if recession_c == 1 & length_recession_c==3
  sum ue3_change_4 if recession_c == 1 & length_recession_c==4

  restore

* TABLE 2 
  
  * Variables recoded temporarily to get percentages.
  
  preserve
	
  replace right = 100*right
  replace lc = 100*lc
	  
  keep if `conditions'

  foreach i in lc right {
  tab l_rec_length_c hogideo_n_bin if l_`i' == 1 & l_election == 1, row
  }

  foreach i in lc right {
  tab l_rec_length_c hogideo_n_bin if l_`i' == 1 & l_election == 1 & periods == 1, row
  }

  foreach i in lc right {
  tab l_rec_length_c hogideo_n_bin if l_`i' == 1 & l_election == 1 & periods == 2, row
  }
  
  foreach i in lc right {
  tab l_rec_length_c hogideo_n_bin if l_`i' == 1 & l_election == 1 & periods == 3, row
  }

  foreach i in lc right {
  tab l_rec_length_c hogideo_n_bin if l_`i' == 1 & l_election == 1 & regLA == 0, row
  }

  foreach i in lc right {
  tab l_rec_length_c hogideo_n_bin if l_`i' == 1 & l_election == 1 & regLA == 1, row
  }
  
  
  restore 
 
* TABLE 3
 
  logit right l_brief_c l_drawn_c if `conditions' & L1.right == 0, robust cluster(ccodecow)
   
  logit right l_brief_c l_drawn_c `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
  
  logit lc l_brief_c l_drawn_c if `conditions' & L1.right == 1, robust cluster(ccodecow)
   
  logit lc l_brief_c l_drawn_c `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)
 
* TABLE 4

  logit transition L1.rec_length_c##l_lc `controls3' if `conditions', robust cluster(ccodecow)
  
  margins, at(L1.rec_length`a' = (0 1 2) l_lc = (0 1)) post
  
  test _b[2._at] = _b[4._at] /// Effect of short recession if lc govt. in power
  
  test _b[1._at] = _b[3._at] /// Effect of short recession if right govt. in power
  
  test _b[3._at] - _b[1._at] = _b[4._at] - _b[2._at] /// Differences.
  
  test _b[2._at] = _b[6._at] /// Effect of long recession if lc govt. in power
  
  test _b[1._at] = _b[5._at] /// Effect of long recession if right govt. in power
  
  test _b[5._at] - _b[1._at] = _b[6._at] - _b[2._at] /// Differences.
 
* TABLE 5

  logit right l_shallowbriefrecession_c l_deepbriefrecession_c l_shallowlongrecession_c l_deeplongrecession_c if `conditions' & L1.right == 0, robust cluster(ccodecow)

  logit right l_shallowbriefrecession_c l_deepbriefrecession_c l_shallowlongrecession_c l_deeplongrecession_c `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)

  logit lc l_shallowbriefrecession_c l_deepbriefrecession_c l_shallowlongrecession_c l_deeplongrecession_c if `conditions' & L1.right == 1, robust cluster(ccodecow)

  logit lc l_shallowbriefrecession_c l_deepbriefrecession_c l_shallowlongrecession_c l_deeplongrecession_c `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)
  
* TABLE 6

  preserve
  
  generate rectype = 0 if l_recession_c !=.
  replace rectype = 1 if l_shallowbriefrecession_c == 1
  replace rectype = 2 if l_deepbriefrecession_c == 1
  replace rectype = 3 if l_shallowlongrecession_c == 1
  replace rectype = 4 if l_deeplongrecession_c == 1
  
  logit transition i.rectype##l_lc `controls3' if `conditions', cluster(ccodecow)
  
  margins, at(rectype = (0 1 2 3 4) l_lc = (0 1)) post
  
  test _b[2._at] = _b[4._at] /// Effect of short, shallow recession if lc govt. in power
  
  test _b[1._at] = _b[3._at] /// Effect of short, shallow recession if right govt. in power
  
  test _b[3._at] - _b[1._at] = _b[4._at] - _b[2._at] /// Differences.
  
  test _b[2._at] = _b[6._at] /// Effect of short, deep if lc govt. in power
  
  test _b[1._at] = _b[5._at] /// Effect of short, deep if right govt. in power
  
  test _b[5._at] - _b[1._at] = _b[6._at] - _b[2._at] /// Differences.
  
  test _b[2._at] = _b[8._at] /// Effect of long, shallow if lc govt. in power
  
  test _b[1._at] = _b[7._at] /// Effect of long, shallow if right govt. in power
  
  test _b[7._at] - _b[1._at] = _b[8._at] - _b[2._at] /// Differences.

  test _b[2._at] = _b[10._at] /// Effect of long, deep if lc govt. in power
  
  test _b[1._at] = _b[9._at] /// Effect of long, deep if right govt. in power
  
  test _b[9._at] - _b[1._at] = _b[10._at] - _b[2._at] /// Differences.

  restore
  
  
  
* TABLES IN THE ONLINE APPENDIX  
  
* TABLE 7
 
  logit right l_brief_b l_drawn_b `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)

  logit lc l_brief_b l_drawn_b `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)
  
  logit right l_brief l_drawn `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)

  logit lc l_brief l_drawn `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)
  
  logit right l_growth_c l_growth_c_5 `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
	  
  logit lc l_growth_c l_growth_c_5 `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)

  logit right l_recession_c l2_below_c `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
	  
  logit lc l_recession_c l2_below_c `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)

* TABLE 8

  logit right l_brief_c l_drawn_c l_domesticevents `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
  
  logit lc l_brief_c l_drawn_c l_domesticevents `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)

  logit right l_brief_c l_drawn_c `controls' if `conditions2' & L1.right == 0, robust cluster(ccodecow)
  
  logit lc l_brief_c l_drawn_c `controls' if `conditions2' & L1.right == 1, robust cluster(ccodecow)

* TABLE 9

  logit transition l_brief_c##l_lc l_drawn_c##l_lc `controls3' if `conditions', robust cluster(ccodecow)

  logit transition l_shallowbriefrecession_c##l_lc l_deepbriefrecession_c##l_lc l_shallowlongrecession_c##l_lc l_deeplongrecession_c##l_lc  `controls3' if `conditions', robust cluster(ccodecow)
     
* TABLE 10
   
  logit right l_brief_c l_drawn_c `controls1' if `conditions' & L1.right == 0, robust cluster(ccodecow)
   
  logit lc l_brief_c l_drawn_c `controls1' if `conditions' & L1.right == 1, robust cluster(ccodecow)

* TABLE 11

  logit right l_brief_c l_drawn_c l_growth_c l_growth_c_5 `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
   
  logit lc l_brief_c l_drawn_c l_growth_c l_growth_c_5 `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)

* TABLE 12

  logit right l_brief_c l_drawn_c if `conditions' & `excludelindvall2014' & L1.right == 0, robust cluster(ccodecow)
   
  logit right l_brief_c l_drawn_c `controls' if `conditions' & `excludelindvall2014' & L1.right == 0, robust cluster(ccodecow)
  
  logit lc l_brief_c l_drawn_c if `conditions' & `excludelindvall2014' & L1.right == 1, robust cluster(ccodecow)
   
  logit lc l_brief_c l_drawn_c `controls' if `conditions' & `excludelindvall2014' & L1.right == 1, robust cluster(ccodecow)

* TABLE 13

  logit right l_brief_c l_drawn_c l_brief_c##prewar l_drawn_c##prewar l_brief_c##interwar l_drawn_c##interwar `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
     
  logit lc l_brief_c l_drawn_c l_brief_c##prewar l_drawn_c##prewar l_brief_c##interwar l_drawn_c##interwar `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)
 
  logit right l_brief_c l_drawn_c l_brief_c##regLA l_drawn_c##regLA `controls' if `conditions' & L1.right == 0, robust cluster(ccodecow)
     
  logit lc l_brief_c l_drawn_c l_brief_c##regLA l_drawn_c##regLA `controls' if `conditions' & L1.right == 1, robust cluster(ccodecow)

* TABLE 14
  
  logit right l_brief_c##l_presidentialism l_drawn_c##l_presidentialism l_proportional `controls0' if `conditions' & L1.right == 0, robust cluster(ccodecow)
  
  logit right l_brief_c##l_proportional l_drawn_c##l_proportional l_presidentialism `controls0' if `conditions' & L1.right == 0, robust cluster(ccodecow)

  logit lc l_brief_c##l_presidentialism l_drawn_c##l_presidentialism l_proportional  `controls0' if `conditions' & L1.right == 1, robust cluster(ccodecow)
  
  logit lc l_brief_c##l_proportional l_drawn_c##l_proportional l_presidentialism `controls0' if `conditions' & L1.right == 1, robust cluster(ccodecow)
  
* TABLE 15 
   
  preserve
 
  label define type 0 "No" 1 "Yes (short)" 2 "Yes (long)"
  
  foreach a in "" "_b" "_c" {
  
  generate l_type`a' = .
  replace l_type`a' = 0 if l_brief`a' == 0 & l_drawn`a' == 0
  replace l_type`a' = 1 if l_brief`a' == 1
  replace l_type`a' = 2 if l_drawn`a' == 1
  label variable l_type`a' "Downturn (length)"
  label values l_type`a' type

  }

  tsset ccodecow year
  
  keep if (right != L1.right) & `conditions'

  sort cname year

  keep cname year l_hogname l_hogideo hogname hogideo l_type_c l_type_b l_type 
  
  order cname year l_hogname l_hogideo hogname hogideo l_type_c l_type_b l_type 
  
  export excel using transitions.xls, replace
  
  restore
