module RenderApiHelper

  def render_api_error(messages, code)
    data = { errors: { code: code, details: Array.wrap(messages) } }
    render json: data, status: code
  end
  
  def render_api_message(messages, code)
    data = { message: messages, code: code}
    render json: data, status: code
  end
    
end