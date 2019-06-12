*Use AppendixSectionB_Data.dta

set more off

drop if days<=0

gen absnom=abs(dwnom1)
gen minabsnom=minority*absnom
gen mindwmeddist=minority*dwmeddist

*Model 1

xi: logit sign PrevAdopters VoteSharePrevAdopt days days2 days3 i.PetitionID if days>0 & cong!=., robust cluster(idno)
fitstat

*Model 2

xi: logit sign PrevAdopters VoteSharePrevAdopt minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors days days2 days3 i.PetitionID if days>0 & cong!=., robust cluster(idno)
fitstat

*Model 3

xi: logit sign PrevAdopters PrevAdoptersNetwork VoteSharePrevAdopt VoteSharePANetwork minority dweucldis dwmeddist mindwmeddist absnom minabsnom VoteShare ch_senior prestige_com CommLeader TargetCommMem IndCosponsors days days2 days3 i.PetitionID if days>0 & cong!=., robust cluster(idno)
fitstat
