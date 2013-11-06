#!/usr/bin/env ruby

#check that you came here from bookworm.rb, i.e. after loading the libraries needed:

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

# This passes the login credentials to Roo without requiring every user change system environment variables
oo = Roo::Google.new(sheetkey, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD) #Loading spreadsheet :-)
oo.default_sheet = "pubmed_result"

  lastauth          = oo.cell(line,'A')
  fauthsur          = oo.cell(line,'B')
  uniqfasur         = oo.cell(line,'C')
  correspauthsur    = oo.cell(line,'D')
  correspauthgn     = oo.cell(line,'E')
  hyplink           = oo.cell(line,'F')
  title             = oo.cell(line,'G')
  pmurlfield        = oo.cell(line,'H')
  pmid              = oo.cell(line,'I')
  journal           = oo.cell(line,'J')
  authors           = oo.cell(line,'K')
  details           = oo.cell(line,'L')
  nodoi             = oo.cell(line,'M')
  doi               = oo.cell(line,'P')
  doiuri            = oo.cell(line,'Q')
  doixml            = oo.cell(line,'R')
  pmceutilsxml      = oo.cell(line,'S')
  realurl           = oo.cell(line,'U')
  pmcid             = oo.cell(line,'V')
  pubmeduri         = oo.cell(line,'W')
  identifiers       = oo.cell(line,'X')
  pmid              = oo.cell(line,'Y')
  properties        = oo.cell(line,'Z')
  fauthfull         = oo.cell(line,'AA')

if (defined?(Net).nil?)
    require "net/http"
end

2.upto(oo.last_row) do |line|
    if pmceutilsxml == nil
      # do nothing
    else
        url = pmceutilsxml
        xml_data = Net::HTTP.get_response(URI.parse(url)).body      # stores the XML
        parsed = REXML::Document.new xml_data
        parsedoc = Nokogiri::XML.parse(xml_data)
        parsedoc.search('xref[text()="*"] ~ *').map &:text
        corrdetails = doc.at('contrib:has(xref[text()="*"])')
        oo.set(line,'D', corrdetails.xpath( "//surname" ).text )
        oo.set(line,'E', corrdetails.xpath("//given-names").text )
    end
end
