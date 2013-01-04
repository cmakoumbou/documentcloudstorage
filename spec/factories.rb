FactoryGirl.define do
  factory :user do
    first_name	"Bat"
    last_name	"Man"
    email    "batman@gotham.com"
    password "foobar"
    password_confirmation "foobar"
  end
end