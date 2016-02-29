

enum = Enumeration.filter(:name => "job_type").get(:id)  

ev = EnumerationValue.filter( :enumeration_id => enum, :value => "resync_job").count

unless ev > 0 
  count = EnumerationValue.filter( :enumeration_id => enum ).count 
  EnumerationValue.insert( :enumeration_id => enum, :value => "resync_job",
   :position => count + 1, :readonly => 1 ) 
   Enumeration.broadcast_changes 
end
