desc "Run puppet-lint"
task :lint do
  sh "bundle exec puppet-lint --no-autoloader_layout-check --no-documentation-check --no-names_containing_dash-check --with-filename manifests/**/*.pp files/**/*.pp" rescue nil
end
