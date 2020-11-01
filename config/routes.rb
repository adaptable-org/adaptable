# frozen_string_literal: true

Rails.application.routes.draw do
  root 'landing#soon'

  get 'home', to: 'landing#soon', as: :home
  get 'confirm', to: 'landing#confirm', as: :confirm

  # Static Content Pages
  get 'about', to: 'prose#about', as: :about_page
  get 'privacy', to: 'prose#privacy', as: :privacy_page
  get 'terms', to: 'prose#terms', as: :terms_page
  get 'security', to: 'prose#security', as: :security_page
  get 'accessibility', to: 'prose#accessibility', as: :accessibility_page
  get 'contact', to: 'prose#contact', as: :contact_page
end
