require 'faker'

puts "Seeding - START"

puts "Seeding properties"

User.create(name:"admin", email:"test2@mail.com", phone:"12345566778", user_type:"landlord", password:"123456");

12.times do |i|

  User.create(name:"admin#{i}", email:"test2#{i}@mail.com", phone:"12345566778", user_type:["landlord", "seeker"].sample, password:"123456");
end

12.times do |i|
  bedrooms = rand(1..6)
  bathrooms = rand(1..4)
  area = rand(50..1000)
  pet_allowed = [true, false].sample
  price = rand(1000..10000)
  mode = ["sale", "rent"].sample
  address = Faker::Address.street_address
  description = Faker::Lorem.sentences(number: 1)
  property_type= ["house","apartment"].sample
  status= [true, false].sample
  maintenance = rand(100..500)
  user_id = rand(1...12)
  property = Property.create(bedrooms: bedrooms, 
                             bathrooms: bathrooms, 
                             area: area, 
                             pet_allowed: pet_allowed, 
                             price: price, 
                             mode:mode,
                             address: address, 
                             description: description, 
                             property_type: property_type,
                             status:status,
                             maintenance: maintenance,
                             user_id: user_id,
                            )
  property.image.attach(io: File.open("db/images/house#{i+1}.png"), filename: "house#{i+1}.png")

end

puts "Create favorites and contacted"
50.times do |i|
  involved = InvolvedProperty.new(user_id:rand(1...12) , property_id:rand(1...12) , favorite: [true, false].sample, contacts: [true, false].sample)
  find_involved = InvolvedProperty.where(user_id:involved.user_id, property_id:involved.property_id)
  involved.save() if !find_involved
end

puts "Finished"