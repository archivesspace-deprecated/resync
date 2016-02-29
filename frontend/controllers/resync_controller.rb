class ResyncController < ApplicationController

  set_access_control "manage_repository" => [ :index, :create]
  
  def index
    @job = JSONModel(:job).new._always_valid!
  end

  def create
    
    job_data = params['job'].reject{|k,v| k === '_resolved'} 
    job_data["repo_id"] ||= session[:repo_id] 

    job = Job.new('resync_job', JSONModel(:resync_job).from_hash( job_data ) , []) 
    upload = job.upload 
    resolver = Resolver.new(upload[:uri])
    redirect_to resolver.view_uri 

  end

end
