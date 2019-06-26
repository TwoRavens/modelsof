* Framing Consensus "Do-File"
sysuse framing-consensus, clear

regress withdraw J G
regress divide J G
regress agree J G
regress bestarg J G

regress withdraw J G if s==1
regress divide J G if s==1
regress agree J G if s==1
regress bestarg J G if s==1

regress withdraw J G if h==1
regress divide J G if h==1
regress agree J G if h==1
regress bestarg J G if h==1

regress withdraw J G if e==1
regress divide J G if e==1
regress agree J G if e==1
regress bestarg J G if e==1

regress withdraw J WB if sd==1
regress divide J WB if sd==1
regress agree J WB if sd==1
regress bestarg J WB if sd==1

regress withdraw h e sd
regress divide h e sd
regress agree h e sd
regress bestarg h e sd

regress withdraw s e sd if J==1
regress divide s e sd if J==1
regress agree s e sd if J==1
regress bestarg s e sd if J==1

regress withdraw h e sd if G==1
regress divide h e sd if G==1
regress agree h e sd if G==1
regress bestarg h e sd if G==1

regress withdraw h e sd if WB==1
regress divide h e sd if WB==1
regress agree h e sd if WB==1
regress bestarg h e sd if WB==1
