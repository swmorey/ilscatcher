class MelcatController < ApplicationController
respond_to :html, :json
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'oj'
require 'nikkou'

def searchmelcat

if params[:q].present?
@searchquery = params[:q]
@searchqueryclearned = CGI::escape(@searchquery)    
else
@searchqueryclearned = ""       
end    

@pagetitle = 'http://elibrary.mel.org/search/a?searchtype=X&searcharg=' + @searchqueryclearned + '&SORT=D' 
url = @pagetitle
@doc = Nokogiri::HTML(open(url))
@itemlist = @doc.search('tr').text_includes("ISBN/ISSN:").map do |item|
{
item:
{
:title => item.at_css('.briefcitTitle').try(:text).try(:strip), 
}
}
end 

@test = @pagetitle

respond_to do |format|
format.json { render :json => Oj.dump(items: @itemlist.uniq)  }
end


end











end
