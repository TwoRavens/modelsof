///Moore, Selling to Both Sides, International Interactions, Replication .do file

///use file "moore selling to both sides Internaitonal Interactions.dta"


///Model 1
regress  lnbdb  lnduration lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar

///Model 2
regress  lnbdb   lstarmimp lrarmimp lnduration lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar if sipricomp==1 &  conflict_name!="Vietnam War"

///Model 3
regress  lnbdb   lstarmimp5 lrarmimp5 lnduration lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar if sipricomp==1 &  conflict_name!="Vietnam War"

///Model 4
regress  lnbdb   lstarmimp lrarmimp lnduration lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar intervention  if sipricomp==1 &  conflict_name!="Vietnam War"

///Model 5
regress  lnbdb   lstarmimp5 lrarmimp5 lnduration lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar intervention  if sipricomp==1 &  conflict_name!="Vietnam War"

///model 6
stcox lstarmimp  lrarmimp lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar if sipricomp==1 & viet!=1, nohr

///model 7
stcox lstarmimp5  lrarmimp5 lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar if sipricomp==1 & viet!=1, nohr

///model 8
stcox lstarmimp  lrarmimp lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar intervention   if sipricomp==1 & viet!=1, nohr

///model 9
stcox lstarmimp5  lrarmimp5 lnpop lnmilqual lngdp cw lnmountain democ  ethnicpolar relpolar intervention   if sipricomp==1 & viet!=1, nohr






