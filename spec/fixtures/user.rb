class User
  def self.create_from_auth(_provider, _request, _user_hash); end

  def after_authentication(_provider, _request, _user_hash); end
end
