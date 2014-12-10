class MediaType < Struct.new(:type, :tree, :subtype, :suffix, :parameters)
  VERSION = "1.0.0"
  MATCHER = /\A([^\/]+)\/(?:([^\.\+;]+)\.)?([^\s\+;]+)(?:\+([^\s;]+))?\s*(?:;(.*))?\Z/

  def initialize(*args)
    if args.length == 1 && (hash = args.first).is_a?(Hash)
      symbolized_hash = hash.map { |k, v| [k.to_sym, v] }.to_h
      super(*symbolized_hash.values_at(*self.class.members))
    else
      super
    end
  end

  def self.parse(string, parse_parameters: true)
    components = string.match(MATCHER)[1..-1]
    if parse_parameters
      components[-1] = parse_params(components[-1])
    end
    new(*components)
  end

  def self.parse_params(string)
    return nil if string.nil?
    components = string.split(/(?<!\\)"/) # seperate quoted strings
    components.map!.with_index do |element, i|
      if i.even? # not inside a quoted string
        element.split(?;).
                map(&:strip).
                reject(&:empty?).
                map { |s| s.split(?=).map(&:strip) } # seperate keys and values
      else # inside a quoted string
        element.gsub(/\\(.)/, '\1') # remove escapes
      end
    end
    components.flatten! # now 1D array of strings, alternating key/value
    components.each_slice(2).to_h
  end

  def self.encode_params(params)
    params.map do |key, value|
      value = %("#{value.gsub(?", '\"')}") if value[/["\s]/]
      "#{key}=#{value}"
    end.join("; ")
  end

  def to_s
    string = "#{type}/"
    string << "#{tree}." if tree
    string << subtype
    string << "+#{suffix}" if suffix
    string << "; #{string_parameters.gsub(/\A\s+/, "")}" if parameters
    string
  end

  def inspect
    "#<#{self.class}:#{to_s}>"
  end

  def ==(other)
    return false unless other.kind_of? MediaType
    [self, other].map do |type|
      hash = type.to_h
      hash[:parameters] &&= type.parsed_parameters
      hash
    end.inject(:==)
  end

  def string_parameters
    parameters.is_a?(Hash) ? self.class.encode_params(parameters) : parameters
  end

  def parsed_parameters
    parameters.is_a?(Hash) ? parameters : self.class.parse_params(parameters)
  end
end
