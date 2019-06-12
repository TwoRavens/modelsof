****************************************************************
**  Stata command file that                                   **
**  produces results described in footnote 10 of              **
**  Lewis & King (1999) "No Evidence on Directional           **
**    Versus Proximity Voting", _Political_Analysis_ 8(1)     **
****************************************************************

version 6.0
drop _all
infile using lewisking_fn10

ren VCF0843 vdef
ren VCF0841 vussr
ren VCF0834 vera
ren VCF0830 vmaid  
ren VCF0806 vghins
ren VCF0839 vgserv
ren VCF0809 vggjob
ren VCF0803 vlc

ren VCF9081 cdefd
ren VCF9082 cussrd
ren VCF9083 cerad
ren VCF9084 cmaidd
ren VCF9085 cghinsd
ren VCF9086 cgservd 
ren VCF9087 cggjobd
ren VCF9088 clcd

ren VCF9089 cdefr
ren VCF9090 cussrr
ren VCF9091 cerar
ren VCF9092 cmaidr
ren VCF9093 cghinsr
ren VCF9094 cgservr 
ren VCF9095 cggjobr 
ren VCF9096 clcr 

ren VCF0424 ftd
ren VCF0426 ftr

ren VCF0004 year

drop if year < 1972
keep ft* v* c* year
gen index = _n

reshape long ft cdef cussr cera cmaid cghins cgserv cggjob clc, i(index) j(party d r)

replace ft=. if ft>96
for var v* c*: replace X = . if X==0 | X>7
for var v* c*: replace X = X - 4

local cand  "cdef cussr cera cmaid cghins cgserv cggjob clc"
local voter "vdef vussr vera vmaid vghins vgserv vggjob vlc"
local issue "def ussr era maid ghins gserv ggjob lc"

for var `cand' `voter': gen sX2 = X^2
for any `issue': gen spX = cX*vX*2
for any `issue': reg ft spX svX2 scX2
reg ft splc sclc2 svlc2 /*
    */ spggjob svggjob2 scggjob2       

 
