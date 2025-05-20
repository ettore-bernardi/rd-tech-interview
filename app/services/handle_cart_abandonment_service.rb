class HandleCartAbandonmentService
  def initialize(cart_id)
    @cart = Cart.find(cart_id)
  end

  def call
    delete_current_scheduled_jobs
    schedule_new_job
  end

  private

  def delete_current_scheduled_jobs
    Sidekiq::ScheduledSet.new.find_job(@cart.abandonment_job_id)&.delete if @cart.abandonment_job_id
    Sidekiq::ScheduledSet.new.find_job(@cart.deletion_job_id)&.delete if @cart.deletion_job_id
  end

  def schedule_new_job
    job_id = MarkCartAsAbandonedJob.perform_at(3.hours.from_now, @cart.id)
    @cart.update_attribute(:abandonment_job_id, job_id)
  end
end
