

/* Do file for email results */
/* NOTE: File is completely anonymized at the request of our partner org */


/* Table 2 in the main text */
prtest click_email1, by(email1)
prtest click_email2, by(email2)

/* this is in Appendix 12 and footnote in main paper */
prtest email2, by(email1)


/* this is in Appendix 12 */ 
probit click_email2 email2 click_email1


/* this is in Appendix 12 */
prtest click_email2 if email2==1, by(email1)
