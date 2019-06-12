use "/Users/dbroock/Dropbox/Broockman-Skovron/Elite perceptions 2/2016 ANES/anes_timeseries_2016_dta/anes_timeseries_2016.dta", clear

recode V162019 (1=1) (2=0) (nonmis = .)

tab V161158x
recode V161158x (1/3=1) (5/7=0) (nonmis = .), gen(piddemnotrep)

tabstat V162019, by(piddemnotrep)
