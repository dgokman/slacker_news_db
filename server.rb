require 'sinatra'
require 'sinatra/reloader'
require 'csv'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker_news')

    yield(connection)

  ensure
    connection.close
  end
end


get "/articles" do
  db_connection do |conn|
    results = conn.exec('SELECT id, title, url, description
     FROM articles')
    @articles = results.to_a
  end
  erb :index
end

get "/articles/new" do

  erb :submit
end

get "/articles/new/error" do
  @title = params["title"]
  @url = params["url"]
  @description = params["description"]
  erb :error
end

post "/articles" do
  title = params["title"]
  url = params["url"]
  description = params["description"]

   if description.length < 20
    redirect '/articles/new/error'
   else
    db_connection do |conn|
     insert = conn.exec_params('INSERT INTO articles (title, url, description)
      VALUES ($1, $2, $3)',[title, url, description])
    end
   end
    redirect '/articles'
  # end
end


get "/articles/:id/comments" do
  id = params[:id]
  db_connection do |conn|
    results = conn.exec_params('SELECT CURRENT_TIMESTAMP as time, comment, article_id
     FROM comments
     WHERE article_id = $1', [id])
    @comments = results.to_a
    #binding.pry
  end
  erb :comments
end

post "/articles/:id/comments" do
  comment = params["comments"]

    db_connection do |conn|
     insert = conn.exec_params('INSERT INTO comments (comment, article_id)
      VALUES ($1, $2)',[comment, params[:id]])
  end

  redirect '/articles'

end




