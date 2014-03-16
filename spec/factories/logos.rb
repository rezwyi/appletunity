FactoryGirl.define do
  factory :logo do
    image { FactoryGirl.generate(:logo_image) }
  end
end