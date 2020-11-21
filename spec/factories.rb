FactoryBot.define do
  factory :location_moskow, class: Location do
    postcode { '64401' }
    suburb { 'Moskow' }
    state { 'MSK' }
    counts_jobs { 73 }
  end

  factory :location_any, class: Location do
    postcode { Faker::Address.postcode }
    suburb { Faker::Address.city  }
    state { Faker::Address.state}
    counts_jobs { 0 }
  end

  factory :location_omsk, class: Location do
    postcode { '64400' }
    suburb { 'Omsk' }
    state { 'OMS' }
    counts_jobs { 21 }
  end

  factory :client, class: Client do
    firstname { 'Nikol' }
    lastname { 'Kidman' }
    email { 'nikol.k@mail.com' }
    phone { Faker::PhoneNumber.phone_number }
    password { '11111111' }
  end

  factory :client_any, class: Client do
    firstname { Faker::Name.first_name  }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email}
    phone { Faker::PhoneNumber.phone_number }
    password { Faker::Internet.password }
    association :location, factory: :location_any
  end

  factory :any_job, class: Job do
    title { "New job" }
    description { "sdfdsfsdfsdf" }
    association :location, factory: :location_any
    association :client,  factory: :client_any
    association  :company,  factory: :company_any
  end


  factory :job, class:Job do
    title { "New job" }
    description { "sdfdsfsdfsdf" }
  end

  factory :company, class: Company do
    name { 'Best Company' }
  end

  factory :company_any, class: Company do
    name { Faker::Company.name }
    association :location, factory: :location_any
  end

  factory :create_job do
    email    { Faker::Internet.email }
    password { '11111111' }
    title { 'Barista' }
    salarymin { 10000 }
    salarymax { 1000000 }
    description { '<p> We created a new job! </p>' }
    company_name { 'Best Company'}
    full_name { 'Sarah Smith' }
  end

  factory :order_job, class: Order do
    association :product, factory: :product_urgent
  end

  factory :product_urgent, class: Product do
    name    { 'Job_Urgent' }
    price { {
        'AUD':  {price: 14.99},
        'USD':  {price: 14.99},
        'CAD':  {price: 14.99},
        'GBR':  {price: 11.99},
        'EUR':  {price: 12.99},
        'INR':  {price: 399},
        'RUB':  {price: 399},
        'CNY':  {price: 71}
    } }
  end

  factory :product_highlight, class: Product do
    name    { 'Job_Highlight' }
    price { {
        'AUD':  {price: 9.99},
        'USD':  {price: 9.99},
        'CAD':  {price: 9.99},
        'GBR':  {price: 7.99},
        'EUR':  {price: 8.99},
        'INR':  {price: 249},
        'RUB':  {price: 299},
        'CNY':  {price: 47}
    } }
  end

  factory :product_urgent_and_highlight, class: Product do
    name    { 'Job_Urgent_And_Highlight' }
    price { {
        'AUD':  {price: 21.99},
        'USD':  {price: 21.99},
        'CAD':  {price: 21.99},
        'GBR':  {price: 17.99},
        'EUR':  {price: 19.99},
        'INR':  {price: 549},
        'RUB':  {price: 599},
        'CNY':  {price: 99}
    } }
  end

  factory :size do
    size    { '1..20' }
  end

  factory :industry do
    name    { 'Other' }
    level   { 1 }
  end

  factory :product do
    name {'Resume_Urgent_And_Highlight'}
    price {{
        'AUD':  {price: 8.99},
        'USD':  {price: 8.99},
        'CAD':  {price: 8.99},
        'GBR':  {price: 6.99},
        'EUR':  {price: 6.99},
        'INR':  {price: 259},
        'RUB':  {price: 329},
        'CNY':  {price: 45}
    }}
  end
end
