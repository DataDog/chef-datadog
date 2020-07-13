
# rubocop:disable Lint/AssignmentInCondition
module ConfigSpecification
  # Expanding specification by loading included templates on the fly,
  # and overriding values
  class YAMLExpander
    def initialize(template_cache)
      @template_cache = template_cache
    end

    def expand(object)
      case object
      when Array
        expand_array(object)
      when Hash
        expand_hash(object)
      else
        object.dup
      end
    end

    private

    attr_reader :template_cache

    def expand_hash(object)
      # edge case to transform an empty object including a template
      # into the templated object
      if should_replace_in_place?(object)
        return apply_overrides(template_of(object), overrides: object['overrides'])
      end

      object.dup.tap do |copy|
        overrides = copy.delete('overrides')
        if template = template_of(copy, remove_reference: true)
          unless template.is_a?(Hash)
            # if the template is not a merge-able object
            # and the copy object had other keys that we would ignore
            # by returning the template directly, raise an error
            raise "Template '#{template_path}' is a #{template.class} and cannot replace hash object because keys #{copy.keys} would be lost"
          end
        end

        # expand each value of the hash
        copy.each do |key, value|
          copy[key] = expand(value)
        end

        # merge the template
        copy.merge!(template) if template

        apply_overrides(copy, overrides: overrides)
      end
    end

    def expand_array(objects)
      # edge case to include a file if an array has only one item
      if objects.size == 1 && unique_object = objects[0] && should_replace_in_place?(unique_object)
        return apply_overrides(template_of(unique_object), overrides: unique_object['overrides'])
      end

      objects.each_with_object([]) do |sub_object, copy|
        expanded_sub_object = expand(sub_object)

        if expanded_sub_object.is_a?(Array)
          copy.concat(expanded_sub_object)
        else
          copy << expanded_sub_object
        end
      end
    end

    def should_replace_in_place?(obj)
      return false unless obj.is_a?(Hash)

      # if there is not remaining keys, it means that the whole hash
      # will be replaced by the template

      keys = obj.keys
      keys == %w[template] || keys == %w[template overrides]
    end

    def template_of(object, remove_reference: false)
      template_path = remove_reference ? object.delete('template') : object['template']

      return nil unless template_path

      template_cache.fetch_template(template_path)
    end

    def apply_overrides(object, overrides: {})
      return object unless overrides

      Overrider.new(overrides).apply(object)
    end
  end
end
# rubocop:enable Lint/AssignmentInCondition
