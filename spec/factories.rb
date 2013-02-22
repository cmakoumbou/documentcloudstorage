FactoryGirl.define do
  factory :user do
    sequence(:first_name)  { |n| "FirstName #{n}" }
    sequence(:last_name)  { |n| "LastName #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	admin true
    end
  end

  factory :document do
    user
  end

  factory :folder do
    name "Lorem ipsum"
    user
  end
end