include ActionDispatch::TestProcess

FactoryGirl.define do
  sequence :email do |n|
    (0...16).map{ 65.+(rand(25)).chr }.join.downcase << '@example.com'
  end

  sequence :logo_image do |n|
    fixture_file_upload(
      Rails.root.join('spec', 'fixtures', 'images', 'logo.png'),
      'image/png'
    )
  end

  sequence :small_logo_image do |n|
    fixture_file_upload(
      Rails.root.join('spec', 'fixtures', 'images', 'small_logo.png'),
      'image/png'
    )
  end

  sequence :tiff_logo_image do |n|
    fixture_file_upload(
      Rails.root.join('spec', 'fixtures', 'images', 'logo.tiff'),
      'image/tiff'
    )
  end
end