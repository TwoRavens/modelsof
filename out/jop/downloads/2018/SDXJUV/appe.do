use "appe.dta"

* Table 7
reg discretion divided lnauthorizing inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided lnauthorizing3 inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided lnauthorizing5 inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided lnprimary inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided lnprimary3 inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided lnprimary5 inflation unemp first_year war approval i.agencyfe i.commfe, cluster(agency_codex)
reg discretion divided unemp inflation approval first_year war lnexpired i.agencyfe i.commfe, cluster(agency_codex)
