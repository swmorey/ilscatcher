class MainController < ApplicationController
respond_to :html, :json
require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'oj'
require 'openssl'
require 'nikkou'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE



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
:author => item.at_css('[@name="item_author"]').text.strip.try(:squeeze, " "),
:summary => item.at_css(".result_table_summary").text.strip,
:availability => item.at_css(".result_count").try(:text).try(:strip).try(:gsub!, /in TADL district./," "), 
:callnumber => item.at_css('[@name="bib_cn_list"]').try(:text).try(:gsub!, /\n/," ").try(:squeeze, " "),
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
:author => detail.at_css(".rdetail_authors_div").try(:text).try(:gsub!, /\n/," ").try(:squeeze, " "),
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

def hold
headers['Access-Control-Allow-Origin'] = "*"
@username = params[:u]
@password = params[:pw]
@record_id = params[:record_id]
agent = Mechanize.new
page = agent.get("https://catalog.tadl.org/eg/opac/login?redirect_to=%2Feg%2Fopac%2Fmyopac%2Fmain")
page.forms.class == Array
form = agent.page.forms[1]
form.field_with(:name => "username").value = @username
form.field_with(:name => "password").value = @password
results = agent.submit(form)
holdpage = agent.get('https://catalog.tadl.org/eg/opac/place_hold?;locg=22;hold_target='+ @record_id +';hold_type=T;')
holdform = agent.page.forms[1]  
holdconfirm = agent.submit(holdform)
@doc = holdconfirm.parser
@test = @doc.css("#hold-items-list").text
respond_to do |format|
format.json { render :json => Oj.dump(@test)  }
end
end


def renew
headers['Access-Control-Allow-Origin'] = "*"
@username = params[:u]
@password = params[:pw]
@circ_id = params[:circ_id]
@barcode = params[:bc]
agent = Mechanize.new
page = agent.get("https://catalog.tadl.org/eg/opac/login?redirect_to=%2Feg%2Fopac%2Fmyopac%2Fmain")
page.forms.class == Array
form = agent.page.forms[1]
form.field_with(:name => "username").value = @username
form.field_with(:name => "password").value = @password
results = agent.submit(form)
renew = agent.get('https://catalog.tadl.org/eg/opac/myopac/circs?&action=renew&circ='+ @circ_id +'')
@doc = renew.parser
@test = @doc.css(".renew-summary").text.try(:gsub!, /\n/," ").try(:gsub!, /[^0-9A-Za-z]/, '').try(:squeeze, " ").try(:strip).try(:gsub, /torenew1items/, '').try(:gsub, /fullyrenewed1items/, '')

@checkouts = @doc.search('tr').text_includes(@barcode).map do |checkout|
{
checkout:
{
:name => checkout.css("/td[2]").try(:text).try(:strip).try(:gsub!, /\n/," ").try(:squeeze, " "),
:renew_attempts => checkout.css("/td[4]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
:due_date => checkout.css("/td[5]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
}
}
end 

respond_to do |format|
format.json { render :json => Oj.dump(:checkouts => @checkouts, :response => @test )}   
end
end

def login
headers['Access-Control-Allow-Origin'] = "*"
@username = params[:u]
@password = params[:pw]
agent = Mechanize.new
page = agent.get("https://catalog.tadl.org/eg/opac/login?redirect_to=%2Feg%2Fopac%2Fmyopac%2Fmain")
page.forms.class == Array
form = agent.page.forms[1]
form.field_with(:name => "username").value = @username
form.field_with(:name => "password").value = @password
results = agent.submit(form)
accountpage = agent.get("https://catalog.tadl.org/eg/opac/myopac/main")
@doc = accountpage.parser

@user = @doc.css("body").map do |item| 
{
user:
{
:name => item.at_css('#dash_user').text.strip,
:checkouts => item.at_css('#dash_checked').text.strip, 
:holds => item.at_css('#dash_holds').text.strip,
:pickups => item.at_css('#dash_pickup').text.strip,
:fines => item.at_css('#dash_fines').text.strip, 
}
}
end 

if @user.count == 0

respond_to do |format|
format.json { render :json => { :status => :error, :message => "Bad Login or Password" }}
end
else

respond_to do |format|
format.json { render :json => Oj.dump(users: @user)  }
end
end
end

def showcheckouts
headers['Access-Control-Allow-Origin'] = "*"
@username = params[:u]
@password = params[:pw]
agent = Mechanize.new
page = agent.get("https://catalog.tadl.org/eg/opac/login?redirect_to=%2Feg%2Fopac%2Fmyopac%2Fmain")
page.forms.class == Array
form = agent.page.forms[1]
form.field_with(:name => "username").value = @username
form.field_with(:name => "password").value = @password
results = agent.submit(form)
checkoutpage = agent.get("https://catalog.tadl.org/eg/opac/myopac/circs?loc=22")
@doc = checkoutpage.parser
@checkouts = @doc.css('//table[2]/tr')[1..-1].map do |checkout|
{
checkout:
{
:checkout_id => checkout.at('td[1]/input')['value'],
:name => checkout.css("/td[2]").try(:text).try(:strip).try(:gsub!, /\n/," ").try(:squeeze, " "),
:renew_attempts => checkout.css("/td[4]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
:due_date => checkout.css("/td[5]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
:format_icon => checkout.css("/td[3]/img").attr("src").text,
:barcode => checkout.css("/td[6]").text.to_s.try(:gsub!, /\n/," ").try(:squeeze, " ").try(:strip),
}
}
end 

respond_to do |format|
format.json { render :json => Oj.dump(checkouts: @checkouts)  }
end


end



  
end
