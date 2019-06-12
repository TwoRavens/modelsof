clear
cd "~/Dropbox/after ISQ - nowhere to go/replication files/replication file for figures/Table A7 and Figure A2"
import delimited "moore_toreplicate.csv"
destring ccode-lag_ref, replace force

*Table A7
zinb refugees deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp  gdppc_weighted lag_ref, inflate(deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp gdppc_weighted lag_ref)
zinb refugees deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp  gdppc_weighted lag_ref, inflate(deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp gdppc_weighted lag_ref) cluster(ccode)
zinb refugees deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp  polity_weighted lag_ref, inflate(deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp polity_weighted lag_ref)
zinb refugees deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp  polity_weighted lag_ref, inflate(deathmag violdissent civwar waronter ptssd dem_aut trans bothgnp polity_weighted lag_ref) cluster(ccode)
