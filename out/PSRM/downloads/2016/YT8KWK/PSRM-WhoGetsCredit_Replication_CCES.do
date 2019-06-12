/*Get the Data*/
	clear
	set more off
	cd "~/Dropbox/PSRM response/Replication/"
	use "CCES2008_validated_replication.dta"


	cd "~/Dropbox/PSRM response/Replication/Results/"

	
/*Recode variables from CCES file*/

	**Create partyid
	gen partyid=CC307a
	replace partyid=4 if CC307a==8


	**Create match
	replace V535 = subinstr(V535, char(34), "",.)

	gen partymatch=0
	replace partymatch=1 if (V535=="Democratic"|V535=="Democratic-Farmer-Labor") & (partyid==1|partyid==2|partyid==3)
	replace partymatch=1 if V535=="Republican" & (partyid==5|partyid==6|partyid==7)

	gen cong_partymatch=0
	replace cong_partymatch=1 if partyid==1|partyid==2|partyid==3 

	**Demographics
	gen female=0
	replace female=1 if V208==2

	gen white=0
	replace white=1 if V211==1

	gen black=0
	replace black=1 if V211==2

	gen hispanic=0
	replace hispanic=1 if V211==3

	gen other=0
	replace other=1 if V211>=4&V211<=8

	gen income=V246
	replace income=. if V246==15

	gen educ=V213

	**Satisfied with contact, more satisfied = high scores
	gen satis=4-CC321

	**Ideological distance from rep
	gen ideo_dist_member=abs(CC317m - CC317a)
	replace ideo_dist_member=abs(CC317a-CC317k) if (V535=="Democratic"|V535=="Democratic-Farmer-Labor") & CC317m==.
	replace ideo_dist_member=abs(CC317a-CC317l) if V535=="Republican" & CC317m==.

	gen ideo_dist_party=abs(CC317a-CC317b) if (V535=="Democratic"|V535=="Democratic-Farmer-Labor")
	replace ideo_dist_party=abs(CC317a-CC317c) if V535=="Republican"


	**Recode dependent variables, high scores = higher approval

	gen rep_approval=.
	replace rep_approval=0 if CC335rep==4
	replace rep_approval=1 if CC335rep==3
	replace rep_approval=2 if CC335rep==5
	replace rep_approval=3 if CC335rep==2
	replace rep_approval=4 if CC335rep==1

	gen cong_approval=.
	replace cong_approval=0 if CC335cong==4
	replace cong_approval=1 if CC335cong==3
	replace cong_approval=2 if CC335cong==5
	replace cong_approval=3 if CC335cong==2
	replace cong_approval=4 if CC335cong==1

/*Results*/

**Ordered Probit
cd "~/Dropbox/PSRM response/Replication/Results/"

**Table A1
**Observational Models of Legislator and Institutional Approval
oprobit cong_approval i.satis b4.partyid partymatch female white black hispanic income educ 
outreg2 using Table_A1, word replace dec(2)
oprobit rep_approval i.satis b4.partyid partymatch female white black hispanic income educ
outreg2 using Table_A1, word dec(2) append

**Table A2
**Ideological distance from the rep
reg ideo_dist_member i.satis partyid partymatch female white black hispanic income educ 
outreg2 using Table_A2, word replace dec(2)
reg ideo_dist_member i.satis partyid partymatch female white black hispanic income educ if partymatch==1
outreg2 using Table_A2, word dec(2) append
reg ideo_dist_member i.satis partyid partymatch female white black hispanic income educ if partymatch==0
outreg2 using Table_A2, word dec(2) append



**Table A3
**Ideological distance from the party
reg ideo_dist_party i.satis partyid partymatch female white black hispanic income educ 
outreg2 using Table_A3, word replace dec(2)
reg ideo_dist_party i.satis partyid partymatch female white black hispanic income educ if partymatch==1
outreg2 using Table_A3, word dec(2) append
reg ideo_dist_party i.satis partyid partymatch female white black hispanic income educ if partymatch==0
outreg2 using Table_A3, word dec(2) append

