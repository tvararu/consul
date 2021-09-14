require "rails_helper"

describe "CNP" do
  before { create(:geozone) }

  scenario "User can verify with their CNP" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_document_number", with: "1870113780091"
    fill_in "verification_sms_phone", with: "0745123456"
    check "residence_terms_of_service"
    check "residence_adult"
    check "residence_resident"

    click_button "Verify residence"

    expect(page).to have_content "Account verified"
  end

  scenario "Admin can view a user's document number, email, and phone number" do
    document_number = "1870113780091"
    email = "foo@bar.com"
    phone_number = "0745123456"
    user = create(:user, document_number: document_number, email: email, phone_number: phone_number)
    admin = create(:administrator)
    login_as(admin.user)

    visit user_path(user)

    expect(page).to have_content document_number
    expect(page).to have_content email
    expect(page).to have_content phone_number
  end
end
