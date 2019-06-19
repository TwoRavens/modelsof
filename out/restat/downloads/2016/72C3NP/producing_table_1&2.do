set more off
u admit, clear
replace prelim=prelim/3


drop if gcsescore>4
drop if alevelscore<100
drop if col1averageinterview<40
drop if prelim<30
global scale=0.5

save temp, replace

sort male
by male: summ  gcsescore alevelscore  tsaoverall tsaessay col1averageinterview prelim_tot got_in accept indep
sort indep
by indep: summ  gcsescore alevelscore  tsaoverall tsaessay col1averageinterview prelim_tot got_in accept male

sort male
ttest gcsescore, by(male)
ttest alevelscore, by(male)
ttest tsaoverall, by(male)
ttest tsaessay, by(male)
ttest col1average, by(male)
ttest prelim, by(male)
ttest got_in, by(male)


sort indep
ttest gcsescore, by(indep)
ttest alevelscore, by(indep)
ttest tsaoverall, by(indep)
ttest tsaessay, by(indep)
ttest col1average, by(indep)
ttest prelim, by(indep)
ttest got_in, by(indep)

reg prelim gcsescore alevelscore tsaoverall tsaessay col1averageinterview indep male

probit got_in gcsescore alevelscore tsaoverall tsaessay col1averageinterview indep male


