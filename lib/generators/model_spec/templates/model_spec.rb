<% klass = class_name.camelize.singularize.constantize %>

<% validations = klass.validators.group_by{|a| a.kind} %>
<% validators = validations.keys %>

<% owner_klasses = klass.reflect_on_all_associations(:belongs_to).map{|asc| asc.name.to_s} %>
<% supa_klasses = klass.reflections.collect{|a, b| {class_name: b.class_name, name: b.name.to_s, options: b.options} if b.macro==:has_many}.compact %>
<% direct_supa_klasses = klass.reflections.collect{|a, b| {class_name: b.class_name, name: b.name.to_s, options: b.options} if b.macro==:has_one}.compact %>

# TODO: maybe add one for :has_and_belongs_to_many?
# TODO: Implement insertions for existing files... why??
require 'rails_helper'

RSpec.describe <%= klass %>, type: :model do
  it "should have a valid factory" do
    <%= file_name %> = FactoryBot.build(:<%= file_name %>)
    expect(<%= file_name %>).to be_valid
  end

  describe "Validators" do

  	<% if validators.include? :presence %>
  		<% validations[:presence][0].attributes.each do |attr| %>
  			it "should ensure the presence of <%= attr %>" do
  				<%= file_name %> = FactoryBot.build(:<%= file_name %>, <%= attr %>: nil)
  				expect(<%= file_name %>).not_to be_valid
  				expect(<%= file_name %>.errors[:<%= attr %>]).to be_present
  			end
  		<% end %>
  	<% end %>

  	<% if validators.include? :uniqueness %>
  		<% validations[:uniqueness].each do |v| %>
  			<% scope = v.options[:scope] %>
	  		<% v.attributes.each do |attr| %>
		  		it "should ensure the uniqueness of <%= attr %>" do
		      	<%= file_name %> = FactoryBot.create(:<%= file_name %>)
						<% if scope %>
							new_<%= file_name %> = FactoryBot.build(:<%= file_name %>, <%= attr %>: <%= file_name %>.<%= attr %>, <%= scope %>: <%= file_name %>.<%= scope %>)
						<% else %>
		      		new_<%= file_name %> = FactoryBot.build(:<%= file_name %>, <%= attr %>: <%= file_name %>.<%= attr %>)
		      	<% end %>
		      	expect(new_<%= file_name %>).not_to be_valid
		      	expect(new_<%= file_name %>.errors[:<%= attr %>]).to be_present
		    	end
		    <% end %>
		  <% end %>
  	<% end %>
  end

  <% unless owner_klasses.empty? and supa_klasses.empty? %>

	  describe "Associations" do
	  	<% owner_klasses.each do |owner| %>
	  		it "should belong to a <%= owner %>" do
	  			<%= owner %> = FactoryBot.create(:<%= owner %>)
	  			<%= file_name %> = FactoryBot.build(:<%= file_name %>, <%= owner %>: <%= owner %>)
	  			expect(<%= file_name %>.<%= owner %>).to eq <%= owner %>
	  		end
	  	<% end %>

	  	<% supa_klasses.each do |child| %>
	  		it "should allow multiple <%= child[:name] %>" do
	  			<%= file_name %> = FactoryBot.create(:<%= file_name %>)

	  			3.times.each do |n|
	  				<%= child[:name].singularize %> = FactoryBot.create(:<%= child[:class_name].underscore %>)
	  				<%= file_name %>.<%= child[:name] %> << <%= child[:name].singularize %>
	  				<%= "#{file_name}_#{child[:name]}" %> = <%= file_name %>.<%= child[:name] %>
	  				expect(<%= "#{file_name}_#{child[:name]}" %>.count).to eq n.next
	  				expect(<%= "#{file_name}_#{child[:name]}" %>).to include <%= child[:name].singularize %>
	  			end
	  		end

	  	<% end %>
	  end
	<% end %>

	<% unless direct_supa_klasses.empty? and supa_klasses.empty? %>
		describe "Graceful Destroyal" do
			<% direct_supa_klasses.each do |d_s_k| %>
				<% next if d_s_k[:options].include? :through %>
				it "should destroy the associated <%= d_s_k[:name] %> when deleted" do
					<%= file_name %> = FactoryBot.create(:<%= file_name %>)
					<%= d_s_k[:name] %> = FactoryBot.create(:<%= d_s_k[:name] %>)
					<%= file_name %>.<%= d_s_k[:name].pluralize %> << <%= d_s_k[:name] %>

					expect{ <%= file_name %>.destroy }.to change(<%= d_s_k[:class_name].constantize %>, :count).by -1
				end
			<% end %>

			<% supa_klasses.each do |child| %>
				<% next if child[:options].include? :through %>
				it "should destroy the associated <%= child[:name] %> when deleted" do
					<%= file_name %> = FactoryBot.create(:<%= file_name %>)
					<%= file_name %>.<%= child[:name] %>.create(FactoryBot.attributes_for(:<%= child[:class_name].underscore %>))

					expect{ <%= file_name %>.destroy }.to change(<%= child[:class_name].constantize %>, :count).by -1
				end
			<% end %>
		end
	<% end %>

  describe "Behavior" do
  	pending "add some examples to #{__FILE__} for behaviours or delete the 'Behaviour' test there."
  end
end
