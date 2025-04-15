load data 
CHARACTERSET UTF8
infile 'ds3_radios.csv' "str '\n'"
append
into table ds3_radios
fields terminated by ','
OPTIONALLY ENCLOSED BY '"' AND '"'
trailing nullcols
           ( name_of_media_group CHAR(4000),
             description_of_media_group CHAR(4000),
             headquarters_of_the_media_group CHAR(4000),
             name_of_the_radio_station CHAR(4000),
             description_of_the_radio_station CHAR(4000),
             frequency_of_the_radio_station CHAR(4000),
             programme CHAR(4000),
             description CHAR(4000),
             programme_lssl CHAR(4000),
             schedule CHAR(4000),
             podcast,
             FirstName CHAR(4000),
             LastName CHAR(4000),
             Birthdate DATE "RRRR-MM-DD",
             Gender CHAR(4000),
             Role CHAR(4000),
             Specialization CHAR(4000),
             Username_lssl CHAR(4000)
           )
