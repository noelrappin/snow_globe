class AddAuthyToUser < ActiveRecord::Migration[5.0]

  def change
    change_table :users do |t|
      t.string :authy_id
    end
  end

end
