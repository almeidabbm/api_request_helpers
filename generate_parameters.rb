require 'openssl'
require 'time'
require 'json'

#
# ------------------------------------//------------------------------------
# Create a hash that contains all the parameters that you want to send
# Call generate_params_with_signature with the hash as the first argument and the user_secret as the second
#
# Note 1: The ID's in the endpoint to be requested should be in the params to be signed otherwise
# the signature will be incorrect
#
# Note 2: timestamp and nonce are automatically generated and added to params:
# timestamp: (Time.now.to_f*1000).to_i\nnonce: Time.now.to_i
# ------------------------------------//------------------------------------
#

# Sign the params
def generate_params_with_signature(params, user_secret)
  params_copy = params.clone
  params_copy[:nonce] = Time.now.to_i
  params_copy[:timestamp] = (Time.now.to_f*1000).to_i
  signature = OpenSSL::HMAC.hexdigest(
                  OpenSSL::Digest.new('sha256'),
                  user_secret,
                  params_copy.keys.sort.map{|key|
                  "#{key}=#{params_copy[key]}"}.join("?"))
  params_copy[:signature] = signature
  return params_copy
end
