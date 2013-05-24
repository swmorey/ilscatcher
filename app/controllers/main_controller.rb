class MainController < ApplicationController
require 'rubygems'
require 'nokogiri'
require 'open-uri'



  def index
  
if params[:q].present?
@searchquery = params[:q]
@searchqueryclearned = CGI::escape(@searchquery)    
else
@searchqueryclearned = ""       
end    

if params[:mt].present?    
  
    if params[:mt] == "MOVIES"
    @mediatype = "format=g"
    @fdefault ="MOVIES"    
    elsif params[:mt] == "BOOKS"
    @mediatype = "format=at"
    @fdefault = "BOOKS"
    elsif params[:mt] == "MUSIC"
    @mediatype = "format=j"
    @fdefault = "MUSIC"
    elsif params[:mt] == "VIDEO GAMES"
    @mediatype = "format=mVG&facet=subject%7Cgenre%5Bgame%5D"
    @fdefault = "VIDEO GAMES" 
    elsif params[:mt] == "ALL"
    @mediatype = "format="
    @fdefault = "ALL" 
    end
    


end

    
if params[:q].present? 

@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=' + @searchqueryclearned + '&qtype=keyword&fi%3A'+ @mediatype +'&locg=22&limit=30'
url = @pagetitle
@doc = Nokogiri::HTML(open(url))
else
url = "http://catalog.tadl.org"
@doc = Nokogiri::HTML(open(url))  
end
end

  def about
  end
end
