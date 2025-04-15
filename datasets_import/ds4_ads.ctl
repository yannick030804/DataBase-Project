load data 
CHARACTERSET UTF8
infile 'ds4_ads.csv' "str '\r\n'"
append
into table ds4_ads
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( num,
             title CHAR(1000),
             description CHAR(1000),
             format CHAR(1000),
             status CHAR(1000),
             AdDate DATE "RRRR-MM-DD",
             category CHAR(1000),
             category1 CHAR(1000),
             category1_desc CHAR(1000),
             category2 CHAR(1000),
             category2_desc CHAR(1000),
             category3 CHAR(1000),
             category3_desc CHAR(1000),
             Code CHAR(1000),
             Campaign CHAR(1000),
             Objective CHAR(1000),
             Budget,
             Product CHAR(1000),
             Start_Date DATE "RRRR-MM-DD",
             End_Date DATE "RRRR-MM-DD",
             Audience_Interest CHAR(1000),
             Audience_Segment CHAR(1000),
             Client CHAR(1000),
             Client_Budget,
             City CHAR(1000)
           )

