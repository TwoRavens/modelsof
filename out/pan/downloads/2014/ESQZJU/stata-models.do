use POQdataset.dta

gen lapp2Xunempl = lapp2*unempl
regress app2 lapp2 growth unempl lapp2Xunempl D.Infl_new logKcas logVcas logAIcas, robust
summarize lapp2 growth unempl lapp2Xunempl D.Infl_new logKcas logVcas logAIcas if e(sample)

dfuller app2, lags(0)
pperron app2
corrgram app2

save POQdataset-ts-additions.dta, replace
