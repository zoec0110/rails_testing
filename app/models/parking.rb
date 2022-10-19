class Parking < ApplicationRecord
  validates_presence_of :parking_type, :start_at
  validates_inclusion_of :parking_type, in: ["guest", "short-term", "long-term"]

  belongs_to :user, optional: true
  validate :validate_end_at_with_amount

  def validate_end_at_with_amount
    if end_at.present? && amount.blank?
      errors.add(:amount, "有結束時間就必須有金額")
    end

    if end_at.blank? && amount.present?
      errors.add(:end_at, "有金額就必須有結束時間")
    end
  end

  # 計算停了多少分鐘
  def duration
    (end_at - start_at) / 60
  end

  def calculate_amount
    # 如果有開始時間和結束時間，則可以計算價格
    factor = user.present? ? 50 : 100
    if amount.blank? && start_at.present? && end_at.present?
      self.amount = if duration <= 60
                      200
                    else
                      200 + (((duration - 60).to_f / 30).ceil * factor)
                    end
    end
  end

  def calculate_guest_term_amount
    self.amount = if duration <= 60
                    200
                  else
                    200 + (((duration - 60).to_f / 30).ceil * 100)
                  end
  end

  def calculate_short_term_amount
    self.amount = if duration <= 60
                    200
                  else
                    200 + (((duration - 60).to_f / 30).ceil * 50)
                  end
  end

  def calculate_long_term_amount
    # TODO
  end
end
