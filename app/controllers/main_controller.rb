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
    @mediatype = "g"
    @fdefault ="MOVIES"    
    elsif params[:mt] == "BOOKS"
    @mediatype = "at"
    @fdefault = "BOOKS"
    elsif params[:mt] == "MUSIC"
    @mediatype = "j"
    @fdefault = "MUSIC"
    elsif params[:mt] == "VIDEO GAMES"
    @mediatype = "mVG&facet=subject%7Cgenre%5Bgame%5D"
    @fdefault = "VIDEO GAMES"         
    end
  else  
   @mediatype = "" 
   @fdefault = "ALL" 
end

    
    

@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=' + @searchqueryclearned + '&qtype=keyword&fi%3Aformat=' + @mediatype + '&locg=22&limit=30'
url = @pagetitle
@doc = Nokogiri::HTML(open(url))

  
end

  def about
  end
end
