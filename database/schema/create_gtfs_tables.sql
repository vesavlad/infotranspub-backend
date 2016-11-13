/*
Order of creation 
DirectionType, TransportType = referenced by other tables
City, Agency
CityAgency
Route
Trips
Stops

Drop order
Stops
Trips
Route
CityAgency
City, Agency
DirectionType, TransportType
*/


-- This table contains values from the GTFS standard

CREATE TABLE T_DirectionType(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	short_name 	text 		NOT 	NULL,
	long_name 	text 		NOT 	NULL,
	description	text 		NOT	NULL
);

CREATE UNIQUE INDEX I_DirectionType ON T_DirectionType (id,short_name);


-- This table contains values from the GTFS standard

CREATE TABLE T_TransportType(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	short_name 	text 		NOT 	NULL,
	long_name 	text 		NOT 	NULL,
	description	text 		NOT	NULL
);

CREATE UNIQUE INDEX I_TransportType ON T_TransportType (id,short_name);


CREATE SEQUENCE S_City INCREMENT  BY 1 
     START WITH  1 ;

CREATE TABLE T_City(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	name		text 		NOT 	NULL
);

CREATE UNIQUE INDEX I_City ON T_City (id, name);
ALTER TABLE T_City ALTER COLUMN id SET DEFAULT nextval('S_City') ;


CREATE SEQUENCE S_Agency INCREMENT  BY 1 
     START WITH  1 ;

CREATE TABLE T_Agency(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	name		text 		NOT 	NULL,	-- GTFS:agency_name
	url		text 		NOT 	NULL,	-- GTFS:agency_url
	timezone	text 		NOT 	NULL,	-- GTFS:timezone
	lang		text			NULL,	-- GTFS:lang
	phone		text			NULL,	-- GTFS:phone
	fare_url	text			NULL,	-- GTFS:fare_url
	email		text			NULL,	-- GTFS:email
	gtfs_agency_id 	text 			NULL	-- GTFS:agency_id
);

CREATE UNIQUE INDEX I_Agency ON T_Agency (id, name);
ALTER TABLE T_Agency ALTER COLUMN id SET DEFAULT nextval('S_Agency') ;

-- Link table between City and Agency - will help in the future
CREATE TABLE T_CityAgency(
	id_city		integer 	REFERENCES T_City(id),
	id_agency	integer 	REFERENCES T_Agency(id)
);

CREATE UNIQUE INDEX I_CityAgency ON T_CityAgency (id_city, id_agency);


CREATE SEQUENCE S_Routes INCREMENT  BY 1 
     START WITH  1 ;

CREATE TABLE T_Routes(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	short_name 	text 		NOT 	NULL,
	long_name 	text 		NOT 	NULL,
	description	text 			NULL,
	type		integer 	REFERENCES T_TransportType(id),
	url		text 			NULL,
	color		text 			NULL,
	text_color 	text 			NULL,
	gtfs_route_id	text		NOT	NULL,
	gtfs_agency_id	text			NULL
);

CREATE UNIQUE INDEX I_Routes ON T_Routes (id, /*id_agency,*/short_name);
ALTER TABLE T_Routes ALTER COLUMN id SET DEFAULT nextval('S_Routes') ;


CREATE SEQUENCE S_Trips INCREMENT  BY 1 
     START WITH  1 ;

CREATE TABLE T_Trips(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	headsign 	text 		 	NULL,
	short_name	text 			NULL,
	id_direction	integer			REFERENCES T_DirectionType(id),
	gtfs_block_id	text			NULL,
	gtfs_shape_id	text 		NULL,
wheelchair_accessible	integer			NULL,
bikes_allowed		integer			NULL,
	gtfs_route_id	text		NOT	NULL, -- GTFS: route_id
	gtfs_service_id	text		NOT	NULL, -- GTFS: sevice_id
	gtfs_trip_id	text		NOT	NULL -- GTFS: trip_id
);

CREATE UNIQUE INDEX I_Trips ON T_Trips (id, short_name);
ALTER TABLE T_Trips ALTER COLUMN id SET DEFAULT nextval('S_Trips') ;



CREATE SEQUENCE S_Stops INCREMENT  BY 1 
     START WITH  1 ;

CREATE TABLE T_Stops(
	id 		integer 	PRIMARY KEY, 	-- internal to the database
	stop_id		text		NOT 	NULL,
	code	text			NULL,
	name	text		NOT	NULL,
	description	text			NULL,
	lat	text		NOT	NULL,
	lon	text		NOT	NULL,
	zone_id		text			NULL,
	url	text			NULL,
	location_type	text			NULL,
	parent_station	text			NULL,
	timezone	text			NULL,
	wheelchair_boarding	text		NULL
);



CREATE UNIQUE INDEX I_Stops ON T_Stops (id, name, code);
ALTER TABLE T_Stops ALTER COLUMN id SET DEFAULT nextval('S_Stops') ;

