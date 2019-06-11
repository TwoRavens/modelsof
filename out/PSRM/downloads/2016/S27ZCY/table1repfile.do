**.do file for replicating Gibler and Little (2016)
**"Heterogeneity in the Militarized Interstate Disputes (MIDs), 1816-2001: What Fatal MIDs Cannot Fix"
**Political Science Research and Methods
**
**
**
**replication commands for Table 1
**
**
**column 1, all MIDs, 1901-2001
logit cwmid i.contiguous allied i.majormin cap_ratio i.jointdem i.jointaut peace_years* if year>1900&year<2002, cluster(dyad)

**column 2, fatal MIDs only, 1901-2001
logit fatal i.contiguous allied i.majormin cap_ratio i.jointdem i.jointaut peace_years* if year>1900&year<2002, cluster(dyad)

**column 3, protest-dependent MIDs only, 1901-2001
logit protestd i.contiguous allied i.majormin cap_ratio i.jointdem i.jointaut peace_years* if year>1900&year<2002, cluster(dyad)

**column 4, all MIDs except protest-dependent cases, 1901-2001
logit cwmid_no i.contiguous allied i.majormin cap_ratio i.jointdem i.jointaut peace_years* if year>1900&year<2002, cluster(dyad)



