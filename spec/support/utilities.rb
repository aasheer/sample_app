include ApplicationHelper

def valid_signin(user)
	fill_in "Email", 	with: user.email
	fill_in "Password", 	with: user.password
	click_button "Sign in"
end

def valid_signup
        fill_in "Name",                      with: "Example User"
        fill_in "Email",                     with: "user@example.com"
        fill_in "Password",                  with: "foobar"
        fill_in "Password confirmation",     with: "foobar"
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

RSpec::Matchers.define :div_alert_selector do
	match do |page|
		page.should_not have_selector('div.alert.alert-error')
	end
end

RSpec::Matchers.define :have_signin_message do |message|
        match do |page|
                page.should have_selector('title', text: message )
        end
end
