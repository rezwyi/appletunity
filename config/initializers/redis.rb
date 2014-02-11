module Rails
  def self.redis
    @_redis ||= {}
    @_redis[Rails.env] ||= Redis::Namespace.new("appeltunity:#{Rails.env}", redis: Redis.new(host: 'localhost', port: '6379'))
  end
end