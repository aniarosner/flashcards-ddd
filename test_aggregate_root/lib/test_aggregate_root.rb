module TestAggregateRoot
  def store(event, event_store, stream_name)
    past_events_size = event_store.read.stream(stream_name).to_a.size
    last_stored_event_version = past_events_size - 1

    event_store.publish(
      event, stream_name: stream_name, expected_version: last_stored_event_version
    )
  end
end
