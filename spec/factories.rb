FactoryGirl.define do
  factory :user do
    name      "Paul Salcido"
    email     "paul.salcido+test@example.com"
    password  "foobar"
    password_confirmation  "foobar"
  end
end
