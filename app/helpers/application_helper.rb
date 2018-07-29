# Main Application helper
require 'pony'

module ApplicationHelper
  def title(value = nil)
    @title = value if value
    @title ? "Jifunze:  - #{@title}" : 'Jifunze'
  end

  def check_admin_auth
    redirect '/category' if current_user.nil?
    redirect '/category' unless current_user.is_admin?
  end

  def allow_enrol_or_withdraw(request_path)
    current_user && ((request_path.include? 'enrol') || (request_path.include? 'withdraw'))
  end

  def validate_access(received_method, request_path)
    methods = %i[post patch delete]
    unless allow_enrol_or_withdraw(request_path)
      check_admin_auth if (methods.include? received_method) || (request_path == '/new')
    end
  end

  def render_error(error_type, error = nil)
    @error = error if error
    @error[error_type.to_s][0] || '' if error
  end
end
