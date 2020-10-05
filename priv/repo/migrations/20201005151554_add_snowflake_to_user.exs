defmodule ProfilePlace.Repo.Migrations.AddSnowflakeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :snowflake, :bigint
    end

    create unique_index :users, [:snowflake]
  end
end
