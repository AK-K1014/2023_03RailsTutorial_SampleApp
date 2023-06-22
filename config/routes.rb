Rails.application.routes.draw do
  get 'static_pages/hom'
  get 'static_pages/help'
root "application#hello"
end
