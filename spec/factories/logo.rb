include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :logo do
    image { fixture_file_upload(Rails.root.join('spec', 'images', 'logo.png'), 'image/png') }
  end
end