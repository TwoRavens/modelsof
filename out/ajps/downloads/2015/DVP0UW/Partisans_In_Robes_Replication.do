*** Stata "do file" for all results reported in Partisans in Robes: Party Cues and Public Acceptance of Supreme Court Decisions ***
*** to be used with Partisans_In_Robes_Replication.dta ***

*** RESULTS REPORTED IN ARTICLE ***

*** Table 2. The Average Effect of Institutional Source Cues on Policy Acceptance ***
*** Gays in Religious Clubs Model ***
ologit  accept i.sc_att i.gov_att if clubs==1
*** testing equality of coefficients ***
test 1.sc_att=1.gov_att
*** Handgun Ban Model ***
ologit  accept i.sc_att i.gov_att if guns==1
test 1.sc_att=1.gov_att
*** Juvenile Sentencing Model ***
ologit  accept i.sc_att i.gov_att if sentencing==1
test 1.sc_att=1.gov_att
*** Campaign Finance Model ***
ologit  accept i.sc_att i.gov_att if camp_fin==1
test 1.sc_att=1.gov_att

*** Table 3. The Conditional Effect of the Supreme Court Source Cue on Policy Acceptance ***
*** Pooled Model ***
ologit  accept i.sc_att##i.party_cue  sc_x_activist  i.sc_att##c.polarization baseline if no_att==0
*** Gays in Religious Clubs Model ***
ologit  accept i.sc_att##i.party_cue if no_att==0 & clubs==1
*** Handgun Ban Model ***
ologit  accept i.sc_att##i.party_cue  sc_x_activist if no_att==0 & guns==1
*** Juvenile Sentencing Model ***
ologit  accept i.sc_att##i.party_cue  sc_x_activist if no_att==0 & sentencing==1
*** Campaign Finance Model ***
ologit  accept i.sc_att##i.party_cue  sc_x_activist if no_att==0 & camp_fin==1

*** Table 4. Testing Whether the Supreme Court Source Cue Conditions the Effect of Partisan Cues on Policy Acceptance ***
*** Gays in Religious Clubs Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & clubs==1
*** Handgun Ban Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & guns==1
*** Juvenile Sentencing Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & sentencing==1
*** Campaign Finance Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & camp_fin==1

*** Table 5. The Effect of Party Polarization and Party Cues on Policy Acceptance ***
*** creating partisan compatibility variable ***
gen compatibility = party_id if guns==1
replace compatibility = party_id if camp_fin==1
replace compatibility = -(party_id) if clubs==1
replace compatibility = -(party_id) if sentencing==1
*** Supreme Court Source Model ***
ologit accept c.compatibility##i.party_cue##c.polarization baseline if sc_x_activist==0 & sc_att==1
*** Government Source Model ***
ologit accept c.compatibility##i.party_cue##c.polarization baseline if sc_x_activist==0 & gov_att==1

*** RESULTS REPORTED IN SUPPLEMENTAL INFORMATION ***

*** Pooled Model from Table 3 with Fixed Effects ***
ologit  accept i.sc_att##i.party_cue  sc_x_activist  i.sc_att##c.polarization guns camp_fin if no_att==0

*** Table 4 Models, Including Only Subjects Receiving “Supreme Court” Treatment ***
*** Gays in Religious Clubs Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & sc_att==1 & clubs==1
*** Handgun Ban Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & sc_att==1 & guns==1
*** Juvenile Sentencing Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & sc_att==1 & sentencing ==1
*** Campaign Finance Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & sc_att==1 & camp_fin==1

*** Table 4 Models, Including Only Subjects Receiving “Government” Treatment ***
*** Gays in Religious Clubs Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & gov_att==1 & clubs==1
*** Handgun Ban Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & gov_att==1 & guns==1
*** Juvenile Sentencing Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & gov_att==1 & sentencing ==1
*** Campaign Finance Model ***
ologit accept c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & gov_att==1 & camp_fin==1

*** Table 4 Models, Including Only High Court Approval Subjects ***
*** Gays in Religious Clubs Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & court_approve>3 & clubs==1
*** Handgun Ban Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & court_approve>3 & guns==1
*** Juvenile Sentencing Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & court_approve>3 & sentencing==1
*** Campaign Finance Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & court_approve>3 & camp_fin==1

*** Table 4 Models, Including Only Subjects with High Levels of Political Knowledge ***
*** Gays in Religious Clubs Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & know>=5 & clubs==1
*** Handgun Ban Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & know>=5 & guns==1
*** Juvenile Sentencing Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & know>=5 & sentencing==1
*** Campaign Finance Model ***
ologit accept i.sc_att##c.party_id##i.party_cue if no_att==0 & sc_x_activist==0 & know>=5 & camp_fin==1

*** Table 5 Models, Excluding Triple Interaction Term ***
*** Supreme Court Source Model ***
ologit accept c.compatibility##i.party_cue c.compatibility##c.polarization i.party_cue##c.polarization baseline if sc_x_activist==0 & sc_att==1
*** Government Source Model ***
ologit accept c.compatibility##i.party_cue c.compatibility##c.polarization i.party_cue##c.polarization baseline if sc_x_activist==0 & gov_att==1

*** Models from Table 5 with Fixed Effects ***
*** Supreme Court Source Model ***
ologit accept c.compatibility##i.party_cue##c.polarization guns camp_fin if sc_x_activist==0 & sc_att==1
*** Government Source Model ***
ologit accept c.compatibility##i.party_cue##c.polarization guns camp_fin if sc_x_activist==0 & gov_att==1
