require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    # assert_no_difference 式を評価した結果の数値は、ブロックで
    # 渡されたものを呼び出す前と呼び出した後で違いがないと主張する。
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    # assert_template 指定されたテンプレートが選択されたか
    # assert_select アプリケーションのビューのテストを行う際に
    # 使うアサーションメソッド
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # follow_redirect! POSTリクエストを送信した結果を見て、
    # 指定されたリダイレクト先に移動するメソッド
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
