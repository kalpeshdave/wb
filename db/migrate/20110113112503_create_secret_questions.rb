class CreateSecretQuestions < ActiveRecord::Migration
  def self.up
    create_table :secret_questions do |t|
      t.string    :question
      t.timestamps
    end
  end

  def self.down
    drop_table :secret_questions
  end
end
