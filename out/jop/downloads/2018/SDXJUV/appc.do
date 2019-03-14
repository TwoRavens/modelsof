use "appc.dta"

* Table 1
reg discretion divided lnpres war inflation approval unemp i.agencyfe i.commfe, cluster(agency_codex)
ivreg2 discretion divided war inflation approval unemp i.agencyfe i.commfe (lnpres = first_year second_year third_year first_term), partial(i.agencyfe i.commfe) cluster(agency_codex)

* Table 2
reg discretion divided i.ch_disagree inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
