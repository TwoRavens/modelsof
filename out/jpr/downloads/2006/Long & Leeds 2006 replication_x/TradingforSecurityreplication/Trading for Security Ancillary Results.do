
** 1885-1938 Sample**
use "(insert full path here\Trading for Security Ancillary Results.dta"

*Baseline Gravity Model
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border, corr(ar1) pairwise np1

*Any type of alliance
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag allies Hegemony, corr(ar1) pairwise np1

*Exclude Barbieri Trade Data
xtpcse ROtrade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies Hegemony, corr(ar1) pairwise np1

*Exclude Imputed GDP values
xtpcse trade GDP_1_real GDP_2_real POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies Hegemony, corr(ar1) pairwise np1

*Substitute Kendall's Tau_b statistic of alliance portfolios for Similarity Score
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Tau_b JointDemocracy MIDlag Lallies NLallies Hegemony, corr(ar1) pairwise np1

clear


** 1885-1913 Sample **
use "(insert full path here\Trading for Security Ancillary Results.dta"
drop if year>1913

*Baseline Gravity Model
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border, corr(ar1) pairwise np1

*Any type of alliance
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag allies, corr(ar1) pairwise np1

*Exclude Barbieri Trade Data
xtpcse ROtrade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1

*Exclude Imputed GDP values **
xtpcse trade GDP_1_real GDP_2_real POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1

*Substitute Kendall's Tau_b statistic of alliance portfolios for Similarity Score
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Tau_b JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1


** 1920-1938 Sample **
use "(insert full path here\Trading for Security Ancillary Results.dta"
drop if year<1920

*Baseline Gravity Model
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border, corr(ar1) pairwise np1

*Any type of alliance
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag allies, corr(ar1) pairwise np1

*Exclude Barbieri Trade Data
xtpcse ROtrade GDP_1 GDP_2 POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1

*Exclude Imputed GDP values **
xtpcse trade GDP_1_real GDP_2_real POP_1 POP_2 Distance Border Similarity JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1

*Substitute Kendall's Tau_b statistic of alliance portfolios for Similarity Score **
xtpcse trade GDP_1 GDP_2 POP_1 POP_2 Distance Border Tau_b JointDemocracy MIDlag Lallies NLallies, corr(ar1) pairwise np1

