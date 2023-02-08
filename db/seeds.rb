require 'faker'

puts "Seeding - START"

puts "Seeding properties"

User.create(name:"admin", email:"test2@mail.com", phone:"12345566778", user_type:"landlord", password:"123456");

# 12.times do |i|

#   User.create(name:"admin#{i}", email:"test2#{i}@mail.com", phone:"12345566778", user_type:["landlord", "seeker"].sample, password:"123456");
# end

3.times do |i|
  bedrooms = rand(1..6)
  bathrooms = rand(1..4)
  area = rand(50..1000)
  pet_allowed = [true, false].sample
  price = rand(1000..10000)
  mode = ["sale", "rent"].sample
  province  = [
    "Amazonas",
    "Ancash",
    "Apurimac",
    "Arequipa",
    "Ayacucho",
    "Cajamarca",
    "Callao",
    "Cusco",
    "Huancavelica",
    "Huanuco",
    "Ica",
    "Junin",
    "La Libertad",
    "Lambayeque",
    "Lima",
    "Loreto",
    "Madre de Dios",
    "Moquegua",
    "Pasco",
    "Piura",
    "Puno",
    "San Martin",
    "Tacna",
    "Tumbes",
    "Ucayali"
  ].sample
  district = [
    "San Juan de Lurigancho",
    "San Miguel",
    "Los Olivos",
    "Comas",
    "Chorrillos",
    "El Agustino",
    "Pueblo Libre",
    "San Isidro",
    "La Victoria",
    "Magdalena del Mar",
    "San Juan de Miraflores",
    "San Luis",
    "Pachacamac",
    "Villa El Salvador",
    "San Martin de Porres",
    "Ancon",
    "Pucusana",
    "Santa Maria del Mar",
    "La Punta",
    "San Borja",
    "San Rafael",
    "Surco",
    "Ate",
    "Callao",
    "La Molina",
    "San Juan de Lurigancho",
    "Santiago de Surco",
    "San Bartolo",
    "San Juan de Lurigancho",
    "San Juan de Miraflores",
    "San Miguel",
    "Bellavista",
    "Los Reyes",
    "San Juan de Lurigancho",
    "San Miguel",
    "Los Olivos",
    "Comas",
    "Chorrillos",
    "El Agustino",
    "Pueblo Libre",
    "San Isidro",
    "La Victoria",
    "Magdalena del Mar",
    "San Juan de Miraflores",
    "San Luis"].sample
  description = Faker::Lorem.sentences(number: 1)
  property_type= ["house","apartment"].sample
  status= [true, false].sample
  maintenance = rand(100..500)
  latitud = (rand(-1300..-1000))/100
  longitud = (rand(-7750..-7530))/100
  user_id = 1#rand(1...12)
  property = Property.create(bedrooms: bedrooms, 
                             bathrooms: bathrooms, 
                             area: area, 
                             pet_allowed: pet_allowed, 
                             price: price, 
                             mode:mode,
                             description: description, 
                             property_type: property_type,
                             status:status,
                             province: province,
                             district: district,
                             latitud: latitud,
                             longitud: longitud,
                             maintenance: maintenance,
                             user_id: user_id,
                            )
  property.images.attach(io: File.open("db/images/house#{i+1}.png"), filename: "house#{i+1}.png")
  property.images.attach(io: File.open("db/images/house#{i+2}.png"), filename: "house#{i+2}.png")
  property.images.attach(io: File.open("db/images/house#{i+3}.png"), filename: "house#{i+3}.png")
  property.images.attach(io: File.open("db/images/house#{i+4}.png"), filename: "house#{i+4}.png")

end

# puts "Create favorites and contacted"
# 50.times do |i|
#   involved = InvolvedProperty.new(user_id:rand(1...12) , property_id:rand(1...12) , favorite: [true, false].sample, contacts: [true, false].sample)
#   find_involved = InvolvedProperty.where(user_id:involved.user_id, property_id:involved.property_id)
#   involved.save() if !find_involved
# end

puts "Finished"