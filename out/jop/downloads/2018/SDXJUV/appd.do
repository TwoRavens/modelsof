use "appd.dta"

* Table 3
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if fees == 0, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if fees == 1, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if oppfees == 0, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if oppfees == 1, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if wcf == 0, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if wcf == 1, cluster(agency_codex)


* Regressions to generate Figure 1
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p1", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p2", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p3", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p4", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p5", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p6", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p7", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p8", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p9", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p10", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p12", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p13", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p14", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p15", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p16", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p17", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p18", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p19", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p20", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p21", cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if primarypolicy != "p23", cluster(agency_codex)

* Table 4
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if sigreg == 0, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if sigreg == 1, cluster(agency_codex)

* Table 5
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if lnrec_avg < 4.60517, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if lnrec_avg >= 4.60517, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if cabinet == 0, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe i.commfe if cabinet == 1, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval lncurrent i.agencyfe i.commfe, cluster(agency_codex)



* Table 6
reg discretion divided inflation unemp first_year war approval counter i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe##c.counter i.commfe, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe##c.counter##c.counter i.commfe, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval i.agencyfe##c.counter##c.counter##c.counter i.commfe, cluster(agency_codex)
reg discretion divided inflation unemp first_year war approval postchadha i.agencyfe i.commfe, cluster(agency_codex)
xtset agency_subcomm fy
reg discretion divided L1.discretion inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
xtabond discretion divided inflation unemp first_year war approval, lags(1) artests(2) vce(robust)












