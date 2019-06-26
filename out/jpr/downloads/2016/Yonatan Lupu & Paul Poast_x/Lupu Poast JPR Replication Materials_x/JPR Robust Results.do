clear all
set more off
set mem 500m
set mat 800

use "K-adic Nonaggression Robust Data", clear

** Generate Results for Table A.I Column (1)
stcox prop_rival_endL nummem prop_mid total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s Russia China

** Generate Results for Table A.I Column (2)
stcox prop_rival_endH nummem prop_mid total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s Russia China

** Generate Results for Table A.I Column (3)
stcox prop_rival_end nummem prop_mid total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s Russia China prop_prevpact

** Generate Results for Table A.I Column (4) 
stcox prop_rival_end nummem prop_mid total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s Russia China if nummem<6

** Generate Results for Table A.II
stcox prop_rival_end if duplicate_kad_members==0
stcox prop_rival_end nummem prop_mid if duplicate_kad_members==0
stcox prop_rival_end nummem prop_mid Russia China if duplicate_kad_members==0
stcox prop_rival_end nummem prop_mid Russia China total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s if duplicate_kad_members==0

** Generate Results for Table A.III
use "Dyadic Nonaggression Robust Data", clear
stcox prop_rival_end
stcox prop_rival_end prop_mid
stcox prop_rival_end prop_mid Russia China
stcox prop_rival_end prop_mid  Russia China total_cinc total_cinc_square kad_max_distance max_pol_dif min_pol average_s


