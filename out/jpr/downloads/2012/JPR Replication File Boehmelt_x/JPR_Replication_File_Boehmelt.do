*** Why many cooks if they can spoil the broth? The determinants of multiparty mediation ***
*** Tobias Bšhmelt, Center for Comparative and International Studies, ETH Zurich, tobias.boehmelt@ir.gess.ethz.ch ***
*** December 31, 2011 ***

*** Table I - use dataset 'JPR Dataset Table I.dta' ***
tab effect4
tab effect_new
tab effect_new size, column chi2

*** Initial variable recodings (already done in final data 'JPR Dataset Tables II and III.dta') ***
generate w_s_ratio=winning_coal/(log((selectorate+1)*10)/3)
sum w_s_ratio
generate bias=abs(s_un_glo_target-s_un_glo_challenger)
sum bias
generate distance_abs=abs(distance_target-distance_challenger)
sum distance_abs

*** Table II - use dataset 'JPR Dataset Tables II and III.dta' ***
logit multimed_dummy rgdpch cap w_s_ratio election distance_abs icowsal duration low_polity2 ln_capratio bias if year>=1950, cluster (coalition_id)
sum rgdpch cap w_s_ratio election distance_abs icowsal duration low_polity2 ln_capratio bias if e(sample)
prvalue, x(election=0 rgdpch=1152.18) rest(mean)
prvalue, x(election=0 rgdpch=33443.54) rest(mean)
prvalue, x(election=0 cap=.000029) rest(mean)
prvalue, x(election=0 cap=.31116) rest(mean)
prvalue, x(election=0 w_s_ratio=0) rest(mean)
prvalue, x(election=0 w_s_ratio=1.001425) rest(mean)
prvalue, x(election=0) rest(mean)
prvalue, x(election=1) rest(mean)
prvalue, x(election=0 distance_abs=16) rest(mean)
prvalue, x(election=0 distance_abs=6504) rest(mean)
prvalue, x(election=0 icowsal=2) rest(mean)
prvalue, x(election=0 icowsal=12) rest(mean)
prvalue, x(election=0 duration=1) rest(mean)
prvalue, x(election=0 duration=186) rest(mean)
prvalue, x(election=0 low_polity2=-10) rest(mean)
prvalue, x(election=0 low_polity2=10) rest(mean)
prvalue, x(election=0 ln_capratio=.0073939) rest(mean)
prvalue, x(election=0 ln_capratio=8.155075) rest(mean)
prvalue, x(election=0 bias=0) rest(mean)
prvalue, x(election=0 bias=.593939) rest(mean)

logit multimed_dummy rgdpch cap w_s_ratio election distance_abs icowsal duration low_polity2 ln_capratio bias settnump durmid terriss if year>=1950, cluster (coalition_id)
sum rgdpch cap w_s_ratio election distance_abs icowsal duration low_polity2 ln_capratio bias settnump durmid terriss if e(sample)
prvalue, x(election=0 durmid=0 terriss=0 rgdpch=1152.18) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 rgdpch=33443.54) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 cap=.000029) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 cap=.31116) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 w_s_ratio=0) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 w_s_ratio=1.001425) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0) rest(mean)
prvalue, x(election=1 durmid=0 terriss=0) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 distance_abs=16) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 distance_abs=6504) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 icowsal=2) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 icowsal=12) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 duration=1) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 duration=186) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 low_polity2=-10) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 low_polity2=10) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 ln_capratio=.0073939) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 ln_capratio=8.155075) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 bias=0) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 bias=.593939) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 settnump=1) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0 settnump=57) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0) rest(mean)
prvalue, x(election=0 durmid=1 terriss=0) rest(mean)
prvalue, x(election=0 durmid=0 terriss=0) rest(mean)
prvalue, x(election=0 durmid=0 terriss=1) rest(mean)

*** Table III - use dataset 'JPR Dataset Tables II and III.dta' ***
logit multimed_dummy rgdpch cap w_s_ratio election distance_abs icowsal duration low_polity2 ln_capratio bias settnump durmid terriss if year>=1950 & mediation==1, cluster (coalition_id)
logit multimed_dummy distance_abs bias if year>=1950 & typesett!=8, cluster (coalition_id)
heckprob mmed_selection rgdpch cap w_s_ratio election distance_abs icowsal duration low_polity2 ln_capratio bias if year>1949, noconst sel(mediation2=icowsal duration low_polity2 ln_capratio settnump durmid terriss) r






