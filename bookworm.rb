#!/usr/bin/env ruby

require "watir-webdriver"
browser = Watir::Browser.new :chrome

#before the loop
doipre = "http://dx.doi.org/"
sheetpub = "https://docs.google.com/spreadsheet/pub?key=0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE&single=true&gid=5&output=html"

#enter the loop
browser.goto doipre #+ DOI-from-sheetpub (need to concatenate DOI here, variable should be in a loop going down DOI list)
#if browser.text.include? '*'
#   puts browser.a(:text => "still need some way to find the text with asterisk").flash
#else
#   hmm_not_sure

#leave watir running while all the papers get scanned (or open new tabs and run parallel...?)

browser.close        # call it a day
