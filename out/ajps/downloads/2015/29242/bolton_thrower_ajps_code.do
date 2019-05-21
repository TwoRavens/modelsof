***Table 1: The Effect of Divided Government on Executive Orders***

*Period 1*
nbreg allnoncerm_eo divided inflation spending_percent_gdp war lame_duck administration_change trend tr taft wilson harding coolidge hoover fdr if year > 1904 & year < 1945, dispersion(mean) vce(cluster president)

*Period 2*
nbreg allnoncerm_eo divided inflation spending_percent_gdp war lame_duck administration_change trend truman ike jfk lbj nixon ford carter reagan bush41 clinton bush43 obama if year > 1944, dispersion(mean) vce(cluster president)



***Table 2: The Effect of Congressional Fragmentation on Executive Orders***

*Period 1*
nbreg allnoncerm_eo divided averagemajsize inflation spending_percent_gdp war lame_duck administration_change trend tr taft wilson harding coolidge hoover fdr if year > 1904 & year < 1945, dispersion(mean) vce(cluster president)

*Period 2*
nbreg allnoncerm_eo divided averagemajsize inflation spending_percent_gdp war lame_duck administration_change trend truman ike jfk lbj nixon ford carter reagan bush41 clinton bush43 obama if year > 1944, dispersion(mean) vce(cluster president)



***Table 3: The Effect of Legislative Capacity on Executive Orders***

*Legislative Expenditures*
nbreg allnoncerm_eo c.lnlegexp##divided inflation spending_percent_gdp war lame_duck administration_change trend postlra tr taft wilson harding coolidge hoover fdr truman ike jfk lbj nixon ford carter reagan bush41 clinton bush43 obama if (year > 1904), dispersion(mean) vce(cluster president)

*Committee Staff Size*
nbreg allnoncerm_eo c.lncommtot1##divided inflation spending_percent_gdp war lame_duck administration_change trend postlra tr taft wilson harding coolidge hoover fdr truman ike jfk lbj nixon ford carter reagan bush41 clinton bush43 obama if (year > 1904), dispersion(mean) vce(cluster president)
