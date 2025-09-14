class CreateSocialMediaUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :social_media_users do |t|
      t.string :full_name
      t.integer :age

      t.timestamps
    end
  end
end
