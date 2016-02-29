class ResyncRunner < JobRunner


  def self.instance_for(job)
    if job.job_type == "resync_job"
      self.new(job)
    else
      nil
    end
  end

  def resync( ao )
    ao.children.each_with_index do |child, i|
     resync(child) if child.has_children?
     @job.write_output( "Processing #{child.id}" ) 
     child.update_position_only(child.parent_id, i)
    end
  end

  def run
    super

    job_data = @json.job
    parsed = JSONModel.parse_reference(job_data['ref'])
    target = Resource.any_repo[parsed[:id]]


    begin
      DB.open( DB.supports_mvcc?, 
             :retry_on_optimistic_locking_fail => true ) do
        begin
          RequestContext.open( :current_username => @job.owner.username,
                              :repo_id => @job.repo_id) do  
            @job.write_output( "Starting resource #{target.id}" ) 
             
            $stderr.puts "1" * 100 
            $stderr.puts target.children.inspect 
            $stderr.puts "1" * 100 
            target.children.each do |ao|
              resync(ao) 
            end
            @job.write_output( "Finishing #{target.id}" ) 
          end 
        rescue Exception => e
          terminal_error = e
          raise Sequel::Rollback
        end
      end
    
    rescue
      terminal_error = $!
    end
 
    if terminal_error
      @job.write_output(terminal_error.message)
      @job.write_output(terminal_error.backtrace)
      
      raise terminal_error
    end
  
  end



end
