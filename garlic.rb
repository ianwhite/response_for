garlic do
  # requried repositories
  repo 'rails', :url => 'git://github.com/rails/rails', :local => '~/dev/vendor/rails'
  repo 'rspec', :url => 'git://github.com/dchelimsky/rspec', :local => '~/dev/vendor/rspec'
  repo 'rspec-rails', :url => 'git://github.com/dchelimsky/rspec-rails', :local => '~/dev/vendor/rspec-rails'
  repo 'response_for', :path => '.'

  # our targets
  target 'edge'
  target '2.1-stable', :branch => 'origin/2-1-stable'
  target '2.1.1', :tag => 'v2.1.2'
  target '2.2.0', :tag => 'v2.2.0'
  
  # all targets do the same thing
  all_targets do
    prepare do
      plugin 'response_for', :clone => true
      plugin 'rspec'
      plugin 'rspec-rails' do
        sh "script/generate rspec -f"
      end
    end
  
    run do
      cd "vendor/plugins/response_for" do
        sh "rake spec:rcov:verify"
      end
    end
  end
end