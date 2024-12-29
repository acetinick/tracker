module Api
  class SessionsController < Devise::SessionsController
    respond_to :json
    
    private
  
    def respond_with(resource, _opts = {})
      if resource.persisted?
        render json: {
          status: { code: 200, message: 'Logged in successfully.' },
          data: {
            user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
            jwt: request.env['warden-jwt_auth.token']
          }
        }
      else
        render json: {
          status: { code: 401, message: "Invalid email or password." }
        }, status: :unauthorized
      end
    end
  
    def respond_to_on_destroy
      if current_user
        render json: {
          status: { code: 200, message: 'Logged out successfully.' }
        }
      else
        render json: {
          status: { code: 401, message: "Couldn't find an active session." }
        }, status: :unauthorized
      end
    end
  end
end 