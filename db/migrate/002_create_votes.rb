class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :topic_id
      t.integer :user_id
      t.integer :choice_id
      t.string  :irc_nick
      t.string  :face
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
