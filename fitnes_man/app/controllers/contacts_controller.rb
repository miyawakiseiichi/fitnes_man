class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.send_contact(@contact).deliver_now
      redirect_to thank_you_contacts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def thank_you
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
