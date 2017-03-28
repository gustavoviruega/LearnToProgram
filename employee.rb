require_relative 'person'
# Esta clase es parte del Modelo. Igual que person y air_conditioner. Interactua con la BD.
class Employee < Person
    # No hace falta hacer el include Mongoid::Document porque ya lo hereda de persona.
    field :category, type: String
    field :desired_AC_temperature, type: Integer
end
