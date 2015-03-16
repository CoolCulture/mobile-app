class RecurringActivity < Activity
  field :name, type: String
  field :description, type: String
  field :start_time, type: String
  field :end_time, type: String
  field :schedule, type: String
  field :active, type: Boolean, default: true

  has_many :one_time_activities

  after_find :deyamlize_rule
  before_save :yamlize_rule
  validates_presence_of :name, :description, :schedule

  default_scope -> { where(active: true) }

  def rule_to_string
    IceCube::Rule.from_yaml(self.schedule).to_s if self.schedule
  end

  def generate_upcoming_events
    schedule = IceCube::Schedule.new
    rule = IceCube::Rule.from_yaml(self.schedule)
    schedule.add_recurrence_rule(rule)
    
    occurrences = schedule.occurrences(30.days.from_now)
    
    new_occurrences = occurrences.select do |occurrence|
      self.one_time_activities.where(date: occurrence.to_date).to_a.empty?
    end

    new_occurrences.map do |occurrence|
      {
        name: self.name,
        description: self.description,
        date: occurrence.to_date,
        start_time: self.start_time,
        end_time: self.end_time,
        museum_id: self.museum_id,
        recurring_activity_id: self.id
      }
    end
  end

  protected
  def deyamlize_rule
    IceCube::Rule.from_yaml(self.schedule) if self.schedule
  end

  def yamlize_rule
    self.schedule = RecurringSelect.dirty_hash_to_rule(self.schedule).to_yaml
  end
end