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
  @url = []
  db_connection do |conn|
    results = conn.exec('SELECT id, title, url, description
     FROM articles')
    @articles = results.to_a
    @articles.each do |article|
      @url << article["url"]
    end
  end
  erb :index
end

get "/articles/new" do
  @article = {}
  erb :submit
end

post "/articles" do
  @url = []
  db_connection do |conn|
    results = conn.exec('SELECT id, title, url, description
     FROM articles')
    @articles = results.to_a
    @articles.each do |article|
      @url << article["url"]
    end
  end
  title = params["title"]
  url = params["url"]
  description = params["description"]

  @article = { title: title, url: url, description: description }

   if /./ !~ title || /^#{URI::regexp(%w(http https))}$/ !~ url || description.length < 20 || @url.include?(url)
    @error = 'You did it wrong'
    erb :submit
   else
    db_connection do |conn|
     insert = conn.exec_params('INSERT INTO articles (title, url, description)
      VALUES ($1, $2, $3)',[title, url, description])
    end

    redirect '/articles'
   end

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
  @comments = {}
  comment = params["comments"]
    if /./ !~ comment
      @error = 'You did it wrong'
      erb :comments
    else db_connection do |conn|
      insert = conn.exec_params('INSERT INTO comments (comment, article_id)
      VALUES ($1, $2)',[comment, params[:id]])
      end
     redirect '/articles'
    end

end

