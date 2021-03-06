describe FreightPlane do

  it 'should be loaded' do
    expect(FreightPlane).to be_a(Class)
  end

  it 'has a capacity that can vary from plane to plane' do
    expect { FreightPlane.new(10) }.to_not raise_error
  end

  it 'exposes its capacity' do
    plane = FreightPlane.new(10)
    expect { plane.capacity }.to_not raise_error
    expect(plane.capacity).to eq(10)
  end

  it 'does not allow capacity to be updated' do
    plane = FreightPlane.new(15)
    expect { plane.capacity = 20 }.to raise_error
    expect(plane.capacity).to eq(15)
  end

  it 'starts off with an empty freight manifest' do
    plane = FreightPlane.new(100)
    expect { plane.manifest }.to_not raise_error
    expect(plane.manifest).to eq([])
  end

  it 'has freight added to its manifest when #load_up is called' do
    plane = FreightPlane.new(50)
    freight = Object.new
    expect { plane.load_up(freight) }.to_not raise_error
    expect(plane.manifest).to include(freight)
  end

  context 'load' do

    before :each do
      @plane = FreightPlane.new(75)
      @plane.load_up(IndustrialFreight.new('i1', 500))
      @plane.load_up(IndustrialFreight.new('i2', 488))
      @plane.load_up(CommercialFreight.new('c1', 502, 5.5))
      @plane.load_up(Freight.new('g1', 333))
    end

    describe '#load_count' do

      it 'returns how many of a specific type of freight are in the manifest' do
        expect(@plane.load_count(IndustrialFreight)).to eq(2)
      end

      it 'returns the total number of freight on the manifest if no type is specified' do
        expect(@plane.load_count).to eq(4)
      end

    end

    describe '#total_load' do

      it 'returns the total weight of all the freight in the manifest' do
        expect(@plane.total_load).to eq(1823)
      end

      it 'returns 0 if there is nothing in the manifest' do
        empty_plane = FreightPlane.new(123)
        expect(empty_plane.total_load).to eq(0)
      end

    end

  end

  describe 'tracking' do

    before :each do
      @plane = FreightPlane.new(170)
    end

    it 'should be able to read and write to its @route' do
      expect(@plane.route).to be_nil
      expect { @plane.route = 1 }.to_not raise_error
      expect(@plane.route).to eq(1)
    end

    it 'should be able to read and write to its @hop' do
      expect(@plane.hop).to be_nil
      expect { @plane.hop = 1 }.to_not raise_error
      expect(@plane.hop).to eq(1)
    end

    it 'should be able to get the name of the city at its current @route and @hop' do
      @plane.route = 1
      @plane.hop = 0
      expect(@plane.current_city).to eq('Anchorage')
    end

    it 'goes to the next hop when #next_on_route is called' do
      @plane.route = 1
      @plane.hop = 0
      expect { @plane.next_on_route }.to_not raise_error
      expect(@plane.hop).to eq(1)
      expect(@plane.current_city).to eq('Vancouver')
    end

  end

end
