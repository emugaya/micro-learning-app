# Main Application helper
module ApplicationHelper
  def title(value = nil)
    @title = value if value
    @title ? "Jifunze:  - #{@title}" : 'Jifunze'
  end
end
