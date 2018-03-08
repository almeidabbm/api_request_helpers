require 'openssl'
require 'time'
require 'json'

# Localhost superuser token
# api_token = 'a8H0FMO0fPAiVY8fBN8FBw'
# Localhost superuser secret
# secret_key = 'fnw9N3rQJi4GlJaKj9RU8q6NOmaEIbVYPODCZZzXsjY'

puts ""
puts "------------------------------------//------------------------------------"
puts "Create a hash that contains all the parameters that you want to send"
puts "Call generate_params_with_signature with the hash as the first argument and the user_secret as the second"
puts ""
puts "Note: timestamp and nonce are automatically generated and added to params:"
puts "timestamp: (Time.now.to_f*1000).to_i\nnonce: Time.now.to_i"
puts "------------------------------------//------------------------------------"
puts ""

# Order the nested params
def generate_params_with_signature(params, user_secret)
  params[:nonce] = Time.now.to_i
  params[:timestamp] = (Time.now.to_f*1000).to_i
  signature = OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new('sha256'),
                  user_secret,
                  params.keys.sort.map{|key|
                  "#{key}=#{params[key]}"}.join("?"))
  params[:signature] = signature
  return params
end
