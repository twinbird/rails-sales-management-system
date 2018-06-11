require 'test_helper'

class ProductManagementFormsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    # yamada belongs to a company that has many products 
    @yamada = users(:yamada)
    @new_user = users(:new_user)
    @crown = products(:crown)
  end

  test "can't access not setup user" do
    sign_in(@new_user)

    get products_path
    assert_redirected_to mysetting_path
    follow_redirect!
    assert_not flash[:notice].empty?
  end

  test "can't access not signin user" do
    get products_path
    assert_redirected_to new_user_session_path
  end

  test "listing pagination" do
    sign_in(@yamada)

    get products_path
    assert_response :success

    assert_select 'div.pagination'
  end

  test "add new products" do
    sign_in(@yamada)

    get products_path
    assert_response :success
    assert_select 'a[href=?]', new_product_path 

    get new_product_path
    assert_response :success

    post products_path, params: { product: { name: '品物1',
                                             default_price: 1000 } }
    follow_redirect!

    assert_match /品物1/, response.body
  end

  test "edit products" do
    sign_in(@sato)

    get products_path
    assert_response :success
    assert_select 'a[href=?]', edit_product_path(@crown)

    get edit_product_path(@crown)
    assert_response :success
    patch product_path(@crown), params: { product: { name: 'hoge' } }

    assert_redirected_to product_path(@crown)
    follow_redirect!
    
    assert_match /hoge/, response.body
  end

  test "destroy products" do
    sign_in(@sato)

    get products_path
    assert_response :success
    assert_select 'a[href=?]', product_path(@crown), count: 2

    delete product_path(@crown)
    assert_redirected_to products_path
    assert_not flash.empty?
  end

end
