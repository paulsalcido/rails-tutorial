FactoryGirl.define do
  factory :user do
    #name      "Paul Salcido"
    #email     "paul.salcido+test@example.com"
    sequence(:name)   { |n| "Person #{n}" }
    sequence(:email)  { |n| "person.#{n}@example.com" }
    password  "foobar"
    password_confirmation  "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
