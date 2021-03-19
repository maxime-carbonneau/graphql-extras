module GraphQL
  module Extras
    class PreloadSource < GraphQL::Dataloader::Source
      def initialize(preload)
        @preload = preload
      end

      def fetch(records)
        preloader = ActiveRecord::Associations::Preloader.new
        preloader.preload(records, @preload)
        records
      end
    end

    module Preload
      # @override
      def initialize(*args, preload: nil, **opts, &block)
        @preload = preload
        super(*args, **opts, &block)
      end

      # @override
      def resolve(object, args, context)
        if @preload
          loader = context.dataloader.with(PreloadSource, @preload)
          loader.load(object.object)
        end

        super
      end
    end
  end
end
