require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "jair", email: "jair@email.com",
       password: "password", password_confirmation: "password")
  end

  test "reject an invalid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "jair@email.com" } }
    assert_template 'chefs/edit'
    assert_select '.alert'
  end

  test "accept valid signup" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: 'jair1', email: 'jair1@email.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'jair1', @chef.chefname
    assert_match 'jair1@email.com', @chef.email
  end
end
