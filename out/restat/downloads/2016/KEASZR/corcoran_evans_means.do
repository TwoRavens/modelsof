clear
use balanced_panel
gen black_students=int(black*enroll_f33)
gen white_students=int((1-(nonwhite/100))*enroll_f33)
sort year
by year: sum expp_co [fw=black_students]
by year: sum expp_co [fw=white_students]
desc