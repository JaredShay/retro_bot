# The StoreWrapper takes a params hash, store, and a RequestParser instance.
# It is responsible for reading, writing, and deleting into a store and
# ensuring any caller doesn't need to be concerned with scoping. For any
# request it has all the information it needs to retrieve or store the correct
# information.
class StoreWrapper
  def initialize(params:, store:, request:)
    @team_id    = params.fetch('team_id')
    @channel_id = params.fetch('channel_id')
    @request    = request
    @store      = store
  end

  def add_request
    @store.sadd("#{@team_id}:#{@channel_id}:#{@request.category}", @request.item)
  end

  def get_items
    @store.smembers("#{@team_id}:#{@channel_id}:#{@request.category}")
  end

  def all_items
    items = Hash.new([])

    [:positive, :negative, :question, :change].each do |category|
      items[category] = @store.smembers("#{@team_id}:#{@channel_id}:#{category}")
    end

    items
  end

  def delete_all_items
    [:positive, :negative, :question, :change].each do |category|
      @store.del("#{@team_id}:#{@channel_id}:#{category}")
    end
  end
end
