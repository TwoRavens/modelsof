*Using data file: "MEVMLB_DATA_TABLE1.dta"
xtset country time
xtreg voteswoninc votesinclag gdpgrowthlag winstability tradegdp  if electionround==1, re
xtreg voteswoninc votesinclag gdpgrowthlag winstability tradegdp  if electionround==2, re
