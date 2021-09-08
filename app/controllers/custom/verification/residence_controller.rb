class Verification::ResidenceController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_verified!
  before_action :verify_lock, only: [:new, :create]
  skip_authorization_check

  def new
    @residence = Verification::Residence.new
    @sms = Verification::Sms.new
  end

  def create
    @residence = Verification::Residence.new(residence_params.merge(user: current_user))
    @sms = Verification::Sms.new(phone: params[:verification_sms][:phone], user: current_user)

    # Check validity for both objects
    # Not using just an if to force both checks
    sv = @sms.valid?
    rv = @residence.valid?

    if sv && rv
      @residence.save
      @sms.save

      redirect_to '/account', notice: t("verification.sms.update.flash.level_three.success")
    else
      render :new
    end
  end

  private

    def residence_params
      params.require(:residence).permit(:document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service, :adult, :resident, sms_attributes: [:phone])
    end
end
