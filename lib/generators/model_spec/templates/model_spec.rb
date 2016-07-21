<% attributes = (eval class_name).new.attributes.except('id', "reset_password_token", "reset_password_sent_at", "remember_created_at", "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip", "created_at", "updated_at").keys %>

<% if attributes.include? 'encrypted_password' %>
 <% attributes[attributes.index 'encrypted_password'] = 'password' %>
<% end %>

require 'rails_helper'

RSpec.describe <%= class_name %>, type: :model do
  it "should have a valid factory" do
    <%= file_name %> = FactoryGirl.build(:<%= file_name %>)
    expect(<%= file_name %>).to be_valid
  end

  describe "Validations" do

  	<% attributes.each do |attr| %>
  		it "should ensure the presence of <%= attr %>" do
  			<%= file_name %> = FactoryGirl.build(:<%= file_name %>, <%= attr %>: nil)
  			expect(<%= file_name %>).not_to be_valid
  			expect(<%= file_name %>.errors[:<%= attr %>]).to be_present
  		end
  	<% end %>

  	<% if attributes.include? "email" %>
  		it "should ensure the uniqueness of email" do
      	<%= file_name %> = FactoryGirl.create(:<%= file_name %>)
      	new_<%= file_name %> = FactoryGirl.build(:<%= file_name %>, email: <%= file_name %>.email)
      	expect(new_<%= file_name %>).not_to be_valid
      	expect(new_<%= file_name %>.errors[:email]).to be_present
    	end
  	<% end %>
  end
end
