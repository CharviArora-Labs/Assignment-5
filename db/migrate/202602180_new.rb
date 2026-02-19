class AddMissingIndexesToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_index :appointments, :scheduled_at
    add_index :appointments, [:patient_id, :scheduled_at]
  end
end
