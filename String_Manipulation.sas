/*Visualizing how the demographics table looks like:*/
PROC print data=SASHELP.DEMOGRAPHICS;
run;

/* Change the ISONAME variable so that only the first letters are capitalised. */
DATA s40840.DEMOGRAPHICS;
	set SASHELP.DEMOGRAPHICS;
		ISONAME2 = PROPCASE(ISONAME);
run;

/*Replacing region values with full word*/
DATA s40840.DEMOGRAPHICS;
	set s40840.DEMOGRAPHICS;
		length region2 $ 25;
		region2 = tranwrd(region, 'AMR', 'Americas');
		region2 = tranwrd(region2, 'AFR', 'Africa');
		region2 = tranwrd(region2, 'EUR', 'Europe');
		region2 = tranwrd(region2, 'EMR', 'Eastern Meditteranean');
		region2 = tranwrd(region2, 'SEAR', 'South-East Asia');
		region2 = tranwrd(region2, 'WPR', 'Western Pacific');
run;

/*Creating a variable name2 that has spaces and special characters of 
the name variable removed*/
DATA s40840.DEMOGRAPHICS;
	set s40840.DEMOGRAPHICS;
		length name2 $ 25;
		name2 = tranwrd(name, '/', '');
		name2 = compress(name2);
run;

/*Creating a len variable that stores the length of name2 variable*/
DATA s40840.DEMOGRAPHICS;
	set s40840.DEMOGRAPHICS;
		len = LENGTH(name2);
run;

/*Using the means procedure to find the minimum and maximum length
recorded in length variable */
PROC means data=s40840.DEMOGRAPHICS maxdec=2 min max;
	var len;
run;

/* Remove the first character and the final character from ISONAME and concatenate 
them into a string of length 2. Store this in a new variable called
FIRST LAST, ensuring that all letters in this new variable are capitalised.  */
DATA s40840.DEMOGRAPHICS;
	set s40840.DEMOGRAPHICS;
	length FIRST_LAST $ 25;
	length First_Letter $ 1;
	length Last_Letter $ 1;
		First_Letter = upcase(substr(ISONAME, 1, 1));
		Last_Letter = upcase(substr(ISONAME, length(ISONAME), 1));
		FIRST_LAST = CATS('',First_Letter, Last_Letter);
run;

/* Ordering the dataset alphabetically by FIRST_LAST variable */
PROC SORT DATA=s40840.DEMOGRAPHICS;
  BY FIRST_LAST;
RUN;

/*Frequency table implementation */
PROC FREQ DATA=s40840.DEMOGRAPHICS;
    TABLE FIRST_LAST;
RUN;
