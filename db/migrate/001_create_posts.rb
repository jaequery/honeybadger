Sequel.migration do
  up do
    create_table :posts do
      primary_key :id
      Text :name
    end
  end

  down do
    drop_table :posts
  end
end
