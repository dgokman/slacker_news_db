CREATE TABLE articles (
  id serial PRIMARY KEY,
  title varchar(100) NOT NULL,
  url varchar(100) NOT NULL,
  description varchar(1000)
  );

CREATE TABLE comments (
  id serial PRIMARY KEY,
  comment varchar(1000) NOT NULL,
  time TIMESTAMP,
  article_id integer NOT NULL
  );
