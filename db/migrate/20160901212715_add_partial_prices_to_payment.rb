class AddPartialPricesToPayment < ActiveRecord::Migration[5.0]

  def change
    change_table :payments do |t|
      t.json :partials
    end
  end

end
