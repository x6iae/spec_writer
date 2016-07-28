<% klass = class_name.camelize.singularize.constantize %>

<% validations = klass.validators.group_by{|a| a.kind} %>
<% validators = validations.keys %>

<% owner_klasses = klass.reflect_on_all_associations(:belongs_to).map{|asc| asc.name.to_s} %>
<% supa_klasses = klass.reflections.collect{|a, b| b.class_name.underscore if b.macro==:has_many}.compact %>
<% direct_supa_klasses = klass.reflections.collect{|a, b| b.class_name.underscore if b.macro==:has_one}.compact %>
# TODO: maybe add one for :has_and_belongs_to_many?
# TODO: All tests for has through are failing miserably
# TODO: Validations with scope ( scoped validations ) are failing

require 'rails_helper'

RSpec.describe <%= klass %>, type: :model do
  it "should have a valid factory" do
    <%= file_name %> = FactoryGirl.build(:<%= file_name %>)
    expect(<%= file_name %>).to be_valid
  end

  describe "Validators" do

  	<% if validators.include? :presence %>
  		<% validations[:presence][0].attributes.each do |attr| %>
  			it "should ensure the presence of <%= attr %>" do
  				<%= file_name %> = FactoryGirl.build(:<%= file_name %>, <%= attr %>: nil)
  				expect(<%= file_name %>).not_to be_valid
  				expect(<%= file_name %>.errors[:<%= attr %>]).to be_present
  			end
  		<% end %>
  	<% end %>

  	<% if validators.include? :uniqueness %>
  		<% validations[:uniqueness][0].attributes.each do |attr| %>
	  		it "should ensure the uniqueness of <%= attr %>" do
	      	<%= file_name %> = FactoryGirl.create(:<%= file_name %>)
	      	new_<%= file_name %> = FactoryGirl.build(:<%= file_name %>, <%= attr %>: <%= file_name %>.<%= attr %>)
	      	expect(new_<%= file_name %>).not_to be_valid
	      	expect(new_<%= file_name %>.errors[:<%= attr %>]).to be_present
	    	end
	    <% end %>
  	<% end %>
  end

  <% unless owner_klasses.empty? and supa_klasses.empty? %>

	  describe "Associations" do
	  	<% owner_klasses.each do |owner| %>
	  		it "should belong to a <%= owner %>" do
	  			<%= owner %> = FactoryGirl.create(:<%= owner %>)
	  			<%= file_name %> = FactoryGirl.build(:<%= file_name %>, <%= owner %>: <%= owner %>)
	  			expect(<%= file_name %>.<%= owner %>).to eq <%= owner %>
	  		end
	  	<% end %>

	  	<% supa_klasses.each do |child| %>
	  		it "should allow multiple <%= child.pluralize %>" do
	  			<%= file_name %> = FactoryGirl.create(:<%= file_name %>)

	  			3.times.each do |n|
	  				<%= child.singularize %> = FactoryGirl.create(:<%= child.singularize %>)
	  				<%= file_name %>.<%= child.pluralize %> << <%= child.singularize %>
	  				<%= "#{file_name}_#{child.pluralize}" %> = <%= file_name %>.<%= child.pluralize %>
	  				expect(<%= "#{file_name}_#{child.pluralize}" %>.count).to eq n.next
	  				expect(<%= "#{file_name}_#{child.pluralize}" %>).to include <%= child.singularize %>
	  			end
	  		end

	  	<% end %>
	  end
	<% end %>

	<% unless direct_supa_klasses.empty? and supa_klasses.empty? %>
		describe "Graceful Destroyal" do
			<% direct_supa_klasses.each do |d_s_k| %>
				it "should destroy the associated <%= d_s_k %> when deleted" do
					<%= file_name %> = FactoryGirl.create(:<%= file_name %>)
					<%= d_s_k %> = FactoryGirl.create(:<%= d_s_k %>)
					<%= file_name %>.<%= d_s_k.pluralize %> << <%= d_s_k %>

					expect{ <%= file_name %>.destroy }.to change(<%= d_s_k.camelize.singularize.constantize %>, :count).by -1
				end
			<% end %>

			<% supa_klasses.each do |child| %>
				it "should destroy the associated <%= child.singularize %> when deleted" do
					<%= file_name %> = FactoryGirl.create(:<%= file_name %>)
					<%= file_name %>.<%= child.pluralize %>.create(FactoryGirl.attributes_for(:<%= child.singularize %>))

					expect{ <%= file_name %>.destroy }.to change(<%= child.camelize.singularize.constantize %>, :count).by -1
				end
			<% end %>
		end
	<% end %>	

  describe "Behavior" do
  	pending "add some examples to #{__FILE__} for behaviours or delete the 'Behaviour' test here."
  end
end
