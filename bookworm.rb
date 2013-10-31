#!/usr/bin/env ruby

require "watir-webdriver"
require "google_drive"
require "roo"

#set up some info
doipre = "http://dx.doi.org/"
sheetkey="0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
sheetfull="https://docs.google.com/spreadsheet/ccc?key=" + sheetkey
sheetresults = "#gid=5"
sheetprocessed = "#gid=4"
results = sheetfull + sheetresults
nameslist = sheetfull + sheetprocessed

puts "Please enter your Gmail address"
GOOGLE_MAIL = gets
puts "Please enter your password"
GOOGLE_PASSWORD = gets

# This passes the login credentials to Roo without requiring every user change system environment variables
oo = Roo::Google.new(sheetkey, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD) #Woop de doo you're in
oo.default_sheet = "pubmed_result"
1.upto(oo.last_row) do |line|
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
  pmcid          = oo.cell(line,'U')
  pubmeduri      = oo.cell(line,'V')
  identifiers    = oo.cell(line,'W')
  pmid           = oo.cell(line,'X')
  properties     = oo.cell(line,'Y')
  1authfull      = oo.cell(line,'Z')

#now what

browser = Watir::Browser.new :chrome

#enter the loop
browser.goto doipre #+ DOI-from-sheet (need to concatenate DOI here, variable should be in a loop going down DOI list)
#if browser.text.include? '*'
#   puts browser.a(:text => "still need to get regex to find text with asterisk").flash
#else
#   hmm_not_sure

#leave watir running while all the papers get scanned (or open new tabs and run parallel...?)

browser.close        # call it a day

browser.goto sheetpub

#need to either add the output in-browser (i.e. in a spreadsheet cell) or save as .txt .csv or .xls file
