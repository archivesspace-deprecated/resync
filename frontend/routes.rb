ArchivesSpace::Application.routes.draw do

  [AppConfig[:frontend_proxy_prefix], AppConfig[:frontend_prefix]].uniq.each do |prefix|

    scope prefix do
      match('/plugins/resync' => 'resync#index', :via => [:get])
      match('/plugins/resync/create' => 'resync#create', :via => [:post])
    end
  end
end
