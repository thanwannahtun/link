-----------  copy all from users and make changes for ensure  ------------------

select * from users;

create table user like users;
insert into user select * from user;

alter table user change name firstName varchar(255) not null;
alter table user add column lastName varchar(255) after firstName;
alter table user change passwordHash password varchar(255) not null;
alter table user add role ENUM('user','admin') default 'user' after password;
alter table user add createdAt timestamp default current_timestamp after role;
describe user;


----------------------------------------