class AddConstraintsAndIndexes < ActiveRecord::Migration[8.1]
  def change
    reversible do |direction|
      direction.up do
        add_index :patients, :email, unique: true

        change_column_null :patients, :name, false
        change_column_null :patients, :email, false

        change_column_null :providers, :name, false
        change_column_null :providers, :specialization, false

        change_column_null :appointments, :scheduled_at, false

        add_index :appointments, :scheduled_at
        add_index :appointments, [ :patient_id, :scheduled_at ]
      end

      direction.down do
        remove_index :appointments, [ :patient_id, :scheduled_at ], if_exists: true
        remove_index :appointments, :scheduled_at, if_exists: true

        change_column_null :appointments, :scheduled_at, true

        change_column_null :providers, :specialization, true
        change_column_null :providers, :name, true

        change_column_null :patients, :email, true
        change_column_null :patients, :name, true

        remove_index :patients, :email, if_exists: true
      end
    end
  end
end