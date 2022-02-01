require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'date'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_number(homephone)
    number = homephone.to_s.gsub(/\D/, '')

    if number[0] == "1" then number.delete_prefix("1") end

    number.length == 10 ? number : "Invalid Number"
end

def get_reg_hour(string)
    time = string.split(' ')[1]
    hour = time.split(':')[0]
end

def get_weekday(string)
    date = string.split(' ')[0]
    date = Date.strptime(date, "%m/%d/%Y")
    weekday = date.strftime("%A")
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

# code to create thank you letters
=begin
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
=end

all_reg_times = Hash.new(0)
all_reg_days = Hash.new(0)

contents.each do |row|
    # phone numbers
    name = row[:first_name]
    phone = clean_phone_number(row[:homephone])
    #puts "#{name}: #{phone}"

    # registration times 
    reg_hour = get_reg_hour(row[:regdate])
    all_reg_times["Hour #{reg_hour}:00"] += 1

    #registration dates
    weekday = get_weekday(row[:regdate])
    all_reg_days[weekday] += 1
end

sorted_registrations = all_reg_times.sort_by { |hour, registrations| -registrations }
sorted_days = all_reg_days.sort_by { |day, registrations| -registrations }

puts "\nruby lib/event_manager.rbMost popular hours to register (and how many registrations occured in each hour): #{sorted_registrations} \n "
puts "Most popular days to register (and how many registrations occured on each day): #{sorted_days}"



