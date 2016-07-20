require "active_record/fixtures"

user = CreateAdminService.new.call
Rails.logger.ap("CREATED ADMIN USER: " << user.email)

ActiveRecord::FixtureSet.create_fixtures(
    "#{Rails.root}/spec/fixtures", "events")
ActiveRecord::FixtureSet.create_fixtures(
    "#{Rails.root}/spec/fixtures", "performances")
ActiveRecord::FixtureSet.create_fixtures(
    "#{Rails.root}/spec/fixtures", "tickets")
ActiveRecord::FixtureSet.create_fixtures(
    "#{Rails.root}/spec/fixtures", "users")
