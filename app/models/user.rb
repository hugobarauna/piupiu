require 'digest/sha1'

class User < ActiveRecord::Base
  validates_confirmation_of :email, :password
  validates_presence_of :email
  validates_uniqueness_of :email
  
  has_many :posts, :order => "created_at DESC"
  
  has_and_belongs_to_many :followeds, :class_name => 'User', :join_table => 'followers', :foreign_key => 'follower_id', :association_foreign_key => 'followed_id', :uniq => true
  
  has_and_belongs_to_many :followers, :class_name => 'User', :join_table => 'followers', :foreign_key => 'followed_id', :association_foreign_key => 'follower_id', :uniq => true
  
  
  after_create :send_new_account_notification
  
  def followeds_posts
    posts = self.followeds.inject([]) do |all_posts, followed|
      all_posts << followed.posts
    end
    
    posts << self.posts
     
    posts.flatten.sort { |post1,post2| post2.created_at <=> post1.created_at }
  end

  def password
    @password || ''
  end
  
  # Método para setar o password.
  # Ele automaticamente gera o salt e encripta o password enviado.
  #
  def password=(new_password)
    @password = new_password
    return nil if @password.blank?

    self.salt            = User.random_string(10)
    self.hashed_password = User.encrypt(@password, self.salt)
  end
  
  # Método que recebe um hash com os valores de e-mail e password, procura
  # o dado e-mail no banco e o autentica, caso o password sejá válido.
  #
  # Retorna o usuário encontrado ou nil.
  #
  def self.find_and_authenticate(options)
    return nil if options[:email].blank? || options[:password].blank?

    user = User.find_by_email(options[:email])
    
    if user
      user.authenticate(options[:password]) ? user : nil
    else
      return nil
    end
  end

  # Método de autenticação que recebe o password e o encripta comparando
  # com o password criptogragado no banco de dados. Retorna true ou false.
  #
  def authenticate(auth_password)
    User.encrypt(auth_password, self.salt) == self.hashed_password
  end


  def send_new_account_notification
    Notification.deliver_new_account(self)
  end

  protected
    # Método que recebe um password e um salt e retorna o password criptografado com SHA1.
    #
    def self.encrypt(password, salt)
      return nil if password.blank? || salt.blank?
      Digest::SHA1.hexdigest(password + 'piupiu' + salt)
    end

    # Método que gera uma string aleatória com o tamanho enviado.
    # Atualmente usado para gerar o salt, confirmation_code e reset_password_code.
    #
    def self.random_string(length)
      chars = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

      newpass = ''
      1.upto(length) { |i| newpass << chars.rand }

      return newpass
    end

end
