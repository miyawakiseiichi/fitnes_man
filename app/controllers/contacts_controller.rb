class ContactsController < ApplicationController
  before_action :authenticate_user! # ユーザー認証が必要
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.save
      ContactMailer.send_contact(@contact).deliver_later
      redirect_to thank_you_contacts_path
  end

  def thank_you
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
