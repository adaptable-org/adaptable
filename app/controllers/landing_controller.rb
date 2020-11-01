# frozen_string_literal: true

class LandingController < ApplicationController
  before_action :load_content

  layout 'landing'

  def soon
    @team = YAML.load_file("#{Rails.root}/app/content/about/board.yml").deep_symbolize_keys
  end

  def confirm
  end

  protected

    def load_content
      @content = File.read("#{Rails.root}/app/views/landing/#{action_name}.md")
    end
end
