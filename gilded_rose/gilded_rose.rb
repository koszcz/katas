require_relative 'updaters_factory'

class GildedRose
  def initialize(items, max_quality = 50)
    @items = items
    @max_quality = max_quality
    @updaters = UpdatersFactory.new.updaters
  end

  def update_quality
    @items.each { |item| update_quality_for_item(item) }
  end

  private

  def update_quality_for_item(item)
    updater = updater_for_item(item)

    updater.update(item)
    post_validations(item)
  end

  def updater_for_item(item)
    @updaters.each { |updater| return updater if updater.matches(item) }
  end

  def post_validations(item)
    item.quality = value_between(item.quality, 0, @max_quality)
  end

  def value_between(value, min, max)
    [[value, min].max, max].min
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
