#!/usr/bin/env ruby

require "watir-webdriver"
browser = Watir::Browser.new :chrome

sheetpub = "https://docs.google.com/spreadsheet/pub?key=0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE&single=true&gid=5&output=html"
doipre = "http://dx.doi.org/"
doisuff = ""

browser.goto sheetpub
#get first doi from spreadsheet
puts browser.url
browser.goto doipre + doisuff #need to concatenate DOI here

#need to either add in-browser or save as .txt .csv or .xls file

browser.close        # call it a day
