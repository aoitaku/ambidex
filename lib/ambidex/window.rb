require 'forwardable'
require 'opal-pixi'

require_relative 'pixi/ticker'
require_relative 'input'

module Ambidex
  module Window

    module ScaleMode
      NEAREST_NEIGHBOR = Native(`PIXI.SCALE_MODES.NEAREST`)
      BILINEAR = Native(`PIXI.SCALE_MODES.LINEAR`)
    end

    class Instance

      attr_accessor :width, :height, :bgcolor, :antialias, :transparent, :view_id

      def initialize
        @width = 640
        @height = 480
        @bgcolor = 0x000000
        @antialias = false
        @transparent = false
        @view_id = 'view'
      end

      def create
        @renderer = PIXI::WebGLRenderer.new(@width, @height, {
          antialias: @antialias,
          backgroundColor: @bgcolor,
          transparent: @transparent
        })
        doc = Native(`window.document`)
        doc.getElementById(@view_id).appendChild(@renderer.view)
      end

      def draw(drawable)
        @renderer.render(drawable)
      end

    end
    private_constant :Instance

    class << self

      extend Forwardable

      def_delegators :instance,
        :draw,
        :width,
        :width=,
        :height,
        :height=,
        :bgcolor,
        :bgcolor=,
        :antialias,
        :antialias=,
        :transparent,
        :transparent=

      def instance
        @instance ||= Instance.new
      end
      private :instance

      def loop(&block)
        instance.create
        PIXI.shared_ticker.add(-> delta_time {
          Input.update
          block.call(delta_time)
        }, self)
      end

      def scale_mode=(mode)
        `PIXI.settings.SCALE_MODE = mode`
      end

    end

  end
end
