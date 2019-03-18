module Observable
  def register(o)
    @observers.push(o)
  end

  def unregister(o)
    @observers.delete(o)
  end

  def notify_all(event)
    @observers.each do |o|
      o.notify(event)
    end
  end
end
