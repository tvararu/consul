class Verification::Sms
  include ActiveModel::Model

  attr_accessor :user, :phone, :confirmation_code

  validates :phone, presence: true
  validates :phone, format: { with: /\A[\d\+]{10,}\z/ }
  validate :uniqness_phone

  def uniqness_phone
    errors.add(:phone, :taken) if User.where(confirmed_phone: phone).any? unless phone.blank?
  end

  def save
    return false unless valid?

    update_user_phone_information
  end

  def update_user_phone_information
    user.update(unconfirmed_phone: phone, confirmed_phone: phone, sms_confirmation_code: '', verified_at: Time.current)
  end

  # Always true since verification is disabled
  def verified?
    true
  end
end
