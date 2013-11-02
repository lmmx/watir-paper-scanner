#!/usr/bin/env ruby

#check that you came here from bookworm.rb, i.e. after loading the libraries needed:

if (defined?(Ox).nil?)
    require "ox"
end

if (defined?(Roo).nil? && defined?(Watir).nil?)
  require "watir-webdriver"
  require "google_drive"
  require "roo"
  else
      puts "Hey bookworm"
end

#set up some info, unless already done in bookworm.rb
unless (sheetkey == "0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE")
    sheetkey="0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
    sheetfull="https://docs.google.com/spreadsheet/ccc?key=" + sheetkey   #use this to see the actual sheet
    sheetresults = "#gid=5"                 #append this to the URL for the sheet this program will use (pubmed_result)
    results = sheetfull + sheetresults      #hey look I did it for you...
end

if (defined?(GOOGLE_MAIL).nil? && defined?(GOOGLE_PASSWORD).nil?)
    puts "Please enter your Gmail address"
    GOOGLE_MAIL = gets
    puts "Please enter your password"
    GOOGLE_PASSWORD = gets
    puts "Thanks!"
end

if (defined?(browser.url).nil?)
    browser = Watir::Browser.new :chrome
end

# This passes the login credentials to Roo without requiring every user change system environment variables
oo = Roo::Google.new(sheetkey, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD) #Loading spreadsheet :-)
oo.default_sheet = "pubmed_result"

  lastauth       = oo.cell(line,'A')
  1authsurname   = oo.cell(line,'B')
  unique1authsur = oo.cell(line,'C')
  correspauth    = oo.cell(line,'D')
  hyplink        = oo.cell(line,'E')
  title          = oo.cell(line,'F')
  pmurlfield     = oo.cell(line,'G')
  pmid           = oo.cell(line,'H')
  journal        = oo.cell(line,'I')
  authors        = oo.cell(line,'J')
  details        = oo.cell(line,'K')
  nodoi          = oo.cell(line,'L')
  doi            = oo.cell(line,'O')
  doiuri         = oo.cell(line,'P')
  doixml         = oo.cell(line,'Q')
  pmceutilsxml   = oo.cell(line,'R')
  realurl        = oo.cell(line,'T')
  pmcid          = oo.cell(line,'U')
  pubmeduri      = oo.cell(line,'V')
  identifiers    = oo.cell(line,'W')
  pmid           = oo.cell(line,'X')
  properties     = oo.cell(line,'Y')
  1authfull      = oo.cell(line,'Z')
  
2.upto(oo.last_row) do |line|
    if pmceutilsxml == nil
      # do nothing
    else
        url = pmceutilsxml
        xml_data = Net::HTTP.get_response(URI.parse(url)).body      #this if for simplexml
        data = XmlSimple.xml_in(xml_data, { 'KeyAttr' => 'name'})   #change me to ox syntax!
    end
end

browser.close        # call it a day