require 'faker'
require 'machinist/active_record'
require 'sham'

Sham.shortname{Faker::Internet.domain_word}
Sham.name{ 	Faker::Name.name}
Sham.host {Faker::Internet.domain_name}
Sham.login {Faker::Internet.user_name}
Sham.email {Faker::Internet.email}
Sham.desciption {Faker::Lorem.paragraph(5)}
Sham.title {Faker::Lorem.sentence(30)}
Sham.street {Faker::Address.street_address}
Sham.city {Faker::Address.us_state}
Sham.city_code {Faker::Address.us_state_abbr}
Sham.country {Faker::Address.uk_country}
Sham.country_code {Faker::Address.us_state_abbr}

Shop.blueprint do
  name {Sham.name}
  shortname {Sham.shortname}
  category {Category.make}
  owner {create_activated_shopowner}
  status {Shop::ACTIVE}
end

User.blueprint do
  login {Sham.login}
  name {Sham.name}
  email {Sham.email}
  remember_token { 'remembertoken' }
  password { 'password' }
  password_confirmation { 'password' }
  activated_at {2.days.ago}
end

ShopOwner.blueprint do
  login {Sham.login}
  name {Sham.name}
  email {Sham.email}
  remember_token { 'remembertoken' }
  password { 'password' }
  password_confirmation { 'password' }
  activated_at {2.days.ago}
  first_name {Sham.name}
  last_name {Sham.name}
  social_id {'B3271477'}
  activation_code {'1234212321'}
end

Category.blueprint do
  name {Sham.name}
  shortname {Sham.shortname}
  parent {nil}
end

Category.blueprint(:subcategory) do
  name {Sham.name}
  shortname {Sham.shortname}
  parent {Category.make}
end

ShopCategory.blueprint do
  name {Sham.name}
  subcategory {Category.make(:subcategory)}
  shop {Shop.make}
end

Product.blueprint do
  name {Sham.name}
  description {Sham.desciption}
  price { rand 10000}
  quantity {rand 10}
  subcategory {Category.make(:parent=>Category.make)}
end

Country.blueprint do
  name {Sham.country}
  code {Sham.country_code}
end

City.blueprint do
  name {Sham.city}
  code {Sham.city_code}
end

Address.blueprint do
  street {Sham.street}
  state {Sham.name}
  city {City.make}
end