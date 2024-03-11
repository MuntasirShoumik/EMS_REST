class BackupWorkerJob
  include Sidekiq::Worker

  def perform(*args)

    if BlacklistedToken.all.count > 0
      puts "backup running .....AT: #{Time.zone.now}"

      blacklisted_tokens = BlacklistedToken.all
  
  
      blacklisted_tokens.each do |blacklisted_token|
      Archive.create(token: blacklisted_token.token, created_at: blacklisted_token.created_at, updated_at: blacklisted_token.updated_at)
      end
  
      BlacklistedToken.destroy_all
    else
        puts "No data to backup.....AT: #{Time.zone.now}"
    end

  end
end
