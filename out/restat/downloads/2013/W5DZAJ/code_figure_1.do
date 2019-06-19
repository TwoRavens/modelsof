****************** USE database_figure_1.dta**************************

gen  propor_mq_30_pessoal100 =  100*atraso_mq_30_pessoal
label variable propor_mq_30_pessoal100 "Personal"
gen  propor_mq_30_veiculo100 =  100*atraso_mq_30_veiculos
label variable propor_mq_30_veiculo100 "Auto"

twoway (line propor_mq_30_veiculo100 data, lpattern(solid) connect(direct)) (line propor_mq_30_pessoal100 data, lpattern(dash) connect(direct)), ytitle(%) xtitle(, size(zero)) title(FIG. 1 Delinquency Rates: Auto v. Personal Loans) subtitle(Proportion of Loans More than 30 Days Overdue) caption(Source: Banco Central do Brasil) legend(on rows(1) position(4) ring(0))

drop propor_mq_30_pessoal100 propor_mq_30_veiculo100
