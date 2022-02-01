# contents = File.read('event_attendees.csv')
# puts contents

=begin
lines = File.readlines('event_attendees.csv')
lines.each do |line|
    #splitting up each line into 'columns', designated by comma separation
    columns = line.split(",")
    #the third column holds the first_name data
    name = columns[2]
    puts name
end
=end

=begin
lines = File.readlines('event_attendees.csv')
# iterate with index so that you can skip over the header line, since it is just describing the column contents.
lines.each_with_index do |line, index|
    next if index == 0
    columns = line.split(",")
    name = columns[2]
    puts name
end
=end

# -----------

# Look for a solution before building a solution. Instead of creating a CSV parser, we can use Ruby's built in CSV.

# we have to 'require' the CSV library
=begin
require 'csv'
puts "Event Manager Initialized"

contents = CSV.open('event_attendees.csv', headers: true)
contents.each do |row|
    name = row[2]
    puts name
end
=end 

# ------------

# instead of the above,
# we can convert the headers into symbols. It will translate into snake_case, so first_Name becomes first_name and HomePhone becomes homephone.

=begin
require 'csv'
puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)
contents.each do |row|
    name = row[:first_name]
    zipcode = row[:zipcode]

    #some of the zipcodes are missing or incomplete. 
    #before diving into creating a solution, write some pseudocode to explain what we want to accomplish
    # if zip code is exactly 5 digits, assume it is ok
    # if zip code is more than 5 digits, truncate it to be the first five digits
    # if zip code is less than 5 digits, add zeros at the front until it is five digits
    if zipcode.nil?
        zipcode = '00000'
    elsif zipcode.length < 5
        zipcode = zipcode.rjust(5, '0')
    elsif zipcode.length > 5
        zipcode = zipcode[0..4]
    end
    #this accomplishes what we want and does so clearly
    #however, it should be its own method

    puts "#{name} #{zipcode}"
end
=end

# -----------

=begin
require 'csv'

def clean_zipcode(zipcode)
    if zipcode.nil?
        zipcode = '00000'
    elsif zipcode.length < 5
        zipcode = zipcode.rjust(5, '0')
    elsif zipcode.length > 5
        zipcode = zipcode[0..4]
    else
        zipcode
    end
end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    puts "#{name} #{zipcode}"
end
=end

# ----------

#now to refactor the code to see if it can be made any clearer or more succinct

# a good rule when developing in Ruby is to favor coercing values into similar values so they behave the same
# so instead of checking if something is nil, we can just convert anything NilClass#to_s

# looking at String#rjust, it performs no work if provided a string with a length greather than five
# so we can apply it in any case

# looking at String#slice, it performs no work if provided a string that is the correct length
# so it too can be applied in any case

=begin
require 'csv'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    puts "#{name} #{zipcode}"
end
=end

# ----------

# now to access the info we want from Google's Civic Information API

=begin
require 'csv'
require 'google/apis/civicinfo_v2'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    begin
    legislators = civic_info.representative_info_by_address(
        address: zipcode,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
    # including a begin and rescue clause will let us handle errors like situations of missing/incorrect data

    puts "#{name} #{zipcode} #{legislators}"
end
=end

# the output that this displays is the RAW legislator object. 

# ----------------------------

#we want to capture each legislator name
# - for each zip code, iterate over the array of legislators
# - for each legislator, we want to find the representative's name
# - add the name to a new collection of names

=begin
require 'csv'
require 'google/apis/civicinfo_v2'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    begin
    legislators = civic_info.representative_info_by_address(
        address: zipcode,
        levels: 'country',
        roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    #we can use #map which returns a new array of the data we want to include
    # legislator_names = legislators.map do |legislator|
    #   legislator.name
    # end
    #this can be simplified further into
    legislator_names = legislators.map(&:name)
    #if we print legislator_names, it gives us an array. We can alter this into a list with Array#join
    legislators_string = legislator_names.join(", ")
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
    # including a begin and rescue clause will let us handle errors like situations of missing/incorrect data

    puts "#{name} #{zipcode} #{legislators_string}"
end
=end

# ---------------

# now we want to look back again and determine if this is as clear and succint as it can be
# it is clear, however, we should again extract what we did into its own method

=begin
require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        )
        legislators = legislators.officials
        legislator_names = legislators.map(&:name)
        legislator_names.join(", ")
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end

end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    legislators = legislators_by_zipcode(zipcode)

    puts "#{name} #{zipcode} #{legislators}"
end
=end

# ------------------
# now we want to use this information in a customized letter 
# we will do this with a linked html file 

=begin
require 'csv'
require 'google/apis/civicinfo_v2'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        )
        legislators = legislators.officials
        legislator_names = legislators.map(&:name)
        legislator_names.join(", ")
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end

end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

template_letter = File.read('form_letter.html')
# creates variable of the letter template as a String of text
# we can use String#gsub to replace certain words and personalize it

contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    legislators = legislators_by_zipcode(zipcode)

    # create copy of the template and use the non-destructive gsub on this step, so as not to overwrite it
    personal_letter = template_letter.gsub('FIRST_NAME', name)
    personal_letter.gsub!('LEGISLATORS', legislators)

    puts personal_letter
end
=end

# ------------------
# instead of building our own custom solution, we could instead use Ruby's ERB
# it is a template language that allows Ruby code to be added to any plain text document 

=begin
require 'csv'
require 'google/apis/civicinfo_v2'
# require the erb library
require 'erb'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
        # simplified this to return the original array of legislators
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end

end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
# we now are linking to a file with an .erb suffix, loaded as a string again.
# creat the ERB template from the contents of the template file, passing it in as a parameter
erb_template = ERB.new template_letter


contents.each do |row|
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    legislators = legislators_by_zipcode(zipcode)

    form_letter = erb_template.result(binding)

    puts form_letter
end
=end

# ------------------
# now it is time to save each form letter to a file.
# - assign an ID for each attendee
# - create an output folder
# - save each form letter to a file based on the id of the attendee

=begin
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
    id = row[0]
    #assign ID
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    legislators = legislators_by_zipcode(zipcode)

    form_letter = erb_template.result(binding)

    Dir.mkdir('output') unless Dir.exist?('output')
    # create an output folder, unless it already exists.
    
    filename = "output/thanks_#{id}.html"
    #save each form letter to a file based on the id of the attendee

    # File#open allows us to open a file for reading and writing.
    # the first parameter is the filename, the second is a flag that states how we want to open the file
    # the 'w' states we want to open the file for writing.
    # caution with this bc if the file already exists, 'w' will write over it.
    File.open(filename, 'w') do |file|
        file.puts form_letter
        # this sends the entire form letter content to the file object
    end

    puts form_letter
end
=end

# ---------------
# again, time to keep it clean and move the operation of saving the form letter to its own method.

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        legislators = civic_info.representative_info_by_address(
            address: zipcode,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

def save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
    end
end

puts "Event Manager Initialized"

contents = CSV.open(
    'event_attendees.csv',
    headers: true,
    header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
    id = row[0]
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    legislators = legislators_by_zipcode(zipcode)

    form_letter = erb_template.result(binding)

    save_thank_you_letter(id, form_letter)
end