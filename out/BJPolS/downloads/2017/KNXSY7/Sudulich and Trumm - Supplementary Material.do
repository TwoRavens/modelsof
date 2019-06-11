
*****
***** Supplementary material for: "A Comparative Study of the Effects of Electoral Institutions on Campaigns" 
***** Authors: Laura Sudulich (University of Kent; L.Sudulich@kent.ac.uk), Siim Trumm (University of Nottingham; siim.trumm@nottingham.ac.uk)
*****

***** Main article
*** Table 1
bysort country smd: summarize campaign_effort_time if using_time==1
bysort country smd: summarize campaign_effort_complexity if using_complexity==1
bysort country smd: summarize campaign_focus if using_focus==1

*** Table 2
reg campaign_effort_time smd district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust
reg campaign_effort_time electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust
reg campaign_effort_time i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust

*** Table 3
oprobit campaign_effort_complexity smd district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust
oprobit campaign_effort_complexity electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust
oprobit campaign_effort_complexity i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust

*** Table 4
reg campaign_focus smd district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust
reg campaign_focus electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust
reg campaign_focus i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country, robust


***** Online Appendix
*** Table A2
reg campaign_effort_time smd district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust
reg campaign_effort_time electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust
reg campaign_effort_time i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust

oprobit campaign_effort_complexity smd district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust
oprobit campaign_effort_complexity electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust
oprobit campaign_effort_complexity i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust

reg campaign_focus smd district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust
reg campaign_focus electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust
reg campaign_focus i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success i.country if constant_sample==1, robust

*** Table A3
xtmixed campaign_effort_time smd district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:
xtmixed campaign_effort_time electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:
xtmixed campaign_effort_time i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:

xtmixed campaign_effort_complexity smd district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:
xtmixed campaign_effort_complexity electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:
xtmixed campaign_effort_complexity i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:

xtmixed campaign_focus smd district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:
xtmixed campaign_focus electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:
xtmixed campaign_focus i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success || country:

*** Table A4
xtmixed campaign_effort_time smd district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
xtmixed campaign_effort_time electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
xtmixed campaign_effort_time i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:

xtmixed campaign_effort_complexity smd district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
xtmixed campaign_effort_complexity electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
xtmixed campaign_effort_complexity i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:

xtmixed campaign_focus smd district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
xtmixed campaign_focus electoral_incentives district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
xtmixed campaign_focus i.vote#c.district_magnitude past_MP party_hierarchy constituency ideological_distance success || party:
