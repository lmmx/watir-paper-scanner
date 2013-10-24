#!/usr/bin/env ruby

require "watir-webdriver"
require "roo"

#set up some info
doipre = "http://dx.doi.org/"
sheetkey="0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
sheetfull="https://docs.google.com/spreadsheet/ccc?key=" + sheetkey
sheetresults = "#gid=5"
sheetprocessed = "#gid=4"
results = sheetfull + sheetresults
nameslist = sheetfull + sheetprocessed

oo = Google.new('"'+sheetkey+'"')
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
