class ContactMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def send_contact(contact)
    @contact = contact
    mail(to: "admin@example.com", subject: "新しいお問い合わせ")
  end
end
