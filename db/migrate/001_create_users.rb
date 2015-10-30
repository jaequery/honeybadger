Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :name, :size => 64
      String :username
      String :password_digest
      String :email
      String :role
      String :uid
      String :provider
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :users
  end
end
