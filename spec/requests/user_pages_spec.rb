require 'spec_helper'
include ApplicationHelper


describe "User Pages" do
	subject { page }

	# Need to add pagination testing here (Listing 9.33 in the book)
	describe "index" do 
		before do
			sign_in FactoryGirl.create(:user)
			FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
			FactoryGirl.create(:user, name: "John", email: "john@example.com")
			visit users_path
		end

		it {should have_selector('title', text: "All users")}
		it {should have_selector('h1'), text: "All users"}

		it "should list each user" do
			User.all.each do |user|
				page.should have_selector('li', text: user.name)
			end
		end

		describe "delete links" do
			it {should_not have_link('delete')}

			describe "as an admin" do
				let(:admin) {FactoryGirl.create(:admin)}

				before do
					sign_in admin
					visit users_path
				end

				it {should have_link('delete', href: user_path(User.first))}
				it "should be able to delete a user who isn't himself" do
					expect {click_link('delete')}.to change(User, :count).by(-1)
				end
				it {should_not have_link('delete', href: user_path(admin))}
			end
		end
	end

	describe "Profile Page" do
		let (:user) {FactoryGirl.create(:user)}
		before {visit user_path(user)}

		it {should have_selector('h1', text: user.name)}
		it {should have_selector('title', text: user.name)}
	end

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector('h1', :text =>'Sign up')}
		it { should have_selector('title', :text => full_title('Sign up')) }
	end

	describe "signup" do
		before { visit signup_path }

		let (:submit) {"Create my account"}

		describe "with invalid information" do
			it "shouldn't create a user" do
				expect {click_button submit}.not_to change(User, :count)
			end

			describe "After submission" do
				before {click_button submit}

				it {should have_selector('title', text:'Sign up')}
				it {should have_content('error')}
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirm password", with: "foobar"
			end

			it "should create a user" do
				expect {click_button submit}.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before {click_button submit}
				let(:user) {User.find_by_email("user@example.com")}

				it {should have_selector('title', text: user.name)}
				it {should have_selector('div.alert.alert-success', text:'Welcome')}
				it {should have_link('Sign out')}
			end

		end
	end

	describe "edit" do
		let(:user) {FactoryGirl.create(:user)}
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it {should have_selector('h1', text: "Update your profile")}
			it {should have_selector('title', text: "Edit profile")}
			it {should have_link('change', href: 'http://gravatar.com/emails')}
		end

		describe "with valid information" do
			before {sign_in_after_edit user}

			it {should have_selector('title', text: "New Name")}
			it {should have_selector('div.alert.alert-success')}
			it {should have_link('Sign out', href: signout_path)}
			# specify {user.reload.name.should == }
		end
		describe "with invalid information" do
			before {click_button "Save changes"}

			it {should have_content('error')}
		end
	end
end



