# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin = Manager.create!(full_name: "Murilo Pereira Rocha", registration_number: '745.808.535-55', 
  email: "adm@teste.com", password: "teste123")

condo = Condo.create!(name:'Condominio Residencial Paineiras', registration_number: "62.810.952/2718-22",
        address_attributes:{public_place: 'Travessa João Edimar', number: '29', neighborhood: 'João Eduardo II',
        city: 'Rio Branco', state: 'AC', zip: '69911-520'})