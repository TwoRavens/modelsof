cd H:\DarkFuture\ExperimentData\DarkFutureReplicationDistribution\
use "DarkFuture_Master.dta", clear

*Hypothesis 1
*these tests do not cluster
prtest OfferReject  if Role==0  & roundid==1 , by(Delta_)
prtest OfferReject  if Role==0  & roundid==1 & repetition==1, by(Delta_)
prtest OfferReject  if Role==0  & roundid==1 & repetition==2, by(Delta_)

*these tests cluster and are used in text
reg OfferReject Delta_ if Role==0  & roundid==1 , cl(ID)
reg OfferReject Delta_ if Role==0  & roundid==1 & repetition==1, cl(ID)
reg OfferReject Delta_ if Role==0  & roundid==1 & repetition==2, cl(ID)


*Hypothesis 2
local offer "& SubjAOffer>.5" 
prtest OfferReject  if Role==0  & roundid==1 `offer', by(Delta_)
prtest OfferReject  if Role==0  & roundid==1 & repetition==1 `offer', by(Delta_)
prtest OfferReject  if Role==0  & roundid==1 & repetition==2 `offer', by(Delta_)

local offer "& SubjAOffer>.69" 
prtest OfferReject  if Role==0  & roundid==1 `offer', by(Delta_)
prtest OfferReject  if Role==0  & roundid==1 & repetition==1 `offer', by(Delta_)
prtest OfferReject  if Role==0  & roundid==1 & repetition==2 `offer', by(Delta_)


reg OfferReject Delta_ if Role==0  & roundid==1  `offer', cl(ID)
reg OfferReject Delta_ if Role==0  & roundid==1 & repetition==1 `offer', cl(ID)
reg OfferReject Delta_ if Role==0  & roundid==1 & repetition==2 `offer', cl(ID)




*Post Experiment survey analysis
use DarkFutureMasterR_IndividualLevel.dta, clear
ranksum  BREJECT_PD1, by(Delta)
ranksum  aoffer, by(Delta)
