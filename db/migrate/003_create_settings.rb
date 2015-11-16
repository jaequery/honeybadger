Sequel.migration do
  up do
    create_table :settings do
      primary_key :id
      String :name
      String :value
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :settings
  end
end
