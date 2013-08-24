require 'spec_helper'

describe "AuthenticationPages" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }

      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link("Profile",      href: user_path(user)) }
      it { should have_link("Sign out",     href: signout_path) }
      it { should_not have_link("Sign in",  href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }
    let(:wrong_user) { FactoryGirl.create(:user, email: "wrong+user@example.com") }

    describe "for non-signed-in users" do

      describe "in the Users controller" do
        before { visit edit_user_path(user) }
        it { should have_title('Sign in') }
      end

      describe "submitting to the update action" do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
              expect(page).to have_title('Edit user')
          end
        end
      end
    end

    describe "as wrong user" do
      before { sign_in user }

      describe "visiting Users#edit page" do

        before do
          visit edit_user_path(wrong_user)
        end

        specify { expect(response).to redirect_to(root_path) }
      end

      describe "submitting a PATCH to the Users#update action" do

        before do
          patch user_path(wrong_user)
        end

        specify { expect(response).to redirect_to(root_path) }
      end
    end
 
  end
end
