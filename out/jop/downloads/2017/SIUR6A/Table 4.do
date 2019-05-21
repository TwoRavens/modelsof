clear
use "/Users/michelemargolis/Dropbox/Elesion/subject line analysis/EIT/Replication files/Email experiment replication data.dta"
  
xi: reg open indiv i.pairing, cl(mailer)
xi: reg open indiv i.pairing

xi: reg open i.type i.pairing, cl(mailer) 
test _Itype_1=_Itype_2

