require 'test_helper'

class RecipeTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.create!(chefname: "Bressani", email: "bressani@jair.junior")
    @recipe = @chef.recipes.build(name: "vegetable", description: "greate vegetable recipe")
  end

  test "recipe withouth chef should be invalid" do
    @recipe.chef_id = nil
    assert_not @recipe.valid?
  end

  test "recipe should be valid" do
    assert @recipe.valid?
  end

  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end

  test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end

  test "description should not be less than 5 characters" do
    @recipe.description = "1234"
    assert_not @recipe.valid?
  end

  test "description should not be more than 500 characters" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid?
  end

end