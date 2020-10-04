# frozen_string_literal: true

class ProseController < ApplicationController
  before_action :load_content

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

  def contact
  end

  protected

    def load_content
      @content = File.read("#{Rails.root}/app/views/prose/#{action_name}.md")
    end
end
