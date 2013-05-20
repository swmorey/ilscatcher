class MainController < ApplicationController
require 'rubygems'
require 'nokogiri'
require 'open-uri'



  def index
  
if params[:q].present?
@pagetitle = URI::escape('http://catalog.tadl.org/eg/opac/results?query=' + params[:q] + ';qtype=keyword;limit=60')
@searchquery = params[:q]
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
