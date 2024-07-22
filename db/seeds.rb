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
  password: "teste123",
  is_super: false,
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

condo1.managers << admin2

tower1 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'A', condo: condo1)
tower2 = Tower.create!(floor_quantity: 6, units_per_floor: 7, name: 'B', condo: condo1)

unit_type1 = UnitType.create!(
  description: 'Apartamento de 2 quartos',
  metreage: '50.55',
  condo: condo1
)

unit_type11 = UnitType.create!(
  description: 'Triplex',
  metreage: '180.00',
  condo: condo1
)

unit_type_condo_1 = [unit_type1, unit_type11]
[tower1, tower2].each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update(unit_type: unit_type_condo_1[index % unit_type_condo_1.size])
    end
  end
  tower.complete!
end

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

tower3 = Tower.create!(floor_quantity: 3, units_per_floor: 6, name: 'Norte', condo: condo2)
tower4 = Tower.create!(floor_quantity: 4, units_per_floor: 8, name: 'Sul', condo: condo2)

unit_type2 = UnitType.create!(
  description: 'Apartamento de 1 quarto',
  metreage: '40.25',
  condo: condo2
)

unit_type12 = UnitType.create!(
  description: 'Studio com mezanino',
  metreage: '45.80',
  condo: condo2
)

unit_type_condo_2 = [unit_type2, unit_type12]
[tower3, tower4].each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update(unit_type: unit_type_condo_2[index % unit_type_condo_2.size])
    end
  end
  tower.complete!
end

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

tower5 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'Torre 1', condo: condo3)
tower6 = Tower.create!(floor_quantity: 7, units_per_floor: 5, name: 'Torre 2', condo: condo3)

unit_type3 = UnitType.create!(
  description: 'Cobertura Duplex',
  metreage: '120.80',
  condo: condo3
)

unit_type13 = UnitType.create!(
  description: 'Apartamento compacto',
  metreage: '38.75',
  condo: condo3
)

unit_type_condo_3 = [unit_type3, unit_type13]
[tower5, tower6].each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update(unit_type: unit_type_condo_3[index % unit_type_condo_3.size])
    end
  end
  tower.complete!
end

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

tower7 = Tower.create!(floor_quantity: 6, units_per_floor: 3, name: 'Alpha', condo: condo4)
tower8 = Tower.create!(floor_quantity: 8, units_per_floor: 4, name: 'Beta', condo: condo4)

unit_type4 = UnitType.create!(
  description: 'Studio',
  metreage: '35.00',
  condo: condo4
)

unit_type14 = UnitType.create!(
  description: 'Casa duplex',
  metreage: '200.00',
  condo: condo4
)

unit_type_condo_4 = [unit_type4, unit_type14]
[tower7, tower8].each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update(unit_type: unit_type_condo_4[index % unit_type_condo_4.size])
    end
  end
  tower.complete!
end

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

tower9 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'Gamma', condo: condo5)
tower10 = Tower.create!(floor_quantity: 9, units_per_floor: 3, name: 'Delta', condo: condo5)

unit_type5 = UnitType.create!(
  description: 'Loft',
  metreage: '55.75',
  condo: condo5
)

unit_type15 = UnitType.create!(
  description: 'Cobertura com piscina privativa',
  metreage: '110.50',
  condo: condo5
)

unit_type_condo_5 = [unit_type5, unit_type15]
[tower9, tower10].each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update(unit_type: unit_type_condo_5[index % unit_type_condo_5.size])
    end
  end
  tower.complete!
end

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

tower11 = Tower.create!(floor_quantity: 6, units_per_floor: 5, name: 'Epsilon', condo: condo6)
tower12 = Tower.create!(floor_quantity: 4, units_per_floor: 6, name: 'Zeta', condo: condo6)

unit_type6 = UnitType.create!(
  description: 'Kitnet',
  metreage: '30.50',
  condo: condo6
)

unit_type_condo_6 = [unit_type6]
[tower11, tower12].each do |tower|
  tower.floors.each do |floor|
    floor.units.each_with_index do |unit, index|
      unit.update(unit_type: unit_type_condo_6[index % unit_type_condo_6.size])
    end
  end
  tower.complete!
end

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

unit_type7 = UnitType.create!(
  description: 'Apartamento térreo com jardim',
  metreage: '70.00',
  condo: condo7
)

tower13 = Tower.create!(floor_quantity: 5, units_per_floor: 4, name: 'Eta', condo: condo7)

tower13.floors.each do |floor|
  floor.units.each_with_index do |unit, index|
    unit.update(unit_type: unit_type7)
  end
end
tower13.complete!

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

unit_type8 = UnitType.create!(
  description: 'Penthouse',
  metreage: '90.60',
  condo: condo8
)

tower14 = Tower.create!(floor_quantity: 6, units_per_floor: 7, name: 'Theta', condo: condo8)

tower14.floors.each do |floor|
  floor.units.each_with_index do |unit, index|
    unit.update(unit_type: unit_type8)
  end
end
tower14.complete!

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

tower15 = Tower.create!(floor_quantity: 5, units_per_floor: 6, name: 'Iota', condo: condo9)

unit_type9 = UnitType.create!(
  description: 'Casa em condomínio',
  metreage: '150.00',
  condo: condo9
)

tower15.floors.each do |floor|
  floor.units.each_with_index do |unit, index|
    unit.update(unit_type: unit_type9)
  end
end
tower15.complete!

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

tower16 = Tower.create!(floor_quantity: 3, units_per_floor: 2, name: 'Omega', condo: condo10)

unit_type10 = UnitType.create!(
  description: 'Apartamento com varanda gourmet',
  metreage: '65.30',
  condo: condo10
)

tower16.floors.each do |floor|
  floor.units.each_with_index do |unit, index|
    unit.update(unit_type: unit_type10)
  end
end
tower16.complete!

resident_property_registration_pending1 = Resident.create!(
  email: 'claudia@email.com',
  password: 'teste123',
  status: :property_registration_pending,
  full_name: 'Cláudia Rodrigues Gomes',
  registration_number: '458.456.480-92',
  residence: tower1.floors[0].units[0]
)

resident_property_registration_pending2 = Resident.create!(
  email: 'joao@email.com',
  password: 'teste123',
  status: :property_registration_pending,
  full_name: 'João da Silva',
  registration_number: '478.040.830-09',
  residence: tower1.floors[1].units[0]
)

resident_property_registration_pending3 = Resident.create!(
  email: 'maria@email.com',
  password: 'teste123',
  status: :property_registration_pending,
  full_name: 'Maria Oliveira',
  registration_number: '231.887.610-07',
  residence: tower1.floors[2].units[0]
)

resident_property_registration_pending4 = Resident.create!(
  email: 'pedro@email.com',
  password: 'teste123',
  status: :residence_registration_pending,
  full_name: 'Pedro Alves',
  registration_number: '185.894.110-52',
  residence: tower1.floors[3].units[0]
)

resident_property_registration_pending5 = Resident.create!(
  email: 'ana@email.com',
  password: 'teste123',
  status: :residence_registration_pending,
  full_name: 'Ana Souza',
  registration_number: '031.661.130-10',
  residence: tower1.floors[4].units[0]
)

resident1 = Resident.create!(
  email:'fernando@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Fernando Marques Gomes',
  registration_number: '065.858.303-42',
  residence: tower1.floors[0].units[1],
  properties: [
                tower1.floors[0].units[2],
                tower1.floors[0].units[3]
              ]
)

resident2 = Resident.create!(
  email: 'marina@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Marina Santos Oliveira',
  registration_number: '077.497.020-08',
  residence: tower2.floors[0].units[1],
  properties: [
                tower2.floors[0].units[2],
                tower2.floors[0].units[3],
                tower6.floors[0].units[0],
                tower6.floors[0].units[1],
                tower6.floors[1].units[0],
                tower6.floors[1].units[1],
              ]
)

resident3 = Resident.create!(
  email: 'rafael@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Rafael Souza Lima',
  registration_number: '533.621.940-10',
  residence: tower2.floors[0].units[2],
  properties: [
                tower2.floors[1].units[2],
                tower2.floors[1].units[3]
              ]
)

resident4 = Resident.create!(
  email: 'carla@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Carla Oliveira Silva',
  registration_number: '013.484.600-16',
  residence: tower2.floors[2].units[3],
  properties: [
                tower2.floors[2].units[2],
                tower2.floors[2].units[3]
              ]
)

resident5 = Resident.create!(
  email: 'gustavo@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Gustavo Pereira Santos',
  registration_number: '896.562.710-92',
  residence: tower2.floors[3].units[1],
  properties: [
                tower2.floors[3].units[2],
                tower2.floors[3].units[3]
              ]
)

resident6 = Resident.create!(
  email: 'isabela@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Isabela Almeida Costa',
  registration_number: '614.881.230-47',
  residence: tower3.floors[0].units[0],
  properties: [
                tower3.floors[0].units[1],
                tower3.floors[0].units[2]
              ]
)

resident7 = Resident.create!(
  email: 'pedro2@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Pedro Machado Barbosa',
  registration_number: '277.796.720-26',
  residence: tower3.floors[1].units[0],
  properties: [
                tower3.floors[1].units[1],
                tower3.floors[1].units[2]
              ]
)

resident8 = Resident.create!(
  email: 'ana2@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Ana Luiza Cardoso',
  registration_number: '318.953.470-50',
  residence: tower3.floors[2].units[0],
  properties: [
                tower3.floors[2].units[1],
                tower3.floors[2].units[2]
              ]
)

resident9 = Resident.create!(
  email: 'bruno@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Bruno Oliveira Santos',
  registration_number: '516.791.320-91',
  residence: tower4.floors[0].units[0],
  properties: [
                tower4.floors[0].units[1],
                tower4.floors[0].units[2]
              ]
)

resident10 = Resident.create!(
  email: 'camila@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Camila Rodrigues Ferreira',
  registration_number: '564.830.190-17',
  residence: tower4.floors[1].units[0],
  properties: [
                tower4.floors[1].units[1],
                tower4.floors[1].units[2]
              ]
)

resident11 = Resident.create!(
  email: 'lucas@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Lucas Almeida Pereira',
  registration_number: '314.787.200-93',
  residence: tower4.floors[2].units[0],
  properties: [
                tower4.floors[2].units[1],
                tower4.floors[2].units[2]
              ]
)

resident12 = Resident.create!(
  email: 'julia@email.com',
  password: 'teste123',
  status: :mail_confirmed,
  full_name: 'Julia Ferreira Lima',
  registration_number: '922.771.400-66',
  residence: tower4.floors[3].units[0],
  properties: [
                tower4.floors[3].units[1],
                tower4.floors[3].units[2]
              ]
)

common_area1 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Churrasqueira',
  description: 'Churrasco comunitário',
  max_occupancy: 50,
  rules: 'Proibido fumar'
)

common_area2 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Piscina',
  description: 'Piscina grande com deck',
  max_occupancy: 30,
  rules: 'Proibido comida e bebida'
)

common_area3 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Salão de Festas',
  description: 'Espaço para eventos e festas',
  max_occupancy: 100,
  rules: 'Reservar com antecedência'
)

common_area4 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Academia',
  description: 'Equipamentos modernos de ginástica',
  max_occupancy: 20,
  rules: 'Usar toalha nos aparelhos'
)

common_area5 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Quadra de Esportes',
  description: 'Quadra poliesportiva',
  max_occupancy: 15,
  rules: 'Horário de silêncio após 22h'
)

common_area6 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Sala de Jogos',
  description: 'Mesa de bilhar e pebolim',
  max_occupancy: 10,
  rules: 'Proibido apostar dinheiro'
)

common_area7 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Sauna',
  description: 'Sauna seca e a vapor',
  max_occupancy: 10,
  rules: 'Traje de banho obrigatório'
)

common_area8 = CommonArea.create!(
  condo_id: condo1.id,
  name: 'Playground',
  description: 'Área de recreação infantil',
  max_occupancy: 20,
  rules: 'Crianças devem estar acompanhadas'
)

common_area9 = CommonArea.create!(
  condo_id: condo2.id,
  name: 'Biblioteca',
  description: 'Espaço para leitura e estudo',
  max_occupancy: 15,
  rules: 'Silêncio total'
)

common_area10 = CommonArea.create!(
  condo_id: condo3.id,
  name: 'Jardim',
  description: 'Jardim com bancos e pergolado',
  max_occupancy: 25,
  rules: 'Manter limpo'
)

common_area11 = CommonArea.create!(
  condo_id: condo4.id,
  name: 'Sala de Cinema',
  description: 'Cinema com 20 lugares',
  max_occupancy: 20,
  rules: 'Proibido celular ligado'
)

common_area12 = CommonArea.create!(
  condo_id: condo5.id,
  name: 'Espaço Gourmet',
  description: 'Cozinha equipada para eventos',
  max_occupancy: 25,
  rules: 'Limpar após uso'
)

common_area13 = CommonArea.create!(
  condo_id: condo6.id,
  name: 'Brinquedoteca',
  description: 'Espaço com brinquedos e jogos',
  max_occupancy: 15,
  rules: 'Somente para crianças até 12 anos'
)

common_area14 = CommonArea.create!(
  condo_id: condo7.id,
  name: 'Sala de Reuniões',
  description: 'Sala equipada para reuniões',
  max_occupancy: 10,
  rules: 'Agendar com antecedência'
)

common_area15 = CommonArea.create!(
  condo_id: condo8.id,
  name: 'Espaço Pet',
  description: 'Área para animais de estimação',
  max_occupancy: 10,
  rules: 'Manter animais na coleira'
)

common_area16 = CommonArea.create!(
  condo_id: condo8.id,
  name: 'Oficina',
  description: 'Espaço para trabalhos manuais',
  max_occupancy: 8,
  rules: 'Utilizar ferramentas com cuidado'
)

common_area17 = CommonArea.create!(
  condo_id: condo9.id,
  name: 'Área de Meditação',
  description: 'Espaço silencioso para meditação',
  max_occupancy: 5,
  rules: 'Proibido conversas'
)

common_area18 = CommonArea.create!(
  condo_id: condo9.id,
  name: 'Pista de Caminhada',
  description: 'Pista para caminhadas e corridas',
  max_occupancy: 20,
  rules: 'Respeitar velocidade dos outros'
)

common_area19 = CommonArea.create!(
  condo_id: condo10.id,
  name: 'Salão de Beleza',
  description: 'Espaço para cuidados pessoais',
  max_occupancy: 5,
  rules: 'Agendar horário'
)

common_area20 = CommonArea.create!(
  condo_id: condo10.id,
  name: 'Espaço Kids',
  description: 'Área de lazer para crianças',
  max_occupancy: 15,
  rules: 'Acompanhamento de adulto obrigatório'
)

Visitor.create!(
  condo: resident1.residence.condo,
  resident: resident1,
  visit_date: Time.zone.today,
  full_name: 'João da Silva Ferreira',
  identity_number: '1456987',
  category: :visitor
)
Visitor.create!(
  condo: resident1.residence.condo,
  resident: resident1,
  visit_date: Time.zone.today,
  full_name: 'Maria Gomes de Oliveira',
  identity_number: '2345678',
  category: :employee,
  recurrence: :working_days
)
Visitor.create!(
  condo: resident2.residence.condo,
  resident: resident2,
  visit_date: Time.zone.today,
  full_name: 'Pedro Souza Santos',
  identity_number: '3214567',
  category: :visitor
)
Visitor.create!(
  condo: resident2.residence.condo,
  resident: resident2,
  visit_date: 1.day.from_now.to_date,
  full_name: 'Ana Pereira dos Reis',
  identity_number: '4123456',
  category: :employee,
  recurrence: :monthly
)
Visitor.create!(
  condo: resident3.residence.condo,
  resident: resident3,
  visit_date: 1.day.from_now.to_date,
  full_name: 'Carlos Silva Mendes',
  identity_number: '5012345',
  category: :employee,
  recurrence: :biweekly
)
Visitor.create!(
  condo: resident3.residence.condo,
  resident: resident3,
  visit_date: Time.zone.today,
  full_name: 'Beatriz Oliveira Costa',
  identity_number: '6901234',
  category: :visitor
)
Visitor.create!(
  condo: resident3.residence.condo,
  resident: resident3,
  visit_date: 2.days.from_now.to_date,
  full_name: 'Bruno Souza Nunes',
  identity_number: '7890123',
  category: :visitor
)
Visitor.create!(
  condo: resident4.residence.condo,
  resident: resident4,
  visit_date: Time.zone.today,
  full_name: 'Clara Pereira Araújo',
  identity_number: '8765432',
  category: :employee,
  recurrence: :bimonthly
)
Visitor.create!(
  condo: resident4.residence.condo,
  resident: resident4,
  visit_date: 1.day.from_now,
  full_name: 'Diego Silva Lopes',
  identity_number: '9654321',
  category: :visitor
)
Visitor.create!(
  condo: resident5.residence.condo,
  resident: resident5,
  visit_date: Time.zone.today,
  full_name: 'Gabriela Oliveira Martins',
  identity_number: '0543210',
  category: :employee,
  recurrence: :semiannual
)

VisitorEntry.create!(
  condo: condo1,
  full_name: 'Maria Fernandes',
  identity_number: '1234567',
  unit: tower1.floors[0].units[0],
  database_datetime: 1.day.ago
)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'João Pereira',
  identity_number: '2345678',
  unit: tower1.floors[0].units[1],
  database_datetime: 3.days.ago.to_datetime

)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'Ana Souza',
  identity_number: '3456789',
  unit: tower1.floors[1].units[3],
  database_datetime: 14.days.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'Carlos Lima',
  identity_number: '4567890',
  database_datetime: 30.days.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'Patricia Mendes',
  identity_number: '5678901',
  database_datetime: 1.day.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'Lucas Alves',
  identity_number: '6789012',
  unit: tower1.floors[2].units[0],
  database_datetime: 2.days.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'Mariana Costa',
  identity_number: '7890123',
  unit: tower2.floors[2].units[0],
  database_datetime: 3.days.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo1,
  full_name: 'Fernando Gomes',
  identity_number: '8901234',
  unit: tower2.floors[0].units[0],
  database_datetime: 4.days.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo2,
  full_name: 'Juliana Oliveira',
  identity_number: '9012345',
  unit: tower3.floors[0].units[0],
  database_datetime: 1.days.ago.to_datetime
)
VisitorEntry.create!(
  condo: condo2,
  full_name: 'Gustavo Ferreira',
  identity_number: '0123456',
  database_datetime: 1.days.ago.to_datetime
)
Announcement.create!(
  title: 'Reunião de condomínio',
  message: 'Participe da próxima reunião para discutir assuntos importantes do condomínio.',
  manager: admin1,
  condo: condo1
)

Announcement.create!(
  title: 'Manutenção do elevador',
  message: 'Informamos que haverá manutenção dos elevadores em breve. Pedimos desculpas pelo transtorno.',
  manager: admin2,
  condo: condo1
)

Announcement.create!(
  title: 'Limpeza de fachada',
  message: 'A limpeza da fachada será realizada nesta semana. Colabore fechando as janelas.',
  manager: admin1,
  condo: condo1
)

Announcement.create!(
  title: 'Horário de coleta de lixo',
  message: 'Confira os horários de coleta de lixo e colabore para manter o condomínio limpo.',
  manager: admin2,
  condo: condo1
)

puts 'Seed data created successfully!'
