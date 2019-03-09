require 'test_helper'

class ChefsTest < ActionDispatch::IntegrationTest
  def setup
    @chef1 = Chef.create!(chefname: "jair", email: "jair@email.com",
       password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "bressani", email: "bressani@email.com",
      password: "password", password_confirmation: "password")
  end

  test "should get chefs index" do
    get chefs_path
    assert_template 'chefs/index'
  end

  test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef1), text: @chef1.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chefname.capitalize
  end

end