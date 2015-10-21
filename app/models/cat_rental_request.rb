

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates_inclusion_of :status, in: ["PENDING", "APPROVED", "DENIED"]
  validate :no_overlapping_requests


  belongs_to(
    :cat,
    class_name: "Cat",
    foreign_key: :cat_id,
    primary_key: :id
  )

  def overlapping_requests

    CatRentalRequest
      .select("*")
      .where(
        "cat_id = ? AND
        id != ? AND NOT

          ( ? < start_date OR
          end_date < ? )
        ", cat_id, id, end_date, start_date
      )

    # CatRentalRequest.select do |request|
    #   request.cat_id == cat_id &&
    #   request.id != id &&
    #   !(end_date < request.start_date || request.end_date < start_date)
    # end
  end

  def approve!
    raise "not pending" unless self.status == "PENDING"
    transaction do
      self.status = "APPROVED"
      self.save!

      # when we approve this request, we reject all other overlapping
      # requests for this cat.
      overlapping_pending_requests.update_all(status: 'DENIED')
    end
  end

  def approved?
    self.status == "APPROVED"
  end

  def denied?
    self.status == "DENIED"
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  private
  def assign_pending_status
    self.status ||= "PENDING"
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'PENDING'")
  end

    def no_overlapping_requests
      errors[:base] << "This cat is already rented out" unless overlapping_approved_requests.empty?
    end
end
