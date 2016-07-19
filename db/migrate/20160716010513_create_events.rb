class CreateEvents < ActiveRecord::Migration[5.0]

  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :image_url

      t.timestamps
    end
  end

end
