******************
****Load Data*****
******************

use PersonalityCampaignsPB, clear

******************
*****Table 1******
******************

tab partyid if staff !=.
tab staff
tab inc	if staff !=.
tab seattype if staff!=.
tab seatgsh if staff !=.
tab female if staff !=.
tab experiencere if staff!=.
tab wonprimary
*Note: primaryvote share excluded to for purposes of removing identifying information*


******************
*****Table 2******
******************

sum bfiagreeable, detail
sum bfiextraversion, detail
sum bficons, detail
sum bfineuro, detail
sum bfiopen, detail


******************
*****Table 4******
******************

reg negativity bfiagreeable bfiextraversion bficons bfineuro bfiopen 
reg negativity bfiagreeable bfiextraversion bficons bfineuro bfiopen i.white female ib2.staff experiencere i.partyid inc 
reg negativity bfiagreeable bfiextraversion bficons bfineuro bfiopen if partyid!=0 
reg negativity bfiagreeable bfiextraversion bficons bfineuro bfiopen i.white female ib2.staff experiencere i.partyid inc if partyid!=0	

******************
*****Table 5******
******************

reg negativity bfiagreeable bfiextraversion bficons bfineuro bfiopen 
	margins, at (bfiextraversion=(2.8(.2)4.7)) atmeans
	margins, at (bfiagreeable=(3.0(.2)4.5)) atmeans
	margins, at (bficons=(3.5(.2)5.1)) atmeans
	margins, at (bfineuro=(1.4(.2)3.2)) atmeans
	margins, at (bfiopen=(2.9(.2)4.5)) atmeans
	
******************
*****Table 6******
******************

reg unethical bfiagreeable bfiextraversion bficons bfineuro bfiopen 
reg unethical bfiagreeable bfiextraversion bficons bfineuro bfiopen i.white female ib2.staff experiencere i.partyid inc 
reg unethical bfiagreeable bfiextraversion bficons bfineuro bfiopen if partyid!=0
reg unethical bfiagreeable bfiextraversion bficons bfineuro bfiopen i.white female ib2.staff experiencere i.partyid inc if partyid!=0	

******************
*****Table 7******
******************

reg unethical bfiagreeable bfiextraversion bficons bfineuro bfiopen 
	margins, at (bfiextraversion=(2.8(.2)4.7)) atmeans
	margins, at (bfiagreeable=(3.0(.2)4.5)) atmeans
	margins, at (bficons=(3.5(.2)5.1)) atmeans
	margins, at (bfineuro=(1.4(.2)3.2)) atmeans
	margins, at (bfiopen=(2.9(.2)4.5)) atmeans
	
	
******************
*****Table A.1****
******************

mlogit staff bfiagreeable bfiextraversion bficons bfineuro bfiopen, b(2)

******************
****Table A.2*****
******************

logit thirdparty bfiagreeable bfiextraversion bficons bfineuro bfiopen

******************
****Table A.3*****
******************

logit typeofad bfiagreeable bfiextraversion bficons bfineuro bfiopen aheadbehind
logit typeofad bfiagreeable bfiextraversion bficons bfineuro bfiopen aheadbehind i.white female experiencere i.partyid inc 
logit typeofad bfiagreeable bfiextraversion bficons bfineuro bfiopen aheadbehind if partyid!=0
logit typeofad bfiagreeable bfiextraversion bficons bfineuro bfiopen aheadbehind i.white female experiencere i.partyid inc if partyid!=0
