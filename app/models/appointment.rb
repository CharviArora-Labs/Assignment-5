class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :provider

  validates :scheduled_at, presence: true
  validate :scheduled_at_not_in_past
  validate :patient_cannot_have_overlapping_appointment
  validate :provider_cannot_have_overlapping_appointment

  private

  # Prevent appointments in the past
  def scheduled_at_not_in_past
    return if scheduled_at.blank?

    if scheduled_at < Time.current
      errors.add(:scheduled_at, "cannot be in the past")
    end
  end

  # Prevent a patient from booking multiple appointments at the same time
  def patient_cannot_have_overlapping_appointment
    return if scheduled_at.blank? || patient_id.blank?

    conflict = Appointment
      .where(patient_id: patient_id, scheduled_at: scheduled_at)
      .where.not(id: id)
      .exists?

    if conflict
      errors.add(:base, "Patient already has an appointment at this time")
    end
  end

  # Prevent a provider from being double-booked
  def provider_cannot_have_overlapping_appointment
    return if scheduled_at.blank? || provider_id.blank?

    conflict = Appointment
      .where(provider_id: provider_id, scheduled_at: scheduled_at)
      .where.not(id: id)
      .exists?

    if conflict
      errors.add(:base, "Provider already has an appointment at this time")
    end
  end
end

