namespace :list do
  desc "List all Priorities (active and inactive)"
  task :priorities => :environment do
    puts "\n📋 Priorities:"
    Priority.all.each do |priority|
      status = priority.active? ? "✅ active" : "❌ inactive"
      puts " - #{priority.name} (#{status})"
    end
  end

  desc "List all Statuses (active and inactive)"
  task :statuses => :environment do
    puts "\n📋 Statuses:"
    Status.all.each do |status|
      s = status.active? ? "✅ active" : "❌ inactive"
      puts " - #{status.name} (#{s})"
    end
  end

  desc "List all Roles (active and inactive)"
  task :roles => :environment do
    puts "\n📋 Roles:"
    Role.all.each do |role|
      r = role.active? ? "✅ active" : "❌ inactive"
      puts " - #{role.name} (#{r})"
    end
  end
end
