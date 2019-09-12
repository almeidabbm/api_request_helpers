require "./generate_parameters.rb"
require "net/http"
require "uri"
require "json"

#############
# Constants #
#############

# Domain to where the request is done
DOMAIN = "https://localhost.proctorexam.com:3001"

# Key used to sign the request
SECRET_KEY = "QKyW3Z7_gQfK-tmJtDF8pAH2wbryLvYgUrA8iUaPBO8"

# Key sent in the header to identify the user
API_TOKEN = "_WhA0nyQoLCpcP0qPnufNA"

# HTTP Header
HTTP_HEADER = {
  "Content-Type" => "application/json",
  "Authorization" => "Token token=#{API_TOKEN}",
  "Accept" => "application/vnd.procwise.v3"
}

######################
# Exams - Controller #
######################

# POST /exams
def create_exam(params)
  post("/api/v3/exams", params)
end

# POST /exams/:id/add_student
def add_student(params)
  post("/api/v3/exams/#{params[:id]}/add_student", params)
end

################################
# StudentSessions - Controller #
################################

# POST /exams/:exam_id/student_sessions
def create_student_session(params)
  post("/api/v3/exams/#{params[:exam_id]}/student_sessions", params)
end

#######################
# Auxiliary Functions #
#######################

def post(url_path, params)
  uri = URI.parse(DOMAIN + url_path)
  signed_params = generate_params_with_signature(params, SECRET_KEY)

  # Request objects
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  puts HTTP_HEADER
  request = Net::HTTP::Post.new(uri.request_uri, HTTP_HEADER)
  request.body = signed_params.to_json

  # Send the request
  response = http.request(request)
  puts response.body
end
