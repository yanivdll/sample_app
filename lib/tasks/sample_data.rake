namespace :db do 
	desc "fill in database with sample users"
	task populate: :environment do
		admin = User.create!(name: "Example User",
			email: "example@example.com",
			password: "foobar",
			password_confirmation: "foobar")
		admin.toggle!(:admin)
		
		99.times do
			name = Faker::Name.name
			email = Faker::Internet.email #"example-#{n+1}@example.com"
			password = "password"
			User.create!(name: name,
				email: email,
				password: password,
				password_confirmation: password)
		end
	end
end