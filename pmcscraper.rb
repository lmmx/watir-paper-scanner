#!/usr/bin/env ruby
# encoding: UTF-8

unless defined?(Roo) && defined?(Watir)
  require "google_drive"
  require "roo"
end

unless defined?(GOOGLE_MAIL).nil? && defined?(GOOGLE_PASSWORD)
    puts "Please enter your Gmail address"
    GOOGLE_MAIL = gets.chomp
    puts "Please enter your password"
    GOOGLE_PASSWORD = gets.chomp
    puts "Thanks!"
end

key = "0Aj697J8sF_ekdHM4NVBRZWV0eXFERGxrWEdzSlRReUE"
oo = Roo::Google.new(key, user: GOOGLE_MAIL, password: GOOGLE_PASSWORD)
puts "Loading spreadsheet .  .  ."
oo.default_sheet = "pubmed_result"
  
unless defined?(Net)
    require "net/http"
end

unless defined?(Nokogiri)
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
  puts line  # keep this - see progress
 
  surnames    = oo.cell(line, 'D')
  givennames  = oo.cell(line, 'E')
  eutils_url  = oo.cell(line, 'S')

  if eutils_url && eutils_url != ""
    uri       = URI.parse(eutils_url)
    xml_data  = Net::HTTP.get_response(uri).body
    document  = Nokogiri::XML.parse(xml_data)
 
    details  = document.at('contrib:has(xref[text()="*"])') || document.at('//*[@corresp]') || document.at('//*[@ref-type="corresp"]') 
    email    = document.xpath('//*[@email]')
    email    = document.xpath('//email') if email.empty?
 
    surnames   = nil
    givennames = nil
    if details
      surnames   = details.xpath(".//surname" ).map(&:text)
      givennames = details.xpath(".//given-names").map(&:text)
      puts "Checking XML details..."
    elsif email.any?
      details = document.at('contrib')
      known_surnames   = details.xpath("..//surname" ).map(&:text)
      known_givennames = details.xpath("..//given-names").map(&:text)
      puts "Parsing an email address...."
 
      emails = email.map(&:text)
      usernames = emails.map { |email| email.match(/^(.+)@.+$/)[1] }
puts "email:"
puts email.inspect    # test what is
puts "emails:"
puts emails.inspect   # coming out

# note: this still needs to decide on a correct name from email addresses
#       shouldn't be hard now I have the array of names and parsed email
 
      names = []
      usernames.each do |username|
        names << $2 if username =~ /^([^.]+)\.(.+)$/ || username =~ /^(.)(.+)$/
      end
 
      surnames    = []
      givennames  = []
      names.each do |name|
	name = name.downcase
	index = known_surnames.index do |surname|
	  surname = surname.downcase
	  initials = surname.split(/[- ]/).map { |x| x[0] }.join
	  surname == name || surname.end_with?(name) || initials == name
puts "surname value:"
puts surname
	end 
        next unless index
 
        surnames    << known_surnames[index]
        givennames  << known_givennames[index]
      end
    end
 
    oo.set(line, 'D', format_for_spreadsheet(surnames))
    oo.set(line, 'E', format_for_spreadsheet(givennames))
  end
end
