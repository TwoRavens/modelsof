***Creation of Variables Uploaded in Dataset***


*Creation of natural log of contribution variable (ln_amount_2012index)*

gen ln_amount_2012index = ln(amount_2012index)


*Creation of natural log of contribution limit variable (log_limits_all_2012 )*

gen log_limits_all_2012 = ln(limits_all_2012index)


*Creation of partisan election X professionalization interaction variable (partisanrXsquire1)*

gen partisanrXsquire1 = partisan_elect_rev2*scprof_Squire1
