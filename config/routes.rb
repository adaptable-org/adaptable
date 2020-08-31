# frozen_string_literal: true

Rails.application.routes.draw do
  root 'welcome#index'

  # Static Content Pages
  get 'about', to: 'pages#about', as: :about_page
  get 'privacy', to: 'pages#privacy', as: :privacy_page
  get 'terms', to: 'pages#terms', as: :terms_page
  get 'security', to: 'pages#security', as: :security_page
  get 'accessibility', to: 'pages#accessibility', as: :accessibility_page
  get 'feedback', to: 'pages#feedback', as: :feedback_page
end
