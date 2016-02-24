Sequel.migration do
  up do
    create_table :hits do
      primary_key :id
      Fixnum :user_id
      String :ip
      DateTime :created_at
    end
  end

  down do
    drop_table :hits
  end
end
