class MainController < ApplicationController
require 'rubygems'
require 'nokogiri'
require 'open-uri'



  def index
  
if params[:q].present?

@searchquery = params[:q]
@searchqueryclearned = CGI::escape(@searchquery)
@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=' + @searchqueryclearned + '&qtype=keyword&fi%3Aformat=&locg=22&limit=60'

url = @pagetitle
@doc = Nokogiri::HTML(open(url))
   else
  url = "http://catalog.tadl.org/eg/opac/results?qtype=keyword;sort=pubdate.descending;"
@doc = Nokogiri::HTML(open(url))
@pagetitle = @doc.at_css("title").text
  end
  end

  def about
  end
end
