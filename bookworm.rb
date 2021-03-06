#!/usr/bin/env ruby

require "watir-webdriver"
require "google_drive"
require "roo"

#set up some info
sheetkey="0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
sheetfull="https://docs.google.com/spreadsheet/ccc?key=" + sheetkey   #use this to see the actual sheet
sheetresults = "#gid=5"                 #append this to the URL for the sheet this program will use (pubmed_result)
results = sheetfull + sheetresults      #hey look I did it for you...

#puts "Please enter your Gmail address"
#GOOGLE_MAIL = gets
#puts "Please enter your password"
#GOOGLE_PASSWORD = gets

browser = Watir::Browser.new :chrome

# This passes the login credentials to Roo without requiring every user change system environment variables
oo = Roo::Google.new(sheetkey, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD) #Loading spreadsheet :-)
oo.default_sheet = "pubmed_result"

#the following doesn't seem to work as desired but in theory it names each cell when on that row, simplifies things:

2.upto(oo.last_row) do |line|       #grabs the DOI and navigates to journal webpage (only where a D.O.I. is available)
    browser.goto oo.cell(line,'P')
    oo.set(line,'T',browser.url)
  end

=begin        excuse me while I comment out the irrelevant bits for the time being
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
=end
  
#Comment 1) Although the following section doesn't work, I don't actually want the array to be spat out, I just want
#the DOIs one at a time for my browser to navigate to. I don't have a need for a massive list of URLs
#but it can stay as an example while I understand how to use this thing

#this bit doesn't work  if pubmeduri
#this bit doesn't work    puts '#{pubmeduri}\t#{title}'

#Comment 2) Idea for a RegExp to get titles:
#if browser.text.include? '*'
#   puts browser.a(:text => "still need to get regex to find text with asterisk").flash
#else
#   hmm_not_sure

#leave watir running while all the papers get scanned
#(or open new tabs and run parallel...?)
#(or better yet, run a headless browser - might not see errors though if they are made)

browser.close        # call it a day

#do I need to end this code with an "end" ?
