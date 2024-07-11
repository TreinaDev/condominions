# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin1 = Manager.create!(full_name: "Murilo Pereira Rocha", registration_number: '745.808.535-55', 
  email: "adm@teste.com", password: "teste123")

admin2 = Manager.create!(full_name: "Adroaldo Silva Santos", registration_number: '025.727.205-40', 
  email: "adm2@teste.com", password: "teste123")


resident_not_owner = Resident.create!(email: 'claudia@email.com', password: 'teste123', 
  status: :not_owner, full_name: 'Cláudia Rodrigues Gomes', registration_number: '963.259.578-57')
  
condo = Condo.create!(name:'Residencial Paineiras', registration_number: "62.810.952/2718-22",
       address_attributes:{public_place: 'Travessa João Edimar', number: '29', neighborhood: 'João Eduardo II',
       city: 'Rio Branco', state: 'AC', zip: '69911-520'})

tower1 = Tower.create!(floor_quantity: 5, units_per_floor:  4, name: 'A', condo: condo)
tower2 = Tower.create!(floor_quantity: 6, units_per_floor:  7, name: 'B', condo: condo)



condo2 = Condo.create!(name:'Residencial João Alvez', registration_number: "36.260.868/0105-64",
       address_attributes:{public_place: 'Travessa Aguar', number: '2359', neighborhood: 'João Bispo 25' ,
       city: 'Rio Azul', state: 'SE', zip: '49510-520'})

tower3 = Tower.create!(floor_quantity: 3, units_per_floor:  6, name: 'Norte', condo: condo2)
tower4 = Tower.create!(floor_quantity: 4, units_per_floor:  8, name: 'Sul', condo: condo2)


resident = Resident.create!(email:'fernando@email.com', password: 'teste123', 
  status: :mail_confirmed, full_name: 'Fernando Marques Gomes', registration_number: '065.858.303-42')


resident.units << tower3.floors[1].units[2]
resident.units << tower3.floors[2].units[2]
resident.units << tower4.floors[1].units[1]
resident.residence = tower3.floors[1].units[2]


