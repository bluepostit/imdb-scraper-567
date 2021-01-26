require 'open-uri'
require 'nokogiri'

def fetch_movie_urls
  # define URL of top 250 films
  # download page source to string
  # scrape top 5 movies
  # return array of these movies

  top_250_url = 'https://www.imdb.com/chart/top'
  html = open(top_250_url).read
  doc = Nokogiri::HTML(html)
  urls = []
  doc.search('.titleColumn a').take(5).each do |item|
    urls << 'https://www.imdb.com' + item.attribute('href').value
  end
  urls
end

def scrape_movie(url)
  # open url; download contents
  # scrape:
  #   get name of movie
  #   get director
  #   get 3 actors
  #   get year
  #   get storyline
  # return hash with this data
  html = open(url).read
  doc = Nokogiri::HTML(html)

  # title
  title_el = doc.search('.title_wrapper h1').text.strip
  title_match_data = title_el.match /(?<title>.*)[[:space:]]\((?<year>\d{4})\)/

  director_el = doc.search('.credit_summary_item a').first
  director = director_el.text.strip

  storyline_el = doc.search('.summary_text')
  storyline = storyline_el.text.strip

  cast = doc.search(".primary_photo + td a").take(3).map do |element|
    element.text.strip
  end

  {
    director: director,
    title: title_match_data['title'],
    year: title_match_data['year'].to_i,
    storyline: storyline,
    cast: cast
  }
end
