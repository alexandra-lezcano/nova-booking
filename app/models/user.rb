class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_one :owner
  validates :name, presence: :true
  validates :last_name, presence: :true
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates_format_of :username, with: /\A[a-zA-Z0-9]+\z/, message: "solo debe contener letras y numeros", :multiline => true
  validates_length_of :username, minimum: 5, maximum: 20, allow_blank: true
  validates_length_of :name, minimum: 2, maximum: 50, allow_blank: true
  validates_length_of :last_name, minimum: 2, maximum: 50, allow_blank: true
  validate :validate_username
  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
  attr_writer :login
  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication warden_conditions
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR lower(email) = lower(:value)", { :value => login }]).first
  end
end
