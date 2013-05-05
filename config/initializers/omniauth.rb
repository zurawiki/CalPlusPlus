OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?

  provider :google_oauth2, '860116077399.apps.googleusercontent.com', 'AKqrSHqoLzXTAwJPJg4z-5U0', {
      :access_type => 'offline',
      :scope => 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar',
      :redirect_uri => 'http://localhost:3000/auth/google_oauth2/callback'
  }

end
