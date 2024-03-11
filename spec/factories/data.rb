FactoryBot.define do
    factory :employee do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      phone { Faker::Number.number(digits: 11) }
      position { Faker::Job.title }
      dept { Faker::Job.field }
      password { '1111' }
      password_confirmation { '1111' }
    end

    factory :manager do
        name { Faker::Name.name }
        email { Faker::Internet.email }
        phone { Faker::Number.number(digits: 11) }
        password { '1111' }
        password_confirmation { '1111' }
      end

    factory :task do
      title { Faker::Name.name }
      description { Faker::Name.name }
      deadline { Faker::Date.backward(days: 365).strftime('%Y-%m-%d')}
      status { 'panding' }
    end

    factory :leave_request do
      start_date { Faker::Date.forward(from: Date.current, days: 1).strftime('%Y-%m-%d') }
      end_date { Faker::Date.forward(from: Date.current, days: 100).strftime('%Y-%m-%d') }
      reason { Faker::Name.name}
      status { 'panding' }
    end

    factory :leave_count do
      count { 10 }
    end
  end