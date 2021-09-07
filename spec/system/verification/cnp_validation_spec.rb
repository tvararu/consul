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
end
