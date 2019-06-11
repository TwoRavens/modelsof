

*tab 1*
tab country env_co if a25==2008, row
tab country env_co if a25==2017, row

tab country env_pe if a25==2008, col
tab country env_pe if a25==2017, col

* tab 2 *
tab a22

tab env_co if a25==2008
tab env_co if a25==2017
tab env_co a18 if a25==2008, column
tab env_co a18 if a25==2017, column
tab env_co a22 if a25==2008, column
tab env_co a22 if a25==2017, column
tab env_co typcom if a25==2008, column
tab env_co typcom if a25==2017, column
tab env_co gc if a25==2008, column
tab env_co gc if a25==2017, column

tab env_pe if a25==2008
tab env_pe if a25==2017
tab env_pe a18 if a25==2008, column
tab env_pe a18 if a25==2017, column
tab env_pe a22 if a25==2008, column
tab env_pe a22 if a25==2017, column
tab env_pe typcom if a25==2008, column
tab env_pe typcom if a25==2017, column
tab env_pe gc if a25==2008, column
tab env_pe gc if a25==2017, column

tab a25 env_co, row
tab a25 env_pe, row 

*tab 3*

xtset codpa
xtlogit env_co life_sad siteco sitfi i.trust gdpg3 disoc3 a18 eta ///
i.a22 i.typcom gc piigs, or i(codpa) vce(oim)
generate sample = e(sample)
sum a25 if sample==1

xtlogit env_pe life_sad siteco sitfi i.trust gdpg3 disoc3 a18 eta ///
i.a22 i.typcom gc piigs, or i(codpa) vce(oim)



