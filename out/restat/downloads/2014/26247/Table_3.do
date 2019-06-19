*Table_3

do Define_Globals

*****************************************************************
* Table 3 - Treatment Effect on a Listing Funding 
*****************************************************************
use listing_final, clear

* Baseline probabilities 
tab prime_categ treat if (after_change == 0 & control == 0  & inrange(month_id,11,15)), sum(funded) means 

dprobit funded $DIFF3 $DIFF2 $DIFF1 $COVARIATES $WEEK_DUM, vce(cluster st_week)
