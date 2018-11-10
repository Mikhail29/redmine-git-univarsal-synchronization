require 'redmine'

Redmine::Plugin.register :gituniversalsync do
  name 'Redmine Git Univarsal Synchronization'
  author 'MM Web Studio'
  description 'This plugin sync local repozitories with remote automatic on notify from remote git repository(it\'s works with bitbucket, gitlab.com and other where work webhooks)'
  version '1.0.0'
  url 'https://rm.mmwebstudio.pp.ua/projects/redmine-git-univarsal-synchronization'
  author_url 'https://mmwebstudio.pp.ua/'
  requires_redmine :version_or_higher => '3.4.5'

  settings :default => { :prune => 'yes', :auto_create => 'yes' }, :partial => 'settings/gituniversalsync_settings'
end