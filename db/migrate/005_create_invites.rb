Sequel.migration do
  up do
    create_table :invites do
      primary_key :id
        Fixnum :user_id
        String :email      
        String :status
        DateTime :accepted_at
        DateTime :created_at
        DateTime :updated_at
        unique [:user_id, :email]
    end
  end

  down do
    drop_table :invites
  end
end
