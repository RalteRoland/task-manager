# lib/tasks/toggle_lookup.rake

namespace :toggle do
  desc "Toggle active status of a User by email"
  task :user, [:email, :active] => :environment do |_, args|
    email = args[:email]
    new_status = args[:active] == 'true'

    if email.nil?
      puts "❌ Please provide an email. Usage: rake toggle:user['email@example.com','true']"
      next
    end

    user = User.find_by(email: email)

    if user
      user.update(active: new_status)
      puts "✅ User '#{user.name}' updated to active=#{user.active}"
    else
      puts "❌ User not found with email: #{email}"
    end
  end

  desc "Toggle active status of a Priority by name"
  task :priority, [:name, :active] => :environment do |_, args|
    name = args[:name]
    new_status = args[:active] == 'true'

    if name.nil?
      puts "❌ Provide a priority name. Example: rake toggle:priority['high','false']"
      next
    end

    priority = Priority.find_by(name: name)

    if priority
      priority.update(active: new_status)
      puts "✅ Priority '#{priority.name}' updated to active=#{priority.active}"
    else
      puts "❌ Priority not found: #{name}"
    end
  end

  desc "Toggle active status of a Status by name"
  task :status, [:name, :active] => :environment do |_, args|
    name = args[:name]
    new_status = args[:active] == 'true'

    if name.nil?
      puts "❌ Provide a status name. Example: rake toggle:status['open','false']"
      next
    end

    status = Status.find_by(name: name)

    if status
      status.update(active: new_status)
      puts "✅ Status '#{status.name}' updated to active=#{status.active}"
    else
      puts "❌ Status not found: #{name}"
    end
  end

  desc "Toggle active status of a Role by name"
  task :role, [:name, :active] => :environment do |_, args|
    name = args[:name]
    new_status = args[:active] == 'true'

    if name.nil?
      puts "❌ Provide a role name. Example: rake toggle:role['manager','true']"
      next
    end

    role = Role.find_by(name: name)

    if role
      role.update(active: new_status)
      puts "✅ Role '#{role.name}' updated to active=#{role.active}"
    else
      puts "❌ Role not found: #{name}"
    end
  end
end
