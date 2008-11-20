# to avail youself of garlic:
#   sudo gem install ianwhite-garlic --source http://gems.github.com
#   rake garlic:all

garlic do
  # requried repositories
  repo 'rails', :url => 'git://github.com/rails/rails'
  repo 'rspec', :url => 'git://github.com/dchelimsky/rspec'
  repo 'rspec-rails', :url => 'git://github.com/dchelimsky/rspec-rails'
  repo 'response_for', :path => '.'

  # our targets
  target '2.1-stable', :branch => 'origin/2-1-stable'
  target '2.2-stable', :branch => 'origin/2-2-stable'
  
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