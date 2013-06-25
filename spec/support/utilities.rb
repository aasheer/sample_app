include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  
# Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

def valid_signup
        fill_in "Name",                      with: "Example User"
        fill_in "Email",                     with: "user@example.com"
        fill_in "Password",                  with: "foobar"
        fill_in "Confirm Password",	     with: "foobar"
end

def valid_update
	fill_in "Name",		    with: new_name
	fill_in "Email", 	    with: new_email
	fill_in "Password", 	    with: user.password
	fill_in "Confirm Password", with: user.password
        click_button "Save changes"
end

def rspec_pluralize(numOfItems, numInWords)
	view.pluralize(numOfitems, numInWords)
end

def pagination_is_valid
        before(:all) { 30.times { FactoryGirl.create(:micropost, user: user) } }
        after(:all)  { User.delete_all }

        it { should have_selector('div.pagination') }
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
