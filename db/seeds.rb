# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


admin1 = Manager.create!(
  full_name: "Ednaldo Pereira", 
  registration_number: '745.808.535-55', 
  email: "adm@teste.com", 
  password: "teste123", 
  is_super: true
)

admin2 = Manager.create!(
  full_name: "Adroaldo Silva Santos", 
  registration_number: '025.727.205-40', 
  email: "adm2@teste.com", 
  password: "teste123"
)

  resident_not_owner1 = Resident.create!(
    email: 'claudia@email.com', 
    password: 'teste123', 
    status: :not_owner, 
    full_name: 'Cláudia Rodrigues Gomes', 
    registration_number: '458.456.480-92'
  )
  
  resident_not_owner2 = Resident.create!(
  email: 'joao@email.com', 
  password: 'teste123', 
  status: :not_owner, 
  full_name: 'João da Silva', 
  registration_number: '478.040.830-09'
)

resident_not_owner3 = Resident.create!(
  email: 'maria@email.com', 
  password: 'teste123', 
  status: :not_owner, 
  full_name: 'Maria Oliveira', 
  registration_number: '231.887.610-07'
)

resident_not_owner4 = Resident.create!(
  email: 'pedro@email.com', 
  password: 'teste123', 
  status: :not_tenant, 
  full_name: 'Pedro Alves', 
  registration_number: '185.894.110-52'
)

resident_not_owner5 = Resident.create!(
  email: 'ana@email.com', 
  password: 'teste123', 
  status: :not_tenant, 
  full_name: 'Ana Souza', 
  registration_number: '031.661.130-10'
)

resident1 = Resident.create!(
  email:'fernando@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Fernando Marques Gomes',
  registration_number: '065.858.303-42'
)

resident2 = Resident.create!(
  email: 'marina@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Marina Santos Oliveira',
  registration_number: '077.497.020-08'
)

resident3 = Resident.create!(
  email: 'rafael@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Rafael Souza Lima',
  registration_number: '533.621.940-10'
)

resident4 = Resident.create!(
  email: 'carla@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Carla Oliveira Silva',
  registration_number: '013.484.600-16'
)

resident5 = Resident.create!(
  email: 'gustavo@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Gustavo Pereira Santos',
  registration_number: '896.562.710-92'
)

resident6 = Resident.create!(
  email: 'isabela@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Isabela Almeida Costa',
  registration_number: '614.881.230-47'
)

resident7 = Resident.create!(
  email: 'pedro2@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Pedro Machado Barbosa',
  registration_number: '277.796.720-26'
)

resident8 = Resident.create!(
  email: 'ana2@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Ana Luiza Cardoso',
  registration_number: '318.953.470-50'
)

resident9 = Resident.create!(
  email: 'bruno@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Bruno Oliveira Santos',
  registration_number: '516.791.320-91'
)

resident10 = Resident.create!(
  email: 'camila@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Camila Rodrigues Ferreira',
  registration_number: '564.830.190-17'
)

resident11 = Resident.create!(
  email: 'lucas@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Lucas Almeida Pereira',
  registration_number: '314.787.200-93'
)

resident12 = Resident.create!(
  email: 'julia@email.com',
  password: 'teste123', 
  status: :mail_confirmed,
  full_name: 'Julia Ferreira Lima',
  registration_number: '922.771.400-66'
)


condo1 = Condo.create!(
  name: 'Residencial Paineiras',
  registration_number: '28.278.614/0001-59',
  address_attributes: {
    public_place: 'Travessa João Edimar',
    number: '29',
    neighborhood: 'João Eduardo II',
    city: 'Rio Branco',
    state: 'AC',
    zip: '69911-520'
  }
)

condo2 = Condo.create!(
  name: 'Bela Vista',
  registration_number: '93.432.999/0001-29',
  address_attributes: {
    public_place: 'Rua das Flores',
    number: '123',
    neighborhood: 'Centro',
    city: 'São Paulo',
    state: 'SP',
    zip: '01000-000'
  }
)

condo3 = Condo.create!(
  name: 'Edifício Panorama',
  registration_number: '10.783.227/0001-04',
  address_attributes: {
    public_place: 'Avenida Brasil',
    number: '456',
    neighborhood: 'Jardins',
    city: 'Rio de Janeiro',
    state: 'RJ',
    zip: '20000-000'
  }
)

condo4 = Condo.create!(
  name: 'Residencial Vista Alegre',
  registration_number: '46.312.882/0001-21',
  address_attributes: {
    public_place: 'Praça das Nações',
    number: '789',
    neighborhood: 'Bela Vista',
    city: 'Porto Alegre',
    state: 'RS',
    zip: '90000-000'
  }
)

condo5 = Condo.create!(
  name: 'Jardins do Lago',
  registration_number: '04.219.568/0001-59',
  address_attributes: {
    public_place: 'Rua do Comércio',
    number: '101',
    neighborhood: 'Lago Sul',
    city: 'Brasília',
    state: 'DF',
    zip: '70000-000'
  }
)

condo6 = Condo.create!(
  name: 'Edifício Solar',
  registration_number: '54.015.828/0001-42',
  address_attributes: {
    public_place: 'Avenida das Américas',
    number: '202',
    neighborhood: 'Barra da Tijuca',
    city: 'Rio de Janeiro',
    state: 'RJ',
    zip: '20000-001'
  }
)

condo7 = Condo.create!(
  name: 'Residencial Nova Era',
  registration_number: '29.568.528/0001-43',
  address_attributes: {
    public_place: 'Rua XV de Novembro',
    number: '303',
    neighborhood: 'Centro',
    city: 'Curitiba',
    state: 'PR',
    zip: '80000-000'
  }
)

condo8 = Condo.create!(
  name: 'Condomínio Parque Verde',
  registration_number: '03.855.766/0001-46',
  address_attributes: {
    public_place: 'Alameda das Palmeiras',
    number: '404',
    neighborhood: 'Jardim Botânico',
    city: 'Belo Horizonte',
    state: 'MG',
    zip: '30000-000'
  }
)

condo9 = Condo.create!(
  name: 'Edifício Alto da Serra',
  registration_number: '32.195.003/0001-14',
  address_attributes: {
    public_place: 'Rua dos Pioneiros',
    number: '505',
    neighborhood: 'Serra',
    city: 'Vitória',
    state: 'ES',
    zip: '29000-000'
  }
)

condo10 = Condo.create!(
  name: 'Residencial Bosque Azul',
  registration_number: '97.634.355/0001-74',
  address_attributes: {
    public_place: 'Avenida das Acácias',
    number: '606',
    neighborhood: 'Bosque',
    city: 'Manaus',
    state: 'AM',
    zip: '69000-000'
  }
)


tower1 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'A', condo: condo1)
tower2 = Tower.create!(floor_quantity: 6, units_per_floor: 7, name: 'B', condo: condo1)
tower3 = Tower.create!(floor_quantity: 3, units_per_floor: 6, name: 'Norte', condo: condo2)
tower4 = Tower.create!(floor_quantity: 4, units_per_floor: 8, name: 'Sul', condo: condo2)
tower5 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'Torre 1', condo: condo3)
tower6 = Tower.create!(floor_quantity: 7, units_per_floor: 5, name: 'Torre 2', condo: condo3)
tower7 = Tower.create!(floor_quantity: 6, units_per_floor: 3, name: 'Alpha', condo: condo4)
tower8 = Tower.create!(floor_quantity: 8, units_per_floor: 4, name: 'Beta', condo: condo4)
tower9 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'Gamma', condo: condo5)
tower10 = Tower.create!(floor_quantity: 9, units_per_floor: 3, name: 'Delta', condo: condo5)
tower11 = Tower.create!(floor_quantity: 6, units_per_floor: 5, name: 'Epsilon', condo: condo6)
tower12 = Tower.create!(floor_quantity: 4, units_per_floor: 6, name: 'Zeta', condo: condo6)
tower13 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'Eta', condo: condo7)
tower14 = Tower.create!(floor_quantity: 6, units_per_floor: 7, name: 'Theta', condo: condo8)
tower15 = Tower.create!(floor_quantity: 5, units_per_floor: 6, name: 'Iota', condo: condo9)


residents = [
  resident1, resident2, resident3, resident4, resident5, resident6,
  resident7, resident8, resident9, resident10, resident11, resident12
]

towers_and_units = [
  { tower: tower1, floor_index: 0, unit_index: 0 },
  { tower: tower2, floor_index: 1, unit_index: 2 },
  { tower: tower3, floor_index: 2, unit_index: 3 },
  { tower: tower4, floor_index: 1, unit_index: 3 },
  { tower: tower5, floor_index: 3, unit_index: 1 },
  { tower: tower6, floor_index: 0, unit_index: 1 },
  { tower: tower7, floor_index: 1, unit_index: 0 },
  { tower: tower8, floor_index: 1, unit_index: 1 },
  { tower: tower9, floor_index: 0, unit_index: 0 },
  { tower: tower10, floor_index: 0, unit_index: 1 },
  { tower: tower11, floor_index: 1, unit_index: 0 },
  { tower: tower12, floor_index: 1, unit_index: 1 },
  { tower: tower13, floor_index: 0, unit_index: 0 },
  { tower: tower14, floor_index: 0, unit_index: 1 },
  { tower: tower15, floor_index: 1, unit_index: 0 },
  { tower: tower1, floor_index: 1, unit_index: 1 },
]

residents.each do |resident|
  towers_and_units.shuffle.each do |tu|
    tower = tu[:tower]
    floor_index = tu[:floor_index]
    unit_index = tu[:unit_index]

    unit = tower.floors[floor_index].units[unit_index]
    
    if unit.owner.nil?
      resident.properties << unit
      break if resident.save
    elsif unit.tenant.nil?
      resident.residence = unit
      break if resident.save
    end
  end
end


unit_type1 = UnitType.create!(
  description: 'Apartamento de 2 quartos',
  metreage: '50.55',
  condo: condo1
)

unit_type2 = UnitType.create!(
  description: 'Apartamento de 1 quarto',
  metreage: '40.25',
  condo: condo2
)

unit_type3 = UnitType.create!(
  description: 'Cobertura Duplex',
  metreage: '120.80',
  condo: condo3
)

unit_type4 = UnitType.create!(
  description: 'Studio',
  metreage: '35.00',
  condo: condo4
)

unit_type5 = UnitType.create!(
  description: 'Loft',
  metreage: '55.75',
  condo: condo5
)

unit_type6 = UnitType.create!(
  description: 'Kitnet',
  metreage: '30.50',
  condo: condo6
)

unit_type7 = UnitType.create!(
  description: 'Apartamento térreo com jardim',
  metreage: '70.00',
  condo: condo7
)

unit_type8 = UnitType.create!(
  description: 'Penthouse',
  metreage: '90.60',
  condo: condo8
)

unit_type9 = UnitType.create!(
  description: 'Casa em condomínio',
  metreage: '150.00',
  condo: condo9
)

unit_type10 = UnitType.create!(
  description: 'Apartamento com varanda gourmet',
  metreage: '65.30',
  condo: condo10
)

unit_type11 = UnitType.create!(
  description: 'Triplex',
  metreage: '180.00',
  condo: condo1
)

unit_type12 = UnitType.create!(
  description: 'Studio com mezanino',
  metreage: '45.80',
  condo: condo2
)

unit_type13 = UnitType.create!(
  description: 'Apartamento compacto',
  metreage: '38.75',
  condo: condo3
)

unit_type14 = UnitType.create!(
  description: 'Casa duplex',
  metreage: '200.00',
  condo: condo4
)

unit_type15 = UnitType.create!(
  description: 'Cobertura com piscina privativa',
  metreage: '110.50',
  condo: condo5
)

unit_types = [
  unit_type1, unit_type2, unit_type3, unit_type4, unit_type5,
  unit_type6, unit_type7, unit_type8, unit_type9, unit_type10,
  unit_type11, unit_type12, unit_type13, unit_type14, unit_type15
]

Tower.all.each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update unit_type_id: unit_types[index]
    end
  end
end