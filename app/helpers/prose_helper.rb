# frozen_string_literal: true

module ProseHelper
  def markdown(content)
    renderer = ::Redcarpet::Render::HTML.new
    markdown = ::Redcarpet::Markdown.new(renderer, {})

    markdown.render(content).html_safe
  end
end
