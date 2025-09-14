# == Schema Information
#
# Table name: people
#
#  id             :bigint           not null, primary key
#  name           :string
#  species_id     :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  home_planet_id :integer
#
class Person < ApplicationRecord
  # You should be able to see which species a person is.
  belongs_to :species
  # You should be able to see which films the person is in.
  has_many :person_films
  has_many :films, through: :person_films
  # You should be able to see which home planet a person is from.
  belongs_to :home_planet, class_name: 'Planet'
  # You should be able to determine who the person's senator (another Person) is.
  has_one :senator, through: :home_planet
  # You should be able to list the citizens of the person's home planet.
  has_many :fellow_citizens, through: :home_planet, source: :citizens
end
