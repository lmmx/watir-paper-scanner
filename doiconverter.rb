#!/usr/bin/env ruby

require "watir-webdriver"
browser = Watir::Browser.new :chrome

sheetpub = "http://goo.gl/2T60tU"
doipre = "http://dx.doi.org/"
doisuff = ""

browser.goto sheetpub
#highlight first doi from spreadsheet
browser.td(:class => "s24").flash

#concatenate with doipre, output the url it leads to with:
browser.goto doipre + doisuff #need to concatenate DOI here
#puts browser.url

#need to either add this output in-browser (i.e. in a spreadsheet cell) or save as .txt .csv or .xls file

browser.close        # call it a day
