*open the fileuse "FL10g_ToDrawSample.dta"*THE MODELlogit g06_voted gen prim age age2 years_registered female rep demhist yhat_10
hist yhat_10 if in_sample == 1