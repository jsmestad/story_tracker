namespace :maintenance do
  desc "Send out daily summary emails"
  task :deliver_daily_emails => :environment do
    start_timestamp = Time.now
    puts "#{start_timestamp} -- Beginning sending of daily emails"
    User.where('email_address IS NOT NULL').each do |user|
      UserMailer.daily_summary(user).deliver_now
    end
    puts "#{start_timestamp} -- Finish sending of daily emails"
  end

  desc "Cleanup stale sessions (optional ENV[\"BEFORE_DATE\"] = yyyy/mm/dd)"
  task :clear_stale_sessions => :environment do
    before_date = ENV["BEFORE_DATE"] || 1.week.ago

    start_timestamp = Time.now

    if Rails.env.production?
      puts "#{start_timestamp} -- Beginning deleting of stale sessions before #{before_date}..."
    else
      Rails.logger.info "#{start_timestamp} -- Beginning deleting of stale sessions before #{before_date}..."
    end

    deleted_session_count = ActiveRecord::SessionStore::Session.delete_all(["updated_at <= ?", before_date])

    finished_timestamp = Time.now

    current_session_count = ActiveRecord::SessionStore::Session.count

    if Rails.env.production?
      puts "#{Time.now} -- Finished deleting of stale sessions before #{before_date} -- Deleted Sessions: #{deleted_session_count} - Current Sessions: #{current_session_count} -- Time: #{(finished_timestamp - start_timestamp)} seconds."
    else
      Rails.logger.info "#{Time.now} -- Finished deleting of stale sessions before #{before_date} -- Deleted Sessions: #{deleted_session_count} - Current Sessions: #{current_session_count} -- Time: #{(finished_timestamp - start_timestamp)} seconds."
    end
  end
end
