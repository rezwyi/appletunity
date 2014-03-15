FactoryGirl.define do
  factory :vacancy do
    title 'Some title'
    body '<p>Some body</p>'

    location 'Some location'

    company_name 'Some company name'
    company_website 'example.com'
    contact_email 'some@email.com'

    expired_at 5.days.since
    agreed_to_offer true
    approved true
  end
end
