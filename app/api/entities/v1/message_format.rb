class MessageFormat < Grape::Entity
  expose :message do |_users, options|
    options[:message]
  end
end
