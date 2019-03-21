require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "jair", email: "jair@email.com",
       password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "jair2", email: "jair2@email.com",
      password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "jairadm", email: "jairadm@email.com",
      password: "password", password_confirmation: "password", admin: true)
  end

  test "reject an invalid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "jair@email.com" } }
    assert_template 'chefs/edit'
    assert_select '.alert'
  end

  test "accept valid edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: 'jair1', email: 'jair1@email.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'jair1', @chef.chefname
    assert_match 'jair1@email.com', @chef.email
  end

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: 'test1', email: 'test1@email.com' } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match 'test1', @chef.chefname
    assert_match 'test1@email.com', @chef.email
  end

  test "redirect edit attempt by non-admin user [view level]" do
    sign_in_as(@chef2, "password")
    get edit_chef_path(@chef)
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end

  test "redirect edit attempt by non-admin user [backend level]" do
    sign_in_as(@chef2, "password")
    patch chef_path(@chef), params: { chef: { chefname: 'test1', email: 'test1@email.com' } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
