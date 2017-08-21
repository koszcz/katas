require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].name).to eq 'foo'
    end

    it 'decreases sell_in' do
      items = [Item.new('foo', 10, 10)]
      GildedRose.new(items).update_quality
      expect(items[0].sell_in).to eq 9
    end

    it 'decreses quality twice as fast after sell_in time was missed' do
      items = [Item.new('foo', 0, 10)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 8
    end

    it 'quality does not go below 0' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 0
    end

    it 'item named Aged Brie increases in Quality the older it gets' do
      items = [Item.new('Aged Brie', 10, 10)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 11
      expect(items[0].sell_in).to eq 9
    end

    it 'The Quality of an item is never more than 50' do
      items = [Item.new('Aged Brie', 10, 50)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 50
    end

    it 'item named "Sulfuras, Hand of Ragnaros" never has to be sold or decreases in Quality' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 10, 10)]
      GildedRose.new(items).update_quality
      expect(items[0].quality).to eq 10
      expect(items[0].sell_in).to eq 10
    end

    describe 'item named Backstage passes increases in Quality when SellIn value approaches' do
      it 'increases by 2 when there are 10 days or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 12
      end

      it 'increases by 3 when there are 5 days or less' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 13
      end

      it 'drops to 0 after the concert' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10)]
        GildedRose.new(items).update_quality
        expect(items[0].quality).to eq 0
      end
    end
  end
end
