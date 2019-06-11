**Balance Tests**
	hotelling pastvotepct, by (sentAB )
	hotelling hhsize, by (sentAB )
	hotelling female, by (sentAB )

**Basic T-Tests*
	*Voted*
	reg votedinspecial sentAB, cluster (householdid)
	reg votedinspecial sentAB if version !=2, cluster (householdid)		
	reg votedinspecial sentAB if version !=3, cluster (householdid)
	
	*Voted absentee*
	reg votedabsentee sentAB, cluster (householdid)
	reg votedabsentee sentAB if version !=2, cluster (householdid)
	reg votedabsentee sentAB if version !=3, cluster (householdid)
	
**Models for Table 2 (and appendix)**

reg votedabsentee i.version, cluster (householdid )
reg votedabsentee i.version pastvotepct hhsize female, cluster (householdid )
reg votedabsentee sentAB pastvotepct hhsize female, cluster (householdid )
reg votedabsentee sentAB, cluster (householdid )
reg votedinspecial i.version, cluster (householdid )
reg votedinspecial sentAB, cluster (householdid )
reg votedinspecial i.version pastvotepct hhsize female, cluster (householdid )
reg votedinspecial sentAB pastvotepct hhsize female, cluster (householdid )
