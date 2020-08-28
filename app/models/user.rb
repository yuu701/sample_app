class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # uniqueness: { case_sensitive: false }でuniqueness:はtrueと判断される。
  # 大文字・小文字の区別をなくしている
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  # has_secure_passwordで存在性のバリデーションもしてくれるが、それは新しく
  # レコードが追加されたときだけ。
  # ユーザーが6字分のスペースといった文字列を入力して更新しようとすると、
  # バリデーションが適用されずに更新してしまうのでpresence: trueが必要。 
  validates :password, presence: true, length: { minimum: 6 }
end
