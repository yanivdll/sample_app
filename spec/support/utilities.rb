def sign_in(user)
	visit signin_path
	fill_in "Email", 	with: user.email
	fill_in "Password",	with: user.password
	click_button "Sign in"

	#Sign in when not using capybara
	cookies[:remember_token] = user.remember_token
end

def sign_in_after_edit(user)
	fill_in "Name", with:"New Name"
	fill_in "Email", with:"new@example.com"
	fill_in "Password", with: user.password
	fill_in "Confirm password", with: user.password
	# binding.pry
	click_button "Save changes"
end