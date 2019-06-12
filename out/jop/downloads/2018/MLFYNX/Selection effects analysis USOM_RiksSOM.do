use "USOM_RiksSOM.dta", clear

recode ti_cpi (0/3.99=1) (4/6.99=2) (7/10.99=3), gen(cpi33)

tab swede
tab1 sex alder4 utb civil barn klarinc polintr frtpol pvalriks VH swd occup2 if swede==0
tab1 sex alder4 utb civil barn klarinc polintr frtpol pvalriks VH swd occup2 if swede==1
tab1 sex alder4 utb civil barn klarinc polintr frtpol pvalriks VH swd occup2 if swede==1 & cpi33==1
tab1 sex alder4 utb civil barn klarinc polintr frtpol pvalriks VH swd occup2 if swede==1 & cpi33==2
tab1 sex alder4 utb civil barn klarinc polintr frtpol pvalriks VH swd occup2 if swede==1 & cpi33==3
