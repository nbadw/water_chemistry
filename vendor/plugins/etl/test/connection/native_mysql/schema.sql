drop table if exists people;
create table people (
  first_name char(255),
  last_name char(255),
  ssn char(64)
);
drop table if exists places;
create table places (
	address text,
	city char(255),
	state char(255),
	country char(2)
);

drop table if exists person_dimension;
create table person_dimension (
  id int not null primary key,
  first_name char(50),
  last_name char(50),
  address char(100),
  city char(50),
  state char(50),
  zip_code char(20),
  effective_date datetime,
  end_date datetime
);

drop table if exists truncate_test;
create table truncate_test (
	x char(4)
);
insert into truncate_test (x) values ('a');
insert into truncate_test (x) values ('b');
insert into truncate_test (x) values ('c');