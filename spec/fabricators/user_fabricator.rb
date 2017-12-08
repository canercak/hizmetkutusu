usern = Faker::Name.last_name
uidn = Faker::Number.number(10) 
Fabricator(:user) do
    uid {123456}
    username {usern }
    email {Faker::Internet.email}
    username_or_uid { [ usern , uidn] }
    provider {'facebook'}
    admin {false}
    name {Faker::Name.name }
    gender {'male'}
    telephone {Faker::Number.number(11)}
    birthday { Time.at(rand * (18.years.ago.to_f - 50.years.ago.to_f) + 50.years.ago.to_f).to_date } 
end
 