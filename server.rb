require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')

    yield(connection)

  ensure
    connection.close
  end
end


get "/" do
  db_connection do |conn|
    results = conn.exec('SELECT articles.title AS title, articles.url AS url,
     articles.description AS description
     FROM articles')
    @articles = results.to_a
  end
  erb :index
end

get "/articles/new" do

  erb :submit
end

post "/articles" do
  title = params["title"]
  url = params["url"]
  description = params["description"]
  db_connection do |conn|
    insert = conn.exec_params('INSERT INTO articles (title, url, description)
      VALUES ($1, $2, $3)',[title, url, description])

  end
  redirect '/'

end


