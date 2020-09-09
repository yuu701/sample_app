require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  # テストが走る前に、インスタンス変数の @user を宣言
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
            password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    # assert メソッドは、第1引数がtrue である場合に、テストが成功したものとみなす。
    # valid?はモデルのメソッドで、パリデーションを実行して、モデルが正しい値かどうかを調べる。
    assert @user.valid?
  end
  
  # nameに空白が入ってしまうとエラーになる
  # assert_not hoge は　hogeがtrueなら失敗、falseなら成功
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  # eamilに空白が入ってしまうとエラーになる
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  # nameが51文字だとエラーになる
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # emailが256文字だとエラーになる
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  # 有効にしたいアドレスが通るかのテスト
  test "email validation should accept valid addresses" do
    # valid_addresses　有効なアドレス
    # %w[foo bar baz]=> ["foo", "bar", "baz"]
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      # 第2引数　"#{valid_address.inspect} should be valid"でどのメールアドレスで
      # テストが失敗したのか特定
      # inspectはわかりやすく文字列で返してくれるメソッド
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # 無効にしたいアドレスを弾けるかのテスト
  test "email validation should reject invalid addresses" do
    # invalid_addresses　無効なアドレス
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  # 大文字・小文字を区別せずに重複したアドレスを弾けるかのテスト
  test "email addresses should be unique" do
    # duplicate_user 重複したuser
    # dupメソッドでオブジェクトを複製
    duplicate_user = @user.dup
    # 重複したuserのemailに@userのemailを大文字にして代入
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # メールアドレスを小文字にするテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    # assert_equal指定した2つの値が等しければテスト成功
    # reloadメソッド　データベースの値に合わせて更新する
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  # パスワードがスペース6つ分の時弾かれるテスト
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードが5文字の時弾かれるテスト
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
