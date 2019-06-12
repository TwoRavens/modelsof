*The following command sorts data by firm and year
Sort gvkey_number cyr
*The following command declares that it is a panel data 
xtset gvkey_number cyr
*The following regression yields the results presented in Model 1 of Table 1
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if arms==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 1
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 3 of Table 1
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster(gvkey_number)

*The following regression yields the results presented in Model 1 of Table 2- Guns as the only arms sector
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if GunsOnly==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 1 of Table 2- Shipbuilding and Aircraft as hybrid Sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if revisedhybrid==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 2- Basic materials sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1 & basic==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 2- Cyclical consumer sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1 & cycconsum==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 2- Non-cyclical consumer sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1 & noncycconsum==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 2- Financial sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1 & financial==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 2- Industrial sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1 & industrial==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 2- Utilities sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1 & utilities==1, cluster (gvkey_number)

*The following regression yields the results presented in Table 3
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logWar##c.d.MilitaryContractRevenue c.l.logWar##c.l.MilitaryContractRevenue c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if firmswithcontract==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 1 of Table 4- Arms sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d. logWar_Causalty c.l. logWar_Causalty c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if arms==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 1 of Table 4- Civil sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d. logWar_Causalty c.l. logWar_Causalty c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 1 of Table 4- Hybrid sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d. logWar_Causalty c.l. logWar_Causalty c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number  c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 4- Arms sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logWar_ArmsSpending c.l.logWar_ArmsSpending c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if arms==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 4- Civil sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logWar_ArmsSpending c.l.logWar_ArmsSpending c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 2 of Table 4- Hybrid sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logWar_ArmsSpending c.l.logWar_ArmsSpending c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 3 of Table 4- Arms sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logtotallargewar c.l.logtotallargewar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if arms==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 3 of Table 4- Civil sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logtotallargewar c.l.logtotallargewar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 3 of Table 4- Hybrid sectors
reg c.d.profitability_ebitda c.l.profitability_ebitda c.d.logtotallargewar c.l.logtotallargewar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 4 of Table 4- Arms sectors
reg c.d.profitability_netincome c.l.profitability_netincome  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if arms==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 4 of Table 4- Civil sectors
reg c.d.profitability_netincome c.l.profitability_netincome  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)

*The following regression yields the results presented in Model 4 of Table 4- Hybrid sectors
reg c.d.profitability_netincome c.l.profitability_netincome  c.d.logWar c.l.logWar c.d.Size c.l.Size c.d.Leverage c.l.Leverage c.d.Dividend c.l.Dividend c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport  i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster (gvkey_number)


*The following regression yields the results presented for arms sectors in Table 5- Predicting change in ln(Sale)
reg c.d.logSale c.l.logSale  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if arms==1, cluster (gvkey_number)

*The following regression yields the results presented for arms sectors in Table 5- Predicting change in ln(Investment)
reg c.d.logInvestment c.l.logInvestment  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.tobin c.l.tobin c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if arms==1, cluster (gvkey_number)

*The following regression yields the results presented for arms sectors in Table 5- Predicting change in ln(Labor Productivity)
reg c.d.logLaborProductivity c.l.logLaborProductivity  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if arms==1, cluster (gvkey_number)

*The following regression yields the results presented for arms sectors in Table 5- Predicting change in ln(Capital Productivity)
reg c.d.logCapitalProductivity c.l.logCapitalProductivity  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if arms==1, cluster (gvkey_number)




*The following regression yields the results presented for civil sectors in Table 5- Predicting change in ln(Sale)
reg c.d.logSale c.l.logSale  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if civil==1, cluster (gvkey_number)

*The following regression yields the results presented for civil sectors in Table 5- Predicting change in ln(Investment)
reg c.d.logInvestment c.l.logInvestment  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.tobin c.l.tobin c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if civil==1, cluster (gvkey_number)

*The following regression yields the results presented for civil sectors in Table 5- Predicting change in ln(Labor Productivity)
reg c.d.logLaborProductivity c.l.logLaborProductivity  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)

*The following regression yields the results presented for civil sectors in Table 5- Predicting change in ln(Capital Productivity)
reg c.d.logCapitalProductivity c.l.logCapitalProductivity  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if civil==1, cluster (gvkey_number)



*The following regression yields the results presented for hybrid sectors in Table 5- Predicting change in ln(Sale)
reg c.d.logSale c.l.logSale  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if hybrid==1, cluster (gvkey_number)

*The following regression yields the results presented for hybrid sectors in Table 5- Predicting change in ln(Investment)
reg c.d.logInvestment c.l.logInvestment  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.tobin c.l.tobin c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08  if hybrid==1, cluster (gvkey_number)

*The following regression yields the results presented for hybrid sectors in Table 5- Predicting change in ln(Labor Productivity)
reg c.d.logLaborProductivity c.l.logLaborProductivity  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster (gvkey_number)

*The following regression yields the results presented for hybrid sectors in Table 5- Predicting change in ln(Capital Productivity)
reg c.d.logCapitalProductivity c.l.logCapitalProductivity  c.d.logdur2 c.l.logdur2 c.d.Size c.l.Size c.d.Age c.l.Age c.d.ColdWar c.l.ColdWar c.d.InternationalWar c.l.InternationalWar c.d.ArmExport c.l.ArmExport i.sic_number c60 c61 c62 c63 c64 c65 c66 c67 c68 c69 c70 c71 c76 c80 c81 c82 c83 c84 c85 c86 c87 c88 c89 c90 c91 c92 c93 c94 c95 c96 c97 c98 c99 c00 c01 c02 c03 c04 c05 c06 c07 c08 if hybrid==1, cluster (gvkey_number)

