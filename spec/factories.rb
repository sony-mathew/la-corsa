# By using the symbol ':user', we get Factory Girl to simulate the User model.

FactoryGirl.define do
	factory :user do
    	sequence(:name)  { |n| 	"Eg2 #{n}" }
    	sequence(:email) { |n| 	"eg2#{n}@example.com"}   
    	password 				"foobar11"
    	password_confirmation 	"foobar11"
    	nickname				"ynos"
    	dob 					"25/05/1992"
  	end

	factory :study_material do
  		title 			"Yesting for for somethingsk kdjfjk kdsjbfkab asjkdbfkjds."
		description  	"Simple what this testing is for and wot you want to do with it.kjdfkjdsfhksjdhkjh kjhdskjhfkjdshfjk."
		link			"http://www.google.co.in"
    	user
  	end

  	factory :course do
    	sequence(:name)	{ |n|	"very very big course simply for testing. #{n}" }
		description 			"Smaple course made to check whether the actual creation takes place."
		material_ids			["24", "25"]
    	user
  	end

end
