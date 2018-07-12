# Main Application helper
module ApplicationHelper
  def title(value = nil)
    @title = value if value
    @title ? "Jifunze:  - #{@title}" : 'Jifunze'
  end

  def check_admin_auth
    redirect '/category' unless session[:is_admin]
  end
end
