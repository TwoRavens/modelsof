**These commands produce the mini models that appear in Table 1 (1971 dyads).

**Trade incentives model (model 1)
regress opportunity dyadgdp distance avgtradeopen mtnest_avg if year == 1971

**State capacity model (model 2)
regress opportunity sepratism avg_gdppc mtnest_avg if year == 1971

**Threat models (model 3)
regress opportunity maj_min cwpceyrs polity_avg mtnest_avg if year == 1971

**Combined models (model 4)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1971


**These commands generate the models that appear in Table 2
**Model 5 (includes measure of bilateral trade)
regress opportunity bilateraltrade sepratism  avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1971

**Model 6 (includes measure of Kin in power in neighboring state)
regress opportunity dyadgdp distance avgtradeopen sepratism powerful_kin avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1971

**Model 7 (uses mean tax ratio)
regress opportunity dyadgdp distance avgtradeopen sepratism dytaxratio maj_min cwpceyrs polity_avg mtnest_avg if year == 1971

**Model 8 (uses weak link tax ratio)
regress opportunity dyadgdp distance avgtradeopen sepratism lowtaxratio maj_min cwpceyrs polity_avg mtnest_avg if year == 1971

**Model 9 (uses dyads containing least developed countries)
regress opportunity dyadgdp distance avgtradeopen sepratism LDCdyad maj_min cwpceyrs polity_avg mtnest_avg if year == 1971


**These commands generate the models in Table 3

**Model 10 (includes weak link polity test)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_low mtnest_avg if year == 1971

**Model 11 (includes a measure of alliances)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs allies mtnest_avg if year == 1971


**These commands generate the models in Table 4

**Model 12 (uses 1981 data)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1981

**Model 13 (uses 1986 data)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1986

**Model 14 (uses 1996 data)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1996

**Model 15 (controls for new dyads)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg newdyad if include71==1&exclude==0

**Model 16 (excludes influential observations)
quietly regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1971
predict d, cooksd
gen influence=0
replace influence=1 if d>4/200
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if influence!=1&year == 1971


** These commands generate the models in Table A2 (appendix)

**Model A1 (includes measure of common IO membership)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs NUMIGO mtnest_avg if year == 1971

** Model A2 (includes measure of political affinity)
regress opportunity mtnest_avg dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg s3uni if year == 1971

** Model A3 (includes measure of avergage polity score and indicator of European dyads)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg europe mtnest_avg if year == 1971


** These commands generate the models in Table A3 (appendix)

** Model A4 (includes indicator of mountainous borders)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mountainous if year == 1971

** Model A5 (includes measure of the percentage of the border that comports with topographical features)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg per_topographic if year == 1971


** These commands generate the models in Table A4 (appendix)

** Model A6 (includes indicator of new (post 1971) dyads and violent territorial change)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg newdyad conflict_change mtnest_avg if include71==1&exclude==0

** Model A7 (includes indicator of dyads including post-Soviet states)
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg postsoviet mtnest_avg if include71==1&exclude==0




regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg tallest_mountain if year == 1971


xi: regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs i.alliance mtnest_avg if year == 1971


**Combined model minus influential observations, 1971 dyads
quietly regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1971
predict d, cooksd
gen influence=0
replace influence=1 if d>4/200
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if influence!=1&year == 1971

**Alternative lag tests
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if year == 1976
outreg using C:\Users\Aaron\Documents\Research\Borders\June21_table2.out, coefastr se bdec(2, 10, 5, 2, 2, 7, 2, 3, 2) 3aster ctitle (1976 dyads) append



**Sensitivity check II
**Including new dyads
regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg mtnest_avg if include71==1&exclude==0
outreg using C:\Users\Aaron\Documents\Research\Borders\June21_table6.out, coefastr se bdec(10, 5, 2, 2, 5, 2, 3, 3, 2) 3aster title (Table 6: New dyad checks, part III.)

regress opportunity dyadgdp distance avgtradeopen sepratism avg_gdppc maj_min cwpceyrs polity_avg newdyad mtnest_avg if include71==1&exclude==0
outreg using C:\Users\Aaron\Documents\Research\Borders\June21_table6.out, coefastr se bdec(10, 5, 2, 2, 5, 2, 3, 3, 2, 2) 3aster append




