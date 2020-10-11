# frozen_string_literal: true

module ProseHelper
  # Converts markdown to HTML
  #
  # @example
  #   markdown('*Bold*') # => '<b>Bold</b>'
  #
  # @param content [String] markdown-formatted content
  #
  # @return [String] HTML-formatted content
  def markdown(content)
    renderer = ::Redcarpet::Render::HTML.new
    markdown = ::Redcarpet::Markdown.new(renderer, {})

    markdown.render(content).html_safe
  end
end
