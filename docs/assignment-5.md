
# Assignment 05: Data Model, Validations, and Migrations

**ILA Rails and React Engineering Certification – Level 1**
**Topic:** Domain Modeling, Validations, and Safe Migrations

---

## Objective

Design and implement a stable relational data model for:

* Patients
* Providers
* Appointments

The goal is to ensure **data correctness at both the application and database layers**, prevent invalid states, and support real-world appointment workflows.

---

## Why This Matters

Incorrect data modeling leads to:

* Silent data corruption
* Conflicting appointments
* Hard-to-debug production issues

This assignment enforces **explicit validation boundaries** so invalid data cannot enter the system—**even accidentally**.

---

## Domain Design Overview

### Entities

| Entity      | Purpose                                            |
| ----------- | -------------------------------------------------- |
| Patient     | Represents a person booking appointments           |
| Provider    | Represents a service provider (doctor, specialist) |
| Appointment | Connects a patient and provider at a specific time |

### Relationships

* A Patient has many Appointments
* A Provider has many Appointments
* An Appointment belongs to one Patient and one Provider

---

## Step 1: Create Models

### Commands Run

```bash
bin/rails generate model Patient name:string email:string
bin/rails generate model Provider name:string specialization:string
bin/rails generate model Appointment patient:references provider:references scheduled_at:datetime
```

### Outcome

* Model files created in `app/models`
* Migration files generated in `db/migrate`

---

## Step 2: Model-Level Validations

### Patient Model

```ruby
class Patient < ApplicationRecord
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
```

### Provider Model

```ruby
class Provider < ApplicationRecord
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :specialization, presence: true
end
```

### Appointment Model (Core Business Rules)

```ruby
class Appointment < ApplicationRecord
  belongs_to :patient
  belongs_to :provider

  validates :scheduled_at, presence: true
  validate :no_patient_overlap
  validate :no_provider_overlap

  private

  def no_patient_overlap
    return unless patient && scheduled_at

    if Appointment.exists?(
      patient_id: patient_id,
      scheduled_at: scheduled_at
    )
      errors.add(:scheduled_at, "Patient already has an appointment at this time")
    end
  end

  def no_provider_overlap
    return unless provider && scheduled_at

    if Appointment.exists?(
      provider_id: provider_id,
      scheduled_at: scheduled_at
    )
      errors.add(:scheduled_at, "Provider already has an appointment at this time")
    end
  end
end
```

### Why This Is in Scope

* Prevents double booking
* Enforces real-world scheduling constraints
* Correct boundary for **business rules**

---

## Step 3: Database-Level Constraints and Indexes

### Migration: AddConstraintsAndIndexes

```ruby
class AddConstraintsAndIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :patients, :email, unique: true

    change_column_null :patients, :name, false
    change_column_null :patients, :email, false

    change_column_null :providers, :name, false
    change_column_null :providers, :specialization, false

    change_column_null :appointments, :scheduled_at, false

    add_index :appointments, :scheduled_at
    add_index :appointments, [:patient_id, :scheduled_at]
    add_index :appointments, [:provider_id, :scheduled_at]
  end
end
```

### Why DB Constraints Matter

* Protects against skipped validations
* Ensures integrity even via raw SQL
* Required for production-grade systems

---

## Step 4: Run and Verify Migrations

### Commands

```bash
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:migrate
```

### Expected Result

* Migrations apply cleanly
* Rollbacks work without manual fixes
* Schema remains consistent

---

## Step 5: Console Validation Checks

### Create Valid Records

```ruby
patient = Patient.create!(
  name: "Alice Patient",
  email: "alice.patient@example.com"
)

provider_1 = Provider.create!(
  name: "Dr Smith",
  specialization: "Cardiology"
)

provider_2 = Provider.create!(
  name: "Dr Jones",
  specialization: "Dermatology"
)

time = Time.current + 1.day
```

### First Appointment (Valid)

```ruby
Appointment.create!(
  patient: patient,
  provider: provider_1,
  scheduled_at: time
)
```

### Same Patient, Same Time, Different Provider (Invalid)

```ruby
Appointment.create!(
  patient: patient,
  provider: provider_2,
  scheduled_at: time
)
```

**Expected Error**

```
Validation failed: Patient already has an appointment at this time
```

---

### Provider Overlap Check

```ruby
another_patient = Patient.create!(
  name: "Bob Patient",
  email: "bob.patient@example.com"
)

Appointment.create!(
  patient: another_patient,
  provider: provider_1,
  scheduled_at: time
)
```

**Expected Error**

```
Validation failed: Provider already has an appointment at this time
```

---

## Step 6: Verifying Table State

### Check If Tables Are Empty or Populated

```ruby
Patient.count
Provider.count
Appointment.count
```

### Inspect Records

```ruby
Patient.all
Provider.all
Appointment.all
```

---

## Common Mistakes Avoided

* ❌ Relying only on model validations
* ❌ Allowing overlapping appointments
* ❌ Missing unique index on email
* ❌ Skipping migration rollback tests

---

## What I Learned

* How to design stable relational models
* Where business logic belongs
* Why DB constraints are non-optional
* How to validate migrations safely

---

## Self-Check Answers

**1. Which constraint must exist at DB layer?**

* NOT NULL columns
* Unique email index
* Foreign key relationships

**2. How do you validate migration reversibility?**

* Run `db:rollback` and re-migrate

**3. How will this schema scale for reporting?**

* Indexed appointment lookups
* Clean relational joins
* No conflicting time slots

---

## Completion Status

✅ Invalid records rejected at model and DB levels
✅ Migrations reversible
✅ Schema supports appointment workflows
✅ Ready for review


