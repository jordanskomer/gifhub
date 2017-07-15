module Github
  class Payload < Github::Base
    def initialize(request)
      request.body.rewind
      payload_body = request.body.read
      payload = verify_webhook_signature(payload_body, request.env["HTTP_X_HUB_SIGNATURE"])
      @payload = payload ? payload : false
    end
  end
end
