require 'json'

class GitSyncHookController < ActionController::Base
    skip_before_filter :verify_authenticity_token, :check_if_login_required
   def index
        if Setting.plugin_gituniversalsync['api_key'] == params[:key] 
            repository = find_repository
            p repository.inspect
            git_success = update_repository(repository)
            if git_success
                # Fetch the new changesets into Redmine
                repository.fetch_changesets
                render(:text => 'OK', :status => :ok)
            else
                render(:text => "Git command failed on repository: #{repository.identifier}!", :status => :not_acceptable)
            end

        else
            raise ActionController::RoutingError.new('Not Found')
        end
   end

    private
  
    def find_project
        identifier = get_project_identifier
        project = Project.find_by_identifier(identifier.downcase)
        raise ActiveRecord::RecordNotFound, "No project found with identifier '#{identifier}'" if project.nil?
        return project
    end
    
    def find_repository
        project = find_project
        repository_id = get_repository_identifier
        repository = project.repositories.find_by_identifier_param(repository_id)
        if repository.nil?
            if Setting.plugin_gituniversalsync['auto_create'] == 'yes'
                repository = create_repository(project)
            else
                raise TypeError, "Project '#{project.to_s}' ('#{project.identifier}') has no repository or repository not found with identifier '#{repository_id}'"
            end
        else
            unless repository.is_a?(Repository::Git)
                raise TypeError, "'#{repository_id}' is not a Git repository"
            end
        end
        return repository
    end
    
    def get_project_identifier
        identifier = params[:project_id] || params[:repository_name]
        raise ActiveRecord::RecordNotFound, 'Project identifier not specified' if identifier.nil?
        return identifier
    end
    
    def get_repository_identifier
        repo_name = get_repository_name || get_project_identifier
        return repo_name
    end
    
    def get_repository_name
        return params[:repository_name] && params[:repository_name].downcase
    end
    
    def update_repository(repository)
        Setting.plugin_gituniversalsync['prune'] == 'yes' ? prune = ' -p' : prune = ''
        command = git_command("fetch#{prune} origin", repository)
        exec(command)
    end
    
    def create_repository(project)
        logger.debug('Trying to create repository...')
        raise TypeError, 'Local repository path is not set' unless Setting.plugin_gituniversalsync['local_repositories_path'].to_s.present?

        identifier = get_repository_identifier
        remote_url = params[:repository_git_url]

        raise TypeError, 'Remote repository URL is null' unless remote_url.present?

        local_root_path = Setting.plugin_gituniversalsync['local_repositories_path']
        repo_name = get_repository_name
        local_url = File.join(local_root_path, repo_name)
        git_file = File.join(local_url, 'HEAD')

        unless File.exists?(git_file)
            FileUtils.mkdir_p(local_url)
            command = clone_repository(remote_url, local_url)
            unless exec(command)
                raise RuntimeError, "Can't clone URL #{remote_url}"
            end
        end
        repository = Repository::Git.new
        repository.identifier = identifier
        repository.url = local_url
        repository.is_default = true
        repository.project = project
        repository.save
        return repository
    end
    
    def clone_repository(remote_url, local_url)
    "git clone --mirror #{remote_url} #{local_url}"
  end
    
    def git_command(command, repository)
        "git --git-dir='#{repository.url}' #{command}"
    end
    
    def exec(command)
        logger.debug { "GitLabHook: Executing command: '#{command}'" }

        # Get a path to a temp file
        logfile = Tempfile.new('gituniversalsync_hook_exec')
        logfile.close

        success = system("#{command} > #{logfile.path} 2>&1")
        output_from_command = File.readlines(logfile.path)
        if success
            logger.debug { "GitUniversalSync: Command output: #{output_from_command.inspect}"}
        else
        logger.error { "GitUniversalSync: Command '#{command}' didn't exit properly. Full output: #{output_from_command.inspect}"}
    end
    
    def system(command)
        Kernel.system(command)
    end

    return success
  ensure
    logfile.unlink
  end
   
end
