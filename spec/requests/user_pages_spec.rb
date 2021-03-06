
# valid_signup, valid_signin (remember to 'visit signin_path' before calling valid_signin)
# These are  RSpec matchers, located in /support/utilities.rb

require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
        let(:user) { FactoryGirl.create(:user) }

	before(:each) do
		visit signin_path
		valid_signin user
		visit users_path
	end

	it { should have_selector('title', text: 'All users') }
	it { should have_selector('h1',    text: 'All users') }

	describe "pagination" do
		before(:all) { 30.times { FactoryGirl.create(:user) } }
		after(:all)  { User.delete_all }

		it { should have_selector('div.pagination') }	

	        it "should list each user" do
                	User.paginate(page: 1).each  do |user|
                        	page.should have_selector('li', text: user.name)
                	end
		end
        end

	describe "delete links" do
		it { should_not have_link('delete') }

		describe "as an admin user" do
			let(:admin) { FactoryGirl.create(:admin) }
			before do
				visit signin_path
				valid_signin admin
				visit users_path
			end
		
			it { should have_link('delete', href: user_path(User.first)) }
			it "should be able to delete another user" do
				expect { click_link('delete').to change(User, :count).by(-1) }
			end

			it { should_not have_link('delete', href: user_path(admin)) }
		end
	end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
	 before { click_button submit }

	 it { should have_selector('title', text: 'Sign up') }
         it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { valid_signup }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome to the Sample App!') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "profile page" do
	let(:user) { FactoryGirl.create(:user) }
        let(:another_user) { FactoryGirl.create(:user) }
                        
        let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
        let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
	let!(:mp) { FactoryGirl.create(:micropost, user: another_user, content: "Baz") }

	before (:each) do
		visit user_path(user)
	end

	it { should have_selector('h1', text: user.name) }
	it { should have_selector('title', text: user.name) }

    	describe "microposts" do
      		it { should have_content(m1.content) }
      		it { should have_content(m2.content) }
      		it { should have_content(user.microposts.count) }

		describe "another user's microposts should not have delete link" do

		        before { visit user_path(another_user) }	

                     	it { should_not have_link('delete', title: mp.content) }   
		end
	end

        describe "micropost pagination" do
        	pagination_is_valid
	end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
	visit signin_path
	valid_signin(user)
	visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
	let(:new_name) { "New Name" }
	let(:new_email) { "new@example.com" }

	before { valid_update }

	it { should have_selector('title', text: new_name) }
	it { should have_selector('div.alert.alert-success') }
	it { should have_link('Sign out', href: signout_path) }
	specify { user.reload.name.should == new_name }
	specify { user.reload.email.should == new_email }
    end
  end
end
