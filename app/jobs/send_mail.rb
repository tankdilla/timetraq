module SendMail
  @queue = :outgoing_mail

  def perform(mail)
    
    @users = User.all #put search criteria here
    
    @users.each do |user|
      UserDigestNotifier.weekly_progress_report(user).deliver #sends weekly progress report email
    end
    
  end
end