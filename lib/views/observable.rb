module Observable

  def observers
    @observers ||= []
  end

  def register(o)
    observers.push(o)
  end

  def unregister(o)
    observers.delete(o)
  end

  def notify_all(event)
    observers.each do |o|
      o.notify(event)
    end
  end

end

module PassthroughObservable
  include Observable

  def notify(event)
    puts "----- #{self} FORWARDING #{event.id} -----"
    notify_all(event)
  end
end
