namespace :tasks do
  desc "Mark tasks as overdue if due date has passed"
  task mark_overdue: :environment do
    overdue_status = Status.find_by(name: 'overdue')

    if overdue_status.nil?
      puts "❌ 'overdue' status not found. Please check your statuses table."
      next
    end

    tasks_to_update = Task.where('due_date < ?', Date.today)
                          .where.not(status_id: overdue_status.id)

    count = tasks_to_update.update_all(status_id: overdue_status.id)

    puts "✅ #{count} task(s) marked as overdue."
  end
end
