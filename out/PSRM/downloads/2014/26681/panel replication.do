use "panel replication data.dta"

*Table 3
sum chall_increase100  movement votes1 qual_d delta_chall_adj_10000  extremity open1

*Table 4
*Model 1
reg  chall_increase100  movement,cl(cl1)
*Model 2
reg  chall_increase100  movement rep98 rep96 dem98 rep02 dem02 rep04 dem04,cl(cl1)
*Model 3
reg  chall_increase100 movement delta_chall_adj_10000 open1 extremity qual_ votes1_  ,cl(cl1)
*Model 4
reg  chall_increase100 movement delta_chall_adj_10000 open1 extremity qual_ votes1_ rep98 rep96 dem98 rep02 dem02 rep04 dem04,cl(cl1)



*Table 5, repeat
reg  chall_increase100 movement delta_chall_adj_10000 extremity  votes1_ open1 rep98 rep96 dem98 rep02 dem02 rep04 dem04 if repeat==1,cl(cl1)
*Table 5, model 1
reg  chall_increase100 movement votes1 delta_chall_adj_10000 extremity qual_ open1 rep98 rep96 dem98 rep02 dem02 rep04 dem04 if votes1>45,cl(cl1)
*Table 5, model 2
reg  chall_increase100 movement votes1 delta_chall_adj_10000 extremity qual_ open1 rep98 rep96 dem98 rep02 dem02 rep04 dem04 if votes1>40,cl(cl1)
*Table 5, model 3
reg  chall_increase100 movement votes1 delta_chall_adj_10000 extremity qual_ open1 rep98 rep96 dem98 rep02 dem02 rep04 dem04 if votes1>35,cl(cl1)
*Table 5, model 4
reg  chall_increase100 movement votes1 delta_chall_adj_10000 extremity qual_ open1 rep98 rep96 dem98 rep02 dem02 rep04 dem04 if votes1>30,cl(cl1)

