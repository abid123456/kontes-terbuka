module ContestJobs
  extend ActiveSupport::Concern

  def prepare_jobs
    destroy_prepared_jobs
    jobs_on_contest_end
    prepare_emails
    prepare_facebook
    jobs_on_result_released if changes['result_released'] == [false, true]
    jobs_on_feedback_time_end
    backup_files
  end

  private

  def destroy_prepared_jobs
    Delayed::Job.where(queue: "contest_#{id}").destroy_all
  end

  def jobs_on_contest_end
    do_if_not_time(end_time, self, :purge_panitia)
    do_if_not_time(end_time, self, :send_most_answers)
  end

  def prepare_emails
    e = EmailNotifications.new self

    Notification.where(event: 'contest_starting').find_each do |n|
      do_if_not_time(start_time - n.seconds, e, :contest_starting, n.time_text)
    end

    Notification.where(event: 'contest_started').find_each do
      do_if_not_time(start_time, e, :contest_started)
    end

    Notification.where(event: 'contest_ending').find_each do |n|
      do_if_not_time(end_time - n.seconds, e, :contest_ending, n.time_text)
    end

    Notification.where(event: 'feedback_ending').find_each do |n|
      do_if_not_time(feedback_time - n.seconds, e, :feedback_ending,
                     n.time_text)
    end
  end

  def prepare_facebook
    f = FacebookPost.new self

    do_if_not_time(start_time - 1.day, f, :contest_starting, '24 jam')
    do_if_not_time(start_time, f, :contest_started)
    do_if_not_time(end_time - 1.day, f, :contest_ending, '24 jam')
    do_if_not_time(feedback_time - 6.hours, f, :feedback_ending, '6 jam')
  end

  def jobs_on_result_released
    EmailNotifications.new(self).delay(queue: "contest_#{id}").results_released
    FacebookPost.new(self).delay(queue: "contest_#{id}").results_released
    delay(queue: "contest_#{id}").refresh
  end

  def jobs_on_feedback_time_end
    do_if_not_time(feedback_time, self, :check_veteran)
    do_if_not_time(feedback_time, self, :award_points)
    do_if_not_time(feedback_time, self, :send_certificates)
    do_if_not_time(feedback_time, FacebookPost.new(self), :certificate_sent)
    do_if_not_time(feedback_time, self, :refresh)

    c = ContestFileBackup.new
    do_if_not_time(feedback_time, c, :backup_misc, 1)
    do_if_not_time(feedback_time, c, :backup_submissions, self, 1)
  end

  def award_points
    user_contests.processed.each do |uc|
      PointTransaction.create(point: uc.contest_points, user_id: uc.user_id,
                              description: uc.contest.to_s)
    end
    Ajat.info "award_points|id:#{id}"
  end

  def purge_panitia
    panitia_roles = [:panitia, :admin]
    panitia_ids = panitia_roles.inject([]) do |memo, item|
      memo + User.with_role(item).pluck(:id)
    end
    user_contests.where(user_id: panitia_ids).destroy_all
    Ajat.info "purge_panitia|id:#{id}"
  end

  def send_most_answers
    answers = short_problems.order(:problem_no).map do |sp|
      "No. #{sp.problem_no}: #{sp.most_answer.map(&:answer)}"
    end.join("\n")
    Mailgun.send_message to: User.with_role(:problem_admin).pluck(:email),
                         force_to_many: true, contest: self,
                         subject: 'Jawaban Terbanyak',
                         text: 'Berikut ini jawaban terbanyak di kontes ' \
                         'ini, mohon dibandingkan dan dicek ulang ' \
                         "bila jawaban aslinya beda.\n#{answers}"
  end

  def check_veteran
    users.each do |u|
      gold = 0
      u.user_contests.include_marks.each do |uc|
        gold += 1 if uc.total_mark >= uc.contest.gold_cutoff
      end

      u.add_role :veteran if gold >= 3
    end
    Ajat.info "check_veteran|id:#{id}"
  end

  def send_certificates
    full_feedback_user_contests.eligible_score.each do |uc|
      CertificateManager.new(uc).run
    end
    Ajat.info "send_certificates|id:#{id}"
  end

  def backup_files
    c = ContestFileBackup.new

    # Backup on end_time - 0, 2, 4, 6, 8, 10, 12 hours
    7.times do |i|
      do_if_not_time(end_time - (2 * i).hours, c, :backup_submissions, self)
    end

    # Backup on end_time - 1, 2, ... days until contest starts
    day = 1
    loop do
      do_if_not_time(end_time - day.days, c, :backup_submissions, self)
      day += 1
      break if end_time - day.days <= start_time
    end
  end

  def do_if_not_time(run_at, object, method, *args)
    return if Time.zone.now >= run_at
    object.delay(run_at: run_at, queue: "contest_#{id}").__send__(method, *args)
  end
end
