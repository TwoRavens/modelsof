*Replication Do File For "Regressive Socioeconomic Distribution and Democratic Survival"

*set the data for event history analysis

stset  count, failure(break=1) id(episode)

*Model 1

streg lnlevel necon pres tag rel ethn prevdem openc , dist(weib) nohr time cluster(ccode)

*Model 2

streg  calinv lnlevel  calileve necon pres tag rel ethn prevdem openc , dist(weib) nohr time cluster(ccode)

*Model 3

streg  calinv2 lnlevel   cali2lev necon pres tag rel ethn prevdem openc , dist(weib) nohr time cluster(ccode)
