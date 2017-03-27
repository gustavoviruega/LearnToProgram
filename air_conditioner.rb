class AirConditioner
  attr_reader :temperature
  attr_reader :status

  def initialize
    @temperature = 24
    @status = 'OFF'
  end

  def temperature=(value)
    @temperature = value.to_i
    p 'Air conditioner set to: ' + @temperature.to_s
  end

  def turn_on
    p 'Air conditioner turned on'
    @status = 'ON'
    return "The Air Conditioner is ON"
  end

  def turn_off
    p 'Air conditioner turned off'
    @status = 'OFF'
    return "The Air Conditioner is OFF"
  end
end
