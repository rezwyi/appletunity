FactoryGirl.define do
  factory :vacancy do
    title 'Some title'
    body 'Some body'
    location 'Some location'
    company_name 'Some company name'
    company_website 'http://some-company-website.com'
    contact_email 'some@email.com'
    agreed_to_offer true
  end
end