require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(page_title) }
  end

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  describe 'Home page' do
    before { visit home_path }
    let (:heading)    { 'Sample App' }
    let (:page_title) { "#{base_title}" }
    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
 
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end

  describe 'Help page' do
    before { visit help_path }
    let (:heading)    { 'Help' }
    let (:page_title) { "#{base_title} | Help" }
    it_should_behave_like "all static pages"
  end

  describe 'About page' do
    before { visit about_path }
    let (:heading)    { 'About Us' }
    let (:page_title) { "#{base_title} | About Us" }
    it_should_behave_like "all static pages"
  end

  describe 'Contact' do
    before { visit contact_path }
    let (:heading)    { 'Contact' }
    let (:page_title) { "#{base_title} | Contact" }
    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    first(:link, "About").click
    page.should have_title("#{base_title} | About Us")
    first(:link, "Help").click
    page.should have_title("#{base_title} | Help")
    first(:link, "Contact").click
    page.should have_title("#{base_title} | Contact")
    first(:link, "Home").click
    first(:link, "Sign up").click
    page.should have_title("#{base_title} | Sign up")
  end
end
