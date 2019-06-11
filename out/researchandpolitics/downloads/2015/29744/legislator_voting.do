
*Model 1: All legislators*
probit vote_yea republican black_legislator bvap hvap under25 over65 mdhhinc_1000 married collegeormore Citizen South senate yr2012 yr2013 if abstain==0
predict p if e(sample)
sum p
gen pmycode = normal(_b[_cons] + _b[republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen difference = p - pmycode
sum pmycode difference
gen prepublican_1 = normal(_b[_cons] + _b[ republican]*1 + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen prepublican_0 = normal(_b[_cons] + _b[ republican]*0 + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectrepublican = prepublican_1 - prepublican_0
sum prepublican_1 prepublican_0 effectrepublican
gen pblack_legislator_1 = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*1 + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pblack_legislator_0 = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*0 + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectblack_legislator = pblack_legislator_1 - pblack_legislator_0
sum pblack_legislator_1 pblack_legislator_0 effectblack_legislator
gen psenate_1 = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*1 + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen psenate_0 = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*0 + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectsenate = psenate_1 - psenate_0
sum psenate_1 psenate_0 effectsenate
gen pyr2012_1 = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*1 + _b[yr2013]*yr2013) if e(sample)
gen pyr2012_0 = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*0 + _b[yr2013]*yr2013) if e(sample)
gen effectyr2012 = pyr2012_1 - pyr2012_0
sum pyr2012_1 pyr2012_0 effectyr2012
gen pbvap_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*.0009 + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pbvap_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*.932 + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectbvap = pbvap_Min - pbvap_Max
sum pbvap_Min pbvap_Max effectbvap
gen phvap_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*.004 + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen phvap_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*.952 + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effecthvap = phvap_Min - phvap_Max
sum phvap_Min phvap_Max effecthvap
gen pover65_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*.043 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pover65_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*.317 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectover65 = pover65_Min - pover65_Max
sum pover65_Min pover65_Max effectover65
gen pmdhhinc_1000_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*18.37 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pmdhhinc_1000_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*164.635 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectmdhhinc_1000 = pmdhhinc_1000_Min - pmdhhinc_1000_Max
sum pmdhhinc_1000_Min pmdhhinc_1000_Max effectmdhhinc_1000
gen pmarried_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*.159 + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pmarried_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*.721 + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectmarried = pmarried_Min - pmarried_Max
sum pmarried_Min pmarried_Max effectmarried
gen pcollegeormore_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*.035 + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pcollegeormore_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*.84 + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectcollegeormore = pcollegeormore_Min - pcollegeormore_Max
sum pcollegeormore_Min pcollegeormore_Max effectcollegeormore
gen pCitizen_Min = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*.551355 + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pCitizen_Max = normal(_b[_cons] + _b[ republican]*republican + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*.9990696 + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectCitizen = pCitizen_Min - pCitizen_Max
sum pCitizen_Min pCitizen_Max effectCitizen
sum vote_yea republican black_legislator bvap hvap under25 over65 mdhhinc_1000 married collegeormore Citizen South senate yr2012 yr2013 if abstain==0


*Model 2: Republican legislators*
probit vote_yea bvap hvap under25 over65 mdhhinc_1000 married collegeormore Citizen South senate yr2012 yr2013 if abstain==0 & party_code==1
predict p if e(sample)
sum p
gen pmycode = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen difference = p - pmycode
sum pmycode difference
gen pbvap_Min = normal(_b[_cons] + _b[bvap]*.0009 + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pbvap_Max = normal(_b[_cons] + _b[bvap]*.356 + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectbvap = pbvap_Min - pbvap_Max
sum pbvap_Min pbvap_Max effectbvap
gen pcollegeormore_Min = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*.083 + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pcollegeormore_Max = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*.741 + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectcollegeormore = pcollegeormore_Min - pcollegeormore_Max
sum pcollegeormore_Min pcollegeormore_Max effectcollegeormore
gen psenate_1 = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*1 + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen psenate_0 = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*0 + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectsenate = psenate_1 - psenate_0
sum psenate_1 psenate_0 effectsenate
gen pyr2012_1 = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*1 + _b[yr2013]*yr2013) if e(sample)
gen pyr2012_0 = normal(_b[_cons] + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*0 + _b[yr2013]*yr2013) if e(sample)
gen effectyr2012 = pyr2012_1 - pyr2012_0
sum pyr2012_1 pyr2012_0 effectyr2012
sum vote_yea bvap hvap under25 over65 mdhhinc_1000 married collegeormore Citizen South senate yr2012 yr2013 if abstain==0 & party_code==1

*Model 3: Democratic legislators*
probit vote_yea black_legislator bvap hvap under25 over65 mdhhinc_1000 married collegeormore Citizen South senate yr2012 yr2013 if abstain==0 & party_code==2
predict p if e(sample)
sum p
gen pmycode = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen difference = p - pmycode
sum pmycode difference
gen pbvap_Min = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*.002 + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pbvap_Max = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*.932 + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectbvap = pbvap_Min - pbvap_Max
sum pbvap_Min pbvap_Max effectbvap
gen pover65_Min = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*.043 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pover65_Max = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*.252 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectover65 = pover65_Min - pover65_Max
sum pover65_Min pover65_Max effectover65
gen pmdhhinc_1000_Min = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*18.37 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pmdhhinc_1000_Max = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*133.62 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectmdhhinc_1000 = pmdhhinc_1000_Min - pmdhhinc_1000_Max
sum pmdhhinc_1000_Min pmdhhinc_1000_Max effectmdhhinc_1000
gen pmarried_Min = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*.159 + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pmarried_Max = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*.675 + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectmarried = pmarried_Min - pmarried_Max
sum pmarried_Min pmarried_Max effectmarried
gen pcollegeormore_Min = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*.035 + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pcollegeormore_Max = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*.84 + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectcollegeormore = pcollegeormore_Min - pcollegeormore_Max
sum pcollegeormore_Min pcollegeormore_Max effectcollegeormore
gen pCitizen_Min = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*.551355 + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pCitizen_Max = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*.9981851 + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectCitizen = pCitizen_Min - pCitizen_Max
sum pCitizen_Min pCitizen_Max effectCitizen
gen pSouth_1 = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*1 + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen pSouth_0 = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*0 + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*yr2013) if e(sample)
gen effectSouth = pSouth_1 - pSouth_0
sum pSouth_1 pSouth_0 effectSouth
gen pyr2012_1 = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*1 + _b[yr2013]*yr2013) if e(sample)
gen pyr2012_0 = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*0 + _b[yr2013]*yr2013) if e(sample)
gen effectyr2012 = pyr2012_1 - pyr2012_0
sum pyr2012_1 pyr2012_0 effectyr2012
gen pyr2013_1 = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*1) if e(sample)
gen pyr2013_0 = normal(_b[_cons] + _b[black_legislator]*black_legislator + _b[bvap]*bvap + _b[hvap]*hvap + _b[under25]*under25 + _b[over65]*over65 + _b[mdhhinc_1000]*mdhhinc_1000 + _b[married]*married + _b[collegeormore]*collegeormore + _b[Citizen]*Citizen + _b[South]*South + _b[senate]*senate + _b[yr2012]*yr2012 + _b[yr2013]*0) if e(sample)
gen effectyr2013 = pyr2013_1 - pyr2013_0
sum pyr2013_1 pyr2013_0 effectyr2013
sum vote_yea black_legislator bvap hvap under25 over65 mdhhinc_1000 married collegeormore Citizen South senate yr2012 yr2013 if abstain==0 & party_code==2

