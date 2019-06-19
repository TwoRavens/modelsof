u $data\edex_data_analytic, clear

preserve
keep T1 T2 bytxmstd bytxrstd
gen id=1
save $data\temp_fig2, replace
restore
keep T1 T2 bytxmstd bytxrstd
gen id=2

append using $data\temp_fig2

gen T = T1 if id==1
replace T = T2 if id==2
binscatter T bytxmstd, by(id)

drop T
gen T = T2 if id==1
replace T = T1 if id==2
binscatter T bytxrstd, by(id)
