Sequel.migration do
  up do
    create_table :users do
      primary_key :id
      String :first_name, :size => 64
      String :last_name, :size => 64
      String :address, :size => 128
      String :address2, :size => 32
      String :city, :size => 64
      String :state, :size => 32
      String :zip, :size => 16
      String :country, :size => 2
      String :username
      String :password_digest
      String :email
      String :role
      String :uid
      String :provider
      String :refid
      String :avatar_url
      DateTime :created_at
      DateTime :updated_at
      unique [:provider, :refid]
    end
  end

  down do
    drop_table :users
  end
end
