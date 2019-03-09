require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Jair", email: "jair@bressani.com",
       password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "name must be at maximum 30 chars" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "email should be greater than 255" do
    @chef.email = "a" * 256
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[a@b.com darth@vader.com.br DaRth@vAder.impErial.A vaDer+@darth.Lorem.ipsu]
    valid_emails.each do |valid_email|
      @chef.email = valid_email
      assert @chef.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "email should accept only correct format" do
    invalid_emails = %w[ab.com touerrado.com.br NaO@vouFuncionAarrr idont+Kwonwo anyth@ing,to put@in+here.com]
    invalid_emails.each do |invalid_email|
      @chef.email = invalid_email
      assert_not @chef.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lower case before saving" do
    mixed_email = "imlowerIMUPPER@IMUPPERimlower.ImUPloWer"
    @chef.email = mixed_email
    @chef.save

    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test "password should be at least 5 chars" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end

end
