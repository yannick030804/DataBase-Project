load data 
CHARACTERSET UTF8
infile 'ds2_shop_keepers.csv' "str '\r\n'"
append
into table ds2_shop_keepers
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( FirstName CHAR(4000),
             LastName CHAR(4000),
             birthdate DATE "YYYY-MM-DD:HH24:MI:SS",
             Gender CHAR(4000),
             vacation_days,
             Shop CHAR(4000),
             role CHAR(4000),
             shift CHAR(4000)
           )
