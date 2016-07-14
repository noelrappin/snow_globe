class CreateAdminService

  def call
    email = Rails.application.secrets.admin_email
    User.find_or_create_by!(email: email) do |user|
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
    end
  end

end
