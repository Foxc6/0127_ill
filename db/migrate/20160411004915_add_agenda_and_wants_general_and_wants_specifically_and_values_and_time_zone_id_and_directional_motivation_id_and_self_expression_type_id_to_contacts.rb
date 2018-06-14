class AddAgendaAndWantsGeneralAndWantsSpecificallyAndValuesAndTimeZoneIdAndDirectionalMotivationIdAndSelfExpressionTypeIdToContacts < ActiveRecord::Migration
  def change
  	add_column :contacts, :agenda, :text
  	add_column :contacts, :wants_general, :text
  	add_column :contacts, :wants_specifically, :text
  	add_column :contacts, :values, :text
    add_reference :contacts, :time_zone, index: true
    add_reference :contacts, :directional_motivation, index: true
    add_reference :contacts, :self_expression_type, index: true
  end
end
