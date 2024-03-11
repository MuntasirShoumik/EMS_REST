module JwtHelper
  SECRET_KEY = 'HHEYHDJUE7747HD'

  ACCESS_TOKEN_EXPIRATION = 1.hour

  REFRESH_TOKEN_EXPIRATION = 30.days

  def encode_access_token(payload)
    payload[:exp] = ACCESS_TOKEN_EXPIRATION.from_now.to_i

    JWT.encode(payload, SECRET_KEY, 'HS256')
  end



  def encode_refresh_token(payload)
    payload[:exp] = REFRESH_TOKEN_EXPIRATION.from_now.to_i

    JWT.encode(payload, SECRET_KEY, 'HS256')
  end



  def decode_token(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256')[0]
  end



  def blacklist_tokens
    token = request.headers['Authorization'].split(' ')

    return false unless token[0] && token[1]

    BlacklistedToken.create(token: token[0])

    BlacklistedToken.create(token: token[1])

    true
  end



  def token_blacklisted?(token)
    BlacklistedToken.exists?(token: token)
  end

  def token_expired?(token)
    begin
      decode_token(token)
    rescue JWT::ExpiredSignature
      true
    else
      false
    end

  end

 

  def current_user(user = "" )
    return unless request.headers['Authorization']

    token = request.headers['Authorization'].split(' ').last

    return nil if token.nil? || token_blacklisted?(token) || token_expired?(token)

    id = decode_token(token)['id']

    @current_user ||= user.find_by(id: id)
  end



  def refresh_access_token(refresh_token, model)
    return false if refresh_token.nil? || token_blacklisted?(refresh_token) || token_expired?(refresh_token)

    id = decode_token(refresh_token)['id']

    user = model.find_by(id: id)

    return false unless user

    encode_access_token(id: user.id)
  end


end
