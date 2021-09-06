class Verification::Residence
  include ActiveModel::Model
  include ActiveModel::Dates
  include ActiveModel::Validations::Callbacks

  attr_accessor :user, :document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service

  before_validation :retrieve_census_data

  validates :document_number, presence: true
  validates :terms_of_service, acceptance: { allow_nil: false }

  # Verify phone number
  validates :phone, acceptance: { allow_nil: false }
  validate :document_number_uniqueness
  validate :document_number_format

  def initialize(attrs = {})
    self.date_of_birth = date_of_birth_from_document if document_number
    attrs = remove_date("date_of_birth", attrs)
    super
    clean_document_number
  end

  def save
    return false unless valid?

    user.take_votes_if_erased_document(document_number, document_type)

    user.update(document_number:       document_number,
                document_type:         document_type,
                date_of_birth:         date_of_birth.in_time_zone.to_datetime,
                gender:                gender,
                residence_verified_at: Time.current)
  end

  def save!
    validate! && save
  end

  def allowed_age
    return if errors[:date_of_birth].any?

    errors.add(:date_of_birth, I18n.t("verification.residence.new.error_not_allowed_age"))
  end

  def document_number_uniqueness
    errors.add(:document_number, I18n.t("errors.messages.taken")) if User.active.where(document_number: document_number).any?
  end

  def document_number_format
    unless (is_number?(document_number) && document_number.size == 13)
      errors.add(:document_number, I18n.t("errors.messages.invalid"))
    end
  end

  def store_failed_attempt
    FailedCensusCall.create(
      user: user,
      document_number: document_number,
      document_type: document_type,
      date_of_birth: date_of_birth,
      postal_code: postal_code
    )
  end

  def geozone
    Rails.configuration.deploy['city']
  end

  def date_of_birth_from_document
    day   = document_number[5..6].to_i
    month = document_number[3..4].to_i
    year  = document_number[1..2].to_i
    year += case gender_digit
      when 1..2
        1900
      when 3..4
        1800
      when 5..8
        2000
      end

    Date.new(year, month, day)
  end

  def gender_digit
    document_number.first.to_i
  end

  def gender
    if [1, 3, 5, 7].include?(gender_digit)
      return 'male'
    elsif [2, 4, 6, 8].include?(gender_digit)
      return 'female'
    end

    errors.add(:document_number, I18n.t("errors.messages.invalid"))
  end

  def is_number? string
    true if Float(string) rescue false
  end

  private

    def retrieve_census_data
      @census_data = CensusCaller.new.call(document_type, document_number, date_of_birth, postal_code)
    end

    def residency_valid?
      residence_tos.valid?
    end

    def clean_document_number
      self.document_number = document_number.gsub(/[^a-z0-9]+/i, "").upcase if document_number.present?
    end
end
