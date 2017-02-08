require 'forwardable'

module Ambidex

  module Input
    @key_table = {}
    @new_keys = []
    @released_keys = []
    @old_keys = []

    class Instance

      attr_reader :x, :y, :keys, :pushed_keys, :released_keys

      def initialize
        @x = 0
        @y = 0
        @key_table = {}
        @keys = []
        @old_keys = []
        @pushed_keys = []
        @released_keys = []
        doc = Native(`window.document`)
        doc.addEventListener('keydown', -> e {
          @key_table[Native(`e.keyCode`)] = true
        }, false)
        doc.addEventListener('keyup', -> e {
          @key_table[Native(`e.keyCode`)] = false
        }, false)
      end

      def update
        @keys = @key_table.select {|*, v| v }.keys
        @pushed_keys = @keys - @old_keys
        @released_keys = @old_keys - @keys
        @old_keys = @keys
        @x =
          key_down?(K_LEFT)  ? -1 :
          key_down?(K_RIGHT) ?  1 :
          0
        @y =
          key_down?(K_UP)   ? -1 :
          key_down?(K_DOWN) ?  1 :
          0
      end

      def key_down?(key)
        !!@key_table[key]
      end

      def key_push?(key)
        @pushed_keys.include?(key)
      end

      def key_release?(key)
        @released_keys.include?(key)
      end

    end
    private_constant :Instance

    class << self

      extend Forwardable

      def_delegators :instance,
        :update,
        :x,
        :y,
        :keys,
        :pushed_keys,
        :released_keys,
        :key_down?,
        :key_push?,
        :key_release?

      def instance
        @instance ||= Instance.new
      end
      private :instance

    end

  end
end
