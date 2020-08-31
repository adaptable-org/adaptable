# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :load_markdown

  def about
  end

  def privacy
  end

  def terms
  end

  def security
  end

  def accessibility
  end

  def feedback
  end

  protected

    def load_markdown
      @markdown = File.read("#{Rails.root}/app/views/pages/#{action_name}.md")
    end
end
