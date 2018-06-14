# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'csv'
require 'faker'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'time_zones.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if TimeZone.exists?(row['id'])
  else
    t = TimeZone.new
    t.id = row['id']
    t.offset = row['offset']
    t.name = row['name']
    t.abbr = row['abbr']
    t.save!
    puts "#{t.id}, #{t.offset}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'options.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if Option.exists?(row['id'])
  else
    t = Option.new
    t.id = row['id']
    t.key = row['key']
    t.value = row['value']
    t.save!
    puts "#{t.id}, #{t.key} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'locales.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  if Locale.exists?(row['id'])
    else
      t = Locale.new
      t.id = row['id']
      t.code = row['code']
      t.fb_locale = row['fb_locale']
      t.fb_page = row['fb_page']
      t.fb_page_id = row['fb_page_id']
      t.redirect_link = row['redirect_link']
      t.logo_link = row['logo_link']
      t.active = row['active']
      t.isAPAC = row['isAPAC']
      t.tracking_code = row['tracking_code']
      t.tracking_domain = row['tracking_domain']
      t.twitter_link = row['twitter_link']
      t.name = row['name']
      t.facebook_url = row['facebook_url']
      t.twitter_url = row['twitter_url']
      t.youtube_url = row['youtube_url']
      t.pinterest_url = row['pinterest_url']
      t.instagram_url = row['instagram_url']
      t.save!
      puts "#{t.id}, #{t.code}, #{t.fb_locale}, #{t.fb_page}, #{t.fb_page_id}, #{t.redirect_link},
         #{t.logo_link}, #{t.active}, #{t.isAPAC}, #{t.tracking_code}, #{t.tracking_domain},
         #{t.twitter_link},#{t.name}, #{t.facebook_url}, #{t.twitter_url}, #{t.youtube_url}, #{t.pinterest_url},
         #{t.instagram_url} saved"
    end
end

# csv_text = File.read(Rails.root.join('lib', 'seeds', 'preferences.csv'))
# csv = CSV.parse(csv_text, :headers => true)
# csv.each do |row|
#   if Preference.exists?(row['id'])
#   else
#     t = Preference.new
#     t.id = row['id']
#     t.name = row['name']
#     t.company = row['company']
#     t.url = row['url']
#     t.seo_title = row['seo_title']
#     t.mail_from_address = row['mail_from_address']
#     t.default = row['default']
#     t.default_country_code = row['default_country_code']
#     t.is_domestic = row['is_domestic']
#     t.save!
#     puts "Preference saved"
#   end
# end


csv_text = File.read(Rails.root.join('lib', 'seeds', 'activity_objects.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if ActivityObject.exists?(row['id'])
  else
    t = ActivityObject.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'roles.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if Role.exists?(row['id'])
  else
    t = Role.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'payment_statuses.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if PaymentStatus.exists?(row['id'])
  else
    t = PaymentStatus.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'project_states.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if ProjectState.exists?(row['id'])
  else
    t = ProjectState.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'project_types.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if ProjectType.exists?(row['id'])
  else
    t = ProjectType.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'states.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if State.exists?(row['id'])
  else
    t = State.new
    t.id = row['id']
    t.name = row['name']
    t.abbr = row['abbr']
    t.country_id = row['country_id']
    t.save!
    puts "#{t.id}, #{t.name}, #{t.abbr}, #{t.country_id} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'countries.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if Country.exists?(row['id'])
  else
    t = Country.new
    t.id = row['id']
    t.iso_name = row['iso_name']
    t.iso = row['iso']
    t.iso3 = row['iso3']
    t.name = row['name']
    t.numcode = row['numcode']
    t.states_required = row['states_required']
    t.save!
    puts "#{t.id}, #{t.iso_name}, #{t.iso}, #{t.iso3}, #{t.name}, #{t.numcode}, #{t.states_required} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'task_types.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if TaskType.exists?(row['id'])
  else
    t = TaskType.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'contact_types.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if ContactType.exists?(row['id'])
  else
    t = ContactType.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'sales_case_statuses.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if SaleCaseStatus.exists?(row['id'])
  else
    t = SaleCaseStatus.new
    t.id = row['id']
    t.name = row['name']
    t.save!
    puts "#{t.id}, #{t.name} saved"
  end
end

csv_text = File.read(Rails.root.join('lib', 'seeds', 'users.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  if User.exists?(row['id'])
  else
    t = User.new
    t.id = row['id']
    t.first_name = row['first_name']
    t.last_name = row['last_name']
    t.username = row['username']
    t.email = row['email']
    t.password = row['password']
    t.password_confirmation = row['password_confirmation']
    t.locale_id = row['locale_id']
    t.role_id = row['role_id']
    t.save!
    puts "#{t.id}, #{t.first_name} saved"
  end
end

# contact_test = Contact.all
# if !contact_test.any?
#   100.times do
#     c = Contact.new
#     c.first_name = Faker::Name.first_name
#     c.last_name = Faker::Name.last_name
#     c.email = Faker::Internet.safe_email
#     c.about = Faker::Name.title
#     c.contact_type_id = Faker::Number.between(1, 6)
#     c.locale_id = 36
#     c.company_name = Faker::Company.name
#     c.time_zone_id = Faker::Number.between(1, 8)
#     c.is_client = Faker::Boolean.boolean
#     c.save!
#   end
# end

# team_test = Contact.team_scope
# if !team_test.any?
#   10.times do
#     c = Contact.new
#     c.first_name = Faker::Name.first_name
#     c.last_name = Faker::Name.last_name
#     c.email = Faker::Internet.safe_email
#     c.contact_type_id = ContactType.where(name: 'Teammate').first.id
#     c.locale_id = 36
#     c.time_zone_id = Faker::Number.between(1, 8)
#     c.is_team = true
#     c.save!
#   end
# end

# project_test = Project.all

# if !project_test.any?
#   100.times do
#     proj = Project.new
#     proj.name = Faker::Company.name
#     proj.client_contact_id = Faker::Number.between(7, 90)
#     proj.project_state_id = Faker::Number.between(1, 6)
#     proj.project_type_id = Faker::Number.between(1, 15)
#     proj.start_date = Faker::Date.between(1.year.ago, 1.year.from_now)
#     proj.end_date = Faker::Date.between(1.year.from_now, 2.year.from_now)
#     proj.notes = Faker::Lorem.paragraph
#     proj.client.slug = Faker::Hacker.abbreviation
#     proj.save!
#   end
# end

