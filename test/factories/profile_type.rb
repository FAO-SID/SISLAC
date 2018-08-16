# Creación de modelos para los tests. Sin argumentos ni traits debería crear
# modelos que pasen la validación.
FactoryGirl.define do
  factory :profile_type do
    valor { generate :cadena_unica }

    trait :default do
      valor 'soil profile'
    end
  end
end
