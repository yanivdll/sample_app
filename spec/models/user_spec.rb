require 'spec_helper'

describe User do
	before{ @user = User.new(:name => "Example User", :email => "example@gmail.com", :password => "foobar", :password_confirmation => "foobar") }

	subject{ @user }

	it {should respond_to(:name)}
	it {should respond_to(:email)}
  it {should respond_to(:password_digest)}
  it {should respond_to(:password)}
  it {should respond_to(:password_confirmation)}
  it {should respond_to(:authenticate)}
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

  describe "when a user inset an email address that isn't lowercase" do
    let (:mixed_case_email) {"YanivDll@gmail.com"}
    
    it "should be saved as all lower-case" do
      binding.pry
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
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

  describe "return value of authenticate method" do
    before {@user.save}
    let (:found_user) {User.find_by_email(@user.email)}

    describe "when valid password" do
      it {should == found_user.authenticate(@user.password)}
    end

    describe "when invalid password" do
      let (:user_for_invalid_password) {found_user.authenticate("invalid")}

      it {should_not == user_for_invalid_password}
      specify {user_for_invalid_password.should be_false}
    end
  end

  describe "with a password that's too short" do
    before {@user.password = @user.password_confirmation = 'a' * 5}

    it {should be_invalid}
  end
end


