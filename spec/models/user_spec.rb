require 'spec_helper'

describe User do
	before{ @user = User.new(:name => "Example User",:email => "example@gmail.com", :password => "foo", :password_confirmation => "foo") }

	subject{ @user }

	it {should respond_to(:name)}
	it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should be_valid}

  describe "when name is not present" do
    before {@user.name = ""}
    it {should_not be_valid}
  end

  describe "when name is too long" do
    before {@user.name = "a" * 51}
    it {should_not be_valid}
  end

  describe "when email is not present" do 
    before {@user.email = ""}
    it {should_not be_valid}
  end

  describe "when an email address is invalide" do
    it "should_not be_valid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |address|
        @user.email = address
        @user.should_not be_valid
      end
    end
  end

  describe "when an email address is valid" do
    it "should be_valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |address|
        @user.email = address
        @user.should be_valid
      end
    end
  end

  describe "when a user have an email that is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it {should_not be_valid}
  end

  describe "when password is not present" do
    before {@user.password = @user.password_confirmation = ""}
    it {should_not be_valid}
  end

  describe "when password mismatch password_confirmation" do
    before {@user.password_confirmation = "not_foo"}
    it {should_not be_valid}
  end

  describe "when the password_confirmation is nil" do
    before {@user.password_confirmation = nil}
    it {should_not be_valid}
  end
end


