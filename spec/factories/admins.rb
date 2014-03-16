FactoryGirl.define do
  factory :admin do
    email { FactoryGirl.generate(:email) }
    password '123456'
  end
end