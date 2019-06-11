xtset id year

//Testing for stationarity//

xtunitroot fisher disapp, dfuller trend lags(1)
xtunitroot fisher disapp, dfuller trend lags(2)

xtunitroot fisher exkill, dfuller trend lags(1)
xtunitroot fisher exkill, dfuller trend lags(2)

xtunitroot fisher polpris, dfuller trend lags(1)
xtunitroot fisher polpris, dfuller trend lags(2)

xtunitroot fisher tort, dfuller trend lags(1)
xtunitroot fisher tort, dfuller trend lags(2)

xtunitroot fisher assn, dfuller trend lags(1)
xtunitroot fisher assn, dfuller trend lags(2)

xtunitroot fisher formove, dfuller trend lags(1)
xtunitroot fisher formove, dfuller trend lags(2)

xtunitroot fisher dommove, dfuller trend lags(1)
xtunitroot fisher dommove, dfuller trend lags(2)

xtunitroot fisher speech, dfuller trend lags(1)
xtunitroot fisher speech, dfuller trend lags(2)

xtunitroot fisher elecsd, dfuller trend lags(1)
xtunitroot fisher elecsd, dfuller trend lags(2)

xtunitroot fisher religion, dfuller trend lags(1)
xtunitroot fisher religion, dfuller trend lags(2)

xtunitroot fisher worker, dfuller trend lags(1)
xtunitroot fisher worker, dfuller trend lags(2)

//restricted regression//

xtreg disapp L(1/3).disapp, fe
xtreg exkill L(1/3).exkill, fe
xtreg polpris L(1/3).polpris, fe 
xtreg tort L(1/3).tort, fe
xtreg assn L(1/4).assn, fe
xtreg formove L(1/4).formove, fe
xtreg dommove L(1/2).dommove, fe
xtreg speech L(1/3).speech, fe
xtreg elecsd L(1/4).elecsd, fe
xtreg religion L(1/3).religion, fe
xtreg worker L(1/5).worker, fe 
xtreg wecon L(1/4).wecon, fe
xtreg wopol L(1/3).wopol, fe
xtreg wosoc L(1/4).wosoc, fe

//Granger causality tests//

xtreg disapp L(1/3).disapp L(1/2).exkill, fe
test L1.exkill L2.exkill

xtreg exkill L(1/3).exkill L(1/3).disapp, fe
test L1.disapp L2.disapp L3.disapp

xtreg disapp L(1/3).disapp L(1/2).polpris, fe
test L1.polpris L2.polpris

xtreg polpris L(1/3).polpris L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.assn, fe
test L1.assn

xtreg assn L(1/4).assn L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L(1/2).disapp, fe
test L1.disapp L2.disapp

xtreg disapp L(1/3).disapp L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.disapp, fe
test L1.disapp

xtreg disapp L(1/3).disapp L1.worker, fe
test L1.worker

xtreg worker L(1/5).worker L1.disapp, fe
test L1.disapp

xtreg exkill L(1/3).exkill L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L(1/2).tort, fe
test L1.tort L2.tort

xtreg tort L(1/3).tort L(1/2).exkill, fe
test L1.exkill L2.exkill

xtreg exkill L(1/3).exkill L1.assn, fe
test L1.assn

xtreg assn L(1/4).assn L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.exkill, fe
test L1.exkill

xtreg exkill L(1/3).exkill L1.worker, fe
test L1.worker

xtreg worker L(1/5).worker L1.exkill, fe
test L1.exkill

xtreg polpris L(1/3).polpris L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L(1/2).worker, fe
test L1.worker L2.worker

xtreg worker L(1/5).worker L1.polpris, fe
test L1.polpris

xtreg tort L(1/3).tort L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L(1/2).tort, fe
test L1.tort L2.tort

xtreg tort L(1/3).tort L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.worker, fe
test L1.worker

xtreg worker L(1/5).worker L1.tort, fe
test L1.tort

xtreg assn L(1/4).assn L1.polpris, fe
test L1.polpris

xtreg polpris L(1/3).polpris L(1/2).assn, fe
test L1.assn L2.assn

xtreg assn L(1/4).assn L1.tort, fe
test L1.tort

xtreg tort L(1/3).tort L1.assn, fe
test L1.assn

xtreg assn L(1/4).assn L(1/2).formove, fe
test L1.formove L2.formove

xtreg formove L(1/4).formove L1.assn, fe
test L1.assn

xtreg assn L(1/4).assn L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.assn, fe
test L1.assn

xtreg assn L(1/4).assn L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L(1/2).assn, fe
test L1.assn L2.assn

xtreg assn L(1/4).assn L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L(1/2).assn, fe
test L1.assn L2.assn 

xtreg assn L(1/4).assn L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L(1/2).assn, fe
test L1.assn L2.assn

xtreg assn L(1/4).assn L(1/3).worker, fe
test L1.worker L2.worker L3.worker

xtreg worker L(1/5).worker L1.assn, fe
test L1.assn

xtreg formove L(1/4).formove L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.formove, fe
test L1.formove

xtreg formove L(1/4).formove L1.worker, fe
test L1.worker

xtreg worker L(1/5).worker L1.formove, fe
test L1.formove

xtreg dommove L(1/2).dommove L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.dommove, fe
test L1.dommove

xtreg dommove L(1/2).dommove L1.worker, fe
test L1.worker

xtreg worker L(1/5).worker L1.dommove, fe
test L1.dommove

xtreg speech L(1/3).speech L1.elecsd, fe
test L1.elecsd

xtreg elecsd L(1/4).elecsd L(1/4).speech, fe
test L1.speech L2.speech L3.speech L4.speech

xtreg speech L(1/3).speech L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L1.speech, fe
test L1.speech

xtreg speech L(1/3).speech L(1/2).worker, fe
test L1.worker L2.worker 

xtreg worker L(1/5).worker L1.speech, fe
test L1.speech

xtreg elecsd L(1/4).elecsd L1.religion, fe
test L1.religion

xtreg religion L(1/3).religion L(1/2).elecsd, fe
test L1.elecsd L2.elecsd

xtreg elecsd L(1/4).elecsd L(1/3).worker, fe
test L1.worker L2.worker L3.worker

xtreg worker L(1/5).worker L1.elecsd, fe
test L1.elecsd

xtreg religion L(1/3).religion L(1/2).worker, fe
test L1.worker L2.worker

xtreg worker L(1/5).worker L(1/2).religion, fe
test L1.religion L2.religion

