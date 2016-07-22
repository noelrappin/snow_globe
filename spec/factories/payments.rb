FactoryGirl.define do
  factory :payment do
    user nil
    price ""
    integer ""
    reference "MyString"
    payment_method "MyString"
    response_id "MyString"
    full_response ""
  end
end
