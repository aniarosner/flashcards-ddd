module TestAggregateRoot
  MissingStreamNameMethod = Class.new(StandardError)
  MissingApplyStrategyMethod = Class.new(StandardError)
  MissingEventStoreVariable = Class.new(StandardError)

  def build_state
    check_event_store_variable_presence
    check_stream_name_method_presence
    check_apply_strategy_method_presence

    @event_store.read.stream(stream_name).each { |event| apply_strategy(event) }
  end

  def apply(event)
    apply_strategy(event)
    store(event)
  end

  def store(event)
    past_events_size = @event_store.read.stream(stream_name).to_a.size
    last_stored_event_version = past_events_size - 1

    @event_store.publish(
      event, stream_name: stream_name, expected_version: last_stored_event_version
    )
  end

  def check_stream_name_method_presence
    return if respond_to?(:stream_name)

    raise MissingStreamNameMethod.new("Method stream_name is missing in #{self.class.name} aggregate.")
  end

  def check_apply_strategy_method_presence
    return if respond_to?(:apply_strategy)

    raise MissingApplyStrategyMethod.new("Method apply_strategy is missing in #{self.class.name} aggregate.")
  end

  def check_event_store_variable_presence
    return unless defined?(@event_store).nil?

    raise MissingEventStoreVariable.new("Instance variable event_store is missing in #{self.class.name} aggregate.")
  end
end
