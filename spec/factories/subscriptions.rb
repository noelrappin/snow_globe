FactoryGirl.define do
  factory :subscription do
    user nil
    plan nil
    start_date "2016-07-30"
    end_date "2016-07-30"
    status 1
    payment_method "MyString"
    remote_id "MyString"
    string "MyString"
  end
end
