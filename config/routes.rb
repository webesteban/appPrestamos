Rails.application.routes.draw do
  resources :sections
  resources :settlements
  resources :permissions
  resources :roles
  resources :clients do
    member do
      get :summary
    end
  end
  resources :loans

  resources :payments

  resources :collections

  resources :third_party_types
  resources :expense_types
  resources :statuses
  resources :payment_terms
  resources :reasons
  resources :tracks
  resources :section_permissions
  resources :users do
    collection do
      get :hierarchy
    end
  end
  resources :permission_roles, only: [:index, :create, :update]

  namespace :api do
    resources :clients, only: [:index, :show, :create, :update]
    resources :expenses, only: [:index, :show, :create, :update]
    resources :expense_types, only: [:index]
    resources :payment_terms, only: [:index]
    resources :loans, only: [:index, :show, :create, :update]
    resources :payments, only: [:index, :show, :create, :update]
    resource :session, only: [:create, :destroy]
  end

  resources :user_sessions, only: [:new, :create]
  delete 'logout', to: 'user_sessions#destroy', as: :logout
  get 'login', to: 'user_sessions#new', as: :login

  # Ruta por defecto
  root to: 'dashboards#clinic'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")

  get "dashboards/clinic"
  get "dashboards/index"
  get "dashboards/wallet"

  get "apps/calendar"
  get "apps/chat"
  get "apps/email"
  get "apps/file-manager", to: 'apps#file_manager'

  get "apps/invoice/create", to: 'apps#invoice_create'
  get "apps/invoice/details", to: 'apps#invoice_details'
  get "apps/invoice/list", to: 'apps#invoice_list'

  get "hospital/doctors/add", to: 'hospital#add_doctors'
  get "hospital/patients/add", to: 'hospital#add_patients'
  get "hospital/appointments", to: 'hospital#appointments'
  get "hospital/contacts", to: 'hospital#contacts'
  get "hospital/departments", to: 'hospital#departments'
  get "hospital/doctor/details", to: 'hospital#doctor_details'
  get "hospital/doctors", to: 'hospital#doctors'
  get "hospital/patient/details", to: 'hospital#patient_details'
  get "hospital/patients", to: 'hospital#patients'
  get "hospital/payments", to: 'hospital#payments'
  get "hospital/reviews", to: 'hospital#reviews'
  get "hospital/staffs", to: 'hospital#staffs'

  get "e-commerce/categories", to: 'e_commerce#categories'
  get "e-commerce/customers", to: 'e_commerce#customers'
  get "e-commerce/order/details", to: 'e_commerce#order_details'
  get "e-commerce/orders", to: 'e_commerce#orders'
  get "e-commerce/product/details", to: 'e_commerce#product_details'
  get "e-commerce/products", to: 'e_commerce#products'
  get "e-commerce/products/add", to: 'e_commerce#products_add'
  get "e-commerce/products/grid", to: 'e_commerce#products_grid'
  get "e-commerce/reviews", to: 'e_commerce#reviews'
  get "e-commerce/seller/details", to: 'e_commerce#seller_details'
  get "e-commerce/sellers", to: 'e_commerce#sellers'
  get "e-commerce/settings", to: 'e_commerce#settings'

  get "pages/coming-soon", to: 'pages#coming_soon'
  get "pages/faq"
  get "pages/maintenance"
  get "pages/pricing"
  get "pages/pricing-2", to: 'pages#pricing_2'
  get "pages/starter"
  get "pages/terms-conditions", to: 'pages#terms_conditions'
  get "pages/timeline"

  get "auth/2fa", to: 'auth#auth_2fa'
  get "auth/account-deactivation", to: 'auth#account_deactivation'
  get "auth/confirm-mail", to: 'auth#confirm_mail'
  get "auth/create-password", to: 'auth#create_password'
  get "auth/lock-screen", to: 'auth#lock_screen'
  get "auth/login", to: 'auth#login'
  get "auth/login-pin", to: 'auth#login_pin'
  get "auth/logout", to: 'auth#logout'
  get "auth/recover-password", to: 'auth#recover_password'
  get "auth/register", to: 'auth#register'

  get "error/400", to: 'error#error_400'
  get "error/401", to: 'error#error_401'
  get "error/403", to: 'error#error_403'
  get "error/404", to: 'error#error_404'
  get "error/404-alt", to: 'error#error_404_alt'
  get "error/408", to: 'error#error_408'
  get "error/500", to: 'error#error_500'
  get "error/501", to: 'error#error_501'
  get "error/502", to: 'error#error_502'
  get "error/service-unavailable", to: 'error#service_unavailable'

  get "email-templates/activation", to: 'email_templates#activation'
  get "email-templates/basic", to: 'email_templates#basic'
  get "email-templates/invoice", to: 'email_templates#invoice'

  get "layouts/compact", to: 'layouts_eg#compact'
  get "layouts/detached", to: 'layouts_eg#detached'
  get "layouts/full", to: 'layouts_eg#full'
  get "layouts/fullscreen", to: 'layouts_eg#fullscreen'
  get "layouts/horizontal", to: 'layouts_eg#horizontal'
  get "layouts/hover", to: 'layouts_eg#hover'
  get "layouts/icon-view", to: 'layouts_eg#icon_view'

  get "ui/accordions"
  get "ui/alerts"
  get "ui/avatars"
  get "ui/badges"
  get "ui/breadcrumb"
  get "ui/buttons"
  get "ui/cards"
  get "ui/carousel"
  get "ui/collapse"
  get "ui/dropdowns"
  get "ui/embed-video", to: 'ui#embed_video'
  get "ui/grid"
  get "ui/links"
  get "ui/list-group", to: 'ui#list_group'
  get "ui/modals"
  get "ui/notifications"
  get "ui/offcanvas"
  get "ui/pagination"
  get "ui/placeholders"
  get "ui/popovers"
  get "ui/progress"
  get "ui/ratios"
  get "ui/scrollspy"
  get "ui/spinners"
  get "ui/tabs"
  get "ui/tooltips"
  get "ui/typography"
  get "ui/utilities"

  get "extended/dragula"
  get "extended/ratings"
  get "extended/scrollbar"
  get "extended/sweet-alerts", to: "extended#sweet_alerts"

  get "icons/solar"
  get "icons/tabler"

  get "charts/area"
  get "charts/bar"
  get "charts/boxplot"
  get "charts/bubble"
  get "charts/candlestick"
  get "charts/column"
  get "charts/heatmap"
  get "charts/line"
  get "charts/mixed"
  get "charts/pie"
  get "charts/polar-area", to: "charts#polar_area"
  get "charts/radar"
  get "charts/radialbar"
  get "charts/scatter"
  get "charts/sparklines"
  get "charts/timeline"
  get "charts/treemap"

  get "forms/editors"
  get "forms/elements"
  get "forms/fileuploads"
  get "forms/inputmask"
  get "forms/layouts"
  get "forms/picker"
  get "forms/range-slider", to: "forms#range_slider"
  get "forms/select"
  get "forms/validation"
  get "forms/wizard"

  get "tables/basic"
  get "tables/gridjs"

  get "maps/google"
  get "maps/leaflet"
  get "maps/vector"
end
