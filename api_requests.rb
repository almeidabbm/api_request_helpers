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
SECRET_KEY = "nzkwzGzv6Zgz2dSzLJsoqgEeAi9wsEzf1de_pwbWqeU"

# Key sent in the header to identify the user
API_TOKEN = "uEUlnMmSIGVPnCyWSwOrjw"

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
def create_exam(params, number_of_requests=1)
  post("/api/v3/exams", params, number_of_requests)
end

# POST /exams/:id/add_student
def add_student(params, number_of_requests=1)
  post("/api/v3/exams/#{params[:id]}/add_student", params, number_of_requests)
end

################################
# StudentSessions - Controller #
################################

# POST /exams/:exam_id/student_sessions
def create_student_session(params, number_of_requests=1)
  post("/api/v3/exams/#{params[:exam_id]}/student_sessions", params, number_of_requests)
end

#######################
# Auxiliary Functions #
#######################

def post(url_path, params, number_of_requests)
  uri = URI.parse(DOMAIN + url_path)



  async_request(params, number_of_requests, uri)
end

def async_request(params, number_of_requests, uri)
  threads = number_of_requests.times.map do |i|
    start_thread(uri, params)
  end

  threads.each &:join
end

def start_thread(uri, params)
  Thread.new {
    # Request objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri, HTTP_HEADER)

    # Signing the params here so that every request has a different signature, nonce and timestamp
    signed_params = generate_params_with_signature(params, SECRET_KEY)
    request.body = signed_params.to_json

    response = http.request(request)

    # Writes the response to an HTML file so we can see it
    File.write("response_#{signed_params[:nonce]}.html", response.body)
  }
end
