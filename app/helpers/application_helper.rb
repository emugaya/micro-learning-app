module ApplicationHelper
  def title(value = nil)
    @title = value if value
    @title ? "Micro Learning App:  - #{@title}" : "Micro Learning App"
  end
end