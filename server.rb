require 'sinatra'
require 'sinatra/reloader'
require 'csv'

def get_articles
  articles = []
  CSV.foreach("articles.csv") do |row|
    articles << {title: row[0],
    url: row[1],
    description: row[2]}
  end
 articles
end

get "/" do
  @articles = get_articles
  erb :index
end

get "/submit" do

  erb :submit
end

post "/articles" do
  @articles = get_articles
  title = params["title"]
  url = params["url"]
  description = params["description"]
  CSV.open("articles.csv","a") do |csv|
    csv << [title, url, description]
  end
  redirect '/'

end


