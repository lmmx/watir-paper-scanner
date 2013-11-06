#!/usr/bin/env ruby
# encoding: UTF-8

#check that you came here from bookworm.rb, i.e. after loading the libraries needed:

if (defined?(Roo).nil? && defined?(Watir).nil?)
  require "watir-webdriver"
  require "google_drive"
  require "roo"
  else
      puts "Hey bookworm"
end

#set up some info, unless already done in bookworm.rb
if (defined?(sheetkey).nil?)
    sheetkey="0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
    sheetfull="https://docs.google.com/spreadsheet/ccc?key=" + sheetkey   #use this to see the actual sheet
    sheetresults = "#gid=5"                 #append this to the URL for the sheet this program will use (pubmed_result)
    results = sheetfull + sheetresults      #hey look I did it for you...
end

if (defined?(GOOGLE_MAIL).nil? && defined?(GOOGLE_PASSWORD).nil?)
    puts "Please enter your Gmail address"
    GOOGLE_MAIL = gets.chomp
    puts "Please enter your password"
    GOOGLE_PASSWORD = gets.chomp
    puts "Thanks!"
end

# This passes the login credentials to Roo without requiring every user change system environment variables
oo = Roo::Google.new(sheetkey, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD) #Loading :-)
puts "Loading spreadsheet .  .  ."
oo.default_sheet = "pubmed_result"
  
if (defined?(Net).nil?)
    require "net/http"
end

if (defined?(Nokogiri).nil?)
    require "nokogiri"
end

2.upto(oo.last_row) do |line|

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

    if pmceutilsxml.nil?
      puts line.to_s + "..."
    else
        url = pmceutilsxml

        puts line.to_s + "!"
        xml_data = Net::HTTP.get_response(URI.parse(url)).body      # stores the XML

        parsedoc = Nokogiri::XML.parse(xml_data)

        corrdetails = parsedoc.at('contrib:has(xref[text()="*"])')
	corrdetailsalt = parsedoc.at_xpath('//*[@corresp]')        #don't think it matters whether this is .at_xpath or just .at

         if (corrdetails.nil? && corrdetailsalt.nil?)
	   oo.set(line,'D',"---")
           oo.set(line,'E',"---")
         elsif not(corrdetails.nil?)
           surname = corrdetails.xpath( ".//surname" ).text
           oo.set(line,'D',surname)
           givennames = corrdetails.xpath( ".//given-names").text
           oo.set(line,'E',givennames)
         elsif not(corrdetailsalt.nil?)
           surname = corrdetailsalt.xpath(".//surname").text
           oo.set(line,'D',surname)
           givennames = corrdetailsalt.xpath(".//given-names").text
           oo.set(line,'E',givennames)
         end
    end
end
