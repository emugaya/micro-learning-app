require 'pony'
require 'haml'
require_relative '../app/models/lesson'
require_relative '../app/models/user'
require_relative '../app/models/enrollment'

class SendLesson
  DAY = 86_400
  def self.send_daily_lesson
    enrollments = Enrollment.where(
      'next_sending_time <= :current_time AND status = :status',
      current_time: Time.now, status: 'active'
    )
    send_multiple_lessons(enrollments) if enrollments.length > 0
  end

  def self.send_multiple_lessons(enrollments)
    if enrollments.length >= 2
      length = enrollments.length
      first_half = enrollments.length / 2
      email_thread_one = Thread.new do
        send_multiple_lessons(enrollments[0, first_half])
      end
      email_thread_two = Thread.new do
        send_multiple_lessons(enrollments[first_half, (length-first_half)])
      end
      email_thread_one.join
      email_thread_two.join
    else
      send_lesson(enrollments[0])
    end
  end

  def self.send_lesson(enrollment)
    if enrollment[:next_lesson].nil?
      lesson = Lesson.find_by(course_id: enrollment[:course_id], day_id: 1)
    else
      lesson = Lesson.find_by(course_id: enrollment[:course_id],
                              day_id: enrollment[:next_lesson])
    end

    mail_recipient = User.where(id: enrollment[:user_id]).first[:email_address]
    mail_subject = "Day #{lesson[:day_id]} Lesson: #{lesson[:name]}"
    template = File.read('app/views/mail/email.haml')
    haml_engine = Haml::Engine.new(template)
    mail_template = haml_engine.render(Object.new, lesson: lesson)

    send_email(mail_recipient, mail_subject, mail_template)
    next_lesson = lesson[:day_id] + 1
    set_next_lesson(next_lesson, enrollment)
  end

  def self.set_next_lesson(next_lesson, enrollment)
    if Lesson.find_by(day_id: next_lesson, course_id: enrollment[:course_id])
      enrollment.update_attributes(
        next_sending_time. Time.now + DAY,
        status: 'active',
        next_lesson: next_lesson
      )
    else
      enrollment.update_attributes(status: 'completed')
    end
  end

  def self.send_email(mail_recipient, mail_subject, mail_template)
    Pony.mail(
      to: mail_recipient,
      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: 587,
        user_name: ENV['EMAIL_USERNAME'],
        password: ENV['EMAIL_PASSWORD'],
        authentication: ENV['EMAIL_AUTHENTICATION'],
      },
      from: 'jifunze.app@gmail.com',
      subject: mail_subject,
      html_body: mail_template
    )
  end
end
