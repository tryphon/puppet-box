desc "Run continuous integration tasks (spec, ...)"
task :ci => ["spec:clean", "syntax", "lint", :spec]
