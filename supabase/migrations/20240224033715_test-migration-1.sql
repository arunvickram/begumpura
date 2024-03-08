create table users (
  id serial primary key,
  email text unique,
  hashed_password text,
  is_editor boolean default false
);

create table posts (

);