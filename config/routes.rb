RedmineApp::Application.routes.draw do
  match 'git_sync_hook', :to => 'git_sync_hook#index', :via => [:get, :post]
end