/* "Perceptions of Foreign Aid Project Quality in Bangladesh" */
/* Matthew S. Winters, Simone Dietrich, and Minhaj Mahmud */
/* Research and Politics */
/* Replication File */
/* August 2017 */

/*********************/
/* List of Variables */
/*********************/

* osn - a unique identifer for each survey

* add_vill - village name
* vill_code - village code
* add_union - union parashad name
* union_code - union parashad code
* add_city - city name (if applicable)
* city_code - city code
* add_thana - subdistrict name
* thana_code - subdistrict code
* add_zila - district name
* zila_code - district code
* add_division - division number
* division_cde - division code

* branded - treatment indicator

* female - 0/1
* age - self-reported age in years
* edu_31 - self-reported level of education on a seven-point scale
* minority - member of minority group, 0/1, coded from name
 
* health - 1..4 - "What level of importance do you attach to each of these issues ...
 * health care?  Unimportant, somewhat unimportant, somewhat important, very important"

* previous_aware - "Are you familiar with the Smiling Sun Clinics?", 0/1
* previous_use - "Have you ever been to a Smiling Sun Clinic to receive medical services
 * for yourself, your family members, or your close friends?", 0/1

* ssc_funding - "Do you know from where most of the Smiling Sun Clinic's financial assistance
 * comes?", coded
* money_new - recoded version of ssc_funding
 
* success - "Do you think the Smiling Sun Clinics are successful in providing health care
 * to the poorest people of Bangladesh?", 0/1
* finance_expan_15 - "If the government want to expand the Smiling Sun Clinics, what is the
 * best way for the government to finance this?"
* expand_with_aid - recode of finance_expan_15, 0/1
* donor_16 - "If the government invites a foreign donor or international organization to 
 * support the Smiling Sun Clinics, which of the following do you most prefer?"
* get_us_money - recode of donor_16, 0/1 


/***************************/
/* Table A1 Balance Checks */
/***************************/

ttest female, by(branded)
ttest age, by(branded)
ttest edu_31, by(branded)
ttest minority, by(branded)
ttest health, by(branded)
ttest previous_use, by(branded)
ttest previous_aware, by(branded)

/**************************************/
/* Table 2: Successfulness of Clinics */
/**************************************/

prtest success, by(branded)

prtest success if previous_use==1, by(branded)
prtest success if previous_use==0, by(branded)

prtest success if previous_aware==1 & previous_use==0, by(branded)
prtest success if previous_aware==0 & previous_use==0, by(branded)

* Footnote 2
prtest success if health < 4, by(branded)
prtest success if health==4, by(branded)

/****************************************/
/* Table 3: How to Expand Project: Aid? */
/****************************************/

prtest expand_with_aid, by(branded)

prtest expand_with_aid if previous_use==1, by(branded)
prtest expand_with_aid if previous_use==0, by(branded)

prtest expand_with_aid if previous_aware==1 & previous_use==0, by(branded)
prtest expand_with_aid if previous_aware==0 & previous_use==0, by(branded)

/*********************************************/
/* Table 4: How to Expand Project: U.S. Aid? */
/*********************************************/

prtest get_us_money, by(branded)

prtest get_us_money if previous_use==1, by(branded)
prtest get_us_money if previous_use==0, by(branded)

prtest get_us_money if previous_aware==1 & previous_use==0, by(branded)
prtest get_us_money if previous_aware==0 & previous_use==0, by(branded)






/* End of File */
