# application_helper.rb

# Defines helpers that apply across the whole application
module ApplicationHelper
  def title(value = nil)
    @title = value if value
    @title ? "Micro Learning App:  #{@title}" : 'Micro Learning App'
  end
end
