class CreateAffiliates < ActiveRecord::Migration[5.0]

  def change
    create_table :affiliates do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.string :country
      t.string :stripe_id
      t.string :stripe_key
      t.string :stripe_secret
      t.string :tag

      t.timestamps
    end

    change_table :payments do |t|
      t.references :affiliate, foreign_key: true
      t.integer :affiliate_payment_cents, default: 0, null: false
      t.string  :affiliate_payment_currency, default: "USD", null: false
    end
  end

end
