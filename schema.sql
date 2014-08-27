CREATE TABLE articles (
  id serial PRIMARY KEY,
  title varchar(100) NOT NULL,
  url varchar(100) NOT NULL,
  description varchar(1000)
  );
