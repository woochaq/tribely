# Patch: https://github.com/heartcombo/devise/pull/5728#issuecomment-3172898187
Rails.application.config.to_prepare do
  options = {
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations",
      passwords: "users/passwords",
      confirmations: "users/confirmations"
    }
  }

  Devise.add_mapping(:user, options)
  Devise.configure_warden!
end
