	clear
	cd "Yourpath"


	************************************
	* (A) GENERAL SETTINGS
	************************************


	local donors 		Bern  Luzern 	Uri Schwyz  Obwalden Nidwalden Zug  Freiburg Solothurn Basel-Stadt Basel-Landschaft Wallis Neuenburg Genf
	local donors_short	BE 	  LU 	UR  SZ			OW		 NW		   ZG	FR		 SO		  BS		  BS			    VS	   NE		 GE
	local donor_weights 0.285 0.116 0   0.078 		0.268	 0		   0	0	 	 0		  0 		  0			        0	   0 		 0.252	 

	matrix table2=J(26,8,.)
	matlist table2

	************************************
	* (B) FEDERAL ELECTIONS
	************************************

	use data3.dta, clear

	* (i) Generate id for donors based on list above

	gen id_donor=.

	local count=1
	foreach donor of local donors{ 
	replace id_donor=`count' if canton=="`donor'"
	local count=`count'+1
	}

	* (ii) Control group: Generate means and std of mean for pretreatment period

	local mean_participation=0
	local mean_participation_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum participation if id_donor==`count' & inrange(year,1900,1924)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_participation_var'
	if `donor_weight'!=0{
	local mean_participation=`mean_participation'+`donor_weight'*`mean' 
	local mean_participation_var=`mean_participation_var'+`donor_weight'^2*`var'
	}
	display `mean_participation'
	display `mean_participation_var'

	local count=`count'+1
	}

	local mean_participation_se=sqrt(`mean_participation_var')


	matrix table2[1,2]=`mean_participation'
	matrix table2[2,2]=`mean_participation_se'
	matlist table2

	* (iii) Control group: Generate means and std of mean for treatment period

	local mean_participation=0
	local mean_participation_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum participation if id_donor==`count' & inrange(year,1924,1940) | id_donor==`count' & inrange(year,1946,1948)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_participation_var'
	if `donor_weight'!=0{
	local mean_participation=`mean_participation'+`donor_weight'*`mean' 
	local mean_participation_var=`mean_participation_var'+`donor_weight'^2*`var' 
	}
	display `mean_participation'
	display `mean_participation_var'

	local count=`count'+1
	}

	local mean_participation_se=sqrt(`mean_participation_var')

	matrix table2[3,2]=`mean_participation'
	matrix table2[4,2]=`mean_participation_se'
	matlist table2


	* (iv) Control group: Generate means and std of mean for elections concurrent with federal referendums

	local mean_participation=0
	local mean_participation_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum participation if id_donor==`count' & year==1925
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_participation_var'
	if `donor_weight'!=0{
	local mean_participation=`mean_participation'+`donor_weight'*`mean' 
	local mean_participation_var=`mean_participation_var'+`donor_weight'^2*`var'
	}
	display `mean_participation'
	display `mean_participation_var'

	local count=`count'+1
	}

	local mean_participation_se=sqrt(`mean_participation_var')


	matrix table2[5,2]=`mean_participation'
	matrix table2[6,2]=`mean_participation_se'
	matlist table2

	* (v) Control group: Generate means and std of mean for elections NOT concurrent with federal referendums

	local mean_participation=0
	local mean_participation_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum participation if id_donor==`count' & inrange(year,1926,1940) | id_donor==`count' & inrange(year,1946,1948)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_participation_var'
	if `donor_weight'!=0{
	local mean_participation=`mean_participation'+`donor_weight'*`mean' 
	local mean_participation_var=`mean_participation_var'+`donor_weight'^2*`var' 
	}
	display `mean_participation'
	display `mean_participation_var'

	local count=`count'+1
	}


	local mean_participation_se=sqrt(`mean_participation_var')
	matrix table2[7,2]=`mean_participation'
	matrix table2[8,2]=`mean_participation_se'
	matlist table2

	* (vi) Control group: Generate means and std of mean for post-treatment period

	local mean_participation=0
	local mean_participation_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum participation if id_donor==`count' & inrange(year,1949,1970) 
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_participation_se'
	if `donor_weight'!=0{
	local mean_participation=`mean_participation'+`donor_weight'*`mean' 
	local mean_participation_var=`mean_participation_var'+`donor_weight'^2*`var' 
	}
	display `mean_participation'
	display `mean_participation_var'

	local count=`count'+1
	}


	* (vii) Vaud: Generate means and std of mean for all periods


	sum participation if canton=="Waadt" & inrange(year,1900,1924) // pre-treatment
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[1,1]=`mean'
	matrix table2[2,1]=`se'
	matrix table2[1,4]=r(N)

	sum participation if canton=="Waadt" & inrange(year,1925,1940)  | canton=="Waadt" & inrange(year,1946,1948) // treatment
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[3,1]=`mean'
	matrix table2[4,1]=`se'
	matrix table2[3,4]=r(N)

	sum participation if canton=="Waadt" & year==1925 // treatment period and concurrent
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[5,1]=`mean'
	matrix table2[6,1]=`se'
	matrix table2[5,4]=r(N)

	sum participation if canton=="Waadt" & inrange(year,1926,1940)  | canton=="Waadt" & inrange(year,1946,1948) // treatment period and not concurrent
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[7,1]=`mean'
	matrix table2[8,1]=`se'
	matrix table2[7,4]=r(N)



	* (viii) Before and after tests

	//matrix table2[1,6]=(table2[1,1]-table2[1,2])/(sqrt(table2[1,1]^2+table2[1,2]^2))


	matrix table2[3,3]=(table2[3,1]-table2[3,2])-(table2[1,1]-table2[1,2]) // full treatment period: DID
	matrix table2[4,3]=sqrt(table2[2,1]^2+table2[2,2]^2+table2[4,1]^2+table2[4,2]^2) // SE

	matrix table2[5,3]=(table2[5,1]-table2[5,2])-(table2[1,1]-table2[1,2]) // full treatment period: DID for concurrent
	matrix table2[6,3]=sqrt(table2[2,1]^2+table2[2,2]^2+table2[6,1]^2+table2[6,2]^2) // SE

	matrix table2[7,3]=(table2[7,1]-table2[7,2])-(table2[1,1]-table2[1,2]) // full treatment period: DID for non-concurrent
	matrix table2[8,3]=sqrt(table2[2,1]^2+table2[2,2]^2+table2[8,1]^2+table2[8,2]^2) // SE



	************************************
	* (C) CANTONAL REFERENDUMS
	************************************

	use data4.dta, clear

	* (i) Generate id for donors based on list above

	gen id_donor=.

	local count=1
	foreach donor of local donors_short{ 
	replace id_donor=`count' if kkurz=="`donor'"
	local count=`count'+1
	}

	* (ii) Control group: Generate means and std of mean for pretreatment period


	local mean_turnout=0
	local mean_turnout_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum turnout if id_donor==`count' & inrange(year,1900,1924)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_turnout_var'
	if `donor_weight'!=0{
	local mean_turnout=`mean_turnout'+`donor_weight'*`mean' 
	local mean_turnout_var=`mean_turnout_var'+`donor_weight'^2*`var' 
	}
	display `mean_turnout'
	display `mean_turnout_var'

	local count=`count'+1
	}

	local mean_turnout_se=sqrt(`mean_turnout_var')


	matrix table2[11,2]=`mean_turnout'
	matrix table2[12,2]=`mean_turnout_se'
	matlist table2

	* (iii) Control group: Generate means and std of mean for treatment period

	local mean_turnout=0
	local mean_turnout_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum turnout if id_donor==`count' & inrange(year,1924,1940) | id_donor==`count' & inrange(year,1946,1948)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_turnout_var'
	if `donor_weight'!=0{
	local mean_turnout=`mean_turnout'+`donor_weight'*`mean' 
	local mean_turnout_var=`mean_turnout_var'+`donor_weight'^2*`var'
	}
	display `mean_turnout'
	display `mean_turnout_var'

	local count=`count'+1
	}

	local mean_turnout_se=sqrt(`mean_turnout_var')


	matrix table2[13,2]=`mean_turnout'
	matrix table2[14,2]=`mean_turnout_se'
	matlist table2


	* (iv) Control group: Generate means and std of mean for referendums concurrent with federal referendums

	local mean_turnout=0
	local mean_turnout_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum turnout if id_donor==`count' & inrange(year,1926,1940)  & concurrent==1 | id_donor==`count' & inrange(year,1946,1948) & concurrent==1
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_turnout_var'
	if `donor_weight'!=0{
	local mean_turnout=`mean_turnout'+`donor_weight'*`mean' 
	local mean_turnout_var=`mean_turnout_var'+`donor_weight'^2*`var'
	}
	display `mean_turnout'
	display `mean_turnout_var'

	local count=`count'+1
	}

	local mean_turnout_se=sqrt(`mean_turnout_var')

	matrix table2[15,2]=`mean_turnout'
	matrix table2[16,2]=`mean_turnout_se'
	matlist table2

	* (v) Control group: Generate means and std of mean for elections NOT concurrent with federal referendums

	local mean_turnout=0
	local mean_turnout_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum turnout if id_donor==`count' & inrange(year,1926,1940)  & concurrent==0 | id_donor==`count' & inrange(year,1946,1948) & concurrent==0
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_turnout_var'
	if `donor_weight'!=0{
	local mean_turnout=`mean_turnout'+`donor_weight'*`mean' 
	local mean_turnout_var=`mean_turnout_var'+`donor_weight'^2*`var'
	}
	display `mean_turnout'
	display `mean_turnout_var'

	local count=`count'+1
	}

	local mean_turnout_se=sqrt(`mean_turnout_var')


	matrix table2[17,2]=`mean_turnout'
	matrix table2[18,2]=`mean_turnout_se'
	matlist table2



	* (vii) Vaud: Generate means and std of mean for all periods

	sum turnout if kkurz=="VD" & inrange(year,1900,1924) // pre-treatment
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[11,1]=`mean'
	matrix table2[12,1]=`se'
	matrix table2[11,4]=r(N)

	sum turnout if kkurz=="VD" & inrange(year,1925,1940)  | kkurz=="VD" & inrange(year,1946,1948) // treatment
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[13,1]=`mean'
	matrix table2[14,1]=`se'
	matrix table2[13,4]=r(N)

	sum turnout if kkurz=="VD" & inrange(year,1925,1940) & concurrent==1 | kkurz=="VD" & inrange(year,1946,1948) & concurrent==1 // treatment period and concurrent

	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[15,1]=`mean'
	matrix table2[16,1]=`se'
	matrix table2[15,4]=r(N)

	sum turnout if kkurz=="VD" & inrange(year,1925,1940) & concurrent==0 | kkurz=="VD" & inrange(year,1946,1948) & concurrent==0 // treatment period and not concurrent

	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[17,1]=`mean'
	matrix table2[18,1]=`se'
	matrix table2[17,4]=r(N)




	* (viii) Before and after tests

	matrix table2[13,3]=(table2[13,1]-table2[13,2])-(table2[11,1]-table2[11,2]) // full treatment period: DID
	matrix table2[14,3]=sqrt(table2[12,1]^2+table2[12,2]^2+table2[14,1]^2+table2[14,2]^2) // SE

	matrix table2[15,3]=(table2[15,1]-table2[15,2])-(table2[11,1]-table2[11,2]) // full treatment period: DID for concurrent
	matrix table2[16,3]=sqrt(table2[12,1]^2+table2[12,2]^2+table2[16,1]^2+table2[16,2]^2) // SE

	matrix table2[17,3]=(table2[17,1]-table2[17,2])-(table2[11,1]-table2[11,2]) // full treatment period: DID for non-concurrent
	matrix table2[18,3]=sqrt(table2[12,1]^2+table2[12,2]^2+table2[18,1]^2+table2[18,2]^2) // SE



	************************************
	* (D) PETITIONS
	************************************

	use data5.dta, clear

	gen petitions_rel=unt_kt/unt_ch*100


	* (i) Generate id for donors based on list above

	gen id_donor=.

	local count=1
	foreach donor of local donors_short{ 
	replace id_donor=`count' if kkurz=="`donor'"
	local count=`count'+1
	}
	* (ii) Control group: Generate means and std of mean for pretreatment period

	local mean_petitions_rel=0
	local mean_petitions_rel_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum petitions_rel if id_donor==`count' & inrange(year,1900,1924)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_petitions_rel_se'
	if `donor_weight'!=0{
	local mean_petitions_rel=`mean_petitions_rel'+`donor_weight'*`mean' 
	local mean_petitions_rel_var=`mean_petitions_rel_var'+`donor_weight'^2*`var'
	}
	display `mean_petitions_rel'
	display `mean_petitions_rel_var'

	local count=`count'+1
	}

	local mean_petitions_rel_se=sqrt(`mean_petitions_rel_var')
	matrix table2[21,2]=`mean_petitions_rel'
	matrix table2[22,2]=`mean_petitions_rel_se'
	matlist table2

	* (iii) Control group: Generate means and std of mean for treatment period

	local mean_petitions_rel=0
	local mean_petitions_rel_var=0

	local count=1
	foreach donor_weight of local donor_weights{ 
	sum petitions_rel if id_donor==`count' & inrange(year,1924,1940) | id_donor==`count' & inrange(year,1946,1948)
	local mean=r(mean)
	local var=r(sd)^2/r(N)

	display `mean_petitions_rel_var'
	if `donor_weight'!=0{
	local mean_petitions_rel=`mean_petitions_rel'+`donor_weight'*`mean' 
	local mean_petitions_rel_var=`mean_petitions_rel_var'+`donor_weight'^2*`var' 
	}
	display `mean_petitions_rel'
	display `mean_petitions_rel_se'

	local count=`count'+1
	}


	local mean_petitions_rel_se=sqrt(`mean_petitions_rel_var')
	matrix table2[23,2]=`mean_petitions_rel'
	matrix table2[24,2]=`mean_petitions_rel_se'
	matlist table2



	* (iv) Vaud: Generate means and std of mean for treatment period

	sum petitions_rel if kkurz=="VD" & inrange(year,1900,1924) // pre-treatment
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[21,1]=`mean'
	matrix table2[22,1]=`se'
	matrix table2[21,4]=r(N)

	sum petitions_rel if kkurz=="VD" & inrange(year,1925,1940)  | kkurz=="VD" & inrange(year,1946,1948) // treatment
	local mean=r(mean)
	local se=sqrt(r(sd)^2/r(N))
	matrix table2[23,1]=`mean'
	matrix table2[24,1]=`se'
	matrix table2[23,4]=r(N)



	* (viii) Before and after tests

	matrix table2[23,3]=(table2[23,1]-table2[23,2])-(table2[21,1]-table2[21,2]) // full treatment period: DID
	matrix table2[24,3]=sqrt(table2[22,1]^2+table2[22,2]^2+table2[24,1]^2+table2[24,2]^2) // SE




	************************************
	* (E) EXPORT TABLE
	************************************

		matrix colnames table2 = "Vaud"  "Synthetic_aud" "DiD" "N" //"t_value_after-before" "t_value_treated-synthetic" 
		matrix rownames table2 =  "Pre-Treatment_(1900-1924)" "_" "Treatment_(1925-1949)" "_" "concurrent_with_fed_refs" "_"  "non_concurrent_with_fed_refs" "_"  ""	"_" "Pre-Treatment_(1900-1924)" "_" "Treatment_(1925-1949)" "_" "concurrent_with_fed_refs" "_"  "non_concurrent_with_fed_refs" "_"  "" "_" "Pre-Treatment_(1900-1924)" "_" "Treatment_(1925-1949)"  "_"  "" "_" 
		outtable using table2, mat(table2) ///
		replace center nobox f(%9.2f %9.2f %9.2f %9.0f %9.2f %9.2f ) 

