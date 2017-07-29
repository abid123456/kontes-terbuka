# frozen_string_literal: true

module UserContestScope
  extend ActiveSupport::Concern
  included do
    short_mark_text = 'SUM(CASE WHEN short_submissions.answer = ' \
                              'short_problems.answer THEN 1 ELSE 0 END)'
    long_mark_text = 'SUM(COALESCE(long_submissions.score, 0))'
    total_mark_text = "#{short_mark_text} + #{long_mark_text}"

    # Show both short marks and long marks. Short and long marks
    scope(:include_marks, lambda {
      joins(:short_problems)
      .joins(:long_problems)
      .group(:id)
      .select('user_contests.*, ' \
              "#{short_mark_text} AS short_mark, " \
              "#{long_mark_text} AS long_mark, " \
              "#{total_mark_text} AS total_mark")
    })

    # Show marks + award (emas/perak/perunggu)
    scope(:processed, lambda {
      include_marks.joins(:contest).select(
        "CASE WHEN #{total_mark_text} >= gold_cutoff THEN 'Emas' " \
        "WHEN #{total_mark_text} >= silver_cutoff THEN 'Perak' " \
        "WHEN #{total_mark_text} >= bronze_cutoff THEN 'Perunggu' " \
        "ELSE '' END AS award"
      ).group('contests.id')
    })

    # Given a long problem ID, this shows table of user contest id
    # + long problem marks for that long problem.
    scope(:include_long_problem_marks, lambda { |long_problem_id|
      joins('LEFT OUTER JOIN long_submissions ON ' \
            'long_submissions.user_contest_id = user_contests.id')
      .where("long_submissions.long_problem_id = #{long_problem_id}")
      .select("*, long_submissions.score AS problem_no_#{long_problem_id}")
    })

    # Given a feedback question ID, this shows table of user contest id
    # + feedback answer for that feedback question. (INNER JOIN)
    scope(:include_feedback_answers, lambda { |feedback_question_id|
      joins('LEFT OUTER JOIN feedback_answers ON ' \
            'feedback_answers.user_contest_id = user_contests.id')
      .where("feedback_answers.feedback_question_id = #{feedback_question_id}")
      .select('*, feedback_answers.answer AS ' \
              "feedback_question_no_#{feedback_question_id}")
    })

    CUTOFF_CERTIFICATE = 1
    # Add this scope to filter that has high enough score to get certificates
    scope(:eligible_score, lambda {
      having("#{total_mark_text} >= #{CUTOFF_CERTIFICATE}")
    })
  end
end
