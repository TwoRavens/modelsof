****************************************************************
* Replication file for "Government Respect for Gendered Rights"
* by Wade M. Cole
****************************************************************

sort id year
xtset id year

* Women's rights index (Table 1)

xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xi3: xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs L.cedaw_rat_yrs2=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re

* Interactions (Table 2)

xi3: xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs L.cedaw_rat_yrs_sharia=l(1).(law_british*sharia checks_dpi*sharia womparl*sharia ratif_hurdle*sharia btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xi3: xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs L.cedaw_rat_yrs_muslim=l(1).(law_british*muslim sharia*muslim checks_dpi*muslim womparl*muslim ratif_hurdle*muslim btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xi3: xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs L.cedaw_rat_yrs_polity=l(1).(law_british*polity sharia*polity checks_dpi*polity womparl*polity ratif_hurdle*polity btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xi3: xtivreg womenrights_ciri l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs L.cedaw_rat_yrs_wingos=l(1).(law_british*wingos sharia*wingos checks_dpi*wingos womparl*wingos ratif_hurdle*wingos btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re

* Disaggregated into economic, political, and social rights (Table 3)

xtivreg wecon l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg wecon l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg wopol l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg wopol l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg wosoc l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg wosoc l(1).(polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar pressfreedom_fh) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re

* Women in parliament (Table 4)

xtivreg womparl l(1).(womenrights_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(womenrights_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(wecon_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(wecon_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(wopol_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(wopol_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(wosoc_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_1=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re
xtivreg womparl l(1).(wosoc_ciri femquota_1_fill polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar) ///
  (L.cedaw_rat_yrs=l(1).(law_british sharia checks_dpi womparl ratif_hurdle btscs_cedaw_rat _spline1cedaw_rat _spline2cedaw_rat _spline3cedaw_rat) cedaw_conferences) if year<2005, re

* Legislative quotas (Table 5)

stset end, id(id) origin(time 1980) failure(femquota_1==1) exit(femquota_1==1) time0(start)
streg cedaw_rat_1 womenrights_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_yrs womenrights_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_1 wecon_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_yrs wecon_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_1 wopol_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_yrs wopol_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_1 wosoc_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
streg cedaw_rat_yrs wosoc_ciri womparl polity p_change ngo100_sans_wingo wingos female_tert3 labor_women_wdi3 gdppc100 cedawwld muslim sharia law_socialist postcomm5 popgrowth_wdi intrawar, dist(exponential) robust nolog 
