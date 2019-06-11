clear
cd "~/Dropbox/Interaction Paper/Data/Included/Malesky_APSR_2012/"
use "data/electionresults_replication_public.dta",clear
generate time=0 if session==5
replace time=1 if session==6

by delegate_id, sort:  egen avg_speech=mean(speaknum_count) if session <5.9
by delegate_id, sort:  egen avg_speechpost=mean(speaknum_count) if session >5.9
generate diff_speech=speaknum_count-l.avg_speech if session==6
lab var diff_speech "Speeches - Difference Between 6th and Delegate Average in Previous Sessions (#)"

by delegate_id, sort:  egen avg_quest=mean(question_count) if session <5.9
by delegate_id, sort:  egen avg_questpost=mean(question_count) if session >5.9
generate diff_quest= question_count-l.avg_quest if session==6
lab var diff_quest "Questions - Difference Between 6th and Delegate Average in Previous Sessions (#)"

by delegate_id, sort:  egen avg_crit=mean(criticize_total_per) if session <5.9
by delegate_id, sort:  egen avg_critpost=mean(criticize_total_per) if session >5.9
generate diff_crit=criticize_total_per-l.avg_crit if session==6
lab var diff_crit "Difference Between 6th and Delegate Average in Previous Sessions (% Critical)"

bysort delegate_id (session): g d_question_count=question_count-question_count[_n-1]
bysort delegate_id (session): g d_criticize_total_per=criticize_total_per-criticize_total_per[_n-1]


//Replicate Table 5

//Model 4
xi: reg  d.question_count i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id)

//Model 8
xi: reg  d.criticize_total_per i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id)

//Model 9 
xi: reg  diff_quest i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id)

//Model 10
xi: reg  diff_crit  i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted if session==6 & politburo==0, robust cluster(pci_id)



keep if e(sample)
saveold "rep_malesky_2012.dta", replace


//Model 4
xi: reg  d_question_count i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted, robust cluster(pci_id)

//Model 8
xi: reg  d_criticize_total_per i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted, robust cluster(pci_id)

//Model 9 
xi: reg  diff_quest i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted, robust cluster(pci_id)

//Model 10
xi: reg  diff_crit  i.t2*internet_users100 centralnominated fulltime retirement  city ln_gdpcap ln_pop transfer south unweighted, robust cluster(pci_id)

