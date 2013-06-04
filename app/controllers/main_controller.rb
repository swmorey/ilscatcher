class MainController < ApplicationController
respond_to :html, :json
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'oj'



  def index
  
if params[:q].present?
@searchquery = params[:q]
@searchqueryclearned = CGI::escape(@searchquery)    
else
@searchqueryclearned = ""       
end    

if params[:sort].present?
 if params[:sort] == "RELEVANCE"
    @sorttype = "&sort="
    @sortdefault ="RELEVANCE" 
    elsif params[:sort] == "NEWEST TO OLDEST"
    @sorttype = "&sort=pubdate.descending"
    @sortdefault ="NEWEST TO OLDEST" 
    elsif params[:sort] == "OLDEST TO NEWEST"
    @sorttype = "&sort=pubdate"
    @sortdefault ="OLDEST TO NEWEST" 
    elsif
    @sorttype = "&sort="
    @sortdefault ="RELEVANCE" 
    end
else
@sorttype=""
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

if params[:st].present? 
if params[:st] == "KEYWORD"
@searchby = "&qtype=keyword"
@stdefault = "KEYWORD"
elsif params[:st] == "TITLE"
@searchby = "&qtype=title"
@stdefault = "TITLE"
elsif params[:st] == "AUTHOR/ARTIST"
@searchby = "&qtype=author"
@stdefault = "AUTHOR/ARTIST"
end
else
@searchby = "&qtype=keyword"
@stdefault = "KEYWORD"
end

if params[:avail]
@avail = "&modifier=available"
else
@avail = ""
end


  
if params[:q].present? && params[:mt].present?

@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=' + @searchqueryclearned + '' +  @searchby + '&fi%3A'+ @mediatype +''+ @avail +'&locg=22&limit=24' + @sorttype +''
url = @pagetitle
@doc = Nokogiri::HTML(open(url))
@pagenumber = @doc.at_css(".results-paginator-selected").text rescue nil
@querytitle = @pagetitle.gsub("http://catalog.tadl.org/", '') 
@querytitle2 = @querytitle.gsub(".", '%2E')  
@cleanquerytitle = CGI::escape(@querytitle2)
elsif params[:mt].present?
@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=&qtype=keyword&fi%3A'+ @mediatype +''+ @avail +'&locg=22&limit=24' + @sorttype +''
url = @pagetitle
@doc = Nokogiri::HTML(open(url))  
@pagenumber = @doc.at_css(".results-paginator-selected").text rescue nil
@querytitle = @pagetitle.gsub("http://catalog.tadl.org/", '') 
@querytitle2 = @querytitle.gsub(".", '%2E')  
@cleanquerytitle = CGI::escape(@querytitle2)

end
end

def showmore
end

def about
end

def searchjson
headers['Access-Control-Allow-Origin'] = "*"
 
if params[:q].present?
@searchquery = params[:q]
@searchqueryclearned = CGI::escape(@searchquery)    
else
@searchqueryclearned = ""       
end    

if params[:p].present?
@nextpage = params[:p]
else
@nextpage = "0"
end

if params[:sort].present?
 if params[:sort] == "RELEVANCE"
    @sorttype = "&sort="
    @sortdefault ="RELEVANCE" 
    elsif params[:sort] == "NEWEST TO OLDEST"
    @sorttype = "&sort=pubdate.descending"
    @sortdefault ="NEWEST TO OLDEST" 
    elsif params[:sort] == "OLDEST TO NEWEST"
    @sorttype = "&sort=pubdate"
    @sortdefault ="OLDEST TO NEWEST" 
    elsif
    @sorttype = "&sort="
    @sortdefault ="RELEVANCE" 
    end
else
@sorttype=""
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
    else 
    @mediatype = "format="
end

if params[:st].present? 
if params[:st] == "KEYWORD"
@searchby = "&qtype=keyword"
@stdefault = "KEYWORD"
elsif params[:st] == "TITLE"
@searchby = "&qtype=title"
@stdefault = "TITLE"
elsif params[:st] == "AUTHOR/ARTIST"
@searchby = "&qtype=author"
@stdefault = "AUTHOR/ARTIST"
end
else
@searchby = "&qtype=keyword"
@stdefault = "KEYWORD"
end

if params[:avail] == "true"
@avail = "&modifier=available"
else
@avail = ""
end


  
if params[:q].present? 

@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=' + @searchqueryclearned + '' +  @searchby + '&fi%3A'+ @mediatype +''+ @avail +'&locg=22&limit=24'+ @sorttype +'&page='+ @nextpage 
url = @pagetitle
@doc = Nokogiri::HTML(open(url))
@pagenumber = @doc.at_css(".results-paginator-selected").text rescue nil
elsif params[:mt].present?
@pagetitle = 'http://catalog.tadl.org/eg/opac/results?query=&qtype=keyword&fi%3A'+ @mediatype +''+ @avail +'&locg=22&limit=24'+ @sorttype +'&page='+ @nextpage 
url = @pagetitle
@doc = Nokogiri::HTML(open(url))  
@pagenumber = @doc.at_css(".results-paginator-selected").text rescue nil
end

@itemlist = @doc.css(".result_table_row").map do |item| 
{
item:
{
:title => item.at_css(".bigger").text.strip, 
:author => item.at_css('[@name="item_author"]').text.strip,
:summary => item.at_css(".result_table_summary").text.strip,
:availability => item.at_css(".result_count").try(:text).try(:strip).try(:gsub!, /in TADL district./," "), 
:callnumber => item.at_css('[@name="bib_cn_list"]').try(:text).try(:gsub!, /\n/," ").try(:squeeze),
:record_id => item.at_css(".search_link").attr('name').sub!(/record_/, "")
}
}
end 

if @itemlist.count == 0

respond_to do |format|
format.json { render :json => { :status => :error, :message => "no results" }}
end


else

respond_to do |format|
format.json { render :json => Oj.dump(items: @itemlist )  }
end

end
end

def itemdetails
headers['Access-Control-Allow-Origin'] = "*"

@record_id = params[:record_id]
@pagetitle = 'http://catalog.tadl.org/eg/opac/record/' + @record_id + '?locg=22'
url = @pagetitle
@doc = Nokogiri::HTML(open(url)) 
@record_details = @doc.css("#main-content").map do |detail|
{
item:
{
:author => detail.at_css(".rdetail_authors_div").try(:text).try(:gsub!, /\n/," ").try(:squeeze),
:title => detail.at_css("#rdetail_title").text,
:summary => detail.at_css("#rdetail_summary_from_rec").try(:text).try(:strip),
:record_id => @record_id,
:copies_available => detail.at_css(".rdetail_aux_copycounts").try(:text).try(:strip),
:copies_total => detail.at_css(".rdetail_aux_holdcounts").try(:text).try(:strip),
:record_details => detail.at_css(".padding-ten.float-left").try(:text).try(:strip),
:related_subjects => detail.at_css(".rdetail_subject_value").try(:text).try(:strip)
}
}
end

respond_to do |format|
format.json { render :json => Oj.dump(items: @record_details)  }
end


end


  

  
end
