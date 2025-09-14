# == Schema Information
#
# Table name: person_films
#
#  id         :bigint           not null, primary key
#  person_id  :bigint           not null
#  film_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PersonFilm < ApplicationRecord
    # This is a join table listing the films people starred in.
    belongs_to :film
    belongs_to :person
end
