# rails runner 'load(File.join(Rails.root, "db", "seeds", "rb", "users.rb"))'

require 'open-uri'

puts 'Creating 10 users with photos, please wait, this process may take a while...'


10.times do
  user = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    role: 0,
    email: Faker::Internet.email,
    password: '123456' # needs to be 6 digits
    # add any additional attributes you have on your model
  )

  # NOTA: debe tener instalado y configurado activestorage para usar esta opción

  file = URI.open('https://thispersondoesnotexist.com/')
  user.photo.attach(io: file, filename: 'photo.jpg', content_type: 'image/jpg')
end

puts '10 users successfully created!'
