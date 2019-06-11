
****************************************************

use DataAwards.dta, clear

*Initial author code to prepare data

encode community, generate(community1)
encode phone, generate(phone1)
encode emailcomm, generate(email1)
encode namecomm, generate(name1)
encode namepres, generate(namepres1)
encode nameadmin, generate(nameadmin1)
encode address, generate(address1)

***Generate dependent variables
generate workedon = 1
encode end, gen(end1)
replace workedon = . if end1 ==.
bysort id: egen NoComm = count(workedon)

**generate number of points 
bysort id: egen Points = sum(points)

**Estimate amount of time worked: time between between opening of first data entry screen of first person in the session till closing of last data entry screen of last person per session

   bysort session: egen sessionstart = min(timeworkstart)
   bysort session: egen sessionend = max(timeworkend)
   generate timesession = sessionend - sessionstart
   generate timesession_m = mm(timesession)
   generate timesession_h = hh(timesession)
   generate timesession_h_m = timesession_h * 60
   generate sessionlength_min = timesession_h_m + timesession_m

**productivity 
 generate Prod_Comm = NoComm/sessionlength_min
generate Prod_Points = Points/sessionlength_min

**number of names filled 

egen NoNonMissNames = rownonmiss (name1 nameadmin1)
bysort id: egen NoMissNames = sum(NoNonMissNames)

***Quality: quality rating; 0: correct; 4: good alternative is provided with a comment; 1: wrong spelling; 2: no entry; 3: wrong information 

generate addresscorrect = 0
replace addresscorrect = 1 if qualityadress == 0 | qualityadress == 4
generate commnamecorrect = 0
replace commnamecorrect = 1 if qualitycomm == 0 | qualitycomm == 4
generate phonecorrect = 0
replace phonecorrect = 1 if qualityphone == 0 | qualityphone == 4
generate emailcorrect = 0
replace emailcorrect = 1 if qualityemail == 0 | qualityemail == 4
generate correctname = 0
replace correctname = 1 if qualitybezeichnung == 0 | qualitybezeichnung == 4
generate prescorrect = 0
replace prescorrect = 1 if qualitypres == 0 | qualitypres == 4
generate admincorrect = 0
replace admincorrect = 1 if qualityadmin == 0 | qualityadmin == 4

egen PercCorrectPerLine = rowmean(addresscorrect  commnamecorrect phonecorrect emailcorrect correctname prescorrect admincorrect)

desc id treatment session end  concentration experiencedatabase touchtype Prod_Comm Prod_Points PercCorrectPerLine code
encode session, generate(session1)
collapse id treatment session1 end1  concentration experiencedatabase touchtype Prod_Comm Prod_Points PercCorrectPerLine, by(code)

generate award = 0
replace award = 1 if treatment == 5
drop if treatment == 2 
*Not used in any regression in paper

*Reproducing tables - exactly their prep code and execution code, but some discrepancies

*Table 2 - Small errors in coefficients and standard errors in 4th column (more than rounding errors)
reg Prod_Comm award if treatment!=2, cluster(session1)
reg Prod_Comm award touchtype experiencedatabase concentration if treatment!=2, cluster(session1)
reg Prod_Points award if treatment!=2, cluster(session1)
reg Prod_Points award touchtype experiencedatabase concentration  if treatment!=2 , cluster(session1)

foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		reg `Y' award `specification' if treatment !=2, cluster(session1)
		}
	}

*Table 3  

*No coef & s.e. reported, so don't analyze these.

save DatKN, replace
	
