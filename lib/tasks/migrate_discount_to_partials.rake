namespace :snow_globe do
  task migrate_discounts: :environment do
    Payment.transaction do
      Payment.all.each do |payment|
        payment.update(partials: {discount_cents: discount_cents})
      end
    end
  end
end
