require './generate_parameters.rb'
require 'net/http'
require 'uri'
require 'json'

def post_x_times(x, user, subdomain)
  # Branch 2548
  super_secret = "0mp_lRbjFcHcfrd0tP4JmF_kapmUz9oi0yKsa-82veo"
  super_key = "lTssCz38fpjC5XhjA7m5ww"

  # Localhost Bruno
  # super_secret = "Q3qcguCMwBoyLU2uk39FQ_nzMts_Jn6QNTszWXgF00g"
  # super_key = "7ylb6g4VDqDK9qFvPTpc3w"

  admin_secret = "pqe4JnGE5fIQBeR2Sw0MyFwcyd3XhdXHsRMhkx39dSo"
  admin_key = "dow4pPBKo3CUjxlBI9uVfA"

  header_superuser = {
    'Content-Type' => 'application/json',
    'Authorization' => 'Token token=' + super_key,
    'Accept' => 'application/vnd.procwise.v3'
  }

  header_admin = {
    'Content-Type' => 'application/json',
    'Authorization' => 'Token token=' + admin_key,
    'Accept' => 'application/vnd.procwise.v3'
  }

  secret = super_secret
  header = header_superuser

  if(user == "admin")
    secret = admin_secret
    header = header_admin
  end

  for i in 1..x do
    params = generate_params_with_signature(generate_random_params_create_exam, secret)
    puts params
    create_exam_post(subdomain, params, header)
  end
end

def create_exam_post(subdomain, params, header)
  uri = URI.parse("https://" + subdomain + ".proctorexam.com/api/v3/exams/")

  # Request objects
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(uri.request_uri, header)
  request.body = params.to_json

  # Send the request
  response = http.request(request)
  puts response.body
end

def generate_random_params_create_exam
  params = {
    type: 'record_review',
    name: [*('A'..'Z')].sample(8).join,
    global_proctoring: true,
    global_reviewing: true,
    duration_minutes: 60
  }
end
