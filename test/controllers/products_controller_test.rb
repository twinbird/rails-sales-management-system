require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @sato = users(:sato)
    # yamada belongs to a company that has many products
    @yamada = users(:yamada)
    @new_user = users(:new_user)
    @crown = products(:crown)
    @egg_break_machine = products(:egg_break_machine)
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

    assert_select 'nav.pagination'
  end

  test "add new products" do
    sign_in(@yamada)

    get products_path
    assert_response :success
    assert_select 'a[href=?]', new_product_path

    get new_product_path
    assert_response :success

    # miss post(name is empty)
    assert_no_difference('Product.count') do
      post products_path, params: { product: { name: '',
                                               default_price: 1000 } }
    end
    assert_response :success
    assert_select '#error_explanation'

    # correct post
    assert_difference('Product.count', 1) do
      post products_path, params: { product: { name: '品物1',
                                               default_price: 1000 } }
    end
    assert_redirected_to Product.last
    follow_redirect!
  end

  test "edit products" do
    sign_in(@sato)

    get products_path
    assert_response :success
    assert_select 'a[href=?]', product_path(@crown)

    get product_path(@crown)
    assert_response :success
    assert_select 'a[href=?]', edit_product_path(@crown)

    get edit_product_path(@crown)
    assert_response :success

    # miss post(name is empty)
    patch product_path(@crown), params: { product: { name: '' } }
    assert_not_equal @crown.reload.name, ''

    # correct post
    patch product_path(@crown), params: { product: { name: 'hoge' } }

    assert_equal @crown.reload.name, 'hoge'
    assert_redirected_to product_path(@crown)
    follow_redirect!
  end

  test "can't destroy using products" do
    sign_in(@sato)

    get products_path
    assert_response :success
    assert_select 'a[href=?]', product_path(@crown)

    assert_no_difference('Product.count') do
      delete product_path(@crown)
    end
    assert_redirected_to products_path
    assert_not flash.empty?
  end

  test "destroy products" do
    sign_in(@yamada)

    get products_path, params: { query: '卵' }
    assert_response :success
    assert_select 'a[href=?]', product_path(@egg_break_machine)

    assert_difference('Product.count', -1) do
      delete product_path(@egg_break_machine)
    end
    assert_redirected_to products_path
    assert_not flash.empty?
  end

  test "search products" do
    sign_in(@yamada)

    get products_path
    assert_response :success
    assert_select 'tbody>tr', count: 20

    get products_path, params: { query: 'Mac' }
    assert_response :success
    assert_select 'tbody>tr', count: 1
    assert_select 'input[value=?]', 'Mac'
  end

end
