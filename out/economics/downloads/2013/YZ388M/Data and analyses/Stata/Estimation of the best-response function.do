********************************************
* Estimation of the best-response function *
********************************************

* input data

input byte first byte second
 3	11
 4	10
 5	10
 6	 9
 7	 8
 8	 8
 9	 8
10	 7
11	 7
12	 6
13	 6
14	 5
15	 5
end

* ordinary least squares estimation of the best-response function

regress second first

* clear data

clear
