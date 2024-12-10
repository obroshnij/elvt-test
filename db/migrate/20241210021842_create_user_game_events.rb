class CreateUserGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :user_game_events do |t|
      t.references :user, null: false
      t.references :game, null: false
      t.datetime :occured_at, null: false
      t.string :game_event_type, null: false
      t.timestamps
    end

    add_index :user_game_events, :game_event_type
  end
end
