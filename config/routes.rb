Rails.application.routes.draw do

  # manager auth 
  post '/signup', to: 'registrations#signup'  # test writen
  post '/manager_login', to: 'sessions#manager_login'  # test writen
  delete '/manager_logout', to: 'sessions#manager_logout'  # test writen
  post '/refresh_manager_token', to: 'sessions#refresh_manager_token'
  patch '/manager_password_reset', to: 'passwords#manager_password_reset'# test writen

  # employee auth
  post '/emp_login', to: 'sessions#employee_login'  # test writen
  delete '/emp_logout', to: 'sessions#employee_logout'  # test writen
  post '/refresh_emp_token', to: 'sessions#refresh_employee_token'
  patch '/emp_password_reset', to: 'passwords#emp_password_reset'# test writen



  namespace :api do
    namespace :v1 do

      # managers operations 
      get '/all_emp', to: 'managers#index'   # test writen
      get '/employee/:id', to: 'managers#search_emp'  # test writen
      post '/create_emp', to: 'managers#create_emp'   # test writen
      delete '/destroy_emp/:id', to: 'managers#destroy_emp'  # test writen
      patch '/update_emp/:id', to: 'managers#update_emp'  # test writen
      post '/set_task/:id', to: 'managers#set_task'  # test writen
      get '/get_task', to: 'managers#get_task'  # test writen
      get '/view_requests', to: 'managers#view_requests'  # test writen
      post '/update_request/:id', to: 'managers#update_request'  # test writen


      # employee operations
      get '/assigned_tasks', to: 'employees#assigned_tasks' # test writen
      patch '/update_tsak/:id', to: 'employees#update_tsak' # test writen
      post '/req_leave', to: 'employees#request_leave'  # test writen
      get '/requests_status', to: 'employees#requests_status'  # test writen
      get '/leave_count', to:'employees#leave_count'


    end
  end
end
