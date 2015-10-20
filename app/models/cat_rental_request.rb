

class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates_inclusion_of :status, in: ["PENDING", "APPROVED", "DENIED"]
  validate :overlapping_approved_requests

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

  private
    def overlapping_approved_requests
      results = overlapping_requests.select do |request|
        request.status == "APPROVED"
      end

      errors[:base] << "This cat is already rented out" unless results.empty?
    end

end
