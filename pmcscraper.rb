#!/usr/bin/env ruby
# encoding: UTF-8

if (defined?(Roo).nil?)
  require "google_drive"
  require "roo"
end

if (defined?(key).nil?)
    key="0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
end

if (defined?(GOOGLE_MAIL).nil? && defined?(GOOGLE_PASSWORD).nil?)
    puts "Please enter your Gmail address"
    GOOGLE_MAIL = gets.chomp
    puts "Please enter your password"
    GOOGLE_PASSWORD = gets.chomp
    puts "Thanks!"
end

oo = Roo::Google.new(key, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD) #Loading :~)
oo.default_sheet = "pubmed_result"
  
if (defined?(Net).nil?)
    require "net/http"
end

if (defined?(Nokogiri).nil?)
    require "nokogiri"
end

def format_for_spreadsheet(values)
  return "---" unless values
  '=concatenate("' + values.join(',CHAR(10),') + '")'
end
 
2.upto(oo.last_row) do |line|
  last_author         = oo.cell(line,'A')
  first_author        = oo.cell(line,'B')
  unique_first_author = oo.cell(line,'C')
 
  surnames    = oo.cell(line, 'D')
  givennames  = oo.cell(line, 'E')
  eutils_url  = oo.cell(line, 'S')
 
  if eutils_url && eutils_url != ""
    uri       = URI.parse(eutils_url)
    xml_data  = Net::HTTP.get_response(uri).body
    document  = Nokogiri::XML.parse(xml_data)
 
    details  = document.at('contrib:has(xref[text()="*"])') || document.at('//*[@corresp]') || document.at('//*[@ref-type="corresp"]') 
    email    = document.at('//*[@email]') || document.at('//email')
 
    surnames   = nil
    givennames = nil
    if details
      surnames   = details.xpath(".//surname" ).map(&:text)
      givennames = details.xpath(".//given-names").map(&:text)
    elsif email
      details = document.at('contrib')
      known_surnames   = details.xpath(".//surname" ).map(&:text)
      known_givennames = details.xpath(".//given-names").map(&:text)
 
      emails = email.xpath(".//email").map(&:text)
      usernames = emails.map { |email| email.match(/^(.+)@.+$/)[1] }
 
      names = []
      usernames.each do |username|
        names << $2 if username =~ /^([^.]+)\.(.+)$/ || username =~ /^(.)(.+)$/
      end
 
      surnames    = []
      givennames  = []
      names.each do |name|
        index = known_surnames.index { |surname| surname.match(/#{name}$/i) }
        next unless index
 
        surnames    << known_surnames[index]
        givennames  << known_givennames[index]
      end
    end
 
    oo.set(line, 'D', format_for_spreadsheet(surnames))
    oo.set(line, 'E', format_for_spreadsheet(givennames))
  end
end
