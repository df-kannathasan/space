OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '474139535965756', '9b2b5a93f10836229cfa6d9e90d51ce1'
end
