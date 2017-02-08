module PIXI

  def self.shared_ticker
    Native(`PIXI.ticker.shared`)
  end

end
