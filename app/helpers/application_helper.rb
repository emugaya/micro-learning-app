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

  def validate_access(received_method, request_path_info)
    methods = %i[post patch delete]
    check_admin_auth if (methods.include? received_method) || (request_path_info == '/new')
  end
end
