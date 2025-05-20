class AddAbandonmentJobIdandDeletionJobIdToCart < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :abandonment_job_id, :string
    add_column :carts, :deletion_job_id, :string
  end
end
