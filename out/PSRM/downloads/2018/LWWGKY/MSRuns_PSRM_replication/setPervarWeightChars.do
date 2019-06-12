// specify per-variable weights for reliability analyses
// NOTE that for binary variables, weight has no effect
foreach var of varlist flag mention* ecAppeal etPositive etNegative em* tFc* tOc* {
	char `var'[reliability_weight] ordinal
}
foreach var of varlist ideologyFc ideologyOc {
	char `var'[reliability_weight] quadratic
}
