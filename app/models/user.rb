class User < ApplicationRecord
  # attr_accessorを使って「仮想の」属性を作成
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  # allow_nil: trueでパスワードのバリデーションにフィールドが空だった場合の例外処理を加える必要があります。
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す。
  # Secure Randomとはモジュールの一種で安全に乱数を発生させる。 https://docs.ruby-lang.org/ja/latest/class/SecureRandom.html
  # urlsafe_base64で64でURLのsafe(セーフ)なbase64でランダムに64の文字列を返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  # selfキーワードを使うとローカル変数にならずに済む。
  # update_attributeメソッドを使い記憶ダイジェストを更新。このメソッドではバリデーションを素通りさせることができる。
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  # authenticated?メソッドはユーザーモデルで呼び出すだけでhas_secure_passwordメソッドが使える
  # remeber_tokenを引数にして
  # is_password?は==の代わりに使われている。その引数はメソッド内のローカル変数を参照している
  # remember_digestはself.remember_digestと同じであり、nameとemailの使い方と同じになる。
  def authenticated?(remember_token)
    # 記憶ダイジェストがnilの場合にはreturnキーワードで即座にメソッドを終了している
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  # forgetヘルパーメソッドを追加してlog_outヘルパーメソッドから呼び出す。
  def forget
    update_attribute(:remember_digest, nil)
  end

end
