include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :vacancy do
    title 'Some title'
    body '<p>Some body</p>'

    location 'Some location'

    company_name 'Some company name'
    company_website 'http://some-company-website.com'
    contact_email 'some@email.com'

    expired_at 5.days.since
    agreed_to_offer true
    approved true

    logo do
      fixture_file_upload(
        Rails.root.join('spec', 'images', 'vacancy_logo.png'),
        'image/png'
      )
    end
  end
end
