class Person
# Esta clase es parte del Modelo. Igual que employee y air_conditioner. Interactua con la BD.
# Esto indica que persona hereda todo lo de Mongoid. El include indica que se comporta como tal cosa.
include Mongoid::Document
    field :name, type: String
end
