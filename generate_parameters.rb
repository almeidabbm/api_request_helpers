require 'openssl'
require 'time'
require 'json'

#
# ------------------------------------//------------------------------------
# Create a hash that contains all the parameters that you want to send
# Call generate_params_with_signature with the hash as the first argument and the user_secret as the second
#
# Note: timestamp and nonce are automatically generated and added to params:
# timestamp: (Time.now.to_f*1000).to_i\nnonce: Time.now.to_i
# ------------------------------------//------------------------------------
#

# Order the nested params
def generate_params_with_signature(params, user_secret)
  params[:nonce] = Time.now.to_i
  params[:timestamp] = (Time.now.to_f*1000).to_i
  signature = OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new('sha256'),
                  user_secret,
                  params.keys.sort.map{|key|
                  "#{key}=#{params[key]}"}.join("?"))
  puts params.keys.sort.map{|key| "#{key}=#{params[key]}"}.join("?")
  params[:signature] = signature
  return params
end
