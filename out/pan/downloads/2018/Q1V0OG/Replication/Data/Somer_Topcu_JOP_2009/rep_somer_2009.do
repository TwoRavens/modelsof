clear

use13 "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/_to_do/Somer_Topcu_JOP_2009/core_data_Timely_Decisions.dta"

gen absch1=abs(cmp-cmpt1)
gen absch2=abs(cmpt1-cmpt2)
gen votech2=votet1-votet2
gen votechtime = votech2*monthstoprevelect
gen bigparty10=1 if vote>10 & votet1>10
replace bigparty10=0 if bigparty10!=1

//replicate Table 1, Model 2

reg absch1 votech2 monthstoprevelect votechtime absch2, cluster (edate)

gen sample = e(sample)

keep if sample==1

saveold "rep_somer_2009"
